'''
Created on Jun 23, 2016

@author: bbarnett
'''
import os
import random
import re
import unittest
from appium import webdriver
from appium.webdriver.webelement import WebElement
import requests
from robot.api import logger as log
from robot.libraries.BuiltIn import BuiltIn
from selenium.common.exceptions import TimeoutException, \
    ElementNotSelectableException, WebDriverException
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.wait import WebDriverWait

from Utils import GenRandString
from Utils import GetSauceCreds
from Utils import SelectBoxSelectRand
import simplejson as json


REQUEST_STRING_TO_FIND_PLOT = "http://api.landpotential.org/query?version=0.1&action=get&object=landinfo&type=get_by_pair_name_recorder_name&name={0}&recorder_name=lpks.testing%40gmail.com"
SAUCE_ACCESS_KEY = 'Barnebre:216526d7-706f-4eff-bf40-9d774203e268'
LAND_INFO_ANDROID_APP = 'http://128.123.177.36:8080/job/LandInfo_Mobile_Andoird_App/ws/platforms/android/build/outputs/apk/android-debug.apk'
LAND_COVER_ANDROID_APP = 'http://128.123.177.36:8080/job/LandCover_Mobile_Andoird_App/ws/platforms/android/build/outputs/apk/android-debug.apk'
LAND_COVER_ANDROID_PACKAGE = 'org.landpotential.lpks.landcover'
#LAND_COVER_ANDROID_PACKAGE = 'org.apache.cordova.splashscreen'
LAND_COVER_ANDROID_ACTIVITY_NAME = '.MainActivity'
#LAND_COVER_ANDROID_ACTIVITY_NAME = '.SpashScreen'
LAND_INFO_WEBVIEW_NAME = "WEBVIEW_org.landpotential.lpks.landcover"
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
#LAND_COVER_FOLIGAE_COVER_ROW = "//ion-view[@cache-view='false']//div[@class='scroll']//div[@class='row']"
LAND_COVER_FOLIGAE_COVER_ROW = "//ion-view[@cache-view='false']//div[@class='scroll']/div[@class='row'][@style='height:100px;']"
LAND_COVER_SUBMIT_BUTTON = "//ion-view[@cache-view='false']//div[@class='scroll']//button[@id='btnSubmitLandCover']"
LAND_COVER_FOLIGAE_COL_IMAGE_PATH = "/div[@class='col col-20']"
LAND_COVER_SITE_SUMMARY = "//div[@class='scroll']/h2[contains(.,'Site Summary')]"
DICT_MESSAGES_NO_DATA_KEY = {
                 False: {"SubmitPlotText" : "Plot is submitted"},
                 True:{"SubmitPlotText" : "background upload"}
                 }
DICT_OUTPUT_MESSAGE_NO_DATA_KEY =   {
                                   True : {"PlotUnsucess" : "Error, no connectivity and plot was not flagged for upload",
                                           "PlotSucess" : "Test 2.4.9.1 passed. {0} Flagged for Background upload"},
                                   False: {"PlotSucess" : "Test 2.4.9.1 passed. {0} was submitted",
                                           "PlotUnsucess" : "Error, Plot was not submitted"},
                                   "LandCover": {"PlotSucess" : "Landcover for plot {0} was submitted and site summary properly displayed",
                                                 "PlotUnsucess" : "Error, Plot was not submitted in landcover and site summary did not appear"}           
                                   
                                    }
DICT_TEST_MESSAGES_KEY_MENU_NUM = {
                                   2 : {"TestName" : "2.4.2"},
                                   3 : {"TestName" : "2.4.3"},
                                   4 : {"TestName" : "2.4.4"},                                           
                                   5 : {"TestName" : "2.4.5"},
                                   6 : {"TestName" : "2.4.6"}
                                   }
LAND_COVER_HEADINGS = {
                        "North" :{"ElementXpath" : "//img[@id='imgNorth']"},
                        "East" :{"ElementXpath" : "//img[@id='imgEast']"},
                        "South" :{"ElementXpath" : "//img[@id='imgSouth']"},
                        "West" :{"ElementXpath" : "//img[@id='imgWest']"},
                        }
#COMMAND_EXEC = 'http://localhost:4723/wd/hub'
# Returns abs path relative to this file and not cwd
ERRORS = []
SUCCESS = []
PLOT_INFO_PLOTNAME_KEY = {}
PATH = lambda p: os.path.abspath(
    os.path.join(os.path.dirname(__file__), p)
)
def CheckSinglePlotUpload(plotName):
    url = REQUEST_STRING_TO_FIND_PLOT.format(plotName)
    response = requests.put(url)
    if not response.status_code == 200:
        LogError("API didn't respond successfully with URL {0}".format(url))
    else:
        data = json.loads(response.text)
        if(len(data) <= 0):
            LogError("Database didn't find plot {0}".format(plotName))
