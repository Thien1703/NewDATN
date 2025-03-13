import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:health_care/views/screens/auth/auth_service.dart'; // Đảm bảo AuthService được triển khai đúng
import 'package:health_care/views/screens/auth/register/name_screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPPopup extends StatefulWidget {
  final String verificationID; // Số điện thoại truyền từ RegisterScreen

  const OTPPopup({super.key, required this.verificationID});

  @override
  State<OTPPopup> createState() => _OTPPopupState();
}

class _OTPPopupState extends State<OTPPopup> {
  // final AuthService _authService = AuthService(); // Service xác thực OTP
  final TextEditingController smsController =
      TextEditingController(); // Bộ điều khiển cho mã OTP

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: Center(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Tiêu đề
              Text(
                'Xác thực OTP',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),

              // Mô tả
              Text(
                'Vui lòng nhập mã OTP được gửi về SĐT để đăng ký tài khoản',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 20),

              // Input mã OTP
              PinCodeTextField(
                controller: smsController,
                appContext: context,
                length: 6,
                animationType: AnimationType.none,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.underline,
                  activeColor: Colors.green,
                  selectedColor: Colors.grey,
                  inactiveColor: Colors.grey,
                  activeFillColor: Colors.transparent,
                  inactiveFillColor: Colors.transparent,
                ),
                onChanged: (value) {},
              ),
              const SizedBox(height: 10),

              // Đồng hồ đếm giờ (hiển thị cố định trong ví dụ)
              Text(
                '01:13',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 10),

              // Nút "Bỏ qua" và "Xác nhận"
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Nút Bỏ qua
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Quay lại màn hình trước đó
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 30,
                      ),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Bỏ qua',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),

                  // Nút Xác nhận
                  TextButton(
                    onPressed: () async {
                      // Create a PhoneAuthCredential with the code
                      try {
                        PhoneAuthCredential credential =
                            PhoneAuthProvider.credential(
                                verificationId: widget.verificationID,
                                smsCode: smsController.text);
                        // Sign the user in (or link) with the credential
                        await FirebaseAuth.instance
                            .signInWithCredential(credential);
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //     SnackBar(content: Text('Login success')));
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NameScreen(),
                          ),
                        );
                      } on FirebaseAuthException catch (ex) {
                        print(ex.message);
                      }
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 30,
                      ),
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Xác nhận',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
