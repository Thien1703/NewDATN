class Rating {
  final int id;
  final String customerName;
  final int stars;
  final String? comment; // Vì comment có thể là null, nên sử dụng kiểu String?

  Rating({
    required this.id,
    required this.customerName,
    required this.stars,
    this.comment, // comment có thể là null
  });

  // Factory method để tạo đối tượng từ JSON
  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['id'],
      customerName: json['customerName'],
      stars: json['stars'],
      comment:
          json['comment'], // comment có thể là null, không cần kiểm tra kiểu
    );
  }

  // Chuyển từ Dart object sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerName': customerName,
      'stars': stars,
      'comment': comment,
    };
  }
}
