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
Portal Advise User to Logout/Login, Landinfo MultiDelete and Photos Download
    [Documentation]    Checks the form for logout/login message after data edit, Allow users delete multiple plots, Allow users to download photos from landinfo form on Chrome
    [Tags]    FormsTest
    ${x} =  Advise User Logout Login Multidelete PhotosDownload
    should be equal as strings       ${x}        PASS


*** Keywords ***
