import 'dart:convert';
import 'package:intl/intl.dart'; 
import 'specialty.dart';

class Service {
  final int id;
  final Specialty specialty;
  final String name;
  final String description;
  final int price;

  Service({
    required this.id,
    required this.specialty,
    required this.name,
    required this.description,
    required this.price,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      specialty: Specialty.fromJson(json['specialty']),
      name: utf8.decode(json['name'].runes.toList()),
      description: utf8.decode(json['description'].runes.toList()),
      price: (json['price'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'specialty': specialty.toJson(),
      'name': name,
      'description': description,
      'price': price,
    };
  }

  // Hàm này sẽ trả về giá đã được định dạng
  String get formattedPrice {
    final numberFormat = NumberFormat('#,##0', 'vi_VN');
    return '${numberFormat.format(price)}đ';
  }
}