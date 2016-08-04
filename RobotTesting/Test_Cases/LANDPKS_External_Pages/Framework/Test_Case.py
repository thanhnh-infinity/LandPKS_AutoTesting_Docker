'''
Created on Jun 23, 2016

@author: bbarnett
'''
import time
import datetime
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
from Utils import GenDynaWebAppTestsAppend
from Utils import get_uname_and_pword_lpks_gmail
from selenium import webdriver as selWebDriver


REQUEST_STRING_TO_FIND_PLOT = "http://api.landpotential.org/query?version=0.1&action=get&object=landinfo&type=get_by_pair_name_recorder_name&name={0}&recorder_name=lpks.testing%40gmail.com"
SAUCE_ACCESS_KEY = 'Barnebre:216526d7-706f-4eff-bf40-9d774203e268'
LAND_INFO_ANDROID_APP = 'http://128.123.177.36:8080/job/LandInfo_Mobile_Andoird_App/ws/platforms/android/build/outputs/apk/android-debug.apk'
LAND_COVER_ANDROID_APP = 'http://128.123.177.36:8080/job/LandCover_Mobile_Andoird_App/ws/platforms/android/build/outputs/apk/android-debug.apk'
LAND_COVER_ANDROID_PACKAGE = 'org.landpotential.lpks.landcover'
LAND_INFO_ADD_PLOT_BUTTON = "//div[@nav-bar='active']//span[@class='right-buttons']/a[@class='button button-icon ion-plus-round']"
LAND_INFO_SETTINGS_BUTTON = "//div[@nav-bar='active']//span[@class='right-buttons']/a[@class='button button-icon ion-gear-b']"
LAND_INFO_LOGOUT_LINK = "//div[@nav-view='active']//div[@class='scroll']/a[@ng-click='landinfo_logout();']"
LAND_INFO_WORLD_MAP_BUTTON = "//div[@nav-bar='active']//span[@class='right-buttons']/a[@class='button button-icon ion-ios-world']"
LAND_INFO_LOCAL_CLIMATE_BUTTON = "//div[@nav-bar='active']//span[@class='right-buttons']/a[@class='button button-icon ion-ios-rainy']"
#LAND_COVER_ANDROID_PACKAGE = 'org.apache.cordova.splashscreen'
LAND_COVER_ANDROID_ACTIVITY_NAME = '.MainActivity'
LAND_INFO_FOOTER = "//ion-view[@cache-view='false']//ion-footer-bar"
#LAND_COVER_ANDROID_ACTIVITY_NAME = '.SpashScreen'
LAND_INFO_WEBVIEW_NAME = "WEBVIEW_org.landpotential.lpks.landcover"
LAND_INFO_BACK_BUTTON = "//div[@nav-bar='active']//a[@class='button button-icon']"
LAND_INFO_MENU_ITEM_PATH = "//ion-view[@cache-view='false']//div[@class='scroll']/a"
LAND_INFO_PLOT_INFO_PATH = "//ion-view[@cache-view='false']//div[@class='scroll']//div[contains(@class,'col col-5')]/img"
LAND_INFO_ROCK_FRAGEMENT_CONTENT = "//ion-view[@cache-view='false']//div[@class='scroll']//div[@class='lpks-select']"
LAND_INFO_POPUP_ROCK_BODY = "//div[@class='popup-body']//ion-view[@cache-view='false']"
LAND_INFO_POPUP_ROCK_CONTENT = "//a[@class='item item-icon-right']"
LAND_INFO_SOIL_TYPE = "//ion-view[@cache-view='false']//div[@class='scroll']//div[@class='othercomponent']/select[@ng-model='texture_value']"
LAND_INFO_SOIL_TYPE_GUIDE_ME = "//ion-view[@cache-view='false']//div[@class='scroll']//div[@class='othercomponent']/button[@class='button button-balanced button-small']"
LAND_INFO_SOIL_TYPE_GUIDE_ME_CATES = "//div[@nav-view='active']//div[@class='scroll']/div"
LAND_INFO_SUBMIT_PLOT_BUTTON = "//div[@nav-view='active']//div[@class='scroll']//button[@id='btnSubmitPlot_1']"
POSTIVE_POPUP_BUTTON = "//div[@class='popup-buttons']/button[@class='button ng-binding button-positive']"
NEGATIVE_POPUP_BUTTON = "//div[@class='popup-buttons']/button[@class='button ng-binding button-default']"
GENERIC_POPUP_BUTTON = "//div[@class='popup-buttons']/button"
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
LAND_INFO_LOCAL_CLIMATE_GRAPH = "//div[@nav-view='active']//div[@class='scroll']//div[@class='lpks-graph']/div[@class='chart-container']/canvas[@id='bar']"
LAND_INFO_LOCAL_CLIMATE_LAT = "//div[@class='scroll']/p[contains(.,'Latitude')]"
TITLE_LAND_INFO_PAGE_XPATH = LAND_INFO_BACK_BUTTON + "/p"
DICT_MESSAGES_NO_DATA_KEY = {
                 False: {"SubmitPlotText" : "Plot is submitted"},
                 True:{"SubmitPlotText" : "background upload"}
                 }
