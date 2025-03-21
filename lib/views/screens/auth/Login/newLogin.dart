import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/viewmodels/auth_viewmodel.dart';
import 'package:health_care/views/screens/auth/Login/newRes.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailOrPhoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  /// Hàm kiểm tra Gmail hoặc SĐT
  String? _validateEmailOrPhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập Gmail hoặc SĐT';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    final phoneRegex = RegExp(r'^(0|\+84)[0-9]{9}$');

    if (!emailRegex.hasMatch(value) && !phoneRegex.hasMatch(value)) {
      return 'Sai định dạng Gmail hoặc SĐT';
    }
    return null;
  }

  /// Hàm kiểm tra mật khẩu
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    }
    return null;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  /// Hàm đăng nhập sử dụng AuthViewModel
  void _signIn() {
    if (_formKey.currentState!.validate()) {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      String phoneOrEmail = _emailOrPhoneController.text.trim();
      String password = _passwordController.text.trim();

      authViewModel.login(context, phoneOrEmail, password);
    }
  }

  void _signUp() {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => RegisterScreen()), // Thay thế bằng màn hình đăng ký của bạn
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                AppColors.accent,
                AppColors.primary,
              ]),
            ),
            child: const Padding(
              padding: EdgeInsets.only(top: 60.0, left: 22),
              child: Text(
                'Hello\nSign in!',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 250.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)),
                color: Colors.white,
              ),
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 40),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailOrPhoneController,
                          keyboardType: TextInputType.emailAddress,
                          validator: _validateEmailOrPhone,
                          decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.check, color: Colors.grey),
                            label: Text(
                              'Gmail/Phone',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          validator: _validatePassword,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: _togglePasswordVisibility,
                            ),
                            label: const Text(
                              'Password',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        const Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Color(0xff281537),
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                        GestureDetector(
                          onTap: _signIn,
                          child: Container(
                            height: 55,
                            width: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: const LinearGradient(colors: [
                                AppColors.accent,
                                AppColors.primary,
                              ]),
                            ),
                            child: const Center(
                              child: Text(
                                'SIGN IN',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have account?",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              ),
                              GestureDetector(
                                onTap: _signUp,
                                child: Text(
                                  "Sign up",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
