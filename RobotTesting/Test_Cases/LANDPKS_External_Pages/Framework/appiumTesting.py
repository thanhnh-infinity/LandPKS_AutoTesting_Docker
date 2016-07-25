'''
Created on Jun 23, 2016

@author: bbarnett
'''
import re
import requests
import os
from robot.api import logger as log
from time import sleep
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
import unittest
from appium import webdriver
import simplejson as json
from selenium.common.exceptions import TimeoutException,\
    ElementNotSelectableException, WebDriverException
from robot.libraries.BuiltIn import BuiltIn
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities
from appium.webdriver.webelement import WebElement
from Utils import GenRandString
from Utils import SelectBoxSelectRand
from Utils import GetSauceCreds
import random
from appium import SauceTestCase, on_platforms
from appium.webdriver.connectiontype import ConnectionType
REQUEST_STRING_TO_FIND_PLOT = "http://api.landpotential.org/query?version=0.1&action=get&object=landinfo&type=get_by_pair_name_recorder_name&name={0}&recorder_name=lpks.testing%40gmail.com"
SAUCE_ACCESS_KEY = 'Barnebre:216526d7-706f-4eff-bf40-9d774203e268'
LAND_INFO_ANDROID_APP = 'http://128.123.177.36:8080/job/LandInfo_Mobile_Andoird_App/ws/platforms/android/build/outputs/apk/android-debug.apk'
LAND_COVER_ANDROID_APP = 'http://128.123.177.36:8080/job/LandCover_Mobile_Andoird_App/ws/platforms/android/build/outputs/apk/android-debug.apk'
LAND_COVER_ANDROID_PACKAGE = 'org.landpotential.lpks.landcover'
#LAND_COVER_ANDROID_PACKAGE = 'org.apache.cordova.splashscreen'
LAND_COVER_ANDROID_ACTIVITY_NAME = '.MainActivity'
#LAND_COVER_ANDROID_ACTIVITY_NAME = '.SpashScreen'
LAND_INFO_BACK_BUTTON = "//div[@nav-bar='active']//a[@class='button button-icon']"
LAND_INFO_MENU_ITEM_PATH = "//ion-view[@cache-view='false']//div[@class='scroll']/a"
LAND_INFO_PLOT_INFO_PATH = "//ion-view[@cache-view='false']//div[@class='scroll']//div[contains(@class,'col col-5')]/img"
LAND_INFO_ROCK_FRAGEMENT_CONTENT = "//ion-view[@cache-view='false']//div[@class='scroll']//div[@class='lpks-select']"
LAND_INFO_POPUP_ROCK_BODY = "//div[@class='popup-body']//ion-view[@cache-view='false']"
LAND_INFO_POPUP_ROCK_CONTENT = "//a[@class='item item-icon-right']"
LAND_INFO_SOIL_TYPE = "//ion-view[@cache-view='false']//div[@class='scroll']//div[@class='othercomponent']/select[@ng-model='texture_value']"
LAND_INFO_SUBMIT_PLOT_BUTTON = "//div[@nav-view='active']//div[@class='scroll']//button[@id='btnSubmitPlot_1']"
POSTIVE_POPUP_BUTTON = "//div[@class='popup-buttons']/button[@class='button ng-binding button-positive']"
LAND_INFO_POPUP_BODY = "//div[@class='popup-body']"
LAND_INFO_POPUP_BODY_MESSAGE = "//div[@class='popup-body']/span"
LANDCOVER_PLOT_LIST = "//ion-view[@cache-view='false']//div[@class='scroll']//div[@class='list']/ion-item"
TIMEOUT = 15
COMMAND_EXEC = 'http://%s@ondemand.saucelabs.com:80/wd/hub' % (SAUCE_ACCESS_KEY)
USERNAME_ACCESS_KEY = re.compile('^(http|https):\/\/([^:]+):([^@]+)@')
DICT_MESSAGES_NO_DATA_KEY = {
                 False: {"SubmitPlotText" : "Plot is submitted"},
                 True:{"SubmitPlotText" : "background upload"}
                 }
