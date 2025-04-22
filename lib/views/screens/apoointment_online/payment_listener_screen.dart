import 'package:flutter/material.dart';
import 'package:health_care/views/screens/apoointment_online/payment_success_screen.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:health_care/services/websocket/websocket_manager.dart';

class PaymentListenerScreen extends StatefulWidget {
  final String qrCode;
  final String checkoutUrl;
  final int userId;
  final String jwtToken;

  const PaymentListenerScreen({
    super.key,
    required this.qrCode,
    required this.checkoutUrl,
    required this.userId,
    required this.jwtToken,
  });

  @override
  State<PaymentListenerScreen> createState() => _PaymentListenerScreenState();
}

class _PaymentListenerScreenState extends State<PaymentListenerScreen> {
  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    WebSocketManager.getInstance(
      jwtToken: widget.jwtToken,
      userId: widget.userId.toString(),
      onMessageReceived: _handleMessage,
      onConnectionChange: (connected) => print("🟢 WebSocket: $connected"),
    ).connect();
  }

  void _handleMessage(Map<String, dynamic> message) {
    if (_navigated) return;
    if (message['type'] == 'PAID_APPOINTMENT') {
      final appointment = message['appointment'];
      final roomCode = appointment['roomCode'];
      final appointmentId = appointment['id'];

      _navigated = true;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentSuccessScreen(
            appointmentId: appointmentId,
            roomCode: roomCode,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Thanh toán")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text("Quét mã QR để thanh toán"),
            const SizedBox(height: 16),
            QrImageView(data: widget.qrCode, size: 240),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.open_in_browser),
              label: const Text("Mở link thanh toán"),
              onPressed: () async {
                final uri = Uri.parse(widget.checkoutUrl);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
