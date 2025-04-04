import 'package:flutter/material.dart';
import 'package:health_care/views/widgets/widget_header_body.dart';

class StarScreen extends StatefulWidget {
  const StarScreen({super.key});
  @override
  State<StarScreen> createState() => _StarScreen();
}

class _StarScreen extends State<StarScreen> {
  @override
  Widget build(BuildContext context) {
    return WidgetHeaderBody(
      iconBack: true,
      title: 'Đánh giá dịch vụ',
      body: Text('data'),
    );
  }
}
