import 'package:flutter/material.dart';
import 'package:health_care/views/screens/appoinmentonline/detail_doctor.dart';

class Doctor {
  final String name;
  final String degree;
  final String specialty;
  final String clinic;
  final int fee;

  Doctor(this.name, this.degree, this.specialty, this.clinic, this.fee);
}

class DoctorListPage extends StatelessWidget {
  final List<Doctor> doctors = [
    Doctor('Trần Duy Viễn', 'BS.CKI', 'Đa khoa', 'Phòng khám Đa khoa Quốc tế Golden Health', 200000),
    Doctor('Phạm Hoàng Minh Nhựt', 'BS.CKI', 'Đa khoa', 'Phòng khám Đa khoa Quốc tế Golden Health', 200000),
    Doctor('Nguyễn Chí Thành', 'ThS.BS', 'Đa khoa', 'Phòng khám Đa khoa Quốc tế Golden Health', 200000),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE9F5FF),
      appBar: AppBar(
        title: Text('Danh sách bác sĩ'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: ListView.builder(
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          final doctor = doctors[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DoctorDetailPage(doctor: doctor),
                ),
              );
            },
            child: DoctorCard(doctor: doctor),
          );
        },
      ),
    );
  }
}

class DoctorCard extends StatelessWidget {
  final Doctor doctor;

  const DoctorCard({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundImage: AssetImage('assets/doctor_avatar.png'),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${doctor.degree} ${doctor.name}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      )),
                  SizedBox(height: 4),
                  Text(doctor.specialty, style: TextStyle(color: Colors.grey[700])),
                  SizedBox(height: 2),
                  Text(doctor.clinic,
                      style: TextStyle(fontSize: 13, color: Colors.black54),
                      overflow: TextOverflow.ellipsis),
                  SizedBox(height: 6),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text("Tư vấn trực tiếp",
                        style: TextStyle(color: Colors.green, fontSize: 12)),
                        
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Chip(
                        label: Text('Dành cho trẻ em', style: TextStyle(fontSize: 11)),
                        backgroundColor: const Color.fromARGB(255, 236, 237, 238),
                      ),
                      SizedBox(width: 4),
                      Chip(
                        label: Text('Dành cho người lớn', style: TextStyle(fontSize: 11)),
                        backgroundColor: const Color.fromARGB(255, 236, 237, 238),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.attach_money, size: 16, color: Colors.orange),
                      Text('Phí thăm khám cố định ',
                          style: TextStyle(color: Colors.grey[700], fontSize: 13)),
                      Text('${doctor.fee.toString()} đ',
                          style: TextStyle(color: Colors.green, fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
