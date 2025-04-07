import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:health_care/common/app_colors.dart';
import '../auth/Login/login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  bool isLastSlide = false;
  int currentIndex = 0;
  bool isFirstLaunch = true;

  final List<Map<String, String>> items = [
    {
      "image": "assets/images/Imagepage1.png",
      "text1": "Dễ dàng tra cứu thông tin",
      "text2": "Quản lý dữ liệu hồ sơ sức khỏe cá nhân bảo mật và khoa học.",
    },
    {
      "image": "assets/images/Imagepage3.png",
      "text1": "Đặt khám dễ dàng",
      "text2": "Đặt khám tại hơn 10 phòng khám, tiết kiệm thời gian tối đa.",
    },
    {
      "image": "assets/images/Imagepage2.png",
      "text1": "Tiết kiệm thời gian",
      "text2": "Đặt hẹn nhanh chóng ngay trên ứng dụng chỉ với vài thao tác.",
    },
  ];

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    bool firstLaunch = prefs.getBool('isFirstLaunch') ?? true;
    if (!firstLaunch) {
      _pageController.jumpToPage(items.length - 1);
      setState(() => isLastSlide = true);
    } else {
      await prefs.setBool('isFirstLaunch', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: InkWell(
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  ),
                  child: Text(
                    'Bỏ qua',
                    style: TextStyle(
                      color: AppColors.deepBlue,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: items.length,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                    isLastSlide = (index == items.length - 1);
                  });
                },
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          item["image"]!,
                          width: MediaQuery.of(context).size.width * 0.7,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 30),
                        Text(
                          item["text1"]!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.deepBlue,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          item["text2"]!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: 270,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.deepBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    if (isLastSlide) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Text(
                    isLastSlide ? "Bắt đầu" : "Tiếp tục",
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                '${currentIndex + 1}/${items.length}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepBlue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
