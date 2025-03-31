import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/models/clinic.dart';
import 'package:health_care/config/app_config.dart';
import 'package:health_care/viewmodels/api/clinic_api.dart';
import 'package:health_care/views/screens/clinic/clinic_detail_screen.dart';
import 'package:health_care/views/widgets/widget_header_body.dart';
import 'package:health_care/views/screens/appointment/appointment_screen.dart';

class ClinicScreen extends StatefulWidget {
  const ClinicScreen({
    super.key,
    this.iconBack,
  });
  final bool? iconBack;

  @override
  State<ClinicScreen> createState() => _ClinicScreenState();
}

class _ClinicScreenState extends State<ClinicScreen> {
  List<Clinic>? clinics;
  List<Clinic>? filteredClinics;
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    fetchClinics();
  }

  void fetchClinics() async {
    List<Clinic>? data = await ClinicApi.getAllClinic();
    setState(() {
      clinics = data;
      filteredClinics = data;
    });
  }

  void filterClinics(String query) {
    if (clinics == null) return;
    setState(() {
      filteredClinics = clinics!
          .where((clinic) =>
              clinic.address.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WidgetHeaderBody(
      iconBack: widget.iconBack ?? true,
      title: "Đặt khám",
      body: SingleChildScrollView(
        child: Container(
          color: const Color(0xFFECECEC),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: AppColors.softBlue, width: 1.5),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: AppColors.softBlue),
                            const SizedBox(width: 5),
                            Expanded(
                              child: TextField(
                                controller: searchController,
                                onChanged: filterClinics,
                                decoration: const InputDecoration(
                                  hintText: 'Tìm kiếm phòng khám, theo địa chỉ',
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                ),
                              ),
                            ),
                            if (searchController.text.isNotEmpty)
                              IconButton(
                                icon: const Icon(Icons.clear,
                                    color: Colors.black54),
                                onPressed: () {
                                  searchController.clear();
                                  filterClinics('');
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(Icons.location_on_outlined,
                          color: AppColors.deepBlue, size: 20),
                    ),
                  ],
                ),
                clinics == null
                    ? Container(
                        width: double.infinity,
                        height: 700,
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(strokeWidth: 3),
                        ),
                      )
                    : clinics != null
                        ? ListView.builder(
                            padding: EdgeInsets.only(top: 10),
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: filteredClinics!.length,
                            itemBuilder: (context, index) {
                              final clinic = filteredClinics![index];
                              return Card(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                color: Colors.white,
                                shadowColor: Colors.black.withOpacity(0.3),
                                child: Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ClinicDetailScreen(
                                                        clinicId: clinic.id),
                                              ),
                                            );
                                          },
                                          child: Icon(
                                            Icons.info_outlined,
                                            color: AppColors.deepBlue,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Image.network(
                                              clinic.image,
                                              width: 100,
                                              height: 80,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  clinic.name,
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Icon(Icons.location_on_sharp,
                                              size: 23,
                                              color: const Color.fromARGB(
                                                  255, 73, 73, 73)),
                                          Expanded(
                                            child: Text(
                                              clinic.address,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: const Color.fromARGB(
                                                      255, 73, 73, 73),
                                                  fontWeight: FontWeight.w500),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.deepBlue,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 40, vertical: 10),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AppointmentScreen(
                                                  clinicId: clinic.id,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Text('Đặt lịch ngay',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.white)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                'Không có phòng khám nào',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[600]),
                              ),
                            ),
                          )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
