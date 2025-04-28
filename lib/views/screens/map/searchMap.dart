import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:health_care/views/screens/clinic/clinic_screen.dart';
import 'package:health_care/views/screens/map/data_search_model.dart';
import 'package:health_care/views/screens/map/form_field_widget.dart';
import 'package:health_care/views/screens/map/mapmodel.dart';
import 'package:geolocator/geolocator.dart';
import 'package:health_care/views/screens/map/map_service.dart';
import 'package:health_care/views/screens/map/search_map_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late GoogleMapController mapController;
  Set<Marker> markers = {};
  late BitmapDescriptor clinicIcon;
  List<MapModel> clinicList = [];
  late ScrollController _scrollController;
  int _currentIndex = 0;
  late PageController _pageController;
  int _currentPage = 0;
  final double _itemWidth = 200.0;
  final double _spacing = 16.0;

  @override
  void initState() {
    super.initState();
    _loadCustomMarker();
    _goToCurrentLocation();
    _pageController = PageController(
      viewportFraction: 0.8,
      initialPage: clinicList.length * 1000, // Tạo hiệu ứng vô hạn
    );
    _pageController.addListener(_handleScroll);
  }

  void _handleScroll() {
    final newPage = _pageController.page?.round() ?? 0;
    if (newPage != _currentPage) {
      setState(() {
        _currentPage = newPage % clinicList.length;
      });
      _moveToClinic(clinicList[_currentPage]);
    }
  }

  void _moveToClinic(MapModel clinic) {
    mapController.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(clinic.latitude, clinic.longitude),
        14,
      ),
    );
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
      'assets/icons/maker2.png',
    );
    _generateMarkersFromApi();
  }

  Future<void> _generateMarkersFromApi() async {
    try {
      final clinics = await ClinicService.fetchClinics();

      Set<Marker> newMarkers = clinics.map((clinic) {
        return Marker(
          markerId: MarkerId(clinic.id.toString()),
          position: LatLng(clinic.latitude, clinic.longitude),
          icon: clinicIcon,
          infoWindow: InfoWindow(
            title: clinic.name,
            snippet: clinic.address,
            onTap: () => _showClinicDialog(clinic),
          ),
        );
      }).toSet();

      setState(() {
        markers.addAll(newMarkers);
        clinicList = clinics;
      });
    } catch (e) {
      debugPrint("Lỗi khi load API phòng khám: $e");
    }
  }

  void _showClinicDialog(MapModel clinic) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(clinic.name),
          content: Text("Bạn có muốn xem chi tiết phòng khám này không?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Đóng"),
            ),
            ElevatedButton(
              onPressed: () {
                // Trước tiên đóng dialog
                Navigator.pop(context);
                // Lấy tên phòng khám và chuyển đến ClinicScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClinicScreen(
                      clinicName: clinic.name, // Truyền giá trị từ SearchScreen
                      iconBack: true,
                    ),
                  ),
                );
              },
              child: const Text("Đặt lịch ngay"),
            )
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
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
            if (clinicList.isNotEmpty)
              Container(
                height: 180,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) => _handleScroll(),
                  itemBuilder: (context, index) {
                    final clinic = clinicList[index % clinicList.length];
                    return GestureDetector(
                      onTap: () {
                        _pageController.animateToPage(
                          index,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Container(
                        width: _itemWidth,
                        margin: EdgeInsets.symmetric(horizontal: _spacing / 2),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue[800]!, Colors.blue[400]!],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            )
                          ],
                          border: Border.all(
                            color: _currentPage % clinicList.length ==
                                    index % clinicList.length
                                ? Colors.yellow
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16)),
                                // child: Image.network(
                                //   clinic.image,
                                //   fit: BoxFit.cover,
                                //   width: double.infinity,
                                // ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    clinic.name,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    clinic.address,
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 8),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.yellow,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      "GIẢM NGAY 50K",
                                      style: TextStyle(
                                        color: Colors.blue[900],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
