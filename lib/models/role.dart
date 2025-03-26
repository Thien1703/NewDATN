import 'dart:convert';

class Role {
  final int id;
  final String name;
  final String description;

  Role({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'] ?? 0,
      name: json['name'] != null && json['name'].toString().isNotEmpty
          ? utf8.decode(json['name'].toString().runes.toList())
          : "Chưa cập nhật",
      description: json['description'] != null &&
              json['description'].toString().isNotEmpty
          ? utf8.decode(json['description'].toString().runes.toList())
          : "Chưa cập nhật",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}

// Hàm chuyển đổi danh sách JSON thành danh sách Role
List<Role> parseRoles(List<dynamic> jsonList) {
  return jsonList
      .map((json) => Role.fromJson(json as Map<String, dynamic>))
      .toList();
}
