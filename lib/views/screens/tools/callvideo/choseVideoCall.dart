import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/views/screens/apoointment_online/doctor_online/doctor_list_screen.dart';
import 'package:health_care/views/screens/auth/Login/login_screen.dart';
import 'package:health_care/views/screens/auth/Login/register_screen.dart';
import 'package:health_care/views/screens/tools/callvideo/app_data.dart';
import 'package:health_care/views/screens/tools/callvideo/listDoctorOnline.dart';
import 'package:health_care/views/screens/tools/callvideo/schedule_call_screen.dart';

final roomCode = AppData.roomCode;

class chooseCallVideo extends StatelessWidget {
  const chooseCallVideo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.deepBlue,
              Color.fromARGB(255, 106, 168, 231)
            ], // Màu bắt đầu và kết thúc
            begin: Alignment.topLeft, // Hướng bắt đầu
            end: Alignment.bottomRight, // Hướng kết thúc
          ),
        ),
        child: Column(children: [
          const Padding(
            padding: EdgeInsets.only(top: 150.0),
            child: Image(
              image: AssetImage('assets/images/logoDATN.png'),
              height: 60,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(
            height: 70,
          ),

          const SizedBox(
            height: 60,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DoctorListScreen()));
            },
            child: Container(
              height: 53,
              width: 320,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white),
              ),
              child: const Center(
                child: Text(
                  'Đặt lịch ngay',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ScheduleCallScreen()));
            },
            child: Container(
              height: 53,
              width: 320,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white),
              ),
              child: const Center(
                child: Text(
                  'Vào phòng khám',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ),
          const Spacer(),
          if (roomCode != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text(
                'Bạn có lịch đặt khám online với mã phòng là: $roomCode',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          const Text(
            'Chào mừng bạn đến với phòng khám online',
            style: TextStyle(fontSize: 17, color: Colors.white),
          ), //
          const SizedBox(
            height: 12,
          ),
          // const Image(image: AssetImage('assets/social.png'))
        ]),
      ),
    );
  }
}
