from django.views.generic import ListView,CreateView,UpdateView,DeleteView
from django.urls import reverse_lazy

from .models import Score

class BaseScoreView():
    model = Score
    success_url = reverse_lazy("score_list")

class ScoreListView(BaseScoreView,ListView):
    template_name = "scores/score_list.html"
    context_object_name = "scores"
    paginate_by = 10

class ScoreCreateView(CreateView):
    pass

class ScoreUpdateView(UpdateView):
    pass

class ScoreDeleteView(DeleteView):
    pass