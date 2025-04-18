import 'package:flutter/material.dart';

class ConfirmDeleteDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const ConfirmDeleteDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Xác nhận xóa'),
      content: const Text('Bạn có chắc muốn xóa hồ sơ này không?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Đóng dialog trước
            onConfirm(); // Gọi hàm xác nhận
          },
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('Xóa'),
        ),
      ],
    );
  }
}
