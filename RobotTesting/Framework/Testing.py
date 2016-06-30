from selenium import webdriver
import re
import requests
import random
from robot.api import logger
import json
import string
from robot.libraries.BuiltIn import BuiltIn

from selenium.common.exceptions import WebDriverException
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import TimeoutException
from selenium.webdriver.common.by import By
from datetime import datetime


import os
MOBILE_APP_WEBPAGE = "http://testlpks.landpotential.org:8105/#/landpks/landpks_entry_page"
SAUCE_ACCESS_KEY = 'Barnebre:216526d7-706f-4eff-bf40-9d774203e268'
USERNAME_ACCESS_KEY = re.compile('^(http|https):\/\/([^:]+):([^@]+)@')
USERNAME_FIELD = 'userName'
NAME_IPAD_TEST = 'Ipad Portal Test'
NAME_ANDROID_TEST = 'Android Portal Test'
NAME_EDGE_TEST = 'Microsoft Edge Portal Test'
NAME_MAC_TEST = 'Mac Portal Test'
NAME_LINUX_TEST = 'Linux Portal Test'
PORTAL_EXPORT_AND_MAP = 'http://portal.landpotential.org/Export/ExportAndMap.html'
COMMAND_EXEC = 'http://%s@ondemand.saucelabs.com:80/wd/hub' % (SAUCE_ACCESS_KEY)
PLOT_DATA = 'http://128.123.177.13/APEX/External_PHP_Project/LandInfo_Map_Plots/LandPKS_Plots_Map_GenXML.php'
TimeToFinish =""
def report_sauce_sucess(Name, id, time = ""):
    report_to_sauce_(Name, 'PASS', id, 'Portal', COMMAND_EXEC, time)
def report_sauce_fail(Name, id, message):
    report_to_sauce_(Name, 'FAIL', id, 'Portal', COMMAND_EXEC)
    logger.error(message)
    

def report_to_sauce_(name, status, id, tags, remote_url, time=""):
    # Parse username and access_key from the remote_url
    assert USERNAME_ACCESS_KEY.match(remote_url), 'Incomplete remote_url.'
    username, access_key = USERNAME_ACCESS_KEY.findall(remote_url)[0][1:]

    # Get selenium session id from the keyword library
    job_id = id    
    # Prepare payload and headers
    token = (':'.join([username, access_key])).encode('base64').strip()
    if(time != "") :
        payload = {'name': name,
                   'passed': status == 'PASS',
                   'tags': tags,
                   'customData' : {
                    'Time to finish Test' : time
                    }}
    else :
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
        logger.info('<a href="{0}">video.flv</a>'.format(video_url), html=True)
    # Appium code for wifi off
    # NetworkConnectionSetting connection = new NetworkConnectionSetting(true, false, false)
    # driver.setNetworkConnection(connection)
def portal_manipulation(driver, Name):
    start = datetime.now()
    driver.get(PORTAL_EXPORT_AND_MAP)
    id = driver.session_id
    MainWindow = driver.current_window_handle
    ele = driver.find_element_by_id(USERNAME_FIELD)
    if ele :
        Login = '{0}@{1}.com'.format(''.join(random.SystemRandom().choice(string.ascii_uppercase + string.digits) for _ in range(10)),
                                     ''.join(random.SystemRandom().choice(string.ascii_uppercase + string.digits) for _ in range(10))
                                     )
        ele.send_keys(Login)
        logger.info('Typing text {0} into text field {1}'.format(Login,USERNAME_FIELD))
    else :
        report_sauce_fail(Name, id, 'Reporter email field not found')
        driver.quit()
        return
    ExportEle = driver.find_element_by_id('export-button')
    if(ExportEle) :
        ExportEle.click()
        logger.info('clicking export button')
    else :
        report_sauce_fail(Name, id, 'Export button not found')
        return
    try:
        wait = WebDriverWait(driver,3 )
        wait.until(EC.visibility_of_element_located((By.ID,'export-error-message')))
    except TimeoutException:
        logger.info('Waiting for export timed out')
    if( len(driver.window_handles) > 1 ):
        logger.error('New window opened')
    if(driver.find_element_by_id('export-error-message').is_displayed()) :
        logger.info('Email not found displayed properly')
    else :
        report_sauce_fail(Name, id, 'Export error message not found')
        driver.quit()
        return
    driver.get(PLOT_DATA)
    src=driver.page_source
    found_text = re.search(r'<plots>', src)
    finishtime = datetime.now()
    TimeToFinish = finishtime - start
    if(found_text != None) :
        logger.info('Plots displayed')
        report_sauce_sucess(Name, id, '{0} second(s)'.format(TimeToFinish.seconds))
    else :
        report_sauce_fail(Name, id, 'Plots not displayed')
    driver.quit()
    
def check_portal_droid() :
    driver = webdriver.Remote(
        desired_capabilities=webdriver.DesiredCapabilities.ANDROID,
        command_executor = COMMAND_EXEC
    )
    portal_manipulation(driver, NAME_ANDROID_TEST)
def check_portal_safari() :
    driver = webdriver.Remote(
        desired_capabilities=webdriver.DesiredCapabilities.IPAD,
        command_executor = COMMAND_EXEC
    )
    portal_manipulation(driver, NAME_IPAD_TEST)
