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
Resource			 Globals.robot

*** Variables ***
${LANDCOVER_API_URL_PUT}     ${API_BASE_URL}&action=put&object=landcover&x
${LANDCOVER_API_URL_GET}		${API_BASE_URL}&action=get&object=landcover
${LANDCOVER_API_URL_DELETE}		${API_BASE_URL}&action=delete&object=landcover
${LANDCOVER_API_URL_RESTORE}		${API_BASE_URL}&action=restore&object=landcover
${LANDCOVER_API_URL_UPDATE}		${API_BASE_URL}&action=update&object=landcover&
${ID}		0
${recorder_name_fake}		lpks@gmail.com
${recorder_name}		lpks.test@gmail.com
${name}		lpks.test@gmail.com-test_1ax12wrss66
${transect}		west
${segment}		5m
${date}			2016-01-03
${canopy_height}	10-50cm
${canopy_gap}		true
${basal_gap}		false
${species_of_interest_1}		a.reficiens
${species_of_interest_2}		b.reficiens
${dominant_woody_species}		A . mellifera
${dominant_nonwoody_species}		solenum
${stick_segment_0}		Sub-shrubs and perennial forbs, Perennial grasses, Herb Litter
${stick_segment_1}		Perennial grasses, Herb Litter
${stick_segment_2}		Sub-shrubs and perennial forbs, Herb Litter
${stick_segment_3}		Sub-shrubs and perennial forbs, Perennial grasses
${stick_segment_4}		Herb Litter, Rock fragment

${found}		0




*** Test Cases ***
Landcover PUT
	[Tags]		Landcover	Put
	${secrets}=			get file		client.json
	${access_token}=		get google token		${secrets}
	new landcover put	${access_token}
    create session      landcover_put2     ${LANDCOVER_API_URL_PUT}
	&{headers}=  Create Dictionary  X-Auth-Token=${access_token}
	&{params}=   Create Dictionary   recorder_name=${recorder_name_fake}      name=${name}        transect=${transect}        segment=${segment}		date=${date}   canopy_height=${canopy_height}      canopy_gap=${canopy_gap}        basal_gap=${basal_gap}      species_of_interest_1=${species_of_interest_1}      species_of_interest_2=${species_of_interest_2}      dominant_woody_species=${dominant_woody_species}        dominant_nonwoody_species=${dominant_nonwoody_species}      stick_segment_0=${stick_segment_0}      stick_segment_1=${stick_segment_1}      stick_segment_2=${stick_segment_2}      stick_segment_3=${stick_segment_3}      stick_segment_4=${stick_segment_4}

    ${result}=		put Request     landcover_put2     /put		params=${params}	headers=${headers}
    should be valid json     ${result.content}
    should be true     ${result.status_code}<> 200

Landcover Update
	[Tags]		Landcover	Update
	change variables for update
	${secrets}=			get file		client.json
	${access_token}=		get google token		${secrets}
	create session      landcover_update     ${LANDCOVER_API_URL_UPDATE}
	&{headers}=  Create Dictionary  X-Auth-Token=${access_token}
	&{params}=   Create Dictionary		id=${ID}		recorder_name=${recorder_name}      name=${name}        transect=${transect}        segment=${segment}		date=${date}        canopy_height=${canopy_height}      canopy_gap=${canopy_gap}        basal_gap=${basal_gap}      species_of_interest_1=${species_of_interest_1}      species_of_interest_2=${species_of_interest_2}      dominant_woody_species=${dominant_woody_species}        dominant_nonwoody_species=${dominant_nonwoody_species}      stick_segment_0=${stick_segment_0}      stick_segment_1=${stick_segment_1}      stick_segment_2=${stick_segment_2}      stick_segment_3=${stick_segment_3}      stick_segment_4=${stick_segment_4}

    ${result}=		put Request     landcover_update     /put		params=${params}	headers=${headers}
    should be valid json     ${result.content}
    run keyword if      ${result.status_code}== 200			get id from response 	${result.content}
    run keyword if      ${result.status_code}== 200			validate put result through get
    run keyword if      ${result.status_code}== 500			validate put result through get


