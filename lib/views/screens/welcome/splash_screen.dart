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
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    final bool isFirstTime = await LocalStorageService.isFirstTime();
    if (isFirstTime) {
      _goTo(const WelcomeScreen());
      return;
    }

    final bool isLoggedIn = await LocalStorageService.isLoggedIn();
    debugPrint("🟢 isLoggedIn: $isLoggedIn");

    if (!isLoggedIn) {
      _goTo(chooseSigninRes());
      return;
    }

    final int? customerId = await AppConfig.getMyUserId();
    if (customerId == null) {
      showToastError("Không thể lấy ID người dùng!");
      _goTo(chooseSigninRes());
      return;
    }

    // Lưu customerId
    await LocalStorageService.saveUserId(customerId);
    if (!mounted) return;
    Provider.of<UserProvider>(context, listen: false).setCustomerId(customerId);
    debugPrint("✅ Đã lưu customerId vào Provider: $customerId");

    _goTo(HomeScreens());
  }

  void _goTo(Widget screen) {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.05), // Slide từ dưới lên nhẹ
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOut),
              ),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.deepBlue,
        child: Center(
          child: Image.asset(
            'assets/images/logoDATN.png',
            width: 250,
          ),
        ),
      ),
    );
  }
}
