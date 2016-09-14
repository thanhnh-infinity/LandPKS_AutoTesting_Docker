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
${API_URL}     ${API_BASE_URL}&action=get&object=landcover
${DISPLAY_SET}     0
${DELIMITER}        %27
${RECORDER_NAME}    lpks.test@gmail.com
${RECORDER_NAME2}    dwkimiti@gmail.com
${PlOT_NAME2}    dwkimiti@gmail.com-BOT1
${COUNT}    50
${AFTERDATE}    2010-01-01
${BEFOREDATE}    2050-01-01

*** Test Cases ***
Landcover Get All Default
    [Documentation]    Get all landcover data and validate response
    [Tags]      Get     Landcover        get_all
    ${get_url}=     replace variables        ${API_URL}&type=get_all&recorder_name=all&count=${COUNT}&x
    create session      landcover_getall     ${get_url}
    ${result}=  Get Request     landcover_getall     /get
    should be valid json     ${result.content}
    ${next_cursor}=      run keyword if      ${result.status_code}== 200       validate success cursor type    ${result.content}
    :FOR    ${i}    IN RANGE    9999999
    \       Exit For Loop If    ${next_cursor} is None
    \       Exit For Loop If    ${next_cursor}==0
    \       ${next_cursor}=    call api with cursor        ${get_url}       ${next_cursor}
    run keyword unless      ${result.status_code}== 200       validate error model    ${result.content}

Landcover Get All Archived
    [Documentation]    Get all landcover data and validate response
    [Tags]      Get     Landcover        get_all
    ${get_url}=     replace variables        ${API_URL}&type=get_all&recorder_name=all&count=${COUNT}&records_type=1&x
    create session      landcover_getall     ${get_url}
    ${result}=  Get Request     landcover_getall     /get
    should be valid json     ${result.content}
    ${next_cursor}=      run keyword if      ${result.status_code}== 200       validate success cursor type    ${result.content}
    :FOR    ${i}    IN RANGE    9999999
    \       Exit For Loop If    ${next_cursor} is None
    \       Exit For Loop If    ${next_cursor}==0
    \       ${next_cursor}=    call api with cursor        ${get_url}       ${next_cursor}
    run keyword unless      ${result.status_code}== 200       validate error model    ${result.content}

Landcover Get All Both
    [Documentation]    Get all landcover data and validate response
    [Tags]      Get     Landcover        get_all
    ${get_url}=     replace variables        ${API_URL}&type=get_all&recorder_name=all&count=${COUNT}&records_type=2&x
    create session      landcover_getall     ${get_url}
    ${result}=  Get Request     landcover_getall     /get
    should be valid json     ${result.content}
    ${next_cursor}=      run keyword if      ${result.status_code}== 200       validate success cursor type    ${result.content}
    :FOR    ${i}    IN RANGE    9999999
    \       Exit For Loop If    ${next_cursor} is None
    \       Exit For Loop If    ${next_cursor}==0
    \       ${next_cursor}=    call api with cursor        ${get_url}       ${next_cursor}
    run keyword unless      ${result.status_code}== 200       validate error model    ${result.content}

Landcover Get By Pair Name Recorder Name Default
    [Documentation]     Get  landcover data by name and recorder name and validate response
    [Tags]    Get      Landcover        get_by_pair_name_recorder_name
    ${get_url}=     replace variables        ${API_URL}&type=get_by_pair_name_recorder_name&name=${PlOT_NAME2}&recorder_name=${RECORDER_NAME2}&records_type=0&x
    create session      landcover_get     ${get_url}
    ${result}=  Get Request     landcover_get     /get
    should be valid json     ${result.content}
    run keyword if      ${result.status_code}== 200       validate success non cursor type    ${result.content}
    run keyword unless      ${result.status_code}== 200       validate error model    ${result.content}

    ${get_url}=     replace variables        ${API_URL}&type=get_by_pair_name_recorder_name&name=${PlOT_NAME2}&recorder_name=${RECORDER_NAME2}&records_type=0&x
    create session      landcover_getbynamerecordername     ${get_url}
    ${result}=  Get Request     landcover_getbynamerecordername     /get
    should be valid json     ${result.content}
    run keyword if      ${result.status_code}== 200       validate content name recorder name    ${result.content}

