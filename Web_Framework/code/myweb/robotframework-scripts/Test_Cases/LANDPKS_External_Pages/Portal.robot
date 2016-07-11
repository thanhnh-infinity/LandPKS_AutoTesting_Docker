*** Settings ***
Library           Selenium2Library
Library           DateTime
Library           ../../Framework/SauceLabs.py
Library           String
Library           ../../Framework/Testing.py
Library           Framework/RobotPlugins.py

*** Variables ***
${PortalMapHome}    http://portallandpotential.businesscatalyst.com/Export/ExportandMap.html
${LoadingBarXpath}    xpath=//div[@class='progress-bar progress-bar-success progress-bar-striped active']
${Browser}        firefox
${PlotsPulledXpath}    xpath=//strong[@id='total-plots-displayed']
${ExportLoadingBarXpath}    xpath=//div[@class='progress-bar progress-bar-striped active']
${ExportLoadingIMGXpath}    img id=loading_msg
${ExportEmailID}    id=userName
${ExportButtonID}    id=export-button
${PortalDataSheets}    http://landpotential.businesscatalyst.com/landpks.html#manuals
${PortalLIDataSheetXpath}    xpath=//a[@id='u41866-4']
${PortalLCDataSheetXpath}    xpath=//a[@id='u59333-4']
${PortalLIDataSheetImgXp}    xpath=//img[@id='u59344_img']
${PortalLCDataSheetImgXp}    xpath=//img[@id='u59336_img']
${LinkForPortalXpath}    xpath=//a[@href='http://portal.landpotential.org/']
${LandInfoAppURL}    https://play.google.com/store/apps/details?id=com.noisyflowers.landpks.android&hl=en
${LandCoverAppURL}    https://play.google.com/store/apps/details?id=com.noisyflowers.rangelandhealthmonitor.android
${LandInfoAppXpath}    //span[@id='u13764']
${LandCoverAppXpath}    //span[@id='u10901']

*** Test Cases ***
Portal Testing
    Set Test Variable    ${Function}    Browser Init
    ${JenkinsSetupSize}=    Get Browser Setup Count
    run keyword if    ${JenkinsSetupSize} >1    Mobile Multi Setup Jenks
    ...    ELSE    Mobile Setup Jenks

*** Keywords ***
Close test browser
    Run keyword if    '${REMOTE_URL}' != ''    Report Sauce status    ${SUITE_NAME} | ${TEST_NAME}    ${TEST_STATUS}    ${TEST_TAGS}    ${REMOTE_URL}
    Close all browsers

Close test browser Jenkins
    [Arguments]    ${URL}    ${Name}    ${Status}
    [Documentation]    Closes browsers and submits status to Saucelabs requires passing Remote url, Name of test, Status of test (PASS or FAIL)
    ${Mess}=    Set Variable if    '${Status}'=='Fail'    Failed on ${Function}    Pass
    Run keyword if    '${URL}' != ''    Report Sauce status    ${Mess} | ${Name}    ${Status}    Jenkins    ${URL}
    Close all browsers

Open test browser jenkins
    [Arguments]    ${Capa}    ${Remote}
    Open browser    http://www.google.com    ${Browser}    \    remote_url=${Remote}    desired_capabilities=${Capa}

Mobile Multi Setup Jenks
    [Documentation]    Processes webpage execution when more than one browser is setup
    ${Creds}=    Get Sauce Creds Jenkins
    @{Browsers}=    Get Browsers
    : FOR    ${Browser}    IN    @{Browsers}
    \    ${caps}=    Set Jenkins Capabilities    ${Browser["browser"]}    ${Browser["platform"]}    ${Browser["version"]}
    \    Open test browser jenkins    ${caps}    ${Creds}
    \    ${Status}=    run keyword and return status    Manipulation
    \    ${PassOrFail}    set variable if    ${Status}    PASS    Fail
    \    Close Test Browser Jenkins    ${Creds}    ${Browser["platform"]} | ${Browser["browser"]} | ${Browser["version"]}    ${PassOrFail}

