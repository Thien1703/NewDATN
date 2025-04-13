import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/models/clinic.dart';
import 'package:health_care/models/rating/rating.dart';
import 'package:health_care/models/service.dart';
import 'package:health_care/viewmodels/api/clinic_api.dart';
import 'package:health_care/viewmodels/api/rating_api.dart';
import 'package:health_care/viewmodels/api/service_api.dart';
import 'package:health_care/views/screens/clinic/clinic_screen.dart';

class ServicedetailScreen extends StatefulWidget {
  const ServicedetailScreen({super.key, required this.serviceId});
  final int serviceId;

  @override
  State<ServicedetailScreen> createState() => _ServicedetailScreen();
}

class _ServicedetailScreen extends State<ServicedetailScreen> {
  Service? services;
  List<Rating>? ratings;
  bool isLoading = false;
  List<Clinic>? clinics;

  @override
  void initState() {
    super.initState();
    fetchServices();
  }

  void fetchServices() async {
    setState(() {
      isLoading = true;
    });
    Service? data = await ServiceApi.getServiceById(widget.serviceId);
    List<Clinic>? dataClinic = await ClinicApi.getAllClinic();

    List<Rating>? dataRating;
    if (data != null) {
      dataRating = await RatingApi.getRatingByService(widget.serviceId);
    }
    setState(() {
      services = data;
      ratings = dataRating;
      clinics = dataClinic;
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  toolbarHeight: 80,
                  automaticallyImplyLeading: false,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 18,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(20),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              offset: Offset(0, 2),
                              blurRadius: 10,
                              spreadRadius: 1,
                            )
                          ]),
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 5, bottom: 10),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 40),
                        child: Center(
                          child: Text(
                            services!.name,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  pinned: true,
                  backgroundColor: AppColors.deepBlue,
                  expandedHeight: 300,
                  flexibleSpace: FlexibleSpaceBar(
                    background: services!.image == null
                        ? Container(
                            height: double.maxFinite,
                            color: Colors.grey[300],
                            child: Center(
                              child: Icon(
                                Icons.image,
                                color: Colors.grey,
                                size: 80,
                              ),
                            ),
                          )
                        : services!.image!
                                .startsWith('http') // Check if it's a URL
                            ? Image.network(
                                services!.image!,
                                width: double.maxFinite,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                services!.image!,
                                width: double.maxFinite,
                                fit: BoxFit.cover,
                              ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    color: AppColors.ghostWhite,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height - 300),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration:
                                BoxDecoration(color: Colors.white, boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                offset: Offset(0, 4),
                                blurRadius: 10,
                                spreadRadius: 1,
                              )
                            ]),
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Chuyên khoa: ',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        services!.specialty.name,
                                        style: TextStyle(
                                          color: AppColors.deepBlue,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    services!.description,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                  SizedBox(height: 15),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Row(
                                      children: [
                                        Text(
                                          services!.averageRating.toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Colors.black.withOpacity(0.8),
                                            fontSize: 14,
                                          ),
                                        ),
                                        Icon(
                                          Icons.star_rate_rounded,
                                          color: const Color(0xFFE0AA08),
                                          size: 25,
                                        ),
                                        SizedBox(width: 5),
                                        Icon(
                                          Icons.fiber_manual_record,
                                          size: 10,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          '${services!.reviewCount.toString()} đánh giá',
                                          style: TextStyle(
                                            color: AppColors.deepBlue,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Giá: ${services!.formattedPrice}',
                                    style: TextStyle(
                                      color: AppColors.deepBlue,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 15),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 1),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Các phòng khám',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(height: 15),
                                          clinics != null && clinics!.isNotEmpty
                                              ? ListView.builder(
                                                  padding: EdgeInsets.zero,
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  itemCount: clinics!.length > 3
                                                      ? 3
                                                      : clinics!.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final clinic =
                                                        clinics![index];
                                                    return Container(
                                                      margin: EdgeInsets.only(
                                                          bottom: 30),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            clinic!.name,
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .access_time_filled_rounded,
                                                                color:
                                                                    Colors.grey,
                                                                size: 20,
                                                              ),
                                                              SizedBox(
                                                                  width: 5),
                                                              Text(
                                                                  'Mở cửa từ 06:00 đến 21:00'),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .location_on_rounded,
                                                                color:
                                                                    Colors.grey,
                                                                size: 21,
                                                              ),
                                                              SizedBox(
                                                                  width: 5),
                                                              Expanded(
                                                                child: Text(
                                                                  clinic
                                                                      .address,
                                                                  softWrap:
                                                                      true,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                )
                                              : Text('Ko có phòng khám'),
                                          Center(
                                            child: InkWell(
                                              onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ClinicScreen(),
                                                ),
                                              ),
                                              child: Text(
                                                'Xem phòng khám khác',
                                                style: TextStyle(
                                                    color: AppColors.deepBlue,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          )
                                        ],
                                      ))
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            decoration:
                                BoxDecoration(color: Colors.white, boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                offset: Offset(4, 0),
                                blurRadius: 10,
                                spreadRadius: 1,
                              )
                            ]),
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 13, vertical: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Đánh giá sản phẩm',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        '(${services!.reviewCount} đánh giá)',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black.withOpacity(0.6),
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 7, bottom: 3),
                                    child: Text(
                                      'Trung bình',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        services!.averageRating.toString(),
                                        style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 10),
                                        child: Icon(
                                          Icons.star_rate_rounded,
                                          color: const Color(0xFFE0AA08),
                                          size: 30,
                                        ),
                                      )
                                    ],
                                  ),

                                  // Đếm số lượt đánh giá cho từng mức sao
                                  ratings != null && ratings!.isNotEmpty
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: List.generate(5, (index) {
                                            int starRating =
                                                5 - index; // 5, 4, 3, 2, 1 sao
                                            int count = ratings!
                                                .where((rating) =>
                                                    rating.stars == starRating)
                                                .length;
                                            int totalReviews = ratings!.length;

                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 6),
                                              child: Row(
                                                children: [
                                                  // Các ngôi sao
                                                  Row(
                                                    children: List.generate(5,
                                                        (starIndex) {
                                                      return Icon(
                                                        Icons.star_rate_rounded,
                                                        color: starIndex <
                                                                starRating
                                                            ? const Color(
                                                                0xFFE0AA08)
                                                            : Colors
                                                                .grey.shade400,
                                                        size: 23,
                                                      );
                                                    }),
                                                  ),
                                                  SizedBox(width: 10),

                                                  // Thanh phần trăm đánh giá
                                                  Expanded(
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          height: 8,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .grey.shade300,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                        ),
                                                        FractionallySizedBox(
                                                          widthFactor:
                                                              totalReviews == 0
                                                                  ? 0
                                                                  : count /
                                                                      totalReviews,
                                                          child: Container(
                                                            height: 8,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Color(
                                                                  0xFFE0AA08),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  SizedBox(width: 10),
                                                  Text(
                                                    '$count',
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color:
                                                          Colors.grey.shade700,
                                                    ),
                                                    textAlign: TextAlign.end,
                                                  ),
                                                  SizedBox(width: 10),
                                                ],
                                              ),
                                            );
                                          }),
                                        )
                                      : Text('Chưa có đánh giá nào',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey)),
                                  SizedBox(height: 10),
                                  // Hiển thị danh sách các đánh giá (nếu có)
                                  ratings != null && ratings!.isNotEmpty
                                      ? ListView.builder(
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: ratings!.length,
                                          itemBuilder: (context, index) {
                                            final rating = ratings![index];
                                            return Container(
                                              margin: EdgeInsets.only(left: 10),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Image.asset(
                                                    'assets/images/iconProfile.jpg',
                                                    width: 50,
                                                  ),
                                                  SizedBox(width: 15),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        rating.customerName,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      SizedBox(height: 3),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            '${rating.stars.toString()}.0',
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.6),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15,
                                                            ),
                                                          ),
                                                          Icon(
                                                            Icons
                                                                .star_rate_rounded,
                                                            color: const Color(
                                                                0xFFE0AA08),
                                                            size: 20,
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(height: 3),
                                                      Text(
                                                        rating.comment ??
                                                            'Không xác định',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black
                                                              .withOpacity(0.7),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                        )
                                      : Text(
                                          'Chưa có đánh giá nào',
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.grey),
                                        ),
                                  SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
