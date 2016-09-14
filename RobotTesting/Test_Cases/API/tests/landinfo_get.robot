*** Settings ***
Suite Teardown    Delete All Sessions
Library           Selenium2Library
Library           RequestsLibrary
Library           Collections
Library           String
Library           OperatingSystem
Library           HttpLibrary.HTTP
Library           DateTime
Library           OperatingSystem
Resource          Globals.robot

*** Variables ***
${API_URL}     ${API_BASE_URL}&action=get&object=landinfo
${DISPLAY_SET}     0
${DELIMITER}        %27
${RECORDER_NAME}    lpks.test@gmail.com
${RECORDER_NAME2}    dwkimiti@gmail.com
${PlOT_NAME2}    dwkimiti@gmail.com-BOT1
${MIN_LATITUDE}    -20
${MAX_LATITUDE}    50
${MIN_LONGITUDE}    -20
${MAX_LONGITUDE}    50
${COUNT}    100
${ID}       1098,1099
${AFTERDATE}    2010-01-01
${BEFOREDATE}    2050-01-01

*** Test Cases ***
Landinfo Get All Default
    [Documentation]    Get all landinfo data and validate response
    [Tags]      Get     Landinfo        get_all
    ${get_all_url}=     replace variables        ${API_URL}&type=get_all&recorder_name=all&count=${COUNT}&display=${DISPLAY_SET}&delimiter=${DELIMITER}&x
    create session      landinfo_getall     ${get_all_url}
    ${result}=  Get Request     landinfo_getall     /get
    should be valid json     ${result.content}
    ${next_cursor}=      run keyword if      ${result.status_code}== 200       validate success cursor type    ${result.content}
    :FOR    ${i}    IN RANGE    9999999
    \       Exit For Loop If    ${next_cursor} is None
    \       Exit For Loop If    ${next_cursor}==0
    \       ${next_cursor}=    call api with cursor        ${get_all_url}       ${next_cursor}
    run keyword unless      ${result.status_code}== 200       validate error model    ${result.content}

Landinfo Get All Archived
    [Documentation]    Get all landinfo data and validate response
    [Tags]      Get     Landinfo        get_all
    ${get_all_url}=     replace variables        ${API_URL}&type=get_all&recorder_name=all&count=${COUNT}&display=${DISPLAY_SET}&delimiter=${DELIMITER}&records_type=1&x
    create session      landinfo_getall     ${get_all_url}
    ${result}=  Get Request     landinfo_getall     /get
    should be valid json     ${result.content}
    ${next_cursor}=      run keyword if      ${result.status_code}== 200       validate success cursor type    ${result.content}
    :FOR    ${i}    IN RANGE    9999999
    \       Exit For Loop If    ${next_cursor} is None
    \       Exit For Loop If    ${next_cursor}==0
    \       ${next_cursor}=    call api with cursor        ${get_all_url}       ${next_cursor}
    run keyword unless      ${result.status_code}== 200       validate error model    ${result.content}

Landinfo Get All Both
    [Documentation]    Get all landinfo data and validate response
    [Tags]      Get     Landinfo        get_all
    ${get_all_url}=     replace variables        ${API_URL}&type=get_all&recorder_name=all&count=${COUNT}&display=${DISPLAY_SET}&delimiter=${DELIMITER}&records_type=2&x
    create session      landinfo_getall     ${get_all_url}
    ${result}=  Get Request     landinfo_getall     /get
    should be valid json     ${result.content}
    ${next_cursor}=      run keyword if      ${result.status_code}== 200       validate success cursor type    ${result.content}
    :FOR    ${i}    IN RANGE    9999999
    \       Exit For Loop If    ${next_cursor} is None
    \       Exit For Loop If    ${next_cursor}==0
    \       ${next_cursor}=    call api with cursor        ${get_all_url}       ${next_cursor}
    run keyword unless      ${result.status_code}== 200       validate error model    ${result.content}

Landinfo Get By ID Default
    [Documentation]    Get landinfo data by ID and validate response
    [Tags]      Get     Landinfo        get_by_id
    ${get_url}=     replace variables        ${API_URL}&type=get_by_id&id=${ID}&display=${DISPLAY_SET}&delimiter=${DELIMITER}&x
    create session      landinfo_getbyid     ${get_url}
    ${result}=  Get Request     landinfo_getbyid     /get
    should be valid json     ${result.content}
    run keyword if      ${result.status_code}== 200       validate success non cursor type    ${result.content}
    run keyword unless      ${result.status_code}== 200       validate error model    ${result.content}

