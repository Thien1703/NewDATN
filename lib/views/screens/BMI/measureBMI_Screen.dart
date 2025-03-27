
import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/views/screens/BMI/detail_measureBMI_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BmiScreen extends StatefulWidget {
  const BmiScreen({super.key});

  @override
  _BMIPageState createState() => _BMIPageState();
}

class _BMIPageState extends State<BmiScreen> {
  double height = 165.0;
  double weight = 62.0;
  String gender = 'Nam';

  double bmi = 0.0;
  String bmiResult = '';

  // Method to calculate BMI
  void calculateBMI() {
    setState(() {
      bmi = weight / (height / 100 * height / 100);
      if (bmi < 16) {
        bmiResult = 'Gầy độ III';
      } else if (bmi >= 16 && bmi < 17) {
        bmiResult = 'Gầy độ II';
      } else if (bmi >= 17 && bmi < 18.5) {
        bmiResult = 'Gầy độ I';
      } else if (bmi >= 18.5 && bmi < 25) {
        bmiResult = 'Bình thường';
      } else if (bmi >= 25 && bmi < 30) {
        bmiResult = 'Thừa cân';
      } else if (bmi >= 30 && bmi < 35) {
        bmiResult = 'Béo phì độ I';
      } else if (bmi >= 35 && bmi < 40) {
        bmiResult = 'Béo phì độ II';
      } else {
        bmiResult = 'Béo phì độ III';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Đo Chỉ Số BMI - Chiều Cao (BMI)'),
      ),
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: screenHeight,
              width: screenWidth,
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.accent,
                    Colors.white,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.08),
                  SizedBox(height: screenHeight * 0.04),
                  SizedBox(height: screenHeight * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        width: screenWidth * 0.4,
                        height: screenHeight * 0.2,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue, width: 2),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Icon(
                                  Icons.male,
                                  color: gender == 'Nam'
                                      ? Colors.blue
                                      : Colors.grey,
                                  size: 50,
                                ),
                                SizedBox(height: 5),
                                Radio<String>(
                                  value: 'Nam',
                                  groupValue: gender,
                                  onChanged: (value) {
                                    setState(() {
                                      gender = value!;
                                    });
                                  },
                                  activeColor: Colors.blue,
                                ),
                                Text(
                                  'Nam',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: gender == 'Nam'
                                        ? Colors.blue
                                        : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 20),
                            Column(
                              children: [
                                Icon(
                                  Icons.female,
                                  color: gender == 'Nữ'
                                      ? Colors.blue
                                      : Colors.grey,
                                  size: 50,
                                ),
                                SizedBox(height: 5),
                                Radio<String>(
                                  value: 'Nữ',
                                  groupValue: gender,
                                  onChanged: (value) {
                                    setState(() {
                                      gender = value!;
                                    });
                                  },
                                  activeColor: Colors.blue,
                                ),
                                Text(
                                  'Nữ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: gender == 'Nữ'
                                        ? Colors.blue
                                        : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // if (gender.isEmpty)
                      //   Padding(
                      //     padding: const EdgeInsets.only(top: 16.0),
                      //     child: Text(
                      //       'Chưa chọn giới tính của bạn',
                      //       style: TextStyle(
                      //         color: Colors.red,
                      //         fontSize: 16,
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      //     ),
                      //   ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Chiều cao của bạn: ',
                          style: TextStyle(
                              color: const Color.fromARGB(255, 23, 86, 137),
                              fontSize: 19,
                              fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: '${height.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' cm',
                          style: TextStyle(
                              color: const Color.fromARGB(255, 23, 86, 137),
                              fontSize: 19,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Slider(
                    value: height,
                    min: 100,
                    max: 250,
                    divisions: 150,
                    label: height.round().toString(),
                    onChanged: (double newHeight) {
                      setState(() {
                        height = newHeight;
                      });
                    },
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Cân nặng của bạn: ',
                          style: TextStyle(
                              color: const Color.fromARGB(255, 23, 86, 137),
                              fontSize: 19,
                              fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: '${weight.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' kg',
                          style: TextStyle(
                              color: const Color.fromARGB(255, 23, 86, 137),
                              fontSize: 19,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Slider(
                    value: weight,
                    min: 30,
                    max: 200,
                    divisions: 170,
                    label: weight.round().toString(),
                    onChanged: (double newWeight) {
                      setState(() {
                        weight = newWeight;
                      });
                    },
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: calculateBMI,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 151, 181, 206),
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.02,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          minimumSize: Size(
                            screenWidth * 0.4,
                            screenHeight * 0.07,
                          ),
                        ),
                        child: Text(
                          'Xem kết quả',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.065,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailMeasurebmiScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.02,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          minimumSize: Size(
                            screenWidth * 0.4,
                            screenHeight * 0.07,
                          ),
                        ),
                        child: Text(
                          'Xem chi tiết',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 151, 181, 206),
                            fontSize: screenWidth * 0.065,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  if (bmi != 0.0)
                    Column(
                      children: [
                        Text(
                          'Kết quả BMI của bạn: ${bmi.toStringAsFixed(1)}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Text(
                          'Nhận xét BMI của bạn: $bmiResult',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth * 0.04,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
