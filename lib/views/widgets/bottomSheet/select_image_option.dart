import 'package:flutter/material.dart';
import 'package:health_care/views/widgets/bottomSheet/header_bottomSheet.dart';

class SelectImageOption extends StatelessWidget {
  final VoidCallback onPickFromGallery;
  final VoidCallback onTakePhoto;

  const SelectImageOption({
    super.key,
    required this.onPickFromGallery,
    required this.onTakePhoto,
  });

  @override
  Widget build(BuildContext context) {
    return HeaderBottomSheet(
      title: 'Chọn ảnh từ',
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildOption(
            icon: Icons.photo_library,
            text: 'Thư viện hình',
            onTap: () {
              Navigator.pop(context);
              onPickFromGallery();
            },
          ),
          _buildOption(
            icon: Icons.camera_alt,
            text: 'Chụp ảnh mới',
            onTap: () {
              Navigator.pop(context);
              onTakePhoto();
            },
          ),
          // _buildOption(
          //   icon: Icons.remove_circle,
          //   text: 'Gỡ ảnh hiện tại',
          //   onTap: () {
          //     Navigator.pop(context);
          //     onRemovePhoto();
          //   },
          // ),
        ],
      ),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(text),
      onTap: onTap,
    );
  }
}
