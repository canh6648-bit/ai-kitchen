AI Kitchen Pro - Bản sửa match nguyên liệu

1) Copy các file vào thư mục project:
- main.py
- index.html
- auth.html
- database.sql
- requirements.txt

2) Nếu bạn dùng YOLO, đặt file model vào cùng thư mục và đổi tên thành:
best.pt

3) Chạy database.sql trong MySQL Workbench.
Lưu ý: script này sẽ reset database smart_recipe_db.

4) Cài thư viện:
pip install -r requirements.txt

5) Chạy backend:
uvicorn main:app --reload

6) Mở auth.html hoặc index.html bằng trình duyệt.

Đã sửa:
- Chuẩn hóa Ca_Rot, ca_rot, Trung, Ca_Chua... về tên tiếng Việt trong database.
- Sửa lỗi Cà chua trong database.
- Chỉ hiện món database khi đủ nguyên liệu chính.
- Thiếu nguyên liệu phụ thì vẫn hiện món và gợi ý thay thế.
- Thiếu nguyên liệu chính thì không fallback về món sai như chỉ có Su hào mà hiện Thịt lợn xào su hào.
