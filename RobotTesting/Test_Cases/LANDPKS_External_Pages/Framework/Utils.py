import random
from selenium import webdriver
import requests
from selenium.webdriver.remote.command import Command
from robot.libraries.BuiltIn import BuiltIn
import os
import string
from Selenium2Library import Selenium2Library
from robot.api import logger
import selenium
import simplejson as json
ERROR_CODE_RESPONSE = '400'
SUCCESS_CODE_RESPONSE = '200'
def GenRandString(type="text"):
    iStringLen = random.randint(1,10)
    type = string.lower(type)
    ret = ''
    if(type == "text"):
        ret = ''.join(random.SystemRandom().choice(string.ascii_letters) for _ in range(iStringLen))
    elif(type == "number"):
        ret =  ''.join(random.SystemRandom().choice(["0","1","2","3","4","5","6","7","8","9"]) for _ in range(iStringLen))
    return ret
def GetDate():
    yr = '{0}'.format(random.randint(1900,2200))
    mt = '{0}'.format(random.randint(1,12))
    mt = '{0}'.format(mt) if len(mt)>1 else '0{0}'.format(mt)
    dy = '{0}'.format(random.randint(1,31))
    dy = '{0}'.format(dy) if len(dy)>1 else '0{0}'.format(dy)
    return '{0}-{1}-{2}'.format(yr,mt,dy)
