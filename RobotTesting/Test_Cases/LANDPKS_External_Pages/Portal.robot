*** Settings ***
Library           Selenium2Library
Library           DateTime
Library           ../../Framework/SauceLabs.py
Library           String
Library           ../../Framework/Testing.py
Library           Framework/WebHelpers.py
Library           Framework/RobotPlugins.py
Library           Framework/Test_Case.py
Library           Framework/WebHelpers.py

*** Variables ***
${PortalMapHome}    http://portallandpotential.businesscatalyst.com/Export/ExportandMap.html
${PortalDataSheets}    http://landpotential.businesscatalyst.com/landpks.html#manuals
${APIProductionExplorerURL}    portal.landpotential.org/api_explorer
${APITestExplorerURL}    http://128.123.177.103/api_explorer/
${LoadingBarXpath}    xpath=//div[@class='progress-bar progress-bar-success progress-bar-striped active']
${Browser}        firefox
${PlotsPulledXpath}    xpath=//strong[@id='total-plots-displayed']
${ExportLoadingBarXpath}    xpath=//div[@class='progress-bar progress-bar-striped active']
${ExportLoadingIMGXpath}    id=loading_msg
${ExportEmailID}    id=userName
${ExportButtonID}    id=export-button
${PortalLIDataSheetXpath}    xpath=//a[@id='u41866-4']
${PortalLCDataSheetXpath}    xpath=//a[@id='u59333-4']
${PortalLIDataSheetImgXp}    xpath=//img[@id='u59344_img']
${PortalLCDataSheetImgXp}    xpath=//img[@id='u59336_img']
${LinkForPortalXpath}    xpath=//a[@href='http://portal.landpotential.org/']
${LandInfoAppURL}    https://play.google.com/store/apps/details?id=com.noisyflowers.landpks.android&hl=en
${LandCoverAppURL}    https://play.google.com/store/apps/details?id=com.noisyflowers.rangelandhealthmonitor.android
${LandInfoAppXpath}    //span[@id='u13764']
${LandCoverAppXpath}    //span[@id='u10901']
${LinksPortalXpath}    //nav[@class='MenuBar clearfix grpelem']/div
${WaitTimeout}    90
${APIExplorRequestTypeXPRsc}    //ul[@id='resources']/li
${APIExplorRequestTypeXPRscBut}    /div[@class='heading']/h2/a
${APIExplorOpenTypeXpStart}    //ul[@id='resources']/li
${APIExplorOpenTypeXpStop}    /ul/li
${APIExplorerOpenTypeStopBut}    /ul[@class='operations']/li/div[@class='heading']/h3/span[@class='http_method']/a
${ApiExplorerResponseThrobber}    //span[@class='response_throbber']
${XauthControlName}    X-Auth-Token

*** Test Cases ***
Portal Testing
    [Documentation]    Checks portal and makes sure export works properly and all links direct properly. Will error and log detailed message of what failed and on which page
    [Tags]    Main Portal
    Set Test Variable    ${Function}    Browser Init
    Set Test Variable    ${Process}    Portal
    ${JenkinsSetupSize}=    Get Browser Setup Count
    run keyword if    ${JenkinsSetupSize} >1    Mobile Multi Setup Jenks
    ...    ELSE    Mobile Setup Jenks    Portal

Api Explorer Test Production
    [Documentation]    Runs all querys on api explorer. Logs queries and type as it proceeds. Verifies the query only contains one query parameter. Verifies that the api returns the same code that the API does directly.
    [Tags]    API Explorer Production
    Set Test Variable    ${TestVer}    False
    API Caller

Api Explorer Test
    [Documentation]    Runs all querys on api explorer. Logs queries and type as it proceeds. Verifies the query only contains one query parameter. Verifies that the api returns the same code that the API does directly.
    [Tags]    API Explorer Test
    Set Test Variable    ${TestVer}    True
    API Caller

