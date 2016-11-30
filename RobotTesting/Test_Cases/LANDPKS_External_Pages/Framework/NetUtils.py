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
def GetPortalInfo(RequestString):
    response = requests.put(RequestString)
    ResponseText = response.text
    response.close()
    return ResponseText
class GoogleLogin(WebDriver):
    def HandleLogin(self,Creds,bRequireApprove=True):
        try:
            #LogSuccess("Test 2.1.1 Pass")
            
            SwitchToPopupWindow(self)
            time.sleep(2)
            ele = GetEleIfVis(self,By.ID,"Email")
            time.sleep(1)
            ele.send_keys(Creds["UName"])
            ClickEleIfVis(self,By.ID,"next")
            ele = GetEleIfVis(self,By.ID,"Passwd")
            ele.send_keys(Creds["PWord"])
            ClickEleIfVis(self,By.ID,"signIn")
            if (bRequireApprove):
                #try:
                    #if (checkToSeeElement(driver,"submit_approve_access")):
                        ClickEleIfVis(self,By.ID,"submit_approve_access")
                      
                #except:
                #   pass    
            win = self.window_handles
            self.switch_to.window(win[0])
        except :
            self.ProcErros()
    def ProcErrors(self):
        try:
            self.find_element(By.ID, 'challenge')
            self.find_element(By.XPATH, "//button[@type='submit']/img[contains(@src,'manualrecovery.png')]")
        except:
            pass
        return
    