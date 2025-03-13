import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:health_care/views/screens/map/data_search_model.dart';
import 'package:health_care/views/screens/map/form_field_widget.dart';
import 'package:health_care/views/screens/map/search_map_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late GoogleMapController mapController;

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
                // style:
                //     '[{"featureType": "poi.business","stylers": [{ "visibility": "off" }]}]',
                // markers: Set.from(listMarker),
                myLocationEnabled: true,
                onMapCreated: onMapCreated,
                zoomControlsEnabled: false,
                initialCameraPosition: CameraPosition(
                    zoom: 16,
                    target: LatLng(10.854167759297065, 106.62574679688609))),
            GestureDetector(
              onTap: () async {
                DataSearchModel? data = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchAddressPage()),
                );
                if (data != null) {
                  mapController.animateCamera(
                      CameraUpdate.newLatLng(LatLng(data.lat!, data.lng!)));
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
                  icon: Icon(Icons.search),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
