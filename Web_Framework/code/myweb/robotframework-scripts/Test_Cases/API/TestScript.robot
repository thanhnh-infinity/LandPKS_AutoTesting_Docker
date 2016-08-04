*** Settings ***
Library           Collections
Library           RequestsLibrary
Library           Selenium2Library
Library           BuiltIn
Library           String
Library           MyLibrary.py

*** Variables ***
${browser}      Firefox
${host}         http://api.landpotential.org/query?
${version}      0.1
${file}         TestSuite

*** Test Cases ***
Test_Call
    [Tags]	TestMe
	${test_case_name}=      Set Variable    Put_LandInfo_by_all_required_fields
    ${separator}=   set variable    ;
    ${line}=        read a test case from file      ${test_case_name}       ${file}

Put_LandInfo_by_all_required_fields
	[Tags]	PutAPI
	${test_case_name}=	Set Variable	Put_LandInfo_by_all_required_fields
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Put_existed_LandInfo
	[Tags]	PutAPI
	${test_case_name}=	Set Variable	Put_existed_LandInfo
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Put_LandInfo_by_unregistered_recorder_name
	[Tags]	PutAPI
	${test_case_name}=	Set Variable	Put_LandInfo_by_unregistered_recorder_name
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Put_LandInfo_by_mismatching_name_recorder_name
	[Tags]	PutAPI
	${test_case_name}=	Set Variable	Put_LandInfo_by_mismatching_name_recorder_name
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Put_LandInfo_by_missing_name
	[Tags]	PutAPI
	${test_case_name}=	Set Variable	Put_LandInfo_by_missing_name
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Put_LandInfo_by_all_fields
	[Tags]	PutAPI
	${test_case_name}=	Set Variable	Put_LandInfo_by_all_fields
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Put_another_new_LandInfo_plot
	[Tags]	PutAPI
	${test_case_name}=	Set Variable	Put_another_new_LandInfo_plot
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Get_all_records_of_LandInfo_by_all_recorder_name
	[Tags]	GetAPI
	${test_case_name}=	Set Variable	Get_all_records_of_LandInfo_by_all_recorder_name
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Get_all_records_of_LandInfo_by_all_recorder_name_delimiter_display
	[Tags]	GetAPI
	${test_case_name}=	Set Variable	Get_all_records_of_LandInfo_by_all_recorder_name_delimiter_display
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Get_single_record_of_LandInfo_by_name_recorder_name
	[Tags]	GetAPI
	${test_case_name}=	Set Variable	Get_single_record_of_LandInfo_by_name_recorder_name
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${result}=	Run a query	${query}
	Get an ID  ${query}
	Should Be Equal As Integers	${result}	${status_code}

