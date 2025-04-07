import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/viewmodels/auth_viewmodel.dart';
import 'package:health_care/views/widgets/widget_header_body.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>(); // To validate form

  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool isLoading = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateOldPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Mật khẩu cũ không được trống';
    }
    return null;
  }

  String? _validateNewPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Mật khẩu mới không được trống';
    }
    if (value.length < 6) {
      return 'Mật khẩu mới phải có ít nhất 6 ký tự';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Xác nhận mật khẩu không được trống';
    }
    if (value != _newPasswordController.text) {
      return 'Mật khẩu xác nhận không khớp';
    }
    return null;
  }

  void _handleChangePassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      String oldPassword = _oldPasswordController.text.trim();
      String newPassword = _newPasswordController.text.trim();
      String confirmPassword = _confirmPasswordController.text.trim();

      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      await authViewModel.changePassword(
          context, oldPassword, newPassword, confirmPassword);

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WidgetHeaderBody(
      iconBack: true,
      title: 'Đổi Mật Khẩu',
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _customTitle(title: 'Mật khẩu cũ'),
                _buildPasswordField(
                  controller: _oldPasswordController,
                  label: 'Nhập mật khẩu cũ',
                  isVisible: _isOldPasswordVisible,
                  onToggle: () {
                    setState(() {
                      _isOldPasswordVisible = !_isOldPasswordVisible;
                    });
                  },
                  validator: _validateOldPassword,
                ),
                const SizedBox(height: 15),
                _customTitle(title: 'Mật khẩu mới'),
                _buildPasswordField(
                  controller: _newPasswordController,
                  label: 'Nhập mật khẩu mới',
                  isVisible: _isNewPasswordVisible,
                  onToggle: () {
                    setState(() {
                      _isNewPasswordVisible = !_isNewPasswordVisible;
                    });
                  },
                  validator: _validateNewPassword,
                ),
                const SizedBox(height: 15),
                _customTitle(title: 'Xác nhận mật khẩu'),
                _buildPasswordField(
                  controller: _confirmPasswordController,
                  label: 'Nhập lại mật khẩu',
                  isVisible: _isConfirmPasswordVisible,
                  onToggle: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                  validator: _validateConfirmPassword,
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: isLoading ? null : _handleChangePassword,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          color: !isLoading
                              ? AppColors.deepBlue
                              : AppColors.grey4),
                      backgroundColor:
                          !isLoading ? AppColors.deepBlue : AppColors.grey4,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: isLoading
                        ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.neutralWhite),
                          )
                        : Text(
                            'Xác nhận',
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
    );
  }

  Widget _customTitle({required String title}) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool isVisible,
    required VoidCallback onToggle,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          obscureText: !isVisible,
          decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: Colors.white,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            labelStyle:
                const TextStyle(fontSize: 14, color: AppColors.neutralDark),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: AppColors.accent, width: 1),
            ),
            suffixIcon: IconButton(
              icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
              onPressed: onToggle,
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
