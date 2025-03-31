import 'package:flutter/material.dart';
import 'package:health_care/views/screens/tools/gender_enum.dart';

class BmrResultScreen extends StatelessWidget {
  final double bmr;
  final Gender gender;

  BmrResultScreen({required this.bmr, required this.gender});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kết quả BMR')),
      body: Center(
        child: Text(
          'Chỉ số BMR của bạn là: ${bmr.toStringAsFixed(2)} kcal/ngày',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
