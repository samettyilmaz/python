from tastypie.resources import ModelResource
from mypages.models import Post, Comment
from tastypie import fields
from django.contrib.auth.models import User
from tastypie.authentication import BasicAuthentication, ApiKeyAuthentication, MultiAuthentication
from tastypie.authorization import DjangoAuthorization
from tastypie.serializers import Serializer





class UserResource(ModelResource):
    class Meta:
        queryset = User.objects.all()
        resource_name = 'user'
        excludes = ['email', 'password', 'is_superuser']
        serializer = Serializer(formats=['json', 'jsonp', 'xml', 'yaml', 'html', 'plist'])
        authentication = MultiAuthentication(BasicAuthentication(), ApiKeyAuthentication())
        authorization = DjangoAuthorization()

class PostResource(ModelResource):
    author = fields.ForeignKey(UserResource, 'user',null=True)
    class Meta:
        queryset = Post.objects.all()
        resource_name = 'post'
        authentication = MultiAuthentication(BasicAuthentication(), ApiKeyAuthentication())
        authorization= DjangoAuthorization()


class CommentResource(ModelResource):
    """docstring for CommentResource"""
    post=fields.ForeignKey(PostResource,'post')
    class Meta:
        queryset=Comment.objects.all()
        resource_name='comment'
        authentication = MultiAuthentication(BasicAuthentication(), ApiKeyAuthentication())
