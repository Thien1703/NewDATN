import 'dart:convert';

class CustomerProfile {
  final int id;
  final int customerId;
  final String fullName;
  final String phoneNumber;
  final String birthDate;
  final String gender;
  final String? cccd;
  final String address;

  CustomerProfile({
    required this.id,
    required this.customerId,
    required this.fullName,
    required this.phoneNumber,
    required this.birthDate,
    required this.gender,
    this.cccd,
    required this.address,
  });

  factory CustomerProfile.fromJson(Map<String, dynamic> json) {
    return CustomerProfile(
      id: json['id'] ?? 0,
      customerId: json['customerId'] ?? 0,
      fullName:  json["fullName"]?.toString().isNotEmpty == true
          ? utf8.decode(json["fullName"].toString().runes.toList())
          : "Chưa cập nhật",

      phoneNumber: json['phoneNumber'] ?? "Chưa cập nhật",
      birthDate: json['birthDate'] ?? "Chưa cập nhật",
      gender: json['gender'] ?? "Chưa cập nhật",
      cccd: json['cccd'],
      address:  json["address"]?.toString().isNotEmpty == true
          ? utf8.decode(json["address"].toString().runes.toList())
          : "Chưa cập nhật",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'birthDate': birthDate,
      'gender': gender,
      'cccd': cccd,
      'address': address,
    };
  }

  static CustomerProfile defaultProfile() {
    return CustomerProfile(
      id: 0,
      customerId: 0,
      fullName: "Chưa cập nhật",
      phoneNumber: "Chưa cập nhật",
      birthDate: "Chưa cập nhật",
      gender: "Chưa cập nhật",
      cccd: null,
      address: "Chưa cập nhật",
    );
  }
}
