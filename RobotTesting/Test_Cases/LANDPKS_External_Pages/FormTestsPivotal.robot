*** Settings ***

Library           AppiumLibrary
Library          Selenium2Library
Library          Collections
Library         Framework/Portal_Test.py

*** Variables ***
${PortalFormsHome}    http://portallandpotential.businesscatalyst.com/LandPKS_FORMS/#/login
${LoginButton}      //a[@id='googlebutton']
${CREDENTIALS}              key:secret
${Browser}                  chrome
${WaitTime}                    5 seconds
${Remote}                   False
${Capa}             None
${webdriver}        None
${appiumVersion}    1.4.16
${DeviceType}     Phone
${OS}             linux
${Platform}       linux
${BrowserName}    chrome
${BrowserVersion}    ""

*** Test Cases ***
Portal Advise User to Logout/Login
    [Documentation]    Checks the form for logout/login message after data edit
    [Tags]    FormsTest     PortalForms
    ${Creds}=    Get Sauce Creds Jenkins
    Set Browser    ${Creds}    bSelenium=True    platform=${Platform}    os=${OS}    browserName=${BrowserName}    browser-version=${BrowserVersion}
    ${x} =  Advise User Logout Login
    list should contain value       ${x}        PASS

Portal Landinfo MultiDelete Photos Download
    [Documentation]    Allow users delete multiple plots, Allow users to download photos from landinfo form on Chrome
    [Tags]    FormsTest     PortalForms
    ${Creds}=    Get Sauce Creds Jenkins
    Set Browser    ${Creds}    bSelenium=True    platform=${Platform}    os=${OS}    browserName=${BrowserName}    browser-version=${BrowserVersion}
    ${x} =  landinfo multidelete downloadphoto
    list should contain value       ${x}        PASS


*** Keywords ***
