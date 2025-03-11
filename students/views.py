import datetime
import json
from pathlib import Path
from io import BytesIO

from django.shortcuts import render
from django.views.generic import ListView, CreateView, UpdateView, DeleteView
from django.http import HttpResponse, JsonResponse
from django.contrib.auth.models import User
from django.contrib.auth.hashers import make_password
from django.urls import reverse_lazy
import openpyxl

from .models import Student
from grades.models import Grade
from .forms import StudentForm
from utils.handle_excel import ReadExcel


# Create your views here.
class StudentListView(ListView):
    model = Student
    template_name = "students/student_list.html"
    context_object_name = "students"
    paginate_by = 10
    
    def get_context_data(self):
        context = super().get_context_data()
        # 获取所有班级并添加到上下文
        context["grades"] = Grade.objects.all().order_by('grade_number')
        context['current_grade'] = self.request.GET.get('grade','')
        return context


class StudentCreateView(CreateView):
    model = Student
    template_name = "students/student_form.html"
    form_class = StudentForm

    def form_valid(self, form):
        # 表单字段验证
        student_name = form.cleaned_data.get("student_name")
        student_number = form.cleaned_data.get("student_number")
        # 写入到auth_user表
        username = student_name + "_" + student_number
        password = student_number[-6:]
        users = User.objects.filter(username=username)
        if users.exists():
            user = users.first()
        else:
            # 创建auth_user表记录
            user = User.objects.create_user(username=username, password=password)
        #  写入到student
        form.instance.user = user
        form.save()

        # 返回json响应
        return JsonResponse({"status": "success", "message": "操作成功"}, status=200)

    def form_invalid(self, form):
        errors = form.errors.as_json()
        return JsonResponse(
            {
                "status": "error",
                "message": errors,
            },
            status=400,
        )


class StudentUpdateView(UpdateView):
    model = Student
    template_name = "students/student_form.html"
    form_class = StudentForm

    def form_valid(self, form):
        # 获取学生对象实例
        student = form.save(commit=False)
        # 检查一个是否修改了student_name和student_number
        if "student_name" or "student_number" in form.changed_data:
            student.user.username = (
                form.cleaned_data.get("student_name")
                + "_"
                + form.cleaned_data.get("student_number")
            )
            student.user.password = make_password(
                form.cleaned_data.get("student_number")[-6:]
            )
            student.user.save()  # 保存更改的用户模型

        # 保存student模型
        student.save()

        # 返回json响应
        return JsonResponse({"status": "success", "message": "操作成功"}, status=200)

    def form_invalid(self, form):
        errors = form.errors.as_json()
        return JsonResponse(
            {
                "status": "error",
                "message": errors,
            },
            status=400,
        )


class StudentDeleteView(DeleteView):
    success_url = reverse_lazy("student_list")
    model = Student

    def delete(self, request, *args, **kwargs):
        self.object = self.get_object()

        try:
            self.object.delete()
            return JsonResponse(
                {"status": "success", "message": "删除成功"}, status=200
            )
        except Exception as e:
            return JsonResponse(
                {"status": "error", "message": "删除失败：" + str(e)}, status=500
            )


class StudentBulkDeleteView(DeleteView):
    model = Student
    success_url = reverse_lazy("student_list")

    def post(self, request, *args, **kwargs):
        selected_ids = request.POST.getlist("student_ids")
        if not selected_ids:
            return JsonResponse(
                {"status": "error", "message": "请选择要删除的学生"}, status=400
            )
        self.object_list = self.get_queryset().filter(id__in=selected_ids)
        try:
            self.object_list.delete()
            return JsonResponse(
                {"status": "success", "message": "删除成功"}, status=200
            )
        except Exception as e:
            return JsonResponse(
                {"status": "error", "message": "删除失败：" + str(e)}, status=500
            )

