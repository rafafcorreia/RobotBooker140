*** Settings ***
Library    RequestsLibrary
Library    DataDriver    ../../fixtures/csv/booking.csv    dialect=excel
Variables    ../../resources/variables.py
Test Template    Create Booking DDT

*** Test Cases ***
Create Booking Successfully

*** Keywords ***
Create Booking DDT
    [Arguments]    ${firstname}    ${lastname}    ${totalprice}    ${depositpaid}    ${checkin}    ${checkout}    ${additionalneeds}
    ${header}    Create Dictionary    Content-Type=${content_type}
    ${totalprice}    Convert To Integer    ${totalprice}
    ${depositpaid}    Convert To Boolean    ${depositpaid}
    &{bookingdates}    Create Dictionary    checkin=${checkin}    checkout=${checkout}
    ${body}    Create Dictionary    firstname=${firstname}    lastname=${lastname}    
    ...    totalprice=${totalprice}    depositpaid=${depositpaid}    
    ...    bookingdates=${bookingdates}    additionalneeds=${additionalneeds}
    
    ${response}    POST    url=${url}/booking    json=${body}    headers=${header}

    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

    Status Should Be    200
    Should Be Equal    ${response_body}[booking][firstname]    ${firstname}
    Should Be Equal    ${response_body}[booking][lastname]    ${lastname}
    Should Be Equal    ${response_body}[booking][totalprice]    ${totalprice}
    Should Be Equal    ${response_body}[booking][depositpaid]    ${depositpaid}
    Should Be Equal    ${response_body}[booking][bookingdates][checkin]    ${bookingdates}[checkin]
    Should Be Equal    ${response_body}[booking][bookingdates][checkout]    ${bookingdates}[checkout]
    Should Be Equal    ${response_body}[booking][additionalneeds]    ${additionalneeds}
