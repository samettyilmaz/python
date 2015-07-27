# -*- coding: utf-8 -*-
from south.utils import datetime_utils as datetime
from south.db import db
from south.v2 import SchemaMigration
from django.db import models


class Migration(SchemaMigration):

    def forwards(self, orm):
        # Deleting model 'Contact'
        db.delete_table(u'mypages_contact')

        # Adding model 'Blog'
        db.create_table(u'mypages_blog', (
            (u'id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('title', self.gf('django.db.models.fields.CharField')(max_length=255)),
            ('article', self.gf('django.db.models.fields.TextField')(max_length=255)),
        ))
        db.send_create_signal(u'mypages', ['Blog'])

        # Adding model 'Comment'
        db.create_table(u'mypages_comment', (
            (u'id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('comment', self.gf('django.db.models.fields.TextField')()),
            ('blog_article', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['mypages.Blog'])),
        ))
        db.send_create_signal(u'mypages', ['Comment'])


    def backwards(self, orm):
        # Adding model 'Contact'
        db.create_table(u'mypages_contact', (
            ('first_name', self.gf('django.db.models.fields.CharField')(max_length=255)),
            ('last_name', self.gf('django.db.models.fields.CharField')(max_length=255)),
            ('old', self.gf('django.db.models.fields.IntegerField')(max_length=32)),
            (u'id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('email', self.gf('django.db.models.fields.EmailField')(max_length=75)),
        ))
        db.send_create_signal(u'mypages', ['Contact'])

        # Deleting model 'Blog'
        db.delete_table(u'mypages_blog')

        # Deleting model 'Comment'
        db.delete_table(u'mypages_comment')


    models = {
        u'mypages.blog': {
            'Meta': {'object_name': 'Blog'},
            'article': ('django.db.models.fields.TextField', [], {'max_length': '255'}),
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'title': ('django.db.models.fields.CharField', [], {'max_length': '255'})
        },
        u'mypages.comment': {
            'Meta': {'object_name': 'Comment'},
            'blog_article': ('django.db.models.fields.related.ForeignKey', [], {'to': u"orm['mypages.Blog']"}),
            'comment': ('django.db.models.fields.TextField', [], {}),
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'})
        }
    }

    complete_apps = ['mypages']