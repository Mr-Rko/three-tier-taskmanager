#!/bin/bash

echo "🚀 Starting Task Manager Setup..."
echo "================================="

# Stop any running containers
echo "🛑 Stopping any running containers..."
docker compose down

# Start MySQL
echo "🐬 Starting MySQL database..."
docker compose up -d mysql

echo "⏳ Waiting for MySQL to be ready..."
sleep 20
# Wait for MySQL to be fully ready
echo "✅ MySQL is ready!"

# Check if SQL file exists
if [ -f "database-setup.sql" ]; then
    echo "📦 Setting up database tables from SQL file..."
    # Execute the SQL file to create tables and insert sample data
    docker exec -i taskmanager-mysql mysql -hlocalhost -uroot -proot < setup_database.sql
    
    if [ $? -eq 0 ]; then
        echo "✅ Database tables created successfully!"
    else
        echo "❌ Failed to create database tables!"
        exit 1
    fi
else
    echo "⚠️  SQL file not found, continuing with Django migrations..."
fi

# Run Django migrations (they won't break anything if tables already exist)
echo "🔄 Running Django migrations..."
docker compose run --rm django_cont python manage.py migrate --noinput

# Collect static files
echo "📁 Collecting static files..."
docker compose run --rm django_cont python manage.py collectstatic --noinput

# Start all services
echo "🎯 Starting all services..."
docker compose up -d

echo ""
echo "================================="
echo "✅ Setup complete!"
echo "================================="
echo ""
echo "🌐 Your application is now running at:"
echo "   - Main App: http://localhost/tasks/"
echo "   - Admin Panel: http://localhost/admin/"
echo ""
echo "👤 Default users (if SQL was executed):"
echo "   - admin / admin123 (Administrator)"
echo "   - john / demo123 (Regular User)"
echo "   - jane / demo123 (Regular User)"
echo ""
echo "💡 You can also create new users at: http://localhost/tasks/register/"