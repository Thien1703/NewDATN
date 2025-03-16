import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/models/service.dart';
import 'package:health_care/viewmodels/api/service_api.dart';
import 'package:health_care/views/widgets/widget_header_body.dart';

class ServiceCartScreen extends StatefulWidget {
  const ServiceCartScreen({super.key});

  @override
  State<ServiceCartScreen> createState() => _ServiceCartScreenState();
}

class _ServiceCartScreenState extends State<ServiceCartScreen> {
  List<Service>? services;
  Map<String, List<Service>> groupedServices = {};
  Map<String, List<Service>> filteredServices = {};
  TextEditingController searchController = TextEditingController();
  Set<Service> selectedServices = {}; // Danh sách dịch vụ đã chọn

  @override
  void initState() {
    super.initState();
    fetchServices();
    searchController.addListener(_filterServices);
  }

  void fetchServices() async {
    List<Service>? data = await ServiceApi.getAllServe();
    if (data != null) {
      setState(() {
        services = data;
        groupedServices = _groupBySpecialty(data);
        filteredServices = groupedServices;
      });
    }
  }

  Map<String, List<Service>> _groupBySpecialty(List<Service> services) {
    Map<String, List<Service>> grouped = {};
    for (var service in services) {
      String specialtyName = service.specialty.name ?? 'Không xác định';
      if (!grouped.containsKey(specialtyName)) {
        grouped[specialtyName] = [];
      }
      grouped[specialtyName]?.add(service);
    }
    return grouped;
  }

  void _filterServices() {
    String query = searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        filteredServices = groupedServices;
      });
      return;
    }

    Map<String, List<Service>> temp = {};
    groupedServices.forEach((specialty, serviceList) {
      List<Service> filteredList = serviceList.where((service) {
        return service.name.toLowerCase().contains(query) ||
            specialty.toLowerCase().contains(query);
      }).toList();

      if (filteredList.isNotEmpty) {
        temp[specialty] = filteredList;
      }
    });

    setState(() {
      filteredServices = temp;
    });
  }

  /// Toggle chọn/bỏ chọn dịch vụ
  void _toggleService(Service service) {
    setState(() {
      if (selectedServices.contains(service)) {
        selectedServices.remove(service);
      } else {
        selectedServices.add(service);
      }
    });
  }

  /// Tính tổng tiền của dịch vụ đã chọn
  double getTotalPrice() {
    return selectedServices.fold(
        0.0, (sum, service) => sum + (service.price ?? 0.0));
  }

  @override
  Widget build(BuildContext context) {
    return WidgetHeaderBody(
      iconBack: true,
      title: 'Chọn dịch vụ',
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm chuyên khoa/dịch vụ',
                prefixIcon: const Icon(Icons.search, color: AppColors.accent),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Danh sách dịch vụ có thể cuộn
          Expanded(
            child: services == null
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: filteredServices.entries.map((entry) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  entry.key,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.deepBlue,
                                  ),
                                ),
                              ),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                ),
                                itemCount: entry.value.length,
                                itemBuilder: (context, index) {
                                  final service = entry.value[index];
                                  bool isSelected =
                                      selectedServices.contains(service);
                                  return GestureDetector(
                                    onTap: () => _toggleService(service),
                                    child: Card(
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        side: isSelected
                                            ? BorderSide(
                                                color: AppColors.accent,
                                                width: 2)
                                            : BorderSide.none,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              service.name,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              'Giá: ${service.price}đ',
                                              style: const TextStyle(
                                                  color: Colors.black54),
                                            ),
                                            const Spacer(),
                                            OutlinedButton(
                                              onPressed: () =>
                                                  _toggleService(service),
                                              child: Text(isSelected
                                                  ? 'Bỏ chọn'
                                                  : 'Chọn dịch vụ'),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
          ),

          // Thanh tổng hợp dịch vụ đã chọn
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Đã chọn ${selectedServices.length} dịch vụ',
                  style: const TextStyle(fontSize: 16),
                ),
                Column(
                  children: [
                    Text(
                      '${getTotalPrice()}đ',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    OutlinedButton(
                      onPressed: selectedServices.isEmpty
                          ? null
                          : () {
                              Navigator.pop(context, {
                                'selectedServiceList':
                                    selectedServices.toList(),
                                'selectedServiceId':
                                    selectedServices.map((s) => s.id).toList(),
                              });
                            },
                      child: const Text('Xong'),
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

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
