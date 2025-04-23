import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/views/screens/chatbot/botchat.dart';
import 'package:health_care/views/screens/clinic/clinic_screen.dart';
import 'package:health_care/views/screens/examination/examination_screen.dart';
import 'package:health_care/views/screens/home/home_screens.dart';
import 'package:health_care/views/screens/map/searchMap.dart';
import 'package:health_care/views/screens/notification/notification_screen.dart';
import 'package:health_care/views/screens/tools/BMI/BMI_screen.dart';
import 'package:health_care/views/screens/tools/BMR/BMR_screen.dart';
import 'package:health_care/views/screens/tools/callvideo/choseVideoCall.dart';
import 'package:url_launcher/url_launcher.dart';

class BuildDraw extends StatefulWidget {
  const BuildDraw(
      {super.key,
      required this.fullName,
      required this.image,
      required this.phone});
  final String fullName;
  final String image;
  final String phone;

  @override
  State<BuildDraw> createState() => _BuildDrawState();
}

class _BuildDrawState extends State<BuildDraw> {
  bool isExpanded = false;
  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print("Không thể mở đường dẫn: $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            margin: EdgeInsets.only(left: 15, right: 15, top: 25, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: Image.asset(
                            'assets/images/logoFptne.png',
                            width: 50,
                          ),
                        ),
                        SizedBox(width: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PHÒNG KHÁM',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.deepBlue,
                              ),
                            ),
                            Text(
                              'ĐA KHOA FPT',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: AppColors.deepBlue,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.close,
                        size: 25,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreens(
                    inttialIndex: 4,
                  ),
                )),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                AppColors.deepBlue,
                AppColors.deepBlue.withOpacity(0.6)
              ])),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: widget.image.startsWith('htpp')
                        ? NetworkImage(widget.image)
                        : AssetImage(widget.image) as ImageProvider,
                  ),
                  SizedBox(width: 10),
                  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.fullName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.phone,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle('Thông báo', () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationScreen(),
                      ));
                }),
                // _buildTitle('Xem chuyên khoa', () {}),
                ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: Text(
                    'Đặt khám',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isExpanded ? AppColors.deepBlue : Colors.black,
                    ),
                  ),
                  children: [
                    ListTile(
                      title: Text(
                        'Đặt khám tại phòng khám',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ClinicScreen(),
                          )),
                    ),
                    ListTile(
                      title: Text(
                        'Đặt khám online',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => chooseCallVideo(),
                          )),
                    )
                  ],
                  onExpansionChanged: (expanded) {
                    setState(() {
                      isExpanded = expanded;
                    });
                  },
                ),
                _buildTitle('Hệ thống nhà thuốc', () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchScreen(),
                      ));
                }),
                _buildTitle('Chat với AI', () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatBotScreen(),
                      ));
                }),
                ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: Text(
                    'Đo chỉ số',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isExpanded ? AppColors.deepBlue : Colors.black,
                    ),
                  ),
                  children: [
                    ListTile(
                      title: Text(
                        'Đo BMI',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BmiScreen(),
                          )),
                    ),
                    ListTile(
                      title: Text(
                        'Đo BMR',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BmrScreen(),
                          )),
                    )
                  ],
                  onExpansionChanged: (expanded) {
                    setState(() {
                      isExpanded = expanded;
                    });
                  },
                ),
                _buildTitle('Xem lịch khám', () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>HomeScreens(inttialIndex: 1,),
                      ));
                }),
                _buildTitle(
                    'CSKH', () => _launchURL('https://zalo.me/0917107881')),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTitle(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 15),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