Landcover Archive By Name RecorderName
	[Tags]		Landcover	Archive
	${secrets}=			get file		client.json
	${access_token}=		get google token		${secrets}
	create session      landcover_archive     ${LANDCOVER_API_URL_DELETE}&type=delete_by_name_recorder_name&x
	&{headers}=  Create Dictionary  X-Auth-Token=${access_token}
	&{params}=   Create Dictionary		name=${name}		recorder_name=${recorder_name}		delete_permanent=0
	${result}=		delete Request     landcover_archive     /delete		params=${params}	headers=${headers}
    should be valid json     ${result.content}
	run keyword if      ${result.status_code}== 200			validate archived by name recorder name

Landcover Restore By Name RecorderName
	[Tags]		Landcover	Restore
	${secrets}=			get file		client.json
	${access_token}=		get google token		${secrets}
	create session      landcover_restore     ${LANDCOVER_API_URL_RESTORE}&type=restore_by_name_recorder_name&x
	&{headers}=  Create Dictionary  X-Auth-Token=${access_token}
	&{params}=   Create Dictionary		name=${name}		recorder_name=${recorder_name}
	${result}=		put Request     landcover_restore     /put		params=${params}	headers=${headers}
    should be valid json     ${result.content}
	run keyword if      ${result.status_code}== 200			validate restored by name recorder name

Landcover Archive By Name RecorderName Date
	[Tags]		Landcover	Archive
	${secrets}=			get file		client.json
	${access_token}=		get google token		${secrets}
	create session      landcover_archive     ${LANDCOVER_API_URL_DELETE}&type=delete_by_name_recorder_name_date&x
	&{headers}=  Create Dictionary  X-Auth-Token=${access_token}
	&{params}=   Create Dictionary		name=${name}		recorder_name=${recorder_name}		date=${date}		delete_permanent=0
	${result}=		delete Request     landcover_archive     /delete		params=${params}	headers=${headers}
    should be valid json     ${result.content}
	run keyword if      ${result.status_code}== 200			validate archived by name recorder name date

Landcover Restore By Name RecorderName Date
	[Tags]		Landcover	Restore
	${secrets}=			get file		client.json
	${access_token}=		get google token		${secrets}
	create session      landcover_restore     ${LANDCOVER_API_URL_RESTORE}&type=restore_by_name_recorder_name_date&x
	&{headers}=  Create Dictionary  X-Auth-Token=${access_token}
	&{params}=   Create Dictionary		name=${name}		recorder_name=${recorder_name}		date=${date}
	${result}=		put Request     landcover_restore     /put		params=${params}	headers=${headers}
    should be valid json     ${result.content}
	run keyword if      ${result.status_code}== 200			validate restored by name recordername date

Landcover Delete Permanent By Name RecorderName Date
	[Tags]		Landcover	Delete Permanent
	${secrets}=			get file		client.json
	${access_token}=		get google token		${secrets}
	create session      landcover_delete     ${LANDCOVER_API_URL_DELETE}&type=delete_by_name_recorder_name_date&x
	&{headers}=  Create Dictionary  X-Auth-Token=${access_token}
	&{params}=   Create Dictionary		name=${name}		recorder_name=${recorder_name}		delete_permanent=1
	${result}=		delete Request     landcover_delete     /delete		params=${params}	headers=${headers}
    should be valid json     ${result.content}
	run keyword if      ${result.status_code}== 200			validate delete permanent by name recordername date

