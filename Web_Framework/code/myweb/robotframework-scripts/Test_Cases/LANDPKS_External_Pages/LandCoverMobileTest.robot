*** Settings ***
Library           Selenium2Library
Library           ../../Framework/SauceLabs.py
Library           String
Library           ../../Framework/Testing.py

*** Variables ***
@{_tmpFire}       name:Testing RobotFramework Selenium2Library,browserName:firefox, platform:Windows 8,version:14
@{_tmpIE}         name:Testing RobotFramework Selenium2Library,browserName:internet explorer, platform:Windows 8,version:10
${CAPABILITIES}    ${EMPTY.join(${_tmpIE})}
${LOGIN_FAIL_MSG}    Incorrect username or password.
${Browser}        firefox
${MobileApps}     http://testlpks.landpotential.org:8105/
${XpathLandHome}    //div[@class='scroll']/div[@class='row']/div[@class='col col-100 ']/img
${GoogleLoginBut}    loginGoogleWebBrowser
${GoogleSignIN}    Sign in - Google Accounts
${LandPKSSignIn}    LandPKS Sign-In
${GoogleEmailField}    Email
${GooglePassField}    Passwd
${GooglePassXpath}    //html/body/div/div[2]/div[2]/div[1]/form/div[2]/div/div[2]/div/div/input[2]
${GoogleSignINBut}    //html/body/div/div[2]/div[2]/div[1]/form/div[2]/div/input[1]
${GoogleApproveAccess}    submit_approve_access
${LandCoverIcon}    /html/body/ion-nav-view/ion-tabs/ion-nav-view/div/ion-view/ion-content/div/div/div[2]/div[2]/img
${TitleOfPageXpathLi}    //div[@nav-bar='active']/ion-header-bar/div[@class='title title-left header-item']/span[@class='nav-bar-title']/a[@class='button button-icon']/p
${AddNewLandInfo}    //span[@class='right-buttons']/a[@class='button button-icon ion-plus-round']
${BackButPlotXpathLi}    //div[@nav-bar='active']/ion-header-bar/div[@class='title title-left header-item']/span[@class='nav-bar-title']/a[@class='button button-icon']
${LoadingContainerActive}    //div[@class='loading-container visible active']
${LandCoverPlotIdXpath}    /html/body/ion-nav-view/ion-tabs/ion-nav-view/div[2]/ion-view/ion-content/div/div[3]/div[2]/img
${AddLandInfoPlotButton}    /html/body/ion-nav-view/ion-tabs/ion-nav-view/div/ion-view/ion-content/div/a
${PlotNameIdLI}    name
${TestPlotYesRadioIdLI}    chkTestPlotYes
${OrgFieldIdLI}    organization
${LatFieldIdLI}    latitude
${LonFieldIdLI}    longitude
${AddPlotMenuPlotXpLI}    //ion-view[@cache-view='false']/ion-content/div[@class='scroll']/a[1]

*** Test Cases ***
LandCover Test
    Get Jenkins Driver

*** Keywords ***
Get Jenkins Driver
    [Documentation]    Runs full blown test suite that tests entire lpks test and manipulates the entire webpage
    [Tags]    Jenkins
    Set Selenium Timeout    15 seconds
    Set Selenium Speed    .3 seconds
    ${JenkinsSetupSize}=    Get Browser Setup Count
    run keyword if    ${JenkinsSetupSize} >1    Mobile Multi Setup Jenks
    ...    ELSE    Mobile Setup Jenks

Open test browser
    Open browser    http://www.google.com    ${Browser}    \    remote_url=${REMOTE_URL}    desired_capabilities=${CAPABILITIES}

Open test browser jenkins
    [Arguments]    ${Capa}    ${Remote}
    Open browser    http://www.google.com    ${Browser}    \    remote_url=${Remote}    desired_capabilities=${Capa}

Open test browser2
    [Arguments]    ${Capa}
    Open browser    http://www.google.com    ${Browser}    \    remote_url=${REMOTE_URL}    desired_capabilities=${Capa}

Close test browser
    Run keyword if    '${REMOTE_URL}' != ''    Report Sauce status    ${SUITE_NAME} | ${TEST_NAME}    ${TEST_STATUS}    ${TEST_TAGS}    ${REMOTE_URL}
    Close all browsers

Close test browser Jenkins
    [Arguments]    ${URL}    ${Name}    ${Status}
    [Documentation]    Closes browsers and submits status to Saucelabs requires passing Remote url, Name of test, Status of test (PASS or FAIL)
    ${Mess}=    Set Variable if    '${Status}'=='Fail'    Failed on ${Function}    Pass
    Run keyword if    '${URL}' != ''    Report Sauce status    ${Mess} | ${Name}    ${Status}    Jenkins    ${URL}
    Close all browsers

Mobile Multi Setup Jenks
    [Documentation]    Processes webpage execution when more than one browser is setup
    ${Creds}=    Get Sauce Creds Jenkins
    @{Browsers}=    Get Browsers
    : FOR    ${Browser}    IN    @{Browsers}
    \    ${caps}=    Set Jenkins Capabilities    ${Browser["browser"]}    ${Browser["platform"]}    ${Browser["version"]}
    \    Open test browser jenkins    ${caps}    ${Creds}
    \    ${Status}=    run keyword and return status    mobile manipulation Landcover    false
    \    ${PassOrFail}    set variable if    ${Status}    PASS    Fail
    \    Close Test Browser Jenkins    ${Creds}    ${Browser["platform"]} | ${Browser["browser"]} | ${Browser["version"]}    ${PassOrFail}

