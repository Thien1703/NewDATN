import 'package:health_care/models/appointment/appointment.dart';
import 'package:health_care/models/employee.dart';
import 'package:health_care/models/service.dart';

class AppointmentService {
  final int id;
  final Appointment appointment;
  final Service? service;
  final Employee? employee;
  final String? status;
  final String? note;

  AppointmentService({
    required this.id,
    required this.appointment,
    this.service,
    this.employee,
    this.status,
    this.note,
  });

  factory AppointmentService.fromJson(Map<String, dynamic> json) {
    try {
      print("Raw JSON: $json"); // In toàn bộ dữ liệu JSON để kiểm tra

      return AppointmentService(
        id: json['id'] ?? 0,
        appointment: json['appointment'] != null
            ? Appointment.fromJson(json['appointment'])
            : throw Exception("Appointment data is required"),
        service:
            json['service'] != null ? Service.fromJson(json['service']) : null,
        employee: json['employee'] != null
            ? Employee.fromJson(json['employee'])
            : null,
        status: json['status'],
        note: json['note'],
      );
    } catch (e, stackTrace) {
      print("Error parsing AppointmentService: $e");
      print("Stack trace: $stackTrace");
      throw Exception("Failed to parse AppointmentService: $e");
    }
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'appointment': appointment.toJson(),
      'service': service?.toJson(),
      'employee': employee?.toJson(),
      'status': status,
      'note': note,
    };
  }
}
