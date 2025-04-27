import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/models/specialty.dart';
import 'package:health_care/viewmodels/api/specialty_api.dart';
import 'package:health_care/views/widgets/bottomSheet/header_bottomSheet.dart';
import 'package:health_care/views/widgets/bottomSheet/header_bottomSheet1.dart';

class WidgetFilterspecialty extends StatefulWidget {
  const WidgetFilterspecialty({super.key});

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
        filteredSpecialties =
            data; // Set the initial list to be the same as specialties
        isSelectedList = List.generate(data?.length ?? 0,
            (index) => false); // Khởi tạo trạng thái checkbox cho mỗi specialty
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Container(
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 226, 229, 231),
                  border: Border.all(
                      color: const Color.fromARGB(255, 193, 199, 206),
                      width: 1.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: AppColors.deepBlue,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Tìm kiếm chuyên khoa...',
                          hintStyle: TextStyle(
                            fontSize: 15,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
                                        width:
                                            isSelectedList[index] ? 1.5 : 0.5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey[300]!,
                                        blurRadius: 3,
                                        spreadRadius: 1,
                                      )
                                    ]),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        specialty.name,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500),
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
                    selectedSpecialtyIds.add(
                        specialties![i].id); // Lấy id của specialty đã chọn
                  }
                }

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
