import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/models/appointment/appointment_service.dart';
import 'package:health_care/viewmodels/api/appointmentService_api.dart';
import 'package:health_care/viewmodels/api/rating_api.dart';
import 'package:health_care/views/screens/examination/ratingStar/ratingSuccessScreen.dart';
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
      if (serviceId == null) continue;

      final rating = _ratings[serviceId] ?? 0;
      final comment = _comments[serviceId] ?? '';
      final customerId = item.appointment.customer.id;

      if (rating > 0) {
        try {
          final targetType = item.service != null ? 'SERVICE' : 'EMPLOYEE';

          final response = await RatingApi.writeApiRating(
            widget.appointmentId,
            serviceId,
            customerId,
            rating.toInt(),
            comment,
            targetType,
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
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RatingSuccessScreen(),
          ));
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
          : LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 100,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      children: [
                        ...appointmentServices!.map((item) {
                          final serviceId = item.service?.id;
                          if (serviceId == null) return const SizedBox.shrink();

                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 1,
                                  spreadRadius: 1,
                                )
                              ],
                            ),
                            margin: const EdgeInsets.all(20),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColors.deepBlue,
                                            width: 2,
                                          ),
                                        ),
                                        child: ClipOval(
                                          child: Image.network(
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
                                                child: const Icon(
                                                  Icons.broken_image,
                                                  size: 40,
                                                  color: Colors.grey,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Dịch vụ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12),
                                            ),
                                            Text(
                                              item.service!.name,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  const Text(
                                    'Đánh giá sao:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15),
                                  ),
                                  const SizedBox(height: 5),
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
                                  const SizedBox(height: 15),
                                  const Text(
                                    'Viết đánh giá:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15),
                                  ),
                                  const SizedBox(height: 5),
                                  TextField(
                                    onChanged: (value) {
                                      _comments[serviceId] = value;
                                    },
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                      hintText:
                                          'Chia sẻ trải nghiệm của bạn...',
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
                        _buildSubmitButton(),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: _isSubmitting
          ? const Center(
              child: SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(),
              ),
            )
          : ElevatedButton(
              onPressed: _ratings.values.any((rating) => rating > 0)
                  ? submitRatings
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _ratings.values.any((rating) => rating > 0)
                    ? AppColors.deepBlue
                    : Colors.grey,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Center(
                child: Text(
                  'Gửi đánh giá',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
    );
  }
}
