*** Settings ***
Library           Collections
Library           RequestsLibrary
Library           Selenium2Library
Library           BuiltIn
Library           String

*** Variables ***
${browser}        Firefox
${host}           http://testapi.landpotential.org:8080/query?
${version}        0.1

*** Test Cases ***
Delete API: Delete landinfo by plot id TestCase
    [Tags]    DeleteAPI
    Delete landinfo/landcover by plot id    delete    landinfo    delete_by_id    200

Delete API: Delete landcover by plot id TestCase
    [Tags]    DeleteAPI
    Delete landinfo/landcover by plot id    delete    landcover    delete_by_id    200

Delete API: Delete landinfo by name and recorder name TestCase
    [Tags]    DeleteAPI
    Delete landinfo/landcover by name and recorder name    delete    landcover    delete_by_name_recorder_name    200

Delete API: Delete landcover by name and recorder name TestCase
    [Tags]    DeleteAPI
    Delete landinfo/landcover by name and recorder name    delete    landinfo    delete_by_name_recorder_name    200

Get API: Get all records of landInfo TestCase
    [Tags]    DeleteAPI
    Get all records of LandInfo/landcover    get    landinfo    get_all    200

Get API: Get single/list records of LandInfo by LandInfo Plot ID TestCase
    [Tags]    GetAPI
    Get single/list records of LandInfo by LandInfo Plot ID    get    landinfo    get_by_id    200

Get API: Get single record of landInfo by Recoder_name and name TestCase
    [Tags]    GetAPI
    Get single record of landInfo/landcover by Recoder_name and name    get    landinfo    get_by_pair_name_recorder_name    200

Get API: Get single/list records of LandInfo by recorder_name TestCase
    [Tags]    GetAPI
    Get single/list records of LandInfo/landcover by recorder_name    get    landinfo    get_by_recorder_name    200

Get API: Get single/list records of LandInfo by region and recorder_name TestCase
    [Tags]    GetAPI
    Get single/list records of LandInfo by region and recorder_name    get    landinfo    get_by_region_recorder_name    200

Get API: Get SINGLE/list records of landinfo from afterDate to now TestCase
    [Tags]    GetAPI
    Get SINGLE/list records of landinfo/landcover from afterDate to now    get    landinfo    get_by_afterdate    200

Get API: Get SINGLE/list records of landinfo from time 0 to beforeDate TestCase
    [Tags]    GetAPI
    Get SINGLE/list records of landinfo/landcover from time 0 to beforeDate    get    landinfo    get_by_beforedate    200

Get API: Get single/list records of landinfo from afterDate to beforeDate TestCase
    [Tags]    GetAPI
    Get single/list records of landinfo/landcover from afterDate to beforeDate    get    landinfo    get_by_beforedate_afterdate    200

Get API: Get all records of landcover TestCase
    [Tags]    GetAPI
    Get all records of LandInfo/landcover    get    landcover    get_all    200

Get API: Get single record of landcover by Recoder_name and name TestCase
    [Tags]    GetAPI
    Get single record of landInfo/landcover by Recoder_name and name    get    landcover    get_by_name_recorder_name    200

Get API: Get single/list records of landcover by recorder_name TestCase
    [Tags]    GetAPI
    Get single/list records of LandInfo/landcover by recorder_name    get    landcover    get_by_recorder_name    200

Get API: Get SINGLE/list records of landcover from afterDate to now TestCase
    [Tags]    GetAPI
    Get SINGLE/list records of landinfo/landcover from afterDate to now    get    landcover    get_by_afterdate    200

Get API: Get SINGLE/list records of landcover from time 0 to beforeDate TestCase
    [Tags]    GetAPI
    Get SINGLE/list records of landinfo/landcover from time 0 to beforeDate    get    landcover    get_by_beforedate    200

Get API: Get single/list records of landcover from afterDate to beforeDate TestCase
    [Tags]    GetAPI
    Get single/list records of landinfo/landcover from afterDate to beforeDate    get    landcover    get_by_afterdate_beforedate    200

Get API: Get a collection of Climate TestCase
    [Tags]    GetAPI
    Get a collection of Climate    get    climate    get_local_climate    200

