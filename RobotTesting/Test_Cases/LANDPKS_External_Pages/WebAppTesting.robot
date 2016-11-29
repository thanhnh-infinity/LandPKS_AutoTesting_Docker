*** Settings ***
Library           AppiumLibrary
Library           Selenium2Library
Library           Framework/Test_Case.py
Library           ../../Framework/SauceLabs.py

*** Variable ***
${appiumVersion}    1.4.16
${DeviceType}     Phone
${OS}             linux
${Platform}       linux
${BrowserName}    chrome
${BrowserVersion}    ""

*** Test Cases ***
#All LandInfo's Map Features 2.7.x Linux Chrome
#    [Documentation]    All LandInfo Map Features: 2.7.1 : Display plots on Map; 2.7.2: Detailed Information of plot on map; 2.7.3: Display map at current location; 2.7.4: Show current location on map; 2.7.5: Put zoom control in the upper left corner
#    [Tags]    WebApp
#    ${Creds}=    Get Sauce Creds Jenkins
#    Set Browser    ${Creds}    bSelenium=True    platform=${Platform}    os=${OS}    browserName=${BrowserName}    browser-version=${BrowserVersion}
#    Test Case 2 7    bSelenium=True

Metric Units Features 10.10.x Linux Chrome
    [Documentation]    Metrics Unit Features:
    [Tags]    WebApp
    ${Creds}=    Get Sauce Creds Jenkins
    Set Browser    ${Creds}    bSelenium=True    platform=${Platform}    os=${OS}    browserName=${BrowserName}    browser-version=${BrowserVersion}
    Test Case 10 10 Metric    bSelenium=True
    
English Units Features 10.10.x Linux Chrome
    [Documentation]    Metrics Unit Features:
    [Tags]    WebApp
    ${Creds}=    Get Sauce Creds Jenkins
    Set Browser    ${Creds}    bSelenium=True    platform=${Platform}    os=${OS}    browserName=${BrowserName}    browser-version=${BrowserVersion}
    Test Case 10 10 English   bSelenium=True

#Web App Test Case 2.3.x Linux Chrome
#    [Documentation]    Launches Web App directly and Runs tests in category 2.3 of manual test plan. Library and test structure is in library Test_case.py. Return what tests failed and were successful. Test Fails if Critical test is a failure.
#    [Tags]    WebApp
#    ${Creds}=    Get Sauce Creds Jenkins
#    Set Browser    ${Creds}    bSelenium=True    platform=${Platform}    os=${OS}    browserName=${BrowserName}    browser-version=${BrowserVersion}
#    Test Case 2 3    bSelenium=True

#Web App Test Case 2.1.x Linux Chrome
#    [Documentation]    Launches Web App directly and tests addition of a plot and Runs tests in category 2.1 of manual test plan. Library and test structure is in library Test case.py. Return what tests failed and were successful. Test Fails if Critical test is a failure.
#    [Tags]    WebApp
#    ${Creds}=    Get Sauce Creds Jenkins
#    Set Browser    ${Creds}    bSelenium=True    platform=${Platform}    os=${OS}    browserName=${BrowserName}    browser-version=${BrowserVersion}
#    Test Case 2    bSelenium=True

#Web App Test Case 2.4.x Linux Chrome
#    [Documentation]    Launches Web App directly and tests addition of a plot and Runs tests in category 2.4 of manual test plan. Library and test structure is in library Test case.py. Return what tests failed and were successful. Test Fails if Critical test is a failure.
#    [Tags]    WebApp
#    ${Creds}=    Get Sauce Creds Jenkins
#    Set Browser    ${Creds}    bSelenium=True    platform=${Platform}    os=${OS}    browserName=${BrowserName}    browser-version=${BrowserVersion}
#    Test Case 2 4    bSelenium=True

#Web App Test Case 0.x Linux Chrome
#    [Documentation]    [Documentation] Launches Web App directly and tests addition of a plot and Runs tests in category 0 of manual test plan on app tests this includes airplane testing. This is skipped for web app as airplane mode doesn't exist.. Library and test structure is in library Test case.py. Return what tests failed and were successful. Test Fails if Critical test is a failure.
#    [Tags]    WebApp
#    ${Creds}=    Get Sauce Creds Jenkins
#    Set Browser    ${Creds}    bSelenium=True    platform=${Platform}    os=${OS}    browserName=${BrowserName}    browser-version=${BrowserVersion}
#    Test Case 0    bSelenium=True

#Web App Test Case 3.1.x Linux Chrome
#    [Documentation]    [Documentation] Launches Web App directly and tests addition of a plot and Runs tests in category 3.1 of manual test plan on app tests This test takes a good while on phone emulation.. Library and test structure is in library Test case.py. Return what tests failed and were successful. Test Fails if Critical test is a failure.
#    [Tags]    WebApp    Portal
#    ${Creds}=    Get Sauce Creds Jenkins
#    Set Browser    ${Creds}    bSelenium=True    platform=${Platform}    os=${OS}    browserName=${BrowserName}    browser-version=${BrowserVersion}
#    Verify Portal And App Data Match    bSelenium=True

