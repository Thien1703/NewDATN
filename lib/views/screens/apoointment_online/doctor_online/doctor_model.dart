import 'package:health_care/models/clinic.dart';
import 'package:health_care/models/specialty.dart';

class Doctor {
  final int id;
  final String fullName;
  final String phoneNumber;
  final String gender;
  final String birthDate;
  final String avatar;
  final String role;
  final Clinic clinic;
  final List<Specialty> specialties;

  Doctor({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.gender,
    required this.birthDate,
    required this.avatar,
    required this.role,
    required this.clinic,
    required this.specialties,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
      gender: json['gender'],
      birthDate: json['birthDate'],
      avatar: json['avatar'],
      role: json['role'],
      clinic: Clinic.fromJson(json['clinic']),
      specialties: (json['specialty'] as List)
          .map((s) => Specialty.fromJson(s))
          .toList(),
    );
  }
}

