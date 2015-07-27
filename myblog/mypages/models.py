# -*- encoding=utf-8 -*

from django.db import models


class Blog(models.Model):
    title = models.CharField(max_length=255,)
    article= models.TextField(max_length=255,)


class Comment(models.Model):
    comment = models.TextField()
    blog_article = models.ForeignKey('Blog')

    
 