Landcover Delete Permanent By Name RecorderName
	[Tags]		Landcover	Delete Permanent
	${secrets}=			get file		client.json
	${access_token}=		get google token		${secrets}
	new landcover put		${access_token}
	create session      landcover_delete     ${LANDCOVER_API_URL_DELETE}&type=delete_by_name_recorder_name&x
	&{headers}=  Create Dictionary  X-Auth-Token=${access_token}
	&{params}=   Create Dictionary		name=${name}		recorder_name=${recorder_name}		delete_permanent=1
	${result}=		delete Request     landcover_delete     /delete		params=${params}	headers=${headers}
    should be valid json     ${result.content}
	run keyword if      ${result.status_code}== 200			validate delete permanent by name recorder name

*** Keywords ***
New Landcover Put
	[Arguments]		${access_token}
	create session      landcover_put     ${LANDCOVER_API_URL_PUT}
	&{headers}=  Create Dictionary  X-Auth-Token=${access_token}
	&{params}=   Create Dictionary		recorder_name=${recorder_name}      name=${name}        transect=${transect}        segment=${segment}		date=${date}        canopy_height=${canopy_height}      canopy_gap=${canopy_gap}        basal_gap=${basal_gap}      species_of_interest_1=${species_of_interest_1}      species_of_interest_2=${species_of_interest_2}      dominant_woody_species=${dominant_woody_species}        dominant_nonwoody_species=${dominant_nonwoody_species}      stick_segment_0=${stick_segment_0}      stick_segment_1=${stick_segment_1}      stick_segment_2=${stick_segment_2}      stick_segment_3=${stick_segment_3}      stick_segment_4=${stick_segment_4}

    ${result}=		put Request     landcover_put     /put		params=${params}	headers=${headers}
    should be valid json     ${result.content}
    run keyword if      ${result.status_code}== 200			get id from response 	${result.content}
    run keyword if      ${result.status_code}== 200			validate put result through get
    run keyword if      ${result.status_code}== 500			validate put result through get

Get Id From Response
	[Arguments]		${resonse}
	${resonse_json}		to json		${resonse}
	set global variable		${ID}		${resonse_json['id']}

Validate Put Result Through Get
	${get_url}=     replace variables        ${LANDCOVER_API_URL_GET}&type=get_by_pair_name_recorder_name&name=${name}&recorder_name=${recorder_name}&records_type=0&x
    create session      landcover_get     ${get_url}
    ${result}=  Get Request     landcover_get     /get
    should be valid json     ${result.content}
    run keyword if      ${result.status_code}== 200       validate content    ${result.content}


Validate Archived By Name Recorder Name
	${get_url}=     replace variables        ${LANDCOVER_API_URL_GET}&type=get_by_pair_name_recorder_name&name=${name}&recorder_name=${recorder_name}&records_type=0&x
    create session      landcover_get     ${get_url}
    ${result}=  Get Request     landcover_get     /get

    should be valid json     ${result.content}
    ${json}=		to json		${result.content}
    ${length}=		get length  	${json['transect']}
    should be true      ${length}==0


Validate Restored By Name Recorder Name
	${get_url}=     replace variables        ${LANDCOVER_API_URL_GET}&type=get_by_pair_name_recorder_name&name=${name}&recorder_name=${recorder_name}&records_type=0&x
    create session      landcover_get     ${get_url}
    ${result}=  Get Request     landcover_get     /get

    should be valid json     ${result.content}
    ${json}=		to json		${result.content}
    ${length}=		get length  	${json['transect']}
    should be true      ${length}>=0		${json}

Validate Archived By Name RecorderName Date
	${get_url}=     replace variables        ${LANDCOVER_API_URL_GET}&type=get_by_pair_name_recorder_name&name=${name}&recorder_name=${recorder_name}&records_type=0&x
    create session      landcover_get     ${get_url}
    ${result}=  Get Request     landcover_get     /get

    should be valid json     ${result.content}
    ${json}=		to json		${result.content}
    ${length}=		get length  	${json['transect']}
    @{transect_list}=       convert to list     ${json['transect']}
    :FOR        ${landcover_object}       IN      @{transect_list}
    \		${found}=		set variable if		${landcover_object['date']}==${date}	1
    \		${found_transect}=		set variable if		${landcover_object['date']}==${date}	${landcover_object}
    \		Exit For Loop If    ${landcover_object['id']}==${ID}
    should not be true		${found}==1

