from django.urls import path
from django.conf.urls import *
from . import views

urlpatterns = [
    url(r'^home/$',views.home,name="home"),
]