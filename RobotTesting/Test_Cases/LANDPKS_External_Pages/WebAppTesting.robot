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