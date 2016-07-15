'''
Created on Jun 23, 2016

@author: bbarnett
'''
import os
from time import sleep
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
import unittest
from appium import webdriver
from selenium.common.exceptions import TimeoutException
from robot.libraries.BuiltIn import BuiltIn
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities
from appium.webdriver.webelement import WebElement
from Utils import GenRandString
import random
SAUCE_ACCESS_KEY = 'Barnebre:216526d7-706f-4eff-bf40-9d774203e268'
COMMAND_EXEC = 'http://localhost:4723/wd/hub'
LAND_INFO_ANDROID_APP = 'http://128.123.177.36:8080/job/LandInfo_Mobile_Andoird_App/ws/platforms/android/build/outputs/apk/android-debug.apk'
LAND_COVER_ANDROID_APP = 'http://128.123.177.36:8080/job/LandCover_Mobile_Andoird_App/ws/platforms/android/build/outputs/apk/android-debug.apk'
LAND_COVER_ANDROID_PACKAGE = 'org.landpotential.lpks.landcover'
LAND_COVER_ANDROID_ACTIVITY_NAME = 'org.landpotential.lpks.landcover.MainActivity'
LAND_INFO_BACK_BUTTON = "//div[@nav-bar='active']//a[@class='button button-icon']"
LAND_INFO_MENU_ITEM_PATH = "//ion-view[@cache-view='false']//div[@class='scroll']/a"
LAND_INFO_PLOT_INFO_PATH = "//ion-view[@cache-view='false']//div[@class='scroll']//div[contains(@class,'col col-5')]/img"
LAND_INFO_ROCK_FRAGEMENT_CONTENT = "//ion-view[@cache-view='false']//div[@class='scroll']//div[@class='lpks-select']"
LAND_INFO_POPUP_BODY = "//div[@class='popup-body']//ion-view[@cache-view='false']"
LAND_INFO_POPUP_ROCK_CONTENT = "//a[@class='item item-icon-right']"
#COMMAND_EXEC = 'http://%s@ondemand.saucelabs.com:80/wd/hub' % (SAUCE_ACCESS_KEY)
# Returns abs path relative to this file and not cwd
PATH = lambda p: os.path.abspath(
    os.path.join(os.path.dirname(__file__), p)
)
def FillPlotData(driver):
    #fill plot info
    inputs = driver.find_elements_by_tag_name("input")
    for input in inputs:
        type = input.get_attribute("type")
        if(type == "text"):
            input.send_keys(GenRandString())
        elif(type == "number"):
            input.send_keys(GenRandString("number"))
        elif(type == "radio" and input.get_attribute("value") == "small"):
            input.click()
    ClickElementIfVis(driver, By.XPATH, LAND_INFO_BACK_BUTTON)
    #click Slope
    ClickElementIfVis(driver, By.XPATH, '{0}{1}'.format(LAND_INFO_MENU_ITEM_PATH,'[4]'))
    #Click first slope
    eles = GetElesIfVis(driver, By.XPATH,LAND_INFO_PLOT_INFO_PATH)
    eles[0].click()
    ClickElementIfVis(driver, By.XPATH, LAND_INFO_BACK_BUTTON)
    #click soil layer
    ClickElementIfVis(driver, By.XPATH, '{0}{1}'.format(LAND_INFO_MENU_ITEM_PATH,'[7]'))
    #click first soil layer
    ClickElementIfVis(driver, By.XPATH, '{0}{1}'.format(LAND_INFO_MENU_ITEM_PATH,'[1]'))
    #Click Rock Fragment content
    ClickElementIfVis(driver, By.XPATH, LAND_INFO_ROCK_FRAGEMENT_CONTENT)
    #select Fragment Content
    eles = GetElesIfVis(driver, By.XPATH,'{0}{1}'.format(LAND_INFO_POPUP_BODY, LAND_INFO_POPUP_ROCK_CONTENT))
    eles[random.randint(0,3)].click()
    #Select which soil type
    #Go back to main page
    ClickElementIfVis(driver, By.XPATH, LAND_INFO_BACK_BUTTON)
    ClickElementIfVis(driver, By.XPATH, LAND_INFO_BACK_BUTTON)
    ClickElementIfVis(driver, By.XPATH, '{0}{1}'.format(LAND_INFO_MENU_ITEM_PATH,'[9]'))
def WaitForLoad(driver):
    wait = WebDriverWait(driver, 30)
    wait.until(EC.presence_of_element_located((By.XPATH, "//div[@class='loading-container']")),"")
    wait.until(EC.invisibility_of_element_located((By.XPATH, "//div[@class='loading-container']")),"")
def GetEleIfVis(driver, ByType, Value):
    wait = WebDriverWait(driver, 10)
    return wait.until(EC.visibility_of_element_located((ByType, Value)), "")