Landcover API: Put landcover TestCase
    [Tags]    LandCoverAPI
    Put landcover    put    landcover    200

Landcover API: Delete landcover by landcover ID TestCase
    [Tags]    LandCoverAPI
    Delete landinfo/landcover by plot id    delete    landcover    delete_by_id    200

Landcover API: Delete landcover by name and recorder name TestCase
    [Tags]    LandCoverAPI
    Delete landinfo/landcover by name and recorder name    delete    landcover    delete_by_name_recorder_name    200

Landcover API: Get landcover by all recorder_name TestCase
    [Tags]    LandCoverAPI
    Get all records of LandInfo/landcover    get    landcover    get_all    200

Landcover API: Get single/list records of landcover by name and recorder_name TestCase
    [Tags]    LandCoverAPI
    Get single/list records of LandInfo/landcover by recorder_name    get    landcover    get_by_name_recorder_name    200

Landcover API: Get SINGLE/list records of landcover by recorder_name TestCase
    [Tags]    LandCoverAPI
    Get single/list records of LandInfo/landcover by recorder_name    get    landcover    get_by_recorder_name    200

Landcover API: Get SINGLE/list records of landinfo/landcover from afterDate to now TestCase
    [Tags]    LandCoverAPI
    Get SINGLE/list records of landinfo/landcover from afterDate to now    get    landcover    get_by_afterdate    200

Landcover API: Get SINGLE/list records of landinfo/landcover from time 0 to beforeDate TestCase
    [Tags]    LandCoverAPI
    Get SINGLE/list records of landinfo/landcover from time 0 to beforeDate    get    landcover    get_by_beforedate    200

Landcover API: Get single/list records of landinfo/landcover from afterDate to beforeDate TestCase
    [Tags]    LandCoverAPI
    Get single/list records of landinfo/landcover from afterDate to beforeDate    get    landcover    get_by_afterdate_beforedate    200

Landinfo API: Update landinfo TestCase
    [Tags]    LandInfoAPI
    Put/Update Landinfo    update    landinfo    200

Landinfo API: Put landinfo TestCase
    [Tags]    LandInfoAPI
    Put/Update Landinfo    put    landinfo    200

Landinfo API: Delete landinfo by landinfo ID TestCase
    [Tags]    LandInfoAPI
    Delete landinfo/landcover by plot id    delete    landinfo    delete_by_id    200

Landinfo API: Delete object of LandInfo Plot by Recorder_name and name
    [Tags]    LandInfoAPI
    Delete landinfo/landcover by name and recorder name    delete    landinfo    delete_by_name_recorder_name    200

Landinfo API: Get landinfo by all recorder_name TestCase
    [Tags]    LandInfoAPI
    Get all records of LandInfo/landcover    get    landinfo    get_all    200

Landinfo API: GET single/list records of LandInfo by LandInfo Plot ID TestCase
    [Tags]    LandInfoAPI
    Get single/list records of LandInfo by LandInfo Plot ID    get    landinfo    get_by_id    200

Landinfo API: Get SINGLE/list records of LandInfo by recoder_name and name
    [Tags]    LandInfoAPI
    Get single record of landInfo/landcover by Recoder_name and name    get    landinfo    get_by_pair_name_recorder_name    200

Landinfo API: Get single/list records of LandInfo by recorder_name
    [Tags]    LandInfoAPI
    Get single/list records of LandInfo/landcover by recorder_name    get    landinfo    get_by_recorder_name    200

Landinfo API: Get single/list records of LandInfo by region and recorder_name
    [Tags]    LandInfoAPI
    Get single/list records of LandInfo by region and recorder_name    get    landinfo    get_by_region_recorder_name    200

Landinfo API: Get SINGLE/list records of landinfo from afterDate to now TestCase
    [Tags]    LandInfoAPI
    Get SINGLE/list records of landinfo/landcover from afterDate to now    get    landinfo    get_by_afterdate    200

Landinfo API: Get SINGLE/list records of landinfo from time 0 to beforeDate TestCase
    [Tags]    LandInfoAPI
    Get SINGLE/list records of landinfo/landcover from time 0 to beforeDate    get    landinfo    get_by_beforedate    200

