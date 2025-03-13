import 'dart:convert';

class Specialty {
  final int id;
  final String name;
  final String description;
  final String? image;
  Specialty({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
  });
  // Chuyển từ JSON sang đối tượng Specialty
  factory Specialty.fromJson(Map<String, dynamic> json) {
    return Specialty(
      id: json['id'],
      name: utf8.decode(json['name'].runes.toList()), // Chuyển về UTF-8
      description: utf8.decode(json['description'].runes.toList()),
      image: json['image'],
    );
  }

  // Chuyển từ đối tượng Specialty sang JSON (nếu cần)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
    };
  }
}
