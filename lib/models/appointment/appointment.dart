class Appointment {
  final int? id;
  final int clinicId;
  final int customerId;
  final String date;
  final String time;
  final String? status;
  final int? paymentId;

  Appointment({
    this.id,
    required this.clinicId,
    required this.customerId,
    required this.date,
    required this.time,
    this.status,
    this.paymentId,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      clinicId: json['clinicId'],
      customerId: json['customerId'],
      date: json['date'],
      time: json['time'],
      status: json['status'],
      paymentId: json['paymentId'],
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'clinicId': clinicId,
      'customerId': customerId,
      'date': date,
      'time': time,
    };
    if (paymentId != null) {
      data['paymentId'] = paymentId;
    }
    return data;
  }
}