Landinfo API: Get single/list records of landinfo from afterDate to beforeDate TestCase
    [Tags]    LandInfoAPI
    Get single/list records of landinfo/landcover from afterDate to beforeDate    get    landinfo    get_by_beforedate_afterdate    200

LocalClimate API: Get local climate
    [Tags]    LocalClimateAPI
    Get a collection of Climate    get    climate    get_local_climate    200

Login API: login
    [Tags]    LoginAPI
    login    200

Put API: Put landinfo
    [Tags]    PutAPI
    Put/Update Landinfo    put    landinfo    200

Put API: Put landcover
    [Tags]    PutAPI
    Put landcover    put    landcover    200

System API: Login LandPKS System
    [Tags]    SystemAPI
    login    200

Update API: Update landinfo
    [Tags]    UpdateAPI
    Put/Update Landinfo    put    landinfo    200

*** Keywords ***
Delete landinfo/landcover by plot id
    [Arguments]    ${action}    ${object}    ${type}    ${status_code}
    ${random} =    Evaluate    random.randint(0, sys.maxint)    modules=random, sys
    ${url}=    Catenate    SEPARATOR=    ${host}    version=    ${version}    &action=
    ...    ${action}    &object=    ${object}    &type=    ${type}    &id=
    ...    ${random}
    Create Session    Land    ${url}
    ${resp}=    Get Request    Land    /
    Should Be Equal As Strings    ${resp.status_code}    ${status_code}

Delete landinfo/landcover by name and recorder name
    [Arguments]    ${action}    ${object}    ${type}    ${status_code}
    ${recorder_name}    Generate Random String    12    [LOWER]
    ${name}    Generate Random String    12    [LOWER]
    ${url}=    Catenate    SEPARATOR=    ${host}    version=    ${version}    &action=
    ...    ${action}    &object=    ${object}    &type=    ${type}    &recorder_name=
    ...    ${recorder_name}    &name=    ${name}
    Create Session    Land    ${url}
    ${resp}=    Get Request    Land    /
    Should Be Equal As Strings    ${resp.status_code}    ${status_code}

Get all records of LandInfo/landcover
    [Arguments]    ${action}    ${object}    ${type}    ${status_code}
    ${recorder_name}    Set Variable    all
    ${url}=    Catenate    SEPARATOR=    ${host}    version=    ${version}    &action=
    ...    ${action}    &object=    ${object}    &type=    ${type}    &recorder_name=
    ...    ${recorder_name}
    Create Session    Land    ${url}
    ${resp}=    Get Request    Land    /
    Should Be Equal As Strings    ${resp.status_code}    ${status_code}
    Log    ${resp.status_code}

Get single/list records of LandInfo by LandInfo Plot ID
    [Arguments]    ${action}    ${object}    ${type}    ${status_code}
    ${object}    Set Variable    landinfo
    ${type}    Set Variable    get_by_id
    ${random} =    Evaluate    random.randint(0, sys.maxint)    modules=random, sys
    ${url}=    Catenate    SEPARATOR=    ${host}    version=    ${version}    &action=
    ...    ${action}    &object=    ${object}    &type=    ${type}    &id=
    ...    ${random}
    Create Session    Land    ${url}
    ${resp}=    Get Request    Land    /
    Should Be Equal As Strings    ${resp.status_code}    ${status_code}

Get single record of landInfo/landcover by recoder_name and name
    [Arguments]    ${action}    ${object}    ${type}    ${status_code}
    ${recorder_name}    Generate Random String    12    [LOWER]
    ${name}    Generate Random String    12    [LOWER]
    ${url}=    Catenate    SEPARATOR=    ${host}    version=    ${version}    &action=
    ...    ${action}    &object=    ${object}    &type=    ${type}    &name=
    ...    ${name}    &recorder_name=    ${recorder_name}
    Create Session    Land    ${url}
    ${resp}=    Get Request    Land    /
    Should Be Equal As Strings    ${resp.status_code}    ${status_code}

