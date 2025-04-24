import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/models/employee.dart';
import 'package:health_care/views/screens/apoointment_online/appointment_online_screen.dart';
import 'package:health_care/views/screens/apoointment_online/doctor_online/doctor_api.dart';
import 'package:health_care/views/screens/apoointment_online/doctor_online/doctor_detail_screen.dart';
import 'package:health_care/views/screens/apoointment_online/doctor_online/doctor_model.dart';
import 'package:health_care/views/widgets/bottomSheet/widget_filterSpecialty.dart';
import 'package:health_care/views/widgets/widget_header_body.dart';

class DoctorListScreen extends StatefulWidget {
  const DoctorListScreen({super.key});

  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  List<Employee>? employee;

  @override
  void initState() {
    super.initState();
    fetchEmployee();
  }

  void fetchEmployee() async {
    List<Employee>? data = await DoctorApi.getAllOnlineDoctors();
    setState(() {
      employee = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WidgetHeaderBody(
      iconBack: true,
      title: 'Tư vấn khám bệnh qua video',
      color: AppColors.ghostWhite,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 17, vertical: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Lọc theo:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true, // ← Thêm dòng này
                      builder: (context) {
                        return WidgetFilterspecialty();
                      },
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 227, 227, 227),
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      children: [
                        Text(
                          'Chuyên khoa',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            employee == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : employee != null
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: employee!.length,
                        itemBuilder: (context, index) {
                          final employees = employee![index];
                          return InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DoctorDetailScreen(employee: employees),
                                )),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 5),
                              margin: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  // border: Border.all(color: Colors.black, width: 1),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey[400]!,
                                      blurRadius: 5,
                                      spreadRadius: 1,
                                    )
                                  ]),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.network(
                                    employees.avatar,
                                    width: 90,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Bác sĩ ${employees.fullName}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: AppColors.deepBlue,
                                          ),
                                          softWrap: true,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          'Chuyên khoa: ${employees.specialty.map((e) => e.name).join(', ')}',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              EdgeInsets.only(right: 5, top: 5),
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: OutlinedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          AppointmentOnlineScreen(
                                                              doctor:
                                                                  employees),
                                                    ));
                                              },
                                              style: OutlinedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide.none,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12), // bo góc
                                                  ),
                                                  foregroundColor: Colors
                                                      .white, // màu chữ và icon
                                                  backgroundColor:
                                                      AppColors.deepBlue),
                                              child: Text(
                                                'Đặt lịch hẹn',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text('Không có bác sĩ '),
                      )
          ],
        ),
      ),
    );
  }

  Widget _buildRow({required String label, required String value}) {
    return Container(
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            softWrap: true,
          ),
        ],
      ),
    );
  }
}
