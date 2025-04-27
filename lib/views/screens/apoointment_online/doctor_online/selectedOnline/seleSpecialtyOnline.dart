import 'package:flutter/material.dart';
import 'package:health_care/models/specialty.dart';
import 'package:health_care/views/widgets/bottomSheet/header_bottomSheet.dart';

class Selespecialtyonline extends StatelessWidget {
  const Selespecialtyonline({super.key, required this.specialties});
  final List<Specialty> specialties;

  @override
  Widget build(BuildContext context) {
    return HeaderBottomSheet(
      title: 'Chọn chuyên khoa',
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 5),
            ...specialties.map(
              (s) => Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[400]!,
                        blurRadius: 1,
                        spreadRadius: 1,
                      )
                    ]),
                margin: EdgeInsets.symmetric(vertical: 6),
                child: InkWell(
                  child: Text(
                    s.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context, s);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
