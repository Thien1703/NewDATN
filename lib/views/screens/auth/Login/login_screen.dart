import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/views/screens/auth/register/register_screen.dart';
import 'package:provider/provider.dart';
import '../../../../viewmodels/auth_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  String? _errorMessage;

  void handleLogin() async {
    if (!mounted) return;
    await Provider.of<AuthViewModel>(context, listen: false).login(
      context,
      phoneController.text.trim(),
      passwordController.text.trim(),
    );
  }

  @override
  void initState() {
    super.initState();
    phoneController.addListener(_updateButtonState);
    passwordController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {});
  }

  bool get _isFormFilled =>
      phoneController.text.isNotEmpty && passwordController.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: screenHeight, // Đảm bảo nội dung chiếm toàn bộ chiều cao
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(),
              const SizedBox(height: 30),
              _buildInputField('Số điện thoại', phoneController, false),
              SizedBox(height: 20),
              _buildPasswordField(),
              if (_errorMessage != null) _buildErrorMessage(screenWidth),
              SizedBox(height: 40),
              _buildLoginButton(),
              const SizedBox(height: 10),
              _buildRegisterOption(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Đăng nhập',
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildInputField(
      String label, TextEditingController controller, bool isPassword) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 5),
            const Icon(Icons.star, color: Colors.red, size: 12),
          ],
        ),
        SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: TextField(
            controller: controller,
            obscureText: isPassword && !_isPasswordVisible,
            keyboardType: isPassword ? TextInputType.text : TextInputType.phone,
            decoration: InputDecoration(
              hintText: 'Nhập',
              filled: true,
              fillColor: const Color.fromARGB(255, 250, 251, 252),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.blue, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.softBlue, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.deepBlue, width: 1.5),
              ),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(_isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'Mật khẩu',
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 5),
                const Icon(Icons.star, color: Colors.red, size: 12),
              ],
            ),
            GestureDetector(
                onTap: () {},
                child: ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      AppColors.deepBlue,
                      AppColors.softBlue,
                    ],
                  ).createShader(bounds),
                  child: Text('Quên mật khẩu',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                )),
          ],
        ),
        SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: TextField(
            controller: passwordController,
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              hintText: 'Nhập',
              filled: true,
              fillColor: const Color.fromARGB(255, 250, 251, 252),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.blue, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.softBlue, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.deepBlue, width: 1.5),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        _buildCustomeError(error: 'Mật khẩu bao gồm 8 ký tự'),
        _buildCustomeError(
            error: 'Mật khẩu bao gồm chữ cái viết hoa và viết thường'),
        _buildCustomeError(error: 'Mật khẩu bao gồm ký tự đặc biệt'),
      ],
    );
  }

  Widget _buildErrorMessage(double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Center(
        child: Text(
          _errorMessage!,
          style: TextStyle(color: Colors.red, fontSize: screenWidth * 0.04),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Center(
      child: Ink(
        decoration: BoxDecoration(
          gradient: _isFormFilled
              ? LinearGradient(colors: [AppColors.deepBlue, AppColors.softBlue])
              : null,
          color:
              _isFormFilled ? null : const Color.fromARGB(255, 199, 199, 199),
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          onTap: _isFormFilled ? handleLogin : null,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 360,
            height: 50,
            alignment: Alignment.center,
            child: const Text(
              'Đăng nhập',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterOption() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Bạn chưa có tài khoản?', style: TextStyle(fontSize: 15)),
          const SizedBox(width: 5),
          GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RegisterScreen()),
                );
              },
              child: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    AppColors.deepBlue,
                    AppColors.softBlue,
                  ],
                ).createShader(bounds),
                child: Text('Tạo mới ngay!',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
              )),
        ],
      ),
    );
  }
}

Widget _buildCustomeError({required String error}) {
  return Padding(
    padding: EdgeInsets.only(left: 5),
    child: Row(
      children: [
        Icon(
          Icons.donut_large_sharp,
          size: 10,
          color: Colors.black,
        ),
        SizedBox(width: 10),
        Text(error),
      ],
    ),
  );
}
