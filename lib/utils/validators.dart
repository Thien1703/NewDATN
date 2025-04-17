class Validators {
  static String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập họ và tên';
    }

    // Regex: chỉ cho phép chữ cái và khoảng trắng (bao gồm tên có dấu tiếng Việt)
    final regex = RegExp(r"^[a-zA-ZÀ-ỹ\s]+$");

    if (!regex.hasMatch(value.trim())) {
      return 'Họ và tên không được chứa số hoặc ký tự đặc biệt';
    }

    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập email';
    }
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(value)) {
      return 'Email không hợp lệ';
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập số điện thoại';
    }

    final trimmed = value.trim();

    // Kiểm tra độ dài 10 số và bắt đầu bằng các đầu số hợp lệ
    final validPhoneRegex = RegExp(r'^(03|05|07|08|09)[0-9]{8}$');

    if (!validPhoneRegex.hasMatch(trimmed)) {
      return 'Vui lòng nhập đúng định dạng số điện thoại';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    }

    // Kiểm tra không được chứa khoảng trắng
    if (value.contains(' ')) {
      return 'Mật khẩu không được chứa khoảng trắng';
    }

    // Regex: ít nhất 8 ký tự, gồm ít nhất 1 chữ hoa và 1 chữ số (ký tự đặc biệt thì có thể có hoặc không)
    final regex = RegExp(r'^(?=.*[A-Z])(?=.*\d).{8,}$');

    if (!regex.hasMatch(value)) {
      return 'Mật khẩu phải từ 8 ký tự trở lên, gồm ít nhất 1 chữ hoa và 1 số ';
    }
    return null;
  }

  static String? validateGender(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng chọn giới tính';
    }
    return null;
  }
}
