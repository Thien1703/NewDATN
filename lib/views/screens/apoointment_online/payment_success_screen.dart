import 'package:flutter/material.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final int appointmentId;
  final String roomCode;

  const PaymentSuccessScreen({
    super.key,
    required this.appointmentId,
    required this.roomCode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hoá đơn thành công")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 16),
            Text("🎉 Lịch hẹn #$appointmentId đã thanh toán thành công!"),
            const SizedBox(height: 8),
            Text("Mã phòng tư vấn của bạn là:", style: const TextStyle(fontSize: 16)),
            Text(roomCode, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
