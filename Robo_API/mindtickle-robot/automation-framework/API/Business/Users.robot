*** Settings ***
Documentation     Users Business Functions
Library           RequestsLibrary
Library           String
Resource          ../Variables/Constants.robot
Resource          ../Common/CommonKeywords.robot
Resource          ../Utilities/Data.robot

*** Variables ***
${createUserFile}           ${CURDIR}${/}..${/}..${/}API${/}Input${/}CreateUser.json
${updateUserFile}           ${CURDIR}${/}..${/}..${/}API${/}Input${/}UpdateUser.json
${create_user_url}         v2/user
${create_user_array_url}    v2/user/createWithArray
${update_user_url}         /v2/user/{}
${get_user_url}         /v2/user/{}

*** Keywords ***
Get File Contents For Create User Request
    [Arguments]   ${createUserFile}    ${userId}    ${userName}
    ${requestBody}  Get file  ${createUserFile}
    ${requestBody}    evaluate  json.loads('''${requestBody}''')    json
    Set To Dictionary   ${requestBody}    id=${userId}
    Set To Dictionary   ${requestBody}    username=${userName}
    [Return]    ${requestBody}

Get File Contents For Update User Request
    [Arguments]   ${updateUserFile}    ${field_to_update}    ${updated_value}
    ${requestBody}  Get file  ${updateUserFile}
    ${requestBody}    evaluate  json.loads('''${requestBody}''')    json
    IF    '${field_to_update}'=='${emailField}'
        Set To Dictionary   ${requestBody}    ${field_to_update}=${updated_value}
    ELSE IF    '${field_to_update}'=='${phoneField}'
        Set To Dictionary   ${requestBody}    ${field_to_update}=${updated_value}
    ELSE IF    '${field_to_update}'=='${userNameField}'
        Set To Dictionary   ${requestBody}    ${field_to_update}=${updated_value}
    END
    [Return]    ${requestBody}

Create User With Array Response
    [Arguments]    ${requestBody}    ${expected_status_code}=${successRequestStatusCode}
    ${host_name}=    Get Hostname
    ${headers} =  Get Header Dictionary
    Create Session    alias=MTapi    url=${host_name}    headers=${headers}    disable_warnings=1
    ${resp}=    Post On Session    MTapi     ${create_user_array_url}    json=${requestBody}    expected_status=${expected_status_code}    msg="Status code is not equal to 200 (SUCCESS)"
    Log  ${resp}
    [Return]    ${resp}

Create Mutiple Users And Return User Names
    [Arguments]    ${userName}    ${user_count}    ${expected_status_code}=${successRequestStatusCode}
    ${createMultipleUsersRequest}=    create list
    ${userNames}=    create list
    FOR    ${i}    IN RANGE    0    ${user_count}
        ${randomUserId}=    CommonKeywords.Generate Random Number
        ${randomUserName}=    Catenate  ${userName}${randomUserId}
        ${requestBody}=  Get File Contents For Create User Request    ${createUserFile}    ${randomUserId}    ${randomUserName}
        append to list    ${createMultipleUsersRequest}    ${requestBody}
        append to list    ${userNames}    ${randomUserName}
    END
    Log  Post Request Body To Create Multiple Users:${createMultipleUsersRequest}
    ${resp}=    Create User With Array Response    ${createMultipleUsersRequest}    ${expected_status_code}
    ${json_resp}=  set variable  ${resp.json()}
    Log  Post Response For Create Multiple Users:${json_resp}
    [Return]    ${userNames}

Update User Details Response
    [Arguments]    ${username}    ${requestBody}    ${expected_status_code}=${successRequestStatusCode}
    ${host_name}=    Get Hostname
    ${headers} =  Get Header Dictionary
    Create Session    alias=MTapi    url=${host_name}    headers=${headers}    disable_warnings=1
    ${url}=  format string  ${update_user_url}   ${username}
    ${resp}=    Put On Session    MTapi     ${url}    json=${requestBody}    expected_status=${expected_status_code}    msg="Status code is not equal to 200 (SUCCESS)"
    Log  ${resp}
    [Return]    ${resp}

Update User Details And Validate Response
    [Arguments]    ${userName}    ${fieldToUpdate}    ${updatedValue}    ${expected_status_code}=${successRequestStatusCode}
    ${requestBody}=  Get File Contents For Update User Request    ${updateUserFile}    ${fieldToUpdate}    ${updatedValue}
    Log  Post Request Body To Update User:${requestBody}
    ${resp}=    Update User Details Response   ${userName}    ${requestBody}    ${expected_status_code}
    ${json_resp}=  set variable  ${resp.json()}
    Log  Post Response For Update User:${json_resp}
    [Return]    ${json_resp}

Get User By Username Response
    [Arguments]    ${userName}    ${expected_status_code}=${successRequestStatusCode}
    ${host_name}=    Get Hostname
    ${headers}    Get Header Dictionary
    ${url}=  format string    ${get_user_url}     ${userName}
    Create Session    alias=MTapi    url=${host_name}    headers=${headers}    disable_warnings=1
    ${resp}=    Get On Session    MTapi    ${url}   expected_status=${expected_status_code}    msg="Status code is not equal to 200 (SUCCESS)"
    Log  ${resp}
    [Return]    ${resp}

Get User Details By Username And Verify Fields In Response
    [Arguments]    ${userName}    ${expected_status_code}=${successRequestStatusCode}
    ${resp}=    Get User By Username Response    ${userName}   ${expected_status_code}
    ${json_resp}=  set variable  ${resp.json()}
    should be equal as strings    ${userName}   ${json_resp['username']}