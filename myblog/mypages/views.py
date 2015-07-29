
from mypages.models import Blog
from mypages.models import Comment

from django.views.generic import ListView
from django.views.generic import CreateView
from django.core.urlresolvers import reverse



class ListBlogView(ListView):

    model = Blog
    template_name='blogs_list.html'

class CreateBlogView(CreateView):

    model = Blog
    template_name = 'add_page.html'

    def get_success_url(self):
        return reverse('list')

class CreateCommentView(CreateView):

    model = Comment
    template_name = 'add_comment.html'

    def get_success_url(self):
        return reverse('list')
