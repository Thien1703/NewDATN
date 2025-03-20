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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.accent,
              Colors.white,
              // AppColors.accent,
              // Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search container
              // Container(
              //   margin: const EdgeInsets.symmetric(vertical: 15),
              //   padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(12),
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
             
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 60, 112, 164),
                        width: 1),
                    borderRadius: BorderRadius.circular(10),
                    color:   const Color.fromARGB(255, 37, 135, 162),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center, 
                    crossAxisAlignment: CrossAxisAlignment.center, 
                    children: [
                      Icon(Icons.location_on_outlined, color: Colors.white),
                      SizedBox(width: 5), 
                      Text(
                        'Tìm gần đây',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              
              clinics != null
                  ? ListView.builder(
                      padding: EdgeInsets.only(top: 10),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: clinics!.length,
                      itemBuilder: (context, index) {
                        final clinic = clinics![index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AppointmentScreen(
                                  clinicId: clinic.id,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            margin: EdgeInsets.symmetric(vertical: 6),
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: Colors.blue,
                                width: 1.5,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Image
                                  Image.network(
                                    clinic.image,
                                    width: double.infinity,
                                    height: 180,
                                    fit: BoxFit.cover,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.local_hospital,
                                              size: 20,
                                              color: Colors.blue,
                                            ),
                                            SizedBox(width: 3),
                                            Text(
                                              clinic.name,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5),
                                        
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              size: 18,
                                              color: const Color.fromARGB(255, 255, 58, 58),
                                            ),
                                            Text(
                                              clinic.address,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: const Color.fromARGB(255, 47, 46, 46),
                                              ),
                                              softWrap: true,
                                            ),
                                          ],
                                        ),
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
                      child: Text('Không có phòng khám nào'),
                    ),
            ],
          ),
        ),
      ),
    ),
  );
}
}