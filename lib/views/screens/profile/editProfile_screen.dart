import 'dart:io';
import 'package:flutter/material.dart';
import 'package:health_care/config/app_config.dart';
import 'package:health_care/views/widgets/bottomSheet/select_birthday_widget.dart';
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

  Map<String, dynamic>? _userData;
  String? selectedGender;
  bool isButtonEnabled = false;
  bool isLoading = false;
  File? _avatarFile;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _nameController.addListener(_updateButtonState);
    _dobController.addListener(_updateButtonState);
    _addressController.addListener(_updateButtonState);
  }

  Future<void> _loadUserProfile() async {
    final userProfile = await AppConfig.getUserProfile();
    if (userProfile != null) {
      setState(() {
        _nameController.text = userProfile['fullName'] ?? '';
        _dobController.text = userProfile['birthDate'] ?? '';
        _addressController.text = userProfile['address'] ?? '';
        selectedGender = userProfile['gender'];
        // Kiểm tra và chuyển đổi ngày sinh
        String? birthDateStr = userProfile['birthDate'];
        if (birthDateStr != null && birthDateStr.isNotEmpty) {
          try {
            DateTime parsedDate = DateTime.parse(birthDateStr);
            _selectedDate = parsedDate;
            _dobController.text = DateFormat('dd/MM/yyyy').format(parsedDate);
          } catch (e) {
            print('Lỗi khi parse ngày sinh: $e');
            _selectedDate = DateTime.now(); // Gán giá trị mặc định an toàn
            _dobController.text = '';
          }
        }
      });
    }
  }

  void _updateButtonState() {
    if (!mounted) return;
    setState(() {
      isButtonEnabled = _nameController.text.isNotEmpty &&
          _dobController.text.isNotEmpty &&
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

      widget.onProfileUpdated(); // Gọi callback để reload ProfileScreen
      if (mounted) {
        setState(() {}); // Cập nhật UI ngay lập tức
      }
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
                            child:
                                Icon(Icons.camera_alt, color: AppColors.grey4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _customTitle(title: 'Họ và tên'),
                _customTextField(
                    controller: _nameController, labelText: 'Nhập họ và tên'),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _customTitle(title: 'Ngày sinh'),
                    SizedBox(height: 5),
                    SelectBirthdayWidget(
                      initialDate: _selectedDate,
                      onDateSelected: (DateTime pickedDate) {
                        setState(() {
                          _selectedDate = pickedDate;
                          _dobController.text =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                        });
                        _updateButtonState();
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
                        _updateButtonState();
                      },
                    ),
                  ],
                ),
                _customTitle(title: 'Địa chỉ'),
                _customTextField(
                    controller: _addressController, labelText: 'Nhập địa chỉ'),
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 20),
                  height: 55,
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: isButtonEnabled
                        ? () async {
                            setState(() {
                              isLoading = true; // Start loading
                            });
                            final authViewModel = Provider.of<AuthViewModel>(
                                context,
                                listen: false);
                            Map<String, dynamic> profileData = {
                              "fullName": _nameController.text.trim(),
                              "birthDate": _dobController.text.trim(),
                              "address": _addressController.text.trim(),
                              "gender": selectedGender,
                            };
                            bool success = await authViewModel.updateProfile(
                                context, profileData, _avatarFile);
                            setState(() {
                              isLoading = false; // Stop loading
                            });
                            if (success) {
                              widget
                                  .onProfileUpdated(); // Gọi lại hàm để làm mới dữ liệu
                            }
                          }
                        : null,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: isButtonEnabled && !isLoading
                            ? AppColors.deepBlue
                            : AppColors.softBlue,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Center(
                        child: isLoading
                            ? CircularProgressIndicator(
                                color: Colors.white,
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
