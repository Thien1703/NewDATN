import 'package:flutter/material.dart';

import 'package:health_care/views/screens/appoinmentonline/doctors.dart';
import 'package:health_care/views/screens/appoinmentonline/book_doctor.dart';

class DoctorDetailPage extends StatelessWidget {
  final Doctor doctor;

  const DoctorDetailPage({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "${doctor.degree} ${doctor.name}",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/doctor_avatar.png'),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                '${doctor.degree} ${doctor.name}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 4),
            Center(
              child: Text('${doctor.specialty}', style: TextStyle(color: Colors.grey[600])),
            ),
            SizedBox(height: 8),
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Tư vấn trực tiếp & Tư vấn từ xa",
                  style: TextStyle(color: Colors.blue, fontSize: 12),
                ),
              ),
            ),
            SizedBox(height: 16),
            _infoRow(Icons.money, 'Phí thăm khám cố định', '${doctor.fee} đ', color: Colors.green),
            _infoRow(Icons.location_on_outlined, 'Địa chỉ',
                '29 Đường số 2, Phường 6, Quận 8, TP Hồ Chí Minh'),
            SizedBox(height: 20),

            // Thế mạnh chuyên môn
            Text('🩺 Thế mạnh chuyên môn', style: _sectionTitleStyle()),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: -8,
              children: [
                'Tim mạch',
                'Các bệnh lý Nội Tim mạch',
                'Cơ - Xương - Khớp',
                'Tiểu đường',
                'Lão khoa',
              ]
                  .map((tag) => Chip(
                        label: Text(tag),
                        backgroundColor: Colors.grey[200],
                      ))
                  .toList(),
            ),
            SizedBox(height: 24),

            // Giờ làm việc
            Text('🕒 Giờ làm việc', style: _sectionTitleStyle()),
            SizedBox(height: 8),
            _workTimeRow('Thứ Hai - Thứ Sáu', '17:00 - 20:00'),
            _workTimeRow('Thứ Bảy', '07:00 - 11:30 • 17:00 - 20:00'),
            SizedBox(height: 24),

            // Hình thức thanh toán
            Text('💳 Hình thức thanh toán', style: _sectionTitleStyle()),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _paymentMethod(Icons.money, 'Tiền mặt'),
                _paymentMethod(Icons.phone_android, 'Thanh toán\ntrực tuyến'),
              ],
            ),
            SizedBox(height: 24),

            // Button đặt lịch
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BookDoctor()),
                  );
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                child: Text(
                  'Đặt lịch hẹn',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  TextStyle _sectionTitleStyle() => TextStyle(fontSize: 16, fontWeight: FontWeight.w600);

  Widget _infoRow(IconData icon, String title, String value, {Color color = Colors.black87}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange, size: 20),
          SizedBox(width: 8),
          Text('$title: ',
              style: TextStyle(fontSize: 14, color: Colors.grey[800])),
          Expanded(
            child: Text(value,
                style: TextStyle(fontSize: 14, color: color),
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  Widget _workTimeRow(String day, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.calendar_today_outlined, size: 18, color: Colors.blue),
          SizedBox(width: 8),
          Text(day, style: TextStyle(fontSize: 14)),
          Spacer(),
          Text(time, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _paymentMethod(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 30, color: Colors.blue),
        SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13),
        ),
      ],
    );
  }
}
