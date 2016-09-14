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
${API_URL}     ${API_BASE_URL}&action=get&object=landinfo_landcover
${RECORDER_NAME}    dwkimiti@gmail.com
${COUNT}            5000
${OUTPUT_FILTER}        latitude,longitude,test_plot,organization,landinfo_archived,has_landcover,landcover_archived

*** Test Cases ***
Landinfo_Landcover Get All Default
    [Documentation]    Get all landinfo_landcover data and validate response
    [Tags]      Get     Landinfo_Landcover        get_all
    ${get_all_url}=     replace variables        ${API_URL}&type=get_all&recorder_name=all&count=${COUNT}&output_filter=${OUTPUT_FILTER}&x
    create session      landinfo_landcover_getall     ${get_all_url}
    ${result}=  Get Request     landinfo_landcover_getall     /get
    should be valid json     ${result.content}
    ${next_cursor}=      run keyword if      ${result.status_code}== 200       validate success cursor type    ${result.content}
    :FOR    ${i}    IN RANGE    9999999
    \       Exit For Loop If    ${next_cursor} is None
    \       Exit For Loop If    ${next_cursor}==0
    \       ${next_cursor}=    call api with cursor        ${get_all_url}       ${next_cursor}
    run keyword unless      ${result.status_code}== 200       validate error model    ${result.content}

Landinfo_Landcover Get All Archived
    [Documentation]    Get all landinfo_landcover data and validate response
    [Tags]      Get     Landinfo_Landcover        get_all
    ${get_all_url}=     replace variables        ${API_URL}&type=get_all&recorder_name=all&count=${COUNT}&output_filter=${OUTPUT_FILTER}&records_type=1&x
    create session      landinfo_landcover_getall     ${get_all_url}
    ${result}=  Get Request     landinfo_landcover_getall     /get
    should be valid json     ${result.content}
    ${next_cursor}=      run keyword if      ${result.status_code}== 200       validate success cursor type    ${result.content}
    :FOR    ${i}    IN RANGE    9999999
    \       Exit For Loop If    ${next_cursor} is None
    \       Exit For Loop If    ${next_cursor}==0
    \       ${next_cursor}=    call api with cursor        ${get_all_url}       ${next_cursor}
    run keyword unless      ${result.status_code}== 200       validate error model    ${result.content}

Landinfo_Landcover Get All Both
    [Documentation]    Get all landinfo_landcover data and validate response
    [Tags]      Get     Landinfo        get_all
    ${get_all_url}=     replace variables        ${API_URL}&type=get_all&recorder_name=all&count=${COUNT}&records_type=2&output_filter=${OUTPUT_FILTER}&x
    create session      landinfo_landcover_getall     ${get_all_url}
    ${result}=  Get Request     landinfo_landcover_getall     /get
    should be valid json     ${result.content}
    ${next_cursor}=      run keyword if      ${result.status_code}== 200       validate success cursor type    ${result.content}
    :FOR    ${i}    IN RANGE    9999999
    \       Exit For Loop If    ${next_cursor} is None
    \       Exit For Loop If    ${next_cursor}==0
    \       ${next_cursor}=    call api with cursor        ${get_all_url}       ${next_cursor}
    run keyword unless      ${result.status_code}== 200       validate error model    ${result.content}

Landinfo_Landcover Get By Recorder Name Default
    [Documentation]    Get landinfo_landcover data by recorder_name and validate response
    [Tags]      Get     Landinfo_Landcover        get_by_recorder_name
    ${get_recorder_name_url}=     replace variables        ${API_URL}&type=get_by_recorder_name&recorder_name=${RECORDER_NAME}&count=${COUNT}&output_filter=${OUTPUT_FILTER}&x
    create session      landinfo_landcover_getrecorder_name     ${get_recorder_name_url}
    ${result}=  Get Request     landinfo_landcover_getrecorder_name     /get
    should be valid json     ${result.content}
    ${next_cursor}=      run keyword if      ${result.status_code}== 200       validate success cursor type    ${result.content}
    :FOR    ${i}    IN RANGE    9999999
    \       Exit For Loop If    ${next_cursor} is None
    \       Exit For Loop If    ${next_cursor}==0
    \       ${next_cursor}=    call api with cursor        ${get_recorder_name_url}       ${next_cursor}
    run keyword unless      ${result.status_code}== 200       validate error model    ${result.content}

