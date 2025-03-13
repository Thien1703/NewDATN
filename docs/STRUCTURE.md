# 📱 Ứng Dụng Đặt Lịch Khám Bệnh

Ứng dụng này được xây dựng bằng Flutter theo mô hình **MVVM**, với cấu trúc thư mục rõ ràng và dễ mở rộng.

---

## 🗂 **Cấu Trúc Thư Mục**

```STRUCTURE
lib/
├── src/
│   ├── models/               # Các class dữ liệu (Appointment, User, Doctor)
│   ├── views/                # Giao diện người dùng (UI)
│   │   ├── screens/          # Các màn hình (Login, Home, Appointment)
│   │   └── widgets/          # Widget tái sử dụng (button, form, dialog)
│   ├── viewmodels/           # Logic kết nối giữa Model và View
│   │   ├── auth_viewmodel.dart
│   │   ├── appointment_viewmodel.dart
│   │   └── doctor_viewmodel.dart
│   ├── repositories/         # Xử lý dữ liệu (API và Local)
│   │   ├── user_repository.dart
│   │   ├── appointment_repository.dart
│   │   └── doctor_repository.dart
│   ├── services/             # Kết nối API và Local DB
│   │   ├── api_service.dart
│   │   └── local_storage_service.dart
│   ├── utils/                # Hàm tiện ích, extension
│   ├── config/               # Cài đặt chung (routes, theme, dependency)
│   └── common/               # Thành phần chung (constants, themes, localization)
├── main.dart                 # Entry point
```

---

## 📦 **Chi Tiết Từng Thư Mục**

### **1. `models/`**

- Chứa các class dữ liệu ánh xạ từ API hoặc Local Storage.
- **Ví dụ:**
  - `appointment.dart`: Định nghĩa thông tin lịch hẹn.
  - `user.dart`: Thông tin người dùng.
  - `doctor.dart`: Thông tin bác sĩ.

---

### **2. `views/`**

- Chứa giao diện người dùng:
  - **`screens/`**: Các màn hình chính (Login, Home, Appointment).
  - **`widgets/`**: Các widget tái sử dụng như button, form, dialog.
- **Ví dụ:**
  - `login_screen.dart`: Màn hình đăng nhập.
  - `appointment_card_widget.dart`: Thẻ hiển thị thông tin lịch hẹn.

---

### **3. `viewmodels/`**

- Chứa logic kết nối giữa View (UI) và Model (Dữ liệu).
- **Ví dụ:**
  - `auth_viewmodel.dart`: Quản lý trạng thái và logic cho đăng nhập/đăng ký.
  - `appointment_viewmodel.dart`: Quản lý lịch hẹn.

---

### **4. `repositories/`**

- Xử lý dữ liệu từ API và Local Storage.
- **Ví dụ:**
  - `appointment_repository.dart`: Gọi API để lấy danh sách lịch hẹn.
  - `user_repository.dart`: Quản lý thông tin người dùng.

---

### **5. `services/`**

- Kết nối API và Local Storage:
  - `api_service.dart`: Gọi API backend.
  - `local_storage_service.dart`: Quản lý dữ liệu cục bộ bằng SQLite hoặc Hive.

---

### **6. `utils/`**

- Chứa các hàm tiện ích, extension dùng chung.
- **Ví dụ:**
  - `date_utils.dart`: Định dạng ngày giờ.
  - `validators.dart`: Kiểm tra dữ liệu đầu vào.

---

### **7. `config/`**

- Chứa các cài đặt chung:
  - `routes.dart`: Quản lý route trong ứng dụng.
  - `theme.dart`: Cài đặt giao diện (màu sắc, font chữ).

---

### **8. `common/`**

- Chứa các thành phần dùng chung:
  - `constants.dart`: Các hằng số (API URL, Key).
  - `themes/`: Định nghĩa màu sắc, typography.

---
