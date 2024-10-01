
-- Tạo cơ sở dữ liệu EasyTravels
CREATE DATABASE EasyTravel;
USE EasyTravel;

-- Bảng Tài khoản
CREATE TABLE Accounts (
    account_id VARCHAR(10) PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(50), -- Vai trò: "Admin", "Customer", "ServiceProvider", "Staff"
    created_at DATETIME DEFAULT GETDATE()
);

-- Bảng Khách hàng
CREATE TABLE Customers (
    customer_id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    address VARCHAR(255),
    account_id VARCHAR(10), -- Khóa ngoại liên kết với bảng Accounts
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
);

-- Bảng Nhân viên
CREATE TABLE Staffs (
    staff_id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    position VARCHAR(50), -- Chức vụ của nhân viên
    account_id VARCHAR(10), -- Khóa ngoại liên kết với bảng Accounts
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
);

-- Bảng Nhà cung cấp dịch vụ (Đối tác)
CREATE TABLE ServiceProviders (
    provider_id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    contact_info VARCHAR(255),
    address VARCHAR(255),
    description TEXT,
    revenue DECIMAL(15, 2) DEFAULT 0.00, -- Doanh thu của đối tác
    account_id VARCHAR(10), -- Khóa ngoại liên kết với bảng Accounts
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
);

-- Bảng Khách sạn
CREATE TABLE Hotels (
    hotel_id VARCHAR(10) PRIMARY KEY,
    provider_id VARCHAR(10), -- Khóa ngoại liên kết với bảng ServiceProviders
    hotel_name VARCHAR(100) NOT NULL,
    location VARCHAR(100),
    star_rating INT CHECK (star_rating BETWEEN 1 AND 5), -- Đánh giá sao (1-5)
    description TEXT,
    amenities TEXT, -- Tiện nghi khách sạn
    image_url VARCHAR(255),
    contact_info VARCHAR(255),
    status VARCHAR(50) DEFAULT 'Available', -- Trạng thái khách sạn: Available, Unavailable, ...
    FOREIGN KEY (provider_id) REFERENCES ServiceProviders(provider_id)
);

-- Bảng Phòng khách sạn
CREATE TABLE HotelRooms (
    room_id VARCHAR(10) PRIMARY KEY,
    hotel_id VARCHAR(10), -- Khóa ngoại liên kết với bảng Hotels
    room_type VARCHAR(50), -- Loại phòng (Standard, Suite, Deluxe, ...)
    max_capacity INT, -- Sức chứa tối đa
    price_per_night DECIMAL(10, 2), -- Giá thuê phòng mỗi đêm
    amenities TEXT, -- Tiện nghi phòng
    status VARCHAR(50) DEFAULT 'Available', -- Trạng thái phòng: Available, Unavailable, ...
    FOREIGN KEY (hotel_id) REFERENCES Hotels(hotel_id)
);

-- Bảng Thuê xe
CREATE TABLE CarRentals (
    car_id VARCHAR(10) PRIMARY KEY,
    provider_id VARCHAR(10), -- Khóa ngoại liên kết với bảng ServiceProviders
    car_model VARCHAR(100),
    car_type VARCHAR(50), -- Loại xe: Sedan, SUV, ...
    price_per_day DECIMAL(10, 2),
    capacity INT, -- Số lượng chỗ ngồi
    description TEXT,
    image_url VARCHAR(255),
    status VARCHAR(50) DEFAULT 'Available', -- Trạng thái xe: Available, Unavailable, ...
    FOREIGN KEY (provider_id) REFERENCES ServiceProviders(provider_id)
);

-- Bảng Tour
CREATE TABLE Tours (
    tour_id VARCHAR(10) PRIMARY KEY,
    provider_id VARCHAR(10), -- Khóa ngoại liên kết với bảng ServiceProviders
    tour_name VARCHAR(100) NOT NULL,
    location VARCHAR(100),
    price_per_person DECIMAL(10, 2),
    duration INT, -- Thời gian tour (theo giờ)
    description TEXT,
    image_url VARCHAR(255),
    status VARCHAR(50) DEFAULT 'Available', -- Trạng thái tour: Available, Unavailable, ...
    FOREIGN KEY (provider_id) REFERENCES ServiceProviders(provider_id)
);

