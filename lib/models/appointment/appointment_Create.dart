class AppointmentCreate {
  final int? id;
  final int clinicId;
  final int customerId;
  final String date;
  final String time;
  final String? status;
  final int? customerProfileId;
  final List<int> serviceIds; // Thêm serviceIds vào model

  AppointmentCreate({
    this.id,
    required this.clinicId,
    required this.customerId,
    required this.date,
    required this.time,
    this.customerProfileId,
    this.status,
    required this.serviceIds, // Thêm serviceIds vào constructor
  });

  factory AppointmentCreate.fromJson(Map<String, dynamic> json) {
    return AppointmentCreate(
      id: json['id'],
      clinicId: json['clinicId'],
      customerId: json['customerId'],
      date: json['date'],
      time: json['time'],
      customerProfileId: json['customerProfileId'],
      status: json['status'],
      serviceIds: List<int>.from(
          json['serviceIds'] ?? []), // Dùng List<int> cho serviceIds
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'clinicId': clinicId,
      'customerId': customerId,
      'date': date,
      'time': time,
      'customerProfileId': customerProfileId,
      'serviceIds': serviceIds, // Thêm serviceIds vào toJson
    };
    return data;
  }
}
