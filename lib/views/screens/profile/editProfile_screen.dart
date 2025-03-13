import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/viewmodels/auth_viewmodel.dart';
import 'package:health_care/views/widgets/widget_header_body.dart';
import 'package:health_care/views/widgets/widget_selectGender.dart';
import 'package:provider/provider.dart';
import 'package:vietnam_provinces/vietnam_provinces.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  Province? selectedProvince;
  String? selectedGender;
  bool isButtonEnabled = false;
  File? _avatarFile; // Ảnh đại diện

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updateButtonState);
    _dobController.addListener(_updateButtonState);
    _emailController.addListener(_updateButtonState);
    _addressController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {
      isButtonEnabled = _nameController.text.isNotEmpty &&
          _dobController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _addressController.text.isNotEmpty &&
          selectedGender != null;
    });
  }

  /// Chọn ảnh từ thư viện
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _avatarFile = File(pickedFile.path);
      });
      _updateButtonState();
    }
  }

  /// Cập nhật hồ sơ người dùng
  void _updateUserProfile(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    Map<String, dynamic> profileData = {
      "fullName": _nameController.text.trim(),
      "birthDate": _dobController.text.trim(),
      "email": _emailController.text.trim(),
      "address": _addressController.text.trim(),
      "gender": selectedGender,
    };

    authViewModel.updateProfile(context, profileData, _avatarFile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WidgetHeaderBody(
        iconBack: true,
        title: 'Chỉnh sửa hồ sơ',
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: _avatarFile != null
                              ? FileImage(_avatarFile!)
                              : const AssetImage('assets/images/noavatar.png')
                                  as ImageProvider,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.white,
                            child:
                                Icon(Icons.camera_alt, color: AppColors.accent),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _customTitle(title: 'Họ và tên'),
                _customTextField(
                    controller: _nameController, labelText: 'Nhập họ và tên'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _customTitle(title: 'Ngày sinh'),
                        _customTextField(
                          controller: _dobController,
                          labelText: 'Ngày / Tháng / Năm',
                          width: 170,
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
                _customTitle(title: 'Email'),
                _customTextField(
                    controller: _emailController, labelText: 'Email'),
                _customTitle(title: 'Địa chỉ'),
                _customTextField(
                    controller: _addressController,
                    labelText: 'Chỉ nhập số nhà, tên đường, ấp thôn xóm,...'),
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 20),
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: isButtonEnabled
                        ? () => _updateUserProfile(context)
                        : null,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          color: isButtonEnabled
                              ? AppColors.accent
                              : AppColors.grey4),
                      backgroundColor:
                          isButtonEnabled ? AppColors.accent : AppColors.grey4,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 30),
                    ),
                    child: Text(
                      'Cập nhật',
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

  Widget _customTextField({
    required TextEditingController controller,
    required String labelText,
    double width = double.infinity,
  }) {
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
