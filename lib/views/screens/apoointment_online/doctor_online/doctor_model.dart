import 'dart:convert';

import 'package:health_care/models/clinic.dart';
import 'package:health_care/models/specialty.dart';

class Doctor {
  final int id;
  final String fullName;
  final String phoneNumber;
  final String gender;
  final String birthDate;
  final String avatar;
  final String role;
  final Clinic clinic;
  final List<Specialty> specialties;
  final double averageRating;
  final int reviewCount;
  final String qualification;
  final int experienceYears;
  final String? bio;

  Doctor({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.gender,
    required this.birthDate,
    required this.avatar,
    required this.role,
    required this.clinic,
    required this.specialties,
    required this.averageRating,
    required this.reviewCount,
    required this.qualification,
    required this.experienceYears,
    this.bio,
  });
  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      fullName: utf8.decode(json['fullName'].runes.toList()), // 👈 decode UTF-8
      phoneNumber: json['phoneNumber'],
      gender: json['gender'],
      birthDate: json['birthDate'],
      avatar: json['avatar'],
      role: json['role'],
      clinic: Clinic.fromJson(json['clinic']),
      specialties: (json['specialty'] as List)
          .map((s) => Specialty.fromJson(s))
          .toList(),
      averageRating: (json['averageRating'] as num).toDouble(),
      reviewCount: json['reviewCount'],
      qualification: utf8.decode(json['qualification'].runes.toList()),
      experienceYears: json['experienceYears'],
      bio: json['bio'],
    );
  }
}
