import 'dart:convert';

class Customer {
  int id;
  String fullName;
  String phoneNumber;
  int isVerified;
  int isDeleted;
  String? birthDate;
  String? gender;
  String? cccd;
  String? email;
  String? address;
  String? avatar;

  Customer({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    this.isVerified = 0,
    this.isDeleted = 0,
    this.birthDate,
    this.gender,
    this.cccd,
    this.email,
    this.address,
    this.avatar,
  });

  /// Chuyển JSON thành đối tượng `Customer`
  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json["id"] ?? 0,
      fullName: utf8.decode(json["fullName"].toString().runes.toList()),
      phoneNumber: json["phoneNumber"] ?? "Chưa cập nhật",
      isVerified: json["isVerified"] ?? 0,
      isDeleted: json["isDeleted"] ?? 0,
      birthDate: json["birthDate"],
      gender: json["gender"],
      cccd: json["cccd"],
      email: json["email"],
      address: json["address"],
      avatar: json["avatar"] ?? json["avtar"], // Xử lý lỗi key avatar
    );
  }

  /// Chuyển đối tượng `Customer` thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'isVerified': isVerified,
      'isDeleted': isDeleted,
      'birthDate': birthDate,
      'gender': gender,
      'cccd': cccd,
      'email': email,
      'address': address,
      'avatar': avatar,
    };
  }
}
