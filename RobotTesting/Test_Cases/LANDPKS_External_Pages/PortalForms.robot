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

*** Test Cases ***
#Portal Advise User to Logout/Login
#    [Documentation]    Checks the form for logout/login message after data edit
#    [Tags]    FormsTest
#    ${x} =  Advise User Logout Login
#    list should contain value       ${x}        PASS

Portal Landinfo MultiDelete And Photos Download
    [Documentation]    Allow users delete multiple plots, Allow users to download photos from landinfo form on Chrome
    [Tags]    FormsTest
    ${x} =  landinfo multidelete downloadphoto
    list should contain value       ${x}        PASS


*** Keywords ***
