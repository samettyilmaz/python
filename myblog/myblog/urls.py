from django.conf.urls import patterns, include, url
import mypages.views
from django.contrib.staticfiles.urls import staticfiles_urlpatterns

from django.contrib import admin

admin.autodiscover()

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'myblog.views.home', name='home'),
    # url(r'^blog/', include('blog.urls')),

    url(r'^article_list$', mypages.views.ListBlogView.as_view(),name='list',),
    url(r'^new$', mypages.views.CreateBlogView.as_view(),name='add_article',),
    url(r'^newcomment$', mypages.views.CreateCommentView.as_view(),name='add_comment',),
    url(r'^admin/', include(admin.site.urls)),
)
