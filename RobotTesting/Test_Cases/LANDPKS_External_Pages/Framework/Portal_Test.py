from Test_Case import Test_Case
from Test_Case import SetUpApp
from selenium.webdriver.common.by import By
import unittest
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
            Test = Test_Case
            SetUpApp(Test,bRobot=bRobot,bSelenium=True,starturl = "http://portallandpotential.businesscatalyst.com/LandPKS_FORMS/#/login",loginbutton="//a[@id='googlebutton']")
            #########
            # Your Stuff
            #########
        except:
            PassOrFail = "PASS"
        return PassOrFail,ERRORS,SUCCESS,WARNS
class Testing(unittest.TestCase):
    AppTest = Test_Case()
    def tester(self):
        #self.AppTest.PortalMap(False, False)
        #self.AppTest.Test_Case_2_3(False,False,False,True)
        #self.AppTest.Test_Case_2(False,False)
        self.AppTest.Update_LandInfo_Stats_so_that_they_use_the_LPKS_API(False)
        #self.AppTest.Test_Case_0(False,False)
        #self.AppTest.Test_Case_2_4(False,True)
        #self.AppTest.Verify_Portal_And_App_Data_Match(False, True)
        #self.AppTest.Verify_Portal_And_CSV_Data_Match(False,True)
        self.AppTest.Test_Case_2_3(False,False,False)
        self.AppTest.Test_Case_0_Form(False)
        #self.AppTest.Verify_Portal_And_App_Data_Match( bRobot = False,bSelenium = False)
        #self.AppTest.Test_Case_0( bRobot = False,bSelenium = True)
        #self.AppTest.test_add_plot(bRobot=False)
        #self.AppTest.test_add_plot_airplane_verify_it_appears_in_landcover(bRobot=False)
if __name__ == '__main__':    
    #GenDynaWebAppTestsAppend()
    
    suite = unittest.TestLoader().loadTestsFromTestCase(Testing)
    unittest.TextTestRunner(verbosity=2).run(suite)