Landinfo Get By ID Archived
    [Documentation]    Get landinfo data by ID and validate response
    [Tags]      Get     Landinfo        get_by_id
    ${get_url}=     replace variables        ${API_URL}&type=get_by_id&id=${ID}&display=${DISPLAY_SET}&records_type=1&delimiter=${DELIMITER}&x
    create session      landinfo_getbyid     ${get_url}
    ${result}=  Get Request     landinfo_getbyid     /get
    should be valid json     ${result.content}
    run keyword if      ${result.status_code}== 200       validate success non cursor type    ${result.content}
    run keyword unless      ${result.status_code}== 200       validate error model    ${result.content}

Landinfo Get By ID Both
    [Documentation]    Get landinfo data by ID and validate response
    [Tags]      Get     Landinfo        get_by_id
    ${get_url}=     replace variables        ${API_URL}&type=get_by_id&id=${ID}&display=${DISPLAY_SET}&records_type=2&delimiter=${DELIMITER}&x
    create session      landinfo_getbyid     ${get_url}
    ${result}=  Get Request     landinfo_getbyid     /get
    should be valid json     ${result.content}
    run keyword if      ${result.status_code}== 200       validate success non cursor type    ${result.content}
    run keyword unless      ${result.status_code}== 200       validate error model    ${result.content}

Landinfo Get By Name Recorder Name Default
    [Documentation]    Get landinfo data by name and recorder_name and validate response
    [Tags]      Get     Landinfo        get_by_pair_name_recorder_name
    ${get_url}=     replace variables        ${API_URL}&type=get_by_pair_name_recorder_name&name=${PlOT_NAME2}&recorder_name=${RECORDER_NAME2}&display=${DISPLAY_SET}&delimiter=${DELIMITER}&records_type=0&x
    create session      landinfo_getbynamerecordername     ${get_url}
    ${result}=  Get Request     landinfo_getbynamerecordername     /get
    should be valid json     ${result.content}
    run keyword if      ${result.status_code}== 200       validate success non cursor type    ${result.content}
    run keyword unless      ${result.status_code}== 200       validate error model    ${result.content}

    ${get_url}=     replace variables        ${API_URL}&type=get_by_pair_name_recorder_name&name=${PlOT_NAME2}&recorder_name=${RECORDER_NAME2}&records_type=0&x
    create session      landinfo_getbynamerecordername     ${get_url}
    ${result}=  Get Request     landinfo_getbynamerecordername     /get
    should be valid json     ${result.content}
    run keyword if      ${result.status_code}== 200       validate content name recorder name    ${result.content}

Landinfo Get By Name Recorder Name Archived
    [Documentation]    Get landinfo data by name and recorder_name and validate response
    [Tags]      Get     Landinfo        get_by_pair_name_recorder_name
    ${get_url}=     replace variables        ${API_URL}&type=get_by_pair_name_recorder_name&name=${PlOT_NAME2}&recorder_name=${RECORDER_NAME2}&display=${DISPLAY_SET}&delimiter=${DELIMITER}&records_type=1&x
    create session      landinfo_getbynamerecordername     ${get_url}
    ${result}=  Get Request     landinfo_getbynamerecordername     /get
    should be valid json     ${result.content}
    run keyword if      ${result.status_code}== 200       validate success non cursor type    ${result.content}
    run keyword unless      ${result.status_code}== 200       validate error model    ${result.content}

Landinfo Get By Name Recorder Name Both
    [Documentation]    Get landinfo data by name and recorder_name and validate response
    [Tags]      Get     Landinfo        get_by_pair_name_recorder_name
    ${get_url}=     replace variables        ${API_URL}&type=get_by_pair_name_recorder_name&name=${PlOT_NAME2}&recorder_name=${RECORDER_NAME2}&display=${DISPLAY_SET}&delimiter=${DELIMITER}&records_type=2&x
    create session      landinfo_getbynamerecordername     ${get_url}
    ${result}=  Get Request     landinfo_getbynamerecordername     /get
    should be valid json     ${result.content}
    run keyword if      ${result.status_code}== 200       validate success non cursor type    ${result.content}
    run keyword unless      ${result.status_code}== 200       validate error model    ${result.content}

