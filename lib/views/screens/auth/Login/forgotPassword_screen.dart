import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:health_care/viewmodels/auth_viewmodel.dart';
import 'package:health_care/views/screens/auth/Login/reset_password.dart';
import 'package:health_care/views/widgets/widget_header_body.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // ✅ Hàm kiểm tra email
  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập email';
    }
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(value)) {
      return 'Email không hợp lệ';
    }
    return null;
  }

  // ✅ Hàm gửi OTP
  Future<void> _sendOtp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String email = _emailController.text.trim();
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

      String? otp = await authViewModel.forgotPassword(context, email);
      print('🔐 In OTP: $otp');

      setState(() {
        _isLoading = false;
      });

      if (otp != null && context.mounted) {
        Fluttertoast.showToast(
          msg: 'Xác thực OTP thành công!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResetPassword(email: email, otp: otp),
          ),
        );
      } else {
        // Xác thực thất bại hoặc bị hủy
        print("❌ OTP null hoặc không xác thực được");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WidgetHeaderBody(
        iconBack: true,
        title: "Quên mật khẩu",
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  "Nhập email để nhận mã OTP",
                  style: TextStyle(fontSize: 18, color: AppColors.deepBlue),
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Nhập email',
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  validator: _validateEmail,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _sendOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.deepBlue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text("Tiếp tục"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
