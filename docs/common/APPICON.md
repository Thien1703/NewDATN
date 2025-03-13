# 📚 Hướng Dẫn Nhanh: Sử Dụng và Thêm Icon Mới

## **1. Sử dụng `COMMON/AppIcons` trong Flutter**

Khi muốn sử dụng một icon trong ứng dụng, bạn có thể gọi `Image.asset()` kèm với đường dẫn từ lớp `AppIcons`.

**Ví dụ:**

```dart
import 'package:flutter/material.dart';
import 'app_icons.dart';

class IconExampleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Icon Example'),
      ),
      body: Center(
        child: Image.asset(AppIcons.addProfile), // Hiển thị icon add_profile_icon
      ),
    );
  }
}
```

---

## **2. Thêm icon mới vào `AppIcons`**

Khi muốn thêm một icon mới:

1. **Thêm file icon vào thư mục** `assets/icons/`.
   - Ví dụ: `assets/icons/new_icon.png`.

2. **Khai báo trong file `app_icons.dart`:**

   ```dart
   class AppIcons {
     static const String newIcon = 'assets/icons/new_icon.png'; // Thêm icon mới
   }
   ```

3. **Sử dụng icon mới:**

   ```dart
   Image.asset(AppIcons.newIcon);
   ```

---

### **Tóm gọn:**

1. Gọi `AppIcons.iconName` để sử dụng icon.
2. Khi thêm icon mới:
   - Đặt file icon vào thư mục `assets/icons/`.
   - Khai báo trong `app_icons.dart`.

Vậy là bạn đã sẵn sàng sử dụng và thêm icon mới một cách nhanh chóng! 🚀
