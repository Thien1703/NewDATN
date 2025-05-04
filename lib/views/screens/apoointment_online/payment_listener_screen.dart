import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/views/screens/apoointment_online/payment_success_screen.dart';
import 'package:health_care/views/screens/home/home_screens.dart';
import 'package:qr_flutter/qr_flutter.dart';
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

    final socket = WebSocketManager.getInstance(
      jwtToken: widget.jwtToken,
      userId: widget.userId.toString(),
    );

    // ✅ Thêm listener mà không ghi đè global handler
    socket.addMessageListener(_handleMessage);
  }

  @override
  void dispose() {
    // ✅ Gỡ listener khi màn hình bị hủy
    WebSocketManager.instance?.removeMessageListener(_handleMessage);
    super.dispose();
  }

  void _handleMessage(Map<String, dynamic> message) {
    if (_navigated) return;

    print('📥 Received WebSocket message: $message');

    if (message['type'] == 'PAID_APPOINTMENT') {
      final appointment = message['appointment'];
      final roomCode = appointment['roomCode'];
      final appointmentId = appointment['id'];
      print('✅ Đã nhận PAID_APPOINTMENT, roomCode: $roomCode, appointmentId: $appointmentId');

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

  Future<bool> _onWillPop() async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomeScreens()),
      (Route<dynamic> route) => false,
    );
    return Future.value(false); // Ngăn mặc định pop
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Thanh toán"),
          titleTextStyle: const TextStyle(
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: AppColors.deepBlue,
        ),
        body: Container(
          width: double.infinity,
          color: AppColors.deepBlue,
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 40),
                  const Text(
                    "Vui lòng quét mã QR này để được đặt lịch",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        QrImageView(data: widget.qrCode, size: 270),
                        const SizedBox(height: 10),
                        const Text(
                          'HUYNH MINH KHAI',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          '0974198371',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset('assets/images/anhdep.png'),
              ),
              Positioned(
                bottom: 100,
                left: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Phòng khám đa khoa FPT",
                      style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "Ứng dụng đặt khám qua phòng khám \nFPT dành cho gia đình bạn",
                      style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
