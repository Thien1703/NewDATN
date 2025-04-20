import 'dart:convert';

class Customer {
  final int id;
  final String fullName;
  final String phoneNumber;
  final int isVerified;
  final int isDeleted;
  final String birthDate;
  final String gender;
  final String cccd;
  final String email;
  final String address;
  final String avatar;

  Customer({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.isVerified,
    required this.isDeleted,
    required this.birthDate,
    required this.gender,
    required this.cccd,
    required this.email,
    required this.address,
    required this.avatar,
  });

  // Chuyển từ JSON sang Object
  factory Customer.fromJson(Map<String, dynamic>? json) {
    if (json == null || json.isEmpty) {
      return Customer.defaultCustomer();
    }
    return Customer(
      id: json["id"] ?? 0,
      fullName: json["fullName"]?.toString().isNotEmpty == true
          ? utf8.decode(json["fullName"].toString().runes.toList())
          : "Chưa cập nhật",
      phoneNumber: json["phoneNumber"] ?? "Chưa cập nhật",
      isVerified: json["isVerified"] ?? 0,
      isDeleted: json["isDeleted"] ?? 0,
      birthDate: json["birthDate"] ?? "Chưa cập nhật",
      gender: json["gender"] ?? "Chưa cập nhật",
      cccd: json["cccd"] ?? "Chưa cập nhật",
      email: json["email"] ?? "Chưa cập nhật",
      address: json["address"] ?? "Chưa cập nhật",
      avatar: json["avatar"] ?? "assets/images/iconProfile.jpg",
    );
  }

  // Chuyển từ Object sang JSON
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

  // Giá trị mặc định nếu tất cả đều null
  static Customer defaultCustomer() {
    return Customer(
      id: 0,
      fullName: "Chưa cập nhật",
      phoneNumber: "Chưa cập nhật",
      isVerified: 0,
      isDeleted: 0,
      birthDate: "Chưa cập nhật",
      gender: "Chưa cập nhật",
      cccd: "Chưa cập nhật",
      email: "Chưa cập nhật",
      address: "Chưa cập nhật",
      avatar: "assets/images/iconProfile.jpg",
    );
  }
}
