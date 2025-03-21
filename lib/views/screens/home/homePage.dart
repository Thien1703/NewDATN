import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/config/app_config.dart';
import 'package:health_care/models/specialty.dart';
import 'package:health_care/views/screens/BMI/measureBMI_Screen.dart';
import 'package:health_care/views/screens/home/service_screen.dart';
import 'package:health_care/viewmodels/api/specialty_api.dart';
import 'package:health_care/views/screens/map/searchMap.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//   @override
//   State<HomePage> createState() => _HomePage();
// }

// class _HomePage extends State<HomePage> {
//   List<Specialty>? specialties;

//   @override
//   void initState() {
//     super.initState();
//     fetchSpecialties();
//   }

//   void fetchSpecialties() async {
//     List<Specialty>? data = await SpecialtyApi.getAllSpecialty();
//     setState(() {
//       specialties = data;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Container(
//           width: double.infinity,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 AppColors.accent,
//                 Colors.white,
//                 AppColors.accent,
//                 Colors.white,
//               ],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//           ),
//           child: Container(
//             margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 35),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     CircleAvatar(
//                       radius: 25,
//                       child: Image.asset(
//                         'assets/images/healthcaregreen.png',
//                         width: 70,
//                       ),
//                     ),
//                     SizedBox(width: 10),
//                     Expanded(
//                       child: Text(
//                         'Chào mừng đến với phòng khám FPT',
//                         softWrap: true,
//                         style: TextStyle(
//                           fontSize: 17,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 70),
//                   ],
//                 ),
//                 Container(
//                   margin: const EdgeInsets.symmetric(vertical: 15),
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: const [
//                       Text('Tìm kiếm chuyên khoa/dịch vụ',
//                           style: TextStyle(color: Colors.black54)),
//                       Icon(Icons.search, color: AppColors.accent),
//                     ],
//                   ),
//                 ),

//                 Container(
//                   margin: const EdgeInsets.symmetric(vertical: 10),
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
//                   decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12)),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       _buildFeatureButton(
//                         'Xem bản đồ',
//                         Icons.map,
//                         () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => SearchScreen()));
//                         },
//                       ),
//                       _buildFeatureButton('Chat AI', Icons.chat, () {
//                         print('object');
//                       }),
//                       _buildFeatureButton('Đo BMI', Icons.fitness_center, () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => BmiScreen()));
//                       }),
//                     ],
//                   ),
//                 ),

//                 // Tiêu đề Chuyên khoa
//                 Text(
//                   'Chuyên khoa',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.w600,
//                     color: AppColors.accent,
//                   ),
//                 ),

//                 // Danh sách chuyên khoa
//                 specialties != null
//                     ? ListView.builder(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         itemCount: specialties!.length,
//                         itemBuilder: (context, index) {
//                           final specialty = specialties![index];
//                           return InkWell(
//                             onTap: () {
//                               print(specialty.id);
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => ServiceScreen(
//                                     specialtyId: specialty.id,
//                                   ),
//                                 ),
//                               );
//                             },
//                             child: Card(
//                               elevation: 3,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: ListTile(
//                                 contentPadding: const EdgeInsets.all(10),
//                                 leading: ClipRRect(
//                                   borderRadius: BorderRadius.circular(10),
//                                   child: Image.network(
//                                       specialty.image ??
//                                           'https://example.com/default-image.png',
//                                       width: 50,
//                                       height: 50,
//                                       fit: BoxFit.cover),
//                                 ),
//                                 title: Text(
//                                   specialty.name,
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.w600,
//                                     color: Colors.blue.shade800,
//                                   ),
//                                 ),
//                                 subtitle: Text(
//                                   specialty.description,
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     color: Colors.black54,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       )
//                     : const Center(
//                         child: CircularProgressIndicator(),
//                       ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // Widget cho các nút chức năng chính
//   Widget _buildFeatureButton(String text, IconData icon, VoidCallback onTap) {
//     return InkWell(
//       onTap: onTap,
//       child: Column(
//         children: [
//           CircleAvatar(
//             radius: 25,
//             backgroundColor: const Color.fromARGB(255, 178, 232, 181),
//             child: Icon(icon, color: AppColors.accent),
//           ),
//           const SizedBox(height: 5),
//           Text(
//             text,
//             style: TextStyle(fontSize: 12, color: AppColors.accent),
//           ),
//         ],
//       ),
//     );
//   }
// }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  List<Specialty>? specialties;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    fetchSpecialties();
    _fetchUserProfile();
  }

  void fetchSpecialties() async {
    List<Specialty>? data = await SpecialtyApi.getAllSpecialty();
    setState(() {
      specialties = data;
    });
  }

  Future<void> _fetchUserProfile() async {
    try {
      final data = await AppConfig.getUserProfile();
      print(data);
      setState(() {
        _userData = data;
      });
    } catch (e) {
      print("Error fetching user profile: $e");
      setState(() {
        _userData = {};
      });
    }
  }

  List<String> imgList = [
    'assets/images/slide1.jpg',
    'assets/images/slide2.jpg',
    'assets/images/slide3.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF1565C0),
                Colors.white,
                Color(0xFF64B5F6),
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
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      child: Image.asset(
                        'assets/images/logoApp.png',
                        width: 120,
                        height: 120,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Xin chào!',
                            softWrap: true,
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            _userData?['fullName'] ?? 'Người dùng',
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          // Text(
                          //   'đến với phòng khám FPT',
                          //   softWrap: true,
                          //   style: TextStyle(
                          //     fontSize: 17,
                          //     fontWeight: FontWeight.bold,
                          //     color: Colors.black,
                          //   ),
                          // ),
                        ],
                      ),
                    )
                  ],
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Tìm kiếm chuyên khoa/dịch vụ',
                          style: TextStyle(color: Colors.black54)),
                      Icon(Icons.search, color: Colors.blue),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildFeatureButton('Xem bản đồ', Icons.map, () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchScreen()));
                      }),
                      _buildFeatureButton('Chat AI', Icons.chat, () {
                        print('Chat AI clicked');
                      }),
                      _buildFeatureButton('Đo BMI', Icons.fitness_center, () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BmiScreen()));
                      }),
                    ],
                  ),
                ),
                CarouselSlider(
                  options: CarouselOptions(
                    height: 200.0,
                    autoPlay: true,
                    aspectRatio: 14 / 9,
                    viewportFraction: 1.0,
                  ),
                  items: imgList.map((item) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(item, fit: BoxFit.fill),
                      ),
                    );
                  }).toList(),
                ),
                Text(
                  'Chuyên khoa',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(255, 75, 75, 75),
                  ),
                ),
                specialties != null
                    ? Container(
                        height: 300,
                        child: GridView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 7,
                            mainAxisSpacing: 7,
                          ),
                          itemCount: specialties!.length,
                          itemBuilder: (context, index) {
                            final specialty = specialties![index];
                            return InkWell(
                              onTap: () {
                                print(specialty.id);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ServiceScreen(
                                        specialtyId: specialty.id),
                                  ),
                                );
                              },
                              child: Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      color: Colors.white,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          specialty.image ??
                                              'https://example.com/default-image.png',
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      specialty.name,
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blue.shade800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget cho các nút chức năng chính
  Widget _buildFeatureButton(String text, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: AppColors.accent,
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 5),
          Text(
            text,
            style: TextStyle(
                fontSize: 12, color: AppColors.accent),
          ),
        ],
      ),
    );
  }
}
