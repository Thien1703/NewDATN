import 'dart:io';
import 'package:flutter/material.dart';
import 'package:health_care/config/app_config.dart';
import 'package:image_picker/image_picker.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/viewmodels/auth_viewmodel.dart';
import 'package:health_care/views/widgets/widget_header_body.dart';
import 'package:health_care/views/widgets/widget_selectGender.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EditProfileScreen extends StatefulWidget {
  final Function onProfileUpdated;
  const EditProfileScreen({super.key, required this.onProfileUpdated});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, dynamic>? _userData;
  String? selectedGender;
  bool isLoading = false;
  bool isAvatarLoading = false;
  File? _avatarFile;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập họ và tên';
    }

    // Regex: chỉ cho phép chữ cái (bao gồm tiếng Việt có dấu) và khoảng trắng
    final nameRegex = RegExp(r"^[a-zA-ZÀ-ỹ\s]+$");

    if (!nameRegex.hasMatch(value.trim())) {
      return 'Họ và tên không được chứa số hoặc ký tự đặc biệt';
    }

    return null;
  }

  Future<void> _loadUserProfile() async {
    final userProfile = await AppConfig.getUserProfile();
    if (userProfile != null) {
      setState(() {
        _nameController.text = userProfile['fullName'] ?? '';
        _addressController.text = userProfile['address'] ?? '';
        selectedGender = userProfile['gender'];

        // Cập nhật dữ liệu avatar
        _userData = userProfile;
        if (userProfile['avatar'] != null && userProfile['avatar'].isNotEmpty) {
          // Kiểm tra URL hợp lệ
          if (Uri.tryParse(userProfile['avatar'])?.hasAbsolutePath == true) {
            _userData!['avatar'] = userProfile['avatar'];
          } else {
            print('URL avatar không hợp lệ.');
            _userData!['avatar'] = null;
          }
        }
        String? birthDateStr = userProfile['birthDate'];
        if (birthDateStr != null && birthDateStr.isNotEmpty) {
          try {
            DateTime parsedDate = DateTime.parse(birthDateStr); // ✅ Parse được
            _selectedDate = parsedDate;
            _dobController.text = DateFormat('yyyy-MM-dd')
                .format(parsedDate); // ✅ format hiển thị
          } catch (e) {
            print('Lỗi khi parse ngày sinh: $e');
            _selectedDate = DateTime.now();
            _dobController.text = '';
          }
        } else {
          _selectedDate = DateTime.now();
          _dobController.text = '';
        }
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        isAvatarLoading = true;
        _avatarFile = File(pickedFile.path);
      });
      if (!mounted) return;
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      await authViewModel.uploadAvatar(context, _avatarFile!);

      setState(() {
        isAvatarLoading = false; // Kết thúc loading
      });

      widget.onProfileUpdated(); // Gọi callback để reload ProfileScreen
      if (mounted) {
        setState(() {}); // Cập nhật UI ngay lập tức
      }
    }
  }

  Future<void> _handleUpdateProfile() async {
    if (!_formKey.currentState!.validate()) {
      return; // Nếu validate không qua thì dừng
    }
    if (_nameController.text.isEmpty ||
        _dobController.text.isEmpty ||
        _addressController.text.isEmpty ||
        selectedGender == null ||
        isLoading) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    Map<String, dynamic> profileData = {
      "fullName": _nameController.text.trim(),
      "birthDate": _dobController.text.trim(),
      "address": _addressController.text.trim(),
      "gender": selectedGender,
    };

    bool success = await authViewModel.updateProfile(context, profileData);

    setState(() {
      isLoading = false;
    });

    if (success) {
      widget.onProfileUpdated();
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
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: InkWell(
                            onTap: _pickImage,
                            child: CircleAvatar(
                              radius: 40,
                              backgroundImage: _avatarFile != null
                                  ? FileImage(_avatarFile!)
                                  : (_userData?['avtar'] != null &&
                                              Uri.tryParse(_userData!['avtar'])
                                                      ?.hasAbsolutePath ==
                                                  true
                                          ? CachedNetworkImageProvider(
                                              _userData!['avtar'])
                                          : const AssetImage(
                                              'assets/images/noavatar.png'))
                                      as ImageProvider,
                              child: isAvatarLoading
                                  ? const CircularProgressIndicator(
                                      color: AppColors.softBlue)
                                  : null, // Hiển thị spinner nếu đang tải
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            onTap: _pickImage,
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.camera_alt,
                                  color: AppColors.grey4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _customTitle(title: 'Họ và tên'),
                  _customTextField(
                    controller: _nameController,
                    labelText: 'Nhập họ và tên',
                    validator: _validateName,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _customTitle(title: 'Ngày sinh'),
                      SizedBox(height: 5),
                      TextFormField(
                        controller: _dobController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        readOnly: true,
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null && picked != _selectedDate) {
                            setState(() {
                              _selectedDate = picked;
                              _dobController.text =
                                  DateFormat('yyyy-MM-dd').format(picked);
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _customTitle(title: 'Giới tính'),
                      SizedBox(height: 5),
                      WidgetSelectGender(
                        initialGender: selectedGender,
                        onChanged: (String gender) {
                          setState(() {
                            selectedGender = gender;
                          });
                          // _updateButtonState();
                        },
                      ),
                    ],
                  ),
                  _customTitle(title: 'Địa chỉ'),
                  _customTextField(
                      controller: _addressController,
                      labelText: 'Nhập địa chỉ'),
                  Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 20),
                    height: 55,
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: _nameController.text.isNotEmpty &&
                              _dobController.text.isNotEmpty &&
                              _addressController.text.isNotEmpty &&
                              selectedGender != null &&
                              !isLoading
                          ? _handleUpdateProfile
                          : null,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color:
                              !isLoading ? AppColors.deepBlue : AppColors.grey4,
                        ),
                        child: Center(
                          child: isLoading
                              ? SizedBox(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Cập nhật',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
  String? Function(String?)? validator,
}) {
  return TextFormField(
    controller: controller,
    validator: validator,
    decoration: InputDecoration(
      // labelText: labelText,
      // filled: true,
      // fillColor: Colors.white,
      // floatingLabelBehavior: FloatingLabelBehavior.never,
      // labelStyle: const TextStyle(fontSize: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      // contentPadding:
      //     const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      // focusedBorder: OutlineInputBorder(
      //   borderRadius: const BorderRadius.all(Radius.circular(15)),
      //   borderSide: BorderSide(color: AppColors.accent, width: 1),
      // ),
      // enabledBorder: OutlineInputBorder(
      //   borderRadius: const BorderRadius.all(Radius.circular(10)),
      //   borderSide: BorderSide(color: AppColors.neutralGrey2, width: 1),
      // ),
    ),
  );
}
