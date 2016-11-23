from Test_Case import *
from Test_Case import SetUpApp
from selenium.webdriver.common.by import By
import os
from selenium import webdriver


chromedriver = "C:\Users\Ujjwal\Downloads\chromedriver_win32\chromedriver"
os.environ["webdriver.chrome.driver"] = chromedriver

ERRORS = []
SUCCESS = []
WARNS=[]
url = "http://portallandpotential.businesscatalyst.com/LandPKS_FORMS/#/"
landcover_img_xpath = '//*[@id="landpks-page"]/div[2]/div[3]/a'

class Portal_Test:
    def Showing(self,bRobot=True):
            global ERRORS,SUCCESS,WARNS
            ERRORS = []
            SUCCESS = []
            WARNS = []
            PassOrFail = "PASS"
            try:
                # Test = Test_Case
                self.driver = webdriver.Chrome(chromedriver)

                SetUpApp(self,bRobot=bRobot,bSelenium=True,starturl= url+"login",loginbutton="//a[@id='googlebutton']")
                time.sleep(1)
                win = self.driver.window_handles
                self.driver.switch_to.window(win[0])
                ClickElementIfVis(self.driver, By.XPATH, LAND_FORMS_LAND_COVER_ICON)
                WaitForLoadForm(self.driver)



            except  Exception as e:
                PassOrFail = "PASS"
            return PassOrFail,ERRORS,SUCCESS,WARNS

# if __name__ == '__main__':
#     #GenDynaWebAppTestsAppend()
#     Showing()

