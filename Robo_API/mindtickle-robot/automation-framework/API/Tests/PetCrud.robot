*** Settings ***
Documentation     Pets Crud Operation Test Cases
Resource          ../Business/Pets.robot
Resource          ../Common/CommonKeywords.robot

*** Variables ***
${petName}    MyPet
*** Test Cases ***

Create Pet Record And Validate Response
# Create Pet For First Time And Get Id
    [Tags]    Sanity        Regression     Assertion     SRE
    ${randomPetId}=    CommonKeywords.Generate Random Number
    ${randomPetName}=    Catenate  ${petName}${randomPetId}
    ${petId}=    Pets.Create Pet And Return Id    ${randomPetId}    ${randomPetName}
    set global variable   ${petId}

Create Pet With Same Id And Different Name & Validate Response
    [Tags]    Sanity        Regression     Assertion     SRE
# Create Pet With Same Id And Different Name and validate name is updated.
    ${randomNumber}=    CommonKeywords.Generate Random Number
    ${randomPetName}=    Catenate  ${petName}${randomNumber}
    ${petId}=    Pets.Create Pet And Return Id    ${petId}     ${randomPetName}
# Get Created Pet Details Via Pet Id And Validate Pet Name
    Pets.Get Pet Details By Id/Status And Verify Fields In Response    petId=${petId}    expectedName=${randomPetName}

Update Pet Status And Verify Response
    [Tags]    Sanity        Regression     Assertion     SRE
    Update Pet Details And Validate Response    ${petId}    ${statusField}    ${statusSold}

Update Pet Category And Verify Response
    [Tags]    Sanity        Regression     Assertion     SRE
    Update Pet Details And Validate Response    ${petId}    ${categoryField}    ${categoryCat}

Update Pet Photo URL And Verify Response
    [Tags]    Sanity        Regression     Assertion     SRE
    Update Pet Details And Validate Response    ${petId}    ${photoUrlsField}    ${photoURL}

Get Pet Details By Updated Status And Verify Response
    [Tags]    Sanity        Regression     Assertion     SRE
    Get Pet Details By Status And Verify Fields In Response    ${statusSold}