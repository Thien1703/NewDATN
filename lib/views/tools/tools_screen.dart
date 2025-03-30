import 'package:flutter/material.dart';
import 'package:health_care/views/tools/BMI/BMI_screen.dart';
import 'package:health_care/views/tools/BMI/measureBMI_Screen.dart';
import 'package:health_care/views/widgets/widget_header_body.dart';

class ToolsScreen extends StatefulWidget {
  const ToolsScreen({Key? key}) : super(key: key);

  @override
  State<ToolsScreen> createState() => _ToolsScreen();
}

class _ToolsScreen extends State<ToolsScreen> {
  @override
  Widget build(BuildContext context) {
    return WidgetHeaderBody(
      iconBack: false,
      title: 'Công cụ sức khỏe',
      body: Container(
        color: Colors.white,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Công cụ tính nhanh',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Kiểm tra nhanh các chỉ số sức khỏe',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSelected('assets/images/image2.jpg', () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BmiScreen(),
                        ));
                  }),
                  _buildSelected('assets/images/image1.jpg', () {}),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSelected('assets/images/image3.jpg', () {}),
                  _buildSelected('assets/images/image4.jpg', () {}),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelected(String image, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Image.asset(
        image,
        width: 170,
      ),
    );
  }
}
