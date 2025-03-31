import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/views/screens/tools/BMI/measureBMI_Screen.dart';

class BmiScreen extends StatefulWidget {
  const BmiScreen({super.key});

  @override
  _BmiScreenState createState() => _BmiScreenState();
}

class _BmiScreenState extends State<BmiScreen> {
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
                      Image.asset('assets/images/imageBMI.jpg'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            const Text(
                              'Tính chỉ số BMI',
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
                                  'Chỉ số BMI là gì? - Định nghĩa chỉ số khối cơ thể BMI',
                              content:
                                  'Chỉ số khối cơ thể(BMI) là phép đo trọng lượng của một người tương ứng với chiều cao của người đó. Chỉ số BMI có thể cho thấy bạn đang có mức cân nặng bình thường so với chiều cao hay béo phì, thừa cân, thiếu cân hay suy dinh dưỡng',
                              isExpanded: isExpanded,
                              onToggle: () =>
                                  setState(() => isExpanded = !isExpanded),
                            ),
                            Divider(color: Colors.grey.withOpacity(0.5)),
                            _buildExpandableSection(
                              title: 'Công thức tính BMI là gì?',
                              content:
                                  'Bạn có thể kiểm tra chỉ số BMI của mình bằng cách sử dụng chiều cao và trọng lượng cơ thể. Để tính chỉ số BMI của một người trưởng thành, hãy chia trọng lượng(theo kg) cho bình phương chiều cao(theo m) hay BMI = (trọng lượng cơ thể)/ (chiều cao x chiều cao) \n Đối với người lớn, chỉ số BMI từ 18,5- 24,9 nằm trong mức cân nặng bình thường hoặc khỏe mạnh. Chỉ số BMI từ 25,0 trở lên là thừa cân, trong khi chỉ số BMI dưới 18,5 là thiếu cân',
                              isExpanded: isExpanded1,
                              onToggle: () =>
                                  setState(() => isExpanded1 = !isExpanded1),
                            ),
                            Divider(color: Colors.grey.withOpacity(0.5)),
                            _buildExpandableSection(
                              title: 'Tại sao bạn nên biết về chỉ số BMI?',
                              content:
                                  'Bạn có thể kiểm tra chỉ số BMI của mình bằng cách sử dụng chiều cao và trọng lượng cơ thể. Để tính chỉ số BMI của một người trưởng thành, hãy chia trọng lượng(theo kg) cho bình phương chiều cao(theo m) hay BMI = (trọng lượng cơ thể)/ (chiều cao x chiều cao) \n Đối với người lớn, chỉ số BMI từ 18,5- 24,9 nằm trong mức cân nặng bình thường hoặc khỏe mạnh. Chỉ số BMI từ 25,0 trở lên là thừa cân, trong khi chỉ số BMI dưới 18,5 là thiếu cân',
                              isExpanded: isExpanded2,
                              onToggle: () =>
                                  setState(() => isExpanded2 = !isExpanded2),
                            ),
                            Divider(color: Colors.grey.withOpacity(0.5)),
                            _buildExpandableSection(
                              title:
                                  'Chỉ số BMI cao có gây nguy hiểm nghiêm trọng đến sức khỏe không',
                              content:
                                  'Đo BMI có thể là mốt công cụ sàng lọc nhưng không dùng chuẩn đoán tình trạng béo phì hoặc sức khỏe cá nhân. Để xác định chỉ số BMI có tiềm ẩn một nguy cơ ảnh hương đến sức khỏe hay không, bác sĩ hay các chuyên gia y tế sẽ cần thực hiện thêm những đánh giá khác như đo độ dày nếp gấp da, đánh giá chế độ ăn uống, hoạt động thể chất và tiền sử gia đình',
                              isExpanded: isExpanded3,
                              onToggle: () => setState(
                                () {
                                  isExpanded3 = !isExpanded3;
                                },
                              ),
                            ),
                            Divider(color: Colors.grey.withOpacity(0.5)),
                            _buildExpandableSection(
                              title: 'Những nguy cơ gây báo phì bạn cần nắm',
                              content:
                                  'Nếu bạn có chỉ số BMI từ 30,0 trở lên, kết quả này được phân loại là béo phì. \nBéo phì có ảnh hưởng đến cơ thể và những người béo phì có nguy cơ tử vong cao hơn bình thường do dễ mắc một số tình trạng sức khỏe như: \n- Bệnh tiểu đường type 2 \n- Choleserol LDL cao, cholesretol HDL thấp hoặc mức lipid máu không tốt cho sức khỏe(mỡ trong máu) \n- Bệnh tim mạch vành \n- Đột quỵ \n- Bệnh túi mật \n- Viêm xương khớp \n- Ngưng thở khi ngủ và các vấn đề về hô hấp \n- Tình trạng viêm mãn tính và tăng stress oxy hóa \n- Ung thư \n- Trầm cảm, rối loạn lo âu và các tình trạng sức khỏe tâm thần khác',
                              isExpanded: isExpanded4,
                              onToggle: () => setState(
                                () {
                                  isExpanded4 = !isExpanded4;
                                },
                              ),
                            ),
                            Divider(color: Colors.grey.withOpacity(0.5)),
                            _buildExpandableSection(
                              title: 'Những nguy cơ gây thiếu cân bạn cần nắm',
                              content:
                                  'Nếu chỉ số BMI của bạn dưới 18.5, bạn đang thiếu cân so với chiều cao của mình.\nKhi mức cân nặng thấp hơn nhiều so với trọng lượng lý tưởng, bạn cũng có nguy cơ mắc các bệnh khác do thiếu dinh dưỡng và hệ miễn dịch kém, chẳng hạn như:\n- Suy dinh dưỡng\n- Thiếu máu\n- Loãng xương do thiếu canxi và vitamin D\n- Các vấn đề về khả năng sinh sản do chu kỳ kinh nguyệt không đều\n- Nguy cơ biến chứng hậu phẫu thuật cao hơn\n- Thấp còi và các vấn đề về phát triển khác ở trẻ em và thanh thiếu niên',
                              isExpanded: isExpanded4,
                              onToggle: () => setState(
                                () {
                                  isExpanded4 = !isExpanded4;
                                },
                              ),
                            ),
                            Divider(color: Colors.grey.withOpacity(0.5)),
                            _buildExpandableSection(
                              title:
                                  'Chỉ số BMI có phải là một chỉ số tốt đề đánh giá lượng mỡ trong cơ thể?',
                              content:
                                  'Mặc dù chỉ số BMI và lượng mỡ có thể có mối tương quan chặt chẽ nhưng không có nghĩa 2 người dùng chỉ số BMI sẽ có lượng mỡ trong cơ thể.\nSự khác biệt có thể phụ thuộc và tạng người, tuổi tác, giới tính và mức độ hoạt động thể chất. Ngay cả ở cùng một chỉ số BMI, các vận động viên sẽ có lượng mỡ cơ thể ít hơn những người không phải là vận động viên; người lớn tuổi sẽ có lượng mỡ nhiều hơn những người trẻ tuổi; phụ nữ thường có lượng mỡ nhiều hơn nam giới',
                              isExpanded: isExpanded5,
                              onToggle: () => setState(
                                () {
                                  isExpanded5 = !isExpanded5;
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
                    MaterialPageRoute(builder: (context) => MeasurebmiScreen()),
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