Landcover Get By Pair Name Recorder Name Archived
    [Documentation]     Get  landcover data by name and recorder name and validate response
    [Tags]    Get      Landcover        get_by_pair_name_recorder_name
    ${get_url}=     replace variables        ${API_URL}&type=get_by_pair_name_recorder_name&name=${PlOT_NAME2}&recorder_name=${RECORDER_NAME2}&records_type=1&x
    create session      landcover_get     ${get_url}
    ${result}=  Get Request     landcover_get     /get
    should be valid json     ${result.content}
    run keyword if      ${result.status_code}== 200       validate success non cursor type    ${result.content}
    run keyword unless      ${result.status_code}== 200       validate error model    ${result.content}



Landcover Get By Pair Name Recorder Name Both
    [Documentation]     Get  landcover data by name and recorder name and validate response
    [Tags]    Get      Landcover        get_by_pair_name_recorder_name
    ${get_url}=     replace variables        ${API_URL}&type=get_by_pair_name_recorder_name&name=${PlOT_NAME2}&recorder_name=${RECORDER_NAME2}&count=${COUNT}&records_type=2&x
    create session      landcover_get     ${get_url}
    ${result}=  Get Request     landcover_get     /get
    should be valid json     ${result.content}
    run keyword if      ${result.status_code}== 200       validate success non cursor type    ${result.content}
    run keyword unless      ${result.status_code}== 200       validate error model    ${result.content}

Landcover Get By Recorder Name Default
    [Documentation]     Get  landcover data by recorder name and validate response
    [Tags]    Get      Landcover        get_by_recorder_name
    ${get_url}=     replace variables        ${API_URL}&type=get_by_recorder_name&recorder_name=${RECORDER_NAME2}&count=${COUNT}&records_type=0&x
    create session      landcover_get     ${get_url}
    ${result}=  Get Request     landcover_get     /get
    should be valid json     ${result.content}
    ${next_cursor}=      run keyword if      ${result.status_code}== 200       validate success cursor type    ${result.content}
    :FOR    ${i}    IN RANGE    9999999
    \       Exit For Loop If    ${next_cursor} is None
    \       Exit For Loop If    ${next_cursor}==0
    \       ${next_cursor}=    call api with cursor        ${get_url}       ${next_cursor}
    run keyword unless      ${result.status_code}== 200       validate error model    ${result.content}



Landcover Get By Recorder Name Archived
    [Documentation]     Get  landcover data by recorder name and validate response
    [Tags]    Get      Landcover        get_by_recorder_name
    ${get_url}=     replace variables        ${API_URL}&type=get_by_recorder_name&recorder_name=${RECORDER_NAME2}&count=${COUNT}&records_type=1&x
    create session      landcover_get     ${get_url}
    ${result}=  Get Request     landcover_get     /get
    should be valid json     ${result.content}
    ${next_cursor}=      run keyword if      ${result.status_code}== 200       validate success cursor type    ${result.content}
    :FOR    ${i}    IN RANGE    9999999
    \       Exit For Loop If    ${next_cursor} is None
    \       Exit For Loop If    ${next_cursor}==0
    \       ${next_cursor}=    call api with cursor        ${get_url}       ${next_cursor}
    run keyword unless      ${result.status_code}== 200       validate error model    ${result.content}

Landcover Get By Recorder Name Both
    [Documentation]     Get  landcover data by recorder name and validate response
    [Tags]    Get      Landcover        get_by_recorder_name
    ${get_url}=     replace variables        ${API_URL}&type=get_by_recorder_name&recorder_name=${RECORDER_NAME2}&count=${COUNT}&records_type=2&x
    create session      landcover_get     ${get_url}
    ${result}=  Get Request     landcover_get     /get
    should be valid json     ${result.content}
    ${next_cursor}=      run keyword if      ${result.status_code}== 200       validate success cursor type    ${result.content}
    :FOR    ${i}    IN RANGE    9999999
    \       Exit For Loop If    ${next_cursor} is None
    \       Exit For Loop If    ${next_cursor}==0
    \       ${next_cursor}=    call api with cursor        ${get_url}       ${next_cursor}
    run keyword unless      ${result.status_code}== 200       validate error model    ${result.content}

Landcover Get By AfterDate Default
    [Documentation]     Get  landcover data by afterdate and validate response
    [Tags]    Get      Landcover        get_by_afterdate
    ${get_url}=     replace variables        ${API_URL}&type=get_by_afterdate&after_date=${AFTERDATE}&count=${COUNT}&records_type=0&x
    create session      landcover_get     ${get_url}
    ${result}=  Get Request     landcover_get     /get
    should be valid json     ${result.content}
    ${next_cursor}=      run keyword if      ${result.status_code}== 200       validate success cursor type    ${result.content}
    :FOR    ${i}    IN RANGE    9999999
    \       Exit For Loop If    ${next_cursor} is None
    \       Exit For Loop If    ${next_cursor}==0
    \       ${next_cursor}=    call api with cursor        ${get_url}       ${next_cursor}
    run keyword unless      ${result.status_code}== 200       validate error model    ${result.content}

