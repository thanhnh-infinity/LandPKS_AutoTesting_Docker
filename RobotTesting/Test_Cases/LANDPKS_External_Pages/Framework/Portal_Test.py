from Test_Case import SetUpApp
from selenium.webdriver.common.by import By
ERRORS = []
SUCCESS = []
WARNS=[]
def Showing( bRobot=True):
        global ERRORS,SUCCESS,WARNS
        ERRORS = []
        SUCCESS = []
        WARNS = []
        PassOrFail = "PASS"
        try:
            SetUpApp(bRobot=bRobot,bSelenium=True,starturl = "http://portallandpotential.businesscatalyst.com/LandPKS_FORMS/#/login",loginbutton="//a[@id='googlebutton']")
            #########
            # Your Stuff
            #########
        except:
            PassOrFail = "PASS"
        return PassOrFail,ERRORS,SUCCESS,WARNS
