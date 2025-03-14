from django.views.generic import ListView, CreateView, UpdateView, DeleteView
from django.urls import reverse_lazy
from django.db.models import Q

from grades.models import Grade

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

class ScoreCreateView(CreateView):
    pass

class ScoreUpdateView(UpdateView):
    pass
