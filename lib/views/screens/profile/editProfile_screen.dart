import 'dart:io';
import 'package:flutter/material.dart';
import 'package:health_care/config/app_config.dart';
import 'package:image_picker/image_picker.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/viewmodels/auth_viewmodel.dart';
import 'package:health_care/views/widgets/widget_header_body.dart';
import 'package:health_care/views/widgets/widget_selectGender.dart';
import 'package:provider/provider.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:intl/intl.dart';

class EditProfileScreen extends StatefulWidget {
  final Function onProfileUpdated;
  const EditProfileScreen({super.key, required this.onProfileUpdated});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String? selectedGender;
  bool isButtonEnabled = false;
  File? _avatarFile;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _nameController.addListener(_updateButtonState);
    _dobController.addListener(_updateButtonState);
    _emailController.addListener(_updateButtonState);
    _addressController.addListener(_updateButtonState);
  }

  Future<void> _loadUserProfile() async {
    final userProfile = await AppConfig.getUserProfile();
    if (userProfile != null) {
      setState(() {
        _nameController.text = userProfile['fullName'] ?? '';
        _dobController.text = userProfile['birthDate'] ?? '';
        _emailController.text = userProfile['email'] ?? '';
        _addressController.text = userProfile['address'] ?? '';
        selectedGender = userProfile['gender'];
        _selectedDate =
            DateTime.tryParse(userProfile['birthDate'] ?? '') ?? DateTime.now();
      });
    }
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

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _avatarFile = File(pickedFile.path);
      });

      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      await authViewModel.uploadAvatar(context, _avatarFile!);

      _updateButtonState();
    }
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
                        SizedBox(
                          height: 250,
                          child: ScrollDatePicker(
                            selectedDate: _selectedDate,
                            locale: Locale('en'),
                            onDateTimeChanged: (DateTime value) {
                              setState(() {
                                _selectedDate = value;
                                _dobController.text =
                                    DateFormat('yyyy-MM-dd').format(value);
                              });
                              _updateButtonState();
                            },
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
                _customTitle(title: 'Email'),
                _customTextField(
                    controller: _emailController, labelText: 'Email'),
                _customTitle(title: 'Địa chỉ'),
                _customTextField(
                    controller: _addressController, labelText: 'Nhập địa chỉ'),
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 20),
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: isButtonEnabled
                        ? () async {
                            final authViewModel = Provider.of<AuthViewModel>(
                                context,
                                listen: false);
                            Map<String, dynamic> profileData = {
                              "fullName": _nameController.text.trim(),
                              "birthDate": _dobController.text.trim(),
                              "email": _emailController.text.trim(),
                              "address": _addressController.text.trim(),
                              "gender": selectedGender,
                            };
                            bool success = await authViewModel.updateProfile(
                                context, profileData, _avatarFile);
                            if (success) {
                              widget
                                  .onProfileUpdated(); // Gọi lại hàm để làm mới dữ liệu
                            }
                          }
                        : null,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          color: isButtonEnabled
                              ? AppColors.deepBlue
                              : AppColors.grey4),
                      backgroundColor: isButtonEnabled
                          ? AppColors.deepBlue
                          : AppColors.grey4,
                    ),
                    child: Text(
                      'Cập nhật',
                      style: TextStyle(color: AppColors.neutralWhite),
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
}

Widget _customTitle({required String title}) {
  return Container(
    margin: const EdgeInsets.only(top: 20),
    child: Text(
      title,
      style: TextStyle(
          fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.deepBlue),
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
