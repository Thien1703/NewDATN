class MapModel {
  final int id;
  final String name;
  final String description;
  final String address;
  final String image;
  final double lat;
  final double lng;

  MapModel({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.image,
    required this.lat,
    required this.lng,
  });

  factory MapModel.fromJson(Map<String, dynamic> json) {
    return MapModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      address: json['address'],
      image: json['image'],
      lat: json['latitude'],
      lng: json['longitude'],
    );
  }
}