Landcover Get By AfterDate Archived
    [Documentation]     Get  landcover data by afterdate and validate response
    [Tags]    Get      Landcover        get_by_afterdate
    ${get_url}=     replace variables        ${API_URL}&type=get_by_afterdate&after_date=${AFTERDATE}&count=${COUNT}&records_type=1&x
    create session      landcover_get     ${get_url}
    ${result}=  Get Request     landcover_get     /get
    should be valid json     ${result.content}
    ${next_cursor}=      run keyword if      ${result.status_code}== 200       validate success cursor type    ${result.content}
    :FOR    ${i}    IN RANGE    9999999
    \       Exit For Loop If    ${next_cursor} is None
    \       Exit For Loop If    ${next_cursor}==0
    \       ${next_cursor}=    call api with cursor        ${get_url}       ${next_cursor}
    run keyword unless      ${result.status_code}== 200       validate error model    ${result.content}

Landcover Get By AfterDate Both
    [Documentation]     Get  landcover data by afterdate and validate response
    [Tags]    Get      Landcover        get_by_afterdate
    ${get_url}=     replace variables        ${API_URL}&type=get_by_afterdate&after_date=${AFTERDATE}&count=${COUNT}&records_type=2&x
    create session      landcover_get     ${get_url}
    ${result}=  Get Request     landcover_get     /get
    should be valid json     ${result.content}
    ${next_cursor}=      run keyword if      ${result.status_code}== 200       validate success cursor type    ${result.content}
    :FOR    ${i}    IN RANGE    9999999
    \       Exit For Loop If    ${next_cursor} is None
    \       Exit For Loop If    ${next_cursor}==0
    \       ${next_cursor}=    call api with cursor        ${get_url}       ${next_cursor}
    run keyword unless      ${result.status_code}== 200       validate error model    ${result.content}

Landcover Get By BeforeDate default
    [Documentation]     Get  landcover data by beforedate and validate response
    [Tags]    Get      Landcover        get_by_beforedate
    ${get_url}=     replace variables        ${API_URL}&type=get_by_beforedate&before_date=${BEFOREDATE}&count=${COUNT}&records_type=0&x
    create session      landcover_get     ${get_url}
    ${result}=  Get Request     landcover_get     /get
    should be valid json     ${result.content}
    ${next_cursor}=      run keyword if      ${result.status_code}== 200       validate success cursor type    ${result.content}
    :FOR    ${i}    IN RANGE    9999999
    \       Exit For Loop If    ${next_cursor} is None
    \       Exit For Loop If    ${next_cursor}==0
    \       ${next_cursor}=    call api with cursor        ${get_url}       ${next_cursor}
    run keyword unless      ${result.status_code}== 200       validate error model    ${result.content}

Landcover Get By BeforeDate Archived
    [Documentation]     Get  landcover data by beforedate and validate response
    [Tags]    Get      Landcover        get_by_beforedate
    ${get_url}=     replace variables        ${API_URL}&type=get_by_beforedate&before_date=${BEFOREDATE}&count=${COUNT}&records_type=1&x
    create session      landcover_get     ${get_url}
    ${result}=  Get Request     landcover_get     /get
    should be valid json     ${result.content}
    ${next_cursor}=      run keyword if      ${result.status_code}== 200       validate success cursor type    ${result.content}
    :FOR    ${i}    IN RANGE    9999999
    \       Exit For Loop If    ${next_cursor} is None
    \       Exit For Loop If    ${next_cursor}==0
    \       ${next_cursor}=    call api with cursor        ${get_url}       ${next_cursor}
    run keyword unless      ${result.status_code}== 200       validate error model    ${result.content}

