
from mypages.models import Blog
from django.views.generic import ListView



class ListBlogView(ListView):

    model = Blog
    template_name='blogs_list.html'