Validate Restored By Name Recorder Name Date
	${get_url}=     replace variables        ${LANDCOVER_API_URL_GET}&type=get_by_pair_name_recorder_name&name=${name}&recorder_name=${recorder_name}&records_type=0&x
    create session      landcover_get     ${get_url}
    ${result}=  Get Request     landcover_get     /get

    should be valid json     ${result.content}
    ${json}=		to json		${result.content}
    ${length}=		get length  	${json['transect']}
    @{transect_list}=       convert to list     ${json['transect']}
    :FOR        ${landcover_object}       IN      @{transect_list}
    \		${found}=		set variable if		${landcover_object['date']}==${date}	1
    \		${found_transect}=		set variable if		${landcover_object['date']}==${date}	${landcover_object}
    \		Exit For Loop If    ${landcover_object['date']}==${date}
    should be true		${found}==1

Validate Delete Permanent By Name Recorder Name
	${get_url}=     replace variables        ${LANDCOVER_API_URL_GET}&type=get_by_pair_name_recorder_name&name=${name}&recorder_name=${recorder_name}&records_type=2&x
    create session      landcover_get     ${get_url}
    ${result}=  Get Request     landcover_get     /get

    should be valid json     ${result.content}
    ${json}=		to json		${result.content}
    ${length}=		get length  	${json['transect']}
    should be true      ${length}==0

Validate Delete Permanent By Name Recordername Date
	${get_url}=     replace variables        ${LANDCOVER_API_URL_GET}&type=get_by_pair_name_recorder_name&name=${name}&recorder_name=${recorder_name}&records_type=2&x
    create session      landcover_get     ${get_url}
    ${result}=  Get Request     landcover_get     /get

    should be valid json     ${result.content}
    ${json}=		to json		${result.content}
    ${length}=		get length  	${json['transect']}
    @{transect_list}=       convert to list     ${json['transect']}
    :FOR        ${landcover_object}       IN      @{transect_list}
    \		${found}=		set variable if		${landcover_object['date']}==${date}	1
    \		${found_transect}=		set variable if		${landcover_object['date']}==${date}	${landcover_object}
    \		Exit For Loop If    ${landcover_object['id']}==${ID}
    should not be true		${found}==1

Validate Content
	[Arguments]		${content}
	${found}=		set variable 		0
	${content_json}		to json		${content}
	${length}=		get length		${content_json['transect']}

	should be true		${length}>=1
	@{transect_list}=       convert to list     ${content_json['transect']}
    :FOR        ${landcover_object}       IN      @{transect_list}
    \		${found}=		set variable if		${landcover_object['id']}==${ID}	1
    \		${found_transect}=		set variable if		${landcover_object['id']}==${ID}	${landcover_object}
    \		Exit For Loop If    ${landcover_object['id']}==${ID}
    should be true		${found}==1

    ${get_transect}=        get from dictionary     ${found_transect}     direction
	${get_date}=        get from dictionary     ${found_transect}     date
	${get_species_of_interest_1}=       get from dictionary     ${found_transect}        species_of_interest_1
	${get_species_of_interest_2}=       get from dictionary     ${found_transect}        species_of_interest_2
	${get_dominant_woody_species}=      get from dictionary     ${found_transect}       dominant_woody_species
	${get_dominant_nonwoody_species}=       get from dictionary     ${found_transect}        dominant_nonwoody_species

	${get_segment}=     get from dictionary     ${found_transect['segment']}      range
	${get_canopy_height}=       get from dictionary     ${found_transect['segment']}        canopy_height
	${get_canopy_gap}=      get from dictionary     ${found_transect['segment']}       canopy_gap
	${get_basal_gap}=       get from dictionary     ${found_transect['segment']}        basal_gap


	${get_stick_segment_0}=     get from dictionary     ${found_transect['segment']['stick_segment']['0']}      cover
	${get_stick_segment_1}=     get from dictionary     ${found_transect['segment']['stick_segment']['1']}      cover
	${get_stick_segment_2}=     get from dictionary     ${found_transect['segment']['stick_segment']['2']}      cover
	${get_stick_segment_3}=     get from dictionary     ${found_transect['segment']['stick_segment']['3']}      cover
	${get_stick_segment_4}=     get from dictionary     ${found_transect['segment']['stick_segment']['4']}      cover


	${get_transect}=        convert to lowercase        ${get_transect}
	${get_date}=        convert to lowercase        ${get_date}
	${get_species_of_interest_1}=       convert to lowercase        ${get_species_of_interest_1}
	${get_species_of_interest_2}=       convert to lowercase        ${get_species_of_interest_2}
