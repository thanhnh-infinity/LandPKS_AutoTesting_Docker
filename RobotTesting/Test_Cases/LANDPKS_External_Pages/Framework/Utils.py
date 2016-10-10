import random
import os
import string
import sys
import platform
import simplejson as json
from selenium.webdriver.support.ui import Select
from NetUtils import GetPortalInfo
import csv
#REQUEST_API_LAND_INFO_BY_RECORDER = "http://testapi.landpotential.org:8080/query?version=0.1&action=get&object=landinfo&type=get_by_recorder_name&recorder_name={0}"
REQUEST_API_LAND_INFO_BY_RECORDER = "http://testapi.landpotential.org:8080/query?&action=get&object=landinfo&type=get_by_recorder_name&recorder_name={0}"
REQUEST_API_LAND_INFO_BY_RECORDER_PRODUCTION = "http://api.landpotential.org/query?&action=get&object=landinfo&type=get_by_recorder_name&recorder_name={0}"
ERROR_CODE_RESPONSE = '400'
SUCCESS_CODE_RESPONSE = '200'
BROWSER_VERSIONS = {
                   "Firefox" : ["47.0"],
                   "Chrome" : ["51.0"]
                   }
BROWSERS = ["Chrome","Firefox"]
TestTypes = {
             "Windows 8.1" :{
              "os" : "Windows 8",
              "platform" : "Windows 8",
              "fileName" : "Windows_8_1_Web_App.robot",
              "strReplace" : [
                  {"OldText":"${Platform}       linux","NewText" : "${Platform}       Windows 8"},
                  {"OldText":"${OS}             linux","NewText" : "${OS}             Windows 8_1"},
                  ]
              },
             "Windows 10" :{
              "os" : "Windows 10",
              "platform" : "Windows 10",
              "fileName" : "Windows_10_Web_App.robot",
              "strReplace": [
                  {"OldText":"${Platform}       linux","NewText" : "${Platform}       Windows 10"},
                  {"OldText":"${OS}             linux","NewText" : "${OS}             Windows 10"},
                  ]              
              },
              "Windows 7" :{
              "os" : "Windows 7",
              "platform" : "Windows 7",
              "fileName" : "Windows_7_Web_App.robot",
              "strReplace" : [
                  {"OldText":"${Platform}       linux","NewText" : "${Platform}       Windows 7"},
                  {"OldText":"${OS}             linux","NewText" : "${OS}             Windows 7"}, 
                  ]
              }
             }
