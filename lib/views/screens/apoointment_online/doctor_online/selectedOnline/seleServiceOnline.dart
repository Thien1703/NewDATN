import 'package:flutter/material.dart';
import 'package:health_care/models/service.dart';
import 'package:health_care/viewmodels/api/service_api.dart';
import 'package:health_care/views/widgets/bottomSheet/header_bottomSheet.dart';
import 'package:intl/intl.dart'; // Thêm thư viện intl
import 'package:shimmer/shimmer.dart'; // Thêm thư viện shimmer

class Seleserviceonline extends StatefulWidget {
  const Seleserviceonline({super.key, required this.serviceId});
  final String serviceId;

  @override
  State<Seleserviceonline> createState() => _SeleserviceonlineState();
}

class _SeleserviceonlineState extends State<Seleserviceonline> {
  List<Service>? service;

  @override
  void initState() {
    super.initState();
    fetchServices();
  }

  void fetchServices() async {
    int serviceIdInt = int.tryParse(widget.serviceId) ?? 0;
    List<Service>? data = await ServiceApi.getOnlineServeById(serviceIdInt);
    if (data != null) {
      setState(() {
        service = data;
      });
    }
  }

  // Hàm để định dạng giá
  String formatPrice(double price) {
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    return formatCurrency.format(price);
  }

  @override
  Widget build(BuildContext context) {
    return HeaderBottomSheet(
      title: 'Chọn dịch vụ',
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: service == null
            ? Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: 2, // Giới hạn số lượng item cho shimmer
                  itemBuilder: (context, index) {
                    return Container(
                      width: double.infinity,
                      height: 70,
                      margin: EdgeInsets.symmetric(vertical: 6),
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    );
                  },
                ),
              )
            : ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height *
                      0.5, // tối đa 50% chiều cao màn hình
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: service!.length,
                  itemBuilder: (context, index) {
                    final services = service![index];
                    return InkWell(
                      onTap: () {
                        Navigator.pop(context,
                            {'id': services.id, 'name': services.name});
                      },
                      child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[400]!,
                                  blurRadius: 1,
                                  spreadRadius: 1,
                                )
                              ]),
                          margin: EdgeInsets.symmetric(vertical: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                services.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Giá: ',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.amber[500]),
                                  ),
                                  Text(
                                    formatPrice(services.price),
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.amber,
                                        fontWeight: FontWeight.bold),
                                  ), // Định dạng giá
                                ],
                              )
                            ],
                          )),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
