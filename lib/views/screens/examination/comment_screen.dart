import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/common/app_icons.dart';
import 'package:health_care/models/rating/rating_sreate.dart';
import 'package:health_care/viewmodels/api/rating_api.dart';
import 'package:health_care/views/screens/home/home_screens.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({
    super.key,
    required this.customerId,
    required this.serviceId,
    required this.stars,
  });
  final int customerId;
  final int serviceId;
  final int stars;

  @override
  State<CommentScreen> createState() => _CommentScreen();
}

class _CommentScreen extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  // Tạo một phương thức riêng để xử lý gửi đánh giá
  Future<void> _handleSubmit() async {
    final comment = _commentController.text;
    setState(() {
      _isLoading = true;
    });

    // Gọi API để gửi dữ liệu
    RatingCreate? result = await RatingApi.writeApiRating(
      widget.serviceId,
      widget.customerId,
      widget.stars,
      comment,
    );
    setState(() {
      _isLoading = false;
    });

    // Xử lý kết quả API
    if (result != null) {
      _showSnackBar('Đánh giá của bạn đã được gửi thành công!');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreens()),
      );
    } else {
      _showSnackBar('Đã có lỗi khi gửi đánh giá.');
    }
  }

  // Tạo một phương thức riêng để hiển thị snack bar
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: InkWell(
        onTap: () => Navigator.pop(context),
        child: Image.asset(AppIcons.cancel),
      )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildUserInfo(),
            _buildStarDisplay(),
            SizedBox(height: 40),
            _buildCommentTextField(),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  // Widget cho thông tin người dùng và dịch vụ
  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text("Người dùng ID: ${widget.customerId}"),
        // Text("Dịch vụ ID: ${widget.serviceId}"),
      ],
    );
  }

  // Widget hiển thị sao màu vàng tùy vào số lượng sao
  Widget _buildStarDisplay() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Đánh giá',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(5, (index) {
                return Icon(
                  index < widget.stars
                      ? Icons.star_purple500_sharp
                      : Icons.star_border,
                  color: Colors.amber,
                  size: 40,
                );
              }),
            )
          ],
        )
      ],
    );
  }

  // Widget cho TextField
  Widget _buildCommentTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Chia sẻ nhận xét',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _commentController,
          maxLines: 3,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12), // Bo góc tròn
              ),
              hintText:
                  'Chia sẻ với mọi người điều làm bạn hài lòng về dịch vụ này',
              hintStyle: TextStyle(
                fontSize: 13,
              )),
        )
      ],
    );
  }

  Widget _buildSubmitButton() {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: ElevatedButton(
              onPressed: _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.deepBlue, // Nền xanh lá
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Bo góc
                ),
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text(
                'Gửi',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white, // Chữ màu trắng
                ),
              ),
            ),
          );
  }
}