def GenDynaAndroidTestsAppend():
    TestTypesBrowsered = {}
    ExecCommand = "pybot {0}"
    JenkinsBrowsers = parseJSONJenkinsCapa()
    if(len(JenkinsBrowsers) > 0):
        for config in JenkinsBrowsers:
            if(( "iphone" in config) or ( "android" in config)):
                NameNewTest = "{0} {1} {2}".format(config["os"],config["Browser"],config["version"])
                TestTypesBrowsered[NameNewTest] = {}
                TestTypesBrowsered[NameNewTest]["strReplace"] = []
                TestTypesBrowsered[NameNewTest]["fileName"] = "{0}_{1}_{2}_Web_App.robot".format(config["platform"],config["Browser"],config["version"])
                
                TestTypesBrowsered[NameNewTest]["strReplace"].append({"OldText":"${PLATFORM}       Android","NewText" : "${Platform}       %s"%config["platform"]})
                TestTypesBrowsered[NameNewTest]["strReplace"].append({"OldText":"${OS}             linux","NewText" : "${OS}             %s"%config["os"]})
                
                TestTypesBrowsered[NameNewTest]["strReplace"].append({"OldText":"${BrowserName}    chrome","NewText" : "${BrowserName}    %s"%config["Browser"]})
                TestTypesBrowsered[NameNewTest]["strReplace"].append({"OldText":"${platformVersion}    5.1","NewText" : "${platformVersion}    %s"%config["version"]})
                TestTypesBrowsered[NameNewTest]["strReplace"].append({"OldText":"x Android 5.1","NewText" : "x %s %s"%(config["platform"],config["Browser"])})
        for Key in TestTypesBrowsered:
            FilePath = GenDynaTestCaseAppend("..\\WebAppTesting.robot","DynaTestGened.robot",bCompletePath=False,strReplace =TestTypesBrowsered[Key]["strReplace"])
        os.system(ExecCommand.format(
                                     '"{0}"'.format(FilePath)
                                     )
                  )
        os.remove(FilePath)
        del(TestTypesBrowsered)
    #endIF
    else:
        for Key in TestTypes:
            for Browser in BROWSERS:
                for BrowserVer in BROWSER_VERSIONS[Browser]:
                    NameNewTest = "{0} {1} {2}".format(Key,Browser,BrowserVer)
                    TestTypesBrowsered[NameNewTest] = dict(TestTypes[Key])
                    TestTypesBrowsered[NameNewTest]["strReplace"] = list(TestTypes[Key]["strReplace"])
                    TestTypesBrowsered[NameNewTest]["Browser"] = Browser
                    TestTypesBrowsered[NameNewTest]["fileName"] = "{0}_Ver_{1}_{2}".format(Browser,BrowserVer,TestTypes[Key]["fileName"])
                    TestTypesBrowsered[NameNewTest]["strReplace"].append({"OldText":"${BrowserName}    chrome","NewText" : "${BrowserName}    %s"%Browser})
                    TestTypesBrowsered[NameNewTest]["strReplace"].append({"OldText":"${BrowserVersion}    \"\"","NewText" : "${BrowserVersion}    %s"%BrowserVer})
                    TestTypesBrowsered[NameNewTest]["strReplace"].append({"OldText":"x Linux Chrome","NewText" : "x Windows 7 %s"%Browser})
        for Key in TestTypesBrowsered:
            FilePath = GenDynaTestCaseAppend("..\\WebAppTesting.robot","DynaTestGened.robot",bCompletePath=False,strReplace =TestTypesBrowsered[Key]["strReplace"])
        os.system(ExecCommand.format(
                                     FilePath
                                     )
                  )
        os.remove(FilePath)
        del(TestTypesBrowsered)

def GenDynaWebAppTestsAppend():
    TestTypesBrowsered = {}
    ExecCommand = "pybot {0}"
    JenkinsBrowsers = parseJSONJenkinsCapa()
    if(len(JenkinsBrowsers) > 0):
        for config in JenkinsBrowsers:
            if((not "iphone" in config) and (not "android" in config)):
                NameNewTest = "{0} {1} {2}".format(config["os"],config["Browser"],config["version"])
                TestTypesBrowsered[NameNewTest] = {}
                TestTypesBrowsered[NameNewTest]["strReplace"] = []
                TestTypesBrowsered[NameNewTest]["fileName"] = "{0}_{1}_{2}_Web_App.robot".format(config["platform"],config["Browser"],config["version"])
                
                TestTypesBrowsered[NameNewTest]["strReplace"].append({"OldText":"${Platform}       linux","NewText" : "${Platform}       %s"%config["platform"]})
                TestTypesBrowsered[NameNewTest]["strReplace"].append({"OldText":"${OS}             linux","NewText" : "${OS}             %s"%config["os"]})
                
                TestTypesBrowsered[NameNewTest]["strReplace"].append({"OldText":"${BrowserName}    chrome","NewText" : "${BrowserName}    %s"%config["Browser"]})
                TestTypesBrowsered[NameNewTest]["strReplace"].append({"OldText":"${BrowserVersion}    \"\"","NewText" : "${BrowserVersion}    %s"%config["version"]})
                TestTypesBrowsered[NameNewTest]["strReplace"].append({"OldText":"x Linux Chrome","NewText" : "x %s %s"%(config["platform"],config["Browser"])})
        for Key in TestTypesBrowsered:
            FilePath = GenDynaTestCaseAppend("..\\WebAppTesting.robot","DynaTestGened.robot",bCompletePath=False,strReplace =TestTypesBrowsered[Key]["strReplace"])
        #os.system(ExecCommand.format(
        #                             '"{0}"'.format(FilePath)
        #                             )
        #          )
        #os.remove(FilePath)
        del(TestTypesBrowsered)
    #endIF
    else:
        for Key in TestTypes:
            for Browser in BROWSERS:
                for BrowserVer in BROWSER_VERSIONS[Browser]:
                    NameNewTest = "{0} {1} {2}".format(Key,Browser,BrowserVer)
                    TestTypesBrowsered[NameNewTest] = dict(TestTypes[Key])
                    TestTypesBrowsered[NameNewTest]["strReplace"] = list(TestTypes[Key]["strReplace"])
                    TestTypesBrowsered[NameNewTest]["Browser"] = Browser
                    TestTypesBrowsered[NameNewTest]["fileName"] = "{0}_Ver_{1}_{2}".format(Browser,BrowserVer,TestTypes[Key]["fileName"])
                    TestTypesBrowsered[NameNewTest]["strReplace"].append({"OldText":"${BrowserName}    chrome","NewText" : "${BrowserName}    %s"%Browser})
                    TestTypesBrowsered[NameNewTest]["strReplace"].append({"OldText":"${BrowserVersion}    \"\"","NewText" : "${BrowserVersion}    %s"%BrowserVer})
                    TestTypesBrowsered[NameNewTest]["strReplace"].append({"OldText":"x Linux Chrome","NewText" : "x Windows 7 %s"%Browser})
        for Key in TestTypesBrowsered:
            FilePath = GenDynaTestCaseAppend("..\\WebAppTesting.robot","DynaTestGened.robot",bCompletePath=False,strReplace =TestTypesBrowsered[Key]["strReplace"])
        os.system(ExecCommand.format(
                                     FilePath
                                     )
                  )
        os.remove(FilePath)
        del(TestTypesBrowsered)
