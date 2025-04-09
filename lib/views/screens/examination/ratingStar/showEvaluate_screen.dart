import 'package:flutter/material.dart';
import 'package:health_care/views/widgets/widget_header_body.dart';

class ShowevaluateScreen extends StatefulWidget {
  const ShowevaluateScreen({super.key});
  @override
  State<ShowevaluateScreen> createState() => _ShowevaluateScreen();
}

class _ShowevaluateScreen extends State<ShowevaluateScreen> {
  @override
  Widget build(BuildContext context) {
    return WidgetHeaderBody(
      iconBack: true,
      title: 'Chi tiết đánh giá',
      body: Text('data'),
    );
  }
}
