import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/views/screens/auth/login/forgotPassword_screen.dart';
import 'package:health_care/views/screens/home/home_screens.dart';

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({super.key});

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    passwordController.addListener(_checkPasswordValidity);
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  void _checkPasswordValidity() {
    setState(() {
      isButtonEnabled = passwordController.text.length >= 6;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.primary,
      resizeToAvoidBottomInset: false, // Cố định layout khi bàn phím xuất hiện
      body: SafeArea(
        child: Stack(
          children: [
            // Logo nằm ở trên cùng
            Positioned(
              top: screenHeight * 0.1,
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset(
                  'assets/images/healthcaregreen.png',
                  height: screenHeight * 0.12,
                ),
              ),
            ),

            // Nội dung chính ở giữa
            Positioned.fill(
              top: screenHeight * 0.25,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: screenWidth * 0.1,
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
                  SizedBox(height: screenHeight * 0.005),
                  Text(
                    '+84901492845',
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: AppColors.secondary1,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),

                  // Nhập mật khẩu
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nhập mật khẩu',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            color: AppColors.neutralDarkGreen1,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        TextField(
                          controller: passwordController,
                          obscureText: !isPasswordVisible,
                          decoration: InputDecoration(
                            hintText: 'Nhập mật khẩu tối thiểu 6 kí tự',
                            hintStyle: TextStyle(
                              color: AppColors.neutralGreen4,
                              fontSize: screenWidth * 0.035,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.015,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  isPasswordVisible = !isPasswordVisible;
                                });
                              },
                            ),
                            border: const UnderlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),

                        // Các nút "Quên mật khẩu" và "Thoát tài khoản"
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ForgotPasswordScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Quên mật khẩu',
                                style: TextStyle(
                                  color: AppColors.neutralDarkGreen2,
                                  fontSize: screenWidth * 0.035,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Text(
                                'Thoát tài khoản',
                                style: TextStyle(
                                  color: AppColors.neutralDarkGreen2,
                                  fontSize: screenWidth * 0.035,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Nút "TIẾP TỤC" ở cuối
            Positioned(
              bottom: screenHeight * 0.05,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton(
                  onPressed: isButtonEnabled
                      ? () {
                          // Logic xử lý khi nhấn "TIẾP TỤC"
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreens(),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isButtonEnabled
                        ? AppColors.accent // Màu xanh nếu hợp lệ
                        : AppColors.grey4, // Màu xám nếu không hợp lệ
                    padding:
                        EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: Size(screenWidth * 0.6, screenHeight * 0.07),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
