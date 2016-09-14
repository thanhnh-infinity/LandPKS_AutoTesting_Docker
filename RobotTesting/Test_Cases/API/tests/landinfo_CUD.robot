*** Settings ***
Library           Selenium2Library
Library           RequestsLibrary
Library           Collections
Library           String
Library           OperatingSystem
Library           HttpLibrary.HTTP
Library           DateTime
Library           OperatingSystem
Library			  customlibrary.py
Resource		  Globals.robot

*** Variables ***
${API_URL_PUT}     ${API_BASE_URL}&action=put&object=landinfo&x
${API_URL_GET}		${API_BASE_URL}&action=get&object=landinfo
${API_URL_DELETE}		${API_BASE_URL}&action=delete&object=landinfo
${API_URL_RESTORE}		${API_BASE_URL}&action=restore&object=landinfo
${API_URL_UPDATE}		${API_BASE_URL}&action=update&object=landinfo&x
${ID}		0
${recorder_name}		lpks.test@gmail.com
${recorder_name_fake}		lpks@gmail.com
${name}		lpks.test@gmail.com-test_1ax12wrss66
${test_plot}		true
${organization}		nmsu
${latitude}		22.14454
${longitude}		35.14454
${city}				las cruces
${modified_date}		2016-01-01
${land_cover}		grassland
${grazed}		true
${grazing}		livestock,goat
${slope}		0-2%
${slope_shape}		linear,convex
${bedrock_depth}		10


${rock_fragment_for_soil_horizon_1}		0-15%
${rock_fragment_for_soil_horizon_2}		0-15%
${rock_fragment_for_soil_horizon_3}		0-15%
${rock_fragment_for_soil_horizon_4}		0-15%
${rock_fragment_for_soil_horizon_5}		0-15%
${rock_fragment_for_soil_horizon_6}		0-15%
${rock_fragment_for_soil_horizon_7}		0-15%

${texture_for_soil_horizon_1}		sandy loam
${texture_for_soil_horizon_2}		sandy loam
${texture_for_soil_horizon_3}		sandy loam
${texture_for_soil_horizon_4}		sandy loam
${texture_for_soil_horizon_5}		sandy loam
${texture_for_soil_horizon_6}		sandy loam
${texture_for_soil_horizon_7}		sandy loam

${surface_salt}			false
${surface_cracking}			false

${soil_pit_photo_url}		http://test_soil_pit_photo_url
${soil_samples_photo_url}		http://test_soil_samples_photo_url
${landscape_north_photo_url}		http://test_landscape_north_photo_url
${landscape_east_photo_url}		http://test_landscape_east_photo_url
${landscape_south_photo_url}		http://test_landscape_south_photo_url
${landscape_west_photo_url}		http://test_landscape_west_photo_url


*** Test Cases ***
Landinfo PUT
	[Tags]		Landinfo	Put
	${secrets}=			get file		client.json
	${access_token}=		get google token		${secrets}
	new landinfo put	${access_token}
    create session      landinfo_put2     ${API_URL_PUT}
	&{headers}=  Create Dictionary  X-Auth-Token=${access_token}
	&{params}=   Create Dictionary   recorder_name=${recorder_name_fake}      name=${name}        test_plot=${test_plot}      organization=${organization}        latitude=${latitude}        longitude=${longitude}      city=${city}        modified_date=${modified_date}      land_cover=${land_cover}      grazed=${grazed}        grazing=${grazing}      slope=${slope}      slope_shape=${slope_shape}      bedrock_depth=${bedrock_depth}      rock_fragment_for_soil_horizon_1=${rock_fragment_for_soil_horizon_1}        rock_fragment_for_soil_horizon_2=${rock_fragment_for_soil_horizon_2}        rock_fragment_for_soil_horizon_3=${rock_fragment_for_soil_horizon_3}        rock_fragment_for_soil_horizon_4=${rock_fragment_for_soil_horizon_4}        rock_fragment_for_soil_horizon_5=${rock_fragment_for_soil_horizon_5}        rock_fragment_for_soil_horizon_6=${rock_fragment_for_soil_horizon_6}        rock_fragment_for_soil_horizon_7=${rock_fragment_for_soil_horizon_7}        texture_for_soil_horizon_1=${texture_for_soil_horizon_1}        texture_for_soil_horizon_2=${texture_for_soil_horizon_2}        texture_for_soil_horizon_3=${texture_for_soil_horizon_3}        texture_for_soil_horizon_4=${texture_for_soil_horizon_4}        texture_for_soil_horizon_5=${texture_for_soil_horizon_5}        texture_for_soil_horizon_6=${texture_for_soil_horizon_6}        texture_for_soil_horizon_7=${texture_for_soil_horizon_7}        surface_salt=${surface_salt}        surface_cracking=${surface_cracking}        soil_pit_photo_url=${soil_pit_photo_url}        soil_samples_photo_url=${soil_samples_photo_url}        landscape_north_photo_url=${landscape_north_photo_url}      landscape_east_photo_url=${landscape_east_photo_url}        landscape_south_photo_url=${landscape_south_photo_url}      landscape_west_photo_url=${landscape_west_photo_url}

    ${result}=		put Request     landinfo_put2     /put		params=${params}	headers=${headers}
    should be valid json     ${result.content}
    should be true     ${result.status_code}<> 200
    should be true     ${result.status_code}<> 500