def GenDynaTestCaseAppend(PlaceHolderTestCase,NameOfTestCase, bCompletePath,**Changes):
    SYSTEM = platform.system()
    FilePath = ""
    if SYSTEM == "Windows":
        PlaceHolderTestCase = PlaceHolderTestCase.replace("/","\\")
    else:
        PlaceHolderTestCase = PlaceHolderTestCase.replace("\\","/")
    if(bCompletePath):
        FilePath = PlaceHolderTestCase
    else:
        FilePath = "{0}{2}{1}".format(GetPath(), PlaceHolderTestCase, "\\" if SYSTEM == "Windows" else "/")
    TestCase = open(FilePath, 'r')
    TestCaseText = TestCase.read()
    TestCaseText = TestCaseText.split("*** Test Cases ***")
    TestCase.close()
    for Change in Changes:
        TestCaseText[-1] = ProcChangeItem(Changes,Change,TestCaseText[-1])
        #TestCaseText = TypeChange(TestCaseText)
        #TestCaseText = TestCaseText.replace(Changes[Change]["OldText"], Changes[Change]["NewText"])
    NewTestPath = "{0}{2}{1}".format(os.path.dirname(os.path.realpath(FilePath)), NameOfTestCase, "\\" if SYSTEM == "Windows" else "/")
    if(not os.path.isfile(NewTestPath)):
        NewTest = open( NewTestPath, 'a')
        NewTest.write(TestCaseText[0])
        NewTest.write("*** Test Cases ***")
        NewTest.close()
    NewTest = open( NewTestPath, 'a')
    NewTest.write(TestCaseText[-1])
    NewTest.close()
    return NewTestPath