Landcover Get By BeforeDate Both
    [Documentation]     Get  landcover data by beforedate and validate response
    [Tags]    Get      Landcover        get_by_beforedate
    ${get_url}=     replace variables        ${API_URL}&type=get_by_beforedate&before_date=${BEFOREDATE}&count=${COUNT}&records_type=2&x
    create session      landcover_get     ${get_url}
    ${result}=  Get Request     landcover_get     /get
    should be valid json     ${result.content}
    ${next_cursor}=      run keyword if      ${result.status_code}== 200       validate success cursor type    ${result.content}
    :FOR    ${i}    IN RANGE    9999999
    \       Exit For Loop If    ${next_cursor} is None
    \       Exit For Loop If    ${next_cursor}==0
    \       ${next_cursor}=    call api with cursor        ${get_url}       ${next_cursor}
    run keyword unless      ${result.status_code}== 200       validate error model    ${result.content}

Landcover Get By BeforeDate AfterDate Default
    [Documentation]     Get  landcover data by get_by_beforedate_afterdate and validate response
    [Tags]    Get      Landcover        get_by_beforedate_afterdate
    ${get_url}=     replace variables        ${API_URL}&type=get_by_beforedate_afterdate&before_date=${BEFOREDATE}&after_date=${AFTERDATE}&count=${COUNT}&records_type=0&x
    create session      landcover_get     ${get_url}
    ${result}=  Get Request     landcover_get     /get
    should be valid json     ${result.content}
    ${next_cursor}=      run keyword if      ${result.status_code}== 200       validate success cursor type    ${result.content}
    :FOR    ${i}    IN RANGE    9999999
    \       Exit For Loop If    ${next_cursor} is None
    \       Exit For Loop If    ${next_cursor}==0
    \       ${next_cursor}=    call api with cursor        ${get_url}       ${next_cursor}
    run keyword unless      ${result.status_code}== 200       validate error model    ${result.content}

Landcover Get By BeforeDate AfterDate Archived
    [Documentation]     Get  landcover data by get_by_beforedate_afterdate and validate response
    [Tags]    Get      Landcover        get_by_beforedate_afterdate
    ${get_url}=     replace variables        ${API_URL}&type=get_by_beforedate_afterdate&before_date=${BEFOREDATE}&after_date=${AFTERDATE}&count=${COUNT}&records_type=1&x
    create session      landcover_get     ${get_url}
    ${result}=  Get Request     landcover_get     /get
    should be valid json     ${result.content}
    ${next_cursor}=      run keyword if      ${result.status_code}== 200       validate success cursor type    ${result.content}
    :FOR    ${i}    IN RANGE    9999999
    \       Exit For Loop If    ${next_cursor} is None
    \       Exit For Loop If    ${next_cursor}==0
    \       ${next_cursor}=    call api with cursor        ${get_url}       ${next_cursor}
    run keyword unless      ${result.status_code}== 200       validate error model    ${result.content}

Landcover Get By BeforeDate AfterDate Both
    [Documentation]     Get  landcover data by get_by_beforedate_afterdate and validate response
    [Tags]    Get      Landcover        get_by_beforedate_afterdate
    ${get_url}=     replace variables        ${API_URL}&type=get_by_beforedate_afterdate&before_date=${BEFOREDATE}&after_date=${AFTERDATE}&count=${COUNT}&records_type=2&x
    create session      landcover_get     ${get_url}
    ${result}=  Get Request     landcover_get     /get
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
    create session      landcover_get     ${url}&cursor=${cursor}&x
    ${result}=  Get Request     landcover_get     /get
    should be valid json     ${result.content}
    ${next_cursor}=      run keyword if      ${result.status_code}== 200       validate success cursor type    ${result.content}
    run keyword unless      ${result.status_code}== 200       validate error model    ${result.content}
    [Return]         ${next_cursor}

Validate Success Non Cursor Type
    [Arguments]     ${data}
    ${data_json}=     to json     ${data}
    validate landcover data model no cursor    ${data_json}

Validate Success Cursor Type
    [Arguments]     ${result}
    ${result_json}=     to json     ${result}
    ${search_metadata}=     get cursor metadata     ${result_json}
    validate cursor model       ${search_metadata}
    ${has_next} =   get cursor has next       ${search_metadata}

    ${data}=     Get Data     ${result_json}
    validate data length    ${data}     ${has_next}
    validate landcover data model    ${data}
    ${next_cursor} =   get next cursor       ${search_metadata}
    [Return]        ${next_cursor}

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

Validate Landcover Data Model
    [Arguments]     ${data}
    ${original_landcover_keys}=       split string    ${LANDCOVER_OBJECT_KEY_LIST}     ,
    @{data_list}=       convert to list     ${data}
    :FOR        ${landcover_object}       IN      @{data_list}
    \       ${landcover_data_keys}=        get dictionary keys        ${landcover_object}
    \       Lists Should Be Equal   ${landcover_data_keys}     ${original_landcover_keys}
    \       ${transect}=        get from dictionary     ${landcover_object}     transect
    \       validate landcover transect model       ${transect}

