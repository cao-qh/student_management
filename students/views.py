from django.shortcuts import render
from django.views.generic import ListView,CreateView
from django.http import JsonResponse
from django.contrib.auth.models import User

from .models import Student
from .forms import StudentForm

# Create your views here.
class StudentListView(ListView):
  model = Student
  template_name = 'students/student_list.html'
  context_object_name = 'students'
  paginate_by = 10
  
class StudentCreateView(CreateView):
  model = Student
  template_name = 'students/student_form.html'
  form_class = StudentForm
  
  def form_valid(self,form):
    # 表单字段验证
    student_name=form.cleaned_data.get('student_name')
    student_number=form.cleaned_data.get('student_number')
    # 写入到auth_user表
    username = student_name + '_' + student_number
    password = student_number[-6:]
    users = User.objects.filter(username=username)
    if(users.exists()):
      user = users.first()
    else:
      # 创建auth_user表记录
      user = User.objects.create_user(username=username,password=password)
    #  写入到student
    form.instance.user = user
    form.save()
    
    
    # 返回json响应
    return JsonResponse({
      'status':'success',
      'message':'操作成功'
    },status=200)
    
  def form_invalid(self,form):
    errors = form.errors.as_json()
    return JsonResponse({
      'status':'error',
      'message':errors,
    },status=400)