def GenDynaWebAppTests():
    TestTypesBrowsered = {}
    ExecCommand = "pybot {0}"
    JenkinsBrowsers = parseJSONJenkinsCapa()
    if(len(JenkinsBrowsers) > 0):
        for config in JenkinsBrowsers:
            if((not "iphone" in config) and (not "android" in config)):
                NameNewTest = "{0} {1} {2}".format(config["os"],config["Browser"],config["version"])
                TestTypesBrowsered[NameNewTest] = {}
                TestTypesBrowsered[NameNewTest]["strReplace"] = []
                TestTypesBrowsered[NameNewTest]["fileName"] = "{0}_{1}_{2}_Web_App.robot".format(config["platform"],config["Browser"],config["version"])
                
                TestTypesBrowsered[NameNewTest]["strReplace"].append({"OldText":"${Platform}       linux","NewText" : "${Platform}       %s"%config["platform"]})
                TestTypesBrowsered[NameNewTest]["strReplace"].append({"OldText":"${OS}             linux","NewText" : "${OS}             %s"%config["os"]})
                
                TestTypesBrowsered[NameNewTest]["strReplace"].append({"OldText":"${BrowserName}    chrome","NewText" : "${BrowserName}    %s"%config["Browser"]})
                TestTypesBrowsered[NameNewTest]["strReplace"].append({"OldText":"${BrowserVersion}    \"\"","NewText" : "${BrowserVersion}    %s"%config["version"]})
                TestTypesBrowsered[NameNewTest]["strReplace"].append({"OldText":"x Linux Chrome","NewText" : "x %s %s"%(config["platform"],config["Browser"])})
        for Key in TestTypesBrowsered:
            FilePath = GenDynaTestCase("..\\WebAppTesting.robot",TestTypesBrowsered[Key]["fileName"],bCompletePath=False,strReplace =TestTypesBrowsered[Key]["strReplace"])
            os.system(ExecCommand.format(
                                         '"{0}"'.format(FilePath)
                                         )
                      )
            os.remove(FilePath)
        del(TestTypesBrowsered)
    #endIF
    else:
        for Key in TestTypes:
            for Browser in BROWSERS:
                for BrowserVer in BROWSER_VERSIONS[Browser]:
                    NameNewTest = "{0} {1} {2}".format(Key,Browser,BrowserVer)
                    TestTypesBrowsered[NameNewTest] = dict(TestTypes[Key])
                    TestTypesBrowsered[NameNewTest]["strReplace"] = list(TestTypes[Key]["strReplace"])
                    TestTypesBrowsered[NameNewTest]["Browser"] = Browser
                    TestTypesBrowsered[NameNewTest]["fileName"] = "{0}_Ver_{1}_{2}".format(Browser,BrowserVer,TestTypes[Key]["fileName"])
                    TestTypesBrowsered[NameNewTest]["strReplace"].append({"OldText":"${BrowserName}    chrome","NewText" : "${BrowserName}    %s"%Browser})
                    TestTypesBrowsered[NameNewTest]["strReplace"].append({"OldText":"${BrowserVersion}    \"\"","NewText" : "${BrowserVersion}    %s"%BrowserVer})
                    TestTypesBrowsered[NameNewTest]["strReplace"].append({"OldText":"x Linux Chrome","NewText" : "x Windows 7 %s"%Browser})
        for Key in TestTypesBrowsered:
            FilePath = GenDynaTestCase("..\\WebAppTesting.robot",TestTypesBrowsered[Key]["fileName"],bCompletePath=False,strReplace =TestTypesBrowsered[Key]["strReplace"])
            os.system(ExecCommand.format(
                                         FilePath
                                         )
                      )
            os.remove(FilePath)
        del(TestTypesBrowsered)
def GenDynaTestCase(PlaceHolderTestCase,NameOfTestCase, bCompletePath,**Changes):
    SYSTEM = platform.system()
    FilePath = ""
    if SYSTEM == "Windows":
        PlaceHolderTestCase = PlaceHolderTestCase.replace("/","\\")
    else:
        PlaceHolderTestCase = PlaceHolderTestCase.replace("\\","/")
    if(bCompletePath):
        FilePath = PlaceHolderTestCase
    else:
        FilePath = "{0}{2}{1}".format(GetPath(), PlaceHolderTestCase, "\\" if SYSTEM == "Windows" else "/")
    TestCase = open(FilePath, 'r')
    TestCaseText = TestCase.read()
    TestCase.close()
    for Change in Changes:
        TestCaseText = ProcChangeItem(Changes,Change,TestCaseText)
        #TestCaseText = TypeChange(TestCaseText)
        #TestCaseText = TestCaseText.replace(Changes[Change]["OldText"], Changes[Change]["NewText"])
    NewTestPath = "{0}{2}{1}".format(os.path.dirname(os.path.realpath(FilePath)), NameOfTestCase, "\\" if SYSTEM == "Windows" else "/")
    NewTest = open( NewTestPath, 'w+')
    NewTest.write(TestCaseText)
    NewTest.close()
    return NewTestPath
def ProcChangeItem(Changes,Key,Text):
    if(type(Changes[Key]) == list):
        for item in Changes[Key]:
            TypeChange = ProcChangeType(item, Key)
            Text = TypeChange(Text)
    elif(type(Changes[Key]) == dict):
            TypeChange = ProcChangeType(Changes[Key], Key)
            Text = TypeChange(Text)
    return Text
