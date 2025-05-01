import 'package:health_care/models/appointment/appointment.dart';

class AppointmentBookingResult {
  final Appointment? appointment;
  final int statusCode;

  AppointmentBookingResult({
    required this.appointment,
    required this.statusCode,
  });
}
