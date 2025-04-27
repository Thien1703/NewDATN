class MapModel {
  final int id;
  final String name;
  final String description;
  final String address;
  final String image;
  final double latitude;
  final double longitude;
  double? distance;

  MapModel({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.image,
    required this.latitude,
    required this.longitude,
    this.distance,
  });

  factory MapModel.fromJson(Map<String, dynamic> json) {
    return MapModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      address: json['address'],
      image: json['image'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }
}
