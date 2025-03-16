import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/config/app_config.dart';
import 'package:health_care/models/clinic.dart';

class HospitalInfoWidget extends StatefulWidget {
  const HospitalInfoWidget({
    super.key,
    required this.clinicId,
  });
  final int clinicId;

  @override
  State<HospitalInfoWidget> createState() => _HospitalInfoWidgetState();
}

class _HospitalInfoWidgetState extends State<HospitalInfoWidget> {
  Clinic? clinices;
  @override
  void initState() {
    super.initState();
    fetchClinics();
  }

  void fetchClinics() async {
    Clinic? data = await AppConfig.getClinicById(widget.clinicId);
    if (data != null) {
      setState(() {
        clinices = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.accent, width: 1.5),
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            clinices?.name ?? 'Không xác định',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.neutralDarkGreen1,
            ),
          ),
          Text(
            clinices?.address ?? 'Không xác định',
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: AppColors.neutralGrey3,
            ),
          ),
        ],
      ),
    );
  }
}