DICT_OUTPUT_MESSAGE_NO_DATA_KEY = {
                       True : {"PlotUnsucess" : "Error, no connectivity and plot was not flagged for upload",
                               "PlotSucess" : "{0} Flagged for Background upload"},
                       False: {"PlotSucess" : "{0} was submitted",
                               "PlotUnsucess" : "Error, Plot was not submitted"}
                       }
#COMMAND_EXEC = 'http://localhost:4723/wd/hub'
# Returns abs path relative to this file and not cwd
ERRORS = []
PATH = lambda p: os.path.abspath(
    os.path.join(os.path.dirname(__file__), p)
)
def CheckSinglePlotUpload(plotName):
    url = REQUEST_STRING_TO_FIND_PLOT.format(plotName)
    response = requests.put(url)
def OutputErrors():
    if(len(ERRORS) > 0 ):
        log.error("Encountered {0} recoverable errors or inconsistancies they are as follows".format(len(ERRORS) > 0 ))
        for error in ERRORS:
            log.error(error)
def LogError(errorMessage):
    log.error(errorMessage)
    ERRORS.append(errorMessage)
def report_sauce_status(name, status, tags=[], remote_url='', bRobot = True, driver = None):
    # Parse username and access_key from the remote_url
    if(len(ERRORS) > 0 ):
        name.join("| {0} recoverable errors encountered" .format(len(ERRORS)))
    username, access_key = USERNAME_ACCESS_KEY.findall(remote_url)[0][1:]

    # Get selenium session id from the keyword library
    if(bRobot):
        appium = BuiltIn().get_library_instance('AppiumLibrary')
        job_id = appiumLib._current_application().session_id
    else :
        job_id = driver.session_id

    # Prepare payload and headers
    token = (':'.join([username, access_key])).encode('base64').strip()
    payload = {'name': name,
               'passed': status == 'PASS',
               'tags': tags}
    headers = {'Authorization': 'Basic {0}'.format(token)}

    # Put test status to Sauce Labs
    url = 'https://saucelabs.com/rest/v1/{0}/jobs/{1}'.format(username, job_id)
    response = requests.put(url, data=json.dumps(payload), headers=headers)
    assert response.status_code == 200, response.text

    # Log video url from the response
    video_url = json.loads(response.text).get('video_url')
    if video_url:
        log.info('<a href="{0}">video.flv</a>'.format(video_url), html=True)
def FillPlotInputs(driver):
    PlotName = ""
    inputs = driver.find_elements_by_tag_name("input")
    for input in inputs:
        type = input.get_attribute("type")
        if(type == "text"):
            Data = GenRandString()
            if(input.get_attribute("id") == "name"):
                PlotName = Data
            SendTextToEle(input,Data)
        elif(type == "number"):
            Data = GenRandString("loc")
            SendTextToEle(input,Data)
        elif(type == "radio" and input.get_attribute("value") == "small"):
            input.click()
    ClickElementIfVis(driver, By.XPATH, LAND_INFO_BACK_BUTTON)
    return PlotName
def HandleSoilLayer(driver):
    ClickElementIfVis(driver, By.XPATH, '{0}{1}'.format(LAND_INFO_MENU_ITEM_PATH,'[7]'))
    #click first soil layer
    ClickElementIfVis(driver, By.XPATH, '{0}{1}'.format(LAND_INFO_MENU_ITEM_PATH,'[1]'))
    #Click Rock Fragment content
    ClickElementIfVis(driver, By.XPATH, LAND_INFO_ROCK_FRAGEMENT_CONTENT)
    #select Fragment Content
    eles = GetElesIfVis(driver, By.XPATH,'{0}{1}'.format(LAND_INFO_POPUP_ROCK_BODY, LAND_INFO_POPUP_ROCK_CONTENT))
    eles[random.randint(0,3)].click()
    #Select which soil type
    SelectBoxSelectRand(driver,By.XPATH,LAND_INFO_SOIL_TYPE)
    #Go back to main page
    ClickElementIfVis(driver, By.XPATH, LAND_INFO_BACK_BUTTON)
    ClickElementIfVis(driver, By.XPATH, LAND_INFO_BACK_BUTTON)