Landinfo Update
	[Tags]		Landinfo	Update
	change variables for update
	${secrets}=			get file		client.json
	${access_token}=		get google token		${secrets}
	create session      landinfo_update     ${API_URL_UPDATE}
	&{headers}=  Create Dictionary  X-Auth-Token=${access_token}
	&{params}=   Create Dictionary   recorder_name=${recorder_name}      name=${name}        test_plot=${test_plot}      organization=${organization}        latitude=${latitude}        longitude=${longitude}      city=${city}        modified_date=${modified_date}      land_cover=${land_cover}      grazed=${grazed}        grazing=${grazing}      slope=${slope}      slope_shape=${slope_shape}      bedrock_depth=${bedrock_depth}      rock_fragment_for_soil_horizon_1=${rock_fragment_for_soil_horizon_1}        rock_fragment_for_soil_horizon_2=${rock_fragment_for_soil_horizon_2}        rock_fragment_for_soil_horizon_3=${rock_fragment_for_soil_horizon_3}        rock_fragment_for_soil_horizon_4=${rock_fragment_for_soil_horizon_4}        rock_fragment_for_soil_horizon_5=${rock_fragment_for_soil_horizon_5}        rock_fragment_for_soil_horizon_6=${rock_fragment_for_soil_horizon_6}        rock_fragment_for_soil_horizon_7=${rock_fragment_for_soil_horizon_7}        texture_for_soil_horizon_1=${texture_for_soil_horizon_1}        texture_for_soil_horizon_2=${texture_for_soil_horizon_2}        texture_for_soil_horizon_3=${texture_for_soil_horizon_3}        texture_for_soil_horizon_4=${texture_for_soil_horizon_4}        texture_for_soil_horizon_5=${texture_for_soil_horizon_5}        texture_for_soil_horizon_6=${texture_for_soil_horizon_6}        texture_for_soil_horizon_7=${texture_for_soil_horizon_7}        surface_salt=${surface_salt}        surface_cracking=${surface_cracking}        soil_pit_photo_url=${soil_pit_photo_url}        soil_samples_photo_url=${soil_samples_photo_url}        landscape_north_photo_url=${landscape_north_photo_url}      landscape_east_photo_url=${landscape_east_photo_url}        landscape_south_photo_url=${landscape_south_photo_url}      landscape_west_photo_url=${landscape_west_photo_url}

    ${result}=		put Request     landinfo_update     /put		params=${params}	headers=${headers}
    should be valid json     ${result.content}
    run keyword if      ${result.status_code}== 200			validate put result through get
    run keyword if      ${result.status_code}== 500			validate put result through get

Landinfo Archive By ID
	[Tags]		Landinfo	Archive
	${secrets}=			get file		client.json
	${access_token}=		get google token		${secrets}
	create session      landinfo_archive     ${API_URL_DELETE}&type=delete_by_id&x
	&{headers}=  Create Dictionary  X-Auth-Token=${access_token}
	&{params}=   Create Dictionary		id=${ID}		delete_permanent=0
	${result}=		delete Request     landinfo_archive     /delete		params=${params}	headers=${headers}
    should be valid json     ${result.content}
	run keyword if      ${result.status_code}== 200			validate archived by id

