import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/views/screens/auth/login/login_screen.dart';

final List<Map<String, String>> items = [
  {
    "image": "assets/images/Imagepage1.png",
    "text1": "Dễ dàng tra cứu thông tin",
    "text2":
        "Quản lý dữ liệu hồ sơ sức khỏe cho mỗi cá nhân và người thân hoàn toàn bảo mật và khoa học. Dễ dàng tìm kiếm và tra cứu thông tin",
  },
  {
    "image": "assets/images/Imagepage3.png",
    "text1": "Đặt khám dễ dàng",
    "text2":
        "Ứng dụng đặt khám bệnh tại hơn 10 phòng khám đa khoa, chuyên khoa và đa dạng các tiện ích khác giúp đặt khám dễ dàng và tiết kiệm thời gian",
  },
  {
    "image": "assets/images/Imagepage2.png",
    "text1": "Tiết kiệm thời gian",
    "text2":
        "Đặt hẹn nhanh chóng, dễ dàng ngay trên ứng dụng điện thoại chỉ với vài thao tác đơn giản giúp khách hàng chủ động lịch trình khám chữa bệnh",
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 15, top: 20),
                child: IntrinsicWidth(
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    ),
                    child: Text(
                      'Bỏ qua',
                      style: TextStyle(
                        color: AppColors.deepBlue,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
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
                        AspectRatio(
                          aspectRatio: 11 / 9,
                          child: Image.asset(
                            item["image"]!,
                            width: 300,
                            // fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 30),
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [
                              AppColors.deepBlue,
                              AppColors.softBlue,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds),
                          child: Text(
                            item["text1"]!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          item["text2"]!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 50),
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.deepBlue, AppColors.softBlue],
                  ),
                  borderRadius: BorderRadius.circular(15)),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(150, 50),
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  if (isLastSlide) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
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
                  isLastSlide ? "Bắt đầu" : "Tiếp",
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: Text(
                '${currentIndex + 1}/${items.length}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepBlue,
                ),
              ),
            ),
            Stack(
              children: [
                Container(
                  width: 150,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: (currentIndex + 1) / items.length * 150,
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.deepBlue, AppColors.softBlue],
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
