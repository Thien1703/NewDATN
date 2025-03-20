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
      service: Service.fromJson(json['service']),
      employee: Employee.fromJson(json['employee']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'appointment': appointment.toJson(),
      'service': service,
      'employee': employee,
    };
  }
}