Landinfo Get By Recorder Name Default
    [Documentation]    Get landinfo data by recorder_name and validate response
    [Tags]      Get     Landinfo        get_recorder_name
    ${get_recorder_name_url}=     replace variables        ${API_URL}&type=get_by_recorder_name&recorder_name=${RECORDER_NAME}&count=${COUNT}&display=${DISPLAY_SET}&delimiter=${DELIMITER}&x
    create session      landinfo_getrecorder_name     ${get_recorder_name_url}
    ${result}=  Get Request     landinfo_getrecorder_name     /get
    should be valid json     ${result.content}
    ${next_cursor}=      run keyword if      ${result.status_code}== 200       validate success cursor type    ${result.content}
    :FOR    ${i}    IN RANGE    9999999
    \       Exit For Loop If    ${next_cursor} is None
    \       Exit For Loop If    ${next_cursor}==0
    \       ${next_cursor}=    call api with cursor        ${get_recorder_name_url}       ${next_cursor}
    run keyword unless      ${result.status_code}== 200       validate error model    ${result.content}

Landinfo Get By Recorder Name Archived
    [Documentation]    Get landinfo data by recorder_name and validate response
    [Tags]      Get     Landinfo        get_recorder_name
    ${get_recorder_name_url}=     replace variables        ${API_URL}&type=get_by_recorder_name&recorder_name=${RECORDER_NAME}&count=${COUNT}&display=${DISPLAY_SET}&records_type=1&delimiter=${DELIMITER}&x
    create session      landinfo_getrecorder_name     ${get_recorder_name_url}
    ${result}=  Get Request     landinfo_getrecorder_name     /get
    should be valid json     ${result.content}
    ${next_cursor}=      run keyword if      ${result.status_code}== 200       validate success cursor type    ${result.content}
    :FOR    ${i}    IN RANGE    9999999
    \       Exit For Loop If    ${next_cursor} is None
    \       Exit For Loop If    ${next_cursor}==0
    \       ${next_cursor}=    call api with cursor        ${get_recorder_name_url}       ${next_cursor}
    run keyword unless      ${result.status_code}== 200       validate error model    ${result.content}

Landinfo Get By Recorder Name Both
    [Documentation]    Get landinfo data by recorder_name and validate response
    [Tags]      Get     Landinfo        get_recorder_name
    ${get_recorder_name_url}=     replace variables        ${API_URL}&type=get_by_recorder_name&recorder_name=${RECORDER_NAME}&count=${COUNT}&display=${DISPLAY_SET}&records_type=2&delimiter=${DELIMITER}&x
    create session      landinfo_getrecorder_name     ${get_recorder_name_url}
    ${result}=  Get Request     landinfo_getrecorder_name     /get
    should be valid json     ${result.content}
    ${next_cursor}=      run keyword if      ${result.status_code}== 200       validate success cursor type    ${result.content}
    :FOR    ${i}    IN RANGE    9999999
    \       Exit For Loop If    ${next_cursor} is None
    \       Exit For Loop If    ${next_cursor}==0
    \       ${next_cursor}=    call api with cursor        ${get_recorder_name_url}       ${next_cursor}
    run keyword unless      ${result.status_code}== 200       validate error model    ${result.content}

Landinfo Get By Region Default
    [Documentation]    Get landinfo data by region and validate response
    [Tags]      Get     Landinfo        get_by_region
    ${get_url}=     replace variables        ${API_URL}&type=get_by_region&minlat=${MIN_LATITUDE}&minlong=${MIN_LONGITUDE}&maxlat=${MAX_LATITUDE}&maxlong=${MAX_LONGITUDE}&count=${COUNT}&display=${DISPLAY_SET}&delimiter=${DELIMITER}&x
    create session      get_by_region     ${get_url}
    ${result}=  Get Request     get_by_region     /get
    should be valid json     ${result.content}
    ${next_cursor}=      run keyword if      ${result.status_code}== 200       validate success cursor type    ${result.content}
    :FOR    ${i}    IN RANGE    9999999
    \       Exit For Loop If    ${next_cursor} is None
    \       Exit For Loop If    ${next_cursor}==0
    \       ${next_cursor}=    call api with cursor        ${get_url}       ${next_cursor}
    run keyword unless      ${result.status_code}== 200       validate error model    ${result.content}

