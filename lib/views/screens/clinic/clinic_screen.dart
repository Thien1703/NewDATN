import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/models/clinic.dart';
import 'package:health_care/config/app_config.dart';
import 'package:health_care/views/widgets/widget_header_body_scoller.dart';
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

  @override
  void initState() {
    super.initState();
    fetchClinics();
  }

  void fetchClinics() async {
    List<Clinic>? data = await AppConfig.getAllClinic();
    setState(() {
      clinics = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WidgetHeaderBodyScoller(
      iconBack: false,
      title: 'Đặt khám',
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          // decoration: BoxDecoration(
          //   gradient: LinearGradient(
          //     colors: [
          //       const Color.fromARGB(255, 194, 219, 238),
          //   Colors.white,
          //     ],
          //     begin: Alignment.topCenter,
          //     end: Alignment.bottomCenter,
          //   ),
          // ),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search container
                // Container(
                //   margin: const EdgeInsets.symmetric(vertical: 15),
                //   padding:
                //       const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.circular(12),
                //     boxShadow: [
                //       BoxShadow(
                //         color: Colors.grey.withOpacity(0.2),
                //         spreadRadius: 1,
                //         blurRadius: 5,
                //       ),
                //     ],
                //   ),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     children: const [
                //       Text('Tìm kiếm chuyên khoa/dịch vụ',
                //           style: TextStyle(color: Colors.black54)),
                //       SizedBox(width: 10),
                //       Icon(Icons.search, color: Colors.blue),
                //     ],
                //   ),
                // ),

                // Location container
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromARGB(255, 60, 112, 164),
                          width: 1),
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.accent,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.location_on_outlined, color: Colors.white  ,size: 22,),
                        SizedBox(width: 3),
                        Text(
                          'Tìm gần đây',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),

                // List of clinics
                clinics != null
                    ? ListView.builder(
                        padding: EdgeInsets.only(top: 7),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: clinics!.length,
                        itemBuilder: (context, index) {
                          final clinic = clinics![index];
                          return InkWell(
                            child: Card(
                              margin: EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: BorderSide(
                                  color: AppColors.accent,
                                  width: 1.5,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Column(
                                  children: [
                                    // Clinic image
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15),
                                      ),
                                      child: Image.network(
                                        clinic.image,
                                        width: double
                                            .infinity, // Đảm bảo hình ảnh chiếm hết chiều rộng
                                        height:
                                            120, // Chiều cao cố định cho hình ảnh
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    // Clinic details
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                            Icon(
                                            Icons.local_hospital,
                                            size: 26,
                                            color: Colors.blue,
                                          ),
                                          SizedBox(width: 3),
                                          Text(
                                            clinic.name,
                                            style: TextStyle(
                                              fontSize: 19,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                            ],
                                          ),
                                          
                                          SizedBox(height: 8),
                                          Row(children: [
                                            Icon(
                                            Icons.location_on,
                                            size: 23,
                                            color: const Color.fromARGB(
                                                255, 255, 58, 58),
                                          ),
                                          
                                          Text(
                                            clinic.address,
                                            style: TextStyle(
                                              fontSize: 13.7,
                                              color: Color.fromARGB(
                                                  255, 47, 46, 46),
                                            ),
                                            softWrap: true,
                                            overflow: TextOverflow.visible,
                                          ),

                                          ],),
                                          
                                          SizedBox(height: 8),
                                          // Đặt Khám button
                                          Center(
                                            child:  SizedBox(
                                            width: 250, // Chiếm hết chiều rộng
                                            height: 48,
                                            child: ElevatedButton(
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
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  side: BorderSide(
                                                    color: Color(0xFF062A49),
                                                    width: 1.3,
                                                  ),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.calendar_today,
                                                    color: Color(0xFF3A62B8),
                                                    size: 20,
                                                  ),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    'ĐẶT KHÁM',
                                                    style: TextStyle(
                                                      color: Color(0xFF3A62B8),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 17,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          )
                                          
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          'Không có phòng khám nào',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
