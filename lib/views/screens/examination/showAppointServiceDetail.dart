import 'package:flutter/widgets.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/viewmodels/api/appointmentService_api.dart';
import 'package:health_care/models/appointment/appointment_service.dart'; // Import AppointmentService
import 'package:health_care/views/widgets/widget_header_body.dart';

class Showappointservicedetail extends StatefulWidget {
  const Showappointservicedetail(
      {super.key, required this.appointmentServiceId});
  final int appointmentServiceId;

  @override
  State<Showappointservicedetail> createState() =>
      _ShowappointservicedetailState();
}

class _ShowappointservicedetailState extends State<Showappointservicedetail> {
  AppointmentService?
      appointmentService; // Use AppointmentService instead of AppointmentScreen

  @override
  void initState() {
    super.initState();
    fetchAppointmentServices();
  }

  void fetchAppointmentServices() async {
    // Lấy dữ liệu AppointmentService từ API
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
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            // Hiển thị thông tin chi tiết dịch vụ nếu appointmentService có dữ liệu
            if (appointmentService != null)
              Text(
                  'Tên dịch vụ: ${appointmentService!.service?.name ?? 'dfsdf'}'),
            // Thêm các widget khác để hiển thị thông tin chi tiết từ appointmentService
          ],
        ),
      ),
    );
  }
}
