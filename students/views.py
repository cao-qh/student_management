import datetime
from pathlib import Path
import json

from io import BytesIO

from django.shortcuts import render
from django.views.generic import ListView, CreateView, UpdateView, DeleteView
from django.http import JsonResponse, HttpResponse
from django.contrib.auth.models import User
from django.contrib.auth.hashers import make_password
from django.urls import reverse_lazy
from django.db.models import Q

import openpyxl

from .models import Student
from grades.models import Grade
from .forms import StudentForm
from utils.handle_excel import ReadExcel
from utils.permissions import RoleRequiredMixin, role_required


# Create your views here.
class BaseStudentView(RoleRequiredMixin):
    model = Student
    context_object_name = 'students'
    allowed_roles = ['admin', 'teacher']
    form_class = StudentForm
    success_url = reverse_lazy('student_list')

class StudentListView(BaseStudentView, ListView):
    template_name = 'students/students_list.html'
    paginate_by = 10

    def get_queryset(self):
        queryset = super().get_queryset()
        grade_id = self.request.GET.get('grade') # 获取班级
        keyword = self.request.GET.get('search') # 获取搜索的内容
        if grade_id:
            queryset = queryset.filter(grade__pk=grade_id)
        if keyword:
            queryset = queryset.filter(
                Q(student_number=keyword) |
                Q(student_name=keyword)
            )
        return queryset

    def get_context_data(self):
        context = super().get_context_data()
        # 获取所有班级并添加到上下文
        context['grades'] = Grade.objects.all().order_by('grade_number')
        context['current_grade'] = self.request.GET.get('grade', '')
        return context


class StudentCreateView(BaseStudentView, CreateView):
    template_name = 'students/student_form.html'
    

    def form_valid(self, form):
        # 接受字段
        student_name = form.cleaned_data.get('student_name')
        student_number = form.cleaned_data.get('student_number')
        # 写入到auth_user表
        username = student_name + '_' + student_number
        password = student_number[-6:]
        users = User.objects.filter(username=username)
        if users.exists():
            user = users.first()
        else:
            # 创建auth_user表记录
            user = User.objects.create_user(username=username, password=password)
        # 写入到student
        form.instance.user = user
        form.save()

        # 返回json响应
        return JsonResponse({
            'status': 'success',
            'messages': '操作成功'
        }, status=200)
    
    def form_invalid(self, form):
        errors = form.errors.as_json()
        return JsonResponse({
            'status': 'error',
            'messages': errors
        }, status=400)
   

class StudentUpdateView(BaseStudentView, UpdateView):
    template_name = 'students/student_form.html'

    def form_valid(self, form):
        # 获取学生对象实例
        student = form.save(commit=False)
        # 检查一下是否修改了student_name和student_nubmer
        if 'student_name' or 'student_number' in form.changed_data:
            student.user.username = form.cleaned_data.get('student_name') + '_' + form.cleaned_data.get('student_number')
            student.user.password = make_password(form.cleaned_data.get('student_number')[-6:])
            student.user.save() # 保存更改的用户模型

        # 保存student模型
        student.save() 
        # 返回json响应
        return JsonResponse({
            'status': 'success',
            'messages': '操作成功'
        }, status=200)



    def form_invalid(self, form):
        errors = form.errors.as_json()
        return JsonResponse({
            'status': 'error',
            'messages': errors
        }, status=400)
    

class StudentDeleteView(BaseStudentView, DeleteView):

    def delete(self, requst, *args, **kwargs):
        self.object = self.get_object()
        try:
            self.object.delete()
            return JsonResponse({
                'status': 'success',
                'messages': '删除成功'
            }, status=200)
        except Exception as e:
            return JsonResponse({
                'status': 'error',
                'messages': '删除失败:' + str(e)
            }, stauts=500)


class StudentBulkDeleteView(BaseStudentView, DeleteView):

    def post(self, requst, *args, **kwargs):
        selected_ids = requst.POST.getlist('student_ids')
        if not selected_ids:
            return JsonResponse({
                'status': 'error',
                'messages': '请选择要删除的学生'
            }, status=400)
        
        self.object_list = self.get_queryset().filter(id__in=selected_ids)
        try:
            self.object_list.delete()
            return JsonResponse({
                'status': 'success',
                'messages': '删除成功'
            })
        except Exception as e:
            return JsonResponse({
                'status': 'error',
                'messages': '删除失败'
            }, status=400)