Validate Landcover Data Model No Cursor
    [Arguments]     ${data}
    ${original_landcover_keys}=       split string    ${LANDCOVER_OBJECT_KEY_LIST}     ,
    ${landcover_data_keys}=        get dictionary keys        ${data}
    Lists Should Be Equal   ${landcover_data_keys}     ${original_landcover_keys}
    ${transect}=        get from dictionary     ${data}     transect
    validate landcover transect model       ${transect}

Validate Landcover Transect Model
    [Arguments]     ${data}
    ${original_transect_keys}=       split string    ${LANDCOVER_TRANSECT_KEY_LIST}     ,
    @{data_list}=       convert to list     ${data}
    :FOR        ${transect_object}       IN      @{data_list}
    \       ${transect_data_keys}=        get dictionary keys        ${transect_object}
    \       Lists Should Be Equal   ${transect_data_keys}     ${original_transect_keys}
    \       ${segment}=        get from dictionary     ${transect_object}     segment
    \       validate landcover segment model       ${segment}
    \       exit for loop

Validate Landcover Segment Model
    [Arguments]     ${data}
    ${original_segment_keys}=       split string     ${LANDCOVER_SEGMENT_KEY_LIST}      ,
    ${original_summary_keys}=       split string     ${LANDCOVER_SUMMARY_KEY_LIST}      ,

    ${segment_object}=     set variable       ${data}
    ${segment_data_keys}=        get dictionary keys        ${segment_object}
    Lists Should Be Equal       ${segment_data_keys}     ${original_segment_keys}

    ${stick_segment}=        get from dictionary     ${segment_object}     stick_segment
    validate landcover stick segment model       ${stick_segment}

    ${summary}=        get from dictionary     ${segment_object}     summary
    ${summary_keys}=        get dictionary keys        ${summary}
    Lists Should Be Equal       ${summary_keys}     ${original_summary_keys}


Validate Landcover Stick Segment Model
    [Arguments]     ${data}
    ${original_stick_segment_keys}=       split string     ${LANDCOVER_STICK_SEGMENT_KEY_LIST}      ,
    ${original_stick_segment_values_keys}=       split string     ${LANDCOVER_STICK_SEGMENT_VALUE_KEY_LIST}      ,

    ${stick_segment_object}=     set variable       ${data}
    ${stick_segment_data_keys}=        get dictionary keys        ${stick_segment_object}
    Lists Should Be Equal       ${stick_segment_data_keys}     ${original_stick_segment_keys}

    ${stick_stick_segment_0}=        get from dictionary     ${stick_segment_object}     0
    ${stick_stick_segment_0_keys}=        get dictionary keys       ${stick_stick_segment_0}
    Lists Should Be Equal       ${stick_stick_segment_0_keys}     ${original_stick_segment_values_keys}

    ${stick_stick_segment_1}=        get from dictionary     ${stick_segment_object}     1
    ${stick_stick_segment_1_keys}=        get dictionary keys       ${stick_stick_segment_1}
    Lists Should Be Equal       ${stick_stick_segment_1_keys}     ${original_stick_segment_values_keys}

    ${stick_stick_segment_2}=        get from dictionary     ${stick_segment_object}     2
    ${stick_stick_segment_2_keys}=        get dictionary keys       ${stick_stick_segment_2}
    Lists Should Be Equal       ${stick_stick_segment_2_keys}     ${original_stick_segment_values_keys}

    ${stick_stick_segment_3}=        get from dictionary     ${stick_segment_object}     3
    ${stick_stick_segment_3_keys}=        get dictionary keys       ${stick_stick_segment_3}
    Lists Should Be Equal       ${stick_stick_segment_3_keys}     ${original_stick_segment_values_keys}

    ${stick_stick_segment_4}=        get from dictionary     ${stick_segment_object}     4
    ${stick_stick_segment_4_keys}=        get dictionary keys       ${stick_stick_segment_4}
    Lists Should Be Equal       ${stick_stick_segment_4_keys}     ${original_stick_segment_values_keys}


Validate Content Name Recorder Name
    [Arguments]         ${content}
    ${json_string}=        Get file        get_by_name_recorder_name_landcover.json
    ${orginal_json}=     to json     ${json_string}

    ${content_json}=     to json     ${content}
    lists should be equal    ${content_json}     ${orginal_json}