Get single/list records of LandInfo/landcover by recorder_name
    [Arguments]    ${action}    ${object}    ${type}    ${status_code}
    ${recorder_name}    Generate Random String    12    [LOWER]
    ${url}=    Catenate    SEPARATOR=    ${host}    version=    ${version}    &action=
    ...    ${action}    &object=    ${object}    &type=    ${type}    &recorder_name=
    ...    ${recorder_name}
    Create Session    Land    ${url}
    ${resp}=    Get Request    Land    /
    Should Be Equal As Strings    ${resp.status_code}    ${status_code}

Get single/list records of LandInfo by region and recorder_name
    [Arguments]    ${action}    ${object}    ${type}    ${status_code}
    ${recorder_name}    Generate Random String    12    [LOWER]
    ${minlat} =    Evaluate    random.randint(0, sys.maxint)    modules=random, sys
    ${minlong} =    Evaluate    random.randint(0, sys.maxint)    modules=random, sys
    ${maxlat} =    Evaluate    random.randint(0, sys.maxint)    modules=random, sys
    ${maxlong} =    Evaluate    random.randint(0, sys.maxint)    modules=random, sys
    ${url}=    Catenate    SEPARATOR=    ${host}    version=    ${version}    &action=
    ...    ${action}    &object=    ${object}    &type=    ${type}    &recorder_name=
    ...    ${recorder_name}    &minlat=    ${minlat}    &minlong=    ${minlong}    &maxlat=
    ...    ${maxlat}    &maxlong=    ${maxlong}
    Create Session    Land    ${url}
    ${resp}=    Get Request    Land    /
    Should Be Equal As Strings    ${resp.status_code}    ${status_code}

Get SINGLE/list records of landinfo/landcover from afterDate to now
    [Arguments]    ${action}    ${object}    ${type}    ${status_code}
    ${day} =    Evaluate    random.randint(1, 31)    modules=random, sys
    ${month} =    Evaluate    random.randint(1, 12)    modules=random, sys
    ${year} =    Evaluate    random.randint(2013, 2016)    modules=random, sys
    ${after_date} =    Catenate    SEPARATOR=-    ${year}    ${month}    ${day}
    ${url}=    Catenate    SEPARATOR=    ${host}    version=    ${version}    &action=
    ...    ${action}    &object=    ${object}    &type=    ${type}    &after_date=
    ...    ${after_date}
    Create Session    Land    ${url}
    ${resp}=    Get Request    Land    /
    Should Be Equal As Strings    ${resp.status_code}    ${status_code}

Get SINGLE/list records of landinfo/landcover from time 0 to beforeDate
    [Arguments]    ${action}    ${object}    ${type}    ${status_code}
    ${day} =    Evaluate    random.randint(1, 31)    modules=random, sys
    ${month} =    Evaluate    random.randint(1, 12)    modules=random, sys
    ${year} =    Evaluate    random.randint(2013, 2016)    modules=random, sys
    ${before_date} =    Catenate    SEPARATOR=-    ${year}    ${month}    ${day}
    ${url}=    Catenate    SEPARATOR=    ${host}    version=    ${version}    &action=
    ...    ${action}    &object=    ${object}    &type=    ${type}    &before_date=
    ...    ${before_date}
    Create Session    Land    ${url}
    ${resp}=    Get Request    Land    /
    Should Be Equal As Strings    ${resp.status_code}    ${status_code}

Get a collection of Climate
    [Arguments]    ${action}    ${object}    ${type}    ${status_code}
    ${latitude} =    Evaluate    random.randint(-200, 200)    modules=random, sys
    ${longitude} =    Evaluate    random.randint(-200, 200)    modules=random, sys
    ${url}=    Catenate    SEPARATOR=    ${host}    version=    ${version}    &action=
    ...    ${action}    &object=    ${object}    &type=    ${type}    &latitude=
    ...    ${latitude}    &=longitude=    ${longitude}
    Create Session    Land    ${url}
    ${resp}=    Get Request    Land    /
    Should Be Equal As Strings    ${resp.status_code}    ${status_code}

