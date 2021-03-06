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
${LandInfoIcon}    /html/body/ion-nav-view/ion-tabs/ion-nav-view/div/ion-view/ion-content/div/div/div[1]/div[2]/img
${AddNewLandInfo}    //span[@class='right-buttons']/a[@class='button button-icon ion-plus-round']
${AddLandInfoPlotButton}    /html/body/ion-nav-view/ion-tabs/ion-nav-view/div/ion-view/ion-content/div/a
${PlotNameIdLI}    name
${TestPlotYesRadioIdLI}    chkTestPlotYes
${OrgFieldIdLI}    organization
${LatFieldIdLI}    latitude
${LonFieldIdLI}    longitude
${BackButPlotCssLi}    body.grade-a.platform-browser.platform-win32.platform-ready ion-nav-bar.bar-stable.bar.bar-header.bar-balanced.nav-bar-container div.nav-bar-block ion-header-bar.bar-stable.bar.bar-header.bar-balanced.disable-user-behavior div.title.title-left.header-item span.nav-bar-title a.button.button-icon
${BackButPlotXpathLi}    //div[@nav-bar='active']/ion-header-bar/div[@class='title title-left header-item']/span[@class='nav-bar-title']/a[@class='button button-icon']
${LandInfoErrorMessage}    Answer to test plot is required.
${AlertPopUpCssLI}    body.grade-a.platform-browser.platform-win32.platform-ready.popup-open div.popup-container.remove-title-class.popup-showing.active div.popup div.popup-buttons button.button.ng-binding.button-positive
${ErrorMessageCssLI}    body.grade-a.platform-browser.platform-win32.platform-ready.popup-open div.popup-container.remove-title-class.popup-showing.active div.popup div.popup-body span
${AddPlotMenuPlotXpLI}    //ion-view[@cache-view='false']/ion-content/div[@class='scroll']/a[1]
${SubmitPlotButIdLI}    btnSubmitPlot_1
${SubmitPlotErrorButCssLI}    body.grade-a.platform-browser.platform-win32.platform-ready.popup-open div.popup-container.remove-title-class.popup-showing.active div.popup div.popup-buttons button.button.ng-binding.button-positive
${ReviewPlotXpLi}    //div[@class='scroll']/a[9]
${LandCoverXpLi}    /html/body/ion-nav-view/ion-tabs/ion-nav-view/div/ion-view/ion-content/div/a[2]
${LinksAddPlot}    //div[@class='scroll']/a[@class='item item-icon-right othercomponent']
${FloodTypesXpsLI}    //div[@class='scroll']/div/div[contains(@class,'col col-5')]/img
${FloodTypesXpsLI1}    /html/body/ion-nav-view/ion-tabs/ion-nav-view/div/ion-view/ion-content/div/div/div[contains(@class,'col col-5')]/img
${SoilLayersXpsLI}    //div[@class='scroll']/a
${LatitudeInputID}    latitude
${LongitudeInputID}    longitude
${PopupButtonXpath}    //div[@class='popup-buttons']/button[@class='button ng-binding button-positive']
${PopupBodyXpath}    //div
${LoadingContainerXpath}    //div[@class='loading-container']
${LoadingBody}    /div[@class='loading']/span
${TypeOfPhoto}    //p[@class='lpks-p']/b/b/a
${PhotoBack}      //div[@nav-bar='active']/ion-header-bar/button
${PopUpOkayButXpath}    //div[@class='popup-buttons']/button[@class='button ng-binding button-positive']
${LoadingContainerActive}    //div[@class='loading-container visible active']
${TitleOfPageXpathLi}    //div[@nav-bar='active']/ion-header-bar/div[@class='title title-left header-item']/span[@class='nav-bar-title']/a[@class='button button-icon']/p
${LandCoverIcon}    /html/body/ion-nav-view/ion-tabs/ion-nav-view/div/ion-view/ion-content/div/div/div[2]/div[2]/img

