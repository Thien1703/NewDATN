import 'dart:convert';
import 'dart:developer';

import 'package:health_care/models/appointment/appointment.dart';
import 'package:health_care/models/employee.dart';
import 'package:health_care/models/service.dart';

class AppointmentService {
  final int id;
  final Appointment appointment;
  final Service? service;
  final Employee? employee;

  AppointmentService({
    required this.id,
    required this.appointment,
    required this.service,
    required this.employee,
  });

  factory AppointmentService.fromJson(Map<String, dynamic> json) {
    return AppointmentService(
      id: json['id'],
      appointment: Appointment.fromJson(json['appointment']),
      service:
          json['service'] != null ? Service.fromJson(json['service']) : null,
      employee:
          json['employee'] != null ? Employee.fromJson(json['employee']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'appointment': appointment.toJson(),
      'service': service != null ? service!.toJson() : null,
      'employee': employee != null ? employee!.toJson() : null,
    };
  }
}
