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
          Row(
            children: [
              Icon(
                Icons.local_hospital,
                size: 23,
                color: Colors.blue,
              ),
              SizedBox(width: 10),
              Text(
                clinices?.name ?? 'Không xác định',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neutralDarkGreen1,
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: 20,
                color: const Color.fromARGB(255, 255, 58, 58),
              ),
              SizedBox(width: 10),
              Expanded(
                // Sử dụng Expanded để chữ chiếm hết không gian còn lại
                child: Text(
                  clinices?.address ?? 'Không xác định',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.neutralGrey3,
                  ),
                  maxLines: 1, // Giới hạn chữ chỉ hiển thị 1 dòng
                  overflow: TextOverflow
                      .ellipsis, // Cắt chữ khi dài và hiển thị "..."
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
