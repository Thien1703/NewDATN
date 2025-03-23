import 'dart:convert';

class Specialty {
  final int id;
  final String name;
  final String description;
  final String image;

  Specialty({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
  });

  // Chuyển từ JSON sang đối tượng Specialty
  factory Specialty.fromJson(Map<String, dynamic> json) {
    return Specialty(
      id: json['id'] ?? 0,
      name: utf8.decode(json['name'].toString().runes.toList()),
      description: utf8.decode(json['description'].toString().runes.toList()),
      image: json['image'] ??
          "https://example.com/default-image.jpg", // Ảnh mặc định
    );
  }

  // Chuyển từ đối tượng Specialty sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
    };
  }
}
