import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/services/local_storage_service.dart';
import 'package:health_care/viewmodels/profile_viewmodel.dart';
import 'package:health_care/viewmodels/toast_helper.dart';
import 'package:health_care/views/widgets/bottomSheet/select_birthday_widget.dart';
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

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String? _selectedGender;
  bool isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final profileVM = Provider.of<ProfileViewModel>(context, listen: false);

      setState(() {
        isLoading = true;
      });

      int? customerId = await LocalStorageService.getUserId();
      if (!mounted) return;
      if (customerId == null) {
        showToastError(
            "Không tìm thấy thông tin người dùng. Vui lòng đăng nhập lại!");
        setState(() {
          isLoading = false;
        });
        return;
      }

      await profileVM.createProfile(
        context,
        customerId: customerId,
        fullName: _fullNameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        birthDate: _birthDateController.text.trim(),
        gender: _selectedGender ?? "Nam",
        address: _addressController.text.trim(),
      );
      setState(() {
        isLoading = false;
      });
      // ✅ Kiểm tra lại xem có tạo thành công không bằng cách check toast/flag (hoặc giả sử luôn thành công nếu không muốn xử lý thêm)
      widget.onProfileAdded?.call(); // Gọi callback để cập nhật danh sách
    }
  }

  @override
  Widget build(BuildContext context) {
    return WidgetHeaderBody(
      iconBack: true,
      title: 'Thêm hồ sơ đặt khám',
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
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Vui lòng nhập họ và tên'
                      : null,
                ),
                const SizedBox(height: 15),
                _customTitle('Số điện thoại'),
                _buildTextField(
                  controller: _phoneController,
                  hint: 'Nhập số điện thoại',
                  keyboardType: TextInputType.phone,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Vui lòng nhập số điện thoại'
                      : null,
                ),
                const SizedBox(height: 15),
                _customTitle('Ngày sinh'),
                SelectBirthdayWidget(
                  initialDate: DateTime.now(),
                  onDateSelected: (DateTime pickedDate) {
                    setState(() {
                      _birthDateController.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    });
                  },
                ),
                const SizedBox(height: 15),
                _customTitle('Giới tính'),
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
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
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Vui lòng nhập địa chỉ'
                      : null,
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: AppColors.deepBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: isLoading
                        ? SizedBox(
                            child: CircularProgressIndicator(
                              color: AppColors.ghostWhite,
                              // strokeWidth: 1,
                            ),
                          )
                        : const Text(
                            'Thêm hồ sơ',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
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
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: hint,
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
