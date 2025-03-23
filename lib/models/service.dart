import 'dart:convert';
import 'specialty.dart';

class Service {
  final int id;
  final Specialty specialty;
  final String name;
  final String description;
  final double price;

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
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
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
}
