from django.shortcuts import render
from django.views.generic import ListView,CreateView

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