import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/models/service.dart';
import 'package:health_care/viewmodels/api/service_api.dart';
import 'package:intl/intl.dart';

class ServiceCartScreen extends StatefulWidget {
  const ServiceCartScreen({
    super.key,
    required this.specialtyId,
    this.previouslySelected,
  });

  final int specialtyId;
  final List<Service>? previouslySelected;

  @override
  State<ServiceCartScreen> createState() => _ServiceCartScreenState();
}

class _ServiceCartScreenState extends State<ServiceCartScreen> {
  List<Service>? service;
  List<Service>? filteredServices;
  List<Service> selectedServices = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedServices = widget.previouslySelected ?? [];
    searchController.addListener(_filterServices);
    _loadServices();
  }

  void _loadServices() async {
    final result = await ServiceApi.getOfflineServeById(widget.specialtyId);
    setState(() {
      service = result;
      filteredServices = result;
    });
  }

  void _filterServices() {
    if (searchController.text.isEmpty) {
      setState(() {
        filteredServices = service;
      });
    } else {
      setState(() {
        filteredServices = service
            ?.where((s) => s.name
                .toLowerCase()
                .contains(searchController.text.toLowerCase()))
            .toList();
      });
    }
  }

  String formatCurrency(num amount) {
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    return formatCurrency.format(amount);
  }

  @override
  void dispose() {
    searchController.removeListener(_filterServices);
    searchController.dispose();
    super.dispose();
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
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          color: AppColors.ghostWhite,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                        color: const Color.fromARGB(255, 193, 199, 206),
                        width: 1.5),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      const Icon(Icons.search, color: AppColors.deepBlue),
                      const SizedBox(width: 5),
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          decoration: const InputDecoration(
                            hintText: 'Tìm kiếm dịch vụ, theo tên hoặc loại...',
                            hintStyle: TextStyle(fontSize: 14),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Service list
              service == null
                  ? const Expanded(
                      child: Center(child: CircularProgressIndicator()))
                  : filteredServices == null || filteredServices!.isEmpty
                      ? const Expanded(
                          child: Center(child: Text('Không có dịch vụ nào')))
                      : Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.95,
                            ),
                            itemCount: filteredServices!.length,
                            itemBuilder: (context, index) {
                              final services = filteredServices![index];
                              final isSelected = selectedServices
                                  .any((s) => s.id == services.id);

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      selectedServices.removeWhere(
                                          (s) => s.id == services.id);
                                    } else {
                                      selectedServices.add(services);
                                    }
                                  });
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: isSelected
                                          ? AppColors.deepBlue
                                          : Colors.transparent,
                                      width: 1.5,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 4,
                                  color: Colors.white,
                                  child: Stack(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Image.network(
                                            services.image.isNotEmpty
                                                ? services.image
                                                : "assets/images/imageOnErrror.png",
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Image.asset(
                                                "assets/images/imageOnErrror.png",
                                                width: double.infinity,
                                                height: 100,
                                                fit: BoxFit.cover,
                                              );
                                            },
                                            width: double.infinity,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4),
                                            child: Text(
                                              services.name,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4),
                                            child: Row(
                                              children: [
                                                const Text('Giá: ',
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFFDAA520))),
                                                Text(
                                                  formatCurrency(
                                                      services.price),
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromARGB(
                                                        255, 228, 164, 1),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Positioned(
                                        right: 0,
                                        top: 70,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 245, 244, 244),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                (services.averageRating ?? 0)
                                                    .toStringAsFixed(1),
                                                style: const TextStyle(
                                                    fontSize: 11),
                                              ),
                                              Icon(Icons.star,
                                                  color: AppColors.star,
                                                  size: 20),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
            ],
          ),
        ),
      ),
      // Bottom bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(top: BorderSide(color: Colors.grey.shade300, width: 1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Đã chọn ${selectedServices.length} dịch vụ',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
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
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    Text(
                      formatCurrency(
                        selectedServices.fold(
                            0, (sum, item) => sum + item.price),
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.deepBlue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 5),
                ElevatedButton(
                  onPressed: selectedServices.isEmpty
                      ? null
                      : () {
                          Navigator.pop(context, selectedServices);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedServices.isEmpty
                        ? Colors.grey
                        : AppColors.deepBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
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
}
