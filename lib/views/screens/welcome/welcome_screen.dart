import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/views/screens/auth/login/login_screen.dart';
import 'package:health_care/views/screens/auth/register/register_screen.dart';

final List<Map<String, String>> items = [
  {
    "image": "assets/images/Picture1.png",
    "text1": "Tiện Ích",
    "text2": "Tối ưu hóa trải nghiệm người dùng với các công cụ hiện đại",
  },
  {
    "image": "assets/images/Picture2.png",
    "text1": "Thuận Lợi",
    "text2": "Dễ dàng tiếp cận và sử dụng mọi lúc, mọi nơi",
  },
  {
    "image": "assets/images/Picture3.png",
    "text1": "Chủ Động",
    "text2": "Kiểm soát thời gian và lịch trình của bạn hiệu quả hơn",
  },
];

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

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
    Future.delayed(const Duration(seconds: 3), _autoPlaySlides);
  }

  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true; // Lấy giá trị
      if (!isFirstLaunch) {
        // Nếu không phải lần đầu, chuyển đến slide cuối
        _pageController.jumpToPage(items.length - 1);
        isLastSlide = true;
      }
    });
    if (isFirstLaunch) {
      prefs.setBool('isFirstLaunch', false); // Lưu trạng thái sau lần đầu
    }
  }

  void _autoPlaySlides() {
    if (!isLastSlide) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      Future.delayed(const Duration(seconds: 3), _autoPlaySlides);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.65,
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
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: AspectRatio(
                            aspectRatio: 16 / 9, // Tỷ lệ khung hình cố định
                            child: Image.asset(
                              item["image"]!,
                              fit: BoxFit.contain, // Hiển thị toàn bộ hình ảnh
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          item["text1"]!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.accent,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          item["text2"]!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.neutralDarkGreen2,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                items.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: currentIndex == index ? 24 : 8,
                  decoration: BoxDecoration(
                    color: currentIndex == index
                        ? Colors.green
                        : Colors.green.shade200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                if (isLastSlide) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(),
                    ),
                  );
                } else {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
              child: Text(
                isLastSlide ? "ĐĂNG KÝ" : "TIẾP",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (isLastSlide)
              RichText(
                text: TextSpan(
                  text: 'Bạn đã có tài khoản? ',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.neutralGrey3,
                  ),
                  children: [
                    TextSpan(
                      text: 'Đăng nhập',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2F6D46),
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
