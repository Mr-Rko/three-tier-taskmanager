-- =============================================
-- Task Manager Database Setup
-- Complete SQL for Django Task Manager
-- =============================================

-- Create database and user
CREATE DATABASE IF NOT EXISTS mydb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'django_user'@'%' IDENTIFIED BY 'django_pass';
GRANT ALL PRIVILEGES ON mydb.* TO 'django_user'@'%';
FLUSH PRIVILEGES;

USE mydb;

-- =============================================
-- Django Core Tables
-- =============================================

-- Django content types
CREATE TABLE IF NOT EXISTS django_content_type (
    id INT AUTO_INCREMENT PRIMARY KEY,
    app_label VARCHAR(100) NOT NULL,
    model VARCHAR(100) NOT NULL,
    UNIQUE KEY (app_label, model)
);

-- Django auth groups
CREATE TABLE IF NOT EXISTS auth_group (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL UNIQUE
);

-- Django users
CREATE TABLE IF NOT EXISTS auth_user (
    id INT AUTO_INCREMENT PRIMARY KEY,
    password VARCHAR(128) NOT NULL,
    last_login DATETIME(6) NULL,
    is_superuser TINYINT(1) NOT NULL,
    username VARCHAR(150) NOT NULL UNIQUE,
    first_name VARCHAR(150) NOT NULL,
    last_name VARCHAR(150) NOT NULL,
    email VARCHAR(254) NOT NULL,
    is_staff TINYINT(1) NOT NULL,
    is_active TINYINT(1) NOT NULL,
    date_joined DATETIME(6) NOT NULL
);

-- Django permissions
CREATE TABLE IF NOT EXISTS auth_permission (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    content_type_id INT NOT NULL,
    codename VARCHAR(100) NOT NULL,
    UNIQUE KEY (content_type_id, codename)
);

-- User-group relationships
CREATE TABLE IF NOT EXISTS auth_user_groups (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    group_id INT NOT NULL
);

-- User permissions
CREATE TABLE IF NOT EXISTS auth_user_user_permissions (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    permission_id INT NOT NULL
);

-- Group permissions
CREATE TABLE IF NOT EXISTS auth_group_permissions (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    group_id INT NOT NULL,
    permission_id INT NOT NULL
);

-- Django sessions
CREATE TABLE IF NOT EXISTS django_session (
    session_key VARCHAR(40) NOT NULL PRIMARY KEY,
    session_data LONGTEXT NOT NULL,
    expire_date DATETIME(6) NOT NULL,
    KEY (expire_date)
);

-- Django admin log
CREATE TABLE IF NOT EXISTS django_admin_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    action_time DATETIME(6) NOT NULL,
    object_id LONGTEXT NULL,
    object_repr VARCHAR(200) NOT NULL,
    action_flag SMALLINT UNSIGNED NOT NULL,
    change_message LONGTEXT NOT NULL,
    content_type_id INT NULL,
    user_id INT NOT NULL,
    KEY (action_time),
    KEY (content_type_id),
    KEY (user_id)
);

-- Django migrations
CREATE TABLE IF NOT EXISTS django_migrations (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    app VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    applied DATETIME(6) NOT NULL
);

-- =============================================
-- Task Manager Custom Tables
-- =============================================

-- Tasks table
CREATE TABLE IF NOT EXISTS tasks_task (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description LONGTEXT NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    priority VARCHAR(20) NOT NULL DEFAULT 'medium',
    due_date DATETIME(6) NULL,
    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,
    user_id INT NOT NULL,
    KEY (user_id),
    KEY (status),
    KEY (priority),
    KEY (due_date),
    KEY (created_at)
);

-- =============================================
-- Indexes for Performance
-- =============================================

CREATE INDEX IF NOT EXISTS auth_user_username_idx ON auth_user(username);
CREATE INDEX IF NOT EXISTS auth_permission_content_type_id_idx ON auth_permission(content_type_id);
CREATE INDEX IF NOT EXISTS django_session_expire_date_idx ON django_session(expire_date);
CREATE INDEX IF NOT EXISTS django_admin_log_content_type_id_idx ON django_admin_log(content_type_id);
CREATE INDEX IF NOT EXISTS django_admin_log_user_id_idx ON django_admin_log(user_id);
CREATE INDEX IF NOT EXISTS tasks_task_user_id_idx ON tasks_task(user_id);
CREATE INDEX IF NOT EXISTS tasks_task_status_idx ON tasks_task(status);
CREATE INDEX IF NOT EXISTS tasks_task_priority_idx ON tasks_task(priority);
CREATE INDEX IF NOT EXISTS tasks_task_due_date_idx ON tasks_task(due_date);
CREATE INDEX IF NOT EXISTS tasks_task_created_at_idx ON tasks_task(created_at);

-- =============================================
-- Sample Data
-- =============================================

-- Insert default admin user (password: admin123)
INSERT IGNORE INTO auth_user (
    id, password, is_superuser, username, first_name, last_name, email, 
    is_staff, is_active, date_joined
) VALUES (
    1, 
    'pbkdf2_sha256$600000$abc123$hashedpasswordforadmin123=', 
    1, 'admin', 'System', 'Administrator', 'admin@taskmanager.com', 
    1, 1, NOW()
);

-- Insert demo users (password: demo123)
INSERT IGNORE INTO auth_user (
    id, password, is_superuser, username, first_name, last_name, email, 
    is_staff, is_active, date_joined
) VALUES 
(
    2, 
    'pbkdf2_sha256$600000$def456$hashedpasswordfordemo123=', 
    0, 'john', 'John', 'Doe', 'john@example.com', 
    0, 1, NOW()
),
(
    3, 
    'pbkdf2_sha256$600000$ghi789$hashedpasswordfordemo123=', 
    0, 'jane', 'Jane', 'Smith', 'jane@example.com', 
    0, 1, NOW()
);

-- Insert sample tasks
INSERT IGNORE INTO tasks_task (title, description, status, priority, due_date, created_at, updated_at, user_id) VALUES
('Complete project proposal', 'Finish the project proposal document and send for review', 'pending', 'high', DATE_ADD(NOW(), INTERVAL 7 DAY), NOW(), NOW(), 2),
('Buy groceries', 'Milk, eggs, bread, and fruits', 'completed', 'medium', DATE_ADD(NOW(), INTERVAL 1 DAY), NOW(), NOW(), 2),
('Schedule team meeting', 'Coordinate with team members for weekly sync', 'in_progress', 'medium', DATE_ADD(NOW(), INTERVAL 3 DAY), NOW(), NOW(), 3),
('Learn Django', 'Study Django models and views', 'pending', 'low', NULL, NOW(), NOW(), 3),
('Deploy application', 'Deploy the task manager app to production', 'pending', 'high', DATE_ADD(NOW(), INTERVAL 14 DAY), NOW(), NOW(), 1),
('Write documentation', 'Create user guide and API documentation', 'pending', 'medium', DATE_ADD(NOW(), INTERVAL 5 DAY), NOW(), NOW(), 2),
('Fix bug in login', 'Resolve the authentication issue reported by users', 'in_progress', 'high', DATE_ADD(NOW(), INTERVAL 2 DAY), NOW(), NOW(), 1);

-- =============================================
-- Verification Queries
-- =============================================

SELECT 'Database setup completed successfully!' as status;
SELECT COUNT(*) as user_count FROM auth_user;
SELECT COUNT(*) as task_count FROM tasks_task;