import re
import requests
import simplejson as json
import os
from selenium import webdriver
from robot.api import logger
from robot.libraries.BuiltIn import BuiltIn

USERNAME_ACCESS_KEY = re.compile('^(http|https):\/\/([^:]+):([^@]+)@')


def report_sauce_status(name, status, tags=[], remote_url=''):
    # Parse username and access_key from the remote_url
    assert USERNAME_ACCESS_KEY.match(remote_url), 'Incomplete remote_url.'
    username, access_key = USERNAME_ACCESS_KEY.findall(remote_url)[0][1:]

    # Get selenium session id from the keyword library
    selenium = BuiltIn().get_library_instance('Selenium2Library')
    job_id = selenium._current_browser().session_id

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
        logger.info('<a href="{0}">video.flv</a>'.format(video_url), html=True)
def get_jenkins_platform():
    desire_cap =    webdriver.DesiredCapabilities.CHROME
    desire_cap['browserName'] = '{0}'.format(os.environ.get("SELENIUM_BROWSER"))
    desire_cap['Version'] = '{0}'.format(os.environ.get("SELENIUM_VERSION"))
    desire_cap['Capability'] = '{0}'.format(os.environ.get("SELENIUM_PLATFORM"))
    logger.info('Browser:{0} Version:{1} Capability:{2} URL:{3}:{4}'.format(
            os.environ.get("SELENIUM_BROWSER"),
            os.environ.get("SELENIUM_VERSION"),
            os.environ.get("SELENIUM_PLATFORM"),
            os.environ.get("SAUCE_USERNAME"),
            os.environ.get("SAUCE_ACCESS_KEY")
            )
        )
    driver = webdriver.Remote(
        desired_capabilities=desire_cap,
        command_executor = 'http://{0}:{1}@ondemand.saucelabs.com:80/wd/hub'.format(
            os.environ.get("SAUCE_USERNAME"),
            os.environ.get("SAUCE_ACCESS_KEY")
            )
        )
    selenium = BuiltIn().get_library_instance('Selenium2Library')
    selenium._current_browser = driver
    return driver
def get_jenkins_capabilities():

    capa = 'name:Testing with Jenkins RobotFramework Selenium2Library,browserName:{0}, platform:{1},version:{2}'.format(os.environ.get("SELENIUM_BROWSER"),os.environ.get("SELENIUM_PLATFORM"),os.environ.get("SELENIUM_VERSION"))
    return capa
def set_jenkins_capabilities(browser, platform, version):
    if(browser == "firefox"):
       capa = 'name:Testing with Jenkins RobotFramework Selenium2Library,browserName:{0}, platform:{1},version:{2},recordScreenshots:false,recordVideo:false'.format(browser,platform,version)
    else:
        capa = 'name:Testing with Jenkins RobotFramework Selenium2Library,browserName:{0}, platform:{1},version:{2}'.format(browser,platform,version)
    return capa
def get_sauce_creds_jenkins():
    creds = 'http://{0}:{1}@ondemand.saucelabs.com:80/wd/hub'.format(os.environ.get("SAUCE_USERNAME"),
                             os.environ.get("SAUCE_ACCESS_KEY")
                             )
    return creds
def get_uname_and_pword_lpks_gmail():
    loginCred = {
        os.environ.get("LPKS_TEST_UNAME"),
        os.environ.get("LPKS_TEST_PWORD")
        }
    return loginCred

        
