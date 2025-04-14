import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:health_care/views/screens/clinic/clinic_screen.dart';
import 'package:health_care/views/screens/map/data_search_model.dart';
import 'package:health_care/views/screens/map/form_field_widget.dart';
import 'package:health_care/views/screens/map/search_map_view.dart';
import 'package:geolocator/geolocator.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late GoogleMapController mapController;
  Set<Marker> markers = {}; // Danh sách marker
  late BitmapDescriptor clinicIcon;

  @override
  void initState() {
    super.initState();
    _loadCustomMarker();
    _goToCurrentLocation();
  }

  Future<void> _goToCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    final LatLng currentLatLng = LatLng(position.latitude, position.longitude);

    // Thêm marker vị trí hiện tại
    setState(() {
      markers.add(
        Marker(
          markerId: const MarkerId("currentLocation"),
          position: currentLatLng,
          infoWindow: const InfoWindow(title: "Vị trí của bạn"),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        ),
      );
    });

    mapController.animateCamera(CameraUpdate.newLatLng(currentLatLng));
  }

  void _loadCustomMarker() async {
    clinicIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(100, 100)),
      'assets/icons/maker1.png',
    );
    _generateFixedMarkers();
  }

  void _generateFixedMarkers() {
    final List<Map<String, dynamic>> clinics = [
      {
        "name": "Phòng Khám Đa Khoa FPT-Quận 1",
        "district": "Quận 1",
        "lat": 10.856003139908193,
        "lng": 106.63188467921057
      },
      {
        "name": "Phòng Khám Đa Khoa FPT-Quận 3",
        "district": "Quận 3",
        "lat": 10.779,
        "lng": 106.695
      },
      {
        "name": "Phòng Khám Đa Khoa FPT-Quận 5",
        "district": "Quận 5",
        "lat": 10.762,
        "lng": 106.682
      },
      {
        "name": "Phòng Khám Đa Khoa FPT-Quận 7",
        "district": "Quận 7",
        "lat": 10.735,
        "lng": 106.707
      },
      {
        "name": "Phòng Khám Đa Khoa FPT-Quận 10",
        "district": "Quận 10",
        "lat": 10.770,
        "lng": 106.668
      },
      {
        "name": "Phòng Khám Đa Khoa FPT-Quận Bình Thạnh",
        "district": "Bình Thạnh",
        "lat": 10.804,
        "lng": 106.690
      },
      {
        "name": "Phòng Khám Đa Khoa FPT-Quận Govap",
        "district": "Gò Vấp",
        "lat": 10.822,
        "lng": 106.687
      },
      {
        "name": "Phòng Khám Đa Khoa FPT-Quận Phú Nhuận",
        "district": "Phú Nhuận",
        "lat": 10.799,
        "lng": 106.677
      },
      {
        "name": "Phòng Khám Đa Khoa FPT-Quận Tân Bình",
        "district": "Tân Bình",
        "lat": 10.800,
        "lng": 106.647
      },
      {
        "name": "Phòng Khám Đa Khoa FPT-Quận Thủ Đức",
        "district": "Thủ Đức",
        "lat": 10.853,
        "lng": 106.736
      },
    ];

    Set<Marker> newMarkers = clinics
        .map((clinic) => Marker(
              markerId: MarkerId(clinic["name"]),
              position: LatLng(clinic["lat"], clinic["lng"]),
              icon: clinicIcon,
              infoWindow: InfoWindow(
                title: clinic["name"],
                snippet: clinic["district"],
                onTap: () => _showClinicDialog(clinic["name"]),
              ),
            ))
        .toSet();

    setState(() {
      markers = newMarkers;
    });
  }

  void _showClinicDialog(String clinicName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(clinicName),
          content: const Text("Bạn có muốn xem chi tiết phòng khám này không?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Đóng"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ClinicScreen()),
                );
              },
              child: const Text("Đặt lịch ngay"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              myLocationEnabled: true,
              onMapCreated: (controller) => mapController = controller,
              zoomControlsEnabled: false,
              markers: markers,
              initialCameraPosition: const CameraPosition(
                zoom: 14,
                target: LatLng(10.853044766455003, 106.62679932231619),
              ),
            ),
            GestureDetector(
              onTap: () async {
                DataSearchModel? data = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SearchAddressPage()),
                );
                if (data != null) {
                  mapController.animateCamera(
                    CameraUpdate.newLatLng(LatLng(data.lat!, data.lng!)),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: FormFieldWidget(
                  setValueFunc: (value) {},
                  borderColor: Colors.black,
                  radiusBorder: 20,
                  labelText: 'Nhập địa chỉ tìm kiếm',
                  padding: 15,
                  isEnabled: false,
                  icon: const Icon(Icons.search),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
