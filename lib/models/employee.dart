import 'package:health_care/models/clinic.dart';
import 'package:health_care/models/specialty.dart';

class Employee {
  int id;
  String fullName;
  String phoneNumber;
  String role;
  Clinic clinic;
  List<Specialty> specialty;
  String gender;
  String birthDate;
  String? avatar;

  Employee({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.role,
    required this.clinic,
    required this.specialty,
    required this.gender,
    required this.birthDate,
    this.avatar,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] ?? 0,
      fullName: json['fullName'] ?? "Chưa cập nhật",
      phoneNumber: json['phoneNumber'] ?? "Chưa cập nhật",
      role: json['role'] ?? "Chưa cập nhật",
      clinic: Clinic.fromJson(json['clinic'] ?? {}),
      specialty: json['specialty'] != null
          ? (json['specialty'] as List)
              .map((item) => Specialty.fromJson(item))
              .toList()
          : [],
      gender: json['gender'] ?? "Chưa cập nhật",
      birthDate: json['birthDate'] ?? "Chưa cập nhật",
      avatar: json['avatar'] ?? "Chưa cập nhật",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'role': role,
      'clinic': clinic.toJson(),
      'specialty': specialty.map((e) => e.toJson()).toList(),
      'gender': gender,
      'birthDate': birthDate,
      'avatar': avatar,
    };
  }
}