def FindErrors(driver, ByType=By.XPATH, errorElePath=LAND_INFO_POPUP_BODY_MESSAGE):
    eles = GetElesIfVis(driver, ByType, errorElePath)
    errors = {}
    for ele in eles:
        errorText = ele.text
        if("*" in errorText):
            errorText = errorText.strip()
            stringMes = errorText[errorText.index("*") + 1:]
            stringMes = stringMes.strip()
            errors[stringMes.lower()] = True
    if(len(errors) > 0):
        ProcErrors(driver, errors)
    ClickElementIfVis(driver, By.XPATH,POSTIVE_POPUP_BUTTON)
    ClickElementIfVis(driver, By.XPATH, LAND_INFO_BACK_BUTTON)
def ProcErrors(driver, ErrorDict={}):
    bLocError = False
    bSlopeError = False
    bNameError = False
    bLayerError = False
    
    if("latitude" in ErrorDict or "longitude" in ErrorDict):
        bLocError = True
    if("slope" in ErrorDict):
        bSlopeError = True
    if("at least one soil layer" in ErrorDict):
        bLayerError = True
def HandleSlope(driver):
    ClickElementIfVis(driver, By.XPATH, '{0}{1}'.format(LAND_INFO_MENU_ITEM_PATH,'[4]'))
    #Click first slope
    eles = GetElesIfVis(driver, By.XPATH,LAND_INFO_PLOT_INFO_PATH)
    eles[0].click()
    ClickElementIfVis(driver, By.XPATH, LAND_INFO_BACK_BUTTON)
def FillAllDataForPlot(driver):
    for i in range(2, 6):
        ClickElementIfVis(driver, By.XPATH, '{0}[{1}]'.format(LAND_INFO_MENU_ITEM_PATH,i))
        eles = GetElesIfVis(driver, By.XPATH,LAND_INFO_PLOT_INFO_PATH)
        for ele in eles:
            ele.click()
        ClickElementIfVis(driver, By.XPATH, LAND_INFO_BACK_BUTTON)                        
def ReviewPlot(driver, Airplane, PlotName):
    ClickElementIfVis(driver, By.XPATH, '{0}{1}'.format(LAND_INFO_MENU_ITEM_PATH,'[9]'))
    ClickElementIfVis(driver, By.XPATH,LAND_INFO_SUBMIT_PLOT_BUTTON)
    MessageEle = GetEleIfVis(driver, By.XPATH,LAND_INFO_POPUP_BODY_MESSAGE)
    MessageText = MessageEle.text
    if("The following are required for upload:" in MessageText):
        FindErrors(driver)
        return
    ClickElementIfVis(driver, By.XPATH,POSTIVE_POPUP_BUTTON)
    WaitForLoad(driver)
    MessageEle = GetEleIfVis(driver, By.XPATH,LAND_INFO_POPUP_BODY_MESSAGE)
    Text = MessageEle.text
    #if Airplane:
    if ( not DICT_MESSAGES_NO_DATA_KEY[Airplane]["SubmitPlotText"] in Text):
         LogError(DICT_OUTPUT_MESSAGE_NO_DATA_KEY[Airplane]["PlotUnsucess"])
        #log.error( "Error, no connectivity and plot was not flagged for upload" )
    else:
        log.info(DICT_OUTPUT_MESSAGE_NO_DATA_KEY[Airplane]["PlotSucess"].format(PlotName))
        #log.info("{0} Flagged for Background upload".format(PlotName))
    #else:
        #if ( not "Plot is submitted" == Text):
            #log.error( "Error, Plot was not submitted" )
        #else:
            #log.info("{0} was submitted".format(PlotName))
    ClickElementIfVis(driver, By.XPATH,POSTIVE_POPUP_BUTTON)
