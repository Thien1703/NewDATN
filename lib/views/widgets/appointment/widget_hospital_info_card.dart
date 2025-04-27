import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/models/clinic.dart';
import 'package:health_care/viewmodels/api/clinic_api.dart';
import 'package:shimmer/shimmer.dart';

class HospitalInfoWidget extends StatefulWidget {
  const HospitalInfoWidget({
    super.key,
    required this.clinic,
  });

  final Clinic clinic;

  @override
  State<HospitalInfoWidget> createState() => _HospitalInfoWidgetState();
}

class _HospitalInfoWidgetState extends State<HospitalInfoWidget> {
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
            widget.clinic?.name ?? 'Không xác định',
            style: const TextStyle(
              fontSize: 16.5,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            widget.clinic?.address ?? 'Không xác định',
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 130, 128, 128),
            ),
          ),
        ],
      ),
    );
  }
}
