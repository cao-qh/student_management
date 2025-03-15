from django.http import JsonResponse
from django.views.generic import ListView, CreateView, UpdateView, DeleteView,DetailView
from django.urls import reverse_lazy
from django.db.models import Q

from grades.models import Grade
from scores.forms import ScoreForm
from students.models import Student

from .models import Score

class BaseScoreView():
    model = Score
    success_url = reverse_lazy("score_list")

class ScoreListView(BaseScoreView, ListView):
    template_name = "scores/score_list.html"
    context_object_name = "scores"
    paginate_by = 10

    def get_queryset(self):
        queryset = super().get_queryset()
        grade_query = self.request.GET.get('grade')  # 从GET请求中获取班级查询参数
        search_query = self.request.GET.get('search')  # 获取搜索查询参数

        if grade_query:
            queryset = queryset.filter(grade__pk=grade_query)
        if search_query:
            queryset = queryset.filter(
                Q(student_number__icontains=search_query) |
                Q(student_name__icontains=search_query)
            )
        return queryset.order_by('grade', 'student_number')
    
    def get_context_data(self, **kwargs):
        context = super(ScoreListView, self).get_context_data(**kwargs)
        # 获取所有班级并添加到上下文
        context['grades'] = Grade.objects.all()
        context['current_grade'] = self.request.GET.get('grade','')
        return context

class ScoreCreateView(BaseScoreView,CreateView):
    form_class = ScoreForm
    template_name = "scores/score_form.html"
    
    def form_valid(self,form):
        # 从表单获取用户信息
        student_name= form.cleaned_data['student_name']
        student_number = form.cleaned_data['student_number']
        grade_id= form.cleaned_data['grade']
        
        # 查询学生表
        try:
            student = Student.objects.get(student_name=student_name,student_number=student_number,grade_id=grade_id)
        except Student.DoesNotExist:
            errors={'general':[{'message':'学生不存在','code':'student_not_exist'}]}
            return JsonResponse({'status':'error','message':errors},status=404)
        
        form.save()
        return JsonResponse({'status':'success','message':'成绩添加成功'})
    
    def form_invalid(self, form):
        pass

class ScoreUpdateView(BaseScoreView,UpdateView):
    pass

class ScoreDetailView(DetailView):
    pass

class ScoreDeleteView(BaseScoreView,DeleteView):
    pass

class ScoreDeleteMultipleView(BaseScoreView,DeleteView):
    pass

class MyScoreListView(ListView):
    pass