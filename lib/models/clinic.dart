import 'dart:convert';

class Clinic {
  final int id;
  final String name;
  final String image;
  final String description;
  final double? rating;
  final int? reviewCount;
  final String address;
  final String facilitie;
  final double? latitude;
  final double? longitude;

  Clinic({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    this.rating,
    this.reviewCount,
    required this.address,
    required this.facilitie,
    required this.latitude,
    required this.longitude,
  });

  // Chuyển từ JSON sang Object
  factory Clinic.fromJson(Map<String, dynamic> json) {
    return Clinic(
      id: json['id'] ?? 0,
      name: utf8.decode(json['name'].toString().codeUnits),
      image: json['image'] ?? '',
      description: utf8.decode(json['description'].toString().codeUnits),
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : 0.0,
      reviewCount: json['reviewCount'] ?? 0,
      address: utf8.decode(json['address'].toString().codeUnits),
      facilitie: utf8.decode(json['facilitie'].toString().codeUnits),
      latitude: json['latitude'] != null
          ? (json['latitude'] as num).toDouble()
          : null,
      longitude: json['longitude'] != null
          ? (json['longitude'] as num).toDouble()
          : null,
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
      'facilitie': facilitie,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
