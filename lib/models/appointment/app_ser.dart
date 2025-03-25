class AppointmentService {
  final int id;
  final String serviceName;
  final double price;
  final String specialty;
  final String doctorName;

  AppointmentService({
    required this.id,
    required this.serviceName,
    required this.price,
    required this.specialty,
    required this.doctorName,
  });

  factory AppointmentService.fromJson(Map<String, dynamic> json) {
    return AppointmentService(
      id: json['id'],
      serviceName: json['service']['name'],
      price: json['service']['price'].toDouble(),
      specialty: json['service']['specialty']['name'],
      doctorName: json['employee'] != null
          ? json['employee']['fullName']
          : "Chưa có bác sĩ",
    );
  }
}
