import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.search,
          color: Colors.grey,
          size: 26,
        ),
        suffixIcon: const Icon(
          Icons.mic,
          color: AppColors.accent,
          size: 26,
        ),
        // helperText: "Search your topic",
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelText: "Search your topic",
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        isDense: true,
      ),
    );
  }
}