*** Keywords ***
API Caller
    Set Test Variable    ${Function}    Browser Init
    Set Test Variable    ${Process}    Api
    Set Test Variable    ${bCorrect}    False
    ${JenkinsSetupSize}=    Get Browser Setup Count
    run keyword if    ${JenkinsSetupSize} >1    Mobile Multi Setup Jenks
    ...    ELSE    Mobile Setup Jenks    Api
    Set Test Variable    ${bCorrect}    true
    run keyword if    ${JenkinsSetupSize} >1    Mobile Multi Setup Jenks
    ...    ELSE    Mobile Setup Jenks    Api

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

Manipulation
    Run keyword if    '${Process}'=='Portal'    Portal Manipulation
    Run keyword if    '${Process}'=='Api'    API Manipulation

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

API Manipulation
    Set Test Variable    ${Function}    Processing Api Explorer
    Run Keyword if    '${TestVer}'=='True'    Go To    ${APITestExplorerURL}
    ...    ELSE    Go To    ${APIProductionExplorerURL}
    Open Api Explorer Request type

Portal Manipulation
    Set Test Variable    ${Function}    Processing Portal Data Export
    Go to    ${PortalMapHome}
    ${StartMap}=    Get Time    epoch
    Wait for load    ${LoadingBarXpath}
    ${FinishMap}=    Get Time    epoch
    ${TimeToFinishMapLoad}=    evaluate    ${FinishMap}-${StartMap}
    Element should be visible    ${PlotsPulledXpath}
    ${NumPlotsPulled}=    Get Text    ${PlotsPulledXpath}
    ${TimePerPlot}=    Evaluate    ${TimeToFinishMapLoad}/${NumPlotsPulled}
    Input text    ${ExportEmailID}    all
    Click Element    ${ExportButtonID}
    ${IMG}=    Run Keyword And Return Status    Element Should be Visible    ${ExportLoadingIMGXpath}
    ${StartExp}=    Get Time    epoch
    Run Keyword if    ${IMG}    Wait For Load    ${ExportLoadingIMGXpath}
    ...    ELSE    Wait For Load    ${ExportLoadingBarXpath}
    ${FinishExp}=    Get Time    epoch
    ${TimeToFinishExport}=    evaluate    ${FinishExp}-${StartExp}
    Log Faster Map Export    ${TimeToFinishMapLoad}    ${TimeToFinishExport}
    Log    Test 0.3 Success
    Go To    ${PortalDataSheets}
    Click Element    ${PortalLIDataSheetXpath}
    Check Popup Occured
    Click Element    ${PortalLCDataSheetXpath}
    Check Popup Occured
    Click Element    ${PortalLIDataSheetImgXp}
    Check Popup Occured
    Click Element    ${PortalLCDataSheetImgXp}
    Check Popup Occured
    click and test links    ${LinksPortalXpath}

Check Popup Occured
    Close Pop Up Window
    select window

Wait for load
    [Arguments]    ${ELE}
    [Documentation]    Verifies page has loading based upon loading containers
    log    Waiting for page to load
    : FOR    ${I}    IN RANGE    1    ${WaitTimeout}+1
    \    ${TextThere}=    run keyword and return status    Element Should Be Visible    ${ELE}
    \    run keyword unless    ${TextThere}    Exit for Loop
    \    run keyword if    ${I}>=${WaitTimeout}    Set Test Variable    ${Function}    Timeout at ${I}
    \    BuiltIn.Sleep    1s

