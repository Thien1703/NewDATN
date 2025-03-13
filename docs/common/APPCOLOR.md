# 📚 Hướng Dẫn Sử Dụng `COMMON/COLOR.DART`

Lớp `AppColors` chứa bảng màu chính của ứng dụng, được sử dụng để đảm bảo tính đồng bộ và dễ quản lý màu sắc trong suốt ứng dụng Flutter.

---

## ✨ **Hướng Dẫn Sử Dụng `AppColors`**

### **1. Sử dụng trực tiếp trong widget**

Bạn có thể sử dụng màu từ `AppColors` trong các widget Flutter:

```dart
Container(
  color: AppColors.primary, // Sử dụng màu chính làm nền
  child: Text(
    'Hello, World!',
    style: TextStyle(color: AppColors.neutralWhite), // Text màu trắng
  ),
);
```

### **2. Sử dụng trong `ThemeData`**

Bạn có thể tích hợp `AppColors` vào `ThemeData` để áp dụng màu sắc trong toàn ứng dụng:

```dart
ThemeData(
  primaryColor: AppColors.primary,
  accentColor: AppColors.accent,
  scaffoldBackgroundColor: AppColors.neutralWhite,
);
```

### **3. Dùng cho nút hoặc trạng thái**

- **Nút bấm:**
  
  ```dart
  ElevatedButton(
    style: ElevatedButton.styleFrom(
      primary: AppColors.accent, // Màu nền nút
      onPrimary: AppColors.neutralWhite, // Màu chữ
    ),
    onPressed: () {},
    child: Text('Click me'),
  );
  ```

- **Trạng thái tích cực:**
  
  ```dart
  Icon(
    Icons.check_circle,
    color: AppColors.neutralGreen, // Màu xanh lá tích cực
  );
  ```

---

## 💡 **Lưu Ý Khi Sử Dụng**

1. **Đồng bộ giao diện:** Sử dụng màu từ `AppColors` để đảm bảo giao diện thống nhất.
2. **Hạn chế hardcode màu sắc:** Luôn tham chiếu màu từ `AppColors` thay vì sử dụng trực tiếp mã hex trong widget.
3. **Thêm màu mới:** Nếu cần thêm màu, hãy bổ sung chúng vào `AppColors` và cập nhật các phần liên quan.

---

Với `AppColors`, bạn có thể dễ dàng quản lý và sử dụng bảng màu một cách hiệu quả, giúp giao diện ứng dụng trở nên nhất quán và chuyên nghiệp hơn. 😊
