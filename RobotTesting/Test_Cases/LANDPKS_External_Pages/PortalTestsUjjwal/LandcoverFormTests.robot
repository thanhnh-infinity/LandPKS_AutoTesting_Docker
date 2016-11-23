*** Settings ***

Library           AppiumLibrary
Library          Selenium2Library
Library         ../Framework/Portal_Test.py

*** Variables ***
${PortalFormsHome}    http://portallandpotential.businesscatalyst.com/LandPKS_FORMS/#/login
${LoginButton}      //a[@id='googlebutton']
${CREDENTIALS}              key:secret
${Browser}                  chrome
${WaitTime}                    5 seconds
${Remote}                   False
${Capa}             None
${webdriver}        None

*** Test Cases ***
Advise User to Logout/Login
    [Documentation]    Checks Landinfo and Landcover form for logout/login message after any data edit
    Showing


*** Keywords ***
