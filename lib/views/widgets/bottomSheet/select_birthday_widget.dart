import 'package:flutter/material.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:intl/intl.dart';

class SelectBirthdayWidget extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateSelected;

  const SelectBirthdayWidget({
    super.key,
    required this.initialDate,
    required this.onDateSelected,
  });

  @override
  State<SelectBirthdayWidget> createState() => _SelectBirthdayWidgetState();
}

class _SelectBirthdayWidgetState extends State<SelectBirthdayWidget> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
  }

  void _openDatePicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 350,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 40), // Cách lề trái
                  const Text(
                    "Chọn ngày",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Expanded(
                child: ScrollDatePicker(
                  selectedDate: _selectedDate,
                  locale: const Locale('vi'),
                  scrollViewOptions: const DatePickerScrollViewOptions(
                    year: ScrollViewDetailOptions(
                      margin: EdgeInsets.only(right: 10),
                    ),
                    month: ScrollViewDetailOptions(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                    ),
                    day: ScrollViewDetailOptions(
                      margin: EdgeInsets.only(left: 10),
                    ),
                  ),
                  onDateTimeChanged: (DateTime value) {
                    if (value != null) {
                      setState(() {
                        _selectedDate = value;
                      });
                    }
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  widget.onDateSelected(_selectedDate);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  "Hoàn tất",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _openDatePicker,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat('dd-MM-yyyy').format(_selectedDate),
              style: const TextStyle(fontSize: 16),
            ),
            const Icon(Icons.calendar_today),
          ],
        ),
      ),
    );
  }
}
