import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/viewmodels/auth_viewmodel.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailOrPhoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      final String fullName = _fullNameController.text.trim();
      final String phoneOrEmail = _emailOrPhoneController.text.trim();
      final String password = _passwordController.text.trim();

      Provider.of<AuthViewModel>(context, listen: false)
          .register(context, fullName, phoneOrEmail, password);
    }
  }

  String? _validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập họ và tên';
    }
    return null;
  }

  String? _validateEmailOrPhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập số điện thoại hoặc email';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value) && !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
      return 'Số điện thoại hoặc email không hợp lệ';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Vui lòng nhập lại mật khẩu';
  }
  if (value != _passwordController.text) {
    return 'Mật khẩu xác nhận không khớp';
  }
  return null;
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
                'Create Your\nAccount',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 250.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.white,
              ),
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 40),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: _fullNameController,
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          validator: _validateFullName,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _emailOrPhoneController,
                          decoration: const InputDecoration(
                            labelText: 'Phone or Gmail',
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          validator: _validateEmailOrPhone,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: _togglePasswordVisibility,
                            ),
                            labelText: 'Password',
                            labelStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          validator: _validatePassword,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: _toggleConfirmPasswordVisibility,
                            ),
                            labelText: 'Confirm Password',
                            labelStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          validator: _validateConfirmPassword,
                        ),
                        const SizedBox(height: 50),
                        GestureDetector(
                          onTap: _register,
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
                                'SIGN UP',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              const Text(
                                "Already have an account?",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "Sign In",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
