import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/common/app_icons.dart';
import 'package:health_care/models/specialty.dart';
import 'package:health_care/viewmodels/api/specialty_api.dart';
import 'package:health_care/views/widgets/bottomSheet/header_bottomSheet1.dart';
import 'package:health_care/views/widgets/widget_select_item.dart';
import 'package:shimmer/shimmer.dart';

class SelectedSpecialty extends StatefulWidget {
  const SelectedSpecialty({super.key, required this.onSelected});
  final void Function(int specialtyId)? onSelected;

  @override
  State<SelectedSpecialty> createState() => _SelectedSpecialtyState();
}

class _SelectedSpecialtyState extends State<SelectedSpecialty> {
  List<Specialty>? specialty;
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return SelectItemWidget(
      image: AppIcons.stethoscope,
      text: selectedIndex == null
          ? 'Chọn chuyên khoa'
          : specialty![selectedIndex!].name,
      color:
          selectedIndex != null ? AppColors.deepBlue : const Color(0xFF484848),
      colorIcon:
          selectedIndex != null ? AppColors.deepBlue : const Color(0xFF484848),
      bottomSheet: HeaderBottomSheet1(
        title: 'Chọn chuyên khoa',
        body: Expanded(
          child: FutureBuilder<List<Specialty>?>(
            future: SpecialtyApi.getAllSpecialty(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return buildLoading();
              } else if (snapshot.hasError) {
                return Center(child: Text('Có lỗi xảy ra'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Không có chuyên khoa nào'));
              } else {
                specialty = snapshot.data;
                return SingleChildScrollView(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: specialty!.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final specialties = specialty![index];
                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                          widget.onSelected?.call(specialties.id);
                          Navigator.pop(context, specialties.id);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: selectedIndex == index
                                  ? AppColors.deepBlue
                                  : const Color.fromARGB(255, 172, 172, 172),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            color: selectedIndex == index
                                ? AppColors.deepBlue.withOpacity(0.1)
                                : Colors.transparent,
                          ),
                          child: Text(
                            specialties.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: selectedIndex == index
                                  ? AppColors.deepBlue
                                  : Colors.black,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildLoading() {
    return Column(
      children: List.generate(
        6,
        (index) => Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
