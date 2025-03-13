import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/models/service.dart';
import 'package:health_care/models/specialty.dart';
import 'package:health_care/viewmodels/api/api_service.dart';
import 'package:health_care/viewmodels/api/specialty_api.dart';
import 'package:health_care/views/widgets/widget_header_body_scoller.dart';
import 'package:intl/intl.dart';

class ServicecartScreen extends StatefulWidget {
  const ServicecartScreen({super.key});
  @override
  State<ServicecartScreen> createState() => _ServicecartScreenState();
}

class _ServicecartScreenState extends State<ServicecartScreen> {
  List<Service> services = [];
  Map<String, List<Service>> groupedServices = {};
  Set<int> selectedService = {};
  double totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    List<Service>? serviceData = await ApiService.getAllServe();
    List<Specialty>? specialtyData = await SpecialtyApi.getAllSpecialty();

    if (serviceData != null && specialtyData != null) {
      Map<int, String> specialtyMap = {
        for (var specialty in specialtyData) specialty.id: specialty.name
      };

      for (var service in serviceData) {
        service.specialtyName = specialtyMap[service.specialtyId] ?? 'Khác';
      }

      Map<String, List<Service>> grouped = {};
      for (var service in serviceData) {
        grouped.putIfAbsent(service.specialtyName!, () => []).add(service);
      }

      if (mounted) {
        setState(() {
          services = serviceData;
          groupedServices = grouped;
        });
      }
    }
  }

  void toggleServiceSelection(int serviceId) {
    setState(() {
      if (selectedService.contains(serviceId)) {
        selectedService.remove(serviceId);
      } else {
        selectedService.add(serviceId);
      }
      updateTotalPrice();
    });
  }

  void updateTotalPrice() {
    setState(() {
      totalPrice = services
          .where((service) => selectedService.contains(service.id))
          .fold(0.0, (sum, service) => sum + service.price);
    });
  }

  String formatCurrency(double amount) {
    final formatter = NumberFormat("#,###", "vi_VN");
    return "${formatter.format(amount)}đ";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: WidgetHeaderBodyScoller(
              iconBack: true,
              title: 'Chọn dịch vụ',
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          groupedServices.isNotEmpty
                              ? Column(
                                  children:
                                      groupedServices.entries.map((entry) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 10, bottom: 5),
                                          child: Text(
                                            entry.key,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.accent,
                                            ),
                                          ),
                                        ),
                                        GridView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 8,
                                            mainAxisSpacing: 8,
                                          ),
                                          itemCount: entry.value.length,
                                          itemBuilder: (context, index) {
                                            final service = entry.value[index];
                                            return Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black,
                                                    width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(service.name,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(service.formattedPrice,
                                                      style: TextStyle(
                                                          color: Colors.green)),
                                                  OutlinedButton(
                                                    onPressed: () =>
                                                        toggleServiceSelection(
                                                            service.id),
                                                    style: OutlinedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          selectedService
                                                                  .contains(
                                                                      service
                                                                          .id)
                                                              ? Colors.green
                                                              : Colors.blue,
                                                    ),
                                                    child: Text('Thêm dịch vụ'),
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                )
                              : Center(child: Text('Không có dịch vụ')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(15),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Đã chọn ${selectedService.length} dịch vụ'),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Tổng thanh toán'),
                        Text(formatCurrency(totalPrice)),
                      ],
                    ),
                    OutlinedButton(
                      onPressed: () {
                        List<Service> selectedServiceList = services
                            .where((service) =>
                                selectedService.contains(service.id))
                            .toList();
                        List<int> selectedServiceId = selectedService.toList();
                        print(selectedService);
                        Navigator.pop(context, {
                          'selectedServiceList': selectedServiceList,
                          'selectedServiceId': selectedServiceId,
                        });
                      },
                      child: Text('Xong'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
