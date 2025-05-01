import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/models/specialty.dart';
import 'package:health_care/viewmodels/api/specialty_api.dart';
import 'package:health_care/views/widgets/bottomSheet/header_bottomSheet1.dart';

class WidgetFilterspecialty extends StatefulWidget {
  final List<int> selectedIds; // Nhận danh sách ID đã chọn

  const WidgetFilterspecialty({super.key, required this.selectedIds});

  @override
  State<WidgetFilterspecialty> createState() => _WidgetFilterspecialtyState();
}

class _WidgetFilterspecialtyState extends State<WidgetFilterspecialty> {
  List<Specialty>? specialties;
  List<Specialty>? filteredSpecialties;
  List<bool> isSelectedList = []; // Danh sách trạng thái checkbox
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchSpecialties();
    searchController.addListener(() {
      filterSpecialties();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void fetchSpecialties() async {
    List<Specialty>? data = await SpecialtyApi.getAllSpecialty();
    if (mounted) {
      setState(() {
        specialties = data;
        filteredSpecialties = data;
        isSelectedList = List.generate(data?.length ?? 0, (index) {
          // Kiểm tra nếu specialty đã được chọn từ danh sách `selectedIds`
          return widget.selectedIds.contains(data![index].id);
        });
      });
    }
  }

  void filterSpecialties() {
    String query = searchController.text.toLowerCase();
    if (mounted) {
      setState(() {
        filteredSpecialties = specialties
            ?.where((specialty) => specialty.name.toLowerCase().contains(query))
            .toList();
        isSelectedList = List.generate(filteredSpecialties?.length ?? 0,
            (index) => false); // Reset trạng thái checkbox khi lọc
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return HeaderBottomSheet1(
      title: 'Lọc theo',
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            // ... (phần tìm kiếm và danh sách đã được giữ nguyên)
            SizedBox(
              height: 500,
              child: filteredSpecialties == null
                  ? const Center(child: CircularProgressIndicator())
                  : filteredSpecialties!.isEmpty
                      ? const Center(child: Text('Không có dịch vụ nào'))
                      : ListView.builder(
                          itemCount: filteredSpecialties!.length,
                          padding: const EdgeInsets.all(5),
                          itemBuilder: (context, index) {
                            final specialty = filteredSpecialties![index];
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  isSelectedList[index] =
                                      !isSelectedList[index];
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                margin: const EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isSelectedList[index]
                                        ? AppColors
                                            .deepBlue // Chọn màu khi được chọn
                                        : Colors
                                            .grey, // Màu mặc định khi không chọn
                                    width: isSelectedList[index] ? 1.5 : 0.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey[300]!,
                                      blurRadius: 3,
                                      spreadRadius: 1,
                                    )
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        specialty.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Checkbox(
                                      value: isSelectedList[index],
                                      onChanged: (value) {
                                        setState(() {
                                          isSelectedList[index] = value!;
                                        });
                                      },
                                      activeColor: AppColors.deepBlue,
                                      checkColor: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
            InkWell(
              onTap: () {
                // Lọc các specialty đã được chọn
                List<int> selectedSpecialtyIds = [];
                for (int i = 0; i < isSelectedList.length; i++) {
                  if (isSelectedList[i]) {
                    selectedSpecialtyIds.add(specialties![i].id);
                  }
                }
                Navigator.pop(context, selectedSpecialtyIds);

                // In ra danh sách id của các specialty đã được chọn
                print('Selected specialty IDs: $selectedSpecialtyIds');
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.symmetric(vertical: 15),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.deepBlue,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    'Hiện thị kết quả',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
