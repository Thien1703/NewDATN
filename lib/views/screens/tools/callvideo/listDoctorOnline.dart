import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';

class Doctor {
  final String name;
  final String specialty;
  final double rating;

  Doctor({required this.name, required this.specialty, required this.rating});
}

class DoctorOnlineList extends StatelessWidget {
  DoctorOnlineList({super.key});

  final List<Doctor> doctors = [
    Doctor(name: "BS. Nguyễn Văn A", specialty: "Nội tổng quát", rating: 4.8),
    Doctor(name: "BS. Trần Thị B", specialty: "Da liễu", rating: 4.6),
    Doctor(name: "BS. Lê Văn C", specialty: "Nhi khoa", rating: 4.9),
    Doctor(name: "BS. Phạm Thị D", specialty: "Tim mạch", rating: 4.7),
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
              leading: const CircleAvatar(
                radius: 28,
                backgroundImage:
                    AssetImage('assets/images/doctor.png'), // thay hình nếu cần
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
                  // TODO: Điều hướng tới phòng khám hoặc form đặt lịch
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
