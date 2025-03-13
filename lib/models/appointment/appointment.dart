class Appointment {
  final int?
      id; // ID chỉ cần khi lấy dữ liệu từ API, không bắt buộc khi gửi lên
  final int clinicId;
  final int customerId;
  final String date;
  final String time;
  final String?
      status; // status không cần khi gửi API, nhưng có khi nhận dữ liệu
  final int? paymentId;

  Appointment({
    this.id, // ID có thể là null
    required this.clinicId,
    required this.customerId,
    required this.date,
    required this.time,
    this.status, // Status không cần khi gửi
    this.paymentId,
  });

  // Chuyển đổi từ JSON sang Model
  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      clinicId: json['clinicId'],
      customerId: json['customerId'],
      date: json['date'],
      time: json['time'],
      status: json['status'], // API sẽ trả về status (pending)
      paymentId: json['paymentId'],
    );
  }

  // Chuyển đổi từ Model sang JSON (dùng khi gửi API)
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'clinicId': clinicId,
      'customerId': customerId,
      'date': date,
      'time': time,
    };

    // Nếu paymentId không null thì thêm vào JSON
    if (paymentId != null) {
      data['paymentId'] = paymentId;
    }

    return data;
  }
}
