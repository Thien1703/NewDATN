import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/views/widgets/widget_header_body.dart';
import 'package:health_care/views/widgets/widget_selectGender.dart';

class CreateProfileBooking extends StatefulWidget {
  const CreateProfileBooking({super.key});
  @override
  State<CreateProfileBooking> createState() {
    return _CreateProfileBooking();
  }
}

class _CreateProfileBooking extends State<CreateProfileBooking> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dateBirthController = TextEditingController();
  final TextEditingController _positionqController = TextEditingController();
  bool isButtonCreate = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updateButton);
    _phoneController.addListener(_updateButton);
    _dateBirthController.addListener(_updateButton);
    _positionqController.addListener(_updateButton);
  }

  void _updateButton() {
    setState(() {
      isButtonCreate = _nameController.text.isNotEmpty &&
          _phoneController.text.isNotEmpty &&
          _dateBirthController.text.isNotEmpty &&
          _positionqController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WidgetHeaderBody(
        iconBack: true,
        title: 'Tạo hồ sơ mới',
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _customTitleCreateProject(titleProject: 'Họ và tên'),
              _customTextFromField(
                  controller: _nameController,
                  width: double.infinity,
                  labelText: 'Nhập họ và tên'),
              _customTitleCreateProject(titleProject: 'Số diện thoại'),
              _customTextFromField(
                  controller: _phoneController,
                  width: double.infinity,
                  labelText: '09xxxxxxxx'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _customTitleCreateProject(titleProject: 'Ngày sinh'),
                      Container(
                        child: _customTextFromField(
                            controller: _dateBirthController,
                            width: 160,
                            labelText: 'Ngày/ Tháng/ Năm'),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _customTitleCreateProject(titleProject: 'Giới tính'),
                      // WidgetSelectGender(),
                    ],
                  )
                ],
              ),
              _customTitleCreateProject(titleProject: 'Tỉnh / TP'),
              _customTextFromField(
                  controller: _positionqController,
                  width: double.infinity,
                  labelText: 'Chọn tỉnh thành'),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 30),
                child: OutlinedButton(
                  onPressed: isButtonCreate ? () {} : null,
                  style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          color: isButtonCreate
                              ? AppColors.accent
                              : AppColors.grey4),
                      backgroundColor:
                          isButtonCreate ? AppColors.accent : AppColors.grey4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 30)),
                  child: Text(
                    'Tạo hồ sơ mới',
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget _customTitleCreateProject({required String titleProject}) {
  return Container(
    margin: EdgeInsets.only(top: 20),
    child: Text(
      titleProject,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.neutralDarkGreen1,
      ),
    ),
  );
}

Widget _customTextFromField(
    {required controller, required double width, required String labelText}) {
  return Container(
    width: width,
    height: 45,
    margin: EdgeInsets.symmetric(vertical: 5),
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
          labelText: labelText,
          filled: true,
          fillColor: Colors.white,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          labelStyle: TextStyle(fontSize: 14),
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: AppColors.accent, width: 1)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: AppColors.neutralGrey2, width: 1))),
    ),
  );
}