Landinfo Restore By ID
	[Tags]		Landinfo	Restore
	${secrets}=			get file		client.json
	${access_token}=		get google token		${secrets}
	create session      landinfo_restore     ${API_URL_RESTORE}&type=restore_by_id&x
	&{headers}=  Create Dictionary  X-Auth-Token=${access_token}
	&{params}=   Create Dictionary		id=${ID}
	${result}=		put Request     landinfo_restore     /put		params=${params}	headers=${headers}
    should be valid json     ${result.content}
	run keyword if      ${result.status_code}== 200			validate restored by id

Landinfo Archive By Name RecorderName
	[Tags]		Landinfo	Archive
	${secrets}=			get file		client.json
	${access_token}=		get google token		${secrets}
	create session      landinfo_archive     ${API_URL_DELETE}&type=delete_by_name_recorder_name&x
	&{headers}=  Create Dictionary  X-Auth-Token=${access_token}
	&{params}=   Create Dictionary		name=${name}		recorder_name=${recorder_name}		delete_permanent=0
	${result}=		delete Request     landinfo_archive     /delete		params=${params}	headers=${headers}
    should be valid json     ${result.content}
	run keyword if      ${result.status_code}== 200			validate archived by name recorder name

Landinfo Restore By Name RecorderName
	[Tags]		Landinfo	Restore
	${secrets}=			get file		client.json
	${access_token}=		get google token		${secrets}
	create session      landinfo_restore     ${API_URL_RESTORE}&type=restore_by_name_recorder_name&x
	&{headers}=  Create Dictionary  X-Auth-Token=${access_token}
	&{params}=   Create Dictionary		name=${name}		recorder_name=${recorder_name}
	${result}=		put Request     landinfo_restore     /put		params=${params}	headers=${headers}
    should be valid json     ${result.content}
	run keyword if      ${result.status_code}== 200			validate restored by name recorder name

Landinfo Delete Permanent By ID
	[Tags]		Landinfo	Delete Permanent
	${secrets}=			get file		client.json
	${access_token}=		get google token		${secrets}
	create session      landinfo_delete     ${API_URL_DELETE}&type=delete_by_id&x
	&{headers}=  Create Dictionary  X-Auth-Token=${access_token}
	&{params}=   Create Dictionary		id=${ID}		delete_permanent=1
	${result}=		delete Request     landinfo_delete     /delete		params=${params}	headers=${headers}
    should be valid json     ${result.content}
	run keyword if      ${result.status_code}== 200			validate delete permanent by id

Landinfo Delete Permanent By Name RecorderName
	[Tags]		Landinfo	Delete Permanent
	${secrets}=			get file		client.json
	${access_token}=		get google token		${secrets}
	new landinfo put		${access_token}
	create session      landinfo_delete     ${API_URL_DELETE}&type=delete_by_name_recorder_name&x
	&{headers}=  Create Dictionary  X-Auth-Token=${access_token}
	&{params}=   Create Dictionary		name=${name}		recorder_name=${recorder_name}		delete_permanent=1
	${result}=		delete Request     landinfo_delete     /delete		params=${params}	headers=${headers}
    should be valid json     ${result.content}
	run keyword if      ${result.status_code}== 200			validate delete permanent by name recorder name
	new landinfo put		${access_token} #for landcover testing

