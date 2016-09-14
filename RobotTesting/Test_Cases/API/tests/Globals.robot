*** Variables ***
${API_BASE_URL}     http://testapi.landpotential.org:8080/query?version=0.2
${CURSOR_KEY_LIST}      count,has_next,has_prev,next_cursor,next_records,prev_cursor,prev_records
${LANDINFO_OBJECT_KEY_LIST}     archived,bedrock_depth,city,color,flooding,grazed,grazing,id,insert_normal_time,ip_address,land_cover,landscape_east_photo_url,landscape_north_photo_url,landscape_south_photo_url,landscape_west_photo_url,latitude,longitude,name,notes,organization,recorder_name,rock_fragment,slope,slope_shape,soil_pit_photo_url,soil_samples_photo_url,stopped_digging_depth,surface_cracking,surface_salt,test_plot,texture
${ERROR_KEY_LIST}     error
${LANDCOVER_OBJECT_KEY_LIST}     date,name,recorder_name,transect
${LANDCOVER_TRANSECT_KEY_LIST}     archived,date,direction,dominant_nonwoody_species,dominant_woody_species,id,segment,species_of_interest_1,species_of_interest_2
${LANDCOVER_SEGMENT_KEY_LIST}     basal_gap,canopy_gap,canopy_height,date,range,species_1_density,species_2_density,species_list,species_of_interest_1_count,species_of_interest_2_count,stick_segment,summary,time
${LANDCOVER_STICK_SEGMENT_KEY_LIST}     0,1,2,3,4
${LANDCOVER_STICK_SEGMENT_VALUE_KEY_LIST}     cover,index
${LANDCOVER_SUMMARY_KEY_LIST}     annuals_total,bare_total,herb_litter_total,perennial_grasses_total,plant_base_total,rock_total,shrubs_total,sub_shrubs_total,trees_total,wood_litter_total
${LANDINFO_LANDCOVER_KEY_LIST}      has_landcover,id,landcover_archived,landinfo_archived,latitude,longitude,name,organization,recorder_name,test_plot

*** Keywords ***
Get Data
    [Arguments]     ${result}
    dictionary should contain key      ${result}       data
    ${data}=     get from dictionary     ${result}      data
    [return]	${data}

Get Cursor Metadata
    [Arguments]     ${result}
    dictionary should contain key      ${result}       search_metadata
    ${search_metadata}=     get from dictionary     ${result}      search_metadata
    [return]	${search_metadata}

Get Cursor Has Next
    [Arguments]     ${cursor_result}
    ${has_next}=     get from dictionary     ${cursor_result}      has_next
    [return]	${has_next}

Get Next Cursor
    [Arguments]     ${cursor_result}
    ${next_cursor}=     get from dictionary     ${cursor_result}      next_cursor
    [return]	${next_cursor}


Validate Cursor Model
    [Arguments]     ${search_metadata}
    ${cursor_metadata_keys}=        get dictionary keys        ${search_metadata}
    ${original_cursor_keys}=       split string    ${CURSOR_KEY_LIST}     ,
    Lists Should Be Equal       ${cursor_metadata_keys}     ${original_cursor_keys}

Validate Error Model
    [Arguments]     ${response}
    ${error}=     to json     ${response}
    ${error_keys}=        get dictionary keys        ${error}
    ${original_error_keys}=       split string    ${ERROR_KEY_LIST}     ,
    Lists Should Be Equal       ${error_keys}     ${original_error_keys}
