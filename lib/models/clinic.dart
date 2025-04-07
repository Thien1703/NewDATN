import 'dart:convert';

class Clinic {
  final int id;
  final String name;
  final String image;
  final String description;
  final double rating;
  final int reviewCount;
  final String address;
  final double latitude;
  final double longitude;

  Clinic({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.rating,
    required this.reviewCount,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  // Chuyển từ JSON sang Object
  factory Clinic.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Clinic.defaultClinic();
    }
    return Clinic(
      id: json['id'] ?? 0,
      name: json['name'] != null && json['name'].toString().isNotEmpty
          ? utf8.decode(json['name'].toString().runes.toList())
          : "Chưa cập nhật",
      image: json['image'] ?? "assets/images/imageError.png",
      description: json['description'] != null &&
              json['description'].toString().isNotEmpty
          ? utf8.decode(json['description'].toString().runes.toList())
          : "Chưa cập nhật",
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] ?? 0,
      address: json['address'] != null && json['address'].toString().isNotEmpty
          ? utf8.decode(json['address'].toString().runes.toList())
          : "Chưa cập nhật",
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // Chuyển từ Object sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'description': description,
      'rating': rating,
      'reviewCount': reviewCount,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  // Giá trị mặc định nếu tất cả đều null
  static Clinic defaultClinic() {
    return Clinic(
      id: 0,
      name: "Chưa cập nhật",
      image: "assets/images/imageError.png",
      description: "Chưa cập nhật",
      rating: 0.0,
      reviewCount: 0,
      address: "Chưa cập nhật",
      latitude: 0.0,
      longitude: 0.0,
    );
  }
}
