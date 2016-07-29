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
Web App Test Case 2.3.x Linux Chrome
    [Documentation]    Launches App pulled directly from jenkins and tests addition of a plot and verifies the correct messages are displayed and app doesnt freeze or timeout. Test passes if the plot is submitted, all elements functio and plot is viewable in landcover.
    [Tags]    Appium
    ${Creds}=    Get Sauce Creds Jenkins
    Set Browser    ${Creds}    bSelenium=True    platform=${Platform}    os=${OS}    browserName=${BrowserName}    browser-version=${BrowserVersion}
    Test Case 2 3    bSelenium=True

Web App Test Case 2.1.x Linux Chrome
    [Documentation]    Launches App pulled directly from jenkins and tests addition of a plot and verifies the correct messages are displayed and app doesnt freeze or timeout. Test passes if the plot is submitted, all elements functio and plot is viewable in landcover.
    [Tags]    Appium
    ${Creds}=    Get Sauce Creds Jenkins
    Set Browser    ${Creds}    bSelenium=True    platform=${Platform}    os=${OS}    browserName=${BrowserName}    browser-version=${BrowserVersion}
    Test Case 2    bSelenium=True

Web App Test Case 2.4.x Linux Chrome
    [Documentation]    Launches App pulled directly from jenkins and tests addition of a plot and verifies the correct messages are displayed and app doesnt freeze or timeout. Test passes if the plot is submitted, all elements functio and plot is viewable in landcover.
    [Tags]    Appium
    ${Creds}=    Get Sauce Creds Jenkins
    Set Browser    ${Creds}    bSelenium=True    platform=${Platform}    os=${OS}    browserName=${BrowserName}    browser-version=${BrowserVersion}
    Test Case 2 4    bSelenium=True

Web App Test Case 0.x Linux Chrome
    [Documentation]    Launches App pulled directly from jenkins and tests addition of a plot and verifies the correct messages are displayed and app doesnt freeze or timeout. Test passes if the plot is submitted, all elements functio and plot is viewable in landcover.
    [Tags]    Appium
    ${Creds}=    Get Sauce Creds Jenkins
    Set Browser    ${Creds}    bSelenium=True    platform=${Platform}    os=${OS}    browserName=${BrowserName}    browser-version=${BrowserVersion}
    Test Case 0    bSelenium=True

*** Keywords ***
Open test browser jenkins
    [Arguments]    ${Capa}    ${Remote}
    Open browser    http://www.google.com    ${Browser}    \    remote_url=${Remote}    desired_capabilities=${Capa}

Manipulation
    Run keyword if    '${Process}'=='Portal'    Portal Manipulation
    Run keyword if    '${Process}'=='Api'    API Manipulation

Mobile Setup Jenks
    [Documentation]    Processes website when one browser is requested
    ${Caps}=    Get Jenkins Capabilities
    ${Creds}=    Get Sauce Creds Jenkins
    Open test browser jenkins    ${Caps}    ${Creds}
    Manipulation
    Run keyword if    '${REMOTE_URL}' != ''    Report Sauce status    ${SUITE_NAME} | ${TEST_NAME}    ${TEST_STATUS}    ${TEST_TAGS}    ${REMOTE_URL}
    Close all browsers

Close test browser Jenkins
    [Arguments]    ${URL}    ${Name}    ${Status}
    [Documentation]    Closes browsers and submits status to Saucelabs requires passing Remote url, Name of test, Status of test (PASS or FAIL)
    ${Mess}=    Set Variable if    '${Status}'=='Fail'    Failed on ${Function}    Pass
    Run keyword if    '${URL}' != ''    Report Sauce status    ${Mess} | ${Name}    ${Status}    Jenkins    ${URL}
    Close all browsers