def OutputErrors(ErrorList):
    if(len(ErrorList)> 0 ):
        log.error("Encountered {0} recoverable errors or inconsistancies they are as follows".format(len(ErrorList)))
        for error in ErrorList:
            log.error(error)
    ErrorList = []
def OutputSucessful(SuccessList):
    if(len(SuccessList) > 0 ):
        log.info("{0} sucessful activies.".format(len(SuccessList)))
        for Msg in SuccessList:
            log.info(Msg)
    SuccessList = []    
def LogError(errorMessage):
    log.error(errorMessage)
    ERRORS.append(errorMessage)
def LogSuccess(errorMessage):
    SUCCESS.append(errorMessage)
def ProcLandCover(driver):
    for Heading in LAND_COVER_HEADINGS:
        ClickElementIfVis(driver, By.XPATH, LAND_COVER_HEADINGS[Heading]["ElementXpath"])
        Distances = GetElesIfVis(driver, By.XPATH, LAND_INFO_MENU_ITEM_PATH)
        for iDist in range(1,len(Distances)+1):
            ClickElementIfVis(driver, By.XPATH, "{0}[{1}]".format(LAND_INFO_MENU_ITEM_PATH,iDist))
            LandCoverRows = GetElesIfVis(driver, By.XPATH, LAND_COVER_FOLIGAE_COVER_ROW)
            RowXpath = "{0}[{1}]".format(LAND_COVER_FOLIGAE_COVER_ROW,1)
            ColXpath = "{0}{1}".format(RowXpath,LAND_COVER_FOLIGAE_COL_IMAGE_PATH)
            ColCount = len(GetElesIfVis(driver, By.XPATH, ColXpath))
            for iCol in range(1,ColCount+1):
                RowXpath = "{0}[{1}]".format(LAND_COVER_FOLIGAE_COVER_ROW,1)#random.randint(1,len(LandCoverRows)))
                ColXpath = "{0}{1}".format(RowXpath,LAND_COVER_FOLIGAE_COL_IMAGE_PATH)
                RandCoverType = "{0}[{1}]/img".format(ColXpath,iCol)#random.randint(1,ColCount))
                ClickElementIfVis(driver, By.XPATH, RandCoverType)
            ClickElementIfVis(driver, By.XPATH, LAND_INFO_BACK_BUTTON)
        ClickElementIfVis(driver, By.XPATH, LAND_INFO_BACK_BUTTON)
def report_sauce_status(name, status, tags=[], remote_url='', bRobot = True, driver = None):
    # Parse username and access_key from the remote_url
    if(len(ERRORS) > 0 ):
        name.join("| {0} errors encountered" .format(len(ERRORS)))
    username, access_key = USERNAME_ACCESS_KEY.findall(remote_url)[0][1:]

    # Get selenium session id from the keyword library
    if(bRobot):
        appium = BuiltIn().get_library_instance('AppiumLibrary')
        name = BuiltIn().get_variable_value("${TEST_NAME}")
        job_id = appium._current_application().session_id
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
    PlotLat = ""
    PlotLong = ""
    inputs = driver.find_elements_by_tag_name("input")
    for eleInput in inputs:
        EleType = eleInput.get_attribute("type")
        if(EleType == "text"):
            Data = GenRandString()
            if(eleInput.get_attribute("id") == "name"):
                PlotName = Data
                LogSuccess("Test 2.4.1.1 Passed")
            else:
                LogSuccess("Test 2.4.1.2 Passed")
            SendTextToEle(eleInput,Data)
            
        elif(EleType == "number"):
            Data = GenRandString("loc")
            if(eleInput.get_attribute("id") == "latitude"):
                PlotLat = Data
            if(eleInput.get_attribute("id") == "longitude"):
                PlotLong = Data
            LogSuccess("Test 2.4.1.3.3 Passed")
            SendTextToEle(eleInput,Data)
        elif(EleType == "radio" and eleInput.get_attribute("value") == "small"):
            eleInput.click()
            LogSuccess("Test 2.4.1.3 Passed")
    ClickElementIfVis(driver, By.XPATH, LAND_INFO_BACK_BUTTON)
    PLOT_INFO_PLOTNAME_KEY[PlotName] = {"latitude" : PlotLat,
                                        "longitude" : PlotLong
                                        }
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
    for ele in eles:
        ele.click()
        break
    ClickElementIfVis(driver, By.XPATH, LAND_INFO_BACK_BUTTON)
