# 🚀 Django Task Manager - 3-Tier Web Application

A complete 3-tier web application built with **Django**, **MySQL**, and **Nginx**, fully containerized with **Docker**. Includes a full task management system with authentication, filtering, and real-time updates.

---

## 🏗️ Architecture

| Tier             | Technology            | Purpose                             |
| ---------------- | --------------------- | ----------------------------------- |
| Web Tier         | **Nginx**             | Reverse proxy & static file serving |
| Application Tier | **Django + Gunicorn** | Business logic & API                |
| Data Tier        | **MySQL 8.0**         | Data persistence                    |

---

## ✨ Features

* ✅ **User Authentication** – Custom login/registration system
* ✅ **Task CRUD** – Create, read, update, delete tasks
* ✅ **Task Filtering** – By status and priority
* ✅ **Real-time Updates** – AJAX-based quick status updates
* ✅ **Responsive UI** – Clean Bootstrap 5 design
* ✅ **Statistics Dashboard** – Task insights and metrics
* ✅ **Fully Dockerized** – Zero manual setup

---

## 🛠️ Tech Stack

* **Backend:** Django 4.2.7, Python 3.11
* **Database:** MySQL 8.0
* **Web Server:** Nginx
* **WSGI Server:** Gunicorn
* **Containerization:** Docker & Docker Compose
* **Frontend:** Bootstrap 5, JavaScript

---

## 📦 Quick Start

### **Prerequisites**

* Docker
* Docker Compose

### **Installation**

#### 1. Clone the repository

```bash
git clone <your-repo-url>
cd taskmanager
```

#### 2. Run automated setup

```bash
chmod +x setup.sh
./setup.sh
```

#### Or run manually:

```bash
docker-compose up --build
```

### **Access the application**

* 🌐 Main App: **[http://localhost/tasks/](http://localhost/tasks/)**
* 🔐 Admin Panel: **[http://localhost/admin/](http://localhost/admin/)**

### **Default Accounts**

| Username | Password | Role          |
| -------- | -------- | ------------- |
| admin    | admin123 | Administrator |
| john     | demo123  | Regular User  |
| jane     | demo123  | Regular User  |

---

## 🗂️ Project Structure

```
taskmanager/
├── docker-compose.yml          # Multi-container setup
├── setup.sh                    # Automated setup script
├── database-setup.sql          # Database schema & sample data
├── .env                        # Environment variables
├── nginx/
│   ├── Dockerfile              # Nginx container
│   └── nginx.conf              # Nginx configuration
├── taskmanager/                # Django project
│   ├── settings.py             # Django settings
│   ├── urls.py                 # Project URLs
│   └── wsgi.py                 # WSGI configuration
└── tasks/                      # Django app
    ├── models.py               # Task model
    ├── views.py                # Business logic & views
    ├── forms.py                # Django forms
    ├── urls.py                 # App URLs
    ├── templates/              # HTML templates
    └── static/                 # CSS & JavaScript
```

---

## 🚀 Manual Setup (Advanced)

### 1. Create `.env`

```
DEBUG=True
SECRET_KEY=your-secret-key-here
DB_NAME=mydb
DB_USER=django_user
DB_PASSWORD=django_pass
DB_HOST=mysql
DB_PORT=3306
```

### 2. Initialize Database

```bash
docker exec -i taskmanager-mysql mysql -uroot -proot < database-setup.sql
```

### 3. Django Setup

```bash
docker-compose exec django_cont python manage.py migrate
docker-compose exec django_cont python manage.py collectstatic --noinput
docker-compose exec django_cont python manage.py createsuperuser
```

---

## 📊 API Endpoints

| Method | Endpoint                        | Description              |
| ------ | ------------------------------- | ------------------------ |
| GET    | /tasks/                         | Task list with filtering |
| POST   | /tasks/task/create/             | Create new task          |
| GET    | /tasks/task/<id>/               | Task details             |
| POST   | /tasks/task/<id>/update/        | Update task              |
| POST   | /tasks/task/<id>/delete/        | Delete task              |
| POST   | /tasks/task/<id>/update-status/ | AJAX status update       |

---

## 🎯 Task Features

* **Status:** Pending, In Progress, Completed
* **Priority:** Low, Medium, High
* **Due Dates:** Optional deadlines
* **Overdue Detection:** Highlights overdue tasks
* **User Isolation:** Users see only their tasks
* **Search & Filter:** Filter by status or priority

---

## 🤝 Contributing

Pull requests are welcome! Improve UI, add new features, or optimize performance.

---

## 📜 License

MIT License – Free to use and modify.

---

## 💬 Support

For bug reports or feature requests, open an issue on the repository.
