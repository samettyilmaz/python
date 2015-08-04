from django.db import models
from time import time
from django.template.defaultfilters import slugify

from django.contrib.auth.models import User
# Create your models here.
def get_upload_file_name(instance,filename):
    return "uploaded_files/%s_%s" % (str(time).replace('.','_'),filename)


class Post(models.Model):
    title = models.CharField(max_length=150)
    slug = models.SlugField(unique=False)
    text = models.TextField()
    finished=models.BooleanField(default=True)
    created_on = models.DateTimeField(auto_now_add=True)
    author = models.ForeignKey(User)
    like=models.IntegerField(default=0)
    thumbnail=models.FileField(upload_to=get_upload_file_name)

    def __unicode__(self):
        return self.title

    @models.permalink
    def get_absolute_url(self):
        return ('blog_post_detail', (), 
                {
                    'slug' :self.slug,
                })

    def save(self, *args, **kwargs):
        if not self.slug:
            self.slug = slugify(self.title)
        super(Post, self).save(*args, **kwargs)

    def delete(self, *args, **kwargs):
        if not self.slug:
            self.slug = slugify(self.title)
        super(Post, self).delete(*args, **kwargs)


class Comment(models.Model):
    name = models.CharField(max_length=42)
    email = models.EmailField(max_length=75)
    text = models.TextField()
    post = models.ForeignKey(Post)
    created_on = models.DateTimeField(auto_now_add=True)

    def __unicode__(self):
        return self.text

