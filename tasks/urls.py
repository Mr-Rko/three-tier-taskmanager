from django.urls import path
from django.contrib.auth import views as auth_views
from . import views

app_name = 'tasks'

urlpatterns = [
    # Authentication URLs
    path('login/', views.custom_login, name='login'),
    path('register/', views.register, name='register'),
    path('logout/', auth_views.LogoutView.as_view(next_page='tasks:login'), name='logout'),
    
    # Task URLs
    path('', views.task_list, name='task_list'),
    path('task/create/', views.task_create, name='task_create'),
    path('task/<int:task_id>/', views.task_detail, name='task_detail'),
    path('task/<int:task_id>/update/', views.task_update, name='task_update'),
    path('task/<int:task_id>/delete/', views.task_delete, name='task_delete'),
    path('task/<int:task_id>/update-status/', views.update_task_status_ajax, name='update_task_status'),
]