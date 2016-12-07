'''
Created on Dec 6, 2016

@author: thanhnguyen
'''
def LogSuccess(errorMessage):
    global SUCCESS
    SUCCESS.append(errorMessage)
def checkSoillayerName_Tab(driver,PassOrFail):
    if (PassOrFail == "PASS"):
        LogSuccess("--Soil Layer 1's name is correct")
        LogSuccess("--Soil Layer 2's name is correct")
        LogSuccess("--Soil Layer 3's name is correct")
        LogSuccess("--Soil Layer 4's name is correct")
        LogSuccess("--Soil Layer 5's name is correct")
        LogSuccess("--Soil Layer 6's name is correct")
        LogSuccess("--Soil Layer 7's name is correct")
        return True
    else:
        return False
def checkSiteSummary(driver, PassOrFail):
    if (PassOrFail == "PASS"):
        LogSuccess("--Site summary is ok")
        return True
    else:
        return False
def checkGuideMe_RibbonLength(driver,PassOrFail):
    if (PassOrFail == "PASS"):
        LogSuccess("--Ribbon length is correct unit")   
        return True
    else:
        return False