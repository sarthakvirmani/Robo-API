*** Settings ***
Documentation       Read configurations
Library             CommonUtilities.py
Library             Collections
Library             OperatingSystem
Resource            ../Variables/Environment.robot

*** Variables ***
${path}     ${CURDIR}${/}..${/}Variables${/}App_pods.xlsx

*** Keywords ***
Get Config Pod Values
    ${data}=   Read data from excel file    ${path}    ${environment}
    set global variable   ${data}

Get Hostname
    Get Config Pod Values
    ${value}=  get from dictionary  ${data}  hostname
    [Return]  ${value}