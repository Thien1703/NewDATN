import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/common/app_icons.dart';
import 'package:health_care/models/specialty.dart';
import 'package:health_care/models/customer.dart';
import 'package:health_care/viewmodels/api/customer_api.dart';
import 'package:health_care/viewmodels/api/specialty_api.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  List<Specialty>? specialties;
  Customer? customers;
  final List<String> imgList = [
    'assets/images/anhbia1.jpg',
    'assets/images/anhbia2.jpg',
    'assets/images/anhbia4.jpg',
    'assets/images/anhbia3.jpg',
    'assets/images/anhbia5.jpg',
    'assets/images/anhbia6.jpg',
  ];

  @override
  void initState() {
    super.initState();
    fetchSpecialties();
  }

  void fetchSpecialties() async {
    List<Specialty>? data = await SpecialtyApi.getAllSpecialty();
    Customer? result = await CustomerApi.getCustomerProfile();
    setState(() {
      specialties = data;
      customers = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.deepBlue,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: AppColors.deepBlue,
              expandedHeight: 130,
              floating: false,
              pinned: true,
              leading: IconButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: Icon(
                  Icons.menu,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.notifications,
                    size: 30,
                    color: Colors.white,
                  ),
                )
              ],
              flexibleSpace: LayoutBuilder(
                builder: (context, constraints) {
                  bool isCollapsed = constraints.maxHeight < 100;
                  return FlexibleSpaceBar(
                    titlePadding: EdgeInsets.only(
                        left: isCollapsed ? 50 : 0,
                        bottom: isCollapsed ? 10 : 20,
                        right: isCollapsed ? 40 : 0),
                    title: Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.white, width: 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tìm phòng khám, chuyên khoa...',
                            style: TextStyle(
                              fontSize: isCollapsed ? 14 : 10,
                              color: const Color.fromARGB(255, 141, 141, 141),
                            ),
                          ),
                          Icon(
                            Icons.mic,
                            color: AppColors.deepBlue,
                            size: isCollapsed ? 25 : 15,
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.only(bottom: 40),
                decoration: BoxDecoration(
                  color: Color(0xFFF0F2F5),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 25, bottom: 10, top: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Xin chào, ',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.normal),
                          ),
                          Text(
                            customers?.fullName ?? 'Chưa cập nhật',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFeatureButton(
                              'Tìm phòng khám', AppIcons.mapPlus, () {}),
                          _buildFeatureButton(
                              'Chat với AI', AppIcons.robotAI, () {}),
                          _buildFeatureButton(
                              'Đo BMI', AppIcons.bmiIcon, () {}),
                          _buildFeatureButton(
                              'Kiểm tra sức khỏe', AppIcons.healthCheck, () {}),
                          _buildFeatureButton(
                              'Tìm phòng khám', AppIcons.mapPlus, () {}),
                          SizedBox(width: 10),
                        ],
                      ),
                    ),
                    CarouselSlider(
                      items: imgList
                          .map(
                            (item) => ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset(
                                item,
                                width: double.infinity,
                              ),
                            ),
                          )
                          .toList(),
                      options: CarouselOptions(
                        height: 200,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 10),
                        enlargeCenterPage: true,
                        viewportFraction: 0.8,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Danh mục chuyên khoa',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          specialties == null
                              ? Center(child: Text('Không có dịch vụ nào'))
                              : SingleChildScrollView(
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 15,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: 2.9,
                                    ),
                                    itemCount: specialties!.length,
                                    itemBuilder: (context, index) {
                                      final specialty = specialties![index];
                                      return Container(
                                        padding: EdgeInsets.only(left: 10),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors.white, width: 1),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 1,
                                                  blurRadius: 1,
                                              ),
                                            ]),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Image.network(
                                              specialty.image,
                                              width: 45,
                                              color: AppColors.deepBlue,
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              specialty.name,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                )
                        ],
                      ),
                    ),
                    Image.asset('assets/images/anhBia.jpg'),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}

// Widget cho các nút chức năng chính
Widget _buildFeatureButton(String text, String icon, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    child: Container(
      margin: EdgeInsets.only(left: 20),
      width: 70,
      height: 90,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 0,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            icon,
            width: 35,
          ),
          const SizedBox(height: 5),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black,
            ),
          ),
        ],
      ),
    ),
  );
}
