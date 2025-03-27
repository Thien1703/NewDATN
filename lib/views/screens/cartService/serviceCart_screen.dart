import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/models/service.dart';
import 'package:health_care/viewmodels/api/service_api.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
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

    setState(() {
      filteredServices = groupedServices.map((category, services) {
        var filteredList = services
            .where((service) => service.name.toLowerCase().contains(query))
            .toList();
        return MapEntry(category, filteredList);
      })
        ..removeWhere((key, value) => value.isEmpty);
    });

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
  int getTotalPrice() {
    return selectedServices
        .fold(0.0, (sum, service) => sum + service.price)
        .round();
  }

  String formatCurrency(int amount) {
    final formatter = NumberFormat("#,###", "vi_VN");
    return "${formatter.format(amount)}đ";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.deepBlue,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Chọn dịch vụ',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          // Thanh tìm kiếm
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm chuyên khoa/dịch vụ...',
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  prefixIcon: const Icon(Icons.search,
                      color: AppColors.accent, size: 22),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            searchController.clear();
                            _filterServices();
                            setState(() {});
                          },
                        )
                      : null,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(fontSize: 16),
                onChanged: (value) {
                  setState(() {});
                  _filterServices();
                },
              ),
            ),
          ),

          // Danh sách dịch vụ
          Expanded(
            child: filteredServices.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView(
                      children: filteredServices.entries.map((entry) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                entry.key,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.deepBlue,
                                ),
                              ),
                            ),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 5,
                                childAspectRatio: 0.75,
                              ),
                              itemCount: entry.value.length,
                              itemBuilder: (context, index) {
                                final service = entry.value[index];
                                bool isSelected =
                                    selectedServices.contains(service);
                                return GestureDetector(
                                  onTap: () => _toggleService(service),
                                  child: Card(
                                    elevation: isSelected ? 6 : 3,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      side: isSelected
                                          ? BorderSide(
                                              color: AppColors.accent, width: 2)
                                          : BorderSide.none,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Image.network(
                                              service.image,
                                              width: double.infinity,
                                              height: 90,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Container(
                                                  height: 90,
                                                  width: double.infinity,
                                                  color: Colors.grey[300],
                                                  child: const Icon(
                                                      Icons.broken_image,
                                                      size: 50,
                                                      color: Colors.grey),
                                                );
                                              },
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            service.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(Icons.monetization_on,
                                                  size: 22,
                                                  color: Colors.yellow),
                                              const SizedBox(width: 4),
                                              Text(
                                                service.formattedPrice,
                                                style: const TextStyle(
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 19,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          Center(
                                            child: ElevatedButton(
                                              onPressed: () =>
                                                  _toggleService(service),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: isSelected
                                                    ? AppColors.accent
                                                    : Colors.white,
                                                foregroundColor: isSelected
                                                    ? Colors.white
                                                    : AppColors.accent,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: Text(isSelected
                                                  ? 'Bỏ chọn'
                                                  : 'Chọn dịch vụ'),
                                            ),
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
        ],
      ),

      // thanh toán
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Tổng thanh toán",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  '${formatCurrency(getTotalPrice())}',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.deepBlue),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: selectedServices.isEmpty
                  ? null
                  : () {
                      Navigator.pop(context, {
                        'selectedServiceList': selectedServices.toList(),
                        'selectedServiceId':
                            selectedServices.map((s) => s.id).toList(),
                      });
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    selectedServices.isEmpty ? Colors.grey : AppColors.accent,
                foregroundColor: Colors.white,
              ),
              child: const Text('XONG'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
