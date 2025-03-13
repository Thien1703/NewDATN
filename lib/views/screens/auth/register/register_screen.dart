// import 'package:flutter/material.dart';
// import 'package:health_care/common/app_colors.dart';
// import 'package:provider/provider.dart';
// import 'package:health_care/viewmodels/auth_viewmodel.dart';

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});

//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   final TextEditingController fullNameController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   final _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       backgroundColor: AppColors.primary,
//       resizeToAvoidBottomInset: true,
//       body: GestureDetector(
//         onTap: () => FocusScope.of(context).unfocus(),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             child: Container(
//               height: screenHeight,
//               width: screenWidth,
//               padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     SizedBox(height: screenHeight * 0.08),

//                     // Logo
//                     Image.asset(
//                       'assets/images/healthcaregreen.png',
//                       height: screenHeight * 0.12,
//                     ),
//                     SizedBox(height: screenHeight * 0.04),

//                     // Tiêu đề
//                     Text(
//                       'Đăng ký tài khoản',
//                       style: TextStyle(
//                         color: AppColors.neutralDarkGreen1,
//                         fontSize: screenWidth * 0.06,
//                         fontWeight: FontWeight.w700,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     SizedBox(height: screenHeight * 0.02),

//                     // Full Name
//                     TextFormField(
//                       controller: fullNameController,
//                       decoration: InputDecoration(
//                         labelText: 'Họ và Tên',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8.0),
//                         ),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Vui lòng nhập họ và tên';
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(height: screenHeight * 0.02),

//                     // Phone Number
//                     TextFormField(
//                       controller: phoneController,
//                       keyboardType: TextInputType.phone,
//                       decoration: InputDecoration(
//                         labelText: 'Số điện thoại',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8.0),
//                         ),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Vui lòng nhập số điện thoại';
//                         }
//                         if (!RegExp(r'^\d{9,11}$').hasMatch(value)) {
//                           return 'Số điện thoại không hợp lệ';
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(height: screenHeight * 0.02),

//                     // Password
//                     TextFormField(
//                       controller: passwordController,
//                       obscureText: true,
//                       decoration: InputDecoration(
//                         labelText: 'Mật khẩu',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8.0),
//                         ),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.length < 6) {
//                           return 'Mật khẩu phải có ít nhất 6 ký tự';
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(height: screenHeight * 0.05),

//                     // Nút Đăng ký
//                     ElevatedButton(
//                       onPressed: () {
//                         if (_formKey.currentState!.validate()) {
//                           final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
//                           authViewModel.register(
//                             context,
//                             fullNameController.text.trim(),
//                             phoneController.text.trim(),
//                             passwordController.text.trim(),
//                           );
//                         }
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.accent,
//                         padding: EdgeInsets.symmetric(
//                           vertical: screenHeight * 0.02,
//                         ),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         minimumSize: Size(
//                           screenWidth * 0.7,
//                           screenHeight * 0.07,
//                         ),
//                       ),
//                       child: Text(
//                         'ĐĂNG KÝ',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: screenWidth * 0.045,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:health_care/viewmodels/auth_viewmodel.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    // Lắng nghe thay đổi của các text field
    fullNameController.addListener(updateButtonState);
    phoneController.addListener(updateButtonState);
    passwordController.addListener(updateButtonState);
  }

  @override
  void dispose() {
    fullNameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void updateButtonState() {
    setState(() {
      isButtonEnabled = fullNameController.text.isNotEmpty &&
          phoneController.text.isNotEmpty &&
          passwordController.text.isNotEmpty;
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
                  SizedBox(height: screenHeight * 0.08),
                  Image.asset(
                    'assets/images/healthcaregreen.png',
                    height: screenHeight * 0.12,
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  Text(
                    'Đăng ký tài khoản',
                    style: TextStyle(
                      color: AppColors.neutralDarkGreen1,
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // Full Name
                  TextField(
                    controller: fullNameController,
                    decoration: InputDecoration(
                      labelText: 'Họ và Tên',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // Phone Number
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Số điện thoại',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // Password
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Mật khẩu',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),

                  // "Bạn đã có tài khoản?" + "Đăng nhập"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Bạn đã có tài khoản? ',
                        style: TextStyle(
                          color: AppColors.neutralDarkGreen1,
                          fontSize: screenWidth * 0.04,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Đăng nhập',
                          style: TextStyle(
                            color: AppColors.accent,
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.04),

                  // Nút Đăng ký
                  ElevatedButton(
                    onPressed: isButtonEnabled
                        ? () {
                            final authViewModel = Provider.of<AuthViewModel>(
                                context,
                                listen: false);
                            authViewModel.register(
                              context,
                              fullNameController.text.trim(),
                              phoneController.text.trim(),
                              passwordController.text.trim(),
                            );
                          }
                        : null, // Nếu chưa nhập đủ, nút bị vô hiệu hóa
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isButtonEnabled ? AppColors.accent : AppColors.grey4,
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
                      'ĐĂNG KÝ',
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
