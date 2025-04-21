// lib/models/doctor_model.dart
class Doctor {
  final String name;
  final String specialty;
  final double rating;
  final String imagePath;

  Doctor({
    required this.name,
    required this.specialty,
    required this.rating,
    required this.imagePath,
  });
}
