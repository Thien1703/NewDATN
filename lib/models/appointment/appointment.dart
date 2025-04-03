import 'package:health_care/models/clinic.dart';
import 'package:health_care/models/customer.dart';

class Appointment {
  final int id;
  final Clinic clinic;
  final Customer customer;
  final String date;
  final String time;
  final String status;
  final String? cancelNote;
  final int? payment;

  Appointment({
    required this.id,
    required this.clinic,
    required this.customer,
    required this.date,
    required this.time,
    required this.status,
    this.cancelNote,
    this.payment,
  });

  factory Appointment.fromJson(Map<String, dynamic>? json) {
    if (json == null || json.isEmpty) {
      return Appointment.defaultAppointment();
    }
    return Appointment(
      id: json['id'] ?? 0,
      clinic: json['clinic'] != null
          ? Clinic.fromJson(json['clinic'])
          : Clinic.defaultClinic(),
      customer: json['customer'] != null
          ? Customer.fromJson(json['customer'])
          : Customer.defaultCustomer(),
      date: json['date'] ?? "Chưa cập nhật",
      time: json['time'] ?? "Chưa cập nhật",
      status: json['status'] ?? "Chưa cập nhật",
      cancelNote: json['cancelNote'.toString()] ?? 'Chưa cập nhật',
      payment: json['payment'] ?? 0,
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
      'cancelNote': cancelNote,
      'payment': payment,
    };
  }

  static Appointment defaultAppointment() {
    return Appointment(
      id: 0,
      clinic: Clinic.defaultClinic(),
      customer: Customer.defaultCustomer(),
      date: "Chưa cập nhật",
      time: "Chưa cập nhật",
      status: "Chưa cập nhật",
      cancelNote: "Chưa cập nhật",
      payment: 0,
    );
  }
}