#	${get_dominant_woody_species}=      convert to lowercase        ${get_dominant_woody_species}
#	${get_dominant_nonwoody_species}=       convert to lowercase        ${get_dominant_nonwoody_species}
#	${get_segment}=     convert to lowercase        ${get_segment}
#	${get_canopy_height}=       convert to lowercase        ${get_canopy_height}
	${get_canopy_gap}=      convert to lowercase        ${get_canopy_gap}
	${get_basal_gap}=       convert to lowercase        ${get_basal_gap}
#	${get_stick_segment_0}=     convert to lowercase        ${get_stick_segment_0}
#	${get_stick_segment_1}=     convert to lowercase        ${get_stick_segment_1}
#	${get_stick_segment_2}=     convert to lowercase        ${get_stick_segment_2}
#	${get_stick_segment_3}=     convert to lowercase        ${get_stick_segment_3}
#	${get_stick_segment_4}=     convert to lowercase        ${get_stick_segment_4}

	should be equal as strings      ${get_transect}     ${transect}
	should be equal as strings      ${get_date}     ${date}
	should be equal as strings      ${get_species_of_interest_1}        ${species_of_interest_1}
	should be equal as strings      ${get_species_of_interest_2}        ${species_of_interest_2}
	should be equal as strings      ${get_dominant_woody_species}       ${dominant_woody_species}
	should be equal as strings      ${get_dominant_nonwoody_species}        ${dominant_nonwoody_species}
	should be equal as strings      ${get_segment}      ${segment}
	should be equal as strings      ${get_canopy_height}        ${canopy_height}
	should be equal as strings      ${get_canopy_gap}       ${canopy_gap}
	should be equal as strings      ${get_basal_gap}        ${basal_gap}
	should be equal as strings      ${get_stick_segment_0}      ${stick_segment_0}
	should be equal as strings      ${get_stick_segment_1}      ${stick_segment_1}
	should be equal as strings      ${get_stick_segment_2}      ${stick_segment_2}
	should be equal as strings      ${get_stick_segment_3}      ${stick_segment_3}
	should be equal as strings      ${get_stick_segment_4}      ${stick_segment_4}


Change Variables For Update
	set global variable 		${transect}		north
	set global variable 		${segment}		10m
	set global variable 		${date}			2016-01-01
	set global variable 		${canopy_height}	50cm-1m
	set global variable 		${canopy_gap}		false
	set global variable 		${basal_gap}		true
	set global variable 		${species_of_interest_1}		c.reficiens
	set global variable 		${species_of_interest_2}		d.reficiens
	set global variable 		${dominant_woody_species}		B . mellifera
	set global variable 		${dominant_nonwoody_species}		solenumss
	set global variable 		${stick_segment_0}		Sub-shrubs and perennial forbs,Herb Litter
	set global variable 		${stick_segment_1}		Perennial grasses,Herb Litter,Rock fragment
	set global variable 		${stick_segment_2}		Sub-shrubs and perennial forbs
	set global variable 		${stick_segment_3}		Perennial grasses
	set global variable 		${stick_segment_4}		Herb Litter


