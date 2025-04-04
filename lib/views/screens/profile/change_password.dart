import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _oldPasswordController.addListener(_validateForm);
    _newPasswordController.addListener(_validateForm);
    _confirmPasswordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      isButtonEnabled = _oldPasswordController.text.isNotEmpty &&
          _newPasswordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty;
    });
  }

  void _handleChangePassword() async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    String oldPassword = _oldPasswordController.text.trim();
    String newPassword = _newPasswordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();


    //   // Gọi API kiểm tra mật khẩu cũ có đúng không
    // bool isOldPasswordCorrect = await authViewModel.verifyOldPassword(oldPassword);

    // if (!isOldPasswordCorrect) {
    //   Fluttertoast.showToast(
    //     msg: "Mật khẩu cũ không chính xác.",
    //     toastLength: Toast.LENGTH_LONG,
    //     gravity: ToastGravity.BOTTOM,
    //     backgroundColor: Colors.red,
    //     textColor: Colors.white,
    //   );
    //   return;
    // }


    if (newPassword == oldPassword) {
      Fluttertoast.showToast(
        msg: "Mật khẩu mới không được trùng với mật khẩu cũ.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    if (newPassword != confirmPassword) {
      Fluttertoast.showToast(
        msg: "Mật khẩu mới và xác nhận mật khẩu không khớp.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    await authViewModel.changePassword(
        context, oldPassword, newPassword, confirmPassword);
  }

  @override
  Widget build(BuildContext context) {
    return WidgetHeaderBody(
      iconBack: true,
      title: 'Đổi Mật Khẩu',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
            ),
            const SizedBox(height: 16),
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
            ),
            const SizedBox(height: 16),
            _customTitle(title: 'Nhập lại mật khẩu mới'),
            _buildPasswordField(
              controller: _confirmPasswordController,
              label: 'Nhập lại mật khẩu mới',
              isVisible: _isConfirmPasswordVisible,
              onToggle: () {
                setState(() {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                });
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: isButtonEnabled ? _handleChangePassword : null,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                      color: isButtonEnabled
                          ? AppColors.deepBlue
                          : AppColors.grey4),
                  backgroundColor:
                      isButtonEnabled ? AppColors.deepBlue : AppColors.grey4,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  'Xác nhận',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neutralWhite),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _customTitle({required String title}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.deepBlue,
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool isVisible,
    required VoidCallback onToggle,
  }) {
    return Container(
      height: 45,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        controller: controller,
        obscureText: !isVisible,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          labelStyle: const TextStyle(fontSize: 14),
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
      ),
    );
  }
}
