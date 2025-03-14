from django.db import models

from students.models import Grade

# Create your models here.
class Score(models.Model):
    title = models.CharField(max_length=20, help_text='title/考试名称', verbose_name='考试名称')
    student_number = models.CharField(max_length=20, verbose_name='学号')
    student_name = models.CharField(max_length=20, help_text='name/姓名', verbose_name='姓名')
    chinese_score = models.DecimalField(max_digits=5, decimal_places=2, help_text='score/语文成绩', verbose_name='语文成绩')
    math_score = models.DecimalField(max_digits=5, decimal_places=2, help_text='score/数学成绩', verbose_name='数学成绩')
    english_score = models.DecimalField(max_digits=5, decimal_places=2, help_text='score/英语成绩', verbose_name='英语成绩')
    # 班级表一对多关联
    grade = models.ForeignKey(Grade, on_delete=models.CASCADE, related_name='score')

    def __str__(self) -> str:
        return self.title
    
    class Meta:
        db_table = 'scores'
        verbose_name = '成绩表'
        verbose_name_plural = verbose_name
