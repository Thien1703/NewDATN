import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/viewmodels/api/service_api.dart';
import 'package:health_care/views/screens/home/serviceDetail_screen.dart';
import 'package:health_care/views/widgets/widget_header_body.dart';
import 'package:health_care/models/service.dart';
import 'package:health_care/views/screens/clinic/clinic_screen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shimmer/shimmer.dart';

class ServiceScreen extends StatefulWidget {
  final int specialtyId;
  const ServiceScreen({super.key, required this.specialtyId});

  @override
  State<ServiceScreen> createState() => _ServiceScreen();
}

class _ServiceScreen extends State<ServiceScreen> {
  List<Service> services = [];
  List<Service>? filteredServices;
  TextEditingController searchController = TextEditingController();
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
      title: 'Dịch vụ',
      color: AppColors.ghostWhite,
      iconAdd: false,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: isLoading
            ? buildShimmerBody()
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
                                      services!.first.specialty.name,
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
                                        'Cùng phòng khám đa khoa FPT tìm hiểu các dịch vụ về ${services!.first.specialty.name}',
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
                                      childAspectRatio: 0.85,
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
                                            child: Stack(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                              top: Radius
                                                                  .circular(
                                                                      16)),
                                                      child: Image.network(
                                                        service.image,
                                                        height: 120,
                                                        width: double.infinity,
                                                        fit: BoxFit.cover,
                                                        errorBuilder:
                                                            (_, __, ___) =>
                                                                Container(
                                                          height: 120,
                                                          width:
                                                              double.infinity,
                                                          color:
                                                              Colors.grey[300],
                                                          child: Center(
                                                            child: Icon(
                                                              Icons.image,
                                                              color:
                                                                  Colors.grey,
                                                              size: 80,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            service.name,
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 2,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Positioned(
                                                  top: 90,
                                                  right: 0,
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 5,
                                                        vertical: 3),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              245,
                                                              244,
                                                              244),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          service.averageRating
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 11),
                                                        ),
                                                        Icon(Icons.star,
                                                            color:
                                                                AppColors.star,
                                                            size: 20),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )),
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
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget buildShimmerGrid() {
    return Container(
      child: Column(
        children: [
          GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 6,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(16)),
                        child: Container(
                          height: 120,
                          width: double.infinity,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 12,
                              width: double.infinity,
                              color: Colors.white,
                            ),
                            SizedBox(height: 6),
                            Container(
                              height: 12,
                              width: 80,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget buildShimmerBody() {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 15),
        color: AppColors.ghostWhite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // shimmer tiêu đề chuyên khoa
            Row(
              children: [
                Container(
                  height: 30,
                  width: 7,
                  color: Colors.grey[300],
                ),
                SizedBox(width: 10),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 35,
                    width: 80,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            // shimmer mô tả
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 90,
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 15),
                color: Colors.white,
              ),
            ),
            SizedBox(height: 35),
            // shimmer hàng giới thiệu
            Row(
              children: [
                Container(
                  height: 30,
                  width: 7,
                  color: Colors.grey[300],
                ),
                SizedBox(width: 10),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 30,
                    width: 340,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // shimmer danh sách dịch vụ
            buildShimmerGrid(),
            SizedBox(height: 24),
            // shimmer button
            Center(
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: 45,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
