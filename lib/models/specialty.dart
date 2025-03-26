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
        name: json['name'] != null
            ? utf8.decode(json['name'].toString().runes.toList())
            : "Chưa cập nhật",
        description: json['description'] != null
            ? utf8.decode(json['description'].toString().runes.toList())
            : "Chưa cập nhật",
        image: json['image'] ?? "assets/images/imageError.png",
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

    // Giá trị mặc định nếu bị null
    static Specialty defaultSpecialty() {
      return Specialty(
        id: 0,
        name: "Chưa cập nhật",
        description: "Chưa cập nhật",
        image: "assets/images/imageError.png",
      );
    }
  }