#Web App Prod Test Case 2.3.x Linux Chrome
#    [Documentation]    Launches Web App directly and Runs tests in category 2.3 of manual test plan. Library and test structure is in library Test_case.py. Return what tests failed and were successful. Test Fails if Critical test is a failure.
#    [Tags]    WebAppProduction
#    ${Creds}=    Get Sauce Creds Jenkins
#    Set Browser    ${Creds}    bSelenium=True    platform=${Platform}    os=${OS}    browserName=${BrowserName}    browser-version=${BrowserVersion}
#    Test Case 2 3    bSelenium=True    bProduction=True

#Web App Prod Test Case 2.1.x Linux Chrome
#    [Documentation]    Launches Web App directly and tests addition of a plot and Runs tests in category 2.1 of manual test plan. Library and test structure is in library Test case.py. Return what tests failed and were successful. Test Fails if Critical test is a failure.
#    [Tags]    WebAppProduction
#    ${Creds}=    Get Sauce Creds Jenkins
#    Set Browser    ${Creds}    bSelenium=True    platform=${Platform}    os=${OS}    browserName=${BrowserName}    browser-version=${BrowserVersion}
#    Test Case 2    bSelenium=True    bProduction=True

#Web App Prod Test Case 2.4.x Linux Chrome
#    [Documentation]    Launches Web App directly and tests addition of a plot and Runs tests in category 2.4 of manual test plan. Library and test structure is in library Test case.py. Return what tests failed and were successful. Test Fails if Critical test is a failure.
#    [Tags]    WebAppProduction
#    ${Creds}=    Get Sauce Creds Jenkins
#    Set Browser    ${Creds}    bSelenium=True    platform=${Platform}    os=${OS}    browserName=${BrowserName}    browser-version=${BrowserVersion}
#    Test Case 2 4    bSelenium=True    bProduction=True

#Web App Prod Test Case 0.x Linux Chrome
#    [Documentation]    [Documentation] Launches Web App directly and tests addition of a plot and Runs tests in category 0 of manual test plan on app tests this includes airplane testing. This is skipped for web app as airplane mode doesn't exist.. Library and test structure is in library Test case.py. Return what tests failed and were successful. Test Fails if Critical test is a failure.
#    [Tags]    WebAppProduction
#    ${Creds}=    Get Sauce Creds Jenkins
#    Set Browser    ${Creds}    bSelenium=True    platform=${Platform}    os=${OS}    browserName=${BrowserName}    browser-version=${BrowserVersion}
#    Test Case 0    bSelenium=True    bProduction=True

#Web App Prod Test Case 3.1.x Linux Chrome
#    [Documentation]    [Documentation] Launches Web App directly and tests addition of a plot and Runs tests in category 3.1 of manual test plan on app tests This test takes a good while on phone emulation.. Library and test structure is in library Test case.py. Return what tests failed and were successful. Test Fails if Critical test is a failure.
#    [Tags]    WebAppProduction    Portal
#    ${Creds}=    Get Sauce Creds Jenkins
#    Set Browser    ${Creds}    bSelenium=True    platform=${Platform}    os=${OS}    browserName=${BrowserName}    browser-version=${BrowserVersion}
#    Verify Portal And App Data Match    bSelenium=True

#Portal LandCover Test Case 0.x Linux Chrome
#    [Documentation]    [Documentation] Launches Portal Land Cover Form directly and runs tests according to test plan. Cannot split this test like others because the actions must all be completed to test these features.
#    [Tags]    FormsTest
#    ${Creds}=    Get Sauce Creds Jenkins
#    Set Browser    ${Creds}    bSelenium=True    platform=${Platform}    os=${OS}    browserName=${BrowserName}    browser-version=${BrowserVersion}
#    Test Case 0 LandCover

#Portal LandCover Test Case 0.1.x Use Deleted Plot in Landcover Form Linux Chrome
#    [Documentation]    [Documentation] Launches Portal Land Cover Form directly and landinfo simultaneously, deletes plot from landinfo and attempts to use it in landcover. Fails if plot is available
#    [Tags]    FormsTest
#    ${Creds}=    Get Sauce Creds Jenkins
#    Set Browser    ${Creds}    bSelenium=True    platform=${Platform}    os=${OS}    browserName=${BrowserName}    browser-version=${BrowserVersion}
#    Update LandInfo Stats So That They Use The LPKS API

#Portal Map Features 2.7.x Linux Chrome
#    [Documentation]    All Portal Map Features: 2.7.1 : Display plots on Map; 2.7.2: Detailed Information of plot on map; 2.7.3: Display map at current location; 2.7.4: Show current location on map
#    [Tags]    PortalMaps
#    ${Creds}=    Get Sauce Creds Jenkins
#    Set Browser    ${Creds}    bSelenium=True    platform=${Platform}    os=${OS}    browserName=${BrowserName}    browser-version=${BrowserVersion}
#    PortalMap
