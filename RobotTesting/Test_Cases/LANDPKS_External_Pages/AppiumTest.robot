*** Settings ***
Library           AppiumLibrary
Library           Selenium2Library
Library           Framework/Test_Case.py
Library           ../../Framework/SauceLabs.py

*** Variable ***
${PLATFORM}       Android
${platformVersion}    5.1
${LeechURL}       http://apkleecher.com/?id=org.landpotential.lpks.landcover
${APP}            http://128.123.177.36:8080/job/LandCover_Mobile_Andoird_App/ws/platforms/android/build/outputs/apk/android-debug.apk
${APPProduction}    http://www.apkleecher.com/apps/2016/10/06/LandPKS%202.0.2_[www.Apkleecher.com].apk
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

Web App Test Case pivotal_story_132082507.x Android 5.1
    [Documentation]    Pivotal Story 132082507. Content : Display Map at current location. PASS when (As a user I want to view the map so that I can it centered at my current location and I know I've succeeded when the map recenters when I move)
    [Tags]    Appium
    ${Creds}=    Get Sauce Creds Jenkins
    Set Browser    ${Creds}    platformName=${PLATFORM}    appiumVersion=${appiumVersion}    platformVersion=${platformVersion}    deviceName=Android Emulator    app=${APP}
    Test Case Pivotal Story 132082507

Web App Test Case pivotal_story_132278129.x Android 5.1
    [Documentation]    Pivotal Story 132278129. Content : Show current location on map. PASS when (As a user I wish to see my current location as a blue dot on the map and I know this is correct when I change location and the blue dot changes location with me. The dot should be the same size as the plot dots and the color should be blue instead of red)
    [Tags]    Appium
    ${Creds}=    Get Sauce Creds Jenkins
    Set Browser    ${Creds}    platformName=${PLATFORM}    appiumVersion=${appiumVersion}    platformVersion=${platformVersion}    deviceName=Android Emulator    app=${APP}
    Test Case Pivotal Story 132278129

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