Landinfo Get By Region Archived
    [Documentation]    Get landinfo data by region and validate response
    [Tags]      Get     Landinfo        get_by_region
    ${get_url}=     replace variables        ${API_URL}&type=get_by_region&minlat=${MIN_LATITUDE}&minlong=${MIN_LONGITUDE}&maxlat=${MAX_LATITUDE}&maxlong=${MAX_LONGITUDE}&count=${COUNT}&display=${DISPLAY_SET}&delimiter=${DELIMITER}&records_type=1&x
    create session      get_by_region     ${get_url}
    ${result}=  Get Request     get_by_region     /get
    should be valid json     ${result.content}
    ${next_cursor}=      run keyword if      ${result.status_code}== 200       validate success cursor type    ${result.content}
    :FOR    ${i}    IN RANGE    9999999
    \       Exit For Loop If    ${next_cursor} is None
    \       Exit For Loop If    ${next_cursor}==0
    \       ${next_cursor}=    call api with cursor        ${get_url}       ${next_cursor}
    run keyword unless      ${result.status_code}== 200       validate error model    ${result.content}

Landinfo Get By Region Both
    [Documentation]    Get landinfo data by region and validate response
    [Tags]      Get     Landinfo        get_by_region
    ${get_url}=     replace variables        ${API_URL}&type=get_by_region&minlat=${MIN_LATITUDE}&minlong=${MIN_LONGITUDE}&maxlat=${MAX_LATITUDE}&maxlong=${MAX_LONGITUDE}&count=${COUNT}&display=${DISPLAY_SET}&delimiter=${DELIMITER}&records_type=2&x
    create session      get_by_region     ${get_url}
    ${result}=  Get Request     get_by_region     /get
    should be valid json     ${result.content}
    ${next_cursor}=      run keyword if      ${result.status_code}== 200       validate success cursor type    ${result.content}
    :FOR    ${i}    IN RANGE    9999999
    \       Exit For Loop If    ${next_cursor} is None
    \       Exit For Loop If    ${next_cursor}==0
    \       ${next_cursor}=    call api with cursor        ${get_url}       ${next_cursor}
    run keyword unless      ${result.status_code}== 200       validate error model    ${result.content}

Landinfo Get By Region And Recorder Name Default
    [Documentation]    Get landinfo data by region,recorder_name and validate response
    [Tags]      Get     Landinfo        get_by_region_recorder_name
    ${get_url}=     replace variables        ${API_URL}&type=get_by_region_recorder_name&recorder_name=${RECORDER_NAME}&minlat=${MIN_LATITUDE}&minlong=${MIN_LONGITUDE}&maxlat=${MAX_LATITUDE}&maxlong=${MAX_LONGITUDE}&count=${COUNT}&display=${DISPLAY_SET}&delimiter=${DELIMITER}&x
    create session      get_by_region_recorder_name     ${get_url}
    ${result}=  Get Request     get_by_region_recorder_name     /get
    should be valid json     ${result.content}
    ${next_cursor}=      run keyword if      ${result.status_code}== 200       validate success cursor type    ${result.content}
    :FOR    ${i}    IN RANGE    9999999
    \       Exit For Loop If    ${next_cursor} is None
    \       Exit For Loop If    ${next_cursor}==0
    \       ${next_cursor}=    call api with cursor        ${get_url}       ${next_cursor}
    run keyword unless      ${result.status_code}== 200       validate error model    ${result.content}

Landinfo Get By Region And Recorder Name Archived
    [Documentation]    Get landinfo data by region,recorder_name and validate response
    [Tags]      Get     Landinfo        get_by_region_recorder_name
    ${get_url}=     replace variables        ${API_URL}&type=get_by_region_recorder_name&recorder_name=${RECORDER_NAME}&minlat=${MIN_LATITUDE}&minlong=${MIN_LONGITUDE}&maxlat=${MAX_LATITUDE}&maxlong=${MAX_LONGITUDE}&count=${COUNT}&display=${DISPLAY_SET}&delimiter=${DELIMITER}&records_type=1&x
    create session      get_by_region_recorder_name     ${get_url}
    ${result}=  Get Request     get_by_region_recorder_name     /get
    should be valid json     ${result.content}
    ${next_cursor}=      run keyword if      ${result.status_code}== 200       validate success cursor type    ${result.content}
    :FOR    ${i}    IN RANGE    9999999
    \       Exit For Loop If    ${next_cursor} is None
    \       Exit For Loop If    ${next_cursor}==0
    \       ${next_cursor}=    call api with cursor        ${get_url}       ${next_cursor}
    run keyword unless      ${result.status_code}== 200       validate error model    ${result.content}