*** Test Cases ***
Land Cover
    [Documentation]    Runs the Landcover app and generates a new plot and its cover cover in a random fashion and checks for any bugs during the process. Checks for known bugs during this proccess. When it test encounters known bug test will log that it exists and works around. If bug is fixed logs this as well. On failing sets a message to record what failed and in which section. Tests all browsers set in environmental variable. Set on system or by jenkins
    [Tags]    LandCover
    ${Failed}=    set variable    False
    Set Selenium Timeout    15 seconds
    Set Selenium Speed    .3 seconds
    ${Creds}=    Get Sauce Creds Jenkins
    @{Browsers}=    Get Browsers
    : FOR    ${Browser}    IN    @{Browsers}
    \    ${caps}=    Set Jenkins Capabilities    ${Browser["browser"]}    ${Browser["platform"]}    ${Browser["version"]}
    \    Open test browser jenkins    ${caps}    ${Creds}
    \    ${Status}=    run keyword and return status    mobile manipulation    false    true
    \    ${PassOrFail}=    set variable if    ${Status}    PASS    Fail
    \    ${Failed}=    Set Variable If    ${Status}    ${Failed}    True
    \    Run Keyword unless    ${Status}    Set Test Message    Failed on ${Function}    append=yes
    \    Close Test Browser Jenkins    ${Creds}    ${Browser["platform"]} | ${Browser["browser"]} | ${Browser["version"]}    ${PassOrFail}
    run keyword if    '${Failed}'=='True'    BuiltIn.Fail

Photo Test
    [Documentation]    Runs standard framework but checks phots first and fails explicitly if phots fail as photo fail locks up browser. On failing sets a message to record what failed and in which section.
    [Tags]    PhotosUpload
    ${Failed}=    set variable    False
    Set Selenium Timeout    15 seconds
    Set Selenium Speed    .3 seconds
    ${Creds}=    Get Sauce Creds Jenkins
    @{Browsers}=    Get Browsers
    : FOR    ${Browser}    IN    @{Browsers}
    \    ${caps}=    Set Jenkins Capabilities    ${Browser["browser"]}    ${Browser["platform"]}    ${Browser["version"]}
    \    Open test browser jenkins    ${caps}    ${Creds}
    \    ${Status}=    run keyword and return status    mobile manipulation    true    false
    \    ${PassOrFail}=    set variable if    ${Status}    PASS    Fail
    \    ${Failed}=    Set Variable If    ${Status}    ${Failed}    True
    \    Close Test Browser Jenkins    ${Creds}    ${Browser["platform"]} | ${Browser["browser"]} | ${Browser["version"]}    ${PassOrFail}
    run keyword if    '${Failed}'=='True'    BuiltIn.Fail

Get Jenkins Driver
    [Documentation]    Runs landinfo app and randomly generates new plots. Randomly sets all fields when adding a plot. Checks for known bugs during the test. If test encounters a bug it will attempt the work around. If new bug is encountered logs what happened and current url Test also ensures the error handeling of the app accounts for any mistakes that are made. On failing sets a message to record what failed and in which section.
    [Tags]    LandInfo
    Set Selenium Timeout    15 seconds
    Set Selenium Speed    .3 seconds
    ${JenkinsSetupSize}=    Get Browser Setup Count
    run keyword if    ${JenkinsSetupSize} >1    Mobile Multi Setup Jenks
    ...    ELSE    Mobile Setup Jenks

Test Known Bugs Fast
    [Documentation]    Checks known bugs quicker by skipping what is not required.
    [Tags]    Known Bugs
    ${Creds}=    Get Sauce Creds Jenkins
    @{Browsers}=    Get Browsers
    : FOR    ${Browser}    IN    @{Browsers}
    \    ${caps}=    Set Jenkins Capabilities    ${Browser["browser"]}    ${Browser["platform"]}    ${Browser["version"]}
    \    Open test browser jenkins    ${caps}    ${Creds}
    \    Set Test Variable    ${LandCover}    false
    \    Set Test Variable    ${Function}    Browser Init
    \    go to    ${MobileApps}
    \    Wait Until Element Is Enabled    xpath=${XpathLandHome}
    \    Wait Until Element Is visible    xpath=${XpathLandHome}
    \    Click element    xpath=${XpathLandHome}
    \    Set Test Variable    ${Function}    Google Login
    \    Click element    id=${GoogleLoginBut}
    \    ${ele}=    Run Keyword And Return Status    Element Should Not Be Visible    id=account-chooser-add-account
    \    Run keyword if    ${ele}    Handle New Google Login
    \    ...    ELSE    Handle Exisiting Account
    \    Select Window
    \    Set Test Variable    ${Function}    Adding new plot
    \    Add New Land Info Plot
    \    ${Sucess}=    Go back and Make Sure No Error Displayed
    \    run keyword if    ${Sucess}    Try to Submit Land Plot
    \    Go back and Make Sure No Error Displayed
    \    proc soil layers
    \    Submit Land Plot
    \    Go back and Make Sure No Error Displayed
    \    Add Second Plot
    \    ${PassOrFail}    set variable if    ${Status}    PASS    Fail
    \    Close Test Browser Jenkins    ${Creds}    ${Browser["platform"]} | ${Browser["browser"]} | ${Browser["version"]}    ${PassOrFail}