def ProcChangeType(Change, Key):
    if(Key.lower() == "strreplace"):
        return lambda String: String.replace(Change["OldText"], Change["NewText"])
def GetPath():
    try:
        modpath = __file__
    except AttributeError:
        sys.exit('Module does not have __file__ defined.')
    # It's a script for me, you probably won't want to wrap it in try..except

    # Turn pyc files into py files if we can
    if modpath.endswith('.pyc') and os.path.exists(modpath[:-1]):
        modpath = modpath[:-1]

    # Sort out symlinks
    modpath = os.path.dirname(os.path.realpath(modpath))
    return modpath
def GenRandString(strIntype="text"):
    iStringLen = random.randint(6,15)
    strtype = string.lower(strIntype)
    ret = ''
    if(strtype == "text"):
        ret = ''.join(random.SystemRandom().choice(string.ascii_letters + string.digits) for _ in range(iStringLen))
    elif(strtype == "number"):
        ret =  ''.join(random.SystemRandom().choice(["0","1","2","3","4","5","6","7","8","9"]) for _ in range(iStringLen))
        if(ret[:1] == "0"):
            ret = ret[1:]
    elif(strtype=="loc"):
        dataType = random.choice(["int","double"])
        negLoc = random.choice(["-",""])
        if(dataType == "int"):
            ret = "{0}{1}".format(negLoc, random.randint(0,180))
        elif (dataType == "double"):
            ret = "{0}{1}".format(negLoc, random.uniform(0,180))
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
    _SetSelectRand(selEle)
def _SetSelectRand(selEle):
    if( selEle.is_multiple ):
        selEle.deselect_all()
    options = len(selEle.options)
    selEle.select_by_index(random.randint(1,options-1))
def SelectBoxSelectRandFromEle(Element):
    selEle = GetSelEleFromEle(Element)
    _SetSelectRand(selEle)
def GetSelEle(driver, ByType, ElePath):
    return Select(driver.find_element(ByType,ElePath))
def GetSelEleFromEle(Ele):
    return Select(Ele)
def GetSauceCreds():
    creds = 'http://{0}:{1}@ondemand.saucelabs.com:80/wd/hub'.format(os.environ.get("SAUCE_USERNAME"),
                             os.environ.get("SAUCE_ACCESS_KEY")
                             )
    return creds
def get_uname_and_pword_lpks_gmail():
    loginCred = {
        "UName" : os.environ.get("LPKS_TEST_UNAME"),
        "PWord" : os.environ.get("LPKS_TEST_PWORD")
        }
    return loginCred
def Get_Environ_Var(Key):
    KeyPair = {
        "Key" : Key,
        "Value" : os.environ.get(Key)
        }
    return KeyPair
def parseJSONJenkinsCapa():
        
        browsers = json.loads(os.getenv("SAUCE_ONDEMAND_BROWSERS"))
        browserRet =[]
        for e in browsers:
            inputForE = {"Browser":e["browser"],
                     "platform": e["platform"],
                     "version": e["browser-version"],
                     "os" : e["os"]
                     }
            browserRet.append(inputForE)
        return browserRet
    
def GetLandInfoDataForRecorder(RecorderEmail,bProduction = False):
    if (bProduction):
        Request = REQUEST_API_LAND_INFO_BY_RECORDER_PRODUCTION.format(RecorderEmail)
    else:
        Request = REQUEST_API_LAND_INFO_BY_RECORDER.format(RecorderEmail)
    ResponseData = json.loads(GetPortalInfo(Request))["data"]
    return ResponseData
def ParseCSVFile(filePath):
    retData = {}
    with open(GetFilePathForSys(filePath), 'rb') as csvfile:
        csvRead = csv.DictReader(csvfile)
        for CSVrow in csvRead:
            curRow = {}
            for column, value in CSVrow.iteritems():
                curRow.setdefault(column, value)
                #curRow.setdefault(column, []).append(value)
            name = curRow['\xef\xbb\xbfname']
            retData[name] = curRow
            #for item in curRow:
            #    retData[name][item] = curRow[item]
        csvfile.close()
    return retData;
def GetFilePathForSys(filePath):
    if platform.system() == "Windows":
        filePath = filePath.replace("/","\\")
    else:
        filePath = filePath.replace("\\","/")
    return filePath