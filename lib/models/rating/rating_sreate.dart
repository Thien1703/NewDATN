class RatingCreate {
  final int appointmentId;
  final int serviceId;
  final int customerId;
  final int stars;
  final String? comment;

  RatingCreate({
    required this.appointmentId,
    required this.serviceId,
    required this.customerId,
    required this.stars,
    this.comment,
  });

  factory RatingCreate.fromJson(Map<String, dynamic> json) {
    return RatingCreate(
      appointmentId: json['appointmentId'] ?? 0,
      serviceId: json['serviceId'] ?? 0, // Nếu serviceId là null, gán 0
      customerId: json['customerId'] ?? 0, // Nếu customerId là null, gán 0
      stars: json['stars'] ?? 0, // Nếu stars là null, gán 0
      comment: json['comment'], // Có thể để comment là null nếu không có
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointmentId': appointmentId,
      'serviceId': serviceId,
      'customerId': customerId,
      'stars': stars,
      'comment': comment,
    };
  }
}
