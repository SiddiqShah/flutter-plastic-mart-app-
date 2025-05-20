# Plastic Mart Flutter Project with MySQL Database Integration (via XAMPP)

## Overview

This project is a sample shop UI built with Flutter, now extended to support persistent storing and fetching of product selection details using a MySQL database through XAMPP (with PHP as backend API). Works perfectly on Chrome (Flutter Web).

---

## Prerequisites

- **Flutter** (latest stable)
- **XAMPP** (with Apache & MySQL)
- **PHP** (comes with XAMPP)
- **Flutter dependencies:**  
  - `http` for API calls

---

## Database Setup (MySQL via XAMPP)

1. **Start XAMPP:**  
   - Run Apache and MySQL modules.

2. **Create Database & Table:**  
   - Open [http://localhost/phpmyadmin](http://localhost/phpmyadmin)
   - Run the following SQL queries in the SQL window:

```sql
CREATE DATABASE IF NOT EXISTS plasticmart_db;
USE plasticmart_db;

CREATE TABLE IF NOT EXISTS selected_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product VARCHAR(255) NOT NULL,
    quality VARCHAR(50) NOT NULL,
    quantity VARCHAR(50) NOT NULL,
    price_per_dozen DOUBLE NOT NULL,
    total_price DOUBLE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

## Backend API Setup (PHP)

1. **Create a folder called `plasticmart_api` in `C:\xampp\htdocs\`**
2. **Add the provided PHP files (`config.php`, `add_item.php`, `get_items.php`, `delete_item.php`, `update_item.php`)**

---

## Flutter App Setup

1. **Clone/copy the provided Flutter project files.**
2. **Run `flutter pub get` to fetch dependencies.**
3. **Update the API base URL in `api_service.dart` if your XAMPP is running on a different machine or port.**
4. **Run the app:**
   ```
   flutter run -d chrome
   ```

---

## Folder Structure

- `lib/`
  - `main.dart`
  - `login_screen.dart`
  - `home_screen.dart`
  - `bathroom_essentials_screen.dart`
  - `kitchenware.dart`
  - `cleaning_tools.dart`
  - `sanitary_items.dart`
  - `api_service.dart`
- `plasticmart_api/` (in XAMPP `htdocs/`)
  - `config.php`
  - `add_item.php`
  - `get_items.php`
  - `delete_item.php`
  - `update_item.php`

---

## Usage

- Select product, size, and quantity, then click "Add to Table".
- Item is saved to MySQL database.
- Table always reflects the latest DB state.

---

## Troubleshooting

- If you see CORS errors, add CORS headers in your PHP files (`header("Access-Control-Allow-Origin: *");`).
- If Flutter cannot connect to localhost, use your local IP address.
- Make sure XAMPP's Apache and MySQL are running.

---

## Security

This is a basic educational sample. In production, use proper authentication and input validation.

---
