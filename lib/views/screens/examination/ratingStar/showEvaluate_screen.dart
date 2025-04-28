import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/models/rating/rating.dart';
import 'package:health_care/viewmodels/api/rating_api.dart';
import 'package:health_care/viewmodels/api/service_api.dart';
import 'package:health_care/views/widgets/widget_header_body.dart';
import 'package:health_care/models/service.dart';

class ShowevaluateScreen extends StatefulWidget {
  final int appointmentId;
  const ShowevaluateScreen({super.key, required this.appointmentId});
  @override
  State<ShowevaluateScreen> createState() => _ShowevaluateScreen();
}

class _ShowevaluateScreen extends State<ShowevaluateScreen> {
  List<Rating>? rating;
  Map<int, Service> serviceMap = {};

  @override
  void initState() {
    super.initState();
    fetchClinics();
  }

  void fetchClinics() async {
    List<Rating>? data =
        await RatingApi.getRatingByAppointment(widget.appointmentId);
    if (data != null) {
      Map<int, Service> fetchedServices = {};
      for (var rating in data) {
        // Kiểm tra null và xử lý mặc định nếu null
        int serviceId = rating.serviceId ?? 0;

        if (serviceId != 0) {
          // Kiểm tra serviceId có hợp lệ không
          Service? service = await ServiceApi.getServiceById(serviceId);
          if (service != null) {
            fetchedServices[serviceId] = service;
          }
        }
      }

      setState(() {
        rating = data;
        serviceMap = fetchedServices;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WidgetHeaderBody(
      iconBack: true,
      title: 'Chi tiết đánh giá',
      body: rating == null
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
          : Container(
              color: AppColors.ghostWhite,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: ListView.builder(
                  padding: EdgeInsets.only(top: 10),
                  shrinkWrap: true,
                  itemCount: rating!.length,
                  itemBuilder: (context, index) {
                    final ratings = rating![index];
                    final service = serviceMap[ratings.serviceId];
                    return Container(
                      child: _buildContainer(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                // Image.asset('assets/images/iconProfile.jpg',width: 30,),
                                Column(
                                  children: [
                                    Text(
                                      ratings.customerName,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Row(
                                      children: List.generate(5, (index) {
                                        return Icon(
                                          index < ratings.stars
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: Colors.amber,
                                          size: 20,
                                        );
                                      }),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Text(ratings.comment ?? 'Không xác định'),
                            Container(
                              child: Row(
                                children: [
                                  Image.network(
                                    service?.image ?? 'không thấy ảnh',
                                    width: 70,
                                  ),
                                  SizedBox(width: 10),
                                  Text(service?.name ?? 'Không rõ dịch vụ'),
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
            ),
    );
  }

  Widget _buildContainer(Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 5,
              spreadRadius: 1),
        ],
      ),
      child: child,
    );
  }
}
