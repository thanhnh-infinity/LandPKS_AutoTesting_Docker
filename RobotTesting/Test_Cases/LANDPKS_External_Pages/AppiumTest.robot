*** Settings ***
Library           AppiumLibrary
Library           Selenium2Library
Library           Framework/Test_Case.py
Library           ../../Framework/SauceLabs.py

*** Variable ***
${PLATFORM}       Android
${platformVersion}    5.1
${APP}            http://128.123.177.36:8080/job/LandCover_Mobile_Andoird_App/ws/platforms/android/build/outputs/apk/android-debug.apk
${DEVICE_NAME}    AndroidEmulator
${appiumVersion}    1.4.16
${DeviceType}     Phone

*** Test Cases ***
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
