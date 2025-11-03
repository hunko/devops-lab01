# Sử dụng Alpine Linux làm base image
FROM alpine:latest

# Cài đặt Python và Pip
RUN apk add --no-cache python3 py3-pip

# Thiết lập thư mục làm việc
WORKDIR /app

# Copy mã nguồn ứng dụng
COPY app /app

# Cài đặt dependencies
RUN pip3 install -r requirements.txt

# Mở cổng ứng dụng
EXPOSE 5000

# Lệnh khởi chạy ứng dụng
CMD ["python3", "app.py"]
