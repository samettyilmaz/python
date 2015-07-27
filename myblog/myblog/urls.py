from django.conf.urls import patterns, include, url
import mypages.views

from django.contrib import admin

admin.autodiscover()

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'myblog.views.home', name='home'),
    # url(r'^blog/', include('blog.urls')),

    url(r'^article-list/', mypages.views.ListBlogView.as_view()),

    url(r'^admin/', include(admin.site.urls)),
)
