*** Settings ***
Documentation     Common Keywords.
Library           Collections
Library           RequestsLibrary
Library           OperatingSystem
Library           String

*** Keywords ***
Get Header Dictionary
    ${headers}=  create dictionary
    set to dictionary  ${headers}   Content-Type=application/json
    [Return]   ${headers}

Generate Random Number
    ${randomNumber}=    Evaluate    random.sample(range(0, 100000), 1)    random
    ${randomNumber}=  set variable  ${randomNumber[0]}
    [Return]   ${randomNumber}
