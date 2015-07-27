# -*- coding: utf-8 -*-
from south.utils import datetime_utils as datetime
from south.db import db
from south.v2 import SchemaMigration
from django.db import models


class Migration(SchemaMigration):

    def forwards(self, orm):
        # Adding field 'Contact.old'
        db.add_column(u'mypages_contact', 'old',
                      self.gf('django.db.models.fields.IntegerField')(default=1, max_length=32),
                      keep_default=False)


    def backwards(self, orm):
        # Deleting field 'Contact.old'
        db.delete_column(u'mypages_contact', 'old')


    models = {
        u'mypages.contact': {
            'Meta': {'object_name': 'Contact'},
            'email': ('django.db.models.fields.EmailField', [], {'max_length': '75'}),
            'first_name': ('django.db.models.fields.CharField', [], {'max_length': '255'}),
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'last_name': ('django.db.models.fields.CharField', [], {'max_length': '255'}),
            'old': ('django.db.models.fields.IntegerField', [], {'max_length': '32'})
        }
    }

    complete_apps = ['mypages']