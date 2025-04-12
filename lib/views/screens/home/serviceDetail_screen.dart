import 'package:flutter/material.dart';
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
        child: Container(
          width: double.infinity,
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : services != null
                  ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            Image.network(
                              services!.image,
                              fit: BoxFit.cover,
                            ),
                            Text(
                              'Chuyên khoa: ${services!.specialty.name}',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'Dịch vụ: ${services?.name ?? 'Không xác định'}',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'Giá: ${services!.price.toString()}',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'Mô tả: ${services!.description}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 10),
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
                            SizedBox(height: 5),
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
                                      Text(rating?.comment ?? 'Không xác định'),
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
