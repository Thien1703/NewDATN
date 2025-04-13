import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/viewmodels/api/service_api.dart';
import 'package:health_care/views/screens/home/serviceDetail_screen.dart';
import 'package:health_care/views/widgets/widget_header_body.dart';
import 'package:health_care/models/service.dart';
import 'package:health_care/views/screens/clinic/clinic_screen.dart';

class ServiceScreen extends StatefulWidget {
  ServiceScreen({super.key, required this.specialtyId});
  final int specialtyId;

  @override
  State<ServiceScreen> createState() => _ServiceScreen();
}

class _ServiceScreen extends State<ServiceScreen> {
  List<Service> services = [];
  List<Service>? filteredServices;
  TextEditingController searchController = TextEditingController();
  String specialtyName = 'Dich vụ';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchServicesById();
  }

  void fetchServicesById() async {
    List<Service>? data = await ServiceApi.getAllServeById(widget.specialtyId);
    if (mounted) {
      setState(() {
        services = data;
        filteredServices = data;
        // if (services.isNotEmpty) {
        //   specialtyName = services.first.specialty.name;
        // }
        isLoading = false;
      });
    }
  }

  void filterServices(String query) {
    setState(() {
      filteredServices = services
          .where((service) =>
              service.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WidgetHeaderBody(
      iconBack: true,
      title: specialtyName,
      color: AppColors.ghostWhite,
      iconShare: true,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: isLoading
            ? Container(
                width: double.infinity,
                height: 700,
                alignment: Alignment.center,
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(strokeWidth: 3),
                ),
              )
            : services.isEmpty
                ? Container(
                    width: double.infinity,
                    height: 700,
                    alignment: Alignment.center,
                    child: Text(
                      'Chưa có dịch vụ nào',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    child: Container(
                      color: AppColors.ghostWhite,
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 30,
                                      width: 7,
                                      decoration: BoxDecoration(
                                        color:
                                            AppColors.deepBlue.withOpacity(0.6),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      specialtyName,
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.deepBlue,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: Text(
                                    services.first.specialty.description,
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black.withOpacity(0.8),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  children: [
                                    Container(
                                      height: 30,
                                      width: 7,
                                      decoration: BoxDecoration(
                                        color:
                                            AppColors.deepBlue.withOpacity(0.6),
                                      ),
                                    ),
                                    // Icon(
                                    //   Icons.fiber_manual_record,
                                    //   size: 10,
                                    //   color: AppColors.deepBlue,
                                    // ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        'Cùng phòng khám đa khoa FPT tìm hiểu các dịch vụ về ${specialtyName}',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.deepBlue,
                                        ),
                                        softWrap: true,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),

                          // Display the filtered services
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            child: filteredServices == null ||
                                    filteredServices!.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      'Chưa có dịch vụ nào',
                                      style: TextStyle(
                                          color: Colors.black54, fontSize: 16),
                                    ),
                                  )
                                : GridView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    physics:
                                        NeverScrollableScrollPhysics(), // Disable scroll for GridView
                                    itemCount: filteredServices!.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 15,
                                      mainAxisSpacing: 15,
                                      childAspectRatio: 0.9,
                                    ),
                                    itemBuilder: (context, index) {
                                      final service = filteredServices![index];
                                      return InkWell(
                                        onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ServicedetailScreen(
                                                      serviceId: service.id),
                                            )),
                                        child: Card(
                                          elevation: 3,
                                          color: Colors.white,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        top: Radius.circular(
                                                            16)),
                                                child: Image.network(
                                                  service.image,
                                                  height: 110,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (_, __, ___) =>
                                                      Container(
                                                    height: 110,
                                                    width: double.infinity,
                                                    color: Colors.grey[300],
                                                    child: Center(
                                                      child: Icon(
                                                        Icons.image,
                                                        color: Colors.grey,
                                                        size: 80,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      service.name,
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                    ),
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
                          SizedBox(height: 24),

                          // Book appointment button
                          if (services.isNotEmpty)
                            Center(
                              child: SizedBox(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.deepBlue,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 80),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ClinicScreen(iconBack: true),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'ĐẶT LỊCH NGAY',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}
