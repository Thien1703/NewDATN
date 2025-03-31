import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/views/screens/tools/BMI/measureBMI_Screen.dart';
import 'package:health_care/views/screens/tools/BMR/measureBMR_Screen.dart';

class BmrScreen extends StatefulWidget {
  const BmrScreen({super.key});

  @override
  _BmrScreenState createState() => _BmrScreenState();
}

class _BmrScreenState extends State<BmrScreen> {
  bool isExpanded = false;
  bool isExpanded1 = false;
  bool isExpanded2 = false;
  bool isExpanded3 = false;
  bool isExpanded4 = false;
  bool isExpanded5 = false;
  bool isExpanded6 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 90),
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Image.asset('assets/images/imageBMR.jpg'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            const Text(
                              'Tính chỉ số BMR',
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Công cụ ngày không cung cấp lời khuyên y tế mà chỉ có mục đích cung cấp thông tin. Công cụ không thay thế cho chuẩn đoán hoặc dịch vụ điều trị y tế chuyên nghiệp. Không nên bỏ qua tư vấn y tế trong việc tìm kiếm điều trị; mọi thông tin trên trang công cụ của phòng khám chỉ mang tính chất tham khảo. Nếu bạn mắc chứng rối loạn ăn uống, kết quả tính BMR sẽ không áp dụng. Vui lòng liên hệ bác sĩ để được tư vấn thêm.',
                              style: TextStyle(
                                fontSize: 13.8,
                                color: Colors.black.withOpacity(0.7),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child:
                                  Divider(color: Colors.grey.withOpacity(0.5)),
                            ),
                            Row(
                              children: const [
                                Icon(Icons.info_outline, size: 16),
                                SizedBox(width: 7),
                                Text(
                                  'Thông tin',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            _buildExpandableSection(
                              title:
                                  'Tỷ lệ trao đổi chất cơ bản(BMR) là gì? - Định nghĩa BMR',
                              content:
                                  'Cơ thể chúng ra đốt cháy calo liên tục trong ngày để duy trì các chức năng sống cơ bản như hô hấp, tuần hoàn và tiêu hóa. BMR(Basal Metabolic Rate - tỉ lệ trao đổi chất cơ bản) là lượng calo tối thiểu cần thiết cho các chức năng này khi cơ thể nghỉ ngơi\nChỉ số này cũng xác định tốc độ cơ thể có thể đốt cháy calo, do đó sẽ thể hiện được mối liên hệ giữa lượng calo với khố lượng cơ thể.',
                              isExpanded: isExpanded,
                              onToggle: () =>
                                  setState(() => isExpanded = !isExpanded),
                            ),
                            Divider(color: Colors.grey.withOpacity(0.5)),
                            _buildExpandableSection(
                              title:
                                  'Calo là gì và vì sao cơ thể chúng ra cần calo?',
                              content:
                                  'Calo là một đơn vị đo năng lượng. Trong dinh dưỡng, calo là năng lượng mà chúng ta nhận được từ việc tiêu thụ thực phẩm và cũng là năng lượng sử dụng trong các hoạt động thể chất.\nBạn có thể dễ dàng biết số calo được liệt kê trên nhãn thông tin của các loại thực phẩm. Nhiều cách giảm cân cũng xoay quanh mục tiêu là giảm lượng calo nạp vào cơ thể. Một kilocalorie(kcal) tương đương với 1.000 calo.\nTheo dõi lượng calo nạp vào giúp bạn biết rõ hơn lượng calo cơ thể cần để đốt cháy, tiêu thụ thêm hoặc duy trì nhằm sỡ hữu số cân nặng mong muốn. Dù mục tiêu của bạn là gì, bạn cũng cần nắm được mình đang nạp vào bao nhiêu calo.',
                              isExpanded: isExpanded1,
                              onToggle: () =>
                                  setState(() => isExpanded1 = !isExpanded1),
                            ),
                            Divider(color: Colors.grey.withOpacity(0.5)),
                            _buildExpandableSection(
                              title: 'Cách tính BMR',
                              content:
                                  'Một cách phổ biến để tính tỷ lệ trao đổi chất cơ bản BMR là công thức Harris-Benedict:\n\nNữ giới:BMR=655 + (9,6 x trọng lượng tính bằng kg)+(1,8 x chiều cao bằng cm)-(4,7 x tuổi tính theo năm)\tNam giới:BMR=66 + (13,7 x trọng lượng tính bằng kg)+(5 x chiều cao bằng cm)-(6,8 x tuổi tính theo năm)\n\n Bạn cũng thế sử dụng công cụ tính BMR của phòng khám để dễ dàng và nhanh chóng có kết quả.',
                              isExpanded: isExpanded2,
                              onToggle: () =>
                                  setState(() => isExpanded2 = !isExpanded2),
                            ),
                            Divider(color: Colors.grey.withOpacity(0.5)),
                            _buildExpandableSection(
                              title:
                                  'BMR và khối lượng cơ nạc có liên quan như thế nào ?',
                              content:
                                  'Các nghiên cứu chỉ ra rằng bạn càng có nhiều lượng cơ nạc thì tỷ lệ BMR của bạn sẽ các càng lớn. Khối lượng cơ nạc tạo nên một phần cấu tạo cơ thể-tỷ lệ phần trăm mỡ trong cơ thể so với mô nạc hoặc khối lượng không chứ chất béo(mỡ)\nĐể tăng cường trao đổi chất, bạn cần cải thiện các thành phần cơ thể này bằng cách tăng khối lượng cơ nạc nhờ tập luyện thể thao và tiêu thụ nhiều protein hơn.',
                              isExpanded: isExpanded3,
                              onToggle: () => setState(
                                () {
                                  isExpanded3 = !isExpanded3;
                                },
                              ),
                            ),
                            Divider(color: Colors.grey.withOpacity(0.5)),
                            _buildExpandableSection(
                              title: 'Sự khác biệt giữa BMR và TDEE là gì?',
                              content:
                                  'Nếu BMT ước tính lượng calo tối thiểu của bạn cho các chức năng cơ bản của cơ thể, thì Tổng năng lượng tiêu thụ hàng ngày(TDEE) đo lường lượng calo bạn đốt cháy mỗi ngày, bao gồm cả hoạt động thể chất.',
                              isExpanded: isExpanded4,
                              onToggle: () => setState(
                                () {
                                  isExpanded4 = !isExpanded4;
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )),
            Positioned(
              top: 40,
              right: 16,
              child: SizedBox(
                width: 30, // Giảm kích thước
                height: 30,
                child: FloatingActionButton(
                  onPressed: () => Navigator.pop(context),
                  backgroundColor: Colors.white,
                  shape: CircleBorder(),
                  child: Icon(Icons.close, color: AppColors.deepBlue, size: 12),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 1,
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MeasurebmrScreen()),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: AppColors.deepBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    "Tính ngay",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableSection(
      {required String title,
      required String content,
      required bool isExpanded,
      required VoidCallback onToggle}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Text(
              title,
              softWrap: true,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            )),
            IconButton(
              onPressed: onToggle,
              icon: AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                transitionBuilder: (child, animation) => RotationTransition(
                  turns: Tween(begin: 0.75, end: 1.0).animate(animation),
                  child: child,
                ),
                child: Icon(
                  isExpanded ? Icons.remove : Icons.add,
                  key: ValueKey<bool>(isExpanded),
                  size: 20,
                ),
              ),
            ),
          ],
        ),
        AnimatedSize(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: isExpanded
              ? Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 10),
                  child: Text(
                    content,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.7),
                      fontWeight: FontWeight.w400,
                      fontSize: 13.8,
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ),
      ],
    );
  }
}
