import 'package:flutter/material.dart';
import 'package:health_care/views/widgets/bottomSheet/header_bottomSheet.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:intl/intl.dart';

class QrCustomer extends StatefulWidget {
  const QrCustomer({super.key});

  @override
  State<QrCustomer> createState() => _QrCustomerState();
}

class _QrCustomerState extends State<QrCustomer> {
  DateTime _selectedDate = DateTime.now();

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Customer')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SelectBirthday(
              initialDate: _selectedDate,
              onDateSelected: _onDateSelected,
            ),
            const SizedBox(height: 20),
            Text('Ngày sinh đã chọn: ${DateFormat('dd-MM-yyyy').format(_selectedDate)}'),
          ],
        ),
      ),
    );
  }
}

class SelectBirthday extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateSelected;

  const SelectBirthday({
    super.key,
    required this.initialDate,
    required this.onDateSelected,
  });

  @override
  _SelectBirthdayState createState() => _SelectBirthdayState();
}

class _SelectBirthdayState extends State<SelectBirthday> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  void _showDatePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Giúp mở rộng đúng kích thước
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return HeaderBottomSheet(
          title: 'Chọn ngày sinh',
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 200, // Định rõ chiều cao tránh lỗi RenderBox
                child: ScrollDatePicker(
                  selectedDate: selectedDate,
                  locale: const Locale('vn'),
                  onDateTimeChanged: (DateTime value) {
                    setState(() {
                      selectedDate = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  widget.onDateSelected(selectedDate);
                  Navigator.pop(context);
                },
                child: const Text('Xác nhận'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDatePicker(context),
      child: AbsorbPointer(
        child: TextFormField(
          decoration: const InputDecoration(
            labelText: 'Ngày sinh',
            suffixIcon: Icon(Icons.calendar_today),
          ),
          controller: TextEditingController(
            text: DateFormat('yyyy-MM-dd').format(selectedDate),
          ),
        ),
      ),
    );
  }
}
