import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/views/screens/tools/callvideo/bookOnline.dart';
import 'package:health_care/views/screens/tools/callvideo/doctorOnLineModel.dart';

class DoctorOnlineList extends StatelessWidget {
  DoctorOnlineList({super.key});

  final List<Doctor> doctors = [
    Doctor(
      name: "BS. Nguyễn Văn Anh",
      specialty: "Nội tổng quát",
      rating: 4.8,
      imagePath: 'assets/images/bacsi1.jpg',
    ),
    Doctor(
      name: "BS. Trần Thị Lan",
      specialty: "Da liễu",
      rating: 4.6,
      imagePath: 'assets/images/bacsi3.jpg',
    ),
    Doctor(
      name: "BS. Lê Văn Hải",
      specialty: "Nhi khoa",
      rating: 4.9,
      imagePath: 'assets/images/bacsi2.jpg',
    ),
    Doctor(
      name: "BS. Phạm Hùng Chiến",
      specialty: "Tim mạch",
      rating: 4.7,
      imagePath: 'assets/images/bacsi4.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bác sĩ đang online',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: AppColors.deepBlue,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          final doctor = doctors[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: CircleAvatar(
                radius: 28,
                backgroundImage: AssetImage(doctor.imagePath),
              ),
              title: Text(
                doctor.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                  '${doctor.specialty}\n⭐ ${doctor.rating.toStringAsFixed(1)} / 5'),
              isThreeLine: true,
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookingOnlineScreen(doctor: doctor),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.deepBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Đặt lịch",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
