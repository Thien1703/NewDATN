import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/services/local_storage_service.dart';
import 'package:health_care/utils/validators.dart';
import 'package:health_care/viewmodels/profile_viewmodel.dart';
import 'package:health_care/viewmodels/toast_helper.dart';
import 'package:health_care/views/widgets/widget_header_body.dart';
import 'package:health_care/views/widgets/widget_selectGender.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddProfile extends StatefulWidget {
  final VoidCallback? onProfileAdded;

  const AddProfile({super.key, this.onProfileAdded});

  @override
  State<AddProfile> createState() => _AddProfileState();
}

class _AddProfileState extends State<AddProfile> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _addressController = TextEditingController();

  final _focusPhone = FocusNode();
  final _focusAddress = FocusNode();

  String? _selectedGender;
  bool isLoading = false;
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    _addressController.dispose();
    _focusPhone.dispose();
    _focusAddress.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      final profileVM = context.read<ProfileViewModel>();
      int? customerId = await LocalStorageService.getUserId();

      if (!mounted) return;

      if (customerId == null) {
        showToastError(
            "Không tìm thấy thông tin người dùng. Vui lòng đăng nhập lại!");
        setState(() => isLoading = false);
        return;
      }

      await profileVM.createProfile(
        context,
        customerId: customerId,
        fullName: _fullNameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        birthDate: DateFormat('yyyy-MM-dd')
            .format(_selectedDate), // 👉 Format để gửi backend
        gender: _selectedGender ?? "Nam",
        address: _addressController.text.trim(),
      );

      if (mounted) {
        setState(() => isLoading = false);
        widget.onProfileAdded?.call();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WidgetHeaderBody(
      iconBack: true,
      title: 'Thêm hồ sơ đặt khám',
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _customTitle('Họ và tên'),
              _buildTextField(
                controller: _fullNameController,
                hint: 'Nhập họ và tên',
                validator: Validators.validateFullName,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_focusPhone),
              ),
              const SizedBox(height: 15),
              _customTitle('Số điện thoại'),
              _buildTextField(
                controller: _phoneController,
                hint: 'Nhập số điện thoại',
                validator: Validators.validatePhoneNumber,
                keyboardType: TextInputType.phone,
                focusNode: _focusPhone,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 15),
              _customTitle('Ngày sinh'),
              _buildDatePickerField(),
              const SizedBox(height: 15),
              _customTitle('Giới tính'),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  child: WidgetSelectGender(
                    initialGender: _selectedGender,
                    onChanged: (gender) =>
                        setState(() => _selectedGender = gender),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              _customTitle('Địa chỉ'),
              _buildTextField(
                controller: _addressController,
                hint: 'Nhập địa chỉ',
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Vui lòng nhập địa chỉ'
                    : null,
                focusNode: _focusAddress,
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: GestureDetector(
                  onTap: isLoading ? null : _handleSubmit,
                  child: AbsorbPointer(
                    absorbing: isLoading,
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                        color: AppColors.deepBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      alignment: Alignment.center,
                      child: isLoading
                          ? const SizedBox(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Thêm hồ sơ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
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
    FocusNode? focusNode,
    TextInputAction? textInputAction,
    void Function(String)? onFieldSubmitted,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  Widget _buildDatePickerField() {
    return TextFormField(
      controller: _birthDateController,
      readOnly: true,
      validator: (value) => value == null || value.trim().isEmpty
          ? 'Vui lòng chọn ngày sinh'
          : null,
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (picked != null && picked != _selectedDate) {
          setState(() {
            _selectedDate = picked;
            _birthDateController.text =
                DateFormat('dd-MM-yyyy').format(picked); // Format hiển thị
          });
        }
      },
      decoration: InputDecoration(
        hintText: 'Chọn ngày sinh',
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        suffixIcon: const Icon(Icons.calendar_today),
      ),
    );
  }
}
