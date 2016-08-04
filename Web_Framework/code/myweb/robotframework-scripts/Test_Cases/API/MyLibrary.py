import os
import requests


class MyLibrary(object):
    def initiate_a_request(self, url):
        return requests.get(url).status_code

    def Search_for_an_ID(self, url):
        return str.split(str.split(requests.get(url).content, ":")[1], ",")[0]

    def ioint_an_ID_to_a_query(self, url, key):
        return url.format(key)

    def read_a_test_case_from_file(self, test_case_name, file):
        url = ''
        f = open(os.getcwd() + "/robotframework-scripts/Test_Cases/API/template/" + file, "r")
        for line in f:
            words = line.split(",")
            if (words.pop(0).lower() == test_case_name.lower()):
                url = url + words.pop(1) + "\n"
        f.close()
        return url