*** Keywords ***
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
    ${urlFailed} =    Execute Javascript    return window.location.href;
    ${Mess}=    Set Variable if    '${Status}'=='Fail'    Failed on ${Function} at ${urlFailed}    Pass
    Run keyword if    '${URL}' != ''    Report Sauce status    ${Mess} | ${Name}    ${Status}    Jenkins    ${URL}
    Close all browsers

Mobile Setup
    Open test browser
    go to    ${MobileApps}
    Click element    xpath=${XpathLandHome}
    Click element    id=${GoogleLoginBut}

Mobile Multi Setup Jenks
    [Documentation]    Processes webpage execution when more than one browser is setup
    ${Creds}=    Get Sauce Creds Jenkins
    @{Browsers}=    Get Browsers
    : FOR    ${Browser}    IN    @{Browsers}
    \    ${caps}=    Set Jenkins Capabilities    ${Browser["browser"]}    ${Browser["platform"]}    ${Browser["version"]}
    \    Open test browser jenkins    ${caps}    ${Creds}
    \    ${Status}=    run keyword and return status    mobile manipulation    false    false
    \    ${PassOrFail}    set variable if    ${Status}    PASS    Fail
    \    Close Test Browser Jenkins    ${Creds}    ${Browser["platform"]} | ${Browser["browser"]} | ${Browser["version"]}    ${PassOrFail}

Mobile Setup Jenks
    [Documentation]    Processes website when one browser is requested
    ${Caps}=    Get Jenkins Capabilities
    ${Creds}=    Get Sauce Creds Jenkins
    Open test browser jenkins    ${Caps}    ${Creds}
    mobile manipulation    false    false

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
    Wait Until Element Is Enabled    id=${GoogleApproveAccess}
    click button    id=${GoogleApproveAccess}
    Select Window

mobile manipulation
    [Arguments]    ${PhotoTest}    ${LandCoverParam}
    [Documentation]    Processes most functions on the webpage requires parameter whether or not photos are to be tested (true or false)
    Set Test Variable    ${LandCover}    ${LandCoverParam}
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
    Set Test Variable    ${Function}    Adding new plot
    run keyword if    '${LandCover}'=='true'    Add New Land Cover Plot
    ...    ELSE    Add New Land Info Plot
    ${Sucess}=    Go back and Make Sure No Error Displayed
    run keyword if    ${Sucess}    Try to Submit Land Plot
    Go back and Make Sure No Error Displayed
    run keyword if    '${PhotoTest}'=='true'    Process Photos
    Create Plot Using Main Page To Navigate
    Submit Land Plot
    Run keyword unless    '${LandCover}'=='true'    Add Second Plot

Add Second Plot
    Set Test Variable    ${Function}    Adding Second Plot
    Add New Land Info Plot
    ${Sucess}=    Go back and Make Sure No Error Displayed
    run keyword if    ${Sucess}    Try to Submit Land Plot
    Go back and Make Sure No Error Displayed

Process Photos
    [Documentation]    Handles Processing the photo types
    Set Test Variable    ${Function}    Processing Photos
    ${PhotoPage}=    Get WebElement    xpath=(${LinksAddPlot})[contains(@href,'landinfo_photos')]
    click link    ${PhotoPage}
    @{PhotoTypes}=    Get Web Elements    xpath=${TypeOfPhoto}
    : FOR    ${PhotoType}    IN    @{PhotoTypes}
    \    log    ${PhotoType}
    \    Click Link    ${PhotoType}
    \    Proc Photo    xpath=//div[@id='aTagNorth']/a
    \    Proc Photo    xpath=//div[@id='aTagEast']/a
    \    Proc Photo    xpath=//div[@id='aTagSouth']/a
    \    Proc Photo    xpath=//div[@id='aTagWest']/a
    \    Click Element    xpath=${BackButPlotXpathLi}

