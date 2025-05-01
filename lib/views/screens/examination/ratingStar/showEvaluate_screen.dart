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
    fetchRatingsAndServices();
  }

  void fetchRatingsAndServices() async {
    List<Rating>? data =
        await RatingApi.getRatingByAppointment(widget.appointmentId);
    if (data != null) {
      Map<int, Service> fetchedServices = {};
      for (var r in data) {
        int serviceId = r.serviceId ?? 0;
        if (serviceId != 0) {
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
          ? Center(
              child: CircularProgressIndicator(strokeWidth: 3),
            )
          : Container(
              color: AppColors.ghostWhite,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: ListView.separated(
                itemCount: rating!.length,
                separatorBuilder: (_, __) => SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final r = rating![index];
                  final service = serviceMap[r.serviceId];

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.7),
                            blurRadius: 6,
                            offset: Offset(0, 3),
                            spreadRadius: 1)
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header: Customer name + stars
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage:
                                  AssetImage('assets/images/iconProfile.jpg'),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    r.customerName,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: List.generate(5, (i) {
                                      return Icon(
                                        i < r.stars
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: Colors.amber,
                                        size: 18,
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),

                        // Comment
                        Text(
                          r.comment ?? 'Không có bình luận.',
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                        SizedBox(height: 12),
                        Divider(),

                        // Service info
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                service?.image ?? '',
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 70,
                                  height: 70,
                                  color: Colors.grey[300],
                                  child: Icon(Icons.broken_image, size: 30),
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                service?.name ?? 'Dịch vụ không xác định',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}
