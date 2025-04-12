import 'package:flutter/material.dart';
import 'package:health_care/views/screens/home/home_screens.dart';
import 'package:health_care/views/screens/tools/gender_enum.dart';

class BmiResultScreen extends StatelessWidget {
  final double bmi;
  final double bfp;
  final Gender gender;

  const BmiResultScreen({
    super.key,
    required this.bmi,
    required this.bfp,
    required this.gender,
  });

  int getBmiCategoryIndex() {
    if (bmi < 18.5) return 0;
    if (bmi < 23) return 1;
    if (bmi < 25) return 2;
    if (bmi < 30) return 3;
    return 4;
  }

  List<String> getImagePaths() {
    final suffix = gender == Gender.male ? 'male' : 'female';
    return [
      'assets/images/underweight_$suffix.jpg',
      'assets/images/normal_$suffix.jpg',
      'assets/images/overweight_$suffix.jpg',
      'assets/images/obese1_$suffix.jpg',
      'assets/images/obese2_$suffix.jpg',
    ];
  }

  @override
  Widget build(BuildContext context) {
    final bmiValue = bmi.toStringAsFixed(1);
    final bmiIndex = getBmiCategoryIndex();
    final imagePaths = getImagePaths();
    final labels = [
      'Thiếu cân\n0 - 18.5',
      'Bình thường\n18.5 - 22.9',
      'Thừa cân\n23 - 24.9',
      'Béo phì 1\n25 - 29.9',
      'Béo phì 2\n30+',
    ];
    final pageController =
        PageController(viewportFraction: 1 / 3, initialPage: bmiIndex);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Công cụ tính chỉ số BMI",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(
              Icons.cancel,
              color: Colors.grey[600],
              size: 20,
            ),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => HomeScreens())),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            const Text("Chỉ số BMI của bạn là",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400)),
            Text(
              bmiValue,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            // PageView hình
            SizedBox(
              height: 340,
              child: PageView.builder(
                controller: pageController,
                itemCount: imagePaths.length,
                itemBuilder: (context, index) {
                  final isCenter = index == bmiIndex;
                  return Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 330),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Opacity(
                              opacity: isCenter ? 1.0 : 0.3,
                              child: Image.asset(
                                imagePaths[index],
                                width: isCenter ? 220 : 170,
                                height: isCenter ? 280 : 190,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              labels[index],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isCenter
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isCenter ? Colors.black : Colors.grey,
                              ),
                            ),
                            if (isCenter)
                              Text(
                                "($bmiValue)",
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 38),

            Text(
              _getBmiComment(bmi),
              style:
                  const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w400),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 30),

            // Nút kiểm tra lại
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context, true),
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.white,
                  size: 25,
                ),
                label: const Text(
                  "Kiểm tra lại",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getBmiComment(double bmi) {
    if (bmi < 18.5) {
      return "Bạn được xem là thiếu cân nếu có chỉ số BMI dưới 18.5.";
    } else if (bmi < 23) {
      return "Bạn có cân nặng lý tưởng nếu chỉ số BMI trong khoảng 18.5 đến 22.9.";
    } else if (bmi < 25) {
      return "Bạn được xem là thừa cân nếu có chỉ số BMI trong khoảng từ 23 đến 24.9.";
    } else if (bmi < 30) {
      return "Bạn được xem là béo phì độ 1 nếu chỉ số BMI trong khoảng từ 25 đến 29.9.";
    } else {
      return "Bạn được xem là béo phì độ 2 nếu chỉ số BMI từ 30 trở lên.";
    }
  }
}
