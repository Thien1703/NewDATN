import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/views/screens/apoointment_online/appointment_online_screen.dart';
import 'package:health_care/views/screens/apoointment_online/doctor_online/doctor_api.dart';
import 'package:health_care/views/screens/apoointment_online/doctor_online/doctor_detail_screen.dart';
import 'package:health_care/views/screens/apoointment_online/doctor_online/doctor_model.dart';
import 'package:health_care/views/widgets/bottomSheet/widget_filterSpecialty.dart';
import 'package:health_care/views/widgets/widget_header_body.dart';
import 'package:shimmer/shimmer.dart';

class DoctorListScreen extends StatefulWidget {
  const DoctorListScreen({super.key});

  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  List<Doctor>? doctor;
  List<Doctor>? filteredDoctors;
  final TextEditingController _searchController = TextEditingController();
  List<int> _selectedSpecialtyIds = [];

  @override
  void initState() {
    super.initState();
    fetchEmployee();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final searchText = _searchController.text.toLowerCase();
    if (doctor != null) {
      setState(() {
        filteredDoctors = doctor!.where((doc) {
          return doc.fullName.toLowerCase().contains(searchText);
        }).toList();
      });
    }
  }

  void fetchEmployee() async {
    List<Doctor>? data = await DoctorApi.getAllOnlineDoctors();
    setState(() {
      doctor = data;
      filteredDoctors = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WidgetHeaderBody(
      iconBack: true,
      title: 'Tư vấn khám bệnh qua video',
      color: AppColors.ghostWhite,
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            _buildFilterRow(),
            _buildSearchField(),
            doctor == null
                ? _buildLoadingData()
                : filteredDoctors!.isNotEmpty
                    ? Expanded(
                        child: SingleChildScrollView(
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: filteredDoctors!.length,
                            itemBuilder: (context, index) {
                              final doc = filteredDoctors![index];
                              return _buildDoctorCard(doc);
                            },
                          ),
                        ),
                      )
                    : const Expanded(
                        child: Center(child: Text('Không tìm thấy bác sĩ.')),
                      ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterRow() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Lọc theo:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: () async {
                  final selectedIds = await showModalBottomSheet<List<int>>(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => WidgetFilterspecialty(
                      selectedIds:
                          _selectedSpecialtyIds, // Truyền các ID đã chọn vào đây
                    ),
                  );

                  if (selectedIds != null) {
                    setState(() {
                      _selectedSpecialtyIds = selectedIds;
                    });
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 227, 227, 227),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Row(
                    children: [
                      Text(
                        'Chuyên khoa',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Icon(Icons.keyboard_arrow_down, size: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: _selectedSpecialtyIds.map((id) => Text('$id')).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
              color: const Color.fromARGB(255, 193, 199, 206), width: 1.5),
        ),
        child: Row(
          children: [
            const SizedBox(width: 10),
            const Icon(Icons.search, color: AppColors.deepBlue),
            const SizedBox(width: 5),
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm tên bác sĩ...',
                  hintStyle: TextStyle(fontSize: 14),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorCard(Doctor doctor) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DoctorDetailScreen(doctor: doctor),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[400]!,
              blurRadius: 5,
              spreadRadius: 1,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipOval(
                  child: Image.network(
                    doctor.avatar,
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(doctor.qualification,
                          style: TextStyle(fontSize: 14)),
                      Text(
                        doctor.fullName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                          color: AppColors.deepBlue,
                        ),
                      ),
                      Text('${doctor.experienceYears} năm kinh nghiệm',
                          style: TextStyle(fontSize: 14)),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 5,
                        runSpacing: 8,
                        children: doctor.specialties.map((e) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color.fromARGB(255, 223, 223, 223),
                            ),
                            child: Text(
                              e.name,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.only(top: 5, bottom: 10),
              child: Row(
                children: [
                  const Icon(Icons.location_on_rounded, size: 20),
                  const SizedBox(width: 5),
                  Text(
                    doctor.clinic.name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AppointmentOnlineScreen(doctor: doctor),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  backgroundColor: AppColors.deepBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Đặt lịch ngay',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingData() {
    return Expanded(
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          height: 14,
                          width: double.infinity,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 14,
                          width: MediaQuery.of(context).size.width * 0.6,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
