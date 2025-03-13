# 📘 Hướng Dẫn Sử Dụng GitHub Từ A-Z

## 🛠 **Mục Đích**

Hướng dẫn này cung cấp cách sử dụng GitHub từ cơ bản đến nâng cao, bao gồm các quy tắc đặt tên branch, commit, và Pull Request để quản lý dự án hiệu quả.

---

## **1. GitHub Cơ Bản**

### 1.1. **Cách Tạo Repository (Repo)**

1. Truy cập GitHub: [https://github.com](https://github.com).
2. Nhấn nút **New** để tạo repo mới.
3. Điền thông tin:
   - **Repository name**: Đặt tên repo (vd: `healthcare-app`).
   - **Description**: Mô tả dự án ngắn gọn.
   - **Visibility**: Chọn `Public` (công khai) hoặc `Private` (riêng tư).
4. Nhấn **Create repository**.

---

### 1.2. **Clone Repository Về Máy**

```bash
git clone https://github.com/username/repository-name.git
```

- `username`: Tên tài khoản GitHub.
- `repository-name`: Tên repo bạn vừa tạo.

---

## **2. Làm Việc Với Branch**

### 2.1. **Tạo Branch Mới**

Quy tắc đặt tên branch:

- Sử dụng tiền tố để phân loại công việc:
  - `feature/`: Tính năng mới.
  - `bugfix/`: Sửa lỗi.
- Tên branch dùng `kebab-case`.

**Cách tạo branch:**

```bash
git checkout -b feature/add-login-screen
```

### 2.2. **Chuyển Đổi Giữa Các Branch**

```bash
git fetch --all
git checkout branch-name
```

---

## **3. Commit Code**

### 3.1. **Quy Tắc Đặt Tên Commit**

1. **Cấu trúc commit message:**

   ```commit
   <type>: <subject>
   ```

   - **type**: Loại commit. Ví dụ:
     - `new`: Tính năng mới.
     - `fix`: Sửa lỗi.
     - `chore`: Công việc không ảnh hưởng tính năng (cập nhật dependencies).
   - **subject**: Mô tả ngắn gọn, bắt đầu bằng động từ.

**Ví dụ commit:**

```bash
git commit -m "new: add login functionality"
git commit -m "fix: resolve API timeout issue"
```

---

## **4. Push Code Lên GitHub**

```bash
git push origin branch-name
```

- `branch-name`: Tên branch bạn đang làm việc (vd: `feature/add-login-screen`).

---

## **5. Pull Request (PR)**

### 5.1. **Tạo Pull Request**

1. Truy cập repo trên GitHub.
2. Nhấn **Pull Requests** > **New Pull Request**.
3. Chọn branch nguồn và branch đích.
4. Điền mô tả chi tiết:
   - **Title:** Tên branch hoặc mô tả ngắn gọn công việc.
   - **Description:** Giải thích công việc đã làm, liên kết issue/task ID (nếu có).
5. Nhấn **Create Pull Request**.

### 5.2. **Quy Tắc Đặt Tên Pull Request**

- **Cấu trúc:** `[Type] Mô tả công việc`
  - **Type:** `Feature`, `Bugfix`, `Hotfix`, `Chore`.

**Ví dụ:**

- `[Feature] Add Login Screen`
- `[Bugfix] Fix Calendar Display`

---

## **6. Merge Pull Request**

1. Sau khi PR được review và approve, nhấn **Merge Pull Request**.
2. Xóa branch sau khi merge:

   ```bash
   git branch -d branch-name
   ```

---

## **7. Quy Tắc Tổng Quát**

### 7.1. **Đặt Tên Branch**

| Loại Branch      | Tiền Tố       | Ví Dụ                               |
|------------------|---------------|-------------------------------------|
| Tính năng mới    | `feature/`    | `feature/add-login-screen`         |
| Sửa lỗi          | `bugfix/`     | `bugfix/fix-api-error`             |

---

### 7.2. **Quy Tắc Đặt Tên Commit**

| Type       | Mô Tả                        | Ví Dụ                           |
|------------|------------------------------|----------------------------------|
| `feat`     | Thêm tính năng mới           | `feat: add login functionality` |
| `fix`      | Sửa lỗi                      | `fix: resolve API timeout issue`|
| `chore`    | Công việc phụ trợ            | `chore: update dependencies`    |

---

## 📖 **Tham Khảo**

- [Tài liệu chính thức GitHub](https://docs.github.com/en)
- [Cách sử dụng Git](https://git-scm.com/doc)

---

Hãy tuân thủ hướng dẫn này để làm việc nhóm hiệu quả và chuyên nghiệp hơn! 🚀
