import 'package:flutter/material.dart';
import 'package:health_care/views/screens/auth/Login/choose.dart';
import 'package:health_care/views/screens/auth/Login/newLogin.dart';
import 'package:health_care/views/screens/welcome/welcome_screen.dart';
import '../../../services/local_storage_service.dart';
import '../auth/login/login_screen.dart';
import '../home/home_screens.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({super.key});

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
    await Future.delayed(Duration(seconds: 5));

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
        gradient: LinearGradient(
          colors: [
            Color(0xFF1565C0),
            Colors.white,
            Color(0xFF64B5F6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logoApp.png',
              width: 110,
            ),
            SizedBox(height: 20),
            Text(
              'HEALTH CARE',
              style: TextStyle(
                fontSize: 25,
                color: Color(0xFF0D47A1),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
