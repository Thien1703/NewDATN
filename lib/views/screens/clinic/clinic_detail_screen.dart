import 'package:flutter/material.dart';
import 'package:health_care/views/widgets/widget_header_body.dart';

class ClinicDetailScreen extends StatelessWidget {
  const ClinicDetailScreen({super.key, required this.clinicId});
  final int clinicId;

  @override
  Widget build(BuildContext context) {
    return WidgetHeaderBody(
        iconBack: true, title: 'Chi tiết bệnh viện', body: Text('data'));
  }
}
