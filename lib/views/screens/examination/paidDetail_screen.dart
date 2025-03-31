import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/models/appointment/appointment_service.dart';
import 'package:health_care/viewmodels/api/appointmentService_api.dart';
import 'package:health_care/viewmodels/api/appointment_api.dart';
import 'package:health_care/views/screens/clinic/clinic_screen.dart';
import 'package:health_care/views/screens/home/home_screens.dart';
import 'package:health_care/views/widgets/bottomSheet/showCustomer.dart';
import 'package:health_care/views/widgets/widget_header_body.dart';
import 'package:health_care/views/widgets/widget_lineBold.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PaidDetailScreen extends StatefulWidget {
  final int appointmentId;
  final String status;

  const PaidDetailScreen(
      {super.key, required this.appointmentId, required this.status});

  @override
  State<PaidDetailScreen> createState() => _PaidDetailScreenState();
}

class _PaidDetailScreenState extends State<PaidDetailScreen> {
  List<AppointmentService>? appointmentServices;
  String qrData = 'fsdfsdfsdf';

  @override
  void initState() {
    super.initState();
    fetchAppointmentServices();
  }

  void fetchAppointmentServices() async {
    appointmentServices =
        await AppointmentserviceApi.getByAppointment(widget.appointmentId);
    setState(() {});
  }

  String formatCurrency(int amount) {
    final formatter = NumberFormat("#,###", "vi_VN");
    return "${formatter.format(amount)}VNĐ";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: appointmentServices == null
          ? const Center(child: CircularProgressIndicator())
          : appointmentServices!.isEmpty
              ? const Center(child: Text("Không có dịch vụ nào"))
              : WidgetHeaderBody(
                  iconBack: true,
                  title: "Thông tin phiếu khám",
                  body: Container(
                    color: const Color(0xFFECECEC),
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  _buildClinicInfo(),
                                  _sectionTitle('Thông tin bệnh nhân'),
                                  _buildPatientInfo(),
                                  _sectionTitle('Dịch vụ đã chọn'),
                                  _buildSelectedServices(),
                                  SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                        ),
                        appointmentServices!.first.appointment.status ==
                                'CANCELLED'
                            ? _buildSelectedSelected()
                            : _buildSelectedCancel()
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildClinicInfo() {
    final appointment = appointmentServices!.first.appointment;

    return _buildContainer(
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(appointment.clinic.name,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: const [
                  Text('STT',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
                  Text('1',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.deepBlue)),
                ],
              ),
              QrImageView(data: qrData, size: 120),
            ],
          ),
          const SizedBox(height: 10),
          _buildStatusBadge(
              getStatusText(widget.status), getStatusColor(widget.status)),
          appointment.status == 'CANCELLED'
              ? Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    'Đã hủy. Lịch khám đã được hủy bởi bạn. Để được hộ trợ vui lòng liên hệ ',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              : SizedBox.shrink(),
          const WidgetLineBold(),
          _buildInfoRow(
              'Mã phiếu khám', appointment.id.toString(), Colors.black),
          _buildInfoRow('Ngày khám', appointment.date, Colors.black),
          _buildInfoRow('Giờ khám dự kiến', appointment.time, Colors.green),
        ],
      ),
    );
  }

// Hàm chuyển đổi trạng thái
  String getStatusText(String status) {
    const statusMap = {
      'PENDING': 'Đã đặt lịch',
      'CONFIRM': 'Đã xác nhận',
      'CANCELLED': 'Đã hủy'
    };
    return statusMap[status] ?? status;
  }

// Hàm lấy màu theo trạng thái
  Color getStatusColor(String status) {
    const statusColors = {
      'PENDING': Colors.green,
      'CONFIRM': AppColors.deepBlue,
      'CANCELLED': Colors.red
    };
    return statusColors[status] ?? Colors.black;
  }

  Widget _buildPatientInfo() {
    final customer = appointmentServices!.first.appointment.customer;
    return _buildContainer(
      Column(
        children: [
          _buildInfoRow('Mã bệnh nhân', customer.id.toString(), Colors.green),
          _buildInfoRow('Họ và tên', customer.fullName, Colors.black),
          _buildInfoRow('Số điện thoại', customer.phoneNumber, Colors.black),
          const WidgetLineBold(),
          InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => Showcustomer(),
              );
            },
            child: const Text('Chi tiết',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.deepBlue)),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedServices() {
    return Column(
      children: appointmentServices!.map((item) {
        return _buildContainer(
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildInfoRow(
                "Dịch vụ",
                item.service?.name ?? "Không có dịch vụ",
                Colors.black,
              ),
              _buildInfoRow(
                "Giá",
                formatCurrency(item.service?.price?.toInt() ?? 0),
                Colors.green,
              ),
              _buildInfoRow(
                "Bác sĩ",
                item.employee?.fullName ?? "Đang cập nhật",
                Colors.black,
              ),
              WidgetLineBold(),
              InkWell(
                onTap: () {},
                child: const Text('Chi tiết',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.deepBlue)),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildContainer(Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 5,
              spreadRadius: 1),
        ],
      ),
      child: child,
    );
  }

  Widget _buildInfoRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
          SizedBox(
            width: 30,
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w600, color: color),
              softWrap: true,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedSelected() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ClinicScreen(
                iconBack: true,
              ),
            ));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        width: double.infinity,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              color: AppColors.deepBlue,
              border: Border.all(color: AppColors.deepBlue, width: 1),
              borderRadius: BorderRadius.circular(10)),
          child: Text(
            'Đạt lịch khám khác',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedCancel() {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              title: Center(
                child: Text(
                  'Xác nhận hủy lịch?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              content: Text(
                'Bạn có chắc chắn muốn hủy lịch khám này không',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                _buildAlertDialog(
                    label: 'Hủy',
                    onTap: () {
                      Navigator.pop(context);
                    }),
                _buildAlertDialog(
                    label: 'Xác nhận',
                    onTap: () async {
                      bool? sussess = await AppointmentApi.getCancelAppointment(
                          appointmentServices!.first.appointment.id);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreens(),
                          ));
                      if (sussess == true) {
                        fetchAppointmentServices();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Hủy lịch thành công'),
                          backgroundColor: Colors.grey,
                        ));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Hủy lịch thất bại. Vui lòng thử lại'),
                          backgroundColor: Colors.red,
                        ));
                      }
                    },
                    colorBackground: AppColors.deepBlue,
                    colorText: Colors.white)
              ],
            );
          },
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        width: double.infinity,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 1),
              borderRadius: BorderRadius.circular(10)),
          child: Text(
            'Hủy lịch',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          CircleAvatar(
              radius: 8,
              backgroundColor: color,
              child: const Icon(Icons.check, size: 10, color: Colors.white)),
          const SizedBox(width: 6),
          Text(text,
              style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }

  Widget _buildAlertDialog(
      {required String label,
      VoidCallback? onTap,
      Color? colorBackground,
      Color? colorText}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 120,
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: colorBackground,
          border: Border.all(color: colorBackground ?? Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(color: colorText, fontSize: 15),
        ),
      ),
    );
  }
}
