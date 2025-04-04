import 'package:flutter/material.dart';
import 'package:health_care/models/service.dart';
import 'package:health_care/views/widgets/widget_header_body.dart';

class StarScreen extends StatefulWidget {
  const StarScreen(
      {super.key, required this.customerId, required this.serviceId});
  final int customerId;
  final int serviceId;
  @override
  State<StarScreen> createState() => _StarScreen();
}

class _StarScreen extends State<StarScreen> {
  List<Service>? services;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.cancel),
        ),
      ),
      body: Column(
        children: [
          Text(widget.customerId.toString()),
          Text(widget.serviceId.toString())
        ],
      ),
    );
  }
}
