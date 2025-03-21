class Employee {
  final int id;
  final String? fullName;
  final String? phoneNumber;
  final String? roleName;
  final String? specialty;
  final String? gender;
  final String? birthDate;
  final String? avatar;

  Employee({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.roleName,
    this.specialty,
    this.gender,
    required this.birthDate,
    required this.avatar,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
      roleName: json['roleName'],
      specialty: json['specialty'],
      gender: json['gender'],
      birthDate: json['birthDate'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'roleName': roleName,
      'specialty': specialty,
      'gender': gender,
      'birthDate': birthDate,
      'avatar': avatar,
    };
  }
}
