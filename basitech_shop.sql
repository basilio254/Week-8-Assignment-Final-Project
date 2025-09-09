/******************************************************************************
 BASETECH SHOP DATABASE SCHEMA (MySQL 8.0+)
 Author: Basitech Agency
*******************************************************************************/

/* Step 1: Create database */
CREATE DATABASE IF NOT EXISTS `basitech_shop`
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_0900_ai_ci;
USE `basitech_shop`;

/* Step 2: Roles & Users */
CREATE TABLE roles (
  role_id INT AUTO_INCREMENT PRIMARY KEY,
  role_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE users (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(255) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE user_roles (
  user_id INT NOT NULL,
  role_id INT NOT NULL,
  PRIMARY KEY (user_id, role_id),
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
  FOREIGN KEY (role_id) REFERENCES roles(role_id) ON DELETE CASCADE
);

/* Step 3: Products & Categories */
CREATE TABLE categories (
  category_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE products (
  product_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  sku VARCHAR(64) NOT NULL UNIQUE,
  description TEXT,
  price DECIMAL(10,2) NOT NULL,
  status ENUM('ACTIVE','INACTIVE') DEFAULT 'ACTIVE'
);

CREATE TABLE product_categories (
  product_id INT NOT NULL,
  category_id INT NOT NULL,
  PRIMARY KEY (product_id, category_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
  FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE CASCADE
);

/* Step 4: Inventory */
CREATE TABLE inventory (
  product_id INT NOT NULL,
  quantity INT NOT NULL DEFAULT 0,
  PRIMARY KEY (product_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

/* Step 5: Orders & Items */
CREATE TABLE orders (
  order_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  status ENUM('PENDING','PAID','SHIPPED','DELIVERED','CANCELLED') DEFAULT 'PENDING',
  total_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE RESTRICT
);

CREATE TABLE order_items (
  order_item_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  order_id BIGINT NOT NULL,
  product_id INT NOT NULL,
  quantity INT NOT NULL,
  unit_price DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE RESTRICT
);

/* Step 6: Payments & Shipments */
CREATE TABLE payments (
  payment_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  order_id BIGINT NOT NULL UNIQUE,
  method ENUM('CARD','MOBILE_MONEY','CASH_ON_DELIVERY') NOT NULL,
  status ENUM('PENDING','PAID','FAILED') DEFAULT 'PENDING',
  amount DECIMAL(12,2) NOT NULL,
  FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
);

CREATE TABLE shipments (
  shipment_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  order_id BIGINT NOT NULL,
  tracking_number VARCHAR(100) UNIQUE,
  status ENUM('PENDING','IN_TRANSIT','DELIVERED','RETURNED') DEFAULT 'PENDING',
  FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
);

/* Step 7: Reviews */
CREATE TABLE reviews (
  review_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  product_id INT NOT NULL,
  user_id INT NOT NULL,
  rating TINYINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
  review_text TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_review (product_id, user_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

/* Step 8: Helpful View */
CREATE OR REPLACE VIEW vw_product_stock AS
SELECT p.product_id, p.name, COALESCE(i.quantity,0) AS stock
FROM products p
LEFT JOIN inventory i ON p.product_id = i.product_id;
