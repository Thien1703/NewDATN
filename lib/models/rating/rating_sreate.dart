class RatingCreate {
  final int appointmentId;
  final int customerId;
  final int stars;
  final String? comment;
  final String targetType;
  final int? serviceId;
  final int? employeeId;

  RatingCreate({
    required this.appointmentId,
    required this.customerId,
    required this.stars,
    required this.targetType,
    this.comment,
    this.serviceId,
    this.employeeId,
  });

  factory RatingCreate.fromJson(Map<String, dynamic> json) {
    return RatingCreate(
      appointmentId: json['appointmentId'] ?? 0,
      customerId: json['customerId'] ?? 0,
      stars: json['stars'] ?? 0,
      targetType: json['targetType'] ?? '',
      comment: json['comment'],
      serviceId: json['serviceId'],
      employeeId: json['employeeId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointmentId': appointmentId,
      'customerId': customerId,
      'stars': stars,
      'targetType': targetType,
      'comment': comment,
      'serviceId': serviceId,
      'employeeId': employeeId,
    };
  }
}
