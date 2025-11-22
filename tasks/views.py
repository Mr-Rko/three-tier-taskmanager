from django.shortcuts import render, get_object_or_404, redirect
from django.contrib.auth.decorators import login_required
from django.contrib.auth import login, authenticate
from django.contrib.auth.forms import AuthenticationForm, UserCreationForm
from django.contrib import messages
from django.http import JsonResponse
from django.utils import timezone
from .models import Task
from .forms import TaskForm

class TaskService:
    """Business logic layer for task operations"""
    
    @staticmethod
    def get_user_tasks(user, status_filter=None, priority_filter=None):
        """Get tasks with optional filtering"""
        tasks = Task.objects.filter(user=user)
        
        if status_filter:
            tasks = tasks.filter(status=status_filter)
        if priority_filter:
            tasks = tasks.filter(priority=priority_filter)
            
        return tasks
    
    @staticmethod
    def create_task(user, title, description, priority, due_date=None):
        """Create a new task with validation"""
        if not title.strip():
            raise ValueError("Task title cannot be empty")
            
        task = Task(
            user=user,
            title=title.strip(),
            description=description,
            priority=priority,
            due_date=due_date
        )
        task.save()
        return task
    
    @staticmethod
    def update_task_status(task_id, new_status, user):
        """Update task status with permission check"""
        task = get_object_or_404(Task, id=task_id, user=user)
        
        valid_statuses = dict(Task.STATUS_CHOICES).keys()
        if new_status not in valid_statuses:
            raise ValueError("Invalid status")
            
        task.status = new_status
        task.save()
        return task
    
    @staticmethod
    def get_task_stats(user):
        """Get statistics for user's tasks"""
        tasks = Task.objects.filter(user=user)
        total = tasks.count()
        completed = tasks.filter(status='completed').count()
        overdue = sum(1 for task in tasks if task.is_overdue())
        
        return {
            'total': total,
            'completed': completed,
            'pending': total - completed,
            'overdue': overdue,
        }

# Authentication Views
def custom_login(request):
    """Custom login view for regular users"""
    if request.user.is_authenticated:
        return redirect('tasks:task_list')
        
    if request.method == 'POST':
        form = AuthenticationForm(request, data=request.POST)
        if form.is_valid():
            username = form.cleaned_data.get('username')
            password = form.cleaned_data.get('password')
            user = authenticate(username=username, password=password)
            if user is not None:
                login(request, user)
                messages.success(request, f'Welcome back, {username}!')
                next_url = request.GET.get('next', 'tasks:task_list')
                return redirect(next_url)
        else:
            messages.error(request, 'Invalid username or password.')
    else:
        form = AuthenticationForm()
    
    return render(request, 'tasks/login.html', {'form': form})

def register(request):
    """User registration view"""
    if request.user.is_authenticated:
        return redirect('tasks:task_list')
        
    if request.method == 'POST':
        form = UserCreationForm(request.POST)
        if form.is_valid():
            user = form.save()
            login(request, user)
            messages.success(request, f'Account created successfully! Welcome, {user.username}!')
            return redirect('tasks:task_list')
    else:
        form = UserCreationForm()
    
    return render(request, 'tasks/register.html', {'form': form})

# Presentation Tier - Views
@login_required
def task_list(request):
    """Display list of tasks with filtering"""
    status_filter = request.GET.get('status')
    priority_filter = request.GET.get('priority')
    
    task_service = TaskService()
    tasks = task_service.get_user_tasks(
        request.user, 
        status_filter, 
        priority_filter
    )
    stats = task_service.get_task_stats(request.user)
    
    context = {
        'tasks': tasks,
        'stats': stats,
        'current_filters': {
            'status': status_filter,
            'priority': priority_filter,
        }
    }
    return render(request, 'tasks/task_list.html', context)

@login_required
def task_detail(request, task_id):
    """Display task details"""
    task = get_object_or_404(Task, id=task_id, user=request.user)
    context = {'task': task}
    return render(request, 'tasks/task_detail.html', context)

@login_required
def task_create(request):
    """Create a new task"""
    if request.method == 'POST':
        form = TaskForm(request.POST)
        if form.is_valid():
            task_service = TaskService()
            try:
                task = task_service.create_task(
                    user=request.user,
                    title=form.cleaned_data['title'],
                    description=form.cleaned_data['description'],
                    priority=form.cleaned_data['priority'],
                    due_date=form.cleaned_data['due_date']
                )
                messages.success(request, 'Task created successfully!')
                return redirect('tasks:task_list')
            except ValueError as e:
                messages.error(request, str(e))
    else:
        form = TaskForm()
    
    return render(request, 'tasks/task_form.html', {'form': form, 'action': 'Create'})

@login_required
def task_update(request, task_id):
    """Update an existing task"""
    task = get_object_or_404(Task, id=task_id, user=request.user)
    
    if request.method == 'POST':
        form = TaskForm(request.POST, instance=task)
        if form.is_valid():
            form.save()
            messages.success(request, 'Task updated successfully!')
            return redirect('tasks:task_list')
    else:
        form = TaskForm(instance=task)
    
    return render(request, 'tasks/task_form.html', {'form': form, 'action': 'Update'})

@login_required
def task_delete(request, task_id):
    """Delete a task"""
    task = get_object_or_404(Task, id=task_id, user=request.user)
    
    if request.method == 'POST':
        task.delete()
        messages.success(request, 'Task deleted successfully!')
        return redirect('tasks:task_list')
    
    return render(request, 'tasks/task_confirm_delete.html', {'task': task})

@login_required
def update_task_status_ajax(request, task_id):
    """AJAX endpoint for updating task status"""
    if request.method == 'POST' and request.headers.get('X-Requested-With') == 'XMLHttpRequest':
        new_status = request.POST.get('status')
        task_service = TaskService()
        
        try:
            task = task_service.update_task_status(task_id, new_status, request.user)
            return JsonResponse({'success': True, 'status': task.status})
        except (ValueError, Task.DoesNotExist) as e:
            return JsonResponse({'success': False, 'error': str(e)})
    
    return JsonResponse({'success': False, 'error': 'Invalid request'})