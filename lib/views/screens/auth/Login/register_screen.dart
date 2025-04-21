import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:health_care/utils/validators.dart';
import 'package:health_care/views/screens/profile/termsAndServices_screen.dart';
import 'package:provider/provider.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/viewmodels/auth_viewmodel.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _agreedToTerms = false;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      await authViewModel.register(
        context,
        _fullNameController.text.trim(),
        _phoneNumberController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back_ios),
                          ),
                          const SizedBox(height: 10),
                          const Center(
                            child: Text(
                              'Đăng ký',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          TextFormField(
                            controller: _fullNameController,
                            validator: Validators.validateFullName,
                            decoration: InputDecoration(
                              hintText: 'Họ và tên',
                              hintStyle: const TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 108, 108, 108),
                              ),
                              prefixIcon: const Icon(
                                Icons.person_2_sharp,
                                color: AppColors.deepBlue,
                                size: 25,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _phoneNumberController,
                            validator: Validators.validatePhoneNumber,
                            decoration: InputDecoration(
                              hintText: 'Số điện thoại',
                              hintStyle: const TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 108, 108, 108),
                              ),
                              prefixIcon: const Icon(
                                Icons.phone,
                                color: AppColors.deepBlue,
                                size: 25,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _emailController,
                            validator: Validators.validateEmail,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              hintStyle: const TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 108, 108, 108),
                              ),
                              prefixIcon: const Icon(
                                Icons.email,
                                color: AppColors.deepBlue,
                                size: 25,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            validator: Validators.validatePassword,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              hintText: 'Mật khẩu',
                              hintStyle: const TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 108, 108, 108),
                              ),
                              prefixIcon: const Icon(
                                Icons.lock_rounded,
                                color: AppColors.deepBlue,
                                size: 25,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(_obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: _togglePasswordVisibility,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              errorMaxLines: 2,
                            ),
                          ),

                          // Checkbox + Điều khoản
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Checkbox(
                                value: _agreedToTerms,
                                activeColor: AppColors.deepBlue,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _agreedToTerms = value ?? false;
                                  });
                                },
                              ),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Tôi đồng ý với ',
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 12.5,
                                    ),
                                    children: [
                                      TextSpan(
                                          text: 'các điều khoản và dịch vụ',
                                          style: const TextStyle(
                                            color: AppColors.deepBlue,
                                            fontWeight: FontWeight.bold,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        TermsandservicesScreen(),
                                                  ));
                                            }),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: (_isLoading || !_agreedToTerms)
                                  ? null
                                  : _register,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.deepBlue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white)
                                  : const Text(
                                      'Đăng ký',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
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
          },
        ),
      ),
    );
  }
}