Landinfo Get By Region And Recorder Name Both
    [Documentation]    Get landinfo data by region,recorder_name and validate response
    [Tags]      Get     Landinfo        get_by_region_recorder_name
    ${get_url}=     replace variables        ${API_URL}&type=get_by_region_recorder_name&recorder_name=${RECORDER_NAME}&minlat=${MIN_LATITUDE}&minlong=${MIN_LONGITUDE}&maxlat=${MAX_LATITUDE}&maxlong=${MAX_LONGITUDE}&count=${COUNT}&display=${DISPLAY_SET}&delimiter=${DELIMITER}&records_type=2&x
    create session      get_by_region_recorder_name     ${get_url}
    ${result}=  Get Request     get_by_region_recorder_name     /get
    should be valid json     ${result.content}
    ${next_cursor}=      run keyword if      ${result.status_code}== 200       validate success cursor type    ${result.content}
    :FOR    ${i}    IN RANGE    9999999
    \       Exit For Loop If    ${next_cursor} is None
    \       Exit For Loop If    ${next_cursor}==0
    \       ${next_cursor}=    call api with cursor        ${get_url}       ${next_cursor}
    run keyword unless      ${result.status_code}== 200       validate error model    ${result.content}

Landinfo Get By AfterDate Default
    [Documentation]    Get landinfo data by afterdate and validate response
    [Tags]      Get     Landinfo        get_by_afterdate
    ${get_url}=     replace variables        ${API_URL}&type=get_by_afterdate&after_date=${AFTERDATE}&count=${COUNT}&display=${DISPLAY_SET}&delimiter=${DELIMITER}&x
    create session      get_by_afterdate     ${get_url}
    ${result}=  Get Request     get_by_afterdate     /get
    should be valid json     ${result.content}
    ${next_cursor}=      run keyword if      ${result.status_code}== 200       validate success cursor type    ${result.content}
    :FOR    ${i}    IN RANGE    9999999
    \       Exit For Loop If    ${next_cursor} is None
    \       Exit For Loop If    ${next_cursor}==0
    \       ${next_cursor}=    call api with cursor        ${get_url}       ${next_cursor}
    run keyword unless      ${result.status_code}== 200       validate error model    ${result.content}

Landinfo Get By AfterDate Archived
    [Documentation]    Get landinfo data by afterdate and validate response
    [Tags]      Get     Landinfo        get_by_afterdate
    ${get_url}=     replace variables        ${API_URL}&type=get_by_afterdate&after_date=${AFTERDATE}&count=${COUNT}&display=${DISPLAY_SET}&delimiter=${DELIMITER}&records_type=1&x
    create session      get_by_afterdate     ${get_url}
    ${result}=  Get Request     get_by_afterdate     /get
    should be valid json     ${result.content}
    ${next_cursor}=      run keyword if      ${result.status_code}== 200       validate success cursor type    ${result.content}
    :FOR    ${i}    IN RANGE    9999999
    \       Exit For Loop If    ${next_cursor} is None
    \       Exit For Loop If    ${next_cursor}==0
    \       ${next_cursor}=    call api with cursor        ${get_url}       ${next_cursor}
    run keyword unless      ${result.status_code}== 200       validate error model    ${result.content}

Landinfo Get By AfterDate Both
    [Documentation]    Get landinfo data by afterdate and validate response
    [Tags]      Get     Landinfo        get_by_afterdate
    ${get_url}=     replace variables        ${API_URL}&type=get_by_afterdate&after_date=${AFTERDATE}&count=${COUNT}&display=${DISPLAY_SET}&delimiter=${DELIMITER}&records_type=2&x
    create session      get_by_afterdate     ${get_url}
    ${result}=  Get Request     get_by_afterdate     /get
    should be valid json     ${result.content}
    ${next_cursor}=      run keyword if      ${result.status_code}== 200       validate success cursor type    ${result.content}
    :FOR    ${i}    IN RANGE    9999999
    \       Exit For Loop If    ${next_cursor} is None
    \       Exit For Loop If    ${next_cursor}==0
    \       ${next_cursor}=    call api with cursor        ${get_url}       ${next_cursor}
    run keyword unless      ${result.status_code}== 200       validate error model    ${result.content}