def check_portal_Edge() :
    desired_cap = {
    'platform': "",
    'browserName': "MicrosoftEdge",
    'version': "",
    }
    driver = webdriver.Remote(
        desired_capabilities = desired_cap,
        command_executor = COMMAND_EXEC
    )
    portal_manipulation(driver, NAME_EDGE_TEST)
def check_links():
    driver = webdriver.Remote(
        desired_capabilities=webdriver.DesiredCapabilities.INTERNETEXPLORER,
        command_executor = COMMAND_EXEC
        )
    driver.get('http://landpotential.org')
    elements = driver.getElementsByTagName('p')
def check_portal_mac():
    driver = webdriver.Remote(
        desired_capabilities=webdriver.DesiredCapabilities.SAFARI,
        command_executor = COMMAND_EXEC
        )
    portal_manipulation(driver, NAME_MAC_TEST)

def check_portal_linux() :
    desired_cap = {
    'platform': "linux",
    'browserName': "firefox",
    'version': "",
    }
    driver = webdriver.Remote(
        desired_capabilities = desired_cap,
         command_executor = COMMAND_EXEC
        )
    portal_manipulation(driver, NAME_LINUX_TEST)

def check_all_browsers():
    desired_caps = [
    webdriver.DesiredCapabilities.CHROME,
    webdriver.DesiredCapabilities.ANDROID,
    {
    'platform': "linux",
    'browserName': "firefox",
    'version': "",
    'javascriptEnabled' : "true"
    },
    {
    'platform': "linux",
    'browserName': "chrome",
    'version': "",
    'javascriptEnabled' : "true"
    },
    {
    "platform": "android",
    'browserName': "chrome",
    'version': "",
    'javascriptEnabled' : "true"
    },
    {
    'platform': "Windows",
    'browserName': "chrome",
    'version': "",
    'javascriptEnabled' : "true"
    },
    {
    'platform': "Windows",
    'browserName': "firefox",
    'version': "",
    'javascriptEnabled' : "true"
    },
    {
    'platform': "",
    'browserName': "MicrosoftEdge",
    'version': "",
    },
    {
    'platform': "MAC",
    'browserName': "chrome",
    'version': "",
    'javascriptEnabled' : "true"
    },
    {
    'platform': "Mac",
    'browserName': "safari",
    'version': "",
    'javascriptEnabled' : "true"
    },
    {
    'platform': "MAC",
    'browserName': "iphone",
    'version': "",
    'javascriptEnabled' : "true"
    },
    {
    'platform': "MAC",
    'browserName': "Ipad",
    'version': "",
    'javascriptEnabled' : "true"
    },
    {
    'platform': "ios",
    'browserName': "safari",
    'version': "",
    'javascriptEnabled' : "true"
    }
                    
    ]
    for cap in desired_caps:
        try:
            name = "{0}-{1} Portal Test".format(cap['platform'], cap['browserName'])
            logger.info('Launching {0}'.format(name))
            driver = webdriver.Remote(
            desired_capabilities=cap,
            command_executor = COMMAND_EXEC
            )
            portal_manipulation(driver, name)
        except WebDriverException:
            logger.error('Webdriver Fail')
            continue
def run_mobile_test():
    desired_cap = { 'platform': "Windows",
    'browserName': "chrome",
    'version': "",
    'javascriptEnabled' : "true"
    }
    driver = webdriver.Remote(
        desired_capabilities=desired_cap,
        command_executor = COMMAND_EXEC
        )
    Mobile = mobileHandle(driver)
    Mobile.handle_portal_app(driver)
def get_correct_account(accountName):
    selenium = BuiltIn().get_library_instance('Selenium2Library')
    driver= selenium._current_browser()
    accountButtons = driver.find_elements_by_tag_name('button')
    for actBut in accountButtons:
        if actBut.get_attribute('data-value') == accountName:
            return actBut.get_attribute("id")
def switch_window():
    #Get the current window handle
    windowHandle = webdriver.Remote.current_window_handle

    #Get the list of window handles
    tabs = [driver.window_handles]
    numTabs = len(tabs)
    
    #Use the list of window handles to switch between windows
    driver.switchTo().window(tabs.get(0))

    #Switch back to original window
    driver.switchTo().window(windowHandle)
def get_element_atrrib(webelement, attrib):
    return webelement.get_attribute(attrib)
def scroll_to_element(element):
    selenium = BuiltIn().get_library_instance('Selenium2Library')
    driver = selenium._current_browser()
    driver.execute_script("arguments[0].scrollIntoView(true);", element);
def get_browsers():
        
        browsers = json.loads(os.getenv("SAUCE_ONDEMAND_BROWSERS"))
        logger.info(browsers)
        browserRet =[]
        for e in browsers:
            inputForE = {"browser":e["browser"],
                     "platform": e["platform"],
                     "version": e["browser-version"]
                     }
            browserRet.append(inputForE)
        return browserRet
def get_browser_setup_count():
    browsers = json.loads(os.getenv("SAUCE_ONDEMAND_BROWSERS"))
    return len(browsers)
