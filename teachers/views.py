from django.http import JsonResponse
from django.urls import reverse_lazy
from django.views.generic import ListView,CreateView, UpdateView,DeleteView

from teachers.forms import TeacherForm
from django.contrib.auth.models import User


from .models import Teacher


class BaseTeacherView():
    model = Teacher
    success_url = reverse_lazy("teacher_list")

class TeacherListView(BaseTeacherView,ListView):
    template_name = "teachers/teacher_list.html"
    context_object_name = "teachers"
    paginate_by = 10
    
class TeacherCreateView(BaseTeacherView,CreateView):
    form_class = TeacherForm
    template_name = "teachers/teacher_form.html"
    context_object_name = "teacher"
    
    def form_valid(self,form):
        # 从表单获取用户信息 
        teacher_name = form.cleaned_data.get('teacher_name') # 假设你的表单中有提供用户名
        phone_number = form.cleaned_data.get('phone_number') # 假设你的表单中有提供密码
        
        # 判断auth_user表中学生数据是否存在，不存在时，在auth_user表中创建用户
        # 写入到auth_user表
        username = teacher_name + "_" + phone_number
        password = phone_number[-6:]
        users = User.objects.filter(username=username)
        if users.exists():
            user = users.first()
        else:
            # 创建auth_user表记录
            user = User.objects.create_user(username=username, password=password)
            
        form.instance.user = user
        form.save()
        
         # 返回json响应
        return JsonResponse({"status": "success", "message": "操作成功"}, status=200)

class TeacherUpdateView(BaseTeacherView,UpdateView):
    pass
class TeacherDeleteView(BaseTeacherView,DeleteView):
    pass