def upload_student(request):
    """上传学生信息excel"""
    if request.method == "POST":
        file = request.FILES.get("excel_file")
        # 判断文件是否上传
        if not file:
            return JsonResponse(
                {"status": "error", "message": "请选择要上传的文件"}, status=400
            )
        # 判断文件类型是否为excel
        ext = Path(file.name).suffix
        if ext.lower() != ".xlsx":
            return JsonResponse(
                {"status": "error", "message": "请选择正确的excel文件"}, status=400
            )
        # openpyxl 读取excel文件内容
        read_excel = ReadExcel(file)
        data = read_excel.get_data()
        if data[0] != [
            "班级",
            "姓名",
            "学号",
            "性别",
            "出生日期",
            "联系电话",
            "家庭住址",
        ]:
            return JsonResponse(
                {"status": "error", "message": "Excel中学生信息不是指定格式"},
                status=400,
            )
        # 写入到数据库
        for row in data[1:]:
            (
                grade,
                student_name,
                student_number,
                gender,
                birthday,
                contact_number,
                address,
            ) = row
            # 检查班级是否存在
            grade = Grade.objects.filter(grade_name=grade).first()
            if not grade:
                return JsonResponse(
                    {"status": "error", "message": f"{grade}不存在"}, status=400
                )
            # 检测主要字段
            if not student_name:
                return JsonResponse(
                    {"status": "error", "message": "学生姓名不能为空"}, status=400
                )
            if not student_number or len(student_number) != 9:
                return JsonResponse(
                    {"status": "error", "message": "学籍号不能为空且长度为9位"},
                    status=400,
                )
            # 检查日期格式
            if not isinstance(birthday, datetime.datetime):
                return JsonResponse(
                    {"status": "error", "message": "出生日期格式错误"}, status=400
                )
            # 判断学生信息是否存在
            if Student.objects.filter(student_number=student_number).exists():
                return JsonResponse(
                    {"status": "error", "message": f"{student_number}已存在"},
                    status=400,
                )

            # 写入到数据库中
            try:
                # 判断auth_user表中学生数据是否存在，不存在时，再auth_user表中创建用户
                username = student_name + "_" + student_number  # 拼接username
                users = User.objects.filter(username=username)
                if users.exists():
                    user = users.first()
                else:
                    password = student_number[-6:]
                    user = User.objects.create_user(
                        username=username, password=password
                    )
                # 在students表中创建记录
                Student.objects.create(
                    student_name=student_name,
                    student_number=student_number,
                    gender="M" if gender == "男" else "F",
                    birthday=birthday,
                    contact_number=contact_number,
                    address=address,
                    grade=grade,
                    user=user,
                )
            except:
                return JsonResponse(
                    {"status": "error", "message": "上传失败"}, status=500
                )
        
        # 全部写入成功后才提示上传成功
        return JsonResponse({"status": "success", "message": "上传成功"}, status=200)

def export_excel(request):
    if request.method == "POST":
        data = json.loads(request.body)
        grade_id = data.get("grade")
        # 判断grade_id是否存在
        if not grade_id:
            return JsonResponse({'status': 'error', 'message': '班级参数缺失'}, status=400)
        # 判断班级是否存在
        try:
            grade = Grade.objects.get(id=grade_id)
        except Grade.DoesNotExist:
            return JsonResponse({'status': 'error', 'message': '班级不存在'}, status=404)
        
        # 从数据库查询学生数据
        students = Student.objects.filter(grade=grade)
        if not students.exists():
            return JsonResponse({'status': 'error', 'message': '班级中没有学生'}, status=404)
        
        # 操作excel
        wb = openpyxl.Workbook()
        ws = wb.active
        # 添加标题行
        columns =  [
            "班级",
            "姓名",
            "学号",
            "性别",
            "出生日期",
            "联系电话",
            "家庭住址",
        ]
        ws.append(columns)
        for student in students:
            if student.gender == "M":
                student.gender = "男"
            else:
                student.gender = "女"
            ws.append([
                student.grade.grade_name,
                student.student_name,
                student.student_number,
                student.gender,
                student.birthday,
                student.contact_number,
                student.address,
            ])
        
        # 将excel数据保存到内存
        excel_file = BytesIO()
        wb.save(excel_file)
        wb.close()
        # 重置文件指针位置
        excel_file.seek(0)
        
        # 设置响应
        response = HttpResponse(excel_file.read(),content_type='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
        response['Content-Disposition'] = 'attachment; filename="students.xlsx"'
        return response