*** Keywords ***
New Landinfo Put
	[Arguments]		${access_token}
	create session      landinfo_put     ${API_URL_PUT}
	&{headers}=  Create Dictionary  X-Auth-Token=${access_token}
	&{params}=   Create Dictionary   recorder_name=${recorder_name}      name=${name}        test_plot=${test_plot}      organization=${organization}        latitude=${latitude}        longitude=${longitude}      city=${city}        modified_date=${modified_date}      land_cover=${land_cover}      grazed=${grazed}        grazing=${grazing}      slope=${slope}      slope_shape=${slope_shape}      bedrock_depth=${bedrock_depth}      rock_fragment_for_soil_horizon_1=${rock_fragment_for_soil_horizon_1}        rock_fragment_for_soil_horizon_2=${rock_fragment_for_soil_horizon_2}        rock_fragment_for_soil_horizon_3=${rock_fragment_for_soil_horizon_3}        rock_fragment_for_soil_horizon_4=${rock_fragment_for_soil_horizon_4}        rock_fragment_for_soil_horizon_5=${rock_fragment_for_soil_horizon_5}        rock_fragment_for_soil_horizon_6=${rock_fragment_for_soil_horizon_6}        rock_fragment_for_soil_horizon_7=${rock_fragment_for_soil_horizon_7}        texture_for_soil_horizon_1=${texture_for_soil_horizon_1}        texture_for_soil_horizon_2=${texture_for_soil_horizon_2}        texture_for_soil_horizon_3=${texture_for_soil_horizon_3}        texture_for_soil_horizon_4=${texture_for_soil_horizon_4}        texture_for_soil_horizon_5=${texture_for_soil_horizon_5}        texture_for_soil_horizon_6=${texture_for_soil_horizon_6}        texture_for_soil_horizon_7=${texture_for_soil_horizon_7}        surface_salt=${surface_salt}        surface_cracking=${surface_cracking}        soil_pit_photo_url=${soil_pit_photo_url}        soil_samples_photo_url=${soil_samples_photo_url}        landscape_north_photo_url=${landscape_north_photo_url}      landscape_east_photo_url=${landscape_east_photo_url}        landscape_south_photo_url=${landscape_south_photo_url}      landscape_west_photo_url=${landscape_west_photo_url}

    ${result}=		put Request     landinfo_put     /put		params=${params}	headers=${headers}
    should be valid json     ${result.content}
    run keyword if      ${result.status_code}== 200			validate put result through get
    run keyword if      ${result.status_code}== 500			validate put result through get

Validate Put Result Through Get
	${get_url}=     replace variables        ${API_URL_GET}&type=get_by_pair_name_recorder_name&name=${name}&recorder_name=${recorder_name}&records_type=0&x
    create session      landinfo_get     ${get_url}
    ${result}=  Get Request     landinfo_get     /get
    should be valid json     ${result.content}
    run keyword if      ${result.status_code}== 200       validate content    ${result.content}

Validate Archived By ID
	${get_url}=     replace variables        ${API_URL_GET}&type=get_by_id&id=${ID}&records_type=0&x
    create session      landinfo_get     ${get_url}
    ${result}=  Get Request     landinfo_get     /get

    should be valid json     ${result.content}
    ${json}=		to json		${result.content}
    ${length}=		get length  	${json}
    should be true      ${length}==0

Validate Archived By Name Recorder Name
	${get_url}=     replace variables        ${API_URL_GET}&type=get_by_pair_name_recorder_name&name=${name}&recorder_name=${recorder_name}&records_type=0&x
    create session      landinfo_get     ${get_url}
    ${result}=  Get Request     landinfo_get     /get

    should be valid json     ${result.content}
    ${json}=		to json		${result.content}
    ${length}=		get length  	${json}
    should be true      ${length}==0

Validate Restored By ID
	${get_url}=     replace variables        ${API_URL_GET}&type=get_by_id&id=${ID}&records_type=0&x
    create session      landinfo_get     ${get_url}
    ${result}=  Get Request     landinfo_get     /get

    should be valid json     ${result.content}
    ${json}=		to json		${result.content}
    ${length}=		get length  	${json}
    should be true      ${length}>=0

Validate Restored By Name Recorder Name
	${get_url}=     replace variables        ${API_URL_GET}&type=get_by_pair_name_recorder_name&name=${name}&recorder_name=${recorder_name}&records_type=0&x
    create session      landinfo_get     ${get_url}
    ${result}=  Get Request     landinfo_get     /get

    should be valid json     ${result.content}
    ${json}=		to json		${result.content}
    ${length}=		get length  	${json}
    should be true      ${length}>=0

Validate Delete Permanent By Id
	${get_url}=     replace variables        ${API_URL_GET}&type=get_by_id&id=${ID}&records_type=2&x
    create session      landinfo_get     ${get_url}
    ${result}=  Get Request     landinfo_get     /get

    should be valid json     ${result.content}
    ${json}=		to json		${result.content}
    ${length}=		get length  	${json}
    should be true      ${length}==0

Validate Delete Permanent By Name Recorder Name
	${get_url}=     replace variables        ${API_URL_GET}&type=get_by_pair_name_recorder_name&name=${name}&recorder_name=${recorder_name}&records_type=2&x
    create session      landinfo_get     ${get_url}
    ${result}=  Get Request     landinfo_get     /get

    should be valid json     ${result.content}
    ${json}=		to json		${result.content}
    ${length}=		get length  	${json}
    should be true      ${length}==0

