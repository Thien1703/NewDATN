import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool isNewPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isButtonEnabled = false;
    void checkPassword() {
    setState(() {
      isButtonEnabled = newPasswordController.text.length >= 6 &&
          confirmPasswordController.text == newPasswordController.text;
    });
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.primary,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: screenHeight,
              width: screenWidth,
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo ở trên cùng
                  SizedBox(height: screenHeight * 0.1),
                  Image.asset(
                    'assets/images/healthcaregreen.png',
                    height: screenHeight * 0.12, // Responsive logo
                  ),
                  SizedBox(height: screenHeight * 0.05),

                  // Avatar và thông tin người dùng
                  CircleAvatar(
                    radius: screenWidth * 0.12, // Responsive avatar
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: screenWidth * 0.15,
                      color: AppColors.neutralDarkGreen1,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    'HỮU THIỆN',
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neutralDarkGreen1,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    '+84901492845',
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: AppColors.secondary1,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),

                  // Mật khẩu
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Tạo mật khẩu mới',
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        color: AppColors.neutralDarkGreen1,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  TextField(
                    controller: newPasswordController,
                    obscureText: !isNewPasswordVisible,
                    onChanged: (_) => checkPassword(),
                    decoration: InputDecoration(
                      hintText: 'Nhập mật khẩu tối thiểu 6 kí tự',
                      hintStyle: TextStyle(
                        color: AppColors.neutralGreen4,
                        fontSize: screenWidth * 0.04,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.015),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isNewPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            isNewPasswordVisible = !isNewPasswordVisible;
                          });
                        },
                      ),
                      border: const UnderlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),

                  // Nhập lại mật khẩu
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Nhập lại mật khẩu',
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        color: AppColors.neutralDarkGreen1,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: !isConfirmPasswordVisible,
                    onChanged: (_) => checkPassword(),
                    decoration: InputDecoration(
                      hintText: 'Nhập mật khẩu tối thiểu 6 kí tự',
                      hintStyle: TextStyle(
                        color: AppColors.neutralGreen4,
                        fontSize: screenWidth * 0.04,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.015),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isConfirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            isConfirmPasswordVisible =
                                !isConfirmPasswordVisible;
                          });
                        },
                      ),
                      border: const UnderlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),

                  // Nút "TIẾP TỤC"
                  ElevatedButton(
                    onPressed: isButtonEnabled
                        ? () {
                            print("Mật khẩu hợp lệ");
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => WelcomeScreen(),
                            //   ),
                            // );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isButtonEnabled
                          ? AppColors.accent
                          : AppColors.grey4,
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.02,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: Size(
                        screenWidth * 0.7,
                        screenHeight * 0.07,
                      ),
                    ),
                    child: Text(
                      'TIẾP TỤC',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.bold,
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