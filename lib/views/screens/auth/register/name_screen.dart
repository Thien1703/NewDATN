import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/views/screens/auth/register/password_screen.dart';

class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _lastNameController.addListener(_updateButtonState);
    _firstNameController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _lastNameController.dispose();
    _firstNameController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _lastNameController.text.isNotEmpty &&
          _firstNameController.text.isNotEmpty;
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
                  SizedBox(height: screenHeight * 0.1),
                  Image.asset(
                    'assets/images/healthcaregreen.png',
                    height: screenHeight * 0.12, // Responsive logo
                  ),
                  SizedBox(height: screenHeight * 0.05),

                  // Tiêu đề và mô tả
                  Text(
                    'Vui lòng nhập họ và tên của bạn',
                    style: TextStyle(
                      color: AppColors.neutralDarkGreen1,
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    'Sử dụng họ và tên đầy đủ để đảm bảo thông tin chính xác',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.neutralGreen4,
                      fontSize: screenWidth * 0.04,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),

                  // Input họ
                  TextField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      labelText: 'Họ',
                      labelStyle: TextStyle(
                        color: AppColors.neutralGreen4,
                        fontSize: screenWidth * 0.04,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.neutralGreen4),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.neutralDarkGreen1),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),

                  // Input tên
                  TextField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      labelText: 'Tên',
                      labelStyle: TextStyle(
                        color: AppColors.neutralGreen4,
                        fontSize: screenWidth * 0.04,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.neutralGreen4),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.neutralDarkGreen1),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.1),

                  // Nút tiếp tục
                  ElevatedButton(
                    onPressed: _isButtonEnabled
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PasswordScreen(),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isButtonEnabled
                          ? AppColors.neutralGreen4
                          : AppColors.grey4,
                      padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.02),
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