def FillAllDataForPlot(driver):
    for i in range(2, 7):
        try:
            ClickElementIfVis(driver, By.XPATH, '{0}[{1}]'.format(LAND_INFO_MENU_ITEM_PATH,i))
            eles = GetElesIfVis(driver, By.XPATH,LAND_INFO_PLOT_INFO_PATH)
            for ele in eles:
                ele.click()
            LogSuccess("Test {0} Passed".format(DICT_TEST_MESSAGES_KEY_MENU_NUM[i]["TestName"]))
        except :
            LogError("Test {0} Failed".format(DICT_TEST_MESSAGES_KEY_MENU_NUM[i]["TestName"]))
            continue
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
        LogSuccess(DICT_OUTPUT_MESSAGE_NO_DATA_KEY[Airplane]["PlotSucess"].format(PlotName))
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
    for plot in plots:
        String = "{0}{1}".format(LANDCOVER_PLOT_LIST,"[contains(.,'{0}')]".format(plot))
        try:
            PlotFound = GetEleIfVis(driver, By.XPATH, String)
            LogSuccess("Plot '{0}' found in landcover in airplane mode as expected".format(plot))
            PlotFound.click()
            ProcLandCover(driver)
            ClickElementIfVis(driver, By.XPATH, LAND_COVER_SUBMIT_BUTTON)
            MessageEle = GetEleIfVis(driver, By.XPATH,LAND_INFO_POPUP_BODY_MESSAGE)
            MessageText = MessageEle.text
            if(not "Do you want to submit it" in MessageText):
                LogError("Land Cover did not accept Data of: all bare ground")
                return
            ClickElementIfVis(driver, By.XPATH,POSTIVE_POPUP_BUTTON)
            if(Airplane):
                MessageEle = GetEleIfVis(driver, By.XPATH,LAND_INFO_POPUP_BODY_MESSAGE)
                MessageText = MessageEle.text
                if("Transect data has been marked for background upload" in MessageText):
                    LogSuccess("Land cover {0} has been submitted for background upload")
                ClickElementIfVis(driver, By.XPATH,POSTIVE_POPUP_BUTTON)
            WaitForLoad(driver)
            MessageEle = GetEleIfVis(driver, By.XPATH,LAND_COVER_SITE_SUMMARY)
            Text = MessageEle.text
            #if Airplane:
            if ( not Text == "Site Summary"):
                LogError(DICT_OUTPUT_MESSAGE_NO_DATA_KEY["LandCover"]["PlotUnsucess"])
            else:
                LogSuccess(DICT_OUTPUT_MESSAGE_NO_DATA_KEY["LandCover"]["PlotSucess"].format(plot))
                ClickElementIfVis(driver, By.XPATH, LAND_INFO_BACK_BUTTON)
        except TimeoutException:
            LogError( "Plot '{0}' was not found in landcover in airplane mode.".format(plot) )
    ClickElementIfVis(driver, By.XPATH, LAND_INFO_BACK_BUTTON)
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
def GetEleByTextValue(driver, ByType, Xpath, TextValue):
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
    try:
        wait = WebDriverWait(driver, TIMEOUT)
        #wait.until(EC.presence_of_element_located((ByType, Value)), "")
        wait.until(EC.visibility_of_element_located((ByType, Value)), "")
        wait.until(EC.element_to_be_clickable((ByType, Value)), "")
        driver.find_element(ByType,Value).click()
    except TimeoutException as TE:
        log.error("Timeout exception/ Element not found while searching for element {0} by {1}".format(Value,ByType))
        raise TimeoutException
    except WebDriverException as WDE:
        log.error("WebDriver exception unknown error while finding element {0} by {1}".format(Value,ByType))
        raise Exception
def SwitchToPopupWindow(driver):
    wait = WebDriverWait(driver, TIMEOUT)
    wait.until(lambda driver: len(driver.window_handles) > 1)
    driver.switch_to.window(driver.window_handles[-1])
def HandleGoogleLogin(driver):
    try:
        driver.switch_to.context(LAND_INFO_WEBVIEW_NAME)
        ClickElementIfVis(driver,By.XPATH,"//Button[@id='loginGoogleDevice']")
        LogSuccess("Test 2.1.1 Passed")
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
    except:
        LogError("Google login unsuccessful")
        
        raise Exception
def SetConections(driver, iConnectionMode=6):
    curContext = driver.context
    driver.switch_to.context("NATIVE_APP")
    
    if not driver.network_connection == iConnectionMode:
        driver.mobile.set_network_connection(iConnectionMode)
    driver.switch_to.context(curContext)
def set_test_browser(remoteURL):
    Test_Case().set_browser(remoteURL)
