import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/models/clinic.dart';
import 'package:health_care/models/service.dart';
import 'package:health_care/models/specialty.dart';
import 'package:health_care/viewmodels/api/clinic_api.dart';
import 'package:health_care/viewmodels/api/service_api.dart';
import 'package:health_care/viewmodels/api/specialty_api.dart';

class SearchHome extends StatefulWidget {
  const SearchHome({super.key});
  @override
  State<SearchHome> createState() => _SearchHome();
}

class _SearchHome extends State<SearchHome> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Specialty>? specialties;
  List<Service>? services;
  List<Clinic>? clinics;
  List<dynamic> filteredResults = [];

  @override
  void initState() {
    super.initState();
    fetchAll();
  }

  void fetchAll() async {
    List<Specialty>? dataSpecialty = await SpecialtyApi.getAllSpecialty();
    List<Service>? dataService = await ServiceApi.getAllServe();
    List<Clinic>? dataClinic = await ClinicApi.getAllClinic();
    if (mounted) {
      setState(() {
        specialties = dataSpecialty;
        services = dataService;
        clinics = dataClinic;
        filteredResults =
            filterResults(_searchQuery); // Cập nhật filteredResults
      });
    }
  }

// Lọc dữ liệu theo từ khóa tìm kiếm
  List<dynamic> filterResults(String query) {
    List<dynamic> results = [];

    // Lọc chuyên khoa theo tên
    if (specialties != null) {
      results.addAll(specialties!.where(
          (item) => item.name.toLowerCase().contains(query.toLowerCase())));
    }

    // Lọc dịch vụ theo tên
    if (services != null) {
      results.addAll(services!.where(
          (item) => item.name.toLowerCase().contains(query.toLowerCase())));
    }

    // Lọc phòng khám theo địa chỉ
    if (clinics != null) {
      results.addAll(clinics!.where(
          (item) => item.address.toLowerCase().contains(query.toLowerCase())));
    }

    return results;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: AppColors.deepBlue,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        title: SizedBox(
          width: double.infinity,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.white, width: 1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: AppColors.softBlue),
                const SizedBox(width: 5),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (query) {
                      setState(() {
                        _searchQuery = query;
                        filteredResults = filterResults(
                            _searchQuery); // Lọc và cập nhật kết quả
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Tìm kiếm phòng khám, chuyên khoa,dịch vụ',
                      hintStyle: TextStyle(
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear, color: Colors.black54),
                    onPressed: () {
                      _searchController.clear();
                      filterResults('');
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
      body: _searchQuery.isEmpty
          ? Center(child: Text("Nhập từ khóa để tìm kiếm"))
          : FutureBuilder(
              future: Future.delayed(
                  Duration(seconds: 1), () => filterResults(_searchQuery)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Lỗi: ${snapshot.error}"));
                } else {
                  List<dynamic> results = snapshot.data as List<dynamic>;
                  return results.isEmpty
                      ? Center(child: Text("Không tìm thấy kết quả"))
                      : ListView.builder(
                          itemCount: results.length,
                          itemBuilder: (context, index) {
                            var item = results[index];
                            return ListTile(
                              title: Text(item.name),
                              subtitle:
                                  Text(item.description ?? 'Không có mô tả'),
                            );
                          },
                        );
                }
              },
            ),
    );
  }
}
