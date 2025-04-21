import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/views/screens/tools/callvideo/thanhtoan.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BookingConfirmationScreen extends StatelessWidget {
  final String doctorName;
  final String selectedPackage;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final String roomCode;

  const BookingConfirmationScreen({
    super.key,
    required this.doctorName,
    required this.selectedPackage,
    required this.selectedDate,
    required this.selectedTime,
    required this.roomCode,
  });

  @override
  Widget build(BuildContext context) {
    final fee = calculateFee(selectedPackage);
    final formattedFee =
        '${fee.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')} VND';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Xác nhận đặt lịch"),
        backgroundColor: AppColors.deepBlue,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(context, formattedFee),
            const SizedBox(height: 30),
            const Text(
              "💬 Ghi chú:",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Bạn sẽ thanh toán trực tiếp với bác sĩ trong quá trình khám.",
              style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String formattedFee) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow("👨‍⚕️ Bác sĩ", doctorName),
          _infoRow("📦 Gói khám", selectedPackage),
          _infoRow("📅 Ngày", DateFormat('dd/MM/yyyy').format(selectedDate)),
          _infoRow("⏰ Giờ", selectedTime.format(context)),
          _infoRow("💰 Phí khám", formattedFee),
          _infoRow("🏷️ Mã phòng", roomCode, isRoomCode: true),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, {bool isRoomCode = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.bold,
                color: isRoomCode ? Colors.blueAccent : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