Proc Photo
    [Arguments]    ${PhotoPath}
    [Documentation]    Processes individual photo passed from "Process Photos"
    Click Link    ${PhotoPath}
    ${PopUpVis}=    run keyword and return status    element should be visible    xpath=${PopUpOkayButXpath}
    run keyword if    ${PopUpVis}    Click Element    xpath=${PopUpOkayButXpath}
    Click button    id=snap
    ${BackButPres}=    Run Keyword And Return Status    Page Should Contain Element    xpath=${PhotoBack}
    click element if visable by locator    xpath=${PhotoBack}

Create Plot Using Main Page To Navigate
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
    \    Process Current Module
    \    Try to Submit Land Plot
    \    Go back and Make Sure No Error Displayed
    proc soil layers
    Go back and Make Sure No Error Displayed

proc soil layers
    [Documentation]    When soil layers has been reached from "Create Plot Using Main Page To Navigate" this function controls manipulating the layers
    Set Test Variable    ${Function}    Processing Soil Layers
    ${count}=    Get Matching Xpath Count    ${SoilLayersXpsLI}
    : FOR    ${i}    IN RANGE    1    ${count} + 1
    \    ${link}=    Get WebElement    xpath=(${SoilLayersXpsLI})[${i}]
    \    ${Vis}=    click element if visable    ${link}
    \    run keyword if    ${Vis}    proc soil layer

proc soil layer
    [Documentation]    Processes individual soil layer from "proc soil layer"
    Set Test Variable    ${Function}    Processing Individual Soil Layer
    click button    xpath=//div[@nav-view='active']/ion-view[@cache-view='false']/ion-scroll/div[@class='scroll']/div[2]/button
    wait until page contains element    id=radioBall
    @{Elements}=    Get Webelements    tag=input
    : FOR    ${element}    IN    @{Elements}
    \    ${text}=    Get Value    ${element}
    \    run keyword unless    '${text}' == 'NO'    click element if visable    ${element}
    \    Scroll To Element    ${element}
    ${Submit}=    get web element    xpath=//div[@id='btnSelect']/button
    click element if visable    ${Submit}
    ${layer}=    Get WebElement    xpath=//div[@class='lpks-select']/input
    Click element if visable    ${layer}
    ${randomIndex}    Generate Random String    1    1234
    click element    xpath=/html/body/div[4]/div/div[2]/div/ion-view/ion-content/div[1]/a[${randomIndex}]/img
    log    go back
    click element if visable by locator    xpath=${BackButPlotXpathLi}

Process Current Module
    [Documentation]    Processes a single module from main page
    @{FloodTypes}=    Get WebElements    xpath=${FloodTypesXpsLI}
    : FOR    ${FloodType}    IN    @{FloodTypes}
    \    ${Atrib}=    get element atrrib    ${FloodType}    class
    \    click element if visable    ${FloodType}
    Go back and Make Sure No Error Displayed

click element if visable
    [Arguments]    ${element}
    [Documentation]    Clicks an element after verifying it is visible must be passed (WebElement or entire path including the item looking for ie. id=elementID)
    ${Visible}    run keyword and return status    element should be visible    ${element}
    run keyword if    ${Visible}    click element    ${element}
    [Return]    ${Visible}

click element if visable by locator
    [Arguments]    ${locate}
    [Documentation]    Clicks an element after verifying it is visible only accepts a locator (Id=ElementID, Xpath=ElementCpath, etc)
    ${element}=    get webelement    ${locate}
    ${Visible}    run keyword and return status    element should be visible    ${element}
    run keyword if    ${Visible}    click element    ${element}
    [Return]    ${Visible}

