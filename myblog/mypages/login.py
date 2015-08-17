#!/usr/bin/python
#
#web login using requests
#
#login.py
import requests
payload={
    'username':'samet',
    'password':'samet_00'
}

import sys
with requests.Session( ) as c:
        c.post('http://127.0.0.1:8000/login',data=payload)
        r=c.get('http://127.0.0.1:8000/loggedin')
        print 'samet' in r.content