Landinfo_Landcover Get By Recorder Name Archived
    [Documentation]    Get landinfo_landcover data by recorder_name and validate response
    [Tags]      Get     Landinfo_Landcover        get_by_recorder_name
    ${get_recorder_name_url}=     replace variables        ${API_URL}&type=get_by_recorder_name&recorder_name=${RECORDER_NAME}&count=${COUNT}&output_filter=${OUTPUT_FILTER}&x
    create session      landinfo_landcover_getrecorder_name     ${get_recorder_name_url}
    ${result}=  Get Request     landinfo_landcover_getrecorder_name     /get
    should be valid json     ${result.content}
    ${next_cursor}=      run keyword if      ${result.status_code}== 200       validate success cursor type    ${result.content}
    :FOR    ${i}    IN RANGE    9999999
    \       Exit For Loop If    ${next_cursor} is None
    \       Exit For Loop If    ${next_cursor}==0
    \       ${next_cursor}=    call api with cursor        ${get_recorder_name_url}       ${next_cursor}
    run keyword unless      ${result.status_code}== 200       validate error model    ${result.content}

Landinfo_Landcover Get By Recorder Name Both
    [Documentation]    Get landinfo_landcover data by recorder_name and validate response
    [Tags]      Get     Landinfo        get_by_recorder_name
    ${get_recorder_name_url}=     replace variables        ${API_URL}&type=get_by_recorder_name&recorder_name=${RECORDER_NAME}&count=${COUNT}&output_filter=${OUTPUT_FILTER}&x
    create session      landinfo_landcover_getrecorder_name     ${get_recorder_name_url}
    ${result}=  Get Request     landinfo_landcover_getrecorder_name     /get
    should be valid json     ${result.content}
    ${next_cursor}=      run keyword if      ${result.status_code}== 200       validate success cursor type    ${result.content}
    :FOR    ${i}    IN RANGE    9999999
    \       Exit For Loop If    ${next_cursor} is None
    \       Exit For Loop If    ${next_cursor}==0
    \       ${next_cursor}=    call api with cursor        ${get_recorder_name_url}       ${next_cursor}
    run keyword unless      ${result.status_code}== 200       validate error model    ${result.content}



*** Keywords ***
Call API With Cursor
    [Arguments]     ${url}      ${cursor}
    create session      landinfo_landcover_get     ${url}&cursor=${cursor}&x
    ${result}=  Get Request     landinfo_landcover_get     /get
    should be valid json     ${result.content}
    ${next_cursor}=      run keyword if      ${result.status_code}== 200       validate success cursor type    ${result.content}
    run keyword unless      ${result.status_code}== 200       validate error model    ${result.content}
    [Return]        ${next_cursor}



Validate Success Cursor Type
    [Arguments]     ${result}
    ${result_json}=     to json     ${result}
    ${search_metadata}=     get cursor metadata     ${result_json}
    validate cursor model       ${search_metadata}
    ${has_next} =   get cursor has next       ${search_metadata}

    ${data}=     Get Data     ${result_json}
    validate data length    ${data}     ${has_next}
    validate landinfo_landcover data model    ${data}
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


Validate Landinfo_Landcover Data Model
    [Arguments]     ${data}
    ${original_landinfo_landcover_keys}=       split string    ${LANDINFO_LANDCOVER_KEY_LIST}     ,
    @{data_list}=       convert to list     ${data}
    :FOR        ${landinfo_landcover_object}       IN      @{data_list}
    \       ${landinfo__landcover_data_keys}=        get dictionary keys        ${landinfo_landcover_object}
    \       Lists Should Be Equal   ${landinfo__landcover_data_keys}     ${original_landinfo_landcover_keys}