@role_required('admin', 'teacher')     
def upload_student(request):
    """上传学生信息excel"""
    if request.method == 'POST':
        file = request.FILES.get('excel_file')
        print(f"file is {file}")
        # 判断文件是否上传
        if not file:
            return JsonResponse({
                'status': 'error',
                'messages': '请上传excel文件'
            }, status=400)
        # 判断文件类型是否为excel
        ext = Path(file.name).suffix
        if ext.lower() != '.xlsx':
            return JsonResponse({
                'status': 'error',
                'messages': '文件类型错误，请上传.xlsx格式的文件'
            }, status=400)
        # openpyxl 读取excel文件内容
        read_excle = ReadExcel(file)
        data = read_excle.get_data() # [[],[],[],]

        if data[0] != ['班级', '姓名', '学号', '性别', '出生日期', '联系电话', '家庭住址']:
            return JsonResponse({
                'status': 'error',
                'messages': 'Excel中学生信息不是指定格式'
            })
        # 写入到数据库
        for row in data[1:]:
            grade, student_name, student_number, gender, birthday, contact_number, address = row 
            # 检查班级是否存在
            grade = Grade.objects.filter(grade_name=grade).first()
            if not grade:
                return JsonResponse({
                    'status': 'error',
                    'messages': f'{grade} 不存在'
                }, status=400)
            # 检测主要字段
            if not student_name:
                return JsonResponse({'status': 'error', 'messages': '学生姓名不能为空'}, status=400)
            if not student_number or len(student_number) != 19:
                return JsonResponse({'status': 'error', 'messages': '学籍号不能为空，并且长度应为19位'}, status=400)
            # 检查日期格式
            if not isinstance(birthday, datetime.datetime) :
                return JsonResponse({'status': 'error', 'messages': '出生日期格式错误'}, status=400)
            # 判断学生信息是否存在
            if Student.objects.filter(student_number=student_number).exists():
                return JsonResponse({'status': 'error', 'messages': f'学号{student_number}已经存在'}, status=400)
            

            
            # 写入到数据库中
            try:
                # 判断auth_user表中学生数据是否存在，不存在时，在auth_user表中创建用户
                username = student_name + '_' + student_number # 拼接username
                users = User.objects.filter(username=username)
                if users.exists():
                    user = users.first()
                else:
                    password = student_number[-6:]
                    user = User.objects.create_user(username=username, password=password)
                # 在student表中创建记录
                Student.objects.create(
                    student_name = student_name, 
                    student_number = student_number,
                    grade = grade,
                    gender = 'M' if gender == '男' else 'F',
                    birthday = birthday,
                    contact_number = contact_number,
                    address = address,
                    user = user
                )
            except:
                return JsonResponse({'status': 'error', 'messages': '上传失败'}, status=500)
        # 全部写入成功后才提示上传成功
        return JsonResponse({
            'status': 'success',
            'messages': '上传成功'
        }, status=200)
    
@role_required('admin', 'teacher')     
def export_excel(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        grade_id = data.get('grade')
        # 判断grade_id是否存在
        if not grade_id:
            return JsonResponse({'status': 'error', 'messages': '班级参数缺失'}, status=400)
        # 判断班级是否存在
        try:
            grade = Grade.objects.get(id=grade_id)
        except Grade.DoesNotExist:
            return JsonResponse({'status': 'error', 'messages': '班级不存在'}, status=404)
        
        # 从数据库查询学生数据
        students = Student.objects.filter(grade=grade)
        if not students.exists():
            return JsonResponse({'status': 'error', 'messages': '找不到指定班级的学生信息'}, status=404)
        
        # 操作excel
        wb = openpyxl.Workbook()
        ws = wb.active
        # 添加标题行
        columns = ['班级', '姓名', '学号', '性别', '出生日期', '联系电话', '家庭住址']
        ws.append(columns)
        for student in students:
            if student.gender == 'M':
                student.gender = '男'
            else:
                student.gender = '女'
            ws.append([student.grade.grade_name, student.student_name, student.student_number, student.gender, student.birthday, student.contact_number, student.address])

        # 将excel数据保存到内存
        excel_file = BytesIO()
        wb.save(excel_file)
        wb.close()
        # 重置文件指针位置
        excel_file.seek(0)

        # 设置响应
        response = HttpResponse(excel_file.read(), content_type='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
        response['Content-Disposition'] = 'attachment; filename="students.xlsx"'
        return response
