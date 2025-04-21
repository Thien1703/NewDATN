import 'dart:convert';

class Rating {
  final int id;
  final int appointmentId;
  final int serviceId;
  final int stars;
  final String? comment;
  final String customerName;
  final bool? status;

  Rating({
    required this.id,
    required this.appointmentId,
    required this.serviceId,
    required this.stars,
    this.comment,
    required this.customerName,
    required this.status,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['id'],
      appointmentId: json['appointmentId'],
      serviceId: json['serviceId'],
      stars: json['stars'],
      comment: json['comment'] != null
          ? utf8.decode(json['comment'].toString().runes.toList())
          : null,
      customerName: json['customerName']?.toString().isNotEmpty==true
      ?utf8.decode(json['customerName'].toString().runes.toList())
      :"Chua cap nhat",
      status: json['status'] == null ? null : json['status'] == "TRUE",
    );
  }
}
