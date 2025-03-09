from django.shortcuts import render
from django.views.generic import ListView, CreateView, UpdateView, DeleteView
from django.http import JsonResponse
from django.contrib.auth.models import User
from django.contrib.auth.hashers import make_password
from django.urls import reverse_lazy

from .models import Student
from .forms import StudentForm


# Create your views here.
class StudentListView(ListView):
    model = Student
    template_name = "students/student_list.html"
    context_object_name = "students"
    paginate_by = 10


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
