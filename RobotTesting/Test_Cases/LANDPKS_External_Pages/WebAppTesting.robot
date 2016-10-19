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
Web App Test Case pivotal_story_132082507.x Linux Chrome
    [Documentation]    Pivotal Story 132082507. Content : Display Map at current location. PASS when (As a user I want to view the map so that I can it centered at my current location and I know I've succeeded when the map recenters when I move)
    [Tags]    WebApp
    ${Creds}=    Get Sauce Creds Jenkins
    Set Browser    ${Creds}    bSelenium=True    platform=${Platform}    os=${OS}    browserName=${BrowserName}    browser-version=${BrowserVersion}
    Test Case Pivotal Story 132082507    bSelenium=True

Web App Test Case pivotal_story_132278129.x Linux Chrome
    [Documentation]    Pivotal Story 132278129. Content : Display Map at current location. PASS when (As a user I wish to see my current location as a blue dot on the map and I know this is correct when I change location and the blue dot changes location with me. The dot should be the same size as the plot dots and the color should be blue instead of red)
    [Tags]    WebApp
    ${Creds}=    Get Sauce Creds Jenkins
    Set Browser    ${Creds}    bSelenium=True    platform=${Platform}    os=${OS}    browserName=${BrowserName}    browser-version=${BrowserVersion}
    Test Case Pivotal Story 132278129    bSelenium=True
    
Web App Test Case 2.3.x Linux Chrome
    [Documentation]    Launches Web App directly and Runs tests in category 2.3 of manual test plan. Library and test structure is in library Test_case.py. Return what tests failed and were successful. Test Fails if Critical test is a failure.
    [Tags]    WebApp
    ${Creds}=    Get Sauce Creds Jenkins
    Set Browser    ${Creds}    bSelenium=True    platform=${Platform}    os=${OS}    browserName=${BrowserName}    browser-version=${BrowserVersion}
    Test Case 2 3    bSelenium=True

Web App Test Case 2.1.x Linux Chrome
    [Documentation]    Launches Web App directly and tests addition of a plot and Runs tests in category 2.1 of manual test plan. Library and test structure is in library Test case.py. Return what tests failed and were successful. Test Fails if Critical test is a failure.
    [Tags]    WebApp
    ${Creds}=    Get Sauce Creds Jenkins
    Set Browser    ${Creds}    bSelenium=True    platform=${Platform}    os=${OS}    browserName=${BrowserName}    browser-version=${BrowserVersion}
    Test Case 2    bSelenium=True

Web App Test Case 2.4.x Linux Chrome
    [Documentation]    Launches Web App directly and tests addition of a plot and Runs tests in category 2.4 of manual test plan. Library and test structure is in library Test case.py. Return what tests failed and were successful. Test Fails if Critical test is a failure.
    [Tags]    WebApp
    ${Creds}=    Get Sauce Creds Jenkins
    Set Browser    ${Creds}    bSelenium=True    platform=${Platform}    os=${OS}    browserName=${BrowserName}    browser-version=${BrowserVersion}
    Test Case 2 4    bSelenium=True

Web App Test Case 0.x Linux Chrome
    [Documentation]    [Documentation] Launches Web App directly and tests addition of a plot and Runs tests in category 0 of manual test plan on app tests this includes airplane testing. This is skipped for web app as airplane mode doesn't exist.. Library and test structure is in library Test case.py. Return what tests failed and were successful. Test Fails if Critical test is a failure.
    [Tags]    WebApp
    ${Creds}=    Get Sauce Creds Jenkins
    Set Browser    ${Creds}    bSelenium=True    platform=${Platform}    os=${OS}    browserName=${BrowserName}    browser-version=${BrowserVersion}
    Test Case 0    bSelenium=True

Web App Test Case 3.1.x Linux Chrome
    [Documentation]    [Documentation] Launches Web App directly and tests addition of a plot and Runs tests in category 3.1 of manual test plan on app tests This test takes a good while on phone emulation.. Library and test structure is in library Test case.py. Return what tests failed and were successful. Test Fails if Critical test is a failure.
    [Tags]    WebApp    Portal
    ${Creds}=    Get Sauce Creds Jenkins
    Set Browser    ${Creds}    bSelenium=True    platform=${Platform}    os=${OS}    browserName=${BrowserName}    browser-version=${BrowserVersion}
    Verify Portal And App Data Match    bSelenium=True

Web App Prod Test Case 2.3.x Linux Chrome
    [Documentation]    Launches Web App directly and Runs tests in category 2.3 of manual test plan. Library and test structure is in library Test_case.py. Return what tests failed and were successful. Test Fails if Critical test is a failure.
    [Tags]    WebAppProduction
    ${Creds}=    Get Sauce Creds Jenkins
    Set Browser    ${Creds}    bSelenium=True    platform=${Platform}    os=${OS}    browserName=${BrowserName}    browser-version=${BrowserVersion}
    Test Case 2 3    bSelenium=True    bProduction=True

Web App Prod Test Case 2.1.x Linux Chrome
    [Documentation]    Launches Web App directly and tests addition of a plot and Runs tests in category 2.1 of manual test plan. Library and test structure is in library Test case.py. Return what tests failed and were successful. Test Fails if Critical test is a failure.
    [Tags]    WebAppProduction
    ${Creds}=    Get Sauce Creds Jenkins
    Set Browser    ${Creds}    bSelenium=True    platform=${Platform}    os=${OS}    browserName=${BrowserName}    browser-version=${BrowserVersion}
    Test Case 2    bSelenium=True    bProduction=True

Web App Prod Test Case 2.4.x Linux Chrome
    [Documentation]    Launches Web App directly and tests addition of a plot and Runs tests in category 2.4 of manual test plan. Library and test structure is in library Test case.py. Return what tests failed and were successful. Test Fails if Critical test is a failure.
    [Tags]    WebAppProduction
    ${Creds}=    Get Sauce Creds Jenkins
    Set Browser    ${Creds}    bSelenium=True    platform=${Platform}    os=${OS}    browserName=${BrowserName}    browser-version=${BrowserVersion}
    Test Case 2 4    bSelenium=True    bProduction=True

Web App Prod Test Case 0.x Linux Chrome
    [Documentation]    [Documentation] Launches Web App directly and tests addition of a plot and Runs tests in category 0 of manual test plan on app tests this includes airplane testing. This is skipped for web app as airplane mode doesn't exist.. Library and test structure is in library Test case.py. Return what tests failed and were successful. Test Fails if Critical test is a failure.
    [Tags]    WebAppProduction
    ${Creds}=    Get Sauce Creds Jenkins
    Set Browser    ${Creds}    bSelenium=True    platform=${Platform}    os=${OS}    browserName=${BrowserName}    browser-version=${BrowserVersion}
    Test Case 0    bSelenium=True    bProduction=True

Web App Prod Test Case 3.1.x Linux Chrome
    [Documentation]    [Documentation] Launches Web App directly and tests addition of a plot and Runs tests in category 3.1 of manual test plan on app tests This test takes a good while on phone emulation.. Library and test structure is in library Test case.py. Return what tests failed and were successful. Test Fails if Critical test is a failure.
    [Tags]    WebAppProduction    Portal
    ${Creds}=    Get Sauce Creds Jenkins
    Set Browser    ${Creds}    bSelenium=True    platform=${Platform}    os=${OS}    browserName=${BrowserName}    browser-version=${BrowserVersion}
    Verify Portal And App Data Match    bSelenium=True
