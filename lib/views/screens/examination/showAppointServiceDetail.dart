import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/viewmodels/api/appointmentService_api.dart';
import 'package:health_care/models/appointment/appointment_service.dart';
import 'package:health_care/views/widgets/widget_header_body.dart';
import 'package:shimmer/shimmer.dart';

class Showappointservicedetail extends StatefulWidget {
  const Showappointservicedetail(
      {super.key, required this.appointmentServiceId});
  final int appointmentServiceId;

  @override
  State<Showappointservicedetail> createState() =>
      _ShowappointservicedetailState();
}

class _ShowappointservicedetailState extends State<Showappointservicedetail> {
  AppointmentService? appointmentService;

  @override
  void initState() {
    super.initState();
    fetchAppointmentServices();
  }

  void fetchAppointmentServices() async {
    AppointmentService? data =
        await AppointmentserviceApi.getAppointmentService(
            widget.appointmentServiceId);
    if (data != null) {
      setState(() {
        appointmentService = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WidgetHeaderBody(
      iconBack: true,
      color: AppColors.ghostWhite,
      title: 'Chi tiết dịch vụ',
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: appointmentService == null
            ? Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tiêu đề
                    Container(
                      height: 20,
                      width: 150,
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                    ),

                    // Dịch vụ
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    height: 20,
                                    width: double.infinity,
                                    color: Colors.white),
                                const SizedBox(height: 8),
                                Container(
                                    height: 16,
                                    width: 100,
                                    color: Colors.white),
                                const SizedBox(height: 8),
                                Container(
                                    height: 14,
                                    width: 120,
                                    color: Colors.white),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Tiêu đề Bác sĩ
                    Container(
                      height: 20,
                      width: 150,
                      color: Colors.white,
                      margin: const EdgeInsets.only(bottom: 10),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                            4,
                            (index) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  child: Container(
                                      height: 16,
                                      width: double.infinity,
                                      color: Colors.white),
                                )),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Tiêu đề ghi chú
                    Container(
                      height: 20,
                      width: 180,
                      color: Colors.white,
                      margin: const EdgeInsets.only(bottom: 10),
                    ),

                    Container(
                      margin: const EdgeInsets.all(16),
                      width: double.infinity,
                      height: 80,
                      color: Colors.white,
                    )
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thông tin dịch vụ
                  Text(
                    'Thông tin dịch vụ',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            appointmentService!.service?.image ?? '',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              width: 100,
                              height: 100,
                              color: Colors.grey.shade300,
                              child: Icon(Icons.image, color: Colors.grey),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                appointmentService!.service?.name ??
                                    'Tên dịch vụ không xác định',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Giá: ${appointmentService!.service?.price?.toStringAsFixed(0) ?? '...'} VNĐ',
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black87),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Trạng thái: ${appointmentService!.appointment.status}',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Thông tin bác sĩ
                  Text('Bác sĩ phụ trách',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Bác sĩ:',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(width: 75),
                            Text(
                              appointmentService!.employee?.fullName ??
                                  'Không có thông tin',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text('Chuyên khoa:'),
                            SizedBox(width: 35),
                            Text(
                              ' ${appointmentService!.employee?.specialty?.map((e) => e.name).join(', ') ?? 'Không có'}',
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text('Kinh nghiệm:'),
                            SizedBox(width: 40),
                            Text(
                                '${appointmentService!.employee?.experienceYears ?? 0} năm'),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text('Đánh giá:'),
                            SizedBox(width: 65),
                            Text(
                                '${appointmentService!.employee?.averageRating?.toStringAsFixed(1) ?? 'Chưa có'}⭐'),
                          ],
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Ghi chú bác sĩ
                  Text('Ghi chú của bác sĩ',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 5),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      appointmentService!.note?.trim().isNotEmpty == true
                          ? appointmentService!.note!
                          : 'Không có ghi chú.',
                      style: const TextStyle(fontSize: 15, height: 1.4),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
