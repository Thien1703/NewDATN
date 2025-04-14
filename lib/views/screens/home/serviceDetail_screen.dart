import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/models/rating/rating.dart';
import 'package:health_care/models/service.dart';
import 'package:health_care/viewmodels/api/rating_api.dart';
import 'package:health_care/viewmodels/api/service_api.dart';
import 'package:health_care/views/widgets/widget_header_body.dart';

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
    List<Rating>? dataRating;
    if (data != null) {
      dataRating = await RatingApi.getRatingByService(widget.serviceId);
    }
    setState(() {
      services = data;
      ratings = dataRating;
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WidgetHeaderBody(
      iconBack: true,
      title: services?.name ?? 'Không xác định',
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : services != null
                  ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 10),
                            Container(
                              height: 200,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26, // màu bóng
                                    blurRadius: 8, // độ mờ
                                    offset: Offset(0, 4), // vị trí bóng (x, y)
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(12), // Góc bo
                                child: Image.network(
                                  services!.image,
                                  fit: BoxFit.cover,
                                  height: 200,
                                  width: double.infinity,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                        child: CircularProgressIndicator());
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.broken_image,
                                        size: 100, color: Colors.grey);
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Chuyên khoa: ',
                                    style: TextStyle(
                                      color:
                                          AppColors.deepBlue, // màu xanh dương
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: services!.specialty.name,
                                    style: TextStyle(
                                      color: Colors.black, // hoặc giữ mặc định
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Dịch vụ: ',
                                    style: TextStyle(
                                      color:
                                          AppColors.deepBlue, // màu xanh dương
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: services?.name ?? 'Không xác định',
                                    style: TextStyle(
                                      color: Colors
                                          .black, // giữ màu đen hoặc chỉnh tùy thích
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Giá: ',
                                    style: TextStyle(
                                      color:
                                          AppColors.deepBlue, // màu xanh dương
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: services!.price.toString(),
                                    style: TextStyle(
                                      color: Colors.black, // màu chữ của giá
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Mô tả: ',
                                    style: TextStyle(
                                      color:
                                          AppColors.deepBlue, // màu xanh dương
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: services!.description,
                                    style: TextStyle(
                                      color: Colors.black, // màu chữ của giá
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Text(services!.averageRating.toString()),
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                SizedBox(width: 5),
                                Text('Đánh giá dịch vụ'),
                              ],
                            ),
                            SizedBox(height: 15),
                            ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: ratings!.length,
                              itemBuilder: (context, index) {
                                final rating = ratings![index];
                                return Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 1),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(rating.customerName),
                                      SizedBox(height: 5),
                                      Row(
                                        children: List.generate(5, (index) {
                                          return Icon(
                                            index < rating.stars
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: Colors.amber,
                                            size: 20,
                                          );
                                        }),
                                      ),
                                      SizedBox(height: 5),
                                      Text(rating.comment ?? 'Không xác định'),
                                    ],
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    )
                  : Text('Không có dịch vụ'),
        ),
      ),
    );
  }
}
