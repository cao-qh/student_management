from django import forms

from grades.models import Grade
from teachers.models import Teacher

GENDER_CHOICES = {
  ('M', '男'),
  ('F', '女')
}

class TeacherForm(forms.ModelForm):
    class Meta:
        model = Teacher
        fields = ['teacher_name','grade','phone_number','gender','birthday']
        
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.fields['grade'].queryset = Grade.objects.all()
        self.fields['grade'].empty_label = '请选择班级'
        self.fields['gender'].widget = forms.Select(choices=GENDER_CHOICES)
        
    def clean_phone_number(self):
        print(f"self.instance is {self.instance}")
        phone_number = self.cleaned_data.get('phone_number')
        if Teacher.objects.filter(phone_number=phone_number).exclude(pk=self.instance.pk).exists():
            raise forms.ValidationError('手机号已存在')
        return phone_number
    
    def clean_grade(self):
        grade = self.cleaned_data.get('grade')
        if Teacher.objects.filter(grade=grade).exclude(pk=self.instance.pk).exists():
            raise forms.ValidationError('班级已存在老师')
        return grade