import 'package:flutter/material.dart';
import 'package:health_care/views/screens/apoointment_online/doctor_online/doctor_api.dart';
import 'package:health_care/views/screens/apoointment_online/doctor_online/doctor_detail_screen.dart';
import 'package:health_care/views/screens/apoointment_online/doctor_online/doctor_model.dart';

class DoctorListScreen extends StatefulWidget {
  const DoctorListScreen({super.key});

  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  late Future<List<Doctor>> _futureDoctors;

  @override
  void initState() {
    super.initState();
    _futureDoctors = DoctorApi.getAllOnlineDoctors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh sách bác sĩ online"),
      ),
      body: FutureBuilder<List<Doctor>>(
        future: _futureDoctors,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Lỗi: ${snapshot.error}"));
          }

          final doctors = snapshot.data ?? [];

          if (doctors.isEmpty) {
            return const Center(child: Text("Không có bác sĩ nào."));
          }

          return ListView.builder(
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              final doctor = doctors[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(doctor.avatar),
                    onBackgroundImageError: (_, __) {},
                  ),
                  title: Text(doctor.fullName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Phòng khám: ${doctor.clinic.name}"),
                      Text(
                          "Chuyên khoa: ${doctor.specialties.map((s) => s.name).join(', ')}"),
                    ],
                  ),
                  isThreeLine: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DoctorDetailScreen(doctor: doctor),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
