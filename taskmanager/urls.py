from django.contrib import admin
from django.urls import path, include
from django.shortcuts import redirect

app_name = 'tasks'  # <--- important for namespacing

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', lambda request: redirect('tasks:task_list')),  # Redirect root to task list
    path('tasks/', include('tasks.urls')),
]