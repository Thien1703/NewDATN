import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';

class HospitalInfoWidget extends StatelessWidget {
  const HospitalInfoWidget({
    super.key,
    required this.nameHospital,
    required this.addressHospital,
  });
  final String nameHospital;
  final String addressHospital;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.accent, width: 1.5),
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(nameHospital,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.neutralDarkGreen1,
              )),
          Text(addressHospital,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: AppColors.neutralGrey3,
              )),
        ],
      ),
    );
  }
}
