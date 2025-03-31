import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:health_care/views/screens/home/home_screens.dart';
import 'package:health_care/views/screens/tools/gender_enum.dart';

class BmiResultScreen extends StatelessWidget {
  final double bmi;
  final double bfp;
  final Gender gender;
  const BmiResultScreen(
      {super.key, required this.bmi, required this.bfp, required this.gender});

  String getBmiCategory() {
    if (bmi < 18.5) return 'Gầy';
    if (bmi < 23) return 'Bình thường';
    if (bmi < 25) return 'Thừa cân';
    if (bmi < 30) return 'Béo phì độ 1';
    return 'Béo phì độ 2';
  }

  Color getBmiColor() {
    if (bmi < 18.5) return Colors.blue;
    if (bmi < 23) return Colors.green;
    if (bmi < 25) return Colors.orangeAccent;
    if (bmi < 30) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final category = getBmiCategory();
    final color = getBmiColor();
    final scaleWidth = MediaQuery.of(context).size.width - 40;

    double arrowX = 0;

    if (bmi <= 18.5) {
      double percent = bmi / 18.5;
      arrowX = percent * (0.46 * scaleWidth);
    } else if (bmi <= 23) {
      double percent = (bmi - 18.5) / (23 - 18.5);
      arrowX = (0.46 * scaleWidth) + percent * (0.115 * scaleWidth);
    } else if (bmi <= 25) {
      double percent = (bmi - 23) / (25 - 23);
      arrowX = (0.575 * scaleWidth) + percent * (0.05 * scaleWidth);
    } else if (bmi <= 30) {
      double percent = (bmi - 25) / (30 - 25);
      arrowX = (0.625 * scaleWidth) + percent * (0.125 * scaleWidth);
    } else {
      double percent = (bmi - 30) / (40 - 30);
      arrowX = (0.75 * scaleWidth) + percent * (0.25 * scaleWidth);
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text('Công cụ tính chi số BMI',
            style: TextStyle(fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreens(),));
            },
            icon: Icon(
              Icons.cancel,
              size: 19,
              color: Colors.grey.withOpacity(0.8),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Chỉ số BMI của bạn là', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text(
              bmi.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(category, style: TextStyle(fontSize: 22, color: color)),
            SizedBox(height: 30),

            // thanh màu
            Stack(
              children: [
                Container(
                  height: 16,
                  width: scaleWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue,
                        Colors.green,
                        Colors.yellow,
                        Colors.orange,
                        Colors.red
                      ],
                      stops: [0.46, 0.575, 0.625, 0.75, 1],
                    ),
                  ),
                ),

                // Mũi tên
                Positioned(
                  left: arrowX.clamp(0, scaleWidth - 50),
                  top: -40,
                  child: Column(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          bmi.toStringAsFixed(1),
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Icon(Icons.arrow_drop_down,
                          size: 28, color: Colors.black),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 12),

            ///////////////////////
            Stack(
              children: [
                Container(width: scaleWidth, height: 20),
                Positioned(left: 0, child: Text('0')),
                Positioned(left: scaleWidth * 0.46 - 10, child: Text('18.5')),
                Positioned(left: scaleWidth * 0.575 - 10, child: Text('23')),
                Positioned(left: scaleWidth * 0.625 - 10, child: Text('25')),
                Positioned(left: scaleWidth * 0.75 - 10, child: Text('30+')),
              ],
            ),

            Spacer(),

            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.refresh),
              label: Text("Kiểm tra lại"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
