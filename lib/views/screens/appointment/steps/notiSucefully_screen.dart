import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/views/screens/home/home_screens.dart';
import 'package:health_care/views/widgets/widget_lineBold.dart';
import 'package:qr_flutter/qr_flutter.dart';

class NotiSucefully extends StatefulWidget {
  const NotiSucefully({super.key});

  @override
  State<NotiSucefully> createState() => _NotiSucefullyState();
}

class _NotiSucefullyState extends State<NotiSucefully> {
  final String qrData = 'fsfsdfsfsfsf';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0F2F5),
        elevation: 0, // Bỏ đường viền dưới của AppBar
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreens(),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 40),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 25),
                        const Text(
                          'Đã đặt lịch',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.deepBlue,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '15:12:50 21/03/2025',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  child: Center(
                    child: CircleAvatar(
                      radius: 34,
                      backgroundColor: const Color.fromARGB(255, 184, 208, 235),
                      child: CircleAvatar(
                        radius: 26,
                        backgroundColor: AppColors.deepBlue,
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 15),
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            'STT',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '2',
                            style: TextStyle(
                              fontSize: 35,
                              color: AppColors.deepBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      QrImageView(
                        data: qrData,
                        version: QrVersions.auto,
                        size: 100,
                        gapless: false,
                      )
                    ],
                  ),
                  WidgetLineBold(),
                  Text('Phòng khám FPT'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
