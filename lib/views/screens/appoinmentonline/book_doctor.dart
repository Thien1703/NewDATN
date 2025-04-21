import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookDoctor extends StatefulWidget {
  @override
  _BookdoctorState createState() => _BookdoctorState();
}

class _BookdoctorState extends State<BookDoctor> {
  final List<String> timeSlots = [
    "13:00 - 13:30",
    "13:30 - 14:00",
    "14:00 - 14:30",
    "14:30 - 15:00",
    "15:00 - 15:30",
    "15:30 - 16:00",
    "16:00 - 16:30",
    "16:30 - 17:00",
  ];

  String selectedSlot = "13:30 - 14:00";
  DateTime selectedDate = DateTime.now();

  List<DateTime> getThisWeekDates() {
    final today = DateTime.now();
    final startOfWeek =
        today.subtract(Duration(days: today.weekday % 7)); // Chủ Nhật
    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    final thisWeek = getThisWeekDates();

    return Scaffold(
      appBar: AppBar(title: Text("Ngày giờ hẹn khám")),
      body: Column(
        children: [
          SizedBox(height: 16),
          // Chọn ngày trong tuần hiện tại
          SizedBox(
            height: 90,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: getThisWeekDates().map((date) {
                final isSelected = selectedDate.day == date.day &&
                    selectedDate.month == date.month &&
                    selectedDate.year == date.year;

                final isToday = date.day == DateTime.now().day &&
                    date.month == DateTime.now().month &&
                    date.year == DateTime.now().year;

                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => selectedDate = date),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue : Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                        border: isToday
                            ? Border.all(color: Colors.redAccent, width: 2)
                            : null,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            [
                              'CN',
                              'T2',
                              'T3',
                              'T4',
                              'T5',
                              'T6',
                              'T7'
                            ][date.weekday % 7],
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${date.day}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          SizedBox(height: 16),
          Text("Vui lòng chọn buổi",
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          DefaultTabController(
            length: 3,
            child: Column(
              children: [
                TabBar(tabs: [
                  Tab(text: 'Sáng (0)'),
                  Tab(text: 'Chiều (8)'),
                  Tab(text: 'Tối (0)'),
                ]),
                Container(
                  height: 220,
                  child: TabBarView(
                    children: [
                      Center(child: Text("Không có lịch")),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: timeSlots.map((slot) {
                            return ChoiceChip(
                              label: Text(slot),
                              selected: selectedSlot == slot,
                              onSelected: (_) {
                                setState(() => selectedSlot = slot);
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      Center(child: Text("Không có lịch")),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  print('Hẹn ngày: $selectedDate, khung giờ: $selectedSlot');
                },
                child: Text("Tiếp tục"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
