import random
import os
import string
import sys
import platform

from selenium.webdriver.support.ui import Select
ERROR_CODE_RESPONSE = '400'
SUCCESS_CODE_RESPONSE = '200'
TestTypes = {
             "Windows 8.1" :{
              "os" : "Windows 8",
              "platform" : "Windows 8",
              "fileName" : "Windows_8_1_Web_App.robot",
              "strReplace" : [
                  {"OldText":"${Platform}       linux","NewText" : "${Platform}       Windows 8"},
                  {"OldText":"${OS}             linux","NewText" : "${OS}             Windows 8_1"},
                  {"OldText":"x Linux Chrome","NewText" : "x Windows 8.1 Chrome"} 
                  ]
              },
             "Windows 10" :{
              "os" : "Windows 10",
              "platform" : "Windows 10",
              "filename" : "Windows_10_Web_App.robot",
              "strReplace": [
                  {"OldText":"${Platform}       linux","NewText" : "${Platform}       Windows 10"},
                  {"OldText":"${OS}             linux","NewText" : "${OS}             Windows 10"},
                  {"OldText":"x Linux Chrome","NewText" : "x Windows 10 Chrome"}
                  ]              
              },
              "Windows 7" :{
              "os" : "Windows 7",
              "platform" : "Windows 7",
              "fileName" : "Windows_7_Web_App.robot",
              "strReplace" : [
                  {"OldText":"${Platform}       linux","NewText" : "${Platform}       Windows 7"},
                  {"OldText":"${OS}             linux","NewText" : "${OS}             Windows 7"},
                  {"OldText":"x Linux Chrome","NewText" : "x Windows 7 Chrome"} 
                  ]
              }
             }
def GenDynaWebAppTests():
    if(platform.system() == "Linux"):
        ExecCommand = "sudo pybot {0}"
    else:
        ExecCommand = "pybot {0}"
    for Key in TestTypes:
        
        os.system(ExecCommand.format(
                                     GenDynaTestCase("..\\WebAppTesting.robot",TestTypes[Key]["filename"],bCompletePath=False,strReplace =TestTypes[Key]["strReplace"])
                                     )
                  )
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
def GetSauceCreds():
    creds = 'http://{0}:{1}@ondemand.saucelabs.com:80/wd/hub'.format(os.environ.get("SAUCE_USERNAME"),
                             os.environ.get("SAUCE_ACCESS_KEY")
                             )
    return creds