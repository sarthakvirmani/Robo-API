*** Settings ***
Documentation     Pets Business Functions
Library           RequestsLibrary
Library           String
Resource          ../Variables/Constants.robot
Resource          ../Common/CommonKeywords.robot
Resource          ../Utilities/Data.robot

*** Variables ***
${createPetFile}           ${CURDIR}${/}..${/}..${/}API${/}Input${/}CreatePet.json
${updatePetFile}           ${CURDIR}${/}..${/}..${/}API${/}Input${/}UpdatePet.json
${create_pet_url}         /v2/pet
${update_pet_url}         /v2/pet
${get_pet_url}         /v2/pet/{}
${get_pet_by_status_url}         /v2/pet/findByStatus?status={}

*** Keywords ***
Get File Contents For Create Pet Request
    [Arguments]   ${createPetFile}    ${petId}    ${petName}
    ${requestBody}  Get file  ${createPetFile}
    ${requestBody}    evaluate  json.loads('''${requestBody}''')    json
    Set To Dictionary   ${requestBody}    id=${petId}
    Set To Dictionary   ${requestBody}    name=${petName}
    [Return]    ${requestBody}

Get File Contents For Update Pet Detail Request
    [Arguments]    ${updatePetFile}    ${petId}    ${field_to_update}    ${updated_value}
    ${requestBody}  Get file  ${updatePetFile}
    ${requestBody}    evaluate  json.loads('''${requestBody}''')    json
    Set To Dictionary   ${requestBody}    id=${petId}
    IF    '${field_to_update}'=='${statusField}'
        Set To Dictionary   ${requestBody}    ${field_to_update}=${updated_value}
    ELSE IF    '${field_to_update}'=='${photoUrlsField}'
        Append To List    ${requestBody['photoUrls']}    ${updated_value}
    ELSE IF    '${field_to_update}'=='${categoryField}'
        Set To Dictionary    ${requestBody['category']}    name=${updated_value}
    END
    [Return]    ${requestBody}

Create Pet Response
    [Arguments]    ${requestBody}    ${expected_status_code}=${successRequestStatusCode}
    ${host_name}=    Get Hostname
    ${headers} =  Get Header Dictionary
    Create Session    alias=MTapi    url=${host_name}    headers=${headers}    disable_warnings=1
    ${resp}=    Post On Session    MTapi     ${create_pet_url}    json=${requestBody}    expected_status=${expected_status_code}    msg="Status code is not equal to 200 (SUCCESS)"
    Log  ${resp}
    [Return]    ${resp}

Create Pet And Return Id
    [Arguments]    ${petId}    ${petName}    ${expected_status_code}=${successRequestStatusCode}
    ${requestBody}=  Get File Contents For Create Pet Request    ${createPetFile}    ${petId}    ${petName}
    Log  Post Request Body To Create Pet:${requestBody}
    ${resp}=    Create Pet Response    ${requestBody}    ${expected_status_code}
    ${json_resp}=  set variable  ${resp.json()}
    Log  Post Response For Create Pet:${json_resp}
    [Return]    ${json_resp['id']}

Get Pet By Id/Status Response
    [Arguments]    ${petId}='None'    ${petStatus}='None'    ${expected_status_code}=${successRequestStatusCode}
    ${host_name}=    Get Hostname
    ${headers}    Get Header Dictionary
    IF      '${petId}' != 'None'
        ${url}=  format string  ${get_pet_url}   ${petId}
    ELSE
        ${url}=  format string  ${get_pet_url}   ${petStatus}
    END
    Create Session    alias=MTapi    url=${host_name}    headers=${headers}    disable_warnings=1
    ${resp}=    Get On Session    MTapi    ${url}
    Log  ${resp}
    [Return]    ${resp}

Get Pet Details By Id/Status And Verify Fields In Response
    [Arguments]    ${petId}='None'    ${petStatus}='None'    ${expectedName}='None'    ${expectedStatus}='None'
    ${resp}=    Get Pet By Id/Status Response    ${petId}    ${petStatus}
    ${json_resp}=  set variable  ${resp.json()}
    Log  Response From Get Pet Details API:${json_resp}
    IF      '${expectedName}' != 'None'
        Log    ${expectedName}
        should be equal as strings    ${expectedName}    ${json_resp['name']}
    ELSE
        Log    ${expectedStatus}
        should be equal as strings    ${expectedStatus}    ${json_resp['status']}
    END

Update Pet Response
    [Arguments]    ${requestBody}    ${expected_status_code}=${successRequestStatusCode}
    ${host_name}=    Get Hostname
    ${headers} =  Get Header Dictionary
    Create Session    alias=MTapi    url=${host_name}    headers=${headers}    disable_warnings=1
    ${resp}=    Put On Session    MTapi     ${update_pet_url}    json=${requestBody}    expected_status=${expected_status_code}    msg="Status code is not equal to 200 (SUCCESS)"
    Log  ${resp}
    [Return]    ${resp}

Update Pet Details And Validate Response
    [Arguments]    ${petId}    ${fieldToUpdate}    ${updatedValue}    ${expected_status_code}=${successRequestStatusCode}
    ${requestBody}=  Get File Contents For Update Pet Detail Request    ${updatePetFile}    ${petId}    ${fieldToUpdate}    ${updatedValue}
    Log  Post Request Body To Update Pet:${requestBody}
    ${resp}=    Update Pet Response    ${requestBody}    ${expected_status_code}
    ${json_resp}=  set variable  ${resp.json()}
    Log  Post Response For Update Pet:${json_resp}
    [Return]    ${json_resp['id']}

Get Pet By Status Response
    [Arguments]    ${petStatus}    ${expected_status_code}=${successRequestStatusCode}
    ${host_name}=    Get Hostname
    ${headers}    Get Header Dictionary
    ${url}=  format string    ${get_pet_by_status_url}    ${petStatus}
    Create Session    alias=MTapi    url=${host_name}    headers=${headers}    disable_warnings=1
    ${resp}=    Get On Session    MTapi    ${url}    expected_status=${expected_status_code}    msg="Status code is not equal to 200 (SUCCESS)"
    Log  ${resp}
    [Return]    ${resp}

Get Pet Details By Status And Verify Fields In Response
    [Arguments]    ${petStatus}    ${expected_status_code}=${successRequestStatusCode}
    ${resp}=    Get Pet By Status Response    ${petStatus}   ${expected_status_code}
    ${json_resp}=  set variable  ${resp.json()}
    should be equal as strings    ${petStatus}   ${json_resp[0]['status']}
