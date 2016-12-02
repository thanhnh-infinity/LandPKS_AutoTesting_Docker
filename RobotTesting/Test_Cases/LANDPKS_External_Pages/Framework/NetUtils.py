'''
Created on Aug 5, 2016

@author: bbarnett
'''
import requests
from WebHelpers import SwitchToPopupWindow
from appium.webdriver.webdriver import WebDriver
import time
from selenium.webdriver.common.by import By
from WebHelpers import ClickEleIfVis,GetEleIfVis
from selenium import webdriver
from selenium.selenium import selenium
from selenium.webdriver.support.ui import Select
def GetPortalInfo(RequestString):
    response = requests.put(RequestString)
    ResponseText = response.text
    response.close()
    return ResponseText
def SelectBoxSelectOption(driver,ByType,ElePath,option):
    selEle = Select(driver.find_element(ByType,ElePath))
    selEle.select_by_value(option)
class GoogleLogin(webdriver.Remote):
    BaseWebDriver = None
    def __init__(self,Driver):
        self.BaseWebDriver = Driver
    def HandleLogin(self,Creds,bRequireApprove=True):
        try:
            #LogSuccess("Test 2.1.1 Pass")
            
            SwitchToPopupWindow(self.BaseWebDriver)
            time.sleep(2)
            ele = GetEleIfVis(self.BaseWebDriver,By.ID,"Email")
            time.sleep(1)
            ele.send_keys(Creds["UName"])
            ClickEleIfVis(self.BaseWebDriver,By.ID,"next")
            ele = GetEleIfVis(self.BaseWebDriver,By.ID,"Passwd")
            ele.send_keys(Creds["PWord"])
            ClickEleIfVis(self.BaseWebDriver,By.ID,"signIn")
            if (bRequireApprove):
                #try:
                    #if (checkToSeeElement(driver,"submit_approve_access")):
                        ClickEleIfVis(self.BaseWebDriver,By.ID,"submit_approve_access")
                      
                #except:
                #   pass    
            win = self.BaseWebDriver.window_handles
            self.BaseWebDriver.switch_to.window(win[0])
            return False
        except :
            self.ProcErrors(Creds)
            self.BaseWebDriver.close()
            return True
    def ProcErrors(self,Creds):
        try:
            self.BaseWebDriver.find_element(By.ID, 'challenge')
            self.BaseWebDriver.find_element(By.XPATH, "//input[@id='skipChallenge']").click()
            self.BaseWebDriver.find_element(By.XPATH, "//button[@type='submit']/img[contains(@src,'manualrecovery.png')]").click()
            ele = GetEleIfVis(self.BaseWebDriver,By.ID,"password")
            ele.send_keys(Creds["PWord"])
            ClickEleIfVis(self.BaseWebDriver,By.ID,"submit")
            self.AnswerQuestion()
            ClickEleIfVis(self.BaseWebDriver,By.ID,"submit_approve_access")
            win = self.BaseWebDriver.window_handles
            self.BaseWebDriver.switch_to.window(win[0])
        except:
            raise Exception
        return
    def AnswerQuestion(self):
        if("accountcreationdate.png" in self.BaseWebDriver.page_source):
            #date question 7/19/16
            SelectBoxSelectOption(self.BaseWebDriver, By.ID, "month", "7")
            SelectBoxSelectOption(self.BaseWebDriver, By.ID, "year", "2016")
            ClickEleIfVis(self.BaseWebDriver,By.ID,"submit")
            return
        else:
            return