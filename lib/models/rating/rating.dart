import 'dart:convert';

class Rating {
  final int id;
  final int appointmentId;
  final int? serviceId;
  final int? employeeId;
  final int stars;
  final String? comment;
  final String customerName;
  final bool? status;
  final String targetType;

  Rating({
    required this.id,
    required this.appointmentId,
    required this.serviceId,
    required this.employeeId,
    required this.stars,
    this.comment,
    required this.customerName,
    required this.status,
    required this.targetType,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['id'],
      appointmentId: json['appointmentId'],
      serviceId: json['serviceId'],
      employeeId: json['employeeId'],
      stars: json['stars'],
      comment: json['comment'] != null
          ? utf8.decode(json['comment'].toString().runes.toList())
          : null,
      customerName: (json['customerName']?.toString().isNotEmpty ?? false)
          ? utf8.decode(json['customerName'].toString().runes.toList())
          : 'Chưa cập nhật',
      status: json['status'] == null ? null : json['status'] == "TRUE",
      targetType:
          json['targetType'] ?? '', // nếu API không trả về thì cho chuỗi rỗng
    );
  }
}
