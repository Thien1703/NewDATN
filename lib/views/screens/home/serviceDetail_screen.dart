import 'package:flutter/material.dart';
import 'package:health_care/views/widgets/widget_header_body.dart';

class ServicedetailScreen extends StatefulWidget {
  const ServicedetailScreen({super.key, required this.serviceId});
  final int serviceId;
  @override
  State<ServicedetailScreen> createState() => _ServicedetailScreen();
}

class _ServicedetailScreen extends State<ServicedetailScreen> {
  @override
  Widget build(BuildContext context) {
    return WidgetHeaderBody(
      iconBack: true,
      title: 'Dịch vụ',
      body: Text(widget.serviceId.toString()),
    );
  }
}
