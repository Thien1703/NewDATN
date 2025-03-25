import 'package:health_care/models/appointment/app_ser.dart';

class Appointment {
  final int id;
  final String clinicName;
  final String customerName;
  final String customerPhone;
  final String dateTime;
  final String status;
  final List<AppointmentService> services;

  Appointment({
    required this.id,
    required this.clinicName,
    required this.customerName,
    required this.customerPhone,
    required this.dateTime,
    required this.status,
    required this.services,
  });

  factory Appointment.fromJson(
      Map<String, dynamic> appointmentJson, List<AppointmentService> services) {
    return Appointment(
      id: appointmentJson['id'],
      clinicName: appointmentJson['clinic']['name'],
      customerName: appointmentJson['customer']['fullName'],
      customerPhone: appointmentJson['customer']['phoneNumber'],
      dateTime: "${appointmentJson['date']} - ${appointmentJson['time']}",
      status: appointmentJson['status'],
      services: services,
    );
  }
}
