*** Settings ***
Documentation     Validation tests for input fields
Resource          resource.robot
Library           PetClinicLibrary.py
Test Setup        Restore Database
Test Teardown     Close Browser

*** Variables ***
${PET_TYPE}       bird
${OWNER_NAME1}    testfirst
${OWNER_NAME2}    testlast
${OWNER_ADDRESS}  testlast
${OWNER_CITY}     testcity
${OWNER_PHONE}    123456
${PET_NAME}       Pettie
${PET_BDATE}      2018-02-02
${PET_TYPE}       dog
${VISIT_DESC}     test123

*** Test Cases ***
Owner Input
    [Template]  Owner Is Created With Invalid Input
    ${EMPTY}    ${EMPTY}    ${EMPTY}    ${EMPTY}    ${EMPTY}
    First       Last        Address     City        abc
    First       Last        Address     City        12345678910
    [Teardown]  Close Browser

Pet Input
    [Template]  Pet Is Created With Invalid Input
    ${EMPTY}         ${EMPTY}
    ${PET_NAME}      abc
    ${PET_NAME}      5.2.2018
    ${PET_NAME}      05-02-2018
    [Teardown]       Close Browser

Visit Input
    [Template]  Visit Is Created With Invalid Input
    ${EMPTY}         ${EMPTY}
    abc              ${VISIT_DESC}
    5.2.2018         ${VISIT_DESC}
    05-02-2018       ${VISIT_DESC}
    [Teardown]       Close Browser

*** Keywords ***
Owner Is Created With Invalid Input
    [Arguments]     ${first_name}  ${last_name}  ${address}  ${city}  ${telephone}
    Open Browser To Main Page
    Add New Owner   ${first_name}  ${last_name}  ${address}  ${city}  ${telephone}
    ${URL} =        Get Location
    Should Be Equal    ${URL}    ${NEW_OWNER_URL}
    [Teardown]      Close Browser

Pet Is Created With Invalid Input
    [Arguments]     ${pet_name}  ${birth_date}
    Restore Database
    Open Browser To Main Page
    Add New Owner   ${OWNER_NAME1}  ${OWNER_NAME2}  ${OWNER_ADDRESS}  ${OWNER_CITY}  ${OWNER_PHONE}
    ${OWNER_ID} =   Owner Should Be In Database    ${OWNER_NAME1}  ${OWNER_NAME2}  ${OWNER_ADDRESS}  ${OWNER_CITY}  ${OWNER_PHONE}
    Add New Pet     ${pet_name}  ${birth_date}  ${PET_TYPE}
    ${URL} =        Get Location
    Should Be Equal    ${URL}    ${OWNER_URL}${OWNER_ID}/pets/new
    [Teardown]      Close Browser

Visit Is Created With Invalid Input
    [Arguments]      ${date}  ${desc}
    Restore Database
    Open Browser To Main Page
    Add New Owner    ${OWNER_NAME1}  ${OWNER_NAME2}  ${OWNER_ADDRESS}  ${OWNER_CITY}  ${OWNER_PHONE}
    ${OWNER_ID} =    Owner Should Be In Database    ${OWNER_NAME1}  ${OWNER_NAME2}  ${OWNER_ADDRESS}  ${OWNER_CITY}  ${OWNER_PHONE}
    Add New Pet      ${PET_NAME}  ${PET_BDATE}  ${PET_TYPE}
    ${PET_ID} =      Pet Should Be In Database    ${PET_NAME}  ${PET_BDATE}  ${PET_TYPE}  ${OWNER_ID}
    Add Visit        ${date}  ${desc}
    ${URL} =         Get Location
    Should Be Equal  ${URL}    ${OWNER_URL}${OWNER_ID}/pets/${PET_ID}/visits/new
    [Teardown]       Close Browser