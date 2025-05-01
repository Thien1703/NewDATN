class Modeltimecheck {
  final Map<String, int> slots;

  Modeltimecheck({required this.slots});

  factory Modeltimecheck.fromJson(Map<String, dynamic> json) {
    // Kiểm tra json['data'] có phải là null không hoặc không phải Map
    final data = json['data'];
    if (data == null || data is! Map<String, dynamic>) {
      return Modeltimecheck(slots: {});
    }

    // Chuyển đổi data sang kiểu Map<String, int>
    return Modeltimecheck(
      slots: Map<String, int>.from(
          data.map((key, value) => MapEntry(key, value as int))),
    );
  }
}
