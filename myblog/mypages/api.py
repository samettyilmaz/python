from tastypie.resources import ModelResource
from mypages.models import Post, Comment
from django.contrib.auth.models import User
from tastypie import fields




class UserResource(ModelResource):
    class Meta:
        queryset = User.objects.all()
        resource_name = 'user'
        


class PostResource(ModelResource):
    author = fields.ForeignKey(UserResource, 'user',null=True)
    class Meta:
        queryset = Post.objects.all()
        resource_name = 'post'

class CommentResource(ModelResource):
    """docstring for CommentResource"""
    post=fields.ForeignKey(PostResource,'post')
    class Meta:
        queryset=Comment.objects.all()
        resource_name='comment'
       