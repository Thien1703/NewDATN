import 'dart:convert';
import 'package:intl/intl.dart';

class Service {
  final int id;
  final int specialtyId;
  final String name;
  final String description;
  final double price;
  final String? image;
  final int? reviewCount;
  final double? rating;
  String? specialtyName;

  Service({
    required this.id,
    required this.specialtyId,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    this.reviewCount,
    this.rating,
    this.specialtyName,
  });

  // Chuyển từ JSON sang Object
  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      specialtyId: json['specialtyId'],
      name: utf8.decode(json['name'].runes.toList()),
      description: utf8.decode(json['description'].runes.toList()),
      price: json['price'].toDouble(),
      image: json['image'],
      reviewCount: json['reviewCount'],
      rating: json['rating'] != null ? json['rating'].toDouble() : null,
      specialtyName: json['specialtyName'],
    );
  }

  // Chuyển từ Object sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'specialtyId': specialtyId,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'reviewCount': reviewCount,
      'rating': rating,
    };
  }

  String get formattedPrice {
    final formatter = NumberFormat("#,###", "vi_VN");
    return "${formatter.format(price)}đ";
  }
}