Landinfo Get By BeforeDate Default
    [Documentation]    Get landinfo data by beforedate and validate response
    [Tags]      Get     Landinfo        get_by_beforedate
    ${get_url}=     replace variables        ${API_URL}&type=get_by_beforedate&before_date=${BEFOREDATE}&count=${COUNT}&display=${DISPLAY_SET}&delimiter=${DELIMITER}&x
    create session      get_by_beforedate     ${get_url}
    ${result}=  Get Request     get_by_beforedate     /get
    should be valid json     ${result.content}
    ${next_cursor}=      run keyword if      ${result.status_code}== 200       validate success cursor type    ${result.content}
    :FOR    ${i}    IN RANGE    9999999
    \       Exit For Loop If    ${next_cursor} is None
    \       Exit For Loop If    ${next_cursor}==0
    \       ${next_cursor}=    call api with cursor        ${get_url}       ${next_cursor}
    run keyword unless      ${result.status_code}== 200       validate error model    ${result.content}

Landinfo Get By BeforeDate Archived
    [Documentation]    Get landinfo data by beforedate and validate response
    [Tags]      Get     Landinfo        get_by_beforedate
    ${get_url}=     replace variables        ${API_URL}&type=get_by_beforedate&before_date=${BEFOREDATE}&count=${COUNT}&display=${DISPLAY_SET}&delimiter=${DELIMITER}&records_type=1&x
    create session      get_by_beforedate     ${get_url}
    ${result}=  Get Request     get_by_beforedate     /get
    should be valid json     ${result.content}
    ${next_cursor}=      run keyword if      ${result.status_code}== 200       validate success cursor type    ${result.content}
    :FOR    ${i}    IN RANGE    9999999
    \       Exit For Loop If    ${next_cursor} is None
    \       Exit For Loop If    ${next_cursor}==0
    \       ${next_cursor}=    call api with cursor        ${get_url}       ${next_cursor}
    run keyword unless      ${result.status_code}== 200       validate error model    ${result.content}


Landinfo Get By BeforeDate Both
    [Documentation]    Get landinfo data by beforedate and validate response
    [Tags]      Get     Landinfo        get_by_beforedate
    ${get_url}=     replace variables        ${API_URL}&type=get_by_beforedate&before_date=${BEFOREDATE}&count=${COUNT}&display=${DISPLAY_SET}&delimiter=${DELIMITER}&records_type=2&x
    create session      get_by_beforedate     ${get_url}
    ${result}=  Get Request     get_by_beforedate     /get
    should be valid json     ${result.content}
    ${next_cursor}=      run keyword if      ${result.status_code}== 200       validate success cursor type    ${result.content}
    :FOR    ${i}    IN RANGE    9999999
    \       Exit For Loop If    ${next_cursor} is None
    \       Exit For Loop If    ${next_cursor}==0
    \       ${next_cursor}=    call api with cursor        ${get_url}       ${next_cursor}
    run keyword unless      ${result.status_code}== 200       validate error model    ${result.content}

Landinfo Get By BeforeDate AfterDate Default
    [Documentation]    Get landinfo data by beforedate and validate response
    [Tags]      Get     Landinfo        get_by_beforedate_afterdate
    ${get_url}=     replace variables        ${API_URL}&type=get_by_beforedate_afterdate&before_date=${BEFOREDATE}&after_date=${AFTERDATE}&count=${COUNT}&display=${DISPLAY_SET}&delimiter=${DELIMITER}&x
    create session      get_by_beforedate_afterdate     ${get_url}
    ${result}=  Get Request     get_by_beforedate_afterdate     /get
    should be valid json     ${result.content}
    ${next_cursor}=      run keyword if      ${result.status_code}== 200       validate success cursor type    ${result.content}
    :FOR    ${i}    IN RANGE    9999999
    \       Exit For Loop If    ${next_cursor} is None
    \       Exit For Loop If    ${next_cursor}==0
    \       ${next_cursor}=    call api with cursor        ${get_url}       ${next_cursor}
    run keyword unless      ${result.status_code}== 200       validate error model    ${result.content}

