import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/views/screens/notification/notification_screen.dart';

class BuildDraw extends StatefulWidget {
  const BuildDraw({super.key, required this.fullName});
  final String fullName;

  @override
  State<BuildDraw> createState() => _BuildDrawState();
}

class _BuildDrawState extends State<BuildDraw> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: AppColors.deepBlue),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person_2,
                    size: 50,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Xin chào, ${widget.fullName}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text('Thông báo'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationScreen(),
                  ));
            },
          ),
          ListTile(
            title: Text('Bệnh'),
            onTap: () {},
          ),
          ListTile(
            title: Text('Hệ thống nhà thuốc'),
            onTap: () {},
          ),
          ListTile(
            title: Text('Gói sức khỏe'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
