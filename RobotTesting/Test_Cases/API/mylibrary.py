import os
import ast
import requests
import urllib
import httplib
import json
from robot.libraries.BuiltIn import BuiltIn
class mylibrary(object):
    def __init__(self):
        self.secrets = self.get_google_token()
    def initiate_a_request(self, urlPass):
        #s = session = requests.Session()
        #s.headers.update({"X-Auth-Token" : self.get_google_token()})
        #s.url = urlPass
        r = requests.get(urlPass,headers={"X-Auth-Token" : self.secrets})
        return r.status_code

    def Search_for_an_ID(self, url):
        return str.split(str.split(requests.get(url).content, ":")[1], ",")[0]

    def join_an_ID_to_a_query(self, url, key):
        return url.format(key)

    def read_a_test_case_from_file(self, test_case_name, file):
        url = ''
        f = open(os.curdir + "/template/" + file, 'r')
        for line in f:
            words = line.split(",")
            if (words.pop(0).lower() == test_case_name.lower()):
                url = url + words.pop(1) + "\n"
        f.close()
        return url
    def get_google_token(self):
        try:
            secrets = {
             "client_id": "254673914223-tv4pvoig9ouql2puvsuigmiuabaj87u8.apps.googleusercontent.com",
             "client_secret": "VIlyqfrpXMNJCx5gJREdftaz",
             "refresh_token": "1/_1WlcfmNJPESOkzxYjJj9abhkTQUoV74ICKJfqTgXBA",
             "grant_type": "refresh_token"
            }
            content_dict = secrets
            params = urllib.urlencode(content_dict)
    
            headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "text/plain"}
            conn = httplib.HTTPSConnection("www.googleapis.com")
            conn.request("POST", "/oauth2/v4/token", params, headers)
            response = conn.getresponse()
            data = json.loads(response.read())
            conn.close()
            return data["access_token"]
        except Exception as err:
            return err