-- Bảng Đơn đặt khách sạn
CREATE TABLE HotelBookings (
    booking_id VARCHAR(10) PRIMARY KEY,
    customer_id VARCHAR(10), -- Khóa ngoại liên kết với bảng Customers
    hotel_id VARCHAR(10), -- Khóa ngoại liên kết với bảng Hotels
    check_in_date DATE, -- Ngày nhận phòng
    check_out_date DATE, -- Ngày trả phòng
    total_amount DECIMAL(10, 2), -- Tổng tiền
    status VARCHAR(50) DEFAULT 'Pending', -- Trạng thái đặt phòng: Pending, Confirmed, Cancelled, ...
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (hotel_id) REFERENCES Hotels(hotel_id)
);

-- Bảng Đơn thuê xe
CREATE TABLE CarBookings (
    booking_id VARCHAR(10) PRIMARY KEY,
    customer_id VARCHAR(10), -- Khóa ngoại liên kết với bảng Customers
    car_id VARCHAR(10), -- Khóa ngoại liên kết với bảng CarRentals
    rental_start_date DATE, -- Ngày bắt đầu thuê xe
    rental_end_date DATE, -- Ngày trả xe
    total_amount DECIMAL(10, 2), -- Tổng tiền
    status VARCHAR(50) DEFAULT 'Pending', -- Trạng thái thuê xe: Pending, Confirmed, Cancelled, ...
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (car_id) REFERENCES CarRentals(car_id)
);

-- Bảng Đơn đặt tour
CREATE TABLE TourBookings (
    booking_id VARCHAR(10) PRIMARY KEY,
    customer_id VARCHAR(10), -- Khóa ngoại liên kết với bảng Customers
    tour_id VARCHAR(10), -- Khóa ngoại liên kết với bảng Tours
    booking_date DATE, -- Ngày đặt tour
    number_of_people INT, -- Số lượng người tham gia
    total_amount DECIMAL(10, 2), -- Tổng tiền
    status VARCHAR(50) DEFAULT 'Pending', -- Trạng thái đặt tour: Pending, Confirmed, Cancelled, ...
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (tour_id) REFERENCES Tours(tour_id)
);

-- Bảng Thanh toán
CREATE TABLE Payments (
    payment_id VARCHAR(10) PRIMARY KEY,
    booking_id VARCHAR(10),
    booking_type VARCHAR(20), -- Loại đặt chỗ (hotel, car, tour)
    amount_paid DECIMAL(10, 2),
    payment_method VARCHAR(50),
    payment_status VARCHAR(20),
    payment_date DATETIME DEFAULT GETDATE(),
    CHECK (booking_type IN ('hotel', 'car', 'tour')) -- Đảm bảo loại booking là một trong các giá trị đã định
);

