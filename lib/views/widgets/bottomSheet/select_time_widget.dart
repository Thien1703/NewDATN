import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/viewmodels/api/appointment_api.dart';
import 'package:health_care/views/widgets/bottomSheet/header_bottomSheet.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class SelectTimeWidget extends StatefulWidget {
  final Function(String) onTimeSelected;
  final String selectedDate;
  final int clinicId;
  final int specialtyId;

  const SelectTimeWidget({
    super.key,
    required this.onTimeSelected,
    required this.selectedDate,
    required this.clinicId,
    required this.specialtyId,
  });

  @override
  State<SelectTimeWidget> createState() => _SelectTimeWidgetState();
}

class _SelectTimeWidgetState extends State<SelectTimeWidget> {
  String? selectedTime;
  Map<String, int> availableSlots =
      {}; // Đổi từ List<String> thành Map để chứa giờ và slot
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAvailableTimes();
  }

  Future<void> fetchAvailableTimes() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Gọi API để lấy thông tin thời gian có sẵn
      final result = await AppointmentApi.checkAppointmentTimeOff(
        clinicId: widget.clinicId,
        date: widget.selectedDate,
        specialtyId: widget.specialtyId,
      );

      print("📩 Dữ liệu trả về từ API: $result");

      if (result != null) {
        setState(() {
          availableSlots = result.slots; // Cập nhật slots từ model
          // Sắp xếp các giờ từ nhỏ đến lớn
          availableSlots = Map.fromEntries(
            availableSlots.entries.toList()
              ..sort((a, b) {
                DateTime timeA = DateFormat("HH:mm").parse(a.key);
                DateTime timeB = DateFormat("HH:mm").parse(b.key);
                return timeA.compareTo(timeB); // Sắp xếp theo giờ
              }),
          );
          isLoading = false;
        });
      } else {
        setState(() {
          availableSlots = {};
          isLoading = false;
        });
      }
    } catch (e) {
      print('❌ Lỗi khi gọi API: $e');
      setState(() {
        availableSlots = {};
        isLoading = false;
      });
    }
  }

  // Kiểm tra xem giờ có hợp lệ không (không phải giờ trong quá khứ)
  bool isTimeInFuture(String time) {
    DateTime currentTime = DateTime.now();
    DateTime selectedTime =
        DateFormat("yyyy-MM-dd HH:mm").parse("${widget.selectedDate} $time");
    return selectedTime.isAfter(currentTime);
  }

  List<String> getMorningSlots() {
    return availableSlots.keys.where((time) {
      final hour = DateFormat("HH:mm").parse(time).hour;
      return hour >= 7 &&
          hour <= 11; // Chỉ lấy giờ buổi sáng từ 07:00 đến 11:00
    }).toList();
  }

  List<String> getAfternoonSlots() {
    return availableSlots.keys.where((time) {
      final hour = DateFormat("HH:mm").parse(time).hour;
      return hour >= 13 &&
          hour <= 16; // Chỉ lấy giờ buổi chiều từ 13:00 đến 16:00
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.ghostWhite,
      child: HeaderBottomSheet(
        title: 'Chọn giờ khám',
        body: Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.85,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      isLoading
                          ? _shirmarBody()
                          : availableSlots.isEmpty
                              ? const Center(child: Text('Không có giờ trống.'))
                              : Container(
                                  width: double.infinity,
                                  child: Column(
                                    children: [
                                      // Hiển thị giờ buổi sáng
                                      if (getMorningSlots().isNotEmpty)
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Buổi sáng',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Wrap(
                                              spacing:
                                                  10, // Khoảng cách giữa các giờ
                                              runSpacing:
                                                  5, // Khoảng cách giữa các dòng
                                              children:
                                                  getMorningSlots().map((time) {
                                                final isSelected =
                                                    time == selectedTime;
                                                final slotCount =
                                                    availableSlots[time]!;

                                                return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    ChoiceChip(
                                                      label: Text(time),
                                                      selected: isSelected,
                                                      onSelected: (_) {
                                                        if (slotCount > 0 &&
                                                            isTimeInFuture(
                                                                time)) {
                                                          setState(() {
                                                            selectedTime = time;
                                                          });
                                                          widget.onTimeSelected(
                                                              time);
                                                          Navigator.pop(
                                                              context);
                                                        }
                                                      },
                                                      selectedColor:
                                                          AppColors.primary,
                                                      backgroundColor:
                                                          isTimeInFuture(time)
                                                              ? AppColors
                                                                  .deepBlue
                                                                  .withOpacity(
                                                                      0.5)
                                                              : Colors
                                                                  .grey[300],
                                                      labelStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: isTimeInFuture(
                                                                time)
                                                            ? (isSelected
                                                                ? Colors.white
                                                                : Colors.black)
                                                            : Colors.grey[500],
                                                      ),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    if (slotCount == 0)
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 20),
                                                        child: Text(
                                                          'Hết slot',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      ),
                                                    if (slotCount > 0)
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 15),
                                                        child: Text(
                                                          '$slotCount slot',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors
                                                                .grey[700],
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                );
                                              }).toList(),
                                            ),
                                          ],
                                        ),
                                      SizedBox(height: 5),

                                      // Hiển thị giờ buổi chiều
                                      if (getAfternoonSlots().isNotEmpty)
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Buổi chiều',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Wrap(
                                              spacing:
                                                  10, // Khoảng cách giữa các giờ
                                              runSpacing:
                                                  5, // Khoảng cách giữa các dòng
                                              children: getAfternoonSlots()
                                                  .map((time) {
                                                final isSelected =
                                                    time == selectedTime;
                                                final slotCount =
                                                    availableSlots[time]!;

                                                return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    ChoiceChip(
                                                      label: Text(time),
                                                      selected: isSelected,
                                                      onSelected: (_) {
                                                        if (slotCount > 0 &&
                                                            isTimeInFuture(
                                                                time)) {
                                                          setState(() {
                                                            selectedTime = time;
                                                          });
                                                          widget.onTimeSelected(
                                                              time);
                                                          Navigator.pop(
                                                              context);
                                                        }
                                                      },
                                                      selectedColor:
                                                          AppColors.primary,
                                                      backgroundColor:
                                                          isTimeInFuture(time)
                                                              ? AppColors
                                                                  .deepBlue
                                                                  .withOpacity(
                                                                      0.5)
                                                              : Colors
                                                                  .grey[300],
                                                      labelStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: isTimeInFuture(
                                                                time)
                                                            ? (isSelected
                                                                ? Colors.white
                                                                : Colors.black)
                                                            : Colors.grey[500],
                                                      ),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    if (slotCount == 0)
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 20),
                                                        child: Text(
                                                          'Hết slot',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      ),
                                                    if (slotCount > 0)
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 15),
                                                        child: Text(
                                                          '$slotCount slot',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors
                                                                .grey[700],
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                );
                                              }).toList(),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
  
Widget _shirmarBody() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 100,
            height: 20,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: double.infinity,
            height: 60,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 120,
            height: 60,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 5),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 100,
            height: 20,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: double.infinity,
            height: 60,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: double.infinity,
            height: 70,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}
