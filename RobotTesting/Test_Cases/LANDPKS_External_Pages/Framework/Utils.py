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
from selenium.webdriver.support.ui import Select
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
        if(ret[:1] == "0"):
            ret = ret[1:]
    elif(type=="loc"):
        dataType = random.choice(["int","double"])
        negLoc = random.choice(["-",""])
        if(dataType == "int"):
            ret = "{0}{1}".format(negLoc, random.randint(0,180))
        elif (dataType == "double"):
            ret = "{0}{1}".format(negLoc, random.uniform(0,180))
    print ret
    return ret
def GetDate():
    yr = '{0}'.format(random.randint(1900,2200))
    mt = '{0}'.format(random.randint(1,12))
    mt = '{0}'.format(mt) if len(mt)>1 else '0{0}'.format(mt)
    dy = '{0}'.format(random.randint(1,31))
    dy = '{0}'.format(dy) if len(dy)>1 else '0{0}'.format(dy)
    return '{0}-{1}-{2}'.format(yr,mt,dy)
def SelectBoxSelectOption(driver,ByType,ElePath,option):
    selEle = GetSelEle(driver, ByType, ElePath)
    selEle.deselect_all()
    selEle.select_by_value(option)
def SelectBoxSelectRand(driver,ByType,ElePath):
    selEle = GetSelEle(driver, ByType, ElePath)
    if( selEle.is_multiple ):
        selEle.deselect_all()
    options = len(selEle.options)
    selEle.select_by_index(random.randint(1,options-1))
def GetSelEle(driver, ByType, ElePath):
    return Select(driver.find_element(ByType,ElePath))