-- Bảng Đánh giá dịch vụ
CREATE TABLE ServiceRatings (
    rating_id VARCHAR(10) PRIMARY KEY,
    customer_id VARCHAR(10), -- Khóa ngoại liên kết với bảng Customers
    service_id VARCHAR(10), -- ID của dịch vụ (có thể là hotel_id, car_id hoặc tour_id)
    service_type VARCHAR(50), -- Loại dịch vụ được đánh giá (hotel, car, tour)
    rating INT CHECK (rating BETWEEN 1 AND 5), -- Đánh giá (1 - 5 sao)
    review TEXT, -- Nhận xét của khách hàng
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Bảng Quyền hạn (Phân quyền cho các tài khoản)
CREATE TABLE Authorities (
    authority_id VARCHAR(10) PRIMARY KEY,
    account_id VARCHAR(10),
    role VARCHAR(50), -- "Admin", "Customer", "ServiceProvider", "Staff"
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
);

-- Bảng Doanh thu
CREATE TABLE Revenue (
    revenue_id VARCHAR(10) PRIMARY KEY, -- ID duy nhất của bảng Doanh thu
    provider_id VARCHAR(10), -- Khóa ngoại đến bảng ServiceProviders
    service_type VARCHAR(20), -- Loại dịch vụ: "hotel", "car", "tour"
    service_id VARCHAR(10), -- ID của dịch vụ (hotel_id, car_id, tour_id)
    total_revenue DECIMAL(15, 2), -- Tổng doanh thu của dịch vụ
    date_generated DATE DEFAULT GETDATE(), -- Ngày ghi nhận doanh thu
    FOREIGN KEY (provider_id) REFERENCES ServiceProviders(provider_id)
);



-- 1Dữ liệu mẫu cho bảng Tài khoản
INSERT INTO Accounts (account_id, username, email, password, role) VALUES
('ACC001', 'admin1', 'admin1@gmail.com', 'password1', 'Admin'),
('ACC002', 'customer1', 'customer1@gmail.com', 'password2', 'Customer'),
('ACC003', 'staff1', 'staff1@gmail.com', 'password3', 'Staff'),
('ACC004', 'provider1', 'provider1@gmail.com', 'password4', 'ServiceProvider'),
('ACC005', 'customer2', 'customer2@gmail.com', 'password5', 'Customer'),
('ACC006', 'admin2', 'admin2@gmail.com', 'password6', 'Admin'),
('ACC007', 'staff2', 'staff2@gmail.com', 'password7', 'Staff'),
('ACC008', 'provider2', 'provider2@gmail.com', 'password8', 'ServiceProvider'),
('ACC009', 'customer3', 'customer3@gmail.com', 'password9', 'Customer'),
('ACC010', 'customer4', 'customer4@gmail.com', 'password10', 'Customer');

-- 2Dữ liệu mẫu cho bảng Khách hàng
INSERT INTO Customers (customer_id, name, email, phone, address, account_id) VALUES
('CUST001', 'Nguyen Van A', 'customer1@gmail.com', '0123456789', 'Ha Noi', 'ACC002'),
('CUST002', 'Tran Thi B', 'customer2@gmail.com', '0987654321', 'Ho Chi Minh', 'ACC005'),
('CUST003', 'Le Van C', 'customer3@gmail.com', '0112233445', 'Da Nang', 'ACC009'),
('CUST004', 'Pham Thi D', 'customer4@gmail.com', '0123456780', 'Hue', 'ACC010'),
('CUST005', 'Nguyen Van E', 'customer5@gmail.com', '0123456781', 'Nha Trang', 'ACC002'),
('CUST006', 'Nguyen Van F', 'customer6@gmail.com', '0123456782', 'Da Lat', 'ACC005'),
('CUST007', 'Nguyen Van G', 'customer7@gmail.com', '0123456783', 'Can Tho', 'ACC009'),
('CUST008', 'Tran Thi H', 'customer8@gmail.com', '0123456784', 'Vung Tau', 'ACC010'),
('CUST009', 'Pham Thi I', 'customer9@gmail.com', '0123456785', 'Hai Phong', 'ACC002'),
('CUST010', 'Le Van J', 'customer10@gmail.com', '0123456786', 'Hanoi', 'ACC005');

-- 3Dữ liệu mẫu cho bảng Nhân viên
INSERT INTO Staffs (staff_id, name, email, phone, position, account_id) VALUES
('STAFF001', 'Nguyen Van K', 'staff1@gmail.com', '0123456787', 'Quản lý đơn hàng', 'ACC003'),
('STAFF002', 'Tran Thi L', 'staff2@gmail.com', '0123456788', 'Nhân viên hỗ trợ khách hàng ', 'ACC007'),
('STAFF003', 'Le Van M', 'staff3@gmail.com', '0123456789', 'Nhân viên tư vấn khách hàng ', 'ACC003');


-- 4Dữ liệu mẫu cho bảng Nhà cung cấp dịch vụ (Đối tác)
INSERT INTO ServiceProviders (provider_id, name, contact_info, address, description) VALUES
('PROV001', 'Khách sạn ABC', '0901234567', 'Hà Nội', 'Khách sạn sang trọng với nhiều tiện nghi'),
('PROV002', 'Khách sạn XYZ', '0912345678', 'TP.HCM', 'Khách sạn tiện nghi, gần trung tâm thành phố'),
('PROV003', 'Công ty cho thuê xe 123', '0923456789', 'Đà Nẵng', 'Cung cấp dịch vụ cho thuê xe uy tín'),
('PROV004', 'Công ty du lịch 456', '0934567890', 'Nha Trang', 'Tour du lịch với giá cả hợp lý'),
('PROV005', 'Khách sạn 789', '0945678901', 'Huế', 'Khách sạn sạch đẹp, phục vụ tốt'),
('PROV006', 'Công ty cho thuê xe 111', '0956789012', 'Đà Lạt', 'Cho thuê xe với giá cả phải chăng'),
('PROV007', 'Công ty du lịch 222', '0967890123', 'Cần Thơ', 'Tour du lịch đa dạng'),
('PROV008', 'Khách sạn 333', '0978901234', 'Vũng Tàu', 'Khách sạn gần biển, phục vụ 24/7'),
('PROV009', 'Công ty cho thuê xe 444', '0989012345', 'Hải Phòng', 'Cho thuê xe du lịch và xe cá nhân'),
('PROV010', 'Khách sạn 555', '0990123456', 'Nha Trang', 'Khách sạn sang trọng, tiện nghi cao cấp');

-- 5Dữ liệu mẫu cho bảng Khách sạn
INSERT INTO Hotels (hotel_id, provider_id, hotel_name, location, star_rating, description, amenities, image_url, contact_info) VALUES
('HOTEL001', 'PROV001', 'Khách sạn ABC', 'Hà Nội', 5, 'Khách sạn sang trọng với nhiều tiện nghi.', 'Bể bơi, Gym, Nhà hàng', 'image1.jpg', '0901234567'),
('HOTEL002', 'PROV002', 'Khách sạn XYZ', 'TP.HCM', 4, 'Khách sạn tiện nghi, gần trung tâm thành phố.', 'WiFi miễn phí, Bữa sáng', 'image2.jpg', '0912345678'),
('HOTEL003', 'PROV003', 'Khách sạn 123', 'Đà Nẵng', 3, 'Khách sạn bình dân, giá cả hợp lý.', 'Điều hòa, TV', 'image3.jpg', '0923456789'),
('HOTEL004', 'PROV004', 'Khách sạn 456', 'Nha Trang', 5, 'Khách sạn sang trọng, phục vụ tốt.', 'Bể bơi, Spa', 'image4.jpg', '0934567890'),
('HOTEL005', 'PROV005', 'Khách sạn 789', 'Huế', 4, 'Khách sạn sạch đẹp, phục vụ tốt.', 'Nhà hàng, WiFi miễn phí', 'image5.jpg', '0945678901'),
('HOTEL006', 'PROV006', 'Khách sạn 111', 'Đà Lạt', 3, 'Khách sạn ấm cúng, thân thiện.', 'Điều hòa, TV', 'image6.jpg', '0956789012'),
('HOTEL007', 'PROV007', 'Khách sạn 222', 'Cần Thơ', 4, 'Khách sạn với dịch vụ tuyệt vời.', 'Gym, Bữa sáng miễn phí', 'image7.jpg', '0967890123'),
('HOTEL008', 'PROV008', 'Khách sạn 333', 'Vũng Tàu', 5, 'Khách sạn sang trọng gần biển.', 'Bể bơi, Spa', 'image8.jpg', '0978901234'),
('HOTEL009', 'PROV009', 'Khách sạn 444', 'Hải Phòng', 3, 'Khách sạn sạch sẽ, giá cả hợp lý.', 'WiFi miễn phí', 'image9.jpg', '0989012345'),
('HOTEL010', 'PROV010', 'Khách sạn 555', 'Nha Trang', 5, 'Khách sạn sang trọng, tiện nghi cao cấp.', 'Nhà hàng, Bể bơi', 'image10.jpg', '0990123456');

-- 6Dữ liệu mẫu cho bảng Phòng khách sạn
INSERT INTO HotelRooms (room_id, hotel_id, room_type, max_capacity, price_per_night, status) VALUES
('ROOM001', 'HOTEL001', 'Standard', 2, 100.00, 'Available'),
('ROOM002', 'HOTEL001', 'Suite', 4, 250.00, 'Available'),
('ROOM003', 'HOTEL002', 'Deluxe', 3, 180.00, 'Available'),
('ROOM004', 'HOTEL002', 'Standard', 2, 120.00, 'Available'),
('ROOM005', 'HOTEL003', 'Standard', 2, 80.00, 'Available'),
('ROOM006', 'HOTEL003', 'Family', 5, 200.00, 'Available'),
('ROOM007', 'HOTEL004', 'Suite', 3, 300.00, 'Available'),
('ROOM008', 'HOTEL004', 'Deluxe', 4, 220.00, 'Available'),
('ROOM009', 'HOTEL005', 'Standard', 2, 90.00, 'Available'),
('ROOM010', 'HOTEL005', 'Suite', 4, 240.00, 'Available');

-- 7Dữ liệu mẫu cho bảng Thuê xe
INSERT INTO CarRentals (car_id, provider_id, car_model, car_type, price_per_day, capacity, description) VALUES
('CAR001', 'PROV003', 'Toyota Camry', 'Sedan', 50.00, 5, 'Xe sedan tiện nghi'),
('CAR002', 'PROV003', 'Honda CR-V', 'SUV', 70.00, 5, 'Xe SUV thoải mái'),
('CAR003', 'PROV006', 'Mazda 3', 'Sedan', 40.00, 5, 'Xe sedan tiết kiệm nhiên liệu'),
('CAR004', 'PROV006', 'Fortuner', 'SUV', 90.00, 7, 'Xe SUV cho gia đình'),
('CAR005', 'PROV007', 'Kia Morning', 'Hatchback', 30.00, 4, 'Xe nhỏ, dễ lái'),
('CAR006', 'PROV007', 'Hyundai Accent', 'Sedan', 35.00, 5, 'Xe sedan tiết kiệm'),
('CAR007', 'PROV008', 'VinFast Lux A2.0', 'Sedan', 80.00, 5, 'Xe sedan sang trọng'),
('CAR008', 'PROV008', 'Toyota Innova', 'MPV', 85.00, 7, 'Xe MPV cho gia đình'),
('CAR009', 'PROV009', 'Honda City', 'Sedan', 45.00, 5, 'Xe sedan vừa phải'),
('CAR010', 'PROV009', 'Ford Ranger', 'Pickup', 100.00, 5, 'Xe pickup mạnh mẽ');

-- 8Dữ liệu mẫu cho bảng Tour
INSERT INTO Tours (tour_id, provider_id, tour_name, location, price_per_person, duration, description) VALUES
('TOUR001', 'PROV004', 'Tour Hà Nội', 'Hà Nội', 50.00, 8, 'Khám phá Hà Nội trong 1 ngày.'),
('TOUR002', 'PROV004', 'Tour Đà Nẵng', 'Đà Nẵng', 60.00, 6, 'Khám phá Đà Nẵng và các danh lam thắng cảnh.'),
('TOUR003', 'PROV007', 'Tour Nha Trang', 'Nha Trang', 70.00, 5, 'Tour du lịch biển Nha Trang.'),
('TOUR004', 'PROV007', 'Tour TP.HCM', 'TP.HCM', 55.00, 4, 'Khám phá các điểm nổi bật của TP.HCM.'),
('TOUR005', 'PROV008', 'Tour Huế', 'Huế', 65.00, 3, 'Khám phá Huế - Cố đô của Việt Nam.'),
('TOUR006', 'PROV008', 'Tour Hội An', 'Hội An', 75.00, 5, 'Khám phá phố cổ Hội An.'),
('TOUR007', 'PROV009', 'Tour Đà Lạt', 'Đà Lạt', 80.00, 7, 'Khám phá vẻ đẹp Đà Lạt.'),
('TOUR008', 'PROV009', 'Tour Cần Thơ', 'Cần Thơ', 45.00, 4, 'Khám phá miền Tây sông nước.'),
('TOUR009', 'PROV010', 'Tour Vũng Tàu', 'Vũng Tàu', 50.00, 2, 'Tour nghỉ dưỡng tại Vũng Tàu.'),
('TOUR010', 'PROV010', 'Tour Hải Phòng', 'Hải Phòng', 60.00, 3, 'Khám phá thành phố hoa phượng đỏ.');

--9 Dữ liệu mẫu cho bảng Đơn đặt khách sạn
INSERT INTO HotelBookings (booking_id, customer_id, hotel_id, check_in_date, check_out_date, total_amount) VALUES
('BOOK001', 'CUST001', 'HOTEL001', '2024-10-01', '2024-10-05', 500.00),
('BOOK002', 'CUST002', 'HOTEL002', '2024-10-03', '2024-10-07', 360.00),
('BOOK003', 'CUST003', 'HOTEL003', '2024-10-05', '2024-10-10', 400.00),
('BOOK004', 'CUST004', 'HOTEL004', '2024-10-02', '2024-10-06', 600.00),
('BOOK005', 'CUST005', 'HOTEL005', '2024-10-04', '2024-10-09', 450.00),
('BOOK006', 'CUST006', 'HOTEL001', '2024-10-06', '2024-10-11', 550.00),
('BOOK007', 'CUST007', 'HOTEL002', '2024-10-07', '2024-10-12', 370.00),
('BOOK008', 'CUST008', 'HOTEL003', '2024-10-08', '2024-10-13', 420.00),
('BOOK009', 'CUST009', 'HOTEL004', '2024-10-09', '2024-10-14', 630.00),
('BOOK010', 'CUST010', 'HOTEL005', '2024-10-10', '2024-10-15', 480.00);

-- 10Dữ liệu mẫu cho bảng Đơn thuê xe
INSERT INTO CarBookings (booking_id, customer_id, car_id, rental_start_date, rental_end_date, total_amount) VALUES
('CARBOOK001', 'CUST001', 'CAR001', '2024-10-01', '2024-10-05', 200.00),
('CARBOOK002', 'CUST002', 'CAR002', '2024-10-02', '2024-10-06', 420.00),
('CARBOOK003', 'CUST003', 'CAR003', '2024-10-03', '2024-10-07', 160.00),
('CARBOOK004', 'CUST004', 'CAR004', '2024-10-04', '2024-10-08', 360.00),
('CARBOOK005', 'CUST005', 'CAR005', '2024-10-05', '2024-10-09', 120.00),
('CARBOOK006', 'CUST006', 'CAR006', '2024-10-06', '2024-10-10', 140.00),
('CARBOOK007', 'CUST007', 'CAR007', '2024-10-07', '2024-10-11', 400.00),
('CARBOOK008', 'CUST008', 'CAR008', '2024-10-08', '2024-10-12', 340.00),
('CARBOOK009', 'CUST009', 'CAR009', '2024-10-09', '2024-10-13', 270.00),
('CARBOOK010', 'CUST010', 'CAR010', '2024-10-10', '2024-10-14', 500.00);

-- 11Dữ liệu mẫu cho bảng Đơn đặt tour
INSERT INTO TourBookings (booking_id, customer_id, tour_id, booking_date, number_of_people, total_amount) VALUES
('TOURBK001', 'CUST001', 'TOUR001', '2024-10-01', 2, 100.00),
('TOURBK002', 'CUST002', 'TOUR002', '2024-10-02', 3, 180.00),
('TOURBK003', 'CUST003', 'TOUR003', '2024-10-03', 4, 280.00),
('TOURBK004', 'CUST004', 'TOUR004', '2024-10-04', 1, 55.00),
('TOURBK005', 'CUST005', 'TOUR005', '2024-10-05', 2, 130.00),
('TOURBK006', 'CUST006', 'TOUR006', '2024-10-06', 3, 225.00),
('TOURBK007', 'CUST007', 'TOUR007', '2024-10-07', 5, 350.00),
('TOURBK008', 'CUST008', 'TOUR008', '2024-10-08', 4, 180.00),
('TOURBK009', 'CUST009', 'TOUR009', '2024-10-09', 2, 100.00),
('TOURBK010', 'CUST010', 'TOUR010', '2024-10-10', 1, 60.00);

--12
INSERT INTO Revenue (revenue_id, provider_id, service_type, service_id, total_revenue, date_generated) VALUES
('R001', 'PROV001', 'hotel', 'H001', 1500.00, '2024-10-01'),
('R002', 'PROV002', 'car', 'C001', 300.00, '2024-10-01'),
('R003', 'PROV003', 'tour', 'T001', 800.00, '2024-10-01'),
('R004', 'PROV001', 'hotel', 'H002', 2000.00, '2024-10-01'),
('R005', 'PROV002', 'car', 'C002', 450.00, '2024-10-01'),
('R006', 'PROV003', 'tour', 'T002', 1200.00, '2024-10-01'),
('R007', 'PROV001', 'hotel', 'H003', 1000.00, '2024-10-01'),
('R008', 'PROV002', 'car', 'C003', 600.00, '2024-10-01'),
('R009', 'PROV003', 'hotel', 'H004', 1800.00, '2024-10-01'),
('R010', 'PROV002', 'tour', 'T003', 900.00, '2024-10-01');

--13
INSERT INTO Payments (payment_id, booking_id, booking_type, amount_paid, payment_method, payment_status, payment_date) VALUES
('P001', 'HB001', 'hotel', 1500.00, 'Credit Card', 'Completed', '2024-10-01'),
('P002', 'CB001', 'car', 300.00, 'PayPal', 'Completed', '2024-10-01'),
('P003', 'TB001', 'tour', 800.00, 'Credit Card', 'Pending', '2024-10-01'),
('P004', 'HB002', 'hotel', 2000.00, 'Bank Transfer', 'Completed', '2024-10-01'),
('P005', 'CB002', 'car', 450.00, 'Cash', 'Completed', '2024-10-01'),
('P006', 'TB002', 'tour', 1200.00, 'Credit Card', 'Pending', '2024-10-01'),
('P007', 'HB003', 'hotel', 1000.00, 'PayPal', 'Completed', '2024-10-01'),
('P008', 'CB003', 'car', 600.00, 'Credit Card', 'Completed', '2024-10-01'),
('P009', 'HB004', 'hotel', 1800.00, 'Bank Transfer', 'Completed', '2024-10-01'),
('P010', 'TB003', 'tour', 900.00, 'Credit Card', 'Pending', '2024-10-01');

--14
INSERT INTO Authorities (authority_id, account_id, role) VALUES
('A001', 'ACC001', 'Admin'),
('A002', 'ACC002', 'Customer'),
('A003', 'ACC003', 'ServiceProvider'),
('A004', 'ACC004', 'Staff'),
('A005', 'ACC005', 'Admin'),
('A006', 'ACC006', 'Customer'),
('A007', 'ACC007', 'ServiceProvider'),
('A008', 'ACC008', 'Staff'),
('A009', 'ACC009', 'Admin'),
('A010', 'ACC010', 'Customer');

--15
INSERT INTO ServiceRatings (rating_id, customer_id, service_id, service_type, rating, review, created_at) VALUES
('R001', 'CUST001', 'HOTEL001', 'hotel', 5, 'Khách sạn rất đẹp và phục vụ tận tình.', GETDATE()),
('R002', 'CUST002', 'CAR001', 'car', 4, 'Xe mới, chạy rất êm, nhưng thời gian giao xe hơi lâu.', GETDATE()),
('R003', 'CUST003', 'TOUR001', 'tour', 5, 'Tour rất tuyệt vời, hướng dẫn viên nhiệt tình.', GETDATE()),
('R004', 'CUST004', 'HOTEL002', 'hotel', 3, 'Phòng hơi cũ, nhưng giá cả hợp lý.', GETDATE()),
('R005', 'CUST005', 'CAR002', 'car', 5, 'Dịch vụ thuê xe rất nhanh chóng và thuận tiện.', GETDATE()),
('R006', 'CUST006', 'TOUR002', 'tour', 4, 'Chuyến đi thú vị nhưng cần cải thiện bữa ăn.', GETDATE()),
('R007', 'CUST007', 'HOTEL003', 'hotel', 2, 'Không hài lòng với dịch vụ phòng.', GETDATE()),
('R008', 'CUST008', 'CAR003', 'car', 5, 'Tôi rất hài lòng với chiếc xe và chất lượng phục vụ.', GETDATE()),
('R009', 'CUST009', 'TOUR003', 'tour', 4, 'Tour đẹp nhưng thời gian hơi chặt chẽ.', GETDATE()),
('R010', 'CUST010', 'HOTEL004', 'hotel', 5, 'Địa điểm lý tưởng và dịch vụ xuất sắc.', GETDATE());





