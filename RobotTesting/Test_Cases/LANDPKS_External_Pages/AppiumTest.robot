*** Settings ***
Library           AppiumLibrary
Library           Selenium2Library
Library           Framework/Test_Case.py
Library           ../../Framework/SauceLabs.py

*** Variable ***
${PLATFORM}       Android
${platformVersion}    5.1
${LeechURL}       http://apkleecher.com/?id=org.landpotential.lpks.landcover
${APP}            http://128.123.177.36:8080/job/LandCover_Mobile_Andoird_App/ws/platforms/android/bin/MainActivity-debug.apk
${APPProduction}    http://apkleecher.com/apps/2016/11/04/LandPKS%202.0.10_%5bwww.Apkleecher.com%5d.apk
${DEVICE_NAME}    AndroidEmulator
${appiumVersion}    1.5.2
${DeviceType}     Phone

*** Test Cases ***
Android Test Case 3.1.x Android 5.1
    [Documentation]    Launches App pulled directly from jenkins and tests addition of a plot and Runs tests in category 0 of manual test plan on app tests this includes airplane testing. Library and test structure is in library Test case.py. Return what tests failed and were successful. Test Fails if Critical test is a failure.
    [Tags]    Appium
    ${Creds}=    Get Sauce Creds Jenkins
    Set Browser    ${Creds}    platformName=${PLATFORM}    appiumVersion=${appiumVersion}    platformVersion=${platformVersion}    deviceName=Android Emulator    app=${APP}
    Verify Portal And App Data Match

Android Test Case 2.3.x Android 5.1
    [Documentation]    Launches App pulled directly from jenkins and Runs tests in category 2.3 of manual test plan. Library and test structure is in library Test_case.py. Return what tests failed and were successful. Test Fails if Critical test is a failure.
    [Tags]    Appium
    ${Creds}=    Get Sauce Creds Jenkins
    Set Browser    ${Creds}    platformName=${PLATFORM}    appiumVersion=${appiumVersion}    platformVersion=${platformVersion}    deviceName=Android Emulator    app=${APP}
    Test Case 2 3

Andoid Test Case 2.1.x Android 5.1
    [Documentation]    Launches App pulled directly from jenkins and tests addition of a plot and Runs tests in category 2.1 of manual test plan. Library and test structure is in library Test case.py. Return what tests failed and were successful. Test Fails if Critical test is a failure.
    [Tags]    Appium
    ${Creds}=    Get Sauce Creds Jenkins
    Set Browser    ${Creds}    platformName=${PLATFORM}    appiumVersion=${appiumVersion}    platformVersion=${platformVersion}    deviceName=Android Emulator    app=${APP}
    Test Case 2

Andoid Test Case 2.4.x Android 5.1
    [Documentation]    Launches App pulled directly from jenkins and tests addition of a plot and Runs tests in category 2.4 of manual test plan. Library and test structure is in library Test case.py. Return what tests failed and were successful. Test Fails if Critical test is a failure.
    [Tags]    Appium
    ${Creds}=    Get Sauce Creds Jenkins
    Set Browser    ${Creds}    platformName=${PLATFORM}    appiumVersion=${appiumVersion}    platformVersion=${platformVersion}    deviceName=Android Emulator    app=${APP}
    Test Case 2 4

Android Test Case 0.x Android 5.1
    [Documentation]    Launches App pulled directly from jenkins and tests addition of a plot and Runs tests in category 0 of manual test plan on app tests this includes airplane testing. Library and test structure is in library Test case.py. Return what tests failed and were successful. Test Fails if Critical test is a failure.
    [Tags]    Appium
    ${Creds}=    Get Sauce Creds Jenkins
    Set Browser    ${Creds}    platformName=${PLATFORM}    appiumVersion=${appiumVersion}    platformVersion=${platformVersion}    deviceName=Android Emulator    app=${APP}
    Test Case 0

All LandInfo's Map Features 2.7.x Android 5.1
    [Documentation]    All LandInfo Map Features: 2.7.1 : Display plots on Map; 2.7.2: Detailed Information of plot on map; 2.7.3: Display map at current location; 2.7.4: Show current location on map; 2.7.5: Put zoom control in the upper left corner
    [Tags]    Appium
    ${Creds}=    Get Sauce Creds Jenkins
    Set Browser    ${Creds}    platformName=${PLATFORM}    appiumVersion=${appiumVersion}    platformVersion=${platformVersion}    deviceName=Android Emulator    app=${APP}
    Test Case 2 7

