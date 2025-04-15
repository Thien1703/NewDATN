import 'package:flutter/material.dart';
import 'package:health_care/views/screens/tools/BMI/BMI_screen.dart';
import 'package:health_care/views/screens/tools/BMR/BMR_screen.dart';
import 'package:health_care/views/screens/tools/callvideo/schedule_call_screen.dart';
import 'package:health_care/views/widgets/widget_header_body.dart';

class ToolsScreen extends StatefulWidget {
  const ToolsScreen({super.key});

  @override
  State<ToolsScreen> createState() => _ToolsScreen();
}

class _ToolsScreen extends State<ToolsScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return WidgetHeaderBody(
      iconBack: false,
      title: 'Công cụ sức khỏe',
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Công cụ tính nhanh',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Kiểm tra nhanh các chỉ số sức khỏe',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: screenWidth > 600 ? 3 : 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 1.2,
              children: [
                _buildSelected('assets/images/image2.jpg', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BmiScreen()),
                  );
                }),
                _buildSelected('assets/images/image1.jpg', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BmrScreen()),
                  );
                }),
                _buildSelected('assets/images/image3.jpg', () {}),
                _buildSelected('assets/images/image4.jpg', () {}),
                _buildSelected('assets/images/callvideo.png', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ScheduleCallScreen()),
                  );
                }),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSelected(String image, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
