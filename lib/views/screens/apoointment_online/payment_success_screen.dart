import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/models/appointment/appointment_service.dart';
import 'package:health_care/viewmodels/api/appointmentService_api.dart';
import 'package:health_care/views/screens/home/home_screens.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:health_care/views/screens/tools/callvideo/app_data.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final int appointmentId;
  final String roomCode;

  const PaymentSuccessScreen({
    super.key,
    required this.appointmentId,
    required this.roomCode,
  });

  @override
  _PaymentSuccessScreenState createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  List<AppointmentService>? appointmentServices;

  @override
  void initState() {
    super.initState();
    fetchAppointmentServices();
  }

  void fetchAppointmentServices() async {
    final services =
        await AppointmentserviceApi.getByAppointment(widget.appointmentId);
    setState(() {
      appointmentServices = services;
    });
  }

  String _formatDate(String rawDate) {
    try {
      final date = DateTime.parse(rawDate);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return rawDate; // fallback nếu parse lỗi
    }
  }

  @override
  Widget build(BuildContext context) {
    final appointment = appointmentServices?.first.appointment;
    final qrData = widget.appointmentId.toString();

    AppData.roomCode = widget.roomCode;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Hóa đơn thành công',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: appointment == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _buildSuccessBanner(appointment),
                        const SizedBox(height: 20),
                        _buildRoomInfo(qrData),
                        const SizedBox(height: 20),
                        _buildDoctorInfo(),
                        const SizedBox(height: 20),
                        _buildSectionTitle("Thông tin lịch hẹn"),
                        _buildRow('Mã lịch khám', appointment.id.toString()),
                        _buildRow('Ngày khám', appointment.date),
                        _buildRow('Giờ khám', appointment.time),
                        _buildRow(
                          'Chuyên khoa',
                          appointmentServices?.first.service?.specialty.name ??
                              '...',
                        ),
                        const SizedBox(height: 20),
                        _buildSectionTitle("Thông tin bệnh nhân"),
                        _buildRow('Họ và tên', appointment.customer.fullName),
                        _buildRow('Ngày sinh',
                            _formatDate(appointment.customer.birthDate)),
                        _buildRow('Giới tính', appointment.customer.gender),
                        _buildRow(
                            'Số điện thoại', appointment.customer.phoneNumber),
                      ],
                    ),
                  ),
                ),
                _buildHomeButton(context),
              ],
            ),
    );
  }

  Widget _buildSuccessBanner(
    appointment,
  ) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 35),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 25),
                  const Text(
                    'Đã đặt lịch',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        appointment.time.substring(0, 5),
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        '${appointment.date.split("-")[2]}-${appointment.date.split("-")[1]}-${appointment.date.split("-")[0]}',
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Positioned(
              left: 0,
              right: 0,
              child: Center(
                child: CircleAvatar(
                  radius: 34,
                  backgroundColor: Color.fromARGB(255, 184, 235, 189),
                  child: CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.green,
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          "🎉 Lịch hẹn #${widget.appointmentId} đã thanh toán thành công!",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          "Mã phòng tư vấn của bạn là:",
          style: TextStyle(fontSize: 16),
        ),
        Text(
          widget.roomCode,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildRoomInfo(String qrData) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.deepBlue),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Mã phòng tư vấn", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 4),
              Text(
                widget.roomCode,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          QrImageView(
            data: qrData,
            version: QrVersions.auto,
            size: 100,
            gapless: false,
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorInfo() {
    final employee = appointmentServices?.first.employee;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            employee?.avatar ?? 'https://via.placeholder.com/80',
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                employee?.qualification ?? '...',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              Text(
                employee?.fullName ?? '...',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                '${employee?.experienceYears ?? '...'} năm kinh nghiệm',
                style: const TextStyle(fontSize: 15, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 15, color: Colors.grey)),
          Flexible(
            child: Text(value,
                textAlign: TextAlign.right,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeButton(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(40, 10, 40, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Color.fromARGB(255, 201, 201, 201),
              spreadRadius: 1,
              blurRadius: 2)
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          side: const BorderSide(color: Colors.grey),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreens()),
        ),
        child: const Text(
          'Về trang chủ',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