def GetElesIfVis(driver, ByType, Value):
    wait = WebDriverWait(driver, 10)
    wait.until(EC.visibility_of_element_located((ByType, Value)), "")
    return driver.find_elements(ByType, Value)
def ClickElementIfVis(driver, ByType, Value):
    wait = WebDriverWait(driver, 10)
    ele = wait.until(EC.visibility_of_element_located((ByType, Value)), "")
    if(not ele.is_enabled()):
        ele = wait.until(EC.element_to_be_clickable((ByType, Value)), "")
    ele.click()
def SwitchToPopupWindow(driver):
    curHandles = driver.window_handles
    wait = WebDriverWait(driver, 10)
    wait.until(lambda driver: len(driver.window_handles) > 1)
    driver.switch_to.window(driver.window_handles[-1])
class SimpleAndroidTests(unittest.TestCase):
    def set_browser(self, remoteURL):
        appiumLib = BuiltIn.get_library_instance('AppiumLibrary')
        desired_caps = {}
        desired_caps['platformName'] = 'Android'
        desired_caps['platformVersion'] = '4.2'
        desired_caps['deviceName'] = 'Android Emulator'
        desired_caps['app'] = LAND_COVER_ANDROID_APP
        desired_caps['androidActivity']='org.landpotential.lpks.landcover.MainActivity'
        desired_caps['automationName'] = "Selendroid"
        appiumLib.open_application(remoteURL,desired_caps)
    def setUp(self):
        desired_caps = {}
        desired_caps['platformName'] = 'Android'
        desired_caps['platformVersion'] = '4.2'
        desired_caps['deviceName'] = 'Android Emulator'
        desired_caps['app'] = LAND_COVER_ANDROID_APP
        desired_caps['appWaitActivity']= LAND_COVER_ANDROID_ACTIVITY_NAME
        desired_caps['appWaitPackage'] = LAND_COVER_ANDROID_PACKAGE
        self.driver = webdriver.Remote(command_executor=COMMAND_EXEC, 
                                       desired_capabilities=desired_caps)
        self.driver.implicitly_wait(30)
 
    def tearDown(self):
        # end the session
        self.driver.quit()
    def test_find_elements(self):
        
        #ele = self.driver.find_elements_by_xpath("//")
        ClickElementIfVis(self.driver,By.CLASS_NAME,"android.widget.Image")
        #eles = self.driver.find_elements_by_class_name("android.widget.Image")
        #eles[0].click()
        #contexts = self.driver.window_handles
        #contexts = self.driver.contexts
        #self.driver.switch_to.context("LandPKS Sign-In")
        self.driver.switch_to.context("WEBVIEW_org.landpotential.lpks.landcover")
        #webViews = self.driver.find_elements_by_class_name("android.webkit.WebView")
        #eles = self.driver.find_element_by_android_uiautomator(uia_string)("android.widget.Button")
        ClickElementIfVis(self.driver,By.XPATH,"//Button[@id='loginGoogleDevice']")
        #eles = self.driver.find_elements_by_xpath("//Button[@id='loginGoogleDevice']")
        #eles = self.driver.find_elements_by_android_uiautomator('new UiSelector().clickable(true)')
        #for ele in eles:
            #ele.click()
        
        #if(not self.driver.context == "WEBVIEW_com.android.browser"):
            #self.driver.switch_to.context("WEBVIEW_com.android.browser")
        SwitchToPopupWindow(self.driver)
        #self.driver.switch_to.window(win[1])
        ele = GetEleIfVis(self.driver,By.ID,"Email")
        ele.send_keys("lpks.test@gmail.com")
        ClickElementIfVis(self.driver,By.ID,"next")
        #ele = self.driver.find_element_by_id("next")
        #ele.click()
        ele = GetEleIfVis(self.driver,By.ID,"Passwd")
        #self.driver.find_element_by_id("Passwd")
        ele.send_keys("landpotentialtest")
        #ele = self.driver.find_element_by_id("signIn")
        ClickElementIfVis(self.driver,By.ID,"signIn")
        #ele.click()
        #ele = self.driver.find_element_by_id("submit_approve_access")
        ClickElementIfVis(self.driver,By.ID,"submit_approve_access")
        #ele.click()
        win = self.driver.window_handles
        self.driver.switch_to.window(win[0])
        ClickElementIfVis(self.driver,By.XPATH,"//div[@nav-view='active']//img[@src='landpks_img/landinfo_logo.png']")
        WaitForLoad(self.driver)
        ClickElementIfVis(self.driver,By.XPATH,"//div[@nav-bar='active']//span[@class='right-buttons']/a[@class='button button-icon ion-plus-round']")
        ClickElementIfVis(self.driver, By.XPATH, "//a[@class='item item-icon-right plotname']")
        FillPlotData(self.driver)
if __name__ == '__main__':
    print GenRandString()
    suite = unittest.TestLoader().loadTestsFromTestCase(SimpleAndroidTests)
    unittest.TextTestRunner(verbosity=2).run(suite)
