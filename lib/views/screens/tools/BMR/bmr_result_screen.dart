import 'package:flutter/material.dart';
import 'package:health_care/views/screens/home/home_screens.dart';
import 'package:health_care/views/screens/tools/gender_enum.dart';

class BmrResultScreen extends StatelessWidget {
  final double bmr;
  final Gender gender;

  BmrResultScreen({required this.bmr, required this.gender});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Công cụ tính chỉ số BMR'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
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
      body: Column(
        children: [
          Text(
            'Chỉ số BMR của bạn là: ${bmr.toStringAsFixed(2)} kcal/ngày',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
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
    );
  }
}
