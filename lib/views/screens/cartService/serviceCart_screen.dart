import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/models/service.dart';
import 'package:health_care/viewmodels/api/service_api.dart';
import 'package:intl/intl.dart';

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
  String selectedSpecialty = ''; // Lưu chuyên khoa đang được chọn

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

  void _selectSpecialty(String specialty) {
    setState(() {
      selectedSpecialty = specialty;
      if (specialty.isEmpty) {
        filteredServices =
            groupedServices; // Hiển thị tất cả dịch vụ khi không có chuyên khoa được chọn
      } else {
        filteredServices = {specialty: groupedServices[specialty]!};
      }
    });
  }

  void _toggleService(Service service) {
    setState(() {
      if (selectedServices.contains(service)) {
        selectedServices.remove(service);
      } else {
        selectedServices.add(service);
      }
    });
  }

  int getTotalPrice() {
    return selectedServices
        .fold(0.0, (sum, service) => sum + service.price)
        .round();
  }

  String formatCurrency(int amount) {
    final formatter = NumberFormat("#,###", "vi_VN");
    return "${formatter.format(amount)}VNĐ";
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
      body: Container(
        color: AppColors.ghostWhite,
        child: Column(
          children: [
            // Thanh tìm kiếm
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                      color: AppColors.softBlue,
                      width: 1.5), // Đổi màu và độ dày border theo yêu cầu
                ),
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    const Icon(Icons.search,
                        color: AppColors.softBlue), // Tạo icon tìm kiếm
                    const SizedBox(width: 5),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: const InputDecoration(
                          hintText: 'Tìm kiếm dịch vụ, theo tên hoặc loại...',
                          hintStyle: TextStyle(
                            fontSize: 14, // Đặt kích thước font cho placeholder
                          ),
                          border:
                              InputBorder.none, // Loại bỏ border của TextField
                          isDense:
                              true, // Đảm bảo rằng trường input không quá cao
                        ),
                      ),
                    ),
                    if (searchController.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear,
                            color: Colors.black54), // Clear icon
                        onPressed: () {
                          searchController.clear();
                          _filterServices(); // Clear filter khi icon được nhấn
                        },
                      ),
                  ],
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
                        children: [
                          // Row Chuyên khoa
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: SingleChildScrollView(
                              scrollDirection: Axis
                                  .horizontal, // Make the row scrollable horizontally
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  // Nút "Tất cả" luôn hiển thị
                                  GestureDetector(
                                    onTap: () => _selectSpecialty(
                                        ''), // Lọc tất cả dịch vụ
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: Chip(
                                        label: const Text('Tất cả'),
                                        backgroundColor:
                                            selectedSpecialty.isEmpty
                                                ? AppColors.accent
                                                : Colors.grey[300],
                                      ),
                                    ),
                                  ),
                                  // Các chuyên khoa khác
                                  ...groupedServices.keys.map((specialty) {
                                    return GestureDetector(
                                      onTap: () => _selectSpecialty(specialty),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Chip(
                                          label: Text(specialty),
                                          backgroundColor:
                                              selectedSpecialty == specialty
                                                  ? AppColors.accent
                                                  : Colors.grey[300],
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),
                          ...filteredServices.entries.map(
                            (entry) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
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
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 5,
                                      mainAxisSpacing: 5,
                                      childAspectRatio: 0.8,
                                    ),
                                    itemCount: entry.value.length,
                                    itemBuilder: (context, index) {
                                      final service = entry.value[index];
                                      bool isSelected =
                                          selectedServices.contains(service);
                                      return GestureDetector(
                                        onTap: () => _toggleService(service),
                                        child: Card(
                                          color: Colors.white,
                                          elevation: isSelected ? 6 : 3,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            side: isSelected
                                                ? BorderSide(
                                                    color: AppColors.deepBlue,
                                                    width: 2)
                                                : BorderSide.none,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.grey
                                                            .withOpacity(0.5),
                                                        width: 1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    child: Image.network(
                                                      service.image,
                                                      width: double.infinity,
                                                      height: 90,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        return Container(
                                                          height: 80,
                                                          width:
                                                              double.infinity,
                                                          color:
                                                              Colors.grey[300],
                                                          child: const Icon(
                                                              Icons
                                                                  .broken_image,
                                                              size: 50,
                                                              color:
                                                                  Colors.grey),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  service.name,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),

                                                const SizedBox(height: 4),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      service.formattedPrice,
                                                      style: const TextStyle(
                                                        color: Colors.black54,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Icon(Icons.star,
                                                            color:
                                                                Colors.amber),
                                                        Text(
                                                          service.averageRating
                                                              .toString(),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                const Spacer(),
                                                // Center(
                                                //   child: ElevatedButton(
                                                //     onPressed: () =>
                                                //         _toggleService(service),
                                                //     style: ElevatedButton.styleFrom(
                                                //       backgroundColor: isSelected
                                                //           ? AppColors.accent
                                                //           : Colors.white,
                                                //       foregroundColor: isSelected
                                                //           ? Colors.white
                                                //           : AppColors.accent,
                                                //       shape: RoundedRectangleBorder(
                                                //         borderRadius:
                                                //             BorderRadius.circular(
                                                //                 8),
                                                //       ),
                                                //     ),
                                                //     child: Text(isSelected
                                                //         ? 'Bỏ chọn'
                                                //         : 'Chọn dịch vụ'),
                                                //   ),
                                                // )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
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
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
            Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      "Tổng thanh toán",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                    ),
                    Text(
                      formatCurrency(getTotalPrice()),
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.deepBlue),
                    ),
                  ],
                ),
                SizedBox(width: 5),
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
                    backgroundColor: selectedServices.isEmpty
                        ? Colors.white
                        : AppColors.deepBlue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('XONG'),
                ),
              ],
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
