import 'dart:math';
import 'package:flutter/material.dart';
import 'package:health_care/services/local_storage_service.dart';
import 'package:health_care/views/screens/apoointment_online/appointment_online_api.dart';
import 'package:health_care/views/screens/apoointment_online/doctor_online/doctor_model.dart';
import 'package:health_care/views/screens/apoointment_online/payment_listener_screen.dart';
import 'package:intl/intl.dart';

import 'package:health_care/common/app_colors.dart';

class AppointmentOnlineScreen extends StatefulWidget {
  final Doctor doctor;

  const AppointmentOnlineScreen({super.key, required this.doctor});

  @override
  State<AppointmentOnlineScreen> createState() =>
      _AppointmentOnlineScreenState();
}

class _AppointmentOnlineScreenState extends State<AppointmentOnlineScreen> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  String generateRoomCode() {
    final random = Random();
    return random.nextInt(10000).toString().padLeft(4, '0');
  }

Future<void> bookAppointment() async {
  if (selectedDate == null || selectedTime == null) return;

  final dateStr = DateFormat('yyyy-MM-dd').format(selectedDate!);
  final timeStr =
      '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}:00';

  final customerId = await LocalStorageService.getUserId();
  final token = await LocalStorageService.getToken();

  if (customerId == null || token == null) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("❌ Không tìm thấy thông tin người dùng."),
    ));
    return;
  }

  final result = await AppointmentOnlineApi.createOnlineAppointment(
    employeeId: widget.doctor.id,
    customerId: customerId,
    date: dateStr,
    time: timeStr,
  );

  if (result != null) {
    // ✅ Điều hướng sang màn hình hiển thị QR và theo dõi thanh toán
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentListenerScreen(
          qrCode: result['qrCode'],
          checkoutUrl: result['checkoutUrl'],
          userId: customerId,
          jwtToken: token,
        ),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("❌ Đặt lịch thất bại. Vui lòng thử lại."),
    ));
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Đặt lịch với ${widget.doctor.fullName}"),
        backgroundColor: AppColors.deepBlue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 45,
              backgroundImage: NetworkImage(widget.doctor.avatar),
              onBackgroundImageError: (_, __) {},
            ),
            const SizedBox(height: 12),
            Text(
              widget.doctor.clinic.name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              widget.doctor.specialties.isNotEmpty
                  ? widget.doctor.specialties.map((e) => e.name).join(', ')
                  : "Chưa có chuyên khoa",
            ),
            const SizedBox(height: 24),

            /// Chọn ngày
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(selectedDate != null
                  ? DateFormat('dd/MM/yyyy').format(selectedDate!)
                  : "Chọn ngày khám"),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(days: 1)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                );
                if (picked != null) {
                  setState(() {
                    selectedDate = picked;
                  });
                }
              },
            ),

            /// Chọn giờ
            ListTile(
              leading: const Icon(Icons.access_time),
              title: Text(selectedTime != null
                  ? selectedTime!.format(context)
                  : "Chọn giờ khám"),
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (picked != null) {
                  setState(() {
                    selectedTime = picked;
                  });
                }
              },
            ),

            const Spacer(),

            /// Nút xác nhận
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (selectedDate != null && selectedTime != null)
                    ? bookAppointment
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.deepBlue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "Xác nhận đặt lịch",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
