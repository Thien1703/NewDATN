import 'package:flutter/material.dart';
import 'package:health_care/views/widgets/widget_header_body.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});
  @override
  State<NotificationScreen> createState() => _NotificationScreen();
}

class _NotificationScreen extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return WidgetHeaderBody(
      iconBack: false,
      title: 'Thông báo',
      body: Text('Thông báo ở đây nè'),
    );
  }
}
