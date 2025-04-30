import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/utils/validators.dart';
import 'package:health_care/viewmodels/profile_viewmodel.dart';
import 'package:health_care/views/widgets/widget_header_body.dart';
import 'package:health_care/views/widgets/widget_selectGender.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditProfileAnother extends StatefulWidget {
  final int id;
  final int customerId;
  final VoidCallback? onProfileAdded;
  const EditProfileAnother(
      {super.key,
      this.onProfileAdded,
      required this.id,
      required this.customerId});

  @override
  State<EditProfileAnother> createState() => _EditProfileAnotherState();
}

class _EditProfileAnotherState extends State<EditProfileAnother> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String? _selectedGender;
  bool isLoading = false;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final profile = await Provider.of<ProfileViewModel>(context, listen: false)
        .getProfileById(widget.id);

    if (profile != null && mounted) {
      setState(() {
        _fullNameController.text = profile['fullName'] ?? '';
        _phoneController.text = profile['phoneNumber'] ?? '';
        _birthDateController.text = profile['birthDate'] ?? '';
        _addressController.text = profile['address'] ?? '';
        _selectedGender = profile['gender'];

        if (profile['birthDate'] != null &&
            profile['birthDate'].toString().isNotEmpty) {
          _selectedDate =
              DateTime.tryParse(profile['birthDate']) ?? DateTime.now();
          _birthDateController.text =
              DateFormat('dd-MM-yyyy').format(_selectedDate); // ✅ Format UI
        }
      });
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdateProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      final formattedBirthDate = DateFormat('yyyy-MM-dd')
          .format(_selectedDate); // ✅ Format gửi backend
      await Provider.of<ProfileViewModel>(context, listen: false)
          .updateProfileById(
        context,
        id: widget.id,
        customerId: widget.customerId,
        fullName: _fullNameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        birthDate: formattedBirthDate,
        address: _addressController.text.trim(),
        gender: _selectedGender ?? '',
      );

      widget.onProfileAdded?.call(); // callback để reload lại danh sách

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WidgetHeaderBody(
        iconBack: true,
        title: 'Chỉnh sửa hồ sơ đặt khám',
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _customTitle('Họ và tên'),
                  _buildTextField(
                    controller: _fullNameController,
                    hint: 'Nhập họ và tên',
                    validator: Validators.validateFullName,
                  ),
                  const SizedBox(height: 15),
                  _customTitle('Số điện thoại'),
                  _buildTextField(
                    controller: _phoneController,
                    hint: 'Nhập số điện thoại',
                    keyboardType: TextInputType.phone,
                    validator: Validators.validatePhoneNumber,
                  ),
                  const SizedBox(height: 15),
                  _customTitle('Ngày sinh'),
                  TextFormField(
                    controller: _birthDateController,
                    validator: Validators.validateBirthDate,
                    decoration: InputDecoration(
                      hintText: 'Chọn ngày sinh',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      suffixIcon: const Icon(Icons.calendar_today),
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
                          _birthDateController.text = DateFormat('dd-MM-yyyy')
                              .format(picked); // ✅ Format UI khi chọn
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 15),
                  _customTitle('Giới tính'),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      child: WidgetSelectGender(
                        initialGender: _selectedGender,
                        onChanged: (String gender) {
                          setState(() {
                            _selectedGender = gender;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  _customTitle('Địa chỉ'),
                  _buildTextField(
                    controller: _addressController,
                    hint: 'Nhập địa chỉ',
                    validator: Validators.validateAddress,
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: GestureDetector(
                      onTap: isLoading ? null : _handleUpdateProfile,
                      child: Container(
                        // padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.deepBlue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        alignment: Alignment.center,
                        child: isLoading
                            ? SizedBox(
                                // width: 20,
                                // height: 20,
                                child: CircularProgressIndicator(
                                  color: AppColors.ghostWhite,
                                  // strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Cập nhật',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
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

  Widget _customTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
