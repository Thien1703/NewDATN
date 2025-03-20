import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/viewmodels/api/service_api.dart';
import 'package:health_care/views/widgets/widget_header_body.dart';
import 'package:health_care/models/service.dart';
import 'package:health_care/views/screens/clinic/clinic_screen.dart';

// class ServiceScreen extends StatefulWidget {
//   ServiceScreen({super.key, required this.specialtyId});
//   final int specialtyId;

//   @override
//   State<ServiceScreen> createState() => _ServiceScreen();
// }

// class _ServiceScreen extends State<ServiceScreen> {
//   List<Service> services = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchServicesById();
//   }

//   void fetchServicesById() async {
//     List<Service>? data = await ServiceApi.getAllServeById(widget.specialtyId);
//     if (mounted) {
//       setState(() {
//         services = data;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WidgetHeaderBody(
//       iconBack: true,
//       title: 'Dịch vụ',
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 10),
//           child: Column(
//             children: [
//               Container(
//                 margin: EdgeInsets.symmetric(vertical: 15),
//                 padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(
//                     color: AppColors.accent,
//                     width: 1,
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text('Tìm kiếm chuyên khoa/dịch vụ',
//                         style: TextStyle(color: Colors.black54)),
//                     Icon(Icons.search, color: AppColors.accent),
//                   ],
//                 ),
//               ),

//               // Hiển thị danh sách dịch vụ
//               services.isEmpty
//                   ? Center(child: Text('Chưa có dịch vụ này'))
//                   : GridView.builder(
//                       shrinkWrap: true, // Thêm shrinkWrap để tránh lỗi layout
//                       physics: NeverScrollableScrollPhysics(),
//                       padding: EdgeInsets.zero,
//                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2,
//                         crossAxisSpacing: 8,
//                         mainAxisSpacing: 8,
//                         childAspectRatio: 0.69,
//                       ),
//                       itemCount: services.length,
//                       itemBuilder: (context, index) {
//                         final service = services[index];
//                         return Card(
//                           elevation: 5,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Padding(
//                             padding: EdgeInsets.all(5),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 SizedBox(height: 5),
//                                 Text(
//                                   service.name,
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 14),
//                                   softWrap: true,
//                                 ),
//                                 Text(
//                                   service.description,
//                                   softWrap: true,
//                                   maxLines: 3,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: TextStyle(fontSize: 12),
//                                 ),
//                                 Text(
//                                   service.price.toString(),
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 14),
//                                   softWrap: true,

//                                 )
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),

//               SizedBox(height: 10),
//               if (services.isNotEmpty)
//                 OutlinedButton(
//                   onPressed: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => ClinicScreen(
//                                   iconBack: true,
//                                 )));
//                   },
//                   child: Text('Đặt lịch ngay'),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class ServiceScreen extends StatefulWidget {
  ServiceScreen({super.key, required this.specialtyId});
  final int specialtyId;

  @override
  State<ServiceScreen> createState() => _ServiceScreen();
}

class _ServiceScreen extends State<ServiceScreen> {
  List<Service> services = [];

  @override
  void initState() {
    super.initState();
    fetchServicesById();
  }

  void fetchServicesById() async {
    List<Service>? data = await ServiceApi.getAllServeById(widget.specialtyId);
    if (mounted) {
      setState(() {
        services = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WidgetHeaderBody(
      iconBack: true,
      title: 'Dịch vụ',
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          // decoration: BoxDecoration(
          //   gradient: LinearGradient(
          //     colors: [AppColors.accent, Colors.white],
          //     begin: Alignment.topCenter,
          //     end: Alignment.bottomCenter,
          //   ),
          // ),
          child: Padding(
  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
  child: Column(
    children: [
      Text(
        'Bảng giá dịch vụ',
        style: TextStyle(
            fontSize: 30,
            color: Color(0xFF3A62B8),
            fontWeight: FontWeight.bold),
      ),
      SizedBox(
        height: 10,
      ),
      // Hiển thị danh sách dịch vụ
      services.isEmpty
          ? Center(child: Text('Chưa có dịch vụ này'))
          : GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
                childAspectRatio: 1.1,
              ),
              itemCount: services.length,
              itemBuilder: (context, index) {
                final service = services[index];
                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: Color(0xFF3A62B8), // Màu xanh cho border
                      width: 2,
                    ),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Text(
                          service.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black87,
                          ),
                          softWrap: true,
                        ),
                        SizedBox(height: 5),
                        Text(
                          service.description,
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 12, color: Colors.black54),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.monetization_on,
                              size: 23,
                              color: Colors.yellow,
                            ),
                            SizedBox(width: 2),
                            Text(
                              service.formattedPrice,
                              style: TextStyle(
                                color: Color(0xFF3A62B8),
                                fontWeight: FontWeight.bold,
                                fontSize: 19,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      SizedBox(height: 20),
      if (services.isNotEmpty)
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ClinicScreen(
                  iconBack: true,
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: AppColors.accent, // Màu xanh cho border của ElevatedButton
                width: 1.3,
              ),
            ),
            minimumSize: Size(double.minPositive, 50),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_today,
                color: Colors.white, // Màu xanh cho icon
              ),
              SizedBox(width: 8),
              Text(
                'ĐẶT LỊCH NGAY',
                style: TextStyle(
                  color: Colors.white, // Màu xanh cho chữ
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
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