Submit Land Plot
    [Documentation]    Submits plot requiring it to pass. Basic error handling contaned.
    Set Test Variable    ${Function}    Submitting Plot
    Click link    xpath=${ReviewPlotXpLi}
    Click element    id=${SubmitPlotButIdLI}
    ${success}=    Run keyword and return status    Element Should Contain    xpath=//div[@class='popup-body']/span[1]    Confirm submit. Submitted data may become publicly available.
    run keyword unless    ${success}    Check for Submit Error And Process Error
    ${result}=    Run keyword and return status    element should be visible    xpath=//div[@class='popup-buttons']/button[@class='button ng-binding button-positive']
    run keyword if    ${result}    click element    xpath=//div[@class='popup-buttons']/button[@class='button ng-binding button-positive']
    Wait for load
    ${success}=    Run keyword and return status    Element Should Contain    xpath=//div[@class='popup-body']/span[1]    Plot is submitted
    run keyword if    ${success}    element should be visible    xpath=//div[@class='popup-buttons']/button[@class='button ng-binding button-positive']
    run keyword if    ${success}    click element    xpath=//div[@class='popup-buttons']/button[@class='button ng-binding button-positive']
    run keyword unless    ${success}    Check for Submit Error And Process Error
    Run Keyword If    ${success} and '${LandCover}'=='false'    Go to Main Plot Page
    [Return]    ${success}

Check for Submit Error And Process Error
    [Documentation]    Processes an error encountered in "Submit Land Plot"
    Set Test Variable    ${Function}    Processing Errors
    ${PopupBody}=    set variable    //div[@class='popup-body']/span
    ${count}=    Get Matching Xpath Count    ${PopupBody}
    : FOR    ${i}    IN RANGE    1    ${count} + 1
    \    ${error}=    Get WebElement    xpath=(${PopupBody})[${i}]
    \    ${Text}=    get text    ${error}
    \    ${Lat}=    run keyword and return status    should contain    ${Text}    Latitude
    \    ${Long}=    run keyword and return status    should contain    ${Text}    Longitude
    \    run keyword if    ${Long}    Long error found
    \    run keyword if    ${Lat}    Long error found

Go to Main Plot Page
    [Documentation]    Returns to main page ciontaining plots regardless of distance from main page up to 10 pages uses webpage back to ensure page behaves
    : FOR    ${i}    IN RANGE    1    11
    \    ${Title}=    Get Text    xpath=${TitleOfPageXpathLi}
    \    run keyword if    '${Title}'=='LandInfo'    exit for loop
    \    Wait Until Element Is Visible    xpath=${BackButPlotXpathLi}
    \    click element    xpath=${BackButPlotXpathLi}

Long Error Found
    [Documentation]    Processes error found and drops to indivdual handling
    click element    xpath=//div[@class='popup-buttons']/button[@class='button ng-binding button-positive']
    Proc Lat and Long Error
    exit for loop
    Check for Submit Error And Process Error

Proc Lat and Long Error
    [Documentation]    Processes longitude and latitude handling
    click element    xpath=${BackButPlotXpathLi}
    Wait Until Element Is visible    xpath=//div[@nav-view='active']/ion-view/ion-content/div/a[1]
    click element    xpath=//div[@nav-view='active']/ion-view/ion-content/div/a[1]
    ${RandLat}=    Generate Random String    2    123456789
    input text    id=${LatitudeInputID}    ${RandLat}
    ${RandLong}=    Generate Random String    2    123456789
    input text    id=${LongitudeInputID}    ${RandLong}
    Go back and Make Sure No Error Displayed
    Click link    xpath=${ReviewPlotXpLi}
    Click element    id=${SubmitPlotButIdLI}

Try to Submit Land Plot
    [Documentation]    Tries to submit plot expecting and error and verifying one did occur
    ${VarBefore}=    Get Variable Value    ${Function}
    Set Test Variable    ${Function}    Trying to submit plot expecting error
    Click link    xpath=${ReviewPlotXpLi}
    Click element    id=${SubmitPlotButIdLI}
    ${result}=    Run keyword and return status    element should be visible    xpath=${PopupButtonXpath}
    element should contain    xpath=/html/body/div[4]/div/div[@class='popup-body']/span[1]    The following are required
    run keyword if    ${result}    click element    xpath=${PopupButtonXpath}
    Set Test Variable    ${Function}    ${VarBefore}
    [Return]    ${result}

Wait for load
    [Documentation]    Verifies page has loading based upon loading containers
    log    Waiting for page to load
    : FOR    ${I}    IN RANGE    1    10
    \    ${TextThere}=    run keyword and return status    Element Should Be Visible    xpath=${LoadingContainerXpath}
    \    ${Loading}=    Run keyword and return status    Element should Be visible    xpath=${LoadingContainerActive}
    \    run keyword unless    ${TextThere} or ${Loading}    Exit for Loop
    \    BuiltIn.Sleep    1s

