class AppointmentCreateOnline {
  final int clinicId;
  final int customerId;
  final int? customerProfileId;
  final String date;
  final String time;
  final int isOnline;
  final int employeeId;
  final List<int> serviceIds; // Thêm serviceIds vào model

  AppointmentCreateOnline({
    required this.clinicId,
    required this.customerId,
    this.customerProfileId,
    required this.date,
    required this.time,
    this.isOnline = 1, // Mặc định là 1 cho lịch online
    required this.employeeId,
    required this.serviceIds, // Thêm serviceIds vào constructor
  });

  factory AppointmentCreateOnline.fromJson(Map<String, dynamic> json) {
    return AppointmentCreateOnline(
      clinicId: json['clinicId'],
      customerId: json['customerId'],
      date: json['date'],
      time: json['time'],
      customerProfileId: json['customerProfileId'],
      employeeId: json['employee'], // Gán giá trị employee từ JSON
      serviceIds: List<int>.from(
          json['serviceIds'] ?? []), // Dùng List<int> cho serviceIds
      isOnline: json['isOnline'] ??
          1, // Nếu không có isOnline, mặc định là 1 (online)
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'clinicId': clinicId,
      'customerId': customerId,
      'date': date,
      'time': time,
      'customerProfileId': customerProfileId,
      'isOnline': isOnline, // Thêm isOnline vào toJson
      'employeeId': employeeId, // Thêm employee vào toJson
      'serviceIds': serviceIds, // Thêm serviceIds vào toJson
    };
    return data;
  }
}
