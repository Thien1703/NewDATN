import 'dart:convert';
import 'package:intl/intl.dart';

class AppointmentService {
  final int id;
  final int appointmentId;
  final int serviceId;
  final String serviceName;
  final int? employeeId;
  final String doctorName;

  AppointmentService({
    required this.id,
    required this.appointmentId,
    required this.serviceId,
    required this.serviceName,
    required this.employeeId,
    required this.doctorName,
  });

  // Chuyển đổi từ JSON sang Model
  factory AppointmentService.fromJson(Map<String, dynamic> json) {
    return AppointmentService(
      id: json['id'],
      appointmentId: json['appointmentId'],
      serviceId: json['serviceId'],
      serviceName: utf8.decode(json['serviceName'].runes.toList()),
      employeeId: json['employeeId'],
      doctorName: json['doctorName'],
    );
  }

  // Chuyển đổi từ Model sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'appointmentId': appointmentId,
      'serviceId': serviceId, // Mảng được giữ nguyên
      'serviceName': serviceName,
      'employeeId': employeeId,
      'doctorName': doctorName,
    };
  }
}
