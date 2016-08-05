'''
Created on Aug 5, 2016

@author: bbarnett
'''
import requests
def GetPortalInfo(RequestString):
    response = requests.put(RequestString)
    ResponseText = response.text
    response.close()
    return response.text