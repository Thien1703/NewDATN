import 'dart:convert';

import 'package:health_care/models/clinic.dart';
import 'package:health_care/models/customer.dart';
import 'package:health_care/models/customerProfile.dart';

class Appointment {
  final int id;
  final Clinic clinic;
  final Customer customer;
  final CustomerProfile? customerProfile;
  final String date;
  final String time;
  final String status;
  final String? cancelNote;
  final String roomCode;
  final int isOnline;

  Appointment({
    required this.id,
    required this.clinic,
    required this.customer,
    required this.date,
    required this.time,
    required this.status,
    required this.customerProfile,
    this.cancelNote,
    required this.roomCode,
    required this.isOnline,
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
      customerProfile: json['customerProfile'] != null
          ? CustomerProfile.fromJson(json['customerProfile'])
          : null,
      date: json['date'] ?? "Chưa cập nhật",
      time: json['time'] ?? "Chưa cập nhật",
      status: json['status'] ?? "Chưa cập nhật",
      cancelNote:
          json['cancelNote'] != null && json['cancelNote'].toString().isNotEmpty
              ? utf8.decode(json['cancelNote'].toString().runes.toList())
              : "Chưa cập nhật",
      roomCode: json['roomCode'] ?? "Chưa cập nhật",
      isOnline: json['isOnline'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clinic': clinic.toJson(),
      'customer': customer.toJson(),
      'customerProfile': customerProfile?.toJson(),
      'date': date,
      'time': time,
      'status': status,
      'cancelNote': cancelNote,
      'roomCode': roomCode,
      'isOnline': isOnline
    };
  }

  static Appointment defaultAppointment() {
    return Appointment(
      id: 0,
      clinic: Clinic.defaultClinic(),
      customer: Customer.defaultCustomer(),
      customerProfile: CustomerProfile.defaultProfile(),
      date: "Chưa cập nhật",
      time: "Chưa cập nhật",
      status: "Chưa cập nhật",
      cancelNote: "Chưa cập nhật",
      roomCode: "Chưa cập nhật",
      isOnline: 0,
    );
  }
}
