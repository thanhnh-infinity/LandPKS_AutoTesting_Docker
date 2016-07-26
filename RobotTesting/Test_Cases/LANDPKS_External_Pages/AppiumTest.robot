*** Settings ***
Library           AppiumLibrary
Library           Framework/appiumTesting.py
Library           ../../Framework/SauceLabs.py

*** Variable ***
${PLATFORM}       Android
${platformVersion}    5.1
${APP}            http://128.123.177.36:8080/job/LandCover_Mobile_Andoird_App/ws/platforms/android/build/outputs/apk/android-debug.apk
${DEVICE_NAME}    AndroidEmulator
${XpathLandHome}    //div[@class='scroll']/div[@class='row']/div[@class='col col-100 ']/img
${REMOTE_URL1}    http://localhost:4723/wd/hub
${appiumVersion}    1.4.16
${DeviceType}     Phone

*** Test Cases ***
Launch Android Landinfo app and create plot with data
    [Documentation]    Launches App pulled directly from jenkins and tests addition of a plot and verifies the correct messages are displayed and app doesnt freeze or timeout. Test passes if the plot is submitted, all elements functio and plot is viewable in landcover.
    [Tags]    Appium
    ${Creds}=    Get Sauce Creds Jenkins
    Set Browser    ${Creds}    platformName=${PLATFORM}    appiumVersion=${appiumVersion}    platformVersion=${platformVersion}    deviceName=Android Emulator    app=${APP}
    Test Add Plot

Launch android landinfo app in airplane mode and submit landcover
    [Documentation]    Launches App in airplane mode on device and tests addition of a plot and verifies the correct messages are displayed and app doesnt freeze or timeout. Uses plots submitted to fill in landinfo will all data and ensures all elements function as expected. Test is passed if all elements function, plot is submitted and landcover is submitted with plot.
    [Tags]    Appium
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
