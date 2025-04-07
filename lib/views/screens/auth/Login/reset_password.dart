import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/viewmodels/auth_viewmodel.dart';
import 'package:health_care/views/widgets/widget_header_body.dart';
import 'package:provider/provider.dart';

class ResetPassword extends StatefulWidget {
  final String email;
  final String otp;
  const ResetPassword({super.key, required this.email, required this.otp});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  String? _validateNewPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    }

    // Regex: ít nhất 6 kí tự, 1 chữ hoa, 1 chữ thường, 1 số
    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$');

    if (!regex.hasMatch(value)) {
      return 'Mật khẩu phải có ít nhất 6 ký tự, gồm chữ hoa, chữ thường và số';
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng xác nhận mật khẩu';
    }

    if (value != _newPasswordController.text) {
      return 'Mật khẩu xác nhận không khớp';
    }

    return null;
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
                  "Tạo mật khẩu mới để hoàn tất quy trình",
                  style: TextStyle(fontSize: 18, color: AppColors.deepBlue),
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _newPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Nhập mật khẩu',
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  validator: _validateNewPassword,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Xác nhận mật khẩu',
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  validator: _validateConfirmPassword,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;
                            });
                            final newPassword =
                                _newPasswordController.text.trim();
                            final confirmPassword =
                                _confirmPasswordController.text.trim();
                            final authViewModel = Provider.of<AuthViewModel>(
                                context,
                                listen: false);

                            await authViewModel.resetPassword(
                                context,
                                widget.email,
                                widget.otp,
                                newPassword,
                                confirmPassword);

                            setState(() {
                              _isLoading = false;
                            });
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.deepBlue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    textStyle:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text("Đặt lại mật khẩu"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
