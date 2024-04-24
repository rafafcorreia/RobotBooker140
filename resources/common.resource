*** Settings ***
Library    RequestsLibrary
Variables    ../resources/variables.py

*** Keywords ***
Create Token
    [Arguments]    ${url}
    ${header}    Create Dictionary    Content-Type=${content_type}
    ${body}    Create Dictionary    username=admin    password=password123
    ${response}    POST    url=${url}/auth    json=${body}    headers=${header}

    Status Should Be    200
    ${token}    Set Variable    ${response.json()}[token]
    Set Suite Variable    ${token}
    Log To Console    ${token}

Get Booking Id
    [Arguments]    ${url}    ${firstname}    ${lastname}

    ${response}    GET    url=${url}/booking?firstname=${firstname}&lastname=${lastname}
    
    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}
    
    Status Should Be    200

    ${bookingid}    Set Variable    ${response_body}[0][bookingid]
    Set Suite Variable    ${bookingid}