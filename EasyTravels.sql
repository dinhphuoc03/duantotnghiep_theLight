CREATE DATABASE EasyTravels;

USE EasyTravels;

-- Bảng Tài khoản
CREATE TABLE Accounts (
    account_id VARCHAR(10) PRIMARY KEY,
    username VARCHAR(100),
    email VARCHAR(100),
    password VARCHAR(255),
    
);

-- Bảng Khách hàng
CREATE TABLE Customers (
    customer_id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(15),
    password VARCHAR(255),
    address VARCHAR(255)
);

-- Bảng Nhà cung cấp dịch vụ
CREATE TABLE ServiceProviders (
    provider_id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100),
    contact_info VARCHAR(255),
    address VARCHAR(255),
    description TEXT,
    created_at DATETIME,
    account_id VARCHAR(10),
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
);

-- Bảng Khách sạn
CREATE TABLE Hotels (
    hotel_id VARCHAR(10) PRIMARY KEY,
    provider_id VARCHAR(10),
    hotel_name VARCHAR(100),
    location VARCHAR(100),
    star_rating INT,
    description TEXT,
    amenities TEXT,
    image_url VARCHAR(255),
    contact_info VARCHAR(255),
    FOREIGN KEY (provider_id) REFERENCES ServiceProviders(provider_id)
);

-- Bảng Thuê xe
CREATE TABLE CarRentals (
    car_id VARCHAR(10) PRIMARY KEY,
    provider_id VARCHAR(10), -- Thêm khóa ngoại
    car_model VARCHAR(100),
    car_type VARCHAR(50),
    price_per_day DECIMAL(10,2),
    capacity INT,
    description TEXT,
    image_url VARCHAR(255),
    FOREIGN KEY (provider_id) REFERENCES ServiceProviders(provider_id) -- Đảm bảo quyền sở hữu
);

-- Bảng Tour
CREATE TABLE Tours (
    tour_id VARCHAR(10) PRIMARY KEY,
    provider_id VARCHAR(10), -- Thêm khóa ngoại
    tour_name VARCHAR(100),
    location VARCHAR(100),
    price_per_person DECIMAL(10,2),
    duration INT,
    description TEXT,
    image_url VARCHAR(255),
    FOREIGN KEY (provider_id) REFERENCES ServiceProviders(provider_id) -- Đảm bảo quyền sở hữu
);

-- Bảng Đặt phòng khách sạn
CREATE TABLE HotelBookings (
    booking_id VARCHAR(10) PRIMARY KEY,
    customer_id VARCHAR(10),
    hotel_id VARCHAR(10), -- ID khách sạn
    room_id VARCHAR(10), -- ID phòng trong khách sạn
    check_in_date DATE, -- Ngày nhận phòng
    check_out_date DATE, -- Ngày trả phòng
    total_amount DECIMAL(10,2), -- Tổng tiền
    status VARCHAR(20), -- Trạng thái đặt phòng
    created_at DATETIME,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (hotel_id) REFERENCES Hotels(hotel_id)
);

-- Bảng Đặt thuê xe
CREATE TABLE CarBookings (
    booking_id VARCHAR(10) PRIMARY KEY,
    customer_id VARCHAR(10),
    car_id VARCHAR(10), -- ID xe thuê
    rental_start_date DATE, -- Ngày bắt đầu thuê xe
    rental_end_date DATE, -- Ngày trả xe
    total_amount DECIMAL(10,2), -- Tổng tiền
    status VARCHAR(20), -- Trạng thái thuê xe
    created_at DATETIME,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (car_id) REFERENCES CarRentals(car_id)
);

-- Bảng Đơn đặt tour
CREATE TABLE TourBookings (
    booking_id VARCHAR(10) PRIMARY KEY,
    customer_id VARCHAR(10),
    tour_id VARCHAR(10), -- ID của tour
    booking_date DATE, -- Ngày đặt tour
    number_of_people INT, -- Số lượng người tham gia
    total_amount DECIMAL(10,2), -- Tổng tiền
    status VARCHAR(20), -- Trạng thái đặt tour
    created_at DATETIME,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (tour_id) REFERENCES Tours(tour_id)
);

-- Bảng Thanh toán
CREATE TABLE Payments (
    payment_id VARCHAR(10) PRIMARY KEY,
    booking_id VARCHAR(10),
    booking_type VARCHAR(20), -- Loại đặt chỗ (hotel, car, tour)
    amount_paid DECIMAL(10,2),
    payment_method VARCHAR(50),
    payment_status VARCHAR(20),
    payment_date DATETIME,
    -- Không sử dụng FOREIGN KEY để tham chiếu booking_id với các bảng khác nhau
    CHECK (booking_type IN ('hotel', 'car', 'tour'))
);

-- Bảng Đánh giá dịch vụ
CREATE TABLE ServiceRatings (
    rating_id VARCHAR(10) PRIMARY KEY,
    customer_id VARCHAR(10),
    service_id VARCHAR(10), -- ID của dịch vụ (có thể là hotel_id, car_id hoặc tour_id)
    service_type VARCHAR(50), -- Loại dịch vụ được đánh giá (hotel, car, tour)
    rating INT, -- Đánh giá (1 - 5 sao)
    review TEXT, -- Nhận xét của khách hàng
    created_at DATETIME,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Bảng Quyền hạn
CREATE TABLE Authorities (
    authority_id VARCHAR(10) PRIMARY KEY,
    account_id VARCHAR(10),
    role VARCHAR(50),
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
);


-- Thêm dữ liệu vào bảng Accounts
INSERT INTO Accounts (account_id, username, email, password) VALUES 
('AC01', 'nguyenvana', 'nguyenvana@gmail.com', 'password123'),
('AC02', 'tranthib', 'tranthib@gmail.com', 'password123'),
('AC03', 'phamvanc', 'phamvanc@gmail.com', 'password123'),
('AC04', 'ledinhd', 'ledinhd@gmail.com', 'password123'),
('AC05', 'doanthihoang', 'doanthihoang@gmail.com', 'password123'),
('AC06', 'truongvanhung', 'truongvanhung@gmail.com', 'password123'),
('AC07', 'nguyenthithanh', 'nguyenthithanh@gmail.com', 'password123'),
('AC08', 'phamthutrang', 'phamthutrang@gmail.com', 'password123'),
('AC09', 'buituananh', 'buituananh@gmail.com', 'password123'),
('AC10', 'dangthiminh', 'dangthiminh@gmail.com', 'password123');



