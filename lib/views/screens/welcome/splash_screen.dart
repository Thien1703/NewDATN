import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/config/app_config.dart';
import 'package:health_care/viewmodels/toast_helper.dart';
import 'package:health_care/viewmodels/user_provider.dart';
import 'package:health_care/views/screens/auth/Login/choose.dart';
import 'package:health_care/views/screens/welcome/welcome_screen.dart';
import 'package:provider/provider.dart';
import '../../../services/local_storage_service.dart';
import '../home/home_screens.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(Duration(seconds: 1));

    if (!mounted) return;

    bool isFirstTime =
        await LocalStorageService.isFirstTime(); // Hàm kiểm tra lần đầu mở app
    if (isFirstTime) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => WelcomeScreen()),
      );
      return;
    }

    bool isLoggedIn = await LocalStorageService.isLoggedIn();
    // 🔹 Lấy customerId từ API
    int? customerId = await AppConfig.getMyUserId();
    if (customerId != null) {
      await LocalStorageService.saveUserId(customerId);
      if (!mounted) return;
      // 🔹 Lưu customerId vào Provider
      Provider.of<UserProvider>(context, listen: false)
          .setCustomerId(customerId);
      print("Đã lưu customerId vào Provider: $customerId");
    } else {
      showToastError("Không thể lấy ID người dùng!");
      return;
    }
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => isLoggedIn ? HomeScreens() : chooseSigninRes(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        color: AppColors.deepBlue,
      ),
      child: Center(
        child: Image.asset(
          'assets/images/logoDATN.png',
          width: 250,
        ),
      ),
    ));
  }
}
