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
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  final _formKey = GlobalKey<FormState>();
  String? _validateNewPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    }

    // Kiểm tra không được chứa khoảng trắng
    if (value.contains(' ')) {
      return 'Mật khẩu không được chứa khoảng trắng';
    }

    // Regex: ít nhất 8 ký tự, gồm ít nhất 1 chữ hoa và 1 chữ số (ký tự đặc biệt thì có thể có hoặc không)
    final regex = RegExp(r'^(?=.*[A-Z])(?=.*\d).{8,}$');

    if (!regex.hasMatch(value)) {
      return 'Mật khẩu phải từ 8 ký tự trở lên, gồm ít nhất 1 chữ hoa và 1 số ';
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
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: WidgetHeaderBody(
          iconBack: true,
          title: "Quên mật khẩu",
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nhập mật khẩu mới',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.deepBlue,
                    ),
                  ),
                  TextFormField(
                    controller: _newPasswordController,
                    obscureText: _obscureNewPassword,
                    decoration: InputDecoration(
                      hintText: 'Nhập mật khẩu',
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 108, 108, 108),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureNewPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureNewPassword = !_obscureNewPassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      errorMaxLines: 2,
                    ),
                    validator: _validateNewPassword,
                  ),
                  SizedBox(height: 20),
                  Text(
                    '  Xác nhận mật khẩu',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.deepBlue,
                    ),
                  ),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      hintText: 'Xác nhận mật khẩu',
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 108, 108, 108),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    validator: _validateConfirmPassword,
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
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
                                final authViewModel =
                                    Provider.of<AuthViewModel>(context,
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
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                      ),
                      child: _isLoading
                          ? SizedBox(
                              child: CircularProgressIndicator(
                                color: AppColors.neutralWhite,
                              ),
                            )
                          : Text(
                              "Đặt lại mật khẩu",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.neutralWhite),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
