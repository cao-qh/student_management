from django.urls import path,include
from .views import GradeListView

urlpatterns = [
    path('', GradeListView.as_view(),name='grades_list'),
    path('create/',GradeCreateView.as_view(),name='grades_create')
]