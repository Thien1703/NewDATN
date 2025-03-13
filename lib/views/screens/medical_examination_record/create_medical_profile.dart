import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/views/widgets/widget_header_body.dart';
import 'package:health_care/views/widgets/widget_selectGender.dart';
import 'package:health_care/views/widgets/widget_selectProvince.dart';
import 'package:vietnam_provinces/vietnam_provinces.dart';

class CreateMedicalProfile extends StatefulWidget {
  const CreateMedicalProfile({super.key});

  @override
  State<CreateMedicalProfile> createState() => _CreateMedicalProfileState();
}

class _CreateMedicalProfileState extends State<CreateMedicalProfile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _idCardController = TextEditingController();
  final TextEditingController _insuranceController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  Province? selectedProvince;
  String? selectedGender;
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updateButtonState);
    _dobController.addListener(_updateButtonState);
    _idCardController.addListener(_updateButtonState);
    _insuranceController.addListener(_updateButtonState);
    _phoneController.addListener(_updateButtonState);
    _emailController.addListener(_updateButtonState);
    _cityController.addListener(_updateButtonState);
    _addressController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {
      isButtonEnabled = _nameController.text.isNotEmpty &&
          _dobController.text.isNotEmpty &&
          _idCardController.text.isNotEmpty &&
          _insuranceController.text.isNotEmpty &&
          _phoneController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _cityController.text.isNotEmpty &&
          _addressController.text.isNotEmpty &&
          selectedProvince != null && // Kiểm tra tỉnh/thành phố đã được chọn
          selectedGender != null; // Kiểm tra giới tính
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WidgetHeaderBody(
        iconBack: true,
        title: 'Tạo mới hồ sơ',
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _customTitle(title: 'Họ và tên'),
                _customTextField(
                    controller: _nameController,
                    labelText: 'Nhập họ và tên',
                    width: double.infinity),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _customTitle(title: 'Ngày sinh'),
                        Container(
                          child: _customTextField(
                            controller: _dobController,
                            labelText: 'Ngày / Tháng / Năm',
                            width: 170,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _customTitle(title: 'Giới tính'),
                        WidgetSelectGender(
                          initialGender: selectedGender,
                          onChanged: (String gender) {
                            setState(() {
                              selectedGender = gender;
                            });
                            _updateButtonState();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                _customTitle(title: 'Mã định danh/CCCD'),
                _customTextField(
                    controller: _idCardController,
                    labelText: 'Vui lòng nhập Mã định danh/CCCD',
                    width: double.infinity),
                _customTitle(title: 'Mã bảo hiểm y tế'),
                _customTextField(
                    controller: _insuranceController,
                    labelText: 'Mã bảo hiểm y tế',
                    width: double.infinity),
                _customTitle(title: 'Số điện thoại'),
                _customTextField(
                    controller: _phoneController,
                    labelText: '09xxxxxxxx',
                    width: double.infinity),
                _customTitle(title: 'Email'),
                _customTextField(
                    controller: _emailController,
                    labelText: 'Email',
                    width: double.infinity),
                // _customTitle(title: 'Tỉnh / TP'),
                // _customTextField(
                //     controller: _cityController,
                //     labelText: 'Chọn tỉnh thành',
                //     width: double.infinity),
                // Sử dụng widget chọn tỉnh từ package vietnam_provinces
                _customTitle(title: 'Tỉnh / TP'),
                WidgetSelectProvince(
                  initialProvince: selectedProvince,
                  onChanged: (Province province) {
                    setState(() {
                      selectedProvince = province;
                    });
                    _updateButtonState(); // Cập nhật trạng thái nút
                  },
                ),

                _customTitle(title: 'Địa chỉ'),
                _customTextField(
                    controller: _addressController,
                    labelText: 'Chỉ nhập số nhà, tên đường, ấp thôn xóm,...',
                    width: double.infinity),
                Container(
                  // alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 12, bottom: 20),
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: isButtonEnabled ? () {} : null,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          color: isButtonEnabled
                              ? AppColors.accent
                              : AppColors.grey4),
                      backgroundColor:
                          isButtonEnabled ? AppColors.accent : AppColors.grey4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    ),
                    child: Text(
                      'Tạo mới hồ sơ',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppColors.neutralWhite),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _customTitle({required String title}) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.neutralDarkGreen1),
      ),
    );
  }

  Widget _customTextField(
      {required TextEditingController controller,
      required String labelText,
      required double width}) {
    return Container(
      height: 45,
      width: width,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          filled: true,
          fillColor: Colors.white,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          labelStyle: const TextStyle(fontSize: 14),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: AppColors.accent, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: AppColors.neutralGrey2, width: 1),
          ),
        ),
      ),
    );
  }
}
