import 'package:flutter/material.dart';
import 'package:health_care/views/screens/appointment/appointment_screen.dart';
// import 'package:health_care/views/screens/appoinmentonline/book_doctor.dart';
import 'package:health_care/views/screens/appoinmentonline/doctors.dart';

void showBookingOptions(BuildContext context, {required int clinicId}) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    isScrollControlled: true,
    backgroundColor: Colors.white,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Bạn muốn đặt hẹn ...",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87)),
            SizedBox(height: 20),

            // Option 1
            _BookingOptionTile(
              iconPath: 'assets/ic_inperson.png', // thay icon bạn có
              title: 'Thăm khám trực tiếp',
              onTap: () async {
                Navigator.pop(context);
                await Future.delayed(Duration(milliseconds: 100));
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AppointmentScreen(clinicId: clinicId),
                  ),
                );
              },
            ),
            SizedBox(height: 12),

            // Option 2
            _BookingOptionTile(
              iconPath: 'assets/ic_video.png', // thay icon bạn có
              title: 'Tư vấn từ xa',
              onTap: () async {
                Navigator.pop(context);
                await Future.delayed(Duration(milliseconds: 100));
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DoctorListPage(),
                  ),
                );
              },
            ),
          ],
        ),
      );
    },
  );
}

class _BookingOptionTile extends StatelessWidget {
  final String iconPath;
  final String title;
  final VoidCallback onTap;

  const _BookingOptionTile({
    required this.iconPath,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Color(0xFFF8F8F8),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              backgroundImage: AssetImage(iconPath),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 16),
          ],
        ),
      ),
    );
  }
}
