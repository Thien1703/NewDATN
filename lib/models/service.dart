import 'dart:convert';

import 'package:health_care/models/specialty.dart';
import 'package:intl/intl.dart';

class Service {
  final int id;
  final Specialty specialty;
  final String name;
  final String description;
  final double price;
  final String image;
  final double? averageRating;
  final int? reviewCount;

  Service({
    required this.id,
    required this.specialty,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.averageRating,
    required this.reviewCount,
  });

  /// Getter để định dạng giá tiền
  String get formattedPrice {
    final formatter = NumberFormat("#,###", "vi_VN");
    return "${formatter.format(price)}VNĐ";
  }

  factory Service.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError("JSON cannot be null");
    }
    return Service(
      id: json['id'] != null ? json['id'] as int : 0,
      specialty: json['specialty'] != null
          ? Specialty.fromJson(json['specialty'])
          : Specialty.defaultSpecialty(),
      name: json['name'] != null
          ? utf8.decode(json['name'].toString().runes.toList())
          : "Chưa cập nhật",
      description: json['description'] != null
          ? utf8.decode(json['description'].toString().runes.toList())
          : "Chưa cập nhật",
      price: json['price'] != null ? (json['price'] as num).toDouble() : 0.0,
      image: json['image'] ?? "assets/images/imageOnErrror.png",
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'specialty': specialty.toJson(),
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'averageRating': averageRating,
      'reviewCount': reviewCount,
    };
  }
}
