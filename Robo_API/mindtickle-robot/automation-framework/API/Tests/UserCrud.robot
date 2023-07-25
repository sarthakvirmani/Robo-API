*** Settings ***
Documentation     Users Crud Operation Test Cases
Resource          ../Business/Users.robot
Resource          ../Common/CommonKeywords.robot


*** Variables ***
${userName}    MyUser
*** Test Cases ***

Create Multiple Users And Validate Response
# Create Multiple Users And Get List Of UserNames
    [Tags]    Sanity        Regression     Assertion     SRE
    ${userNames}=    Users.Create Mutiple Users And Return User Names    ${userName}    2
    set global variable    ${userNames}

Update User Username And Verify Response
# Update Any User's Username And Validate Response
    [Tags]    Sanity        Regression     Assertion     SRE
    ${randomUserId}=    CommonKeywords.Generate Random Number
    ${randomUserName}=    Catenate  ${userName}${randomUserId}
    set global variable    ${randomUserName}
    Update User Details And Validate Response    ${userNames[0]}    ${userNameField}    ${randomUserName}

Get User Details By Updated Username And Verify Response
#Get User Details By Username and Validat updated username
    [Tags]    Sanity        Regression     Assertion     SRE
    Get User Details By Username And Verify Fields In Response    ${randomUserName}

Update User Email And Verify Response
# Update Any User's Email And Validate Response
    [Tags]    Sanity        Regression     Assertion     SRE
    Update User Details And Validate Response    ${userNames[0]}    ${emailField}    ${updatedEmail}

Update User Phone Number And Verify Response
# Update Any User's Phone Number And Validate Response
    [Tags]    Sanity        Regression     Assertion     SRE
    Update User Details And Validate Response   ${userNames[0]}    ${phoneField}    ${updatedPhoneNumber}