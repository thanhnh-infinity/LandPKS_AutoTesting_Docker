'''
Created on Jun 21, 2016

@author: bbarnett
'''
from selenium import webdriver
import re
import requests
import simplejson as json
import random
from robot.api import logger
from _random import Random
import string
from selenium.webdriver.common.by import By
from selenium.webdriver.common import desired_capabilities
from Selenium2Library.keywords._browsermanagement import BROWSER_NAMES
from robot.libraries.BuiltIn import BuiltIn
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC, wait
import time
from appium.webdriver.webelement import WebElement
from operator import contains
MOBILE_APP_WEBPAGE = "http://testlpks.landpotential.org:8105/#/landpks/landpks_entry_page"
XPATH_NEW_MOBILE_TEST = '//html/body/ion-nav-view/ion-tabs/ion-nav-view/div/ion-view/ion-content/div/div[1]/div/img'
GOOGLE_LOGIN_BUTTON = 'loginGoogleWebBrowser'
GOOGLE_SIGNIN_TITLE = 'Sign in - Google Accounts'
GOOGLE_LOGIN_EMAIL = 'barnebre@gmail.com'
GOOGLE_EMAIL_FIELD_NAME = 'Email'
GOOGLE_NEXT_FIELD_NAME = 'next'
GOOGLE_PASS_FIELD_NAME = 'Passwd'
XPATH_SIGNIN_BUTTON = '//html/body/div/div[2]/div[2]/div[1]/form/div[2]/div/input[1]'
class mobileHandle:
    driverMain = webdriver.Remote
    driverHandleMain = ''
    def __init__(self, driver):
        self.driverMain = driver
        
        #self.driverMain.get(MOBILE_APP_WEBPAGE)
        #driver.execute_script(open("./*.js").read())
        
    def ele_click(self, field, xpath = False):
        if(xpath) :
            wait = WebDriverWait(self.driverMain, 10)
            wait.until(EC.presence_of_element_located((By.XPATH, field)), "")
            self.driverMain.find_element_by_xpath(field).click()
        else:
            wait = WebDriverWait(self.driverMain, 3)
            wait.until(EC.presence_of_element_located((By.ID, field)), "")
            self.driverMain.find_element_by_id(field)
    def handle_portal_app(self, driver):
        driver.get(MOBILE_APP_WEBPAGE)
        time.sleep(3)
        driver.find_element_by_xpath( XPATH_NEW_MOBILE_TEST)
        self.driverMain = driver 
        self.driverHandleMain = self.driverMain.current_window_handle
        logger.info('clicking {0}'.format(XPATH_NEW_MOBILE_TEST))
        #driver.execute_script("document.querySelectorAll(\'{0}\')[1].click()".format(XPATH_NEW_MOBILE_TEST))
        #scripts = self.driverMain.find_elements_by_tag_name("script")
        '''
        for i in scripts:
            src = i.get_attribute('src')
            if(".js" in src):
                logger.info(src)
                self.driverMain.execute_script(open().read())
        '''    
        self.ele_click(
                       XPATH_NEW_MOBILE_TEST,
                       True
                       )
        
        self.handle_google_login()
        self.switch_to_window(self.driverHandleMain)
    def handle_google_login(self):
        self.switch_to_window(GOOGLE_SIGNIN_TITLE)
        emailField = self.driverMain.find_element_by_id(GOOGLE_EMAIL_FIELD_NAME)
        emailField.send_keys(GOOGLE_LOGIN_EMAIL)
        self.driverMain.find_element_by_id(GOOGLE_NEXT_FIELD_NAME).click()
        PassWordField = self.driverMain.find_element_by_id(GOOGLE_PASS_FIELD_NAME)
        PassWordField.setFocus()
        PassWordField.send_keys('_PL)OK(IJ*UH-pl0ok9ij')
        SignInField = self.driverMain.find_element_by_xpath(XPATH_SIGNIN_BUTTON)
        wait = WebDriverWait(self.driverMain, 3)
        wait.until(EC.visibility_of_element_located(SignInField), "")
        SignInField.click()
        
    def switch_to_window(self, WindowHandle):
        #Use the handle of window to switch between windows
        Windows = self.driverMain.window_handles
        
        self.driverMain.switch_to_window(Windows[-1])