Get single/list records of landinfo/landcover from afterDate to beforeDate
    [Arguments]    ${action}    ${object}    ${type}    ${status_code}
    ${day} =    Evaluate    random.randint(1, 31)    modules=random, sys
    ${month} =    Evaluate    random.randint(1, 12)    modules=random, sys
    ${year} =    Evaluate    random.randint(2013, 2016)    modules=random, sys
    ${after_date} =    Catenate    SEPARATOR=-    ${year}    ${month}    ${day}
    ${day} =    Evaluate    random.randint(1, 31)    modules=random, sys
    ${month} =    Evaluate    random.randint(1, 12)    modules=random, sys
    ${year} =    Evaluate    random.randint(2013, 2016)    modules=random, sys
    ${before_date} =    Catenate    SEPARATOR=-    ${year}    ${month}    ${day}
    ${url}=    Catenate    SEPARATOR=    ${host}    version=    ${version}    &action=
    ...    ${action}    &object=    ${object}    &type=    ${type}    &after_date=
    ...    ${after_date}    &before_date=    ${before_date}
    Create Session    Land    ${url}
    ${resp}=    Get Request    Land    /
    Should Be Equal As Strings    ${resp.status_code}    ${status_code}

Put landcover
    [Arguments]    ${action}    ${object}    ${status_code}
    ${auth_key} =    Evaluate    random.randint(0, sys.maxint)    modules=random, sys
    ${recorder_name}    Generate Random String    12    [LOWER]
    ${name}    Generate Random String    12    [LOWER]
    ${transect}    Set Variable    west
    ${segment}=    Evaluate    random.randint(5, 25)    modules=random, sys
    ${canopy_gap}    Set Variable    true
    ${basal_gap}    Set Variable    true
    ${url}=    Catenate    SEPARATOR=    ${host}    version=    ${version}    &action=
    ...    ${action}    &object=    ${object}    &name=    ${name}    &recorder_name=
    ...    ${recorder_name}    &transect=    ${transect}    &segment=    ${segment}    &canopy_gap=
    ...    ${canopy_gap}    &basal_gap=    ${basal_gap}
    Create Session    Land    ${url}
    ${resp}=    Get Request    Land    /
    Should Be Equal As Strings    ${resp.status_code}    ${status_code}

Put/Update landinfo
    [Arguments]    ${action}    ${object}    ${status_code}
    ${recorder_name}    Generate Random String    12    [LOWER]
    ${name}    Generate Random String    12    [LOWER]
    ${test_plot}    Set Variable    true
    ${latitude}=    Evaluate    random.randint(-200, 200)    modules=random, sys
    ${longitude}=    Evaluate    random.randint(-200, 200)    modules=random, sys
    ${slope}=    Evaluate    random.randint(1, 100)    modules=random, sys
    ${slope_shape}=    Evaluate    random.randint(1, 100)    modules=random, sys
    ${surface_salt}    Set Variable    true
    ${surface_cracking}    Set Variable    true
    ${url}=    Catenate    SEPARATOR=    ${host}    version=    ${version}    &action=
    ...    ${action}    &object=    ${object}    &name=    ${name}    &recorder_name=
    ...    ${recorder_name}    &test_plot=    ${test_plot}    &latitude=    ${latitude}    &longitude=
    ...    ${longitude}    &slope=    ${slope}    &slope_shape=    ${slope_shape}    &surface_salt=
    ...    ${surface_salt}    &surface_cracking=    ${surface_cracking}
    Create Session    Land    ${url}
    ${resp}=    Get Request    Land    /
    Should Be Equal As Strings    ${resp.status_code}    ${status_code}

Login
    [Arguments]    ${status_code}
    ${email}    Generate Random String    12    [LOWER]
    ${password}    Generate Random String    12    [LOWER]
    ${loginURL}    Set Variable    http://api.landpotential.org/auth/api_login?
    ${url}=    Catenate    SEPARATOR=    ${loginURL}    email=    ${email}    &password=
    ...    ${password}
    Create Session    Land    ${url}
    ${resp}=    Get Request    Land    /
    Should Be Equal As Strings    ${resp.status_code}    ${status_code}
