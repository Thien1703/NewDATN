import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:health_care/viewmodels/auth_viewmodel.dart';
import 'package:health_care/views/screens/welcome/splash_screen.dart';
import 'package:health_care/views/screens/home/home_screens.dart';
import 'package:vietnam_provinces/vietnam_provinces.dart';

import 'views/screens/auth/login/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await VietnamProvinces.initialize();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCqzgAi64GAYpZZ_pkEwriIV4-RFuYEgWM",
      appId: "1:357055052387:android:3ca405edbbe269ed929656",
      messagingSenderId: "357055052387",
      projectId: "health-care-a85f5",
      storageBucket: "health-care-a85f5.firebasestorage.app",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/', // Route mặc định khi mở ứng dụng
        routes: {
          '/': (context) => SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreens(),
        },
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('vi', 'VN'),
        ],
      ),
    );
  }
}