Metric Units Features 10.10.x Linux Chrome
    [Documentation]    Metrics Unit Features:
    [Tags]    Appium
    ${Creds}=    Get Sauce Creds Jenkins
    Set Browser    ${Creds}    platformName=${PLATFORM}    appiumVersion=${appiumVersion}    platformVersion=${platformVersion}    deviceName=Android Emulator    app=${APP}
    Test Case 10 10 Metric
    
English Units Features 10.10.x Linux Chrome
    [Documentation]    English Unit Features:
    [Tags]    Appium
    ${Creds}=    Get Sauce Creds Jenkins
    Set Browser    ${Creds}    platformName=${PLATFORM}    appiumVersion=${appiumVersion}    platformVersion=${platformVersion}    deviceName=Android Emulator    app=${APP}
    Test Case 10 10 English

LandCover Add Notes for Transects Features 2.5.x Linux Chrome
    [Documentation]    Testing script for LandCover Transects Notes feature
    [Tags]    Appium
    ${Creds}=    Get Sauce Creds Jenkins
    Set Browser    ${Creds}    platformName=${PLATFORM}    appiumVersion=${appiumVersion}    platformVersion=${platformVersion}    deviceName=Android Emulator    app=${APP}
    Test Case 2 5

Android Test Case 3.1.x Android 5.1
    [Documentation]    Launches App pulled directly from jenkins and tests addition of a plot and Runs tests in category 0 of manual test plan on app tests this includes airplane testing. Library and test structure is in library Test case.py. Return what tests failed and were successful. Test Fails if Critical test is a failure.
    [Tags]    Appium Production
    ${Creds}=    Get Sauce Creds Jenkins
    Set Browser    ${Creds}    platformName=${PLATFORM}    appiumVersion=${appiumVersion}    platformVersion=${platformVersion}    deviceName=Android Emulator    app=${APPProduction}
    Verify Portal And App Data Match    bProduction=True

Android Test Case 2.3.x Android 5.1
    [Documentation]    Launches App pulled directly from jenkins and Runs tests in category 2.3 of manual test plan. Library and test structure is in library Test_case.py. Return what tests failed and were successful. Test Fails if Critical test is a failure.
    [Tags]    Appium Production
    ${Creds}=    Get Sauce Creds Jenkins
    Set Browser    ${Creds}    platformName=${PLATFORM}    appiumVersion=${appiumVersion}    platformVersion=${platformVersion}    deviceName=Android Emulator    app=${APPProduction}
    Test Case 2 3

Andoid Test Case 2.1.x Android 5.1
    [Documentation]    Launches App pulled directly from jenkins and tests addition of a plot and Runs tests in category 2.1 of manual test plan. Library and test structure is in library Test case.py. Return what tests failed and were successful. Test Fails if Critical test is a failure.
    [Tags]    Appium Production
    ${Creds}=    Get Sauce Creds Jenkins
    Set Browser    ${Creds}    platformName=${PLATFORM}    appiumVersion=${appiumVersion}    platformVersion=${platformVersion}    deviceName=Android Emulator    app=${APPProduction}
    Test Case 2

Andoid Test Case 2.4.x Android 5.1
    [Documentation]    Launches App pulled directly from jenkins and tests addition of a plot and Runs tests in category 2.4 of manual test plan. Library and test structure is in library Test case.py. Return what tests failed and were successful. Test Fails if Critical test is a failure.
    [Tags]    Appium Production
    ${Creds}=    Get Sauce Creds Jenkins
    Set Browser    ${Creds}    platformName=${PLATFORM}    appiumVersion=${appiumVersion}    platformVersion=${platformVersion}    deviceName=Android Emulator    app=${APPProduction}
    Test Case 2 4

Android Test Case 0.x Android 5.1
    [Documentation]    Launches App pulled directly from jenkins and tests addition of a plot and Runs tests in category 0 of manual test plan on app tests this includes airplane testing. Library and test structure is in library Test case.py. Return what tests failed and were successful. Test Fails if Critical test is a failure.
    [Tags]    Appium Production
    ${Creds}=    Get Sauce Creds Jenkins
    Set Browser    ${Creds}    platformName=${PLATFORM}    appiumVersion=${appiumVersion}    platformVersion=${platformVersion}    deviceName=Android Emulator    app=${APPProduction}
    Test Case 0
