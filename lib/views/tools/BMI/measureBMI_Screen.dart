import 'package:flutter/material.dart';
import 'package:health_care/views/tools/BMI/bmi_result_screen.dart';

enum Gender { male, female }

class MeasurebmiScreen extends StatefulWidget {
  @override
  _MeasurebmiScreenState createState() => _MeasurebmiScreenState();
}

class _MeasurebmiScreenState extends State<MeasurebmiScreen> {
  Gender? selectedGender;
  String age = '';
  String height = '';
  String weight = '';

  bool get isFormValid =>
      selectedGender != null &&
      age.isNotEmpty &&
      height.isNotEmpty &&
      weight.isNotEmpty;

  InputDecoration customInputDecoration(String suffixText) {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      suffixText: suffixText,
      suffixStyle: TextStyle(fontSize: 16),
    );
  }

  Widget genderCard(Gender gender, String label, String assetPath) {
    bool isSelected = selectedGender == gender;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedGender = gender),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(
                color: isSelected ? Colors.blue : Colors.grey.shade300,
                width: 2),
            borderRadius: BorderRadius.circular(12),
            color: isSelected ? Colors.blue.shade50 : Colors.white,
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.transparent,
                child: Image.asset(assetPath,
                    width: 60,
                    height: 60,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.person)),
              ),
              SizedBox(height: 8),
              Text(label, style: TextStyle(fontSize: 16)),
              if (isSelected)
                Icon(Icons.check_circle, color: Colors.blue, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tính chỉ số BMI',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Giới tính của bạn', style: TextStyle(fontSize: 16)),
            SizedBox(height: 12),
            Row(
              children: [
                genderCard(Gender.male, 'Nam', 'assets/images/male.jpg'),
                SizedBox(width: 12),
                genderCard(Gender.female, 'Nữ', 'assets/images/female.jpg'),
              ],
            ),
            SizedBox(height: 20),
            Text('Bạn bao nhiêu tuổi?', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (val) => setState(() => age = val),
              decoration: customInputDecoration(''),
            ),
            SizedBox(height: 16),
            Text('Chiều cao của bạn (cm)', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (val) => setState(() => height = val),
              decoration: customInputDecoration('cm'),
            ),
            SizedBox(height: 16),
            Text('Cân nặng của bạn (kg)', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (val) => setState(() => weight = val),
              decoration: customInputDecoration('kg'),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isFormValid ? _showResult : null,
                child: Text('Xem kết quả', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isFormValid ? Colors.blue : Colors.grey.shade400,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showResult() {
    double h = double.tryParse(height) ?? 0;
    double w = double.tryParse(weight) ?? 0;
    if (h == 0 || w == 0) return;
    double bmi = w / ((h / 100) * (h / 100));

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BmiResultScreen(bmi: bmi),
      ),
    );
  }
}
