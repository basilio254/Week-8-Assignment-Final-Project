**📦 Basitech Shop Database (MySQL)
**
A professional relational database schema for Basitech Shop, an e-commerce system built on MySQL 8.0+.
This project demonstrates real-world database design with proper normalization, constraints, and relationships.

🚀 Features

Well-structured schema for e-commerce.

Constraints: PRIMARY KEY, FOREIGN KEY, UNIQUE, NOT NULL, CHECK.

Relationships:

One-to-One → orders ↔ payments

One-to-Many → orders → order_items, users → orders

Many-to-Many → products ↔ categories, users ↔ roles

Electronics sample products with inventory setup.

Includes a view (vw_product_stock) to quickly check product availability.

📂 Database Structure
Core Tables

users → Stores customer and admin accounts.

roles + user_roles → Role-based access control.

products, categories, product_categories → Product catalog with categories.

inventory → Tracks product stock.

orders, order_items → Customer orders and their items.

payments → One-to-one payments linked to orders.

shipments → Tracks delivery progress.

reviews → Customer reviews and ratings.

Relationships

One-to-Many:

One user can place many orders.

One order has many order items.

Many-to-Many:

Products can belong to multiple categories.

Users can have multiple roles.

One-to-One:

Each order has exactly one payment.

🛠️ Installation
Prerequisites

MySQL 8.0+ installed locally or on a server.

A MySQL user with CREATE DATABASE and CREATE TABLE privileges.

Steps

Clone or download this repository.

Open your MySQL client (Workbench, CLI, or DBeaver).

Run the SQL file:

mysql -u <your_username> -p < ecommerce_store_schema.sql


Verify the database:

SHOW DATABASES;
USE basitech_shop;
SHOW TABLES;

📊 Sample Data

This schema includes Electronics products with stock levels:

Dell Laptop (10 in stock)

Samsung Galaxy S23 (25 in stock)

Logitech Wireless Mouse (50 in stock)

Apple iPad 10th Gen (15 in stock)

Sony WH-1000XM5 Headphones (20 in stock)

🔍 Useful Queries

Check available products and stock:

SELECT * FROM vw_product_stock;


View orders with customer details:

SELECT o.order_id, u.first_name, u.last_name, o.status, o.total_amount
FROM orders o
JOIN users u ON o.user_id = u.user_id;

📖 Author

Basitech Agency
Designed for learning and professional e-commerce database implementation.
