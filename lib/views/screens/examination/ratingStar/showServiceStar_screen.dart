import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/models/appointment/appointment_service.dart';
import 'package:health_care/viewmodels/api/appointmentService_api.dart';
import 'package:health_care/viewmodels/api/rating_api.dart';
import 'package:health_care/views/widgets/widget_header_body.dart';

class ShowservicestarScreen extends StatefulWidget {
  final int appointmentId;

  const ShowservicestarScreen({super.key, required this.appointmentId});

  @override
  State<ShowservicestarScreen> createState() => _ShowservicestarScreenState();
}

class _ShowservicestarScreenState extends State<ShowservicestarScreen> {
  List<AppointmentService>? appointmentServices;
  bool _isSubmitting = false;

  // Map to store rating and comment by serviceId
  final Map<int, double> _ratings = {};
  final Map<int, String> _comments = {};

  @override
  void initState() {
    super.initState();
    fetchAppointmentServices();
  }

  Future<void> fetchAppointmentServices() async {
    appointmentServices =
        await AppointmentserviceApi.getByAppointment(widget.appointmentId);
    setState(() {});
  }

  Future<void> submitRatings() async {
    if (appointmentServices == null || _ratings.isEmpty) return;

    setState(() {
      _isSubmitting = true;
    });

    bool hasError = false;

    for (var item in appointmentServices!) {
      final serviceId = item.service?.id;
      if (serviceId == null) continue; // Skip if serviceId is null

      final rating = _ratings[serviceId] ?? 0;
      final comment = _comments[serviceId] ?? '';
      final customerId = item.appointment.customer.id;

      if (rating > 0) {
        try {
          // Determine targetType dynamically (SERVICE or EMPLOYEE)
          final targetType = item.service != null ? 'SERVICE' : 'EMPLOYEE';

          final response = await RatingApi.writeApiRating(
            widget.appointmentId,
            serviceId,
            customerId,
            rating.toInt(),
            comment,
            targetType, // pass targetType to API
          );

          if (response == null) {
            hasError = true;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('❌ Đánh giá thất bại cho dịch vụ $serviceId.'),
                backgroundColor: Colors.red,
              ),
            );
          } else {
            debugPrint('✅ Đánh giá thành công cho serviceId $serviceId');
          }
        } catch (e) {
          hasError = true;
          debugPrint('❌ Lỗi khi gửi đánh giá cho serviceId $serviceId: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ Lỗi gửi đánh giá cho dịch vụ $serviceId.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }

    setState(() {
      _isSubmitting = false;
    });

    if (!hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎉 Đã gửi đánh giá thành công!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WidgetHeaderBody(
      iconBack: true,
      title: 'Đánh giá dịch vụ',
      color: AppColors.ghostWhite,
      body: appointmentServices == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: appointmentServices!.map((item) {
                        final serviceId = item.service?.id;
                        if (serviceId == null)
                          return SizedBox.shrink(); // Skip if no serviceId
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          margin: const EdgeInsets.all(20),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Image.network(
                                      (item.service!.image.isNotEmpty)
                                          ? item.service!.image
                                          : 'https://via.placeholder.com/100x100.png?text=No+Image',
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          width: 100,
                                          height: 100,
                                          color: Colors.grey.shade300,
                                          child: const Icon(Icons.broken_image,
                                              size: 40, color: Colors.grey),
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        item.service!.name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                const Text('Đánh giá sao:'),
                                RatingBar.builder(
                                  initialRating: _ratings[serviceId] ?? 0,
                                  minRating: 1,
                                  maxRating: 5,
                                  direction: Axis.horizontal,
                                  allowHalfRating: false,
                                  itemCount: 5,
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    setState(() {
                                      _ratings[serviceId] = rating;
                                    });
                                  },
                                ),
                                const SizedBox(height: 12),
                                const Text('Viết đánh giá:'),
                                TextField(
                                  onChanged: (value) {
                                    _comments[serviceId] = value;
                                  },
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                    hintText: 'Chia sẻ trải nghiệm của bạn...',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                      child: _isSubmitting
                          ? SizedBox(
                              width: 40, // Adjust the size of the loader
                              height: 40,
                              child: CircularProgressIndicator(
                                strokeWidth: 3, // Thicker loader
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.deepBlue,
                                ),
                              ),
                            )
                          : Container(
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              width: double
                                  .infinity, // Makes the button take up the full width of the screen

                              child: ElevatedButton(
                                onPressed: _ratings.values.any((rating) =>
                                        rating >
                                        0) // Check if any rating exists
                                    ? submitRatings
                                    : null, // Disable button if no rating
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _ratings.values
                                          .any((rating) => rating > 0)
                                      ? AppColors.deepBlue
                                      : Colors.grey, // Button color changes
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 16, // Adjust vertical padding
                                    horizontal: 32, // Adjust horizontal padding
                                  ),
                                ),
                                child: const Text(
                                  'Gửi đánh giá',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                            )),
                )
              ],
            ),
    );
  }
}
