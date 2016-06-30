from selenium import webdriver

from selenium.common.exceptions import WebDriverException
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import TimeoutException
from selenium.webdriver.common.by import By
from datetime import datetime

import os
from Selenium2Library import Selenium2Library

class RobotPlugins:
    robotDriverRemote = webdriver.Remote
    def get_browser(self, RemoteUrl, Capabilities):
        robotDriverRemote = Selenium2Library.open_browser("www.google.com", remote_url = RemoteUrl, desired_capabilities=Capabilities)
        return robotDriverRemote
    def hello():
        print "Hello"
