import datetime

from django import forms
from django.core.exceptions import ValidationError

from .models import Student
from grades.models import Grade

class StudentForm(forms.ModelForm):
  def __init__(self,*args,**kwargs):
    super().__init__(*args,**kwargs)
    self.fields.get('grade').queryset=Grade.objects.all().order_by('grade_number')
  
  def clean_student_name(self):
    student_name = self.cleaned_data.get('student_name')
    if len(student_name) < 2  or  len(student_name) > 50: 
      raise ValidationError('请填写正确的学生姓名')  
    return student_name
   
  def clean_student_number(self):
    student_number = self.cleaned_data.get('student_number')
    if len(student_number) != 9:
      raise ValidationError('学号长度应为9位。')
    return student_number
  
  def clean_birthday(self):
    birthday = self.cleaned_data.get('birthday')
    if not isinstance(birthday,datetime.date):
      raise ValidationError('生日格式错误，正确格式例如：2020-05-01')
    if birthday > datetime.date.today():
      raise ValidationError('生日不能大于今天')
    return birthday
  
  def clean_contact_number(self):
    contact_number = self.cleaned_data.get('contact_number')
    if len(contact_number) != 11:
      raise ValidationError('手机号长度应为11位。')
    return contact_number
  
  class Meta:
    model = Student
    fields = ['student_name','student_number','grade','gender','birthday','contact_number','address']