Landinfo Get By BeforeDate AfterDate Archived
    [Documentation]    Get landinfo data by beforedate and validate response
    [Tags]      Get     Landinfo        get_by_beforedate_afterdate
    ${get_url}=     replace variables        ${API_URL}&type=get_by_beforedate_afterdate&before_date=${BEFOREDATE}&after_date=${AFTERDATE}&count=${COUNT}&display=${DISPLAY_SET}&delimiter=${DELIMITER}&records_type=1&x
    create session      get_by_beforedate_afterdate     ${get_url}
    ${result}=  Get Request     get_by_beforedate_afterdate     /get
    should be valid json     ${result.content}
    ${next_cursor}=      run keyword if      ${result.status_code}== 200       validate success cursor type    ${result.content}
    :FOR    ${i}    IN RANGE    9999999
    \       Exit For Loop If    ${next_cursor} is None
    \       Exit For Loop If    ${next_cursor}==0
    \       ${next_cursor}=    call api with cursor        ${get_url}       ${next_cursor}
    run keyword unless      ${result.status_code}== 200       validate error model    ${result.content}

Landinfo Get By BeforeDate AfterDate Both
    [Documentation]    Get landinfo data by beforedate and validate response
    [Tags]      Get     Landinfo        get_by_beforedate_afterdate
    ${get_url}=     replace variables        ${API_URL}&type=get_by_beforedate_afterdate&before_date=${BEFOREDATE}&after_date=${AFTERDATE}&count=${COUNT}&display=${DISPLAY_SET}&delimiter=${DELIMITER}&records_type=2&x
    create session      get_by_beforedate_afterdate     ${get_url}
    ${result}=  Get Request     get_by_beforedate_afterdate     /get
    should be valid json     ${result.content}
    ${next_cursor}=      run keyword if      ${result.status_code}== 200       validate success cursor type    ${result.content}
    :FOR    ${i}    IN RANGE    9999999
    \       Exit For Loop If    ${next_cursor} is None
    \       Exit For Loop If    ${next_cursor}==0
    \       ${next_cursor}=    call api with cursor        ${get_url}       ${next_cursor}
    run keyword unless      ${result.status_code}== 200       validate error model    ${result.content}

*** Keywords ***
Call API With Cursor
    [Arguments]     ${url}      ${cursor}
    create session      landinfo_get     ${url}&cursor=${cursor}&x
    ${result}=  Get Request     landinfo_get     /get
    should be valid json     ${result.content}
    ${next_cursor}=      run keyword if      ${result.status_code}== 200       validate success cursor type    ${result.content}
    run keyword unless      ${result.status_code}== 200       validate error model    ${result.content}
    [return]        ${next_cursor}

Validate Success Non Cursor Type
    [Arguments]     ${data}
    ${data_json}=     to json     ${data}
    validate landinfo data model    ${data_json}


Validate Success Cursor Type
    [Arguments]     ${result}
    ${result_json}=     to json     ${result}
    ${search_metadata}=     get cursor metadata     ${result_json}
    validate cursor model       ${search_metadata}
    ${has_next} =   get cursor has next       ${search_metadata}

    ${data}=     Get Data     ${result_json}
    validate data length    ${data}     ${has_next}
    validate landinfo data model    ${data}
    ${next_cursor} =   get next cursor       ${search_metadata}
    [return]        ${next_cursor}


Validate Data length
    [Arguments]     ${data}     ${has_next}
    ${response_list_length}=     get length      ${data}
    run keyword if      ${has_next} is True     validate length equal to count     ${response_list_length}
    run keyword unless      ${has_next} is True        validate length less or equal to count      ${response_list_length}

Validate Length Equal To Count
    [Arguments]     ${length}
    should be true      ${length}==${COUNT}

Validate Length Less Or Equal To Count
    [Arguments]     ${length}
    should be true      ${length}<=${COUNT}

Validate Content Name Recorder Name
    [Arguments]         ${content}
    ${json_string}=        Get file        get_by_name_recorder_name_landinfo.json

    ${orginal_json}=     to json     ${json_string}

    ${content_json}=     to json     ${content}

    lists should be equal    ${content_json}     ${orginal_json}

Validate Landinfo Data Model
    [Arguments]     ${data}
    ${original_landinfo_keys}=       split string    ${LANDINFO_OBJECT_KEY_LIST}     ,
    @{data_list}=       convert to list     ${data}
    :FOR        ${landinfo_object}       IN      @{data_list}
    \       ${landinfo_data_keys}=        get dictionary keys        ${landinfo_object}
    \       Lists Should Be Equal   ${landinfo_data_keys}     ${original_landinfo_keys}