click and test links
    [Arguments]    ${LinksXPath}
    [Documentation]    Uses main page of webpage to navigate to and manipulate individual components
    ${PageTestUrl} =    Execute Javascript    return window.location.href;
    ${count}=    Get Matching Xpath Count    ${LinksXPath}
    @{Links}=    Get WebElements    xpath=${LinksXPath}
    : FOR    ${i}    IN RANGE    1    ${count} + 1
    \    ${link}=    Get WebElement    xpath=(${LinksXPath})[${i}]/a
    \    ${Atrib}=    get element atrrib    ${link}    href
    \    Set Test Variable    ${Function}    Verifying page at ${Atrib}
    \    log    Processing Page | ${Atrib}
    \    click element    ${link}
    \    select Window    url=${Atrib}
    \    ${url} =    Execute Javascript    return window.location.href;
    \    Run keyword unless    '${url}'=='${Atrib}'    log    Link for ${url} is broken
    \    Go To    ${PageTestUrl}

Open Api Explorer Request type
    [Documentation]    PlaceHolder
    ${count}=    Get Matching Xpath Count    ${APIExplorRequestTypeXPRsc}
    @{Links}=    Get WebElements    xpath=${APIExplorRequestTypeXPRsc}
    : FOR    ${i}    IN RANGE    1    ${count} + 1
    \    ${CurXpath}=    Set Variable    ${APIExplorRequestTypeXPRsc}[${i}]
    \    ${link}=    Get WebElement    xpath=(${APIExplorRequestTypeXPRsc})[${i}]${APIExplorRequestTypeXPRscBut}
    \    ${Atrib}=    get element atrrib    ${link}    text
    \    Set Test Variable    ${Function}    Verifying Request ${Atrib}
    \    log    Processing Request | ${Atrib}
    \    click element    ${link}
    \    Run Api Explorer Request Type    ${CurXpath}

Run Api Explorer Request Type
    [Arguments]    ${ResourceType}
    [Documentation]    PlaceHolder
    ${XpathCurRequest}=    Set Variable    ${ResourceType}${APIExplorOpenTypeXpStop}
    log    ${XpathCurRequest}
    ${count}=    Get Matching Xpath Count    ${XpathCurRequest}
    : FOR    ${i}    IN RANGE    1    ${count} + 1
    \    ${XpathToOpenCurRequest}    set variable    ${XpathCurRequest}[${i}]${APIExplorerOpenTypeStopBut}
    \    ${RequestTypeEle}=    Get WebElement    xpath=${XpathToOpenCurRequest}
    \    ${Atrib}=    get element atrrib    ${RequestTypeEle}    text
    \    click element    ${RequestTypeEle}
    \    Input Data Into API Request    ${XpathCurRequest}[${i}]

Input Data Into API Request
    [Arguments]    ${ResourceXpath}
    ${XpathCurInputs}=    Set Variable    ${ResourceXpath}//input
    ${countInputs}=    Get Matching Xpath Count    ${XpathCurInputs}
    @{InputEles}=    Get WebElements    xpath=${XpathCurInputs}
    : FOR    ${element}    IN    @{InputEles}
    \    ${Type}=    Get Element Atrrib    ${element}    type
    \    ${Name}=    Get Element Atrrib    ${element}    name
    \    Run Keyword If    '${Type}'=='text'    Input Random String With Random Length Into Input Element    ${element}
    \    Run Keyword If    '${Type}'=='button'    Submit Form And Read Request Results    ${element}    ${ResourceXpath}
    \    Run Keyword If    '${Name}' == '${XauthControlName}'    Input XAuth    ${element}

Input Random String With Random Length Into Input Element
    [Arguments]    ${element}
    Fill Input Api Explorer    ${element}    ${bCorrect}

Submit Form And Read Request Results
    [Arguments]    ${element}    ${XPathOfRequest}
    Click Element    ${element}
    Wait for Load    xpath=${XPathOfRequest}${ApiExplorerResponseThrobber}
    ${NoTimeout}=    run keyword and return status    Element Should Not Be Visible    xpath=${XPathOfRequest}${ApiExplorerResponseThrobber}
    Run Keyword if    ${NoTimeout}    read api response    ${XPathOfRequest}    ${bCorrect}

Input XAuth
    [Arguments]    ${Ele}
    fill xauth element    ${Ele}
