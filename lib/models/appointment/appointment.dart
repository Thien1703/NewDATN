import 'package:health_care/models/clinic.dart';
import 'package:health_care/models/customer.dart';

class Appointment {
  final int id;
  final Clinic clinic;
  final Customer customer;
  final String date;
  final String time;
  final String status;
  final int? payment;

  Appointment({
    required this.id,
    required this.clinic,
    required this.customer,
    required this.date,
    required this.time,
    required this.status,
    this.payment,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      clinic: Clinic.fromJson(json['clinic']),
      customer: Customer.fromJson(json['customer']),
      date: json['date'],
      time: json['time'],
      status: json['status'],
      payment: json['payment'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clinic': clinic.toJson(),
      'customer': customer.toJson(),
      'date': date,
      'time': time,
      'status': status,
      'payment': payment,
    };
  }
}