def FillPlotData(driver, Airplane = False, bFullPlot = False):
    #fill plot info
    PlotName = FillPlotInputs(driver)
    if(bFullPlot):
        FillAllDataForPlot(driver)
    else:
        #click Slope
        HandleSlope(driver)
        #click soil layer
        HandleSoilLayer(driver)
    #Review Plot
    ReviewPlot(driver, Airplane=Airplane, PlotName=PlotName)
    return PlotName
def SendTextToEle(weEle, strValue):
    log.info("Sending {0} to WebElement {1}".format(strValue, weEle))
    weEle.send_keys(strValue)
def LandCover(driver, plots, Airplane=False):
    try:
        ClickElementIfVis(driver, By.XPATH,POSTIVE_POPUP_BUTTON)
    except Exception:
        LogError( "Message regarding connectivity did not appear" )
    List = []
    for plot in plots:
        String = "{0}{1}".format(LANDCOVER_PLOT_LIST,"[contains(.,'{0}')]".format(plot))
        try:
            PlotFound = GetEleIfVis(driver, By.XPATH, String)
            log.info("Plot '{0}' found in landcover in airplane mode as expected".format(plot))
        except TimeoutException:
            LogError( "Plot '{0}' was not found in landcover in airplane mode.".format(plot) )
        
def WaitForLoad(driver):
    wait = WebDriverWait(driver, 30)
    wait.until(EC.presence_of_element_located((By.XPATH, "//div[@class='loading-container']")),"")
    wait.until(EC.invisibility_of_element_located((By.XPATH, "//div[@class='loading-container']")),"")
def SetUpApp(Test, AirplaneMode=False, bRobot = True, iConnection=None):
    if (bRobot):
        appiumLib = BuiltIn().get_library_instance('AppiumLibrary')
        if(len(appiumLib._cache.get_open_browsers()) > 0 and not hasattr(Test, "driver")):
            Test.driver = appiumLib._current_application()
        else:
            if(not hasattr(Test, "driver")):
                SetDriver(Test, AirplaneMode)
                appiumLib._cache.register(Test.driver, None)
    else:
        if(not hasattr(Test, "driver")):
            SetDriver(Test, AirplaneMode)
    try:
        ClickElementIfVis(Test.driver,By.CLASS_NAME,"android.widget.Image")
        HandleGoogleLogin(Test.driver)
    except TimeoutException as Te:
        log.info("Login not required")
    if(iConnection == None):
        SetConections(Test.driver, 1 if AirplaneMode else 6)
    else:
        SetConections(Test.driver, iConnectionMode=iConnection)
    win = Test.driver.window_handles
    Test.driver.switch_to.window(win[-1])
def TestCaps():
    caps = {}
    caps['browserName'] = ""
    caps['appiumVersion'] = "1.4.16"
    caps['deviceName'] = "Android Emulator"
    caps['deviceType'] = "phone"
    caps['deviceOrientation'] = "portrait"
    caps['platformVersion'] = "5.1"
    caps['platformName'] = "Android"
    return caps
def SetDriver(Test,AirplaneMode):
    desired_caps = {}
    desired_caps = TestCaps()
    #if not AirplaneMode:
    desired_caps['app'] = LAND_INFO_ANDROID_APP
    
    Test.driver = webdriver.Remote(command_executor=COMMAND_EXEC, 
                                      desired_capabilities=desired_caps)
    Test.driver.implicitly_wait(30)
def GetEleAttribIfVis(driver, ByType, Value, Attirb):
    wait = WebDriverWait(driver, TIMEOUT)
    wait.until(EC.visibility_of_element_located((ByType, Value)), "")
    return driver.find_element(ByType, Value) 
def GetEleIfVis(driver, ByType, Value):
    wait = WebDriverWait(driver, TIMEOUT)
    wait.until(EC.visibility_of_element_located((ByType, Value)), "")
    return driver.find_element(ByType, Value) 
