from selenium import webdriver

from selenium.webdriver.remote.command import Command
from robot.libraries.BuiltIn import BuiltIn
import os
from Selenium2Library import Selenium2Library

class RobotPlugins:
    robotDriverRemote = webdriver.Remote
    def get_browser(self, RemoteUrl, Capabilities):
        robotDriverRemote = Selenium2Library.open_browser("www.google.com", remote_url = RemoteUrl, desired_capabilities=Capabilities)
        return robotDriverRemote
    def set_browser(self):
        self.robotDriverRemote = BuiltIn().get_library_instance('Selenium2Library')._current_browser()
    def close_popup(self, handle):
        self.switch_to_window(handle)
        self.robotDriverRemote.close()
    def switch_to_window(self, handle):
        data = {'name': handle}
        self.robotDriverRemote.execute(Command.SWITCH_TO_WINDOW, data)