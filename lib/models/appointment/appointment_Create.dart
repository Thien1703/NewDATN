class AppointmentCreate {
  final int? id;
  final int clinicId;
  final int customerId;
  final String date;
  final String time;
  final String? status;
  final int? customerProfileId;
  final List<int> serviceIds;

  AppointmentCreate({
    this.id,
    required this.clinicId,
    required this.customerId,
    required this.date,
    required this.time,
    this.customerProfileId,
    this.status,
    required this.serviceIds,
  });

  // Factory constructor để chuyển JSON thành đối tượng AppointmentCreate
  factory AppointmentCreate.fromJson(Map<String, dynamic> json) {
    return AppointmentCreate(
      id: json['id'],
      clinicId: json['clinicId'],
      customerId: json['customerId'],
      date: json['date'],
      time: json['time'],
      customerProfileId: json['customerProfileId'],
      status: json['status'],
      serviceIds: List<int>.from(json['serviceIds'] ?? []),
    );
  }

  // Hàm chuyển đối tượng AppointmentCreate thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clinicId': clinicId,
      'customerId': customerId,
      'date': date,
      'time': time,
      'customerProfileId': customerProfileId,
      'status': status,
      'serviceIds': serviceIds,
    };
  }
}
