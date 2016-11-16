from Test_Case import OutputErrors,OutputSucessful,SetUpApp
from selenium.webdriver.common.by import By

def Showing(self, bRobot=True):
        global ERRORS,SUCCESS,WARNS
        ERRORS = []
        SUCCESS = []
        WARNS = []
        PassOrFail = "PASS"
        try:
            SetUpApp(self,bRobot=bRobot,bSelenium=True,starturl = "http://portallandpotential.businesscatalyst.com/LandPKS_FORMS/#/login",loginbutton="//a[@id='googlebutton']")
            #########
            # Your Stuff
            #########
        except:
            PassOrFail = "PASS"
        finally:
            OutputErrors()
            OutputSucessful()
            self.tearDown(PassOrFail, bRobot,bSelenium=True)
