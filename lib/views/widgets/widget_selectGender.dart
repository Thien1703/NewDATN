import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/common/app_icons.dart';

class WidgetSelectGender extends StatefulWidget {
  final String? initialGender; // Giới tính ban đầu (có thể null)
  final Function(String) onChanged; // Callback khi chọn giới tính

  const WidgetSelectGender({
    super.key,
    this.initialGender,
    required this.onChanged,
  });

  @override
  State<WidgetSelectGender> createState() => _WidgetSelectGenderState();
}

class _WidgetSelectGenderState extends State<WidgetSelectGender> {
  late String selectedGender;

  @override
  void initState() {
    super.initState();
    selectedGender = widget.initialGender ?? 'Giới tính'; // Giá trị mặc định
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showGenderSelectionSheet(context),
      child: Container(
        width: 160,
        height: 43,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.neutralGrey2, width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedGender,
              style: const TextStyle(fontSize: 16),
            ),
            const Icon(Icons.keyboard_arrow_right_sharp),
          ],
        ),
      ),
    );
  }

  void _showGenderSelectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _customLineBold(),
              _customTitleGender(context),
              _customButtonSelectedGender(
                gender: 'Nam',
                isSelected: selectedGender == 'Nam',
                onPressed: () => _selectGender('Nam', context),
              ),
              _customButtonSelectedGender(
                gender: 'Nữ',
                isSelected: selectedGender == 'Nữ',
                onPressed: () => _selectGender('Nữ', context),
              ),
            ],
          ),
        );
      },
    );
  }

  void _selectGender(String gender, BuildContext context) {
    setState(() {
      selectedGender = gender;
    });
    widget.onChanged(gender); // Gửi giá trị giới tính ra ngoài
    Navigator.pop(context);
  }

  Widget _customButtonSelectedGender({
    required String gender,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: isSelected ? AppColors.accent : AppColors.neutralGrey2,
              width: 1.5,
            ),
            backgroundColor: isSelected ? AppColors.accent.withOpacity(0.2) : Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                gender,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? AppColors.accent : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _customLineBold() {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      width: 100,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.neutralGrey2,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _customTitleGender(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: Image.asset(AppIcons.cancel, width: 15),
          ),
        ),
        const Text(
          'Giới tính',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
