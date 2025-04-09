import 'dart:async';
import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatefulWidget {
  final String email;
  final Future<String?> Function(String otp) onOtpSubmit;

  const OtpScreen({
    super.key,
    required this.email,
    required this.onOtpSubmit,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  String? errorText;
  bool isLoading = false;
  int _secondsRemaining = 30;
  Timer? _timer;

  void _startTimer() {
    _secondsRemaining = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
      }
    });
  }

  void _submitOtp() async {
    final otp = _otpController.text.trim();
    if (otp.isEmpty || otp.length < 4) {
      setState(() => errorText = "Vui lòng nhập đầy đủ mã OTP.");
      return;
    }

    setState(() {
      isLoading = true;
      errorText = null;
    });

    final result = await widget.onOtpSubmit(otp);

    if (result == null && context.mounted) {
      Navigator.pop(context, otp);
    } else {
      setState(() {
        errorText = result;
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  "Xác minh OTP",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  "Nhập mã xác minh chúng tôi gửi vào email của bạn",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ),
              const SizedBox(height: 40),

              // OTP input
              Pinput(
                controller: _otpController,
                length: 6,
                keyboardType: TextInputType.number,
                defaultPinTheme: PinTheme(
                  width: 60,
                  height: 55,
                  textStyle: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.deepBlue),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                focusedPinTheme: PinTheme(
                  width: 60,
                  height: 60,
                  textStyle: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  decoration: BoxDecoration(
                    color: AppColors.deepBlue.withOpacity(0.05),
                    border: Border.all(color: AppColors.deepBlue, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              if (errorText != null) ...[
                const SizedBox(height: 8),
                Text(
                  errorText!,
                  style: const TextStyle(color: Colors.red, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ],

              const SizedBox(height: 30),

              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _submitOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.deepBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Tiếp tục",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
              ),

              const SizedBox(height: 20),

              // Resend
              // Center(
              //   child: _secondsRemaining > 0
              //       ? Text(
              //           "Không nhận được mã? Gửi lại (${_secondsRemaining}s)",
              //           style: const TextStyle(color: Colors.grey),
              //         )
              //       : GestureDetector(
              //           onTap: () {
              //             _startTimer();
              //             // TODO: Gọi API resend OTP
              //           },
              //           child: const Text(
              //             "Gửi lại",
              //             style: TextStyle(
              //               color: Colors.green,
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //         ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
