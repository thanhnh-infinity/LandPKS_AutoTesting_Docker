*** Settings ***
Library           AppiumLibrary
Library           Framework/appiumTesting.py

*** Variable ***
${REMOTE_URL1}    http://Barnebre:216526d7-706f-4eff-bf40-9d774203e268@ondemand.saucelabs.com:80/wd/hub
${PLATFORM}       Android
${platformVersion}    4.2
${APP}            http://128.123.177.36:8080/job/LandCover_Mobile_Andoird_App/ws/platforms/android/build/outputs/apk/android-debug.apk
${DEVICE_NAME}    AndroidEmulator
${XpathLandHome}    //div[@class='scroll']/div[@class='row']/div[@class='col col-100 ']/img
${REMOTE_URL}     http://localhost:4723/wd/hub

*** Test Cases ***
Adnroid Landinfo
    [Documentation]    Checks portal and makes sure export works properly and all links direct properly. Will error and log detailed message of what failed and on which page
    [Tags]    Landinfo    Online
    Set Browser    ${REMOTE_URL}    platformName=${PLATFORM}    platformVersion=${platformVersion}    deviceName=Android Emulator    app=${APP}    appWaitActivity=org.landpotential.lpks.landcover.MainActivity
    ...    appWaitpackage=org.landpotential.lpks.landcover
    Test Add Plot

Airplane
    Test Add Plot Airplane Verify It Appears In Landcover

*** Keywords ***
Open test browser jenkins
    [Arguments]    ${Capa}    ${Remote}
    Open browser    http://www.google.com    ${Browser}    \    remote_url=${Remote}    desired_capabilities=${Capa}

Manipulation
    Run keyword if    '${Process}'=='Portal'    Portal Manipulation
    Run keyword if    '${Process}'=='Api'    API Manipulation

Mobile Setup Jenks
    [Documentation]    Processes website when one browser is requested
    ${Caps}=    Get Jenkins Capabilities
    ${Creds}=    Get Sauce Creds Jenkins
    Open test browser jenkins    ${Caps}    ${Creds}
    Manipulation
    Run keyword if    '${REMOTE_URL}' != ''    Report Sauce status    ${SUITE_NAME} | ${TEST_NAME}    ${TEST_STATUS}    ${TEST_TAGS}    ${REMOTE_URL}
    Close all browsers

Close test browser Jenkins
    [Arguments]    ${URL}    ${Name}    ${Status}
    [Documentation]    Closes browsers and submits status to Saucelabs requires passing Remote url, Name of test, Status of test (PASS or FAIL)
    ${Mess}=    Set Variable if    '${Status}'=='Fail'    Failed on ${Function}    Pass
    Run keyword if    '${URL}' != ''    Report Sauce status    ${Mess} | ${Name}    ${Status}    Jenkins    ${URL}
    Close all browsers