Mobile Setup Jenks
    [Documentation]    Processes website when one browser is requested
    ${Caps}=    Get Jenkins Capabilities
    ${Creds}=    Get Sauce Creds Jenkins
    Open test browser jenkins    ${Caps}    ${Creds}
    Manipulation

Get Jenkins Driver
    [Documentation]    Runs full blown test suite that tests entire lpks test and manipulates the entire webpage
    Set Selenium Timeout    15 seconds
    Set Selenium Speed    .3 seconds
    ${JenkinsSetupSize}=    Get Browser Setup Count
    run keyword if    ${JenkinsSetupSize} >1    Mobile Multi Setup Jenks
    ...    ELSE    Mobile Setup Jenks

Manipulation
    Set Test Variable    ${Function}    Processing Portal Data Export
    Go to    ${PortalMapHome}
    ${Start}=    Get Time    epoch
    Wait for load    ${LoadingBarXpath}
    ${Finish}=    Get Time    epoch
    ${TimeToFinishMapLoad}=    evaluate    ${Finish}-${Start}
    Element should be visible    ${PlotsPulledXpath}
    ${NumPlotsPulled}=    Get Text    ${PlotsPulledXpath}
    ${TimePerPlot}=    Evaluate    ${TimeToFinishMapLoad}/${NumPlotsPulled}
    Input text    ${ExportEmailID}    all
    Click Element    ${ExportButtonID}
    ${IMG}=    Run Keyword And Return Status    Element Should be Visible    ${ExportLoadingIMGXpath}
    ${Start}=    Get Time    epoch
    Run Keyword if    ${IMG}    Wait For Load    ${ExportLoadingIMGXpath}
    ...    ELSE    Wait For Load    ${ExportLoadingBarXpath}
    ${Finish}=    Get Time    epoch
    ${TimeToFinishExport}=    evaluate    ${Finish}-${Start}
    Go To    ${PortalDataSheets}
    Click Element    ${PortalLIDataSheetXpath}
    Check Popup Occured
    Click Element    ${PortalLCDataSheetXpath}
    Check Popup Occured
    Click Element    ${PortalLIDataSheetImgXp}
    Check Popup Occured
    Click Element    ${PortalLCDataSheetImgXp}
    Check Popup Occured
    click element    ${LinkForPortalXpath}

Check Popup Occured
    ${Windows}=    List Windows
    ${WinCount}=    Get Length    ${Windows}
    Should Be True    ${WinCount}>1
    log    ${Windows[1]}
    Select Window    popup
    Close Window
    select window

Wait for load
    [Arguments]    ${ELE}
    [Documentation]    Verifies page has loading based upon loading containers
    log    Waiting for page to load
    : FOR    ${I}    IN RANGE    1    60
    \    ${TextThere}=    run keyword and return status    Element Should Be Visible    ${ELE}
    \    run keyword unless    ${TextThere}    Exit for Loop
    \    BuiltIn.Sleep    1s

mobile land info using main page
    [Documentation]    Uses main page of webpage to navigate to and manipulate individual components
    Set Test Variable    ${Function}    Processing Main Page
    ${count}=    Get Matching Xpath Count    ${LinksAddPlot}
    @{Links}=    Get WebElements    xpath=${LinksAddPlot}
    : FOR    ${i}    IN RANGE    1    ${count} + 1
    \    ${link}=    Get WebElement    xpath=(${LinksAddPlot})[${i}]
    \    ${Atrib}=    get element atrrib    ${link}    href
    \    log    Processing Page | ${Atrib}
    \    click element if visable    ${link}
    \    run keyword if    '${Atrib}' == 'http://testlpks.landpotential.org:8105/#/landpks/landinfo_soillayers'    Exit for loop
    \    proc current module
    \    Try to submit Land Info
    \    Check for land info sucess
    proc soil layers
    Check for land info sucess