Get_single_record_of_LandInfo_by_name_recorder_name_delimiter_display
	[Tags]	GetAPI
	${test_case_name}=	Set Variable	Get_single_record_of_LandInfo_by_name_recorder_name_delimiter_display
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Get_single_record_of_LandInfo_by_mismatching_name_recorder_name
	[Tags]	GetAPI
	${test_case_name}=	Set Variable	Get_single_record_of_LandInfo_by_mismatching_name_recorder_name
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Get_single_record_of_LandInfo_by_missing_name
	[Tags]	GetAPI
	${test_case_name}=	Set Variable	Get_single_record_of_LandInfo_by_missing_name
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Get_single/list_records_of_LandInfo_by_recorder_name
	[Tags]	GetAPI
	${test_case_name}=	Set Variable	Get_single/list_records_of_LandInfo_by_recorder_name
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Get_single/list_records_of_LandInfo_by_recorder_name_delimiter_display
	[Tags]	GetAPI
	${test_case_name}=	Set Variable	Get_single/list_records_of_LandInfo_by_recorder_name_delimiter_display
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Get_single/list_records_of_LandInfo_by_unregistered_recorder_name
	[Tags]	GetAPI
	${test_case_name}=	Set Variable	Get_single/list_records_of_LandInfo_by_unregistered_recorder_name
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Get_single/list_records_of_LandInfo_by_region_recorder_name
	[Tags]	GetAPI
	${test_case_name}=	Set Variable	Get_single/list_records_of_LandInfo_by_region_recorder_name
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Get_single/list_records_of_LandInfo_by_region_recorder_name_delimiter_display
	[Tags]	GetAPI
	${test_case_name}=	Set Variable	Get_single/list_records_of_LandInfo_by_region_recorder_name_delimiter_display
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Get_single/list_records_of_LandInfo_by_LandInfo_Plot_ID
	[Tags]	GetAPI
	${test_case_name}=	Set Variable	Get_single/list_records_of_LandInfo_by_LandInfo_Plot_ID
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${query}=   ioint an ID to a query  ${query}    ${ID}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Get_single/list_records_of_LandInfo_by_LandInfo_Plot_ID_delimiter_display
	[Tags]	GetAPI
	${test_case_name}=	Set Variable	Get_single/list_records_of_LandInfo_by_LandInfo_Plot_ID_delimiter_display
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${query}=   ioint an ID to a query  ${query}    ${ID}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Get_single/list_records_of_LandInfo_by_LandInfo_nonexistent_Plot_ID
	[Tags]	GetAPI
	${test_case_name}=	Set Variable	Get_single/list_records_of_LandInfo_by_LandInfo_nonexistent_Plot_ID
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${query}=   ioint an ID to a query  ${query}    123454321
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Get_single/list_records_of_LandInfo_by_from_afterDate_to_now
	[Tags]	GetAPI
	${test_case_name}=	Set Variable	Get_single/list_records_of_LandInfo_by_from_afterDate_to_now
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Get_single/list_records_of_LandInfo_by_from_afterDate_to_now_delimiter_display
	[Tags]	GetAPI
	${test_case_name}=	Set Variable	Get_single/list_records_of_LandInfo_by_from_afterDate_to_now_delimiter_display
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Get_single/list_records_of_LandInfo_by_from_time_0_to_beforeDate
	[Tags]	GetAPI
	${test_case_name}=	Set Variable	Get_single/list_records_of_LandInfo_by_from_time_0_to_beforeDate
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Get_single/list_records_of_LandInfo_by_from_time_0_to_beforeDate_delimiter_display
	[Tags]	GetAPI
	${test_case_name}=	Set Variable	Get_single/list_records_of_LandInfo_by_from_time_0_to_beforeDate_delimiter_display
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Get_single/list_records_of_LandInfo_by_beforedate_afterdate
	[Tags]	GetAPI
	${test_case_name}=	Set Variable	Get_single/list_records_of_LandInfo_by_beforedate_afterdate
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Get_single/list_records_of_LandInfo_by_beforedate_afterdate_delimiter_display
	[Tags]	GetAPI
	${test_case_name}=	Set Variable	Get_single/list_records_of_LandInfo_by_beforedate_afterdate_delimiter_display
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Update_landinfo
	[Tags]	UpdateAPI
	${test_case_name}=	Set Variable	Update_landinfo
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Update_landinfo_my_mismatching_name_recorder_name
	[Tags]	UpdateAPI
	${test_case_name}=	Set Variable	Update_landinfo_my_mismatching_name_recorder_name
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Update_landinfo_missing_name
	[Tags]	UpdateAPI
	${test_case_name}=	Set Variable	Update_landinfo_missing_name
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Update_landinfo_random_recorder_name
	[Tags]	UpdateAPI
	${test_case_name}=	Set Variable	Update_landinfo_random_recorder_name
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Put_LandCover_by_all_required_fields
	[Tags]	PutAPI
	${test_case_name}=	Set Variable	Put_LandCover_by_all_required_fields
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Put_LandCover_by_unregistered_recorder_name
	[Tags]	PutAPI
	${test_case_name}=	Set Variable	Put_LandCover_by_unregistered_recorder_name
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Put_LandCover_by_mismatching_name_recorder_name
	[Tags]	PutAPI
	${test_case_name}=	Set Variable	Put_LandCover_by_mismatching_name_recorder_name
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Put_LandCover_by_missing_name
	[Tags]	PutAPI
	${test_case_name}=	Set Variable	Put_LandCover_by_missing_name
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Put_LandCover_by_all_fields
	[Tags]	PutAPI
	${test_case_name}=	Set Variable	Put_LandCover_by_all_fields
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
        ${query}=   ioint an ID to a query  ${query}    ${ID}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Put_LandCover_by_all_fields_and_nonexistent_Plot_ID
	[Tags]	PutAPI
	${test_case_name}=	Set Variable	Put_LandCover_by_all_fields_and_nonexistent_Plot_ID
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${query}=   ioint an ID to a query  ${query}    123454320
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Get_all_records_of_landcover_by_recorder_name
	[Tags]	GetAPI
	${test_case_name}=	Set Variable	Get_all_records_of_landcover_by_recorder_name
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Get_single_record_of_landcover_by_name_recorder_name
	[Tags]	GetAPI
	${test_case_name}=	Set Variable	Get_single_record_of_landcover_by_name_recorder_name
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Get_single_record_of_landcover_by_mismatching_name_recorder_name
	[Tags]	GetAPI
	${test_case_name}=	Set Variable	Get_single_record_of_landcover_by_mismatching_name_recorder_name
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Get_single_record_of_landcover_by_missing_name
	[Tags]	GetAPI
	${test_case_name}=	Set Variable	Get_single_record_of_landcover_by_missing_name
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Get_single/list_records_of_landcover_by_recorder_name
	[Tags]	GetAPI
	${test_case_name}=	Set Variable	Get_single/list_records_of_landcover_by_recorder_name
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Get_single/list_records_of_landcover_by_unregistered_recorder_name
	[Tags]	GetAPI
	${test_case_name}=	Set Variable	Get_single/list_records_of_landcover_by_unregistered_recorder_name
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Get_single/list_records_of_landcover_by_from_afterDate_to_now
	[Tags]	GetAPI
	${test_case_name}=	Set Variable	Get_single/list_records_of_landcover_by_from_afterDate_to_now
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Get_single/list_records_of_landcover_by_from_time_0_to_beforeDate
	[Tags]	GetAPI
	${test_case_name}=	Set Variable	Get_single/list_records_of_landcover_by_from_time_0_to_beforeDate
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Get_single/list_records_of_landcover_by_beforedate_afterdate
	[Tags]	GetAPI
	${test_case_name}=	Set Variable	Get_single/list_records_of_landcover_by_beforedate_afterdate
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Get_a_collection_of_climate_by_latitude_longitude
	[Tags]	GetAPI
	${test_case_name}=	Set Variable	Get_a_collection_of_climate_by_latitude_longitude
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Get_a_collection_of_climate_by_latitude_longitude_data_source_world_clim
	[Tags]	GetAPI
	${test_case_name}=	Set Variable	Get_a_collection_of_climate_by_latitude_longitude_data_source_world_clim
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Get_a_collection_of_climate_by_latitude_longitude_data_source_AgMerra
	[Tags]	GetAPI
	${test_case_name}=	Set Variable	Get_a_collection_of_climate_by_latitude_longitude_data_source_AgMerra
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Get_a_collection_of_local_climate_by_latitude_longitude
	[Tags]	LocalClimateAPI
	${test_case_name}=	Set Variable	Get_a_collection_of_local_climate_by_latitude_longitude
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Get_a_collection_of_local_climate_by_latitude_longitude_data_source_world_clim
	[Tags]	LocalClimateAPI
	${test_case_name}=	Set Variable	Get_a_collection_of_local_climate_by_latitude_longitude_data_source_world_clim
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Get_a_collection_of_local_climate_by_latitude_longitude_data_source_AgMerra
	[Tags]	LocalClimateAPI
	${test_case_name}=	Set Variable	Get_a_collection_of_local_climate_by_latitude_longitude_data_source_AgMerra
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Delete_LandCover_by_ID
	[Tags]	DeleteAPI
	${test_case_name}=	Set Variable	Delete_LandCover_by_ID
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${query}=   ioint an ID to a query  ${query}    ${ID}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Delete_LandCover_by_name_recorder_name
	[Tags]	DeleteAPI
	${test_case_name}=	Set Variable	Delete_LandCover_by_name_recorder_name
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Delete_LandInfo_by_ID
	[Tags]	DeleteAPI
	${test_case_name}=	Set Variable	Delete_LandInfo_by_ID
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${query}=   ioint an ID to a query  ${query}    ${ID}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Delete_LandInfo_by_unregistered_recorder_name
	[Tags]	DeleteAPI
	${test_case_name}=	Set Variable	Delete_LandInfo_by_unregistered_recorder_name
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Delete_LandInfo_by_name_recorder_name
	[Tags]	DeleteAPI
	${test_case_name}=	Set Variable	Delete_LandInfo_by_name_recorder_name
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

Delete_LandInfo_inserted_by_all_Fields
	[Tags]	DeleteAPI
	${test_case_name}=	Set Variable	Delete_LandInfo_inserted_by_all_Fields
	${separator}=	set variable	;
	${line}=	read a test case from file	${test_case_name}	${file}
	${query}=	Fetch From Left	${line}	${separator}
	${status_code}=	Fetch From Right	${line}	${separator}
	${result}=	Run a query	${query}
	Should Be Equal As Integers	${result}	${status_code}

*** Keywords ***
Run a query
	[Arguments]	${query}
	${url}=	Catenate	SEPARATOR=	${host}	version=	${version}	${query}
	${result}=	initiate a request	${url}
	[return]	${result}

Get an ID
	[Arguments]	${query}
	${url}=	Catenate	SEPARATOR=	${host}	version=	${version}	${query}
	${ID}=	Search for an ID	${url}
	Set Suite Variable	${ID}
