from django.urls import reverse_lazy

from .models import Teacher


class BaseTeacherView():
    model = Teacher
    success_url = reverse_lazy("teacher_list")

class TeacherListView():
    pass
class TeacherCreateView():
    pass
class TeacherUpdateView():
    pass
class TeacherDeleteView():
    pass