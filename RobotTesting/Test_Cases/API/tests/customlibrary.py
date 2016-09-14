#Library to be used in robotframework

import httplib, urllib
import json
import ast


def get_google_token(secrets):
    try:
        content_dict = ast.literal_eval(secrets)
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

