// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:health_care/common/app_colors.dart';

// class BmiScreen extends StatefulWidget {
//   const BmiScreen({super.key});

//   @override
//   State<BmiScreen> createState() => _BmiScreenState();
// }

// class _BmiScreenState extends State<BmiScreen> {
//   final TextEditingController _heightController = TextEditingController();
//   final TextEditingController _weightController = TextEditingController();
//   double? _bmi;
//   String _status = "";

//   @override
//   void initState() {
//     super.initState();
//     _loadSavedData();
//   }

//   Future<void> _loadSavedData() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _heightController.text = prefs.getString('height') ?? '';
//       _weightController.text = prefs.getString('weight') ?? '';
//       _bmi = prefs.getDouble('bmi');
//       _status = prefs.getString('status') ?? '';
//     });
//   }

//   Future<void> _saveData(double bmi, String status) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('height', _heightController.text);
//     await prefs.setString('weight', _weightController.text);
//     await prefs.setDouble('bmi', bmi);
//     await prefs.setString('status', status);
//   }

//   void _calculateBMI() {
//     double height = double.tryParse(_heightController.text) ?? 0;
//     double weight = double.tryParse(_weightController.text) ?? 0;

//     if (height > 0 && weight > 0) {
//       double bmi = weight / ((height / 100) * (height / 100));
//       String status = _getBmiStatus(bmi);
//       setState(() {
//         _bmi = bmi;
//         _status = status;
//       });
//       _saveData(bmi, status); // Lưu lại dữ liệu khi tính toán
//     }
//   }

//   String _getBmiStatus(double bmi) {
//     if (bmi < 18.5) return "Gầy (Thiếu cân)";
//     if (bmi < 24.9) return "Bình thường";
//     if (bmi < 29.9) return "Thừa cân";
//     if (bmi < 34.9) return "Béo phì độ 1";
//     if (bmi < 39.9) return "Béo phì độ 2";
//     return "Béo phì độ 3";
//   }

//   Color _getStatusColor(double bmi) {
//     if (bmi < 18.5) return Colors.blue;
//     if (bmi < 24.9) return Colors.green;
//     if (bmi < 29.9) return Colors.orange;
//     return Colors.red;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             borderRadius:
//                 const BorderRadius.vertical(bottom: Radius.circular(25)),
//             gradient: const LinearGradient(
//               colors: [Color(0xFF4CAF50), Color(0xFF1B5E20)],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//             boxShadow: [
//               BoxShadow(
//                   color: Colors.black.withOpacity(0.2),
//                   blurRadius: 8,
//                   offset: const Offset(0, 3)),
//             ],
//           ),
//         ),
//         title: const Text("Chỉ số BMI của bạn",
//             style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 22,
//                 letterSpacing: 1.2)),
//         centerTitle: true,
//         leading: IconButton(
//             icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
//             onPressed: () => Navigator.pop(context)),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const Icon(Icons.monitor_weight, size: 80, color: Colors.blueGrey),
//             const SizedBox(height: 10),
//             const Text("Nhập chiều cao và cân nặng của bạn",
//                 style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black54)),
//             const SizedBox(height: 20),
//             _buildTextField("Chiều cao (cm)", _heightController, Icons.height),
//             const SizedBox(height: 10),
//             _buildTextField(
//                 "Cân nặng (kg)", _weightController, Icons.fitness_center),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _calculateBMI,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.accent,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10)),
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
//               ),
//               child: const Text("Tính BMI",
//                   style: TextStyle(fontSize: 16, color: Colors.white)),
//             ),
//             const SizedBox(height: 20),
//             if (_bmi != null) _buildResultSection(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(
//       String label, TextEditingController controller, IconData icon) {
//     return TextField(
//       controller: controller,
//       keyboardType: TextInputType.number,
//       decoration: InputDecoration(
//         labelText: label,
//         prefixIcon: Icon(icon, color: AppColors.accent),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//         filled: true,
//         fillColor: Colors.grey[100],
//       ),
//     );
//   }

//   Widget _buildResultSection() {
//     return Container(
//       padding: const EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         color: _getStatusColor(_bmi!),
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Column(
//         children: [
//           const Text("Chỉ số BMI của bạn",
//               style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white)),
//           const SizedBox(height: 5),
//           Text(_bmi!.toStringAsFixed(2),
//               style: const TextStyle(
//                   fontSize: 32,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white)),
//           const SizedBox(height: 5),
//           Text(_status,
//               style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white)),
//         ],
//       ),
//     );
//   }
// }

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
