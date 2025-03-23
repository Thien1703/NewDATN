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
  String avatar;

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

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] ?? 0,
      fullName: json['fullName'] ?? "Chưa cập nhật",
      phoneNumber: json['phoneNumber'] ?? "Chưa cập nhật",
      role: json['role'] ?? "Chưa cập nhật",
      clinic: json['clinic'] != null
          ? Clinic.fromJson(json['clinic'])
          : Clinic(
              id: 0,
              name: "Chưa cập nhật",
              image: "",
              description: "Chưa cập nhật",
              address: "Chưa cập nhật",
              facilitie: "Chưa cập nhật",
              latitude: 0.0,
              longitude: 0.0),
      specialty: (json['specialty'] as List?)
              ?.map((item) => Specialty.fromJson(item))
              .toList() ??
          [],
      gender: json['gender'] ?? "Chưa cập nhật",
      birthDate: json['birthDate'] ?? "Chưa cập nhật",
      avatar: json['avatar'] ??
          "https://example.com/default-avatar.jpg", // Ảnh mặc định
    );
  }

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
}
