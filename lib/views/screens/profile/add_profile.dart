import 'package:flutter/material.dart';
import 'package:health_care/views/widgets/widget_header_body.dart';

class AddProfile extends StatefulWidget {
  const AddProfile({super.key});

  @override
  State<AddProfile> createState() => _AddProfileState();
}

class _AddProfileState extends State<AddProfile> {
  @override
  Widget build(BuildContext context) {
    return WidgetHeaderBody(
      iconBack: true,
      title: 'Thêm hồ sơ đặt khám',
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
        ),
      ),
    );
  }
}
