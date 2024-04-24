*** Settings ***
Library    RequestsLibrary
Resource    ../../resources/common.resource
Variables    ../../resources/variables.py
Suite Setup    Create Token    ${url}

*** Test Cases ***
Create Booking
    ${body}    Evaluate    json.loads(open('./fixtures/json/booking1.json').read())
    
    ${response}    POST    url=${url}/booking    json=${body}

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

Get Booking
    Get Booking Id    ${url}    ${firstname}    ${lastname}
    ${response}    GET    url=${url}/booking/${bookingid}

    ${response_body}    Set Variable    ${response.json()}
    
    Log To Console    ${response_body}
    Status Should Be    200
    Should Be Equal    ${response_body}[firstname]    ${firstname}
    Should Be Equal    ${response_body}[lastname]    ${lastname}
    Should Be Equal    ${response_body}[totalprice]    ${totalprice}
    Should Be Equal    ${response_body}[depositpaid]    ${depositpaid}
    Should Be Equal    ${response_body}[bookingdates][checkin]    ${bookingdates}[checkin]
    Should Be Equal    ${response_body}[bookingdates][checkout]    ${bookingdates}[checkout]
    Should Be Equal    ${response_body}[additionalneeds]    ${additionalneeds}

Update Booking
    Get Booking Id    ${url}    ${firstname}    ${lastname}
    ${header}    Create Dictionary    Cookie=token=${token}
    ${body}    Create Dictionary    firstname=${firstname}    lastname=${lastname}    
    ...    totalprice=${totalprice}    depositpaid=${new_depositpaid}    
    ...    bookingdates=${bookingdates}    additionalneeds=${additionalneeds}
    
    ${response}    PUT    url=${url}/booking/${bookingid}    json=${body}    headers=${header}

    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

    Status Should Be    200
    Should Be Equal    ${response_body}[firstname]    ${firstname}
    Should Be Equal    ${response_body}[lastname]    ${lastname}
    Should Be Equal    ${response_body}[totalprice]    ${totalprice}
    Should Be Equal    ${response_body}[depositpaid]    ${new_depositpaid}
    Should Be Equal    ${response_body}[bookingdates][checkin]    ${bookingdates}[checkin]
    Should Be Equal    ${response_body}[bookingdates][checkout]    ${bookingdates}[checkout]
    Should Be Equal    ${response_body}[additionalneeds]    ${additionalneeds}

Partial Update Booking
    Get Booking Id    ${url}    ${firstname}    ${lastname}
    ${header}    Create Dictionary    Cookie=token=${token}
    ${body}    Create Dictionary    lastname=${new_lastname}    additionalneeds=${new_additionalneeds}

    ${response}    PATCH    url=${url}/booking/${bookingid}    headers=${header}    json=${body}

    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

    Status Should Be    200
    Should Be Equal    ${response_body}[firstname]    ${firstname}
    Should Be Equal    ${response_body}[lastname]    ${new_lastname}
    Should Be Equal    ${response_body}[totalprice]    ${totalprice}
    Should Be Equal    ${response_body}[depositpaid]    ${new_depositpaid}
    Should Be Equal    ${response_body}[bookingdates][checkin]    ${bookingdates}[checkin]
    Should Be Equal    ${response_body}[bookingdates][checkout]    ${bookingdates}[checkout]
    Should Be Equal    ${response_body}[additionalneeds]    ${new_additionalneeds}
    Set Suite Variable    ${lastname}    ${new_lastname}

Delete Booking
    Get Booking Id    ${url}    ${firstname}    ${lastname}    
    ${header}    Create Dictionary    Cookie=token=${token}

    ${response}    DELETE    url=${url}/booking/${bookingid}    headers=${header}

    Status Should Be    201
