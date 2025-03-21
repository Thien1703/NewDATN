class Customer {
  int id;
  String fullName;
  String? phoneNumber;
  int? isVerified;
  int? isDeleted;
  String? birthDate;
  String? gender;
  String? cccd;
  String? email;
  String? address;
  String? avatar;

  Customer({
    required this.id,
    required this.fullName,
    this.phoneNumber,
    required this.isVerified,
    required this.isDeleted,
    this.birthDate,
    this.gender,
    this.cccd,
    this.email,
    this.address,
    this.avatar,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json["id"] ?? 0,
      fullName: json["fullName"] ?? "Chưa cập nhật", // Xử lý null
      phoneNumber: json["phoneNumber"], // Không cần `?? ""` vì đã nullable
      isVerified: json["isVerified"] ?? 0,
      isDeleted: json["isDeleted"] ?? 0,
      birthDate: json["birthDate"], // Không cần `?? ""`
      gender: json["gender"],
      cccd: json["cccd"],
      email: json["email"],
      address: json["address"],
      avatar: json["avatar"],
    );
  }

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
