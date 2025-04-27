import 'dart:convert';
import 'package:health_care/models/clinic.dart';
import 'package:health_care/models/specialty.dart';

class Employee {
  final int id;
  final String fullName;
  final String phoneNumber;
  final String role;
  final Clinic clinic;
  final List<Specialty> specialty;
  final String gender;
  final String birthDate;
  final String avatar;

  Employee({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.role,
    required this.clinic,
    required this.specialty,
    required this.gender,
    required this.birthDate,
    required this.avatar,
  });

  // Chuyển từ JSON sang Object
  factory Employee.fromJson(Map<String, dynamic>? json) {
    if (json == null || json.isEmpty) {
      return Employee.defaultEmployee();
    }
    return Employee(
      id: json['id'] ?? 0,
      fullName:
          json['fullName'] != null && json['fullName'].toString().isNotEmpty
              ? utf8.decode(json['fullName'].toString().runes.toList())
              : "Chưa cập nhật",
      phoneNumber: json['phoneNumber'] != null &&
              json['phoneNumber'].toString().isNotEmpty
          ? json['phoneNumber']
          : "Chưa cập nhật",
      role: json['role'] != null && json['role'].toString().isNotEmpty
          ? json['role']
          : "Chưa cập nhật",
      clinic: json['clinic'] != null
          ? Clinic.fromJson(json['clinic'])
          : Clinic.defaultClinic(),
      specialty: (json['specialty'] as List?)
              ?.map((item) => Specialty.fromJson(item))
              .toList() ??
          [],
      gender: json['gender'] != null && json['gender'].toString().isNotEmpty
          ? json['gender']
          : "Chưa cập nhật",
      birthDate:
          json['birthDate'] != null && json['birthDate'].toString().isNotEmpty
              ? json['birthDate']
              : "Chưa cập nhật",
      avatar: json['avatar'] != null && json['avatar'].toString().isNotEmpty
          ? json['avatar']
          : "https://suckhoe123.vn/uploads/users/doctor-avatar-male_n2gdre0x_1.png",
    );
  }

  // Chuyển từ Object sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'role': role,
      'clinic': clinic.toJson(),
      'specialty':
          specialty.isNotEmpty ? specialty.map((e) => e.toJson()).toList() : [],
      'gender': gender,
      'birthDate': birthDate,
      'avatar': avatar,
    };
  }

  // Giá trị mặc định nếu tất cả đều null
  static Employee defaultEmployee() {
    return Employee(
      id: 0,
      fullName: "Chưa cập nhật",
      phoneNumber: "Chưa cập nhật",
      role: "Chưa cập nhật",
      clinic: Clinic.defaultClinic(),
      specialty: [],
      gender: "Chưa cập nhật",
      birthDate: "Chưa cập nhật",
      avatar:
          "https://suckhoe123.vn/uploads/users/doctor-avatar-male_n2gdre0x_1.png",
    );
  }
}
