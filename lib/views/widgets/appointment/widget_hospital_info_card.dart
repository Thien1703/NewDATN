import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/config/app_config.dart';
import 'package:health_care/models/clinic.dart';
import 'package:health_care/viewmodels/api/clinic_api.dart';

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
    Clinic? data = await ClinicApi.getClinicById(widget.clinicId);
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
        border: Border.all(color: AppColors.deepBlue, width: 1.5),
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
              color: Colors.black,
            ),
          ),
          SizedBox(height: 5),
          Text(
            clinices?.address ?? 'Không xác định',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: const Color.fromARGB(255, 130, 128, 128),
            ),
          ),
        ],
      ),
    );
  }
}
