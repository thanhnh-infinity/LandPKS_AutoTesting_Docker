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
${file}         TmpCases


*** Test Cases ***
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