Validate Content
	[Arguments]		${content}
	${content_json}		to json		${content}
	${length}=		get length		${content_json}
	should be true      ${length}==1
	${id}=		get from dictionary				${content_json[0]}        id
	set global variable		${ID}		${id}
	${get_recorder_name}=     get from dictionary     ${content_json[0]}        recorder_name
	${get_name}=     get from dictionary     ${content_json[0]}        name
	${get_test_plot}=     get from dictionary     ${content_json[0]}        test_plot
	${get_organization}=     get from dictionary     ${content_json[0]}        organization
	${get_latitude}=     get from dictionary     ${content_json[0]}        latitude
	${get_longitude}=     get from dictionary     ${content_json[0]}        longitude
	${get_city}=     get from dictionary     ${content_json[0]}        city
	${get_land_cover}=     get from dictionary     ${content_json[0]}        land_cover
	${get_grazed}=     get from dictionary     ${content_json[0]}        grazed
	${get_grazing}=     get from dictionary     ${content_json[0]}        grazing
	${get_slope}=     get from dictionary     ${content_json[0]}        slope
	${get_slope_shape}=     get from dictionary     ${content_json[0]}        slope_shape
	${get_bedrock_depth}=     get from dictionary     ${content_json[0]}        bedrock_depth
	${get_rock_fragment_for_soil_horizon_1}=     get from dictionary     ${content_json[0]['rock_fragment']}        soil_horizon_1
	${get_rock_fragment_for_soil_horizon_2}=     get from dictionary     ${content_json[0]['rock_fragment']}        soil_horizon_2
	${get_rock_fragment_for_soil_horizon_3}=     get from dictionary     ${content_json[0]['rock_fragment']}        soil_horizon_3
	${get_rock_fragment_for_soil_horizon_4}=     get from dictionary     ${content_json[0]['rock_fragment']}        soil_horizon_4
	${get_rock_fragment_for_soil_horizon_5}=     get from dictionary     ${content_json[0]['rock_fragment']}        soil_horizon_5
	${get_rock_fragment_for_soil_horizon_6}=     get from dictionary     ${content_json[0]['rock_fragment']}        soil_horizon_6
	${get_rock_fragment_for_soil_horizon_7}=     get from dictionary     ${content_json[0]['rock_fragment']}        soil_horizon_7
	${get_texture_for_soil_horizon_1}=     get from dictionary     ${content_json[0]['texture']}        soil_horizon_1
	${get_texture_for_soil_horizon_2}=     get from dictionary     ${content_json[0]['texture']}        soil_horizon_2
	${get_texture_for_soil_horizon_3}=     get from dictionary     ${content_json[0]['texture']}        soil_horizon_3
	${get_texture_for_soil_horizon_4}=     get from dictionary     ${content_json[0]['texture']}        soil_horizon_4
	${get_texture_for_soil_horizon_5}=     get from dictionary     ${content_json[0]['texture']}        soil_horizon_5
	${get_texture_for_soil_horizon_6}=     get from dictionary     ${content_json[0]['texture']}        soil_horizon_6
	${get_texture_for_soil_horizon_7}=     get from dictionary     ${content_json[0]['texture']}        soil_horizon_7
	${get_surface_salt}=     get from dictionary     ${content_json[0]}        surface_salt
	${get_surface_cracking}=     get from dictionary     ${content_json[0]}        surface_cracking
	${get_soil_pit_photo_url}=     get from dictionary     ${content_json[0]}        soil_pit_photo_url
	${get_soil_samples_photo_url}=     get from dictionary     ${content_json[0]}        soil_samples_photo_url
	${get_landscape_north_photo_url}=     get from dictionary     ${content_json[0]}        landscape_north_photo_url
	${get_landscape_east_photo_url}=     get from dictionary     ${content_json[0]}        landscape_east_photo_url
	${get_landscape_south_photo_url}=     get from dictionary     ${content_json[0]}        landscape_south_photo_url
	${get_landscape_west_photo_url}=     get from dictionary     ${content_json[0]}        landscape_west_photo_url

	${get_recorder_name}=       convert to lowercase        ${get_recorder_name}
	${get_name}=        convert to lowercase        ${get_name}
	${get_test_plot}=       convert to lowercase        ${get_test_plot}
	${get_organization}=        convert to lowercase        ${get_organization}
	${get_city}=        convert to lowercase        ${get_city}
	${get_land_cover}=       convert to lowercase        ${get_land_cover}
	${get_grazed}=      convert to lowercase        ${get_grazed}
	${get_grazing}=     convert to lowercase        ${get_grazing}
	${get_slope}=       convert to lowercase        ${get_slope}
	${get_slope_shape}=     convert to lowercase        ${get_slope_shape}
	${get_rock_fragment_for_soil_horizon_1}=        convert to lowercase        ${get_rock_fragment_for_soil_horizon_1}
	${get_rock_fragment_for_soil_horizon_2}=        convert to lowercase        ${get_rock_fragment_for_soil_horizon_2}
	${get_rock_fragment_for_soil_horizon_3}=        convert to lowercase        ${get_rock_fragment_for_soil_horizon_3}
	${get_rock_fragment_for_soil_horizon_4}=        convert to lowercase        ${get_rock_fragment_for_soil_horizon_4}
	${get_rock_fragment_for_soil_horizon_5}=        convert to lowercase        ${get_rock_fragment_for_soil_horizon_5}
	${get_rock_fragment_for_soil_horizon_6}=        convert to lowercase        ${get_rock_fragment_for_soil_horizon_6}
	${get_rock_fragment_for_soil_horizon_7}=        convert to lowercase        ${get_rock_fragment_for_soil_horizon_7}
	${get_texture_for_soil_horizon_1}=      convert to lowercase        ${get_texture_for_soil_horizon_1}
	${get_texture_for_soil_horizon_2}=      convert to lowercase        ${get_texture_for_soil_horizon_2}
	${get_texture_for_soil_horizon_3}=      convert to lowercase        ${get_texture_for_soil_horizon_3}
	${get_texture_for_soil_horizon_4}=      convert to lowercase        ${get_texture_for_soil_horizon_4}
	${get_texture_for_soil_horizon_5}=      convert to lowercase        ${get_texture_for_soil_horizon_5}
	${get_texture_for_soil_horizon_6}=      convert to lowercase        ${get_texture_for_soil_horizon_6}
	${get_texture_for_soil_horizon_7}=      convert to lowercase        ${get_texture_for_soil_horizon_7}
	${get_surface_salt}=        convert to lowercase        ${get_surface_salt}
	${get_surface_cracking}=        convert to lowercase        ${get_surface_cracking}
	${get_soil_pit_photo_url}=      convert to lowercase        ${get_soil_pit_photo_url}
	${get_soil_samples_photo_url}=      convert to lowercase        ${get_soil_samples_photo_url}
	${get_landscape_north_photo_url}=       convert to lowercase        ${get_landscape_north_photo_url}
	${get_landscape_east_photo_url}=        convert to lowercase        ${get_landscape_east_photo_url}
	${get_landscape_south_photo_url}=       convert to lowercase        ${get_landscape_south_photo_url}
	${get_landscape_west_photo_url}=        convert to lowercase        ${get_landscape_west_photo_url}

	should be equal as strings      ${get_recorder_name}        ${recorder_name}
	should be equal as strings      ${get_name}        ${name}
	should be equal as strings      ${get_test_plot}        ${test_plot}
	should be equal as strings      ${get_organization}        ${organization}
	should be equal as strings      ${get_latitude}        ${latitude}
	should be equal as strings      ${get_longitude}        ${longitude}
	should be equal as strings      ${get_city}        ${city}
	should be equal as strings      ${get_land_cover}        ${land_cover}
	should be equal as strings      ${get_grazed}        ${grazed}
	should be equal as strings      ${get_grazing}        ${grazing}
	should be equal as strings      ${get_slope}        ${slope}
	should be equal as strings      ${get_slope_shape}        ${slope_shape}
	should be equal as numbers      ${get_bedrock_depth}        ${bedrock_depth}
	should be equal as strings      ${get_rock_fragment_for_soil_horizon_1}        ${rock_fragment_for_soil_horizon_1}
	should be equal as strings      ${get_rock_fragment_for_soil_horizon_2}        ${rock_fragment_for_soil_horizon_2}
	should be equal as strings      ${get_rock_fragment_for_soil_horizon_3}        ${rock_fragment_for_soil_horizon_3}
	should be equal as strings      ${get_rock_fragment_for_soil_horizon_4}        ${rock_fragment_for_soil_horizon_4}
	should be equal as strings      ${get_rock_fragment_for_soil_horizon_5}        ${rock_fragment_for_soil_horizon_5}
	should be equal as strings      ${get_rock_fragment_for_soil_horizon_6}        ${rock_fragment_for_soil_horizon_6}
	should be equal as strings      ${get_rock_fragment_for_soil_horizon_7}        ${rock_fragment_for_soil_horizon_7}
	should be equal as strings      ${get_texture_for_soil_horizon_1}        ${texture_for_soil_horizon_1}
	should be equal as strings      ${get_texture_for_soil_horizon_2}        ${texture_for_soil_horizon_2}
	should be equal as strings      ${get_texture_for_soil_horizon_3}        ${texture_for_soil_horizon_3}
	should be equal as strings      ${get_texture_for_soil_horizon_4}        ${texture_for_soil_horizon_4}
	should be equal as strings      ${get_texture_for_soil_horizon_5}        ${texture_for_soil_horizon_5}
	should be equal as strings      ${get_texture_for_soil_horizon_6}        ${texture_for_soil_horizon_6}
	should be equal as strings      ${get_texture_for_soil_horizon_7}        ${texture_for_soil_horizon_7}
	should be equal as strings      ${get_surface_salt}        ${surface_salt}
	should be equal as strings      ${get_surface_cracking}        ${surface_cracking}
	should be equal as strings      ${get_soil_pit_photo_url}        ${soil_pit_photo_url}
	should be equal as strings      ${get_soil_samples_photo_url}        ${soil_samples_photo_url}
	should be equal as strings      ${get_landscape_north_photo_url}        ${landscape_north_photo_url}
	should be equal as strings      ${get_landscape_east_photo_url}        ${landscape_east_photo_url}
	should be equal as strings      ${get_landscape_south_photo_url}        ${landscape_south_photo_url}
	should be equal as strings      ${get_landscape_west_photo_url}        ${landscape_west_photo_url}