DICT_ELEMENT_PATH_TO_NAME = {
                             LAND_INFO_BACK_BUTTON : "Back button",
                             LAND_INFO_LOCAL_CLIMATE_GRAPH: "Climate Chart",
                             LAND_INFO_SUBMIT_PLOT_BUTTON : "Land info submit button",
                             POSTIVE_POPUP_BUTTON : "Ok button on popup",
                             LAND_INFO_POPUP_BODY_MESSAGE : "Popup message",
                             LAND_COVER_SUBMIT_BUTTON : "Submit Land Cover Button"
                             }
DICT_VIDEO_SRC_TO_TEST = {
                          "SoilBallHQ.mp4" :" Test 2.4.7.{0}.2.2.1.1 Pass",
                          "RibbonHQ.mp4" : "Test 2.4.7.{0}.2.2.2.1 Pass",
                          "RibbonLengthHQ.mp4" : "Test 2.4.7.{0}.2.2.3.1 Pass",
                          "SmoothHQ.mp4" : "Test 2.4.7.{0}.2.2.4.1 Pass"
                          }
DICT_OUTPUT_MESSAGE_NO_DATA_KEY =   {
                                   True : {"PlotUnsucess" : "Error, no connectivity and plot was not flagged for upload",
                                           "PlotSucess" : "Test 2.4.9.1 Pass. {0} Flagged for Background upload"},
                                   False: {"PlotSucess" : "Test 2.4.9.1 Pass. {0} was submitted",
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
WARNS = []
PLOT_INFO_PLOTNAME_KEY = {}
START_TIME = {}
PATH = lambda p: os.path.abspath(
    os.path.join(os.path.dirname(__file__), p)
)
def goToAppSelection(driver):
    GoBackToPageWithTitle(driver, "Application Selection")
def GoBackToPageWithTitle(driver,Title):
    TitleText = GetEleIfVis(driver, By.XPATH,TITLE_LAND_INFO_PAGE_XPATH ).text
    while (not(TitleText in Title) and not("Application Selection" in TitleText) ):
        ClickGoBackLandInfo(driver)
        TitleText = GetEleIfVis(driver, By.XPATH,TITLE_LAND_INFO_PAGE_XPATH ).text
def ClickGoBackLandInfo(driver):
    ClickElementIfVis(driver, By.XPATH, LAND_INFO_BACK_BUTTON)
    WaitForLoad(driver)
def HandleLogout(driver):
    ClickElementIfVis(driver, By.XPATH, LAND_INFO_SETTINGS_BUTTON)
    try:
        ClickElementIfVis(driver, By.XPATH, LAND_INFO_LOGOUT_LINK)
        PopUpBody = GetEleIfVis(driver, By.XPATH, LAND_INFO_POPUP_BODY_MESSAGE)
        Message = PopUpBody.text
        if("Do you want to sign out account" in Message):
            ClickElementIfVis( driver, By.XPATH, NEGATIVE_POPUP_BUTTON)
            ClickElementIfVis(driver, By.XPATH, LAND_INFO_LOGOUT_LINK)
            ClickElementIfVis(driver, By.XPATH, POSTIVE_POPUP_BUTTON)
            TitleText = GetEleIfVis(driver, By.XPATH,TITLE_LAND_INFO_PAGE_XPATH ).text
            if("Accounts" in TitleText):
                LogSuccess("Test 2.1.4 Pass")
            else:
                LogError("Logout was successful but didn't go back to accounts screen. Test 2.1.4 Fail")
        else:
            LogError("Logout account button didn't function properly")
    except Exception:
        goToAppSelection(driver)
        raise TestFailedException("Test 2.1.4 Fail")
def CheckClimate(driver):
    try:
        Chart = GetEleIfVis(driver, By.XPATH, LAND_INFO_LOCAL_CLIMATE_GRAPH)
    except:
        LogError("Climate Information not present, climate graph did not load")
    try:
        Lat = GetEleIfVis(driver, By.XPATH, LAND_INFO_LOCAL_CLIMATE_LAT)
        strLat = Lat.text
        LatNumStr = strLat.split(":")[-1]
        LatNumStr = LatNumStr.strip()
        LatNum = float(LatNumStr)
        LogSuccess("Test 2.3 Pass")
        LogSuccess("Test 2.3.1 Pass")
        LogSuccess("Test 2.3.1.2 Pass")
    except:
        LogError("Test 2.3 Failed")
        LogError("Test 2.3.1 Failed")
        LogError("Test 2.3.1.2 Failed")
        raise TestFailedException("Climate data not present. Location wasn't detected.")
def CheckSinglePlotUpload(plotName):
    url = REQUEST_STRING_TO_FIND_PLOT.format(plotName)
    response = requests.put(url)
    if not response.status_code == 200:
        LogError("API didn't respond successfully with URL {0}".format(url))
    else:
        data = json.loads(response.text)
        if(len(data) <= 0):
            LogError("Database didn't find plot {0}".format(plotName))
def OutputErrors():
    global ERRORS
    if(len(ERRORS)> 0 ):
        log.error("Encountered {0} error(s).".format(len(ERRORS)))
        for error in ERRORS:
            log.error(error)
def OutputWarns():
    global WARNS
    if(len(WARNS)> 0 ):
        log.warn("Encountered {0} recoverable errors or inconsistancies they are as follows".format(len(WARNS)))
        for warn in WARNS:
            log.warn(warn)
def OutputSucessful():
    global SUCCESS
    if(len(SUCCESS) > 0 ):
        log.info("{0} sucessful activies.".format(len(SUCCESS)))
        for Msg in SUCCESS:
            log.info(Msg)
def LogError(errorMessage):
    global ERRORS
    Start = START_TIME["START"]
    TimeHappened = datetime.datetime.now() - Start
    log.error("{0} at {1} in video.".format(errorMessage, TimeHappened))
    ERRORS.append("{0} at {1} in video.".format(errorMessage, TimeHappened))
def LogWarn(warnMessage):
    global WARNS
    Start = START_TIME["START"]
    TimeHappened = datetime.datetime.now() - Start
    log.warn("{0} at {1} in video.".format(warnMessage, TimeHappened))
    WARNS.append("{0} at {1} in video.".format(warnMessage, TimeHappened))
def LogSuccess(errorMessage):
    global SUCCESS
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
            ClickGoBackLandInfo(driver)
        ClickGoBackLandInfo(driver)
def report_sauce_status(name, status, tags=[], remote_url='', bRobot = True, driver = None):
    # Parse username and access_key from the remote_url
    if(len(ERRORS) > 0 ):
        name.join("| {0} errors encountered" .format(len(ERRORS)))
    username, access_key = USERNAME_ACCESS_KEY.findall(remote_url)[0][1:]
    if(bRobot):
        name = "{0} | {1}".format(BuiltIn().get_variable_value("${SUITE_NAME}"),BuiltIn().get_variable_value("${TEST_NAME}"))
    # Get selenium session id from the keyword library
    #if(bRobot):
        #appium = BuiltIn().get_library_instance('AppiumLibrary')
        #name = BuiltIn().get_variable_value("${TEST_NAME}")
        #job_id = appium._current_application().session_id
    #else :
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
    log.info("Adding new Plot using landinfo tab")
    try:
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
                    LogSuccess("Test 2.4.1.1 Pass")
                else:
                    LogSuccess("Test 2.4.1.2 Pass")
                SendTextToEle(eleInput,Data)
                
            elif(EleType == "number"):
                Data = GenRandString("loc")
                if(eleInput.get_attribute("id") == "latitude"):
                    PlotLat = Data
                if(eleInput.get_attribute("id") == "longitude"):
                    PlotLong = Data
                    LogSuccess("Test 2.4.1.3.3 Pass")
                SendTextToEle(eleInput,Data)
            elif(EleType == "radio" and eleInput.get_attribute("value") == "small"):
                eleInput.click()
                LogSuccess("Test 2.4.1.3 Pass")
    except:
        LogError("New plot could not be created in Landinfo")
    ClickGoBackLandInfo(driver)
    PLOT_INFO_PLOTNAME_KEY[PlotName] = {"latitude" : PlotLat,
                                        "longitude" : PlotLong
                                        }
    return PlotName
def HandleSoilLayer(driver,plotName,bAllLayers = False):
    if(bAllLayers):
        ClickElementIfVis(driver, By.XPATH, '{0}{1}'.format(LAND_INFO_MENU_ITEM_PATH,'[7]'))
        Layers = GetElesIfVis(driver, By.XPATH, LAND_INFO_MENU_ITEM_PATH)
        for Layer in range(1,len(Layers) + 1):
            ClickElementIfVis(driver, By.XPATH, '{0}[{1}]'.format(LAND_INFO_MENU_ITEM_PATH,Layer))
            _HandleIndividualLayer(driver,plotName, Layer)
    else:
        ClickElementIfVis(driver, By.XPATH, '{0}{1}'.format(LAND_INFO_MENU_ITEM_PATH,'[7]'))
        #click first soil layer
        ClickElementIfVis(driver, By.XPATH, '{0}{1}'.format(LAND_INFO_MENU_ITEM_PATH,'[1]'))
        _HandleIndividualLayer(driver, plotName, 1)
    #Go back to main page
    GoBackToPageWithTitle(driver," {0}".format(plotName))
def _HandleIndividualLayer(driver,plotName,iSoilLayer):
    #Click Rock Fragment content
    ClickElementIfVis(driver, By.XPATH, LAND_INFO_ROCK_FRAGEMENT_CONTENT)
    LogSuccess("Test 2.4.7.{0}.1 Pass".format(iSoilLayer))
    #select Fragment Content
    eles = GetElesIfVis(driver, By.XPATH,'{0}{1}'.format(LAND_INFO_POPUP_ROCK_BODY, LAND_INFO_POPUP_ROCK_CONTENT))
    eles[random.randint(0,3)].click()
    #Select which soil type
    SelectBoxSelectRand(driver,By.XPATH,LAND_INFO_SOIL_TYPE)
    try:
        ClickElementIfVis(driver, By.XPATH, LAND_INFO_SOIL_TYPE_GUIDE_ME)
        CategoriesGuideME = GetElesIfVis(driver, By.XPATH, LAND_INFO_SOIL_TYPE_GUIDE_ME_CATES)
        if(len(CategoriesGuideME) > 0):
            for Category in range(1,len(CategoriesGuideME) +1):
                VideoXpath = "{0}[{1}]//div[@class='buttons']/img".format(LAND_INFO_SOIL_TYPE_GUIDE_ME_CATES,Category)
                CheckVideo(driver,By.XPATH,VideoXpath,iSoilLayer)
                if(Category >= len(CategoriesGuideME)):
                    break
                RadiosXpath = "{0}[{1}]//input[@type='radio']".format(LAND_INFO_SOIL_TYPE_GUIDE_ME_CATES,Category)
                Radios = GetElesIfVis(driver, By.XPATH, RadiosXpath)
                if(len(Radios) == 2):
                    Radios[-1].click() #click no
                    Texture = GetEleIfVis(driver, By.XPATH, "{0}//h5[@id='textureValue']".format(LAND_INFO_FOOTER)).text
                    Radios[0].click()
                elif(len(Radios) == 3):
                    RadiosNextCatXpath = "{0}[{1}]//input[@type='radio']".format(LAND_INFO_SOIL_TYPE_GUIDE_ME_CATES,Category + 1)
                    RadiosNextCat = driver.find_elements(By.XPATH,RadiosNextCatXpath)
                    for radioThisCat in Radios:
                        radioThisCat.click()
                        RadiosNextCat = driver.find_elements(By.XPATH,RadiosNextCatXpath)
                        for nextCatRad in RadiosNextCat:
                            nextCatRad.click()
                            Texture = GetEleIfVis(driver, By.XPATH, "{0}//h5[@id='textureValue']".format(LAND_INFO_FOOTER)).text
                LogSuccess("Test 2.4.7.{0}.2.2.{1} Pass".format(iSoilLayer,Category))
            ClickElementIfVis(driver, By.XPATH, "{0}//button[@class='button button-balanced']".format(LAND_INFO_FOOTER))
        ClickGoBackLandInfo(driver)
    except Exception:
        raise TestFailedException("error while processing soil layer guide me")
def CheckVideo(driver,ByType, OpenVideoPath, iSoilLayer):
    ClickElementIfVis(driver, ByType, OpenVideoPath)
    try:
        VideoPath = "{0}/video".format(LAND_INFO_POPUP_BODY)
        Video = GetEleIfVis(driver, By.XPATH, VideoPath)
        videoSrcPath = "{0}/source".format(VideoPath)
        videoSrc = driver.find_element(By.XPATH,videoSrcPath).get_attribute("src")
        LogSuccess(DICT_VIDEO_SRC_TO_TEST[videoSrc.split("/")[-1]].format(iSoilLayer))
        ClickElementIfVis(driver, By.XPATH, GENERIC_POPUP_BUTTON)
    except:
        try:
            ClickElementIfVis(driver, By.XPATH, GENERIC_POPUP_BUTTON)
        finally:
            LogError("Video not found for category and soil layer {0}".format(iSoilLayer))
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
    ClickGoBackLandInfo(driver)
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
def HandleSlope(driver, plotName):
    ClickElementIfVis(driver, By.XPATH, '{0}{1}'.format(LAND_INFO_MENU_ITEM_PATH,'[4]'))
    #Click first slope
    eles = GetElesIfVis(driver, By.XPATH,LAND_INFO_PLOT_INFO_PATH)
    for ele in eles:
        ele.click()
        break
    GoBackToPageWithTitle(driver," {0}".format(plotName))
def _FillAllDataForPlot(driver,plotName):
    for i in range(2, 7):
        try:
            ClickElementIfVis(driver, By.XPATH, '{0}[{1}]'.format(LAND_INFO_MENU_ITEM_PATH,i))
            eles = GetElesIfVis(driver, By.XPATH,LAND_INFO_PLOT_INFO_PATH)
            for ele in eles:
                ele.click()
            LogSuccess("Test {0} Pass".format(DICT_TEST_MESSAGES_KEY_MENU_NUM[i]["TestName"]))
        except :
            LogError("Test {0} Failed".format(DICT_TEST_MESSAGES_KEY_MENU_NUM[i]["TestName"]))
            continue
        GoBackToPageWithTitle(driver," {0}".format(plotName))                       
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
    LogSuccess("Test 2.4.9 Pass")
    WaitForLoad(driver)
def FillPlotData(driver, Airplane = False, bFullPlot = False):
    #fill plot info
    PassOrFail = "PASS"
    PlotName = FillPlotInputs(driver)
    if(bFullPlot):
        _FillAllDataForPlot(driver,PlotName)
        try:
            HandleSoilLayer(driver,PlotName,bFullPlot)
            LogSuccess("Test 2.4.7 Pass")
        except:
            LogError("Test 2.4.7 Failed")
            PassOrFail = "FAIL"
    else:
        try:
            #click Slope
            HandleSlope(driver,PlotName)
            LogSuccess("Test 2.4.4 Pass")
            #click soil layer
            HandleSoilLayer(driver,PlotName,bFullPlot)
            LogSuccess("Test 2.4.7 Pass")
        except:
            LogError("Test 2.4.7 Failed")
            LogError("Test 2.4.4 Failed")
            PassOrFail = "FAIL"
        
    #Review Plot
    GoBackToPageWithTitle(driver," {0}".format(PlotName))
    ReviewPlot(driver, Airplane=Airplane, PlotName=PlotName)
    return PlotName,PassOrFail
def SendTextToEle(weEle, strValue):
    log.info("Sending {0} to WebElement {1}".format(strValue, weEle))
    weEle.send_keys(strValue)
def LandCover(driver, plots, Airplane=False):
    if(Airplane):
        try:
            ClickElementIfVis(driver, By.XPATH,POSTIVE_POPUP_BUTTON)
        except ElementNotFoundTimeoutException:
            LogWarn( "Message regarding connectivity did not appear" )
    for plot in plots:
        String = "{0}{1}".format(LANDCOVER_PLOT_LIST,"[contains(.,'{0}')]".format(plot))
        try:
            PlotFound = GetEleIfVis(driver, By.XPATH, String)
        except TimeoutException:
            LogError( "Plot '{0}' was not found in landcover in airplane mode.".format(plot) )
            continue
        try:
            LogSuccess("Plot '{0}' found in landcover in airplane mode as expected".format(plot))
            PlotFound.click()
            ProcLandCover(driver)
        except Exception:
            LogError("Error processing landcover")
        try:
            ClickElementIfVis(driver, By.XPATH, LAND_COVER_SUBMIT_BUTTON)
            MessageEle = GetEleIfVis(driver, By.XPATH,LAND_INFO_POPUP_BODY_MESSAGE)
            MessageText = MessageEle.text
            if(not "Do you want to submit it" in MessageText):
                raise TestFailedException("Land Cover did not accept Data of: all bare ground. Displayed Message {0}".format(MessageText))
            ClickElementIfVis(driver, By.XPATH,POSTIVE_POPUP_BUTTON)
            if(Airplane):
                MessageEle = GetEleIfVis(driver, By.XPATH,LAND_INFO_POPUP_BODY_MESSAGE)
                MessageText = MessageEle.text
                if("Transect data has been marked for background upload" in MessageText):
                    LogSuccess("Land cover {0} has been submitted for background upload".format(plot))
                ClickElementIfVis(driver, By.XPATH,POSTIVE_POPUP_BUTTON)
            WaitForLoad(driver)
            MessageEle = GetEleIfVis(driver, By.XPATH,LAND_COVER_SITE_SUMMARY)
            Text = MessageEle.text
            #if Airplane:
            if ( not Text == "Site Summary"):
                LogError(DICT_OUTPUT_MESSAGE_NO_DATA_KEY["LandCover"]["PlotUnsucess"])
            else:
                LogSuccess(DICT_OUTPUT_MESSAGE_NO_DATA_KEY["LandCover"]["PlotSucess"].format(plot))
                ClickGoBackLandInfo(driver)
        except TestFailedException :
            break
        except Exception:
            LogError("Unknown error while processing landcover")
    ClickGoBackLandInfo(driver)
def WaitForLoad(driver):
    wait = WebDriverWait(driver, 30)
    wait.until(EC.presence_of_element_located((By.XPATH, "//div[@class='loading-container']")),"")
    wait.until(EC.invisibility_of_element_located((By.XPATH, "//div[@class='loading-container']")),"")
def SetUpApp(Test, AirplaneMode=False, bRobot = True, iConnection=None, bSelenium = False):
    if(bSelenium):
        if (bRobot):
            SeleniumLib = BuiltIn().get_library_instance('Selenium2Library')
            if(len(SeleniumLib._cache.get_open_browsers()) > 0 and not hasattr(Test, "driver")):
                Test.driver = SeleniumLib._current_browser()
            else:
                if(not hasattr(Test, "driver")):
                    SetDriver(Test, AirplaneMode,bSel=bSelenium)
                    SeleniumLib._cache.register(Test.driver, None)
        else:
            if(not hasattr(Test, "driver")):
                SetDriver(Test, AirplaneMode,bSel=bSelenium)
        try:
            #Test.driver.set_speed(.5)
            Test.driver.get("http://testlpks.landpotential.org:8105/#/landpks/landpks_entry_page")
            Test.driver.switch_to.default_content
            ClickElementIfVis(Test.driver, By.XPATH, "//div[@nav-view='active']//div[@class='scroll']//img[@src='landpks_img/landinfo_logo.png']")
            HandleGoogleLogin(Test.driver)
        except TimeoutException as Te:
            log.info("Login not required")
        win = Test.driver.window_handles
        Test.driver.switch_to.window(win[-1])
    else:
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
            Test.driver.switch_to.context(LAND_INFO_WEBVIEW_NAME)
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
def TestCapsSel():
    caps= {}
    
    caps['platform'] = "linux"
    caps['browserName'] = "chrome"
    caps['version'] = ""
    caps["os"] = "linux"
    #caps['platform'] = "windows 7"
    #caps['browserName'] = "internet explorer"
    #caps['version'] = "11"
    #caps["os"] = "windows"
    return caps
def SetDriver(Test,AirplaneMode, bSel = False):
    
    START_TIME["START"] = datetime.datetime.now()
    if(bSel):
        desired_caps = TestCapsSel()
        Test.driver = selWebDriver.Remote(command_executor=COMMAND_EXEC, 
                                      desired_capabilities=desired_caps)
        Test.driver.set_page_load_timeout(30)
        Test.driver.set_script_timeout(30)
    else:
        desired_caps = TestCaps()
        desired_caps['app'] = LAND_INFO_ANDROID_APP
        Test.driver = webdriver.Remote(command_executor=COMMAND_EXEC, 
                                      desired_capabilities=desired_caps)
    #if not AirplaneMode:
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
        raise ElementNotFoundTimeoutException(EleKey=Value)
    except WebDriverException as WDE:
        log.error("WebDriver exception unknown error while finding element {0} by {1}".format(Value,ByType))
        raise Exception
def SwitchToPopupWindow(driver):
    wait = WebDriverWait(driver, TIMEOUT)
    time.sleep(1)
    wait.until(lambda driver: len(driver.window_handles) > 1)
    driver.switch_to.window(driver.window_handles[-1])
def HandleGoogleLogin(driver):
    try:
        Creds = get_uname_and_pword_lpks_gmail()
        ClickElementIfVis(driver,By.XPATH,"//Button[contains(@id, 'loginGoogle')][@style='display: block;']")
        LogSuccess("Test 2.1.1 Pass")
        
        SwitchToPopupWindow(driver)
        ele = GetEleIfVis(driver,By.ID,"Email")
        ele.send_keys(Creds["UName"])
        ClickElementIfVis(driver,By.ID,"next")
        ele = GetEleIfVis(driver,By.ID,"Passwd")
        ele.send_keys(Creds["PWord"])
        ClickElementIfVis(driver,By.ID,"signIn")
        ClickElementIfVis(driver,By.ID,"submit_approve_access")
        win = driver.window_handles
        driver.switch_to.window(win[0])
    except:        
        raise TestFailedException("Error logging in using google")
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
    def gen_test_cases(self):
        GenDynaWebAppTestsAppend()
    def set_browser(self, remoteURL,bSelenium=False, **kwgs):
        if(bSelenium):
            START_TIME["START"] = datetime.datetime.now()
            seleniumLib = BuiltIn().get_library_instance('Selenium2Library')
            if(kwgs is None or len(kwgs) <= 0):
                log.info(kwgs)
                desired_caps = TestCapsSel()
                self.driver = webdriver.Remote(command_executor=remoteURL, 
                                               desired_capabilities=desired_caps)
                self.driver.implicitly_wait(30)
                self.driver.set_script_timeout(30)
                self.driver.set_page_load_timeout(30)
                seleniumLib._cache.register(self.driver, None)
            else:
                seleniumLib.open_browser("http://www.google.com",remote_url = remoteURL, desired_capabilities=kwgs)
                self.driver = seleniumLib._current_browser()
                self.driver.implicitly_wait(30)
                self.driver.set_script_timeout(30)
                self.driver.set_page_load_timeout(30)
        else:
            appiumLib = BuiltIn().get_library_instance('AppiumLibrary')
            START_TIME["START"] = datetime.datetime.now()
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
    def tearDown(self, PassOrFail = "PASS",bRobot = False,bSelenium=False):
        report_sauce_status("AppiumTesting", status=PassOrFail, tags="Appium", remote_url=COMMAND_EXEC, bRobot = bRobot, driver = self.driver)
        
        if(bRobot):
            if(bSelenium):
                appiumLib = BuiltIn().get_library_instance('AppiumLibrary')
                appiumLib._cache.close_all()
                self.driver.quit()
                del(self.driver)
                if (not PassOrFail == "PASS"):
                    BuiltIn().fail("")
            else:
                seleniumLib = BuiltIn().get_library_instance('Selenium2Library')
                seleniumLib._cache.close_all()
                self.driver.quit()
                del(self.driver)
                if (not PassOrFail == "PASS"):
                    BuiltIn().fail("")
        else:
            self.driver.quit()
            del(self.driver)
    def Test_Case_2(self, bRobot = True, bSelenium=False):
        #log in
        global ERRORS,SUCCESS,WARNS
        ERRORS = []
        SUCCESS = []
        WARNS = []
        PassOrFail = "PASS"
        try:
            SetUpApp(self,bRobot=bRobot,bSelenium=bSelenium)
            ClickElementIfVis(self.driver,By.XPATH,"//div[@nav-view='active']//div[contains(@ng-show,'device')][not(contains(@class,'hide'))]/img[@src='landpks_img/landinfo_logo.png']")
            WaitForLoad(self.driver)
            HandleLogout(self.driver)
            LogSuccess("Test 2.1.1 Pass")
        except:
            LogError("Test 2.1 Failed")
            PassOrFail = "Fail"
        finally:
            OutputErrors()
            OutputSucessful()
            self.tearDown(PassOrFail, bRobot,bSelenium=bSelenium)
        #2.4 create plot
    def Test_Case_2_3(self, bRobot = True, bSelenium=False):
        PassOrFail = "PASS"
        global ERRORS,SUCCESS,WARNS
        ERRORS = []
        WARNS = []
        SUCCESS = []
        try:
            SetUpApp(self,bRobot=bRobot,bSelenium=bSelenium)
            ClickElementIfVis(self.driver,By.XPATH,"//div[@nav-view='active']//div[contains(@ng-show,'device')][not(contains(@class,'hide'))]/img[@src='landpks_img/landinfo_logo.png']")
            WaitForLoad(self.driver)
            ClickElementIfVis(self.driver,By.XPATH,LAND_INFO_LOCAL_CLIMATE_BUTTON)
            CheckClimate(self.driver)
            ClickGoBackLandInfo(self.driver)
        except:
            PassOrFail = "FAIL"
        finally:
            OutputErrors()
            OutputSucessful()
            self.tearDown(PassOrFail, bRobot,bSelenium=bSelenium)
        #LandCover
    def Test_Case_2_4(self, bRobot = True, bSelenium=False, bFullPlot = True):
        global ERRORS,SUCCESS,WARNS
        ERRORS = []
        SUCCESS = []
        WARNS = []
        PassOrFail = "PASS"
        try:
            SetUpApp(self,bRobot=bRobot,bSelenium=bSelenium)
            ClickElementIfVis(self.driver,By.XPATH,"//div[@nav-view='active']//div[contains(@ng-show,'device')][not(contains(@class,'hide'))]/img[@src='landpks_img/landinfo_logo.png']")
            if(bRobot):
                appiumLib = BuiltIn().get_library_instance('AppiumLibrary')
                if(len(appiumLib._cache.get_open_browsers()) > 0 and not hasattr(self, "driver")):
                    self.driver = appiumLib._current_application()
            WaitForLoad(self.driver)
            ClickElementIfVis(self.driver,By.XPATH,LAND_INFO_ADD_PLOT_BUTTON)
            ClickElementIfVis(self.driver, By.XPATH, "//a[@class='item item-icon-right plotname']")
            LogSuccess("Test 2.4.1 Pass")
            
            PlotName,PassOrFail = FillPlotData(self.driver, Airplane=False, bFullPlot=bFullPlot)
            #PlotName = FillPlotInputs(self.driver)
            #FillAllDataForPlot(self.driver)
            
            
            #click Slope
            #try:
            #    HandleSlope(self.driver)
            #    LogSuccess("Test 2.4.4 Pass")
            #except:
            #    LogError("Test 2.4.4 Failed")
            #click soil layer
            
            #try:
            #    HandleSoilLayer(self.driver)
            #    LogSuccess("Test 2.4.7 Pass")
            #except:
            #    LogError("Test 2.4.7 Failed")
            #    PassOrFail = "FAIL"
            #try:
                #Review Plot
            #    ReviewPlot(self.driver, False, PlotName)
            #    LogSuccess("Test 2.4.9 Pass")
            #except:
            #    LogError("Test 2.4.9 Failed")
            #    PassOrFail = "FAIL"
        finally:
            OutputErrors()
            OutputSucessful()
            self.tearDown(PassOrFail, bRobot,bSelenium=bSelenium)
    def Test_Case_0(self, bRobot = True, bSelenium=False):
        global ERRORS,SUCCESS,WARNS
        ERRORS = []
        SUCCESS = []
        WARNS = []
        PassOrFail = "PASS"
        if(bSelenium):
            try:
                SetUpApp(self,bRobot=bRobot,bSelenium=bSelenium)
                #self.driver.close_app()
                #self.driver.start_activity(app_package=LAND_COVER_ANDROID_PACKAGE, app_activity=LAND_COVER_ANDROID_ACTIVITY_NAME)
                ClickElementIfVis(self.driver,By.XPATH,"//div[@nav-view='active']//div[contains(@ng-show,'device')][not(contains(@class,'hide'))]/img[@src='landpks_img/landinfo_logo.png']")
                WaitForLoad(self.driver)
                ClickElementIfVis(self.driver,By.XPATH,LAND_INFO_ADD_PLOT_BUTTON)
                ClickElementIfVis(self.driver, By.XPATH, "//a[@class='item item-icon-right plotname']")
                try:
                    plotName,PassOrFail = FillPlotData(self.driver,Airplane=False, bFullPlot=False)
                    self.plotNames.append(plotName)
                    goToAppSelection(self.driver)
                    #ClickElementIfVis(self.driver, By.XPATH, LAND_INFO_BACK_BUTTON)
                    #ClickElementIfVis(self.driver, By.XPATH, LAND_INFO_BACK_BUTTON)
                    ClickElementIfVis(self.driver,By.XPATH,"//div[@nav-view='active']//div[contains(@ng-show,'device')][not(contains(@class,'hide'))]//img[@src='landpks_img/landcover_logo.png']")
                    WaitForLoad(self.driver)
                    LandCover(self.driver, self.plotNames, Airplane=False)
                except ElementNotFoundTimeoutException:
                    raise Exception
                except TestFailedException:
                    PassOrFail = "FAIL"
                    raise Exception
                LogSuccess("Test 0.1 Pass")
                LogSuccess("Test 0.2 Pass")
                LogSuccess("Test 0.3 Pass")
            except:
                LogError("Test 0.3 Failed")
                PassOrFail = "FAIL"
            finally:
                OutputErrors()
                OutputSucessful()
                OutputWarns()
                self.tearDown(PassOrFail, bRobot,bSelenium=bSelenium)
        else:
            try:
                self.test_add_plot_airplane_verify_it_appears_in_landcover(bRobot)
                LogSuccess("Test 0.1 Pass")
                LogSuccess("Test 0.2 Pass")
                LogSuccess("Test 0.3 Pass")
            except:
                LogError("Test 0.3 Failed")
                PassOrFail = "FAIL"
            finally:
                OutputErrors()
                OutputSucessful()
                self.tearDown(PassOrFail, bRobot,bSelenium=bSelenium)
            
            
    def test_add_plot_airplane_verify_it_appears_in_landcover(self, bRobot = True):
        global WARNS,SUCCESS,ERRORS
        SetUpApp(self, AirplaneMode=True, bRobot=bRobot, iConnection=1)
        #self.driver.close_app()
        #self.driver.start_activity(app_package=LAND_COVER_ANDROID_PACKAGE, app_activity=LAND_COVER_ANDROID_ACTIVITY_NAME)
        ClickElementIfVis(self.driver,By.XPATH,"//div[@nav-view='active']//div[contains(@ng-show,'device')][not(contains(@class,'hide'))]/img[@src='landpks_img/landinfo_logo.png']")
        WaitForLoad(self.driver)
        try:
            ClickElementIfVis(self.driver, By.XPATH,POSTIVE_POPUP_BUTTON)
        except ElementNotFoundTimeoutException:
            LogWarn( "Message regarding connectivity did not appear" )
        ClickElementIfVis(self.driver,By.XPATH,LAND_INFO_ADD_PLOT_BUTTON)
        ClickElementIfVis(self.driver, By.XPATH, "//a[@class='item item-icon-right plotname']")
        try:
            plotName,PassOrFail = FillPlotData(self.driver,Airplane=True, bFullPlot=False)
            self.plotNames.append(plotName)
            goToAppSelection(self.driver)
            ClickElementIfVis(self.driver,By.XPATH,"//div[@nav-view='active']//div[contains(@ng-show,'device')][not(contains(@class,'hide'))]//img[@src='landpks_img/landcover_logo.png']")
            WaitForLoad(self.driver)
            LandCover(self.driver, self.plotNames, Airplane=True)
            LogSuccess( "Test 0.3 Pass" )
        except TimeoutException:
            LogError("TIMEOUT")
            raise Exception
        except WebDriverException:
            LogError("Web exception")
            raise Exception
    def check_interuptions(self):
        SetUpApp(self)
        #os.system(command)
class TestFailedException(Exception):
    def __init__(self,Mesage):
        LogError(Mesage)
class ElementNotFoundTimeoutException(Exception):
    def __init__(self, Message=None, EleKey=None):
        if(not EleKey == None):
            if (DICT_ELEMENT_PATH_TO_NAME.has_key(EleKey)):
                Message = "{0} was unable to be located".format(DICT_ELEMENT_PATH_TO_NAME[EleKey])
            else:
                Message = "{0} was unable to be located, Element did not exist is dictionary".format(EleKey)
        LogError(Message)
class Testing(unittest.TestCase):
    AppTest = Test_Case()
    def tester(self):
        #self.AppTest.Test_Case_2(False,True)
        #self.AppTest.Test_Case_2_4(False,False)
        #self.AppTest.Test_Case_2_4(False,True)
        #self.AppTest.Test_Case_2_3(False,True)
        #self.AppTest.Test_Case_2_4( bRobot = False,bSelenium = True, bFullPlot = True)
        self.AppTest.Test_Case_0( bRobot = False,bSelenium = True)
        #self.AppTest.test_add_plot(bRobot=False)
        #self.AppTest.test_add_plot_airplane_verify_it_appears_in_landcover(bRobot=False)
if __name__ == '__main__':    
    #GenDynaWebAppTestsAppend()
    suite = unittest.TestLoader().loadTestsFromTestCase(Testing)
    unittest.TextTestRunner(verbosity=2).run(suite)
    
    #os.system("echo %CD%")
    #os.system("pybot ../AppiumTest.robot")