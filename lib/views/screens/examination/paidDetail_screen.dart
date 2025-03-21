import 'package:flutter/material.dart';
import 'package:health_care/views/widgets/widget_header_body.dart';

class PaidDetailScreen extends StatefulWidget {
  @override
  State<PaidDetailScreen> createState() => _PaidDetailScreen();
}

class _PaidDetailScreen extends State<PaidDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return WidgetHeaderBody(
      iconBack: true,
      title: 'Phiếu khám',
      body: Container(
        child: Text('data'),
      ),
    );
  }
}