Change Variables For Update
	set global variable     ${organization}		nmsu-changed
	set global variable     ${latitude}		21.14454
	set global variable     ${longitude}		31.14454
	set global variable     ${city}				cruces
	set global variable     ${modified_date}		2016-04-01
	set global variable     ${land_cover}		savanna
	set global variable     ${grazed}		true
	set global variable     ${grazing}		livestock
	set global variable     ${slope}		3-5%
	set global variable     ${slope_shape}		linear
	set global variable     ${bedrock_depth}		20


	set global variable     ${rock_fragment_for_soil_horizon_1}		15-35%
	set global variable     ${rock_fragment_for_soil_horizon_2}		15-35%
	set global variable     ${rock_fragment_for_soil_horizon_3}		15-35%
	set global variable     ${rock_fragment_for_soil_horizon_4}		15-35%
	set global variable     ${rock_fragment_for_soil_horizon_5}		15-35%
	set global variable     ${rock_fragment_for_soil_horizon_6}		15-35%
	set global variable     ${rock_fragment_for_soil_horizon_7}		15-35%

	set global variable     ${texture_for_soil_horizon_1}		loam
	set global variable     ${texture_for_soil_horizon_2}		loam
	set global variable     ${texture_for_soil_horizon_3}		loam
	set global variable     ${texture_for_soil_horizon_4}		loam
	set global variable     ${texture_for_soil_horizon_5}		loam
	set global variable     ${texture_for_soil_horizon_6}		loam
	set global variable     ${texture_for_soil_horizon_7}		loam

	set global variable     ${surface_salt}			true
	set global variable     ${surface_cracking}			true

	set global variable     ${soil_pit_photo_url}		http://test_soil_pit_photo_url_changed
	set global variable     ${soil_samples_photo_url}		http://test_soil_samples_photo_url_changed
	set global variable     ${landscape_north_photo_url}		http://test_landscape_north_photo_url_changed
	set global variable     ${landscape_east_photo_url}		http://test_landscape_east_photo_url_changed
	set global variable     ${landscape_south_photo_url}		http://test_landscape_south_photo_url_changed
	set global variable     ${landscape_west_photo_url}		http://test_landscape_west_photo_url_changed