class Test_Case:#(unittest.TestCase):
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
        
        if(bRobot):
            appiumLib = BuiltIn().get_library_instance('AppiumLibrary')
            appiumLib._cache.close_all()
            self.driver=None
            if (not PassOrFail == "PASS"):
                BuiltIn().fail("")
        else:
            self.driver.quit()
            
    def Test_Case_2(self, bRobot = True):
        #log in
        try:
            SetUpApp(self,bRobot=bRobot)
            ClickElementIfVis(self.driver,By.XPATH,"//div[@nav-view='active']//img[@src='landpks_img/landinfo_logo.png']")
        except:
            LogError("Test 2.1 Failed")
        finally:
            OutputErrors(ERRORS)
            OutputSucessful(SUCCESS)
        #2.4 create plot
    def Test_Case_3(self, bRobot = True):
        SetUpApp(self,bRobot=bRobot)
        #LandCover
    def Test_Case_2_4(self, bRobot = True):
        try:
            PassOrFail = "PASS"
            SetUpApp(self,bRobot=bRobot)
            if(bRobot):
                appiumLib = BuiltIn().get_library_instance('AppiumLibrary')
                if(len(appiumLib._cache.get_open_browsers()) > 0 and not hasattr(self, "driver")):
                    self.driver = appiumLib._current_application()
            WaitForLoad(self.driver)
            ClickElementIfVis(self.driver,By.XPATH,"//div[@nav-bar='active']//span[@class='right-buttons']/a[@class='button button-icon ion-plus-round']")
            ClickElementIfVis(self.driver, By.XPATH, "//a[@class='item item-icon-right plotname']")
            LogSuccess("Test 2.4.1 Passed")
            PlotName = FillPlotInputs(self.driver)
            FillAllDataForPlot(self.driver)
            #click Slope
            #try:
            #    HandleSlope(self.driver)
            #    LogSuccess("Test 2.4.4 Passed")
            #except:
            #    LogError("Test 2.4.4 Failed")
            #click soil layer
            
            try:
                HandleSoilLayer(self.driver)
                LogSuccess("Test 2.4.7 Passed")
            except:
                LogError("Test 2.4.7 Failed")
                PassOrFail = "FAIL"
            try:
                #Review Plot
                ReviewPlot(self.driver, False, PlotName)
                LogSuccess("Test 2.4.9 Passed")
            except:
                LogError("Test 2.4.9 Failed")
                PassOrFail = "FAIL"
        finally:
            OutputErrors(ERRORS)
            OutputSucessful(SUCCESS)
            self.tearDown(PassOrFail, bRobot)
    def Test_Case_0(self, bRobot = True):
        try:
            self.test_add_plot_airplane_verify_it_appears_in_landcover(bRobot)
            LogSuccess("Test 0.1 Passed")
            LogSuccess("Test 0.2 Passed")
            LogSuccess("Test 0.3 Passed")
            self.tearDown("PASS", bRobot)
        except:
            LogError("Test 0.3 Failed")
            self.tearDown("FAIL", bRobot)
        finally:
            OutputErrors(ERRORS)
            OutputSucessful(SUCCESS)
            
            
    def test_add_plot_airplane_verify_it_appears_in_landcover(self, bRobot = True):
        SetUpApp(self, AirplaneMode=True, bRobot=bRobot, iConnection=1)
        #self.driver.close_app()
        #self.driver.start_activity(app_package=LAND_COVER_ANDROID_PACKAGE, app_activity=LAND_COVER_ANDROID_ACTIVITY_NAME)
        self.driver.switch_to.context(LAND_INFO_WEBVIEW_NAME)
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
            LogSuccess( "Test 0.3 Pass" )
            if(bRobot):
                self.tearDown(bRobot=bRobot)
        except TimeoutException:
            LogError("TIMEOUT")
            self.tearDown("Fail", bRobot=bRobot)
        except WebDriverException:
            LogError("Web exception")
            self.tearDown("Fail", bRobot=bRobot)
        OutputErrors(ERRORS)
        OutputSucessful(SUCCESS)
    def check_interuptions(self):
        SetUpApp(self)
        #os.system(command)
class Testing(unittest.TestCase):
    AppTest = Test_Case()
    def tester(self):
        self.AppTest.Test_Case_0(False)
        self.AppTest.Test_Case_2(False)
        self.AppTest.Test_Case_2_4(False)
        #self.AppTest.test_add_plot(bRobot=False)
        #self.AppTest.test_add_plot_airplane_verify_it_appears_in_landcover(bRobot=False)
    def tearDown(self):
        self.AppTest.tearDown()
if __name__ == '__main__':
    suite = unittest.TestLoader().loadTestsFromTestCase(Testing)
    unittest.TextTestRunner(verbosity=2).run(suite)
    #os.system("echo %CD%")
    #os.system("pybot ../AppiumTest.robot")