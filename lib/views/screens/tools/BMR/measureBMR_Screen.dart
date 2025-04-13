import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/views/screens/tools/BMI/bmi_result_screen.dart';
import 'package:health_care/views/screens/tools/BMR/bmr_result_screen.dart';
import '../gender_enum.dart';

class MeasurebmrScreen extends StatefulWidget {
  const MeasurebmrScreen({super.key});

  @override
  _MeasurebmrScreenState createState() => _MeasurebmrScreenState();
}

class _MeasurebmrScreenState extends State<MeasurebmrScreen> {
  Gender? selectedGender;
  String age = '';
  String height = '';
  String weight = '';

  bool get isFormValid {
    final h = double.tryParse(height) ?? 0;
    final w = double.tryParse(weight) ?? 0;
    final a = int.tryParse(age) ?? 0;
    return selectedGender != null && a > 0 && h > 0 && w > 0;
  }

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
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected
                  ? AppColors.deepBlue
                  : Colors.black.withOpacity(0.1),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.transparent,
                child: Image.asset(assetPath,
                    width: 80,
                    height: 80,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.person)),
              ),
              SizedBox(height: 8),
              Text(label, style: TextStyle(fontSize: 16)),
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
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios)),
        title: Text('Tính chỉ số BMR',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        height: double.infinity,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Giới tính của bạn',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              SizedBox(height: 12),
              Row(
                children: [
                  genderCard(Gender.male, 'Nam', 'assets/images/person1.jpg'),
                  SizedBox(width: 12),
                  genderCard(Gender.female, 'Nữ', 'assets/images/person2.jpg'),
                ],
              ),
              SizedBox(height: 20),
              _buildInputField('Bạn bao nhiêu tuổi?', '', (val) => age = val),
              _buildInputField(
                  'Chiều cao của bạn (cm)', 'cm', (val) => height = val),
              _buildInputField(
                  'Cân nặng của bạn (kg)', 'kg', (val) => weight = val),
              SizedBox(height: 80),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isFormValid ? _showResult : null,
                  child: Text('Xem kết quả',
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isFormValid
                        ? AppColors.deepBlue
                        : AppColors.deepBlue.withOpacity(0.5),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
      String label, String suffix, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        SizedBox(height: 8),
        TextField(
          keyboardType: TextInputType.number,
          onChanged: (val) => setState(() => onChanged(val)),
          decoration: customInputDecoration(suffix).copyWith(
            contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
          ),
          style: TextStyle(fontSize: 17),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  void _showResult() {
    if (selectedGender == null) return;

    double h = double.tryParse(height) ?? 0;
    double w = double.tryParse(weight) ?? 0;
    int a = int.tryParse(age) ?? 0;

    if (h == 0 || w == 0 || a == 0) return;

    double bmr;
    if (selectedGender == Gender.male) {
      bmr = 66.5 + (13.75 * w) + (5 * h) - (6.75 * a);
    } else {
      bmr = 655.1 + (9.563 * w) + (1.850 * h) - (4.676 * a);
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BmrResultScreen(
          bmr: bmr,
          gender: selectedGender!,
        ),
      ),
    );
  }
}
