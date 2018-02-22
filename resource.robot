*** Settings ***
Documentation     A resource file with reusable keywords and variables.
Library           Selenium2Library

*** Variables ***
${SERVER}                   http://localhost:8081
${BROWSER}                  Firefox
${DELAY}                    0.25
${OWNER_URL}                ${SERVER}/owners/
${FIND_OWNERS_URL}          ${SERVER}/owners/find
${NEW_OWNER_URL}            ${SERVER}/owners/new
${OWNER_ID}
${PET_ID}

*** Keywords ***
Open Browser To Main Page
    Open Browser    ${SERVER}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Speed    ${DELAY}
    Main Page Should Be Open

Main Page Should Be Open
    Title Should Be    PetClinic :: a Spring Framework demonstration
    ${URL} =  Get Location
    Should Be Equal    ${URL}    ${SERVER}/

Go To Find Owners Page
    Go To    ${FIND_OWNERS_URL}
    Owners Page Should Be Open

Owners Page Should Be Open
    ${URL} =  Get Location
    Should Be Equal    ${URL}    ${FIND_OWNERS_URL}

Add New Owner
    [Arguments]   ${firstname}  ${lastname}  ${address}  ${city}  ${telephone}
    Go To Find Owners Page
    Click Link    Add Owner
    Input First Name    ${firstname}
    Input Last Name     ${lastname}
    Input Address       ${address}
    Input City          ${city}
    Input Telephone     ${telephone}
    Click Button  Add Owner

Search For Owner
    [Arguments]   ${lastname}
    Go To Find Owners Page
    Input Text    lastName    ${lastname}
    Click Button  Find Owner

Input First Name
    [Arguments]  ${firstname}
    Input Text   firstName   ${firstname}

Input Last Name
    [Arguments]  ${lastname}
    Input Text   lastName   ${lastname}

Input Address
    [Arguments]  ${address}
    Input Text   address   ${address}

Input City
    [Arguments]  ${city}
    Input Text   city   ${city}

Input Telephone
    [Arguments]  ${telephone}
    Input Text   telephone   ${telephone}

Edit Owner
    [Arguments]  ${first}  ${last}  ${address}  ${city}  ${telephone}
    Click Edit Owner
    Input First Name     ${first}
    Input Last Name      ${last}
    Input Address        ${address}
    Input City           ${city}
    Input Telephone      ${telephone}
    Click Update Owner

Click Edit Owner
    Click Link      Edit Owner

Click Update Owner
    Click Button    Update Owner

Add New Pet
    [Arguments]   ${pet_name}  ${birth_date}  ${pet_type}
    Click Add New Pet
    Input Pet Name       ${pet_name}
    Input Birth Date     ${birth_date}
    Select Pet Type      ${pet_type}
    Click Add Pet

Click Add New Pet
    Click Link      Add New Pet

Input Pet Name
    [Arguments]   ${pet_name}
    Input Text    name    ${pet_name}

Input Birth Date
    [Arguments]   ${birth_date}
    Input Text    birthDate  ${birth_date}

Select Pet Type
    [Arguments]   ${pet_type}
    Select From List By Value    type    ${pet_type}

Click Add Pet
    Click Button    Add Pet

Edit Pet
    [Arguments]    ${name}  ${bdate}  ${type}
    Click Edit Pet
    Input Pet Name       ${name}
    Input Birth Date     ${bdate}
    Select Pet Type      ${type}
    Click Update Pet

Click Edit Pet
    Click Link     Edit Pet

Click Update Pet
    Click Button   Update Pet

Add Visit
    [Arguments]   ${visit_date}  ${visit_desc}
    Click Add Visit Link
    Input Visit Date              ${visit_date}
    Input Visit Description       ${visit_desc}
    Click Add Visit Button

Click Add Visit Link
    Click Link     Add Visit

Input Visit Date
    [Arguments]    ${visit_date}
    Input Text     date    ${visit_date}

Input Visit Description
    [Arguments]    ${visit_desc}
    Input Text     description    ${visit_desc}

Click Add Visit Button
    Click Button   Add Visit

URL Should Be
    [Arguments]  ${OWNER_ID}
    ${URL} =    Get Location
    Should Be Equal    ${URL}    ${OWNER_URL}${OWNER_ID}

