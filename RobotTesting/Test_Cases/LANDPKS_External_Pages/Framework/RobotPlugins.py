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
class RobotPlugins:
    robotDriverRemote = webdriver.Remote
    def get_browser(self, RemoteUrl, Capabilities):
        robotDriverRemote = Selenium2Library.open_browser("www.google.com", remote_url=RemoteUrl, desired_capabilities=Capabilities)
        return robotDriverRemote
    def set_browser(self):
        self.robotDriverRemote = BuiltIn().get_library_instance('Selenium2Library')._current_browser()
    def close_popup(self, handle):
        self.switch_to_window(handle)
        self.robotDriverRemote.close()
    def switch_to_window(self, handle):
        data = {'name': handle}
        self.robotDriverRemote.execute(Command.SWITCH_TO_WINDOW, data)
    def read_api_response(self, curResponseXpath, bCorrect):
        self.set_browser()
        responseXpath = "{0}//div[@class='block response_body undefined xml']/pre/code".format(curResponseXpath)
        responseCodeXpath = "{0}//div[@class='block response_code']/pre".format(curResponseXpath)
        requestXpath = "{0}//div[@class='block request_url']/pre".format(curResponseXpath)
        responseEle = self.robotDriverRemote.find_element_by_xpath(responseCodeXpath)
        requestEle = self.robotDriverRemote.find_element_by_xpath(requestXpath)
        ResponseCode = responseEle.text
        RequestUrl = requestEle.text
        response = requests.put(RequestUrl)
        if(response.status_code == int(ResponseCode)):
            logger.info("Response code from API Explorer and API directly were both {0}".format(ResponseCode))
        else:
            logger.error("Codes were not the same, from API Explorer Response code was {0}. From API response was {1}. Request String Was {2}".format(ResponseCode, response.status_code, RequestUrl))
        if(RequestUrl.count('?') > 1):
            logger.error("Request string {0} was flawed. Contained {1} query parameters.".format(RequestUrl,RequestUrl.count('?')))
        if(bCorrect == 'True'):
            self.CheckResponseErrors(ResponseCode, response)
    def fill_input_api_explorer(self, Element, bCorrect='False'):
        name = Element.get_attribute('name')
        ret = '{0}'
        strInput = ''
        if(bCorrect == 'True'):
            logger.info(name)
            if("date" in name):
                strInput = ret.format(self.FillInputDataApiExplorer('date'))
            elif("lon" in name or "lat" in name):
                strInput = ret.format(self.FillInputDataApiExplorer('loc'))
            elif("email" in name or "name" in name):
                strInput = ret.format(self.FillInputDataApiExplorer('email'))
            else:
                strInput = ret.format(self.FillInputDataApiExplorer('number'))
        else:
            strInput = ret.format(self.FillInputDataApiExplorer('Rand'))
        logger.info('Sending "{0}" to element {1}'.format(strInput, Element))
        Element.send_keys(strInput)
    def FillInputDataApiExplorer(self, type):
        return {
                'date':'{0}'.format(self.GetDate()) ,
                'email': '{0}@{1}.{2}'.format(self.GenRandString(),self.GenRandString(),random.choice(["org","com","net"])),
                'number': '{0}'.format(random.randint(0,10)),
                'loc' : '{0}'.format(random.uniform(0,120)),
                'Rand' : '{0}'.format(self.GenRandString())
                }[type]
    def GenRandString(self):
        iStringLen = random.randint(1,10)
        randString = ''.join(random.SystemRandom().choice(string.ascii_letters) for _ in range(iStringLen))
        return randString
    def GetDate(self):
        yr = '{0}'.format(random.randint(1900,2200))
        mt = '{0}'.format(random.randint(1,12))
        mt = '{0}'.format(mt) if len(mt)>1 else '0{0}'.format(mt)
        dy = '{0}'.format(random.randint(1,31))
        dy = '{0}'.format(dy) if len(dy)>1 else '0{0}'.format(dy)
        return '{0}-{1}-{2}'.format(yr,mt,dy)
    def CheckResponseErrors(self, Code, Response):
        strResponse = json.loads(Response.text)
        if(not Response.status_code == SUCCESS_CODE_RESPONSE):
            if(Response.status_code == ERROR_CODE_RESPONSE):
                logger.info(strResponse['error'])