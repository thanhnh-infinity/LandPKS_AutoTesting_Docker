'''
Created on Jul 8, 2016

@author: bbarnett
'''
from robot.api import logger
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import logger
from selenium.webdriver.support.wait import WebDriverWait
import time
import urllib
import httplib
import simplejson as json
from selenium.webdriver.remote.webdriver import WebDriver

def get_google_token():
        try:
            secrets = {
             "client_id": "254673914223-tv4pvoig9ouql2puvsuigmiuabaj87u8.apps.googleusercontent.com",
             "client_secret": "VIlyqfrpXMNJCx5gJREdftaz",
             "refresh_token": "1/_1WlcfmNJPESOkzxYjJj9abhkTQUoV74ICKJfqTgXBA",
             "grant_type": "refresh_token"
            }
            content_dict = secrets
            params = urllib.urlencode(content_dict)
    
            headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "text/plain"}
            conn = httplib.HTTPSConnection("www.googleapis.com")
            conn.request("POST", "/oauth2/v4/token", params, headers)
            response = conn.getresponse()
            data = json.loads(response.read())
            conn.close()
            return data["access_token"]
        except Exception as err:
            return err
def log_faster_map_export(iSecondsMap, iSecondsExport):
    iFasterBy = iSecondsMap-iSecondsExport if iSecondsMap > iSecondsExport else iSecondsExport-iSecondsMap
    if(iSecondsMap > iSecondsExport):
        msg = 'Pulling plot data from export is faster than filling the map with the same data by {0} seconds'.format(iFasterBy)
    else:
        msg = 'Filling map with plot data was faster than exporting the plot data by {0} seconds'.format(iFasterBy)
    logger.info(msg)
def select_pop_up_window():
    SeleniumLib = BuiltIn().get_library_instance('Selenium2Library')
    if(len(SeleniumLib._cache.get_open_browsers()) > 0):
        Curbrowser = SeleniumLib._current_browser()
        SwitchToPopupWindow(Curbrowser)
        time.sleep(1)
        return Curbrowser
def Close_Pop_Up_Window():
    curBrowser = select_pop_up_window()
    curBrowser.close()
    time.sleep(1)
    curBrowser.switch_to.window(curBrowser.window_handles[0])
def SwitchToPopupWindow(driver, TIMEOUT=10):
    wait = WebDriverWait(driver, TIMEOUT)
    time.sleep(3)
    wait.until(lambda driver: len(driver.window_handles) > 1)
    driver.switch_to.window(driver.window_handles[-1])
def get_webdriver_instance():
    se2lib = BuiltIn().get_library_instance('Selenium2Library')
    CurWebDriver = se2lib._current_browser()
    return CurWebDriver
def fill_xauth_element(Element):
    Element.send_keys(get_google_token())