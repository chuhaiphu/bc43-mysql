CREATE DATABASE food_ordering_system;
USE food_ordering_system;

CREATE TABLE user (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(255),
    email VARCHAR(255),
    password VARCHAR(255)
);

CREATE TABLE restaurant (
    res_id INT PRIMARY KEY AUTO_INCREMENT,
    res_name VARCHAR(255),
    image VARCHAR(255),
    `desc` VARCHAR(255)
);

CREATE TABLE food_type (
    type_id INT PRIMARY KEY AUTO_INCREMENT,
    type_name VARCHAR(255)
);

CREATE TABLE food (
    food_id INT PRIMARY KEY AUTO_INCREMENT,
    food_name VARCHAR(255),
    image VARCHAR(255),
    price FLOAT,
    `desc` VARCHAR(255),
    type_id INT,
    FOREIGN KEY (type_id) REFERENCES food_type(type_id)
);

CREATE TABLE sub_food (
    sub_id INT PRIMARY KEY AUTO_INCREMENT,
    sub_name VARCHAR(255),
    sub_price FLOAT,
    food_id INT,
    FOREIGN KEY (food_id) REFERENCES food(food_id)
);

CREATE TABLE `order` (
    user_id INT,
    food_id INT,
    amount INT,
    code VARCHAR(255),
    arr_sub_id VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (food_id) REFERENCES food(food_id)
);

CREATE TABLE rate_res (
    user_id INT,
    res_id INT,
    amount INT,
    date_rate DATETIME,
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (res_id) REFERENCES restaurant(res_id)
);

CREATE TABLE like_res (
    user_id INT,
    res_id INT,
    date_like DATETIME,
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (res_id) REFERENCES restaurant(res_id)
);

-- 1. Tìm 5 người đã like nhà hàng nhiều nhất
SELECT u.user_id, u.full_name, COUNT(*) as like_count
FROM user u
JOIN like_res lr ON u.user_id = lr.user_id
GROUP BY u.user_id, u.full_name
ORDER BY like_count DESC
LIMIT 5;

-- 2. Tìm 2 nhà hàng có lượt like nhiều nhất
SELECT r.res_id, r.res_name, COUNT(*) as like_count
FROM restaurant r
JOIN like_res lr ON r.res_id = lr.res_id
GROUP BY r.res_id, r.res_name
ORDER BY like_count DESC
LIMIT 2;

-- 3. Tìm người đã đặt hàng nhiều nhất
SELECT u.user_id, u.full_name, COUNT(*) as order_count
FROM user u
JOIN `order` o ON u.user_id = o.user_id
GROUP BY u.user_id, u.full_name
ORDER BY order_count DESC
LIMIT 1;

-- 4. Tìm người dùng không hoạt động trong hệ thống (không đặt hàng, không like, không đánh giá nhà hàng)
SELECT u.user_id, u.full_name
FROM user u
LEFT JOIN `order` o ON u.user_id = o.user_id
LEFT JOIN like_res lr ON u.user_id = lr.user_id
LEFT JOIN rate_res rr ON u.user_id = rr.user_id
WHERE o.user_id IS NULL AND lr.user_id IS NULL AND rr.user_id IS NULL;


-- Sample data for user table
INSERT INTO user (full_name, email, password) VALUES
('John Doe', 'john@example.com', 'password123'),
('Jane Smith', 'jane@example.com', 'securepass'),
('Mike Johnson', 'mike@example.com', 'mikepass'),
('Alice Brown', 'alice@example.com', 'alicepass'),
('Bob Wilson', 'bob@example.com', 'bobpass'),
('Eve Davis', 'eve@example.com', 'evepass');

-- Sample data for restaurant table
INSERT INTO restaurant (res_name, image, `desc`) VALUES
('Tasty Bites', 'tasty_bites.jpg', 'Delicious comfort food'),
('Sushi Haven', 'sushi_haven.jpg', 'Fresh and authentic sushi'),
('Pizza Palace', 'pizza_palace.jpg', 'Gourmet pizzas and Italian cuisine'),
('Burger Joint', 'burger_joint.jpg', 'Best burgers in town');

-- Sample data for food_type table
INSERT INTO food_type (type_name) VALUES
('Italian'),
('Japanese'),
('American'),
('Mexican');
USE food_ordering_system;

INSERT INTO food (food_name, image, price, `desc`, type_id) VALUES
('Margherita Pizza', 'margherita.jpg', 12.99, 'Classic cheese and tomato pizza', 1),
('California Roll', 'california_roll.jpg', 8.99, 'Crab, avocado, and cucumber roll', 2),
('Cheeseburger', 'cheeseburger.jpg', 9.99, 'Juicy beef patty with cheese', 3),
('Tacos', 'tacos.jpg', 10.99, 'Authentic Mexican tacos', 4);

-- Sample data for sub_food table
INSERT INTO sub_food (sub_name, sub_price, food_id) VALUES
('Extra Cheese', 1.50, 1),
('Gluten-free Crust', 2.00, 1),
('Spicy Mayo', 0.75, 2),
('Extra Patty', 2.50, 3);

-- Sample data for order table
INSERT INTO `order` (user_id, food_id, amount, code, arr_sub_id) VALUES
(1, 1, 2, 'ORDER001', '1,2'),
(2, 2, 1, 'ORDER002', '3'),
(3, 3, 1, 'ORDER003', NULL),
(1, 4, 3, 'ORDER004', NULL),
(1, 2, 2, 'ORDER005', '3'),
(2, 1, 1, 'ORDER006', '1');

-- Sample data for rate_res table
INSERT INTO rate_res (user_id, res_id, amount, date_rate) VALUES
(1, 1, 5, '2023-05-15 18:30:00'),
(2, 2, 4, '2023-05-16 19:45:00'),
(3, 3, 3, '2023-05-17 20:15:00'),
(1, 2, 5, '2023-05-18 12:30:00'),
(2, 1, 4, '2023-05-19 14:45:00');

-- Sample data for like_res table
INSERT INTO like_res (user_id, res_id, date_like) VALUES
(1, 2, '2023-05-14 12:00:00'),
(2, 1, '2023-05-15 14:30:00'),
(3, 2, '2023-05-16 16:45:00'),
(1, 1, '2023-05-17 18:00:00'),
(1, 3, '2023-05-18 20:15:00'),
(2, 2, '2023-05-19 22:30:00'),
(4, 1, '2023-05-20 10:45:00'),
(5, 2, '2023-05-21 13:00:00');