Add New Land Info Plot
    [Documentation]    Creates a new plot using random information and tries to find location and handles errors and ensures page behaves as expected
    ${Title}=    Get Text    xpath=${TitleOfPageXpathLi}
    run keyword if    '${Title}'==' LandPKS Application Selection'    Wait Until Element Is visible    xpath=${LandInfoIcon}
    run keyword if    '${Title}'==' LandPKS Application Selection'    Click element    xpath=${LandInfoIcon}
    Wait for load
    Wait until element is enabled    xpath=//div[@class='list']
    Wait Until Element Is enabled    xpath=${AddNewLandInfo}
    ${Clicked}=    run keyword and return status    click element    xpath=${AddNewLandInfo}
    run keyword unless    ${Clicked}    click element    xpath=${AddNewLandInfo}
    add the plot

Add New Land Cover Plot
    [Documentation]    Creates a new plot using random information and tries to find location and handles errors and ensures page behaves as expected
    ${Title}=    Get Text    xpath=${TitleOfPageXpathLi}
    run keyword if    '${Title}'==' LandPKS Application Selection'    Wait Until Element Is visible    xpath=${LandCoverIcon}
    run keyword if    '${Title}'==' LandPKS Application Selection'    Click element    xpath=${LandCoverIcon}
    Wait for load
    Wait until element is enabled    xpath=//div[@class='list']
    Wait Until Element Is enabled    xpath=${AddNewLandInfo}
    ${Clicked}=    run keyword and return status    click element    xpath=${AddNewLandInfo}
    run keyword unless    ${Clicked}    click element    xpath=${AddNewLandInfo}
    Click Element    id=imgLandInfo
    add the plot

Add the Plot
    Wait Until Element Is visible    xpath=${AddPlotMenuPlotXpLI}
    click element    xpath=${AddPlotMenuPlotXpLI}
    Set Selenium Speed    .25 seconds
    Go back and Make Sure Error Is Displayed
    click element    id=${TestPlotYesRadioIdLI}
    ${RandLength}=    Generate Random String    1    123456789
    ${RandomString}=    Generate Random String    ${RandLength}
    Set Test Variable    ${PlotName}    ${RandomString}
    @{Elements}=    Get Webelements    tag=input
    : FOR    ${element}    IN    @{Elements}
    \    ${EleVis}=    run keyword and return status    element should be visible    ${element}
    \    run keyword unless    ${EleVis}    Continue For Loop
    \    ${text}=    Get Value    ${element}
    \    run keyword unless    '${text}' == 'small' or '${text}' =='medium'    input text    ${element}    ${RandomString}
    Element should not contain    id=${LongitudeInputID}    ${RandomString}
    click element    id=btnObtainGPS
    ${GPSError}=    Run keyword and return status    Element Should Contain    xpath=//div[@class='popup-body']/span[1]    Geolocation
    run keyword if    ${GPSError}    click element    xpath=//div[@class='popup-buttons']/button[@class='button ng-binding button-positive']

Go back and Make Sure No Error Displayed
    [Documentation]    Goes back a page and expects no error
    ${VarBefore}=    Get Variable Value    ${Function}
    Set Test Variable    ${Function}    Adding plot not successful
    log    Going back a page... Checking for success of last activity
    wait until page contains element    xpath=${BackButPlotXpathLi}
    Click link    xpath=${BackButPlotXpathLi}
    ${result}=    Run keyword and return status    page should not contain element    xpath=${PopupButtonXpath}
    Run Keyword if    '${result}'=='True'    Set Test Variable    ${Function}    ${VarBefore}
    Run Keyword if    '${result}'=='False'    Log    ERROR    Bug Still present that creates an additional dialog on IE
    Run Keyword if    '${result}'=='False'    Click Element    xpath=${PopupButtonXpath}
    [Return]    ${result}

Go back and Make Sure Error Is Displayed
    [Documentation]    Goes back a page expecting an error and dismisses them
    log    Going back a page... Checking for error of last activity
    wait until page contains element    xpath=${BackButPlotXpathLi}
    Click link    xpath=${BackButPlotXpathLi}
    page should contain element    xpath=${PopupButtonXpath}
    click element    xpath=${PopupButtonXpath}

Handle Exisiting Account
    [Documentation]    Handles existing google login account
    ${idForAccount}=    get correct account    GoogleEmail
    Page should contain element    id=${idForAccount}