Mobile Setup Jenks
    [Documentation]    Processes website when one browser is requested
    ${Caps}=    Get Jenkins Capabilities
    ${Creds}=    Get Sauce Creds Jenkins
    Open test browser jenkins    ${Caps}    ${Creds}
    mobile manipulation landcover    false

Handle New Google Login
    [Documentation]    Handles google when existing account is not detected
    Log    Detected Google account not stored adding new one
    @{GoogleCreds}=    Get Uname And Pword Lpks Gmail
    @{ex}=    List Windows
    ${CountWindows}=    Get Length    ${ex}
    run keyword if    ${CountWindows}>=2    Select window    popup
    wait until page contains element    id=${GoogleEmailField}
    input text    id=${GoogleEmailField}    @{GoogleCreds}[0]
    Click Element    id=next
    wait until page contains element    id=${GooglePassField}
    focus    id=${GooglePassField}
    input text    id=${GooglePassField}    @{GoogleCreds}[1]
    Page should contain element    xpath=${GoogleSignINBut}
    Wait Until Element Is Enabled    xpath=${GoogleSignINBut}
    Wait Until Element Is visible    xpath=${GoogleSignINBut}
    Click element    xpath=${GoogleSignINBut}
    click button    id=${GoogleApproveAccess}
    Select Window

mobile manipulation Landcover
    [Arguments]    ${PhotoTest}
    [Documentation]    Processes most functions on the webpage requires parameter whether or not photos are to be tested (true or false)
    Set Test Variable    ${Function}    Browser Init
    go to    ${MobileApps}
    Wait Until Element Is Enabled    xpath=${XpathLandHome}
    Wait Until Element Is visible    xpath=${XpathLandHome}
    Click element    xpath=${XpathLandHome}
    Set Test Variable    ${Function}    Google Login
    Click element    id=${GoogleLoginBut}
    ${ele}=    Run Keyword And Return Status    Element Should Not Be Visible    id=account-chooser-add-account
    Run keyword if    ${ele}    Handle New Google Login
    ...    ELSE    Handle Exisiting Account
    Select Window    ${LandPKSSignIn}
    ${Title}=    Get Text    xpath=${TitleOfPageXpathLi}
    run keyword if    '${Title}'==' LandPKS Application Selection'    Wait Until Element Is visible    xpath=${LandCoverIcon}
    run keyword if    '${Title}'==' LandPKS Application Selection'    Click element    xpath=${LandCoverIcon}
    Wait for load
    Wait Until Element Is enabled    xpath=${AddNewLandInfo}
    ${Clicked}=    run keyword and return status    click element    xpath=${AddNewLandInfo}
    Click Element    id=imgLandInfo
    Add Plot from Land Cover

Add Plot from Land Cover
    click element    xpath=${AddPlotMenuPlotXpLI}
    Set Selenium Speed    .35 seconds
    Check for land info error
    click element    id=${TestPlotYesRadioIdLI}
    ${RandLength}=    Generate Random String    1    123456789
    ${RandomString}=    Generate Random String    ${RandLength}
    Set Test Variable    ${PlotName}    ${RandomString}
    @{Elements}=    Get Webelements    tag=input
    : FOR    ${element}    IN    @{Elements}
    \    ${text}=    Get Value    ${element}
    \    run keyword unless    '${text}' == 'small' or '${text}' =='medium'    input text    ${element}    ${RandomString}
    Element should not contain    id=${LongitudeInputID}    ${RandomString}
    click element    id=btnObtainGPS
    ${GPSError}=    Run keyword and return status    Element Should Contain    xpath=//div[@class='popup-body']/span[1]    Geolocation
    run keyword if    ${GPSError}    click element    xpath=//div[@class='popup-buttons']/button[@class='button ng-binding button-positive']

Wait for load
    [Documentation]    Verifies page has loading based upon loading containers
    log    Waiting for page to load
    : FOR    ${I}    IN RANGE    1    10
    \    ${Loading}=    Run keyword and return status    Element should Be visible    xpath=${LoadingContainerActive}
    \    run keyword unless    ${Loading}    Exit for Loop
    \    BuiltIn.Sleep    1s

Go to Main Plot Page
    [Documentation]    Returns to main page ciontaining plots regardless of distance from main page up to 10 pages uses webpage back to ensure page behaves
    : FOR    ${i}    IN RANGE    1    11
    \    ${Title}=    Get Text    xpath=${TitleOfPageXpathLi}
    \    run keyword if    '${Title}'=='LandInfo'    exit for loop
    \    Wait Until Element Is Visible    xpath=${BackButPlotXpathLi}
    \    click element    xpath=${BackButPlotXpathLi}

Check for land info sucess
    [Documentation]    Goes back a page and expects no error
    log    Going back a page... Checking for success of last activity
    wait until page contains element    xpath=${BackButPlotXpathLi}
    Click link    xpath=${BackButPlotXpathLi}
    ${result}=    Run keyword and return status    page should not contain element    xpath=${PopupButtonXpath}
    [Return]    ${result}

Check for land info error
    [Documentation]    Goes back a page expecting an error and dismisses them
    log    Going back a page... Checking for error of last activity
    wait until page contains element    xpath=${BackButPlotXpathLi}
    Click link    xpath=${BackButPlotXpathLi}
    page should contain element    xpath=${PopupButtonXpath}
    click element    xpath=${PopupButtonXpath}
