import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';

class WidgetLineBold extends StatelessWidget {
  const WidgetLineBold({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(23, (index) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 15),
          width: 7,
          height: 1.5,
          color: AppColors.neutralGrey2,
        );
      }),
    );
  }
}
