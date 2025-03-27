import 'package:flutter/material.dart';
import 'package:health_care/views/widgets/widget_header_body.dart';

class ToolsScreen extends StatefulWidget {
  const ToolsScreen({super.key});

  @override
  State<ToolsScreen> createState() => _ToolsScreen();
}

class _ToolsScreen extends State<ToolsScreen> {
  @override
  Widget build(BuildContext context) {
    return WidgetHeaderBody(
      iconBack: false,
      title: 'Công cụ chăm sóc sức khỏe',
      body: Text('data'),
    );
  }
}
