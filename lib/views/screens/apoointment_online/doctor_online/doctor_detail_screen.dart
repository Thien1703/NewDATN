import 'package:flutter/material.dart';
import 'package:health_care/views/screens/apoointment_online/appointment_online_screen.dart';
import 'package:health_care/views/screens/apoointment_online/doctor_online/doctor_model.dart';
import 'package:health_care/views/screens/appointment/appointment_screen.dart';

class DoctorDetailScreen extends StatelessWidget {
  final Doctor doctor;

  const DoctorDetailScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chi tiết bác sĩ"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(doctor.avatar),
                onBackgroundImageError: (_, __) {},
              ),
            ),
            const SizedBox(height: 16),
            Text(
              doctor.fullName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Giới tính: ${doctor.gender == 'Male' ? 'Nam' : 'Nữ'}"),
            Text("Ngày sinh: ${doctor.birthDate}"),
            const SizedBox(height: 8),
            Text("Điện thoại: ${doctor.phoneNumber}"),
            const SizedBox(height: 8),
            Text("Phòng khám: ${doctor.clinic.name}"),
            const SizedBox(height: 8),
            Text(
              "Chuyên khoa: ${doctor.specialties.isEmpty ? 'Chưa có chuyên khoa' : doctor.specialties.map((s) => s.name).join(', ')}",
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AppointmentOnlineScreen(doctor: doctor),
                    ),
                  );
                },
                child: const Text("Đặt lịch ngay"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
