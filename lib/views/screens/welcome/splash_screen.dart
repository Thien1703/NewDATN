import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/views/screens/auth/Login/choose.dart';
import 'package:health_care/views/screens/welcome/welcome_screen.dart';
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
    await Future.delayed(Duration(seconds: 3));

    if (!mounted) return;

    bool isFirstTime =
        await LocalStorageService.isFirstTime(); // Hàm kiểm tra lần đầu mở app
    if (isFirstTime) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomeScreen()),
      );
      return;
    }

    bool isLoggedIn = await LocalStorageService.isLoggedIn();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => isLoggedIn ? HomeScreens() : chooseSigninRes(),
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