def GetEleByTextValue(driver, byType, Xpath, TextValue):
    StringEle = "{0}{1}".format(Xpath,"[contains(.,'{0}')]".format(TextValue))
    wait = WebDriverWait(driver, TIMEOUT)
    wait.until(EC.visibility_of_element_located((ByType, StringEle)), "")
    return driver.find_element(ByType, StringEle) 
def WaitUntilElementLocated(driver, ByType, Value):
    wait = WebDriverWait(driver, TIMEOUT)
    wait.until(EC.visibility_of_element_located((ByType, Value)), "")
def GetElesIfVis(driver, ByType, Value):
    wait = WebDriverWait(driver, TIMEOUT)
    wait.until(EC.visibility_of_element_located((ByType, Value)), "")
    return driver.find_elements(ByType, Value)
def ClickElementIfVis(driver, ByType, Value):
    wait = WebDriverWait(driver, TIMEOUT)
    wait.until(EC.visibility_of_element_located((ByType, Value)), "")
    wait.until(EC.element_to_be_clickable((ByType, Value)), "")
    driver.find_element(ByType,Value).click()
def SwitchToPopupWindow(driver):
    curHandles = driver.window_handles
    wait = WebDriverWait(driver, TIMEOUT)
    wait.until(lambda driver: len(driver.window_handles) > 1)
    driver.switch_to.window(driver.window_handles[-1])
def HandleGoogleLogin(driver):
    driver.switch_to.context("WEBVIEW_org.landpotential.lpks.landcover")
    ClickElementIfVis(driver,By.XPATH,"//Button[@id='loginGoogleDevice']")
    SwitchToPopupWindow(driver)
    ele = GetEleIfVis(driver,By.ID,"Email")
    ele.send_keys("lpks.testing@gmail.com")
    ClickElementIfVis(driver,By.ID,"next")
    ele = GetEleIfVis(driver,By.ID,"Passwd")
    ele.send_keys("landpotentialtest")
    ClickElementIfVis(driver,By.ID,"signIn")
    ClickElementIfVis(driver,By.ID,"submit_approve_access")
    win = driver.window_handles
    driver.switch_to.window(win[0])
def SetConections(driver, iConnectionMode=6):
    curContext = driver.context
    driver.switch_to.context("NATIVE_APP")
    
    if not driver.network_connection == iConnectionMode:
        driver.mobile.set_network_connection(iConnectionMode)
    driver.switch_to.context(curContext)
def set_test_browser(remoteURL):
    appiumTesting().set_browser(remoteURL)
