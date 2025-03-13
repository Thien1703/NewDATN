import 'package:flutter/material.dart';
import 'package:vietnam_provinces/vietnam_provinces.dart';

class WidgetSelectProvince extends StatefulWidget {
  /// Giá trị tỉnh đã chọn ban đầu (nếu có)
  final Province? initialProvince;

  /// Callback trả về Province khi người dùng chọn
  final ValueChanged<Province> onChanged;

  const WidgetSelectProvince({
    Key? key,
    this.initialProvince,
    required this.onChanged,
  }) : super(key: key);

  @override
  _WidgetSelectProvinceState createState() => _WidgetSelectProvinceState();
}

class _WidgetSelectProvinceState extends State<WidgetSelectProvince> {
  // Khởi tạo danh sách tỉnh với danh sách rỗng để tránh lỗi LateInitializationError
  List<Province> _provinces = [];

  Province? _selectedProvince;

  @override
  void initState() {
    super.initState();
    // Lấy danh sách các tỉnh từ package vietnam_provinces
    _provinces = VietnamProvinces.getProvinces();
    _selectedProvince = widget.initialProvince;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Province>(
      decoration: InputDecoration(
        // labelText: 'Chọn Tỉnh/Thành phố',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      ),
      isExpanded: true,
      value: _selectedProvince,
      items: _provinces.map((Province province) {
        return DropdownMenuItem<Province>(
          value: province,
          child: Text(province.name),
        );
      }).toList(),
      onChanged: (Province? newProvince) {
        if (newProvince != null) {
          setState(() {
            _selectedProvince = newProvince;
          });
          widget.onChanged(newProvince);
        }
      },
    );
  }
}
