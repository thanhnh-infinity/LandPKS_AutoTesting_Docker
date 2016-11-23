from Test_Case import *
from Test_Case import SetUpApp
from selenium.webdriver.common.by import By
from selenium import webdriver

ERRORS = []
SUCCESS = []
WARNS = []
url = "http://portallandpotential.businesscatalyst.com/LandPKS_FORMS/#/"
landcover_img_xpath = '//*[@id="landpks-page"]/div[2]/div[3]/a'
dropdown_xpath = '//*[@id="plot-selection-div"]/div/div[1]/div/a'
dropdown_xpathLandinfo = '//*[@id="plot-selection-div"]/div[1]/div/div/div[1]/span'
searchbox_xpath = '//*[@id="plot-selection-div"]/div/div[1]/div/div/div/input'
searchbox_xpathLandinfo = '//*[@id="plot-selection-div"]/div[1]/div/div/input[1]'
multidelete_xpathLandinfo = '//*[@id="plot-selection-div"]/div[2]/div[1]/div/div/div/input'
multidelete_xpathPlot = '//*[@id="ui-select-choices-row-1-0"]/a'
plot_name = "UjjwalTest"
botton_id = "update"
datebox_id = "recorded_date"
plot_xpath = '//*[@id="ui-select-choices-row-0-0"]/div/div'
plot_xpathLandinfo = '//*[@id="ui-select-choices-row-0-0"]/a'
date_xpath = '//*[@id="recorded_date"]/option[2]'
yesBotton_Dialog = '/html/body/div[2]/div[3]/div/button[1]'
chromedriver = "C:\Users\Ujjwal\Downloads\chromedriver_win32\chromedriver"
sucessMessageBoxID = "sessionSuccessMessage"
sucessMessageBoxCancel = '//*[@id="sessionSuccessMessage"]/div/button'
sucessMessageDiv = '//*[@id="sessionSuccessMessage"]/div'
adviceUserMessage = 'please logout and login'


class Portal_Test:
    def Advise_User_Logout_Login(self, bRobot=True):
        global ERRORS, SUCCESS, WARNS
        ERRORS = []
        SUCCESS = []
        WARNS = []
        PassOrFail = "PASS"
        try:
            # Test = Test_Case
            # self.driver = webdriver.Chrome(chromedriver)

            SetUpApp(self, bRobot=bRobot, bSelenium=True, starturl=url + "login", loginbutton="//a[@id='googlebutton']")
            time.sleep(1)
            win = self.driver.window_handles
            self.driver.switch_to.window(win[0])
            ClickElementIfVis(self.driver, By.XPATH, LAND_FORMS_LAND_COVER_ICON)
            WaitForLoadForm(self.driver)
            ClickElementIfVis(self.driver, By.XPATH, dropdown_xpath)
            time.sleep(1)
            self.driver.find_element_by_xpath(searchbox_xpath).send_keys(plot_name)
            ClickElementIfVis(self.driver, By.XPATH, plot_xpath)
            ClickElementIfVis(self.driver, By.ID, datebox_id)
            ClickElementIfVis(self.driver, By.XPATH, date_xpath)
            ClickElementIfVis(self.driver, By.ID, botton_id)
            ClickElementIfVis(self.driver, By.XPATH, yesBotton_Dialog)
            element = WebDriverWait(self.driver, 20).until(
                EC.element_to_be_clickable((By.XPATH, sucessMessageBoxCancel)))
            text = self.driver.find_element_by_xpath(sucessMessageDiv).text
            if not (adviceUserMessage in text):
                PassOrFail = "FAIL"
            LogSuccess("Advise User Login Logout: Pass")


        except  Exception as e:
            log.error(e.message)
            PassOrFail = "FAIL"
        return PassOrFail, ERRORS, SUCCESS, WARNS

    def Landinfo_MultiDelete_DownloadPhoto(self, bRobot=True):
        global ERRORS, SUCCESS, WARNS
        ERRORS = []
        SUCCESS = []
        WARNS = []
        PassOrFail = "PASS"
        try:
            # self.driver = webdriver.Chrome(chromedriver)

            SetUpApp(self, bRobot=bRobot, bSelenium=True, starturl=url + "login", loginbutton="//a[@id='googlebutton']")
            time.sleep(1)
            win = self.driver.window_handles
            self.driver.switch_to.window(win[0])
            ClickElementIfVis(self.driver, By.XPATH, LAND_FORMS_LAND_INFO_ICON)
            WaitForLoadForm(self.driver)
            time.sleep(0.1)
            ClickElementIfVis(self.driver, By.XPATH, multidelete_xpathLandinfo)
            time.sleep(0.1)
            ClickElementIfVis(self.driver, By.XPATH, multidelete_xpathPlot)
            time.sleep(0.1)
            ClickElementIfVis(self.driver, By.XPATH, multidelete_xpathPlot)
            time.sleep(5)
            ClickElementIfVis(self.driver, By.XPATH, dropdown_xpathLandinfo)
            time.sleep(0.1)
            self.driver.find_element_by_xpath(searchbox_xpathLandinfo).send_keys(plot_name)
            ClickElementIfVis(self.driver, By.XPATH, plot_xpathLandinfo)
            self.driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
            LogSuccess("Test Multi Plots Delete: Pass")
            LogSuccess("Test Download Photo Chrome: Pass")


        except  Exception as e:
            log.error(e.message)
            PassOrFail = "FAIL"
        return PassOrFail, ERRORS, SUCCESS, WARNS


if __name__ == '__main__':
    test = Portal_Test()
    x = test.Advise_User_Logout_Login()
    print "x"