class appiumTesting:#(unittest.TestCase):
    plotNames = []
    def set_browser(self, remoteURL, **kwgs):
        appiumLib = BuiltIn().get_library_instance('AppiumLibrary')
        if(kwgs is None or len(kwgs) <= 0):
            log.info(kwgs)
            desired_caps = TestCaps()
            desired_caps['app'] = LAND_COVER_ANDROID_APP
            self.driver = webdriver.Remote(command_executor=remoteURL, 
                                           desired_capabilities=desired_caps)
            self.driver.implicitly_wait(30)
            appiumLib._cache.register(self.driver, None)
        else:
            appiumLib.open_application(remoteURL, **kwgs)
            self.driver = appiumLib._current_application()
            self.driver.implicitly_wait(30)
    def tearDown(self, PassOrFail = "PASS",bRobot = False):
        report_sauce_status("AppiumTesting", status=PassOrFail, tags="Appium", remote_url=COMMAND_EXEC, bRobot = False, driver = self.driver)
        self.driver.quit()
        if not(PassOrFail == "PASS")and bRobot:
            BuiltIn().fail("")
    def test_add_plot(self, bRobot = True):
        SetUpApp(self,bRobot=bRobot)
        #self.driver.start_activity(LAND_COVER_ANDROID_PACKAGE, LAND_COVER_ANDROID_ACTIVITY_NAME)
        #ClickElementIfVis(self.driver,By.CLASS_NAME,"android.widget.Image")
        #HandleGoogleLogin(self.driver)
        ClickElementIfVis(self.driver,By.XPATH,"//div[@nav-view='active']//img[@src='landpks_img/landinfo_logo.png']")
        log.info(  "Test 2.1 Pass" )
        WaitForLoad(self.driver)
        ClickElementIfVis(self.driver,By.XPATH,"//div[@nav-bar='active']//span[@class='right-buttons']/a[@class='button button-icon ion-plus-round']")
        ClickElementIfVis(self.driver, By.XPATH, "//a[@class='item item-icon-right plotname']")
        try:
            plotName = FillPlotData(self.driver)
            log.info( "Test 2.4 Pass" )
            self.plotNames.append(plotName)
            WaitForLoad(self.driver)
            ClickElementIfVis(self.driver, By.XPATH, LAND_INFO_BACK_BUTTON)
        except TimeoutException as TE:
            LogError("Timeout Exception {0}".format(TE.message))
            self.tearDown("Fail", bRobot=bRobot)
        except WebDriverException as WDE:
            LogError("WebDriver Exception {0}".format(WDE.message))
            self.tearDown("Fail", bRobot=bRobot)
    def test_add_plot_airplane_verify_it_appears_in_landcover(self, bRobot = True):
        SetUpApp(self, AirplaneMode=True, bRobot=bRobot, iConnection=1)
        #self.driver.close_app()
        #self.driver.start_activity(app_package=LAND_COVER_ANDROID_PACKAGE, app_activity=LAND_COVER_ANDROID_ACTIVITY_NAME)
        self.driver.switch_to.context("WEBVIEW_org.landpotential.lpks.landcover")
        win = self.driver.window_handles
        self.driver.switch_to.window(win[-1])
        ClickElementIfVis(self.driver,By.XPATH,"//div[@nav-view='active']//img[@src='landpks_img/landinfo_logo.png']")
        WaitForLoad(self.driver)
        try:
            ClickElementIfVis(self.driver, By.XPATH,POSTIVE_POPUP_BUTTON)
        except TimeoutException:
            LogError( "Message regarding connectivity did not appear" )
        ClickElementIfVis(self.driver,By.XPATH,"//div[@nav-bar='active']//span[@class='right-buttons']/a[@class='button button-icon ion-plus-round']")
        ClickElementIfVis(self.driver, By.XPATH, "//a[@class='item item-icon-right plotname']")
        try:
            plotName = FillPlotData(self.driver, True)
            self.plotNames.append(plotName)
            ClickElementIfVis(self.driver, By.XPATH, LAND_INFO_BACK_BUTTON)
            ClickElementIfVis(self.driver, By.XPATH, LAND_INFO_BACK_BUTTON)
            ClickElementIfVis(self.driver,By.XPATH,"//div[@nav-view='active']//img[@src='landpks_img/landcover_logo.png']")
            WaitForLoad(self.driver)
            LandCover(self.driver, self.plotNames, True)
            log.info( "Test 0.3 Pass" )
            if(bRobot):
                self.tearDown(bRobot=bRobot)
        except TimeoutException:
            LogError("TIMEOUT")
            self.tearDown("Fail", bRobot=bRobot)
        except WebDriverException:
            LogError("Web exception")
            self.tearDown("Fail", bRobot=bRobot)
    def check_interuptions(self):
        SetUpApp(self)
        os.system(command)
class Testing(unittest.TestCase):
    AppTest = appiumTesting()
    def tester(self):
        CheckSinglePlotUpload("nuhypc")
        self.AppTest.test_add_plot(bRobot=False)
        self.AppTest.test_add_plot_airplane_verify_it_appears_in_landcover(bRobot=False)
    def tearDown(self):
        self.AppTest.tearDown()
if __name__ == '__main__':
    suite = unittest.TestLoader().loadTestsFromTestCase(Testing)
    unittest.TextTestRunner(verbosity=2).run(suite)
    #os.system("echo %CD%")
    #os.system("pybot ../AppiumTest.robot")