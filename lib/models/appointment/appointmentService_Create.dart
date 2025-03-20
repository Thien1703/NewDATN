class AddServiceRequest {
  final int appointmentId;
  final List<int> serviceIds;

  AddServiceRequest({
    required this.appointmentId,
    required this.serviceIds,
  });

  Map<String, dynamic> toJson() {
    return {
      "appointmentId": appointmentId,
      "serviceIds": serviceIds,
    };
  }
}
