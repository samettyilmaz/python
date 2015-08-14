
from django.conf.urls import patterns, include, url
import mypages.views
from django.views import *
from django.contrib.staticfiles.urls import staticfiles_urlpatterns
from mypages.models import Post
from django.contrib import admin
from tastypie.api import Api
from mypages.api import PostResource , CommentResource , UserResource
admin.autodiscover()


v1_api = Api(api_name='v1')
v1_api.register(UserResource())
v1_api.register(PostResource())
v1_api.register(CommentResource())

urlpatterns = patterns('',

    url(r'^admin/', include(admin.site.urls)),
    url(r'^post/(?P<slug>[-\w]+)$','mypages.views.view_post',name='blog_post_detail'),
    url(r'^post/like/(?P<slug>[-\w]+)$','mypages.views.like_post',name='like_post'),
    url(r'^edit/(?P<slug>[-\w]+)$','mypages.views.edit_post',name='blog_post_edit'),
    url(r'^delete/(?P<slug>[-\w]+)$','mypages.views.delete_post',name='blog_delete_post'),
    url(r'^add/post/$', 'mypages.views.add_post', name='blog_add_post'),
    url(r'^search/$', 'mypages.views.search', name='search'),
    url(r'^edit_articles/$',"mypages.views.edit_pages",name="edit_articles"),
    url(r'^my_articles/$',"mypages.views.my_articles",name="my_articles"),
    url(r'^articles/$',"mypages.views.articles",name="articles"),
    url(r'^accounts/login/$','mypages.views.login',name="login"),
    url(r'^accounts/auth/$','mypages.views.auth_view',name="auth"),
    url(r'^accounts/logout/$','mypages.views.logout',name="logout"),
    url(r'^accounts/loggedin/$','mypages.views.loggedin',name="loggedin"),
    url(r'^accounts/invalid/$','mypages.views.invalid_login',name="invalid"),
    url(r'^accounts/register/$','mypages.views.register_user',name="register_user"),
    url(r'^accounts/register_success/$','mypages.views.register_success',name="register_success"), 
    url(r'^api/', include(v1_api.urls)),
    
        

)   