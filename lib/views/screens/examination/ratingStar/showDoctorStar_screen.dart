import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/models/appointment/appointment_service.dart';
import 'package:health_care/viewmodels/api/appointmentService_api.dart';
import 'package:health_care/viewmodels/api/rating_api.dart';
import 'package:health_care/views/widgets/widget_header_body.dart';

class ShowdoctorstarScreen extends StatefulWidget {
  final int appointmentId;

  const ShowdoctorstarScreen({super.key, required this.appointmentId});

  @override
  State<ShowdoctorstarScreen> createState() => _ShowdoctorstarScreenState();
}

class _ShowdoctorstarScreenState extends State<ShowdoctorstarScreen> {
  List<AppointmentService>? appointmentServices;
  bool _isSubmitting = false;

  // Map để lưu rating và comment theo serviceId
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
          final targetType =
              'DOCTOR'; // Bạn có thể điều chỉnh lại logic nếu cần

          final response = await RatingApi.writeApiRatingDoctor(
            widget.appointmentId,
            customerId,
            rating.toInt(),
            comment,
            targetType, // truyền targetType vào API
            item.employee?.id, // Đưa serviceId vào nếu cần thiết
          );
          print(response);

          if (response == null) {
            hasError = true;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    '❌ Đánh giá thất bại cho dịch vụ ${item.service?.name ?? "không rõ"}'),
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
              content: Text(
                  '❌ Lỗi gửi đánh giá cho dịch vụ ${item.service?.name ?? "không rõ"}'),
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
                        return Card(
                          margin: const EdgeInsets.all(12),
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Image.network(
                                      item.employee?.avatar ??
                                          'https://via.placeholder.com/100x100.png?text=No+Image', // Nếu employee là null, sử dụng hình ảnh mặc định
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        // Nếu có lỗi khi tải hình ảnh, hiển thị biểu tượng lỗi hoặc hình ảnh mặc định khác
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
                                    Expanded(
                                      child: Text(
                                        item.employee!.fullName,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    // Image.network(
                                    //   (item.service!.image.isNotEmpty)
                                    //       ? item.service!.image
                                    //       : 'https://via.placeholder.com/100x100.png?text=No+Image',
                                    //   width: 100,
                                    //   height: 100,
                                    //   fit: BoxFit.cover,
                                    //   errorBuilder:
                                    //       (context, error, stackTrace) {
                                    //     return Container(
                                    //       width: 100,
                                    //       height: 100,
                                    //       color: Colors.grey.shade300,
                                    //       child: const Icon(Icons.broken_image,
                                    //           size: 40, color: Colors.grey),
                                    //     );
                                    //   },
                                    // ),
                                    // const SizedBox(width: 12),
                                    // Expanded(
                                    //   child: Text(
                                    //     item.service!.name,
                                    //     style: TextStyle(
                                    //         fontWeight: FontWeight.bold),
                                    //   ),
                                    // ),
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
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: _isSubmitting
                        ? SizedBox(
                            width: 20,
                            child: const CircularProgressIndicator(),
                          )
                        : ElevatedButton(
                            onPressed: submitRatings,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.deepBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Gửi đánh giá',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                  ),
                )
              ],
            ),
    );
  }
}
