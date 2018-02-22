*** Settings ***
Documentation     API tests for petclinic
Resource          resource.robot
Library           PetClinicLibrary.py
Test Setup        Restore Database
Test Teardown     Close Browser

*** Variables ***
${FIRST_NAME}               Tester
${LAST_NAME}                Testerino
${ADDRESS}                  Baker Street
${CITY}                     London
${TELEPHONE}                473737
${PET_NAME}                 Pluto
${BIRTH_DATE}               2018-02-02
${PET_TYPE}                 dog
${VISIT_DATE}               2018-02-04
${VISIT_DESCRIPTION}        First checkout

*** Test Cases ***
A New Owner Is Created Through API
    Create Owner Through API      ${FIRST_NAME}  ${LAST_NAME}  ${ADDRESS}  ${CITY}  ${TELEPHONE}
    Owner Should Be In Database   ${FIRST_NAME}  ${LAST_NAME}  ${ADDRESS}  ${CITY}  ${TELEPHONE}

A New Pet Is Added Through API
    Create Owner Through API     ${FIRST_NAME}  ${LAST_NAME}  ${ADDRESS}  ${CITY}  ${TELEPHONE}
    ${OWNER_ID} =     Owner Should Be In Database     ${FIRST_NAME}  ${LAST_NAME}  ${ADDRESS}  ${CITY}  ${TELEPHONE}
    Create Pet Through API       ${PET_NAME}  ${BIRTH_DATE}  ${PET_TYPE}  ${OWNER_ID}
    Pet Should Be In Database    ${PET_NAME}  ${BIRTH_DATE}  ${PET_TYPE}  ${OWNER_ID}

A New Visit Is Added Through API
    Create Owner Through API     ${FIRST_NAME}  ${LAST_NAME}  ${ADDRESS}  ${CITY}  ${TELEPHONE}
    ${OWNER_ID} =    Owner Should Be In Database     ${FIRST_NAME}  ${LAST_NAME}  ${ADDRESS}  ${CITY}  ${TELEPHONE}
    Create Pet Through API       ${PET_NAME}  ${BIRTH_DATE}  ${PET_TYPE}  ${OWNER_ID}
    ${PET_ID} =    Pet Should Be In Database     ${PET_NAME}  ${BIRTH_DATE}  ${PET_TYPE}  ${OWNER_ID}
    Create Visit Through API     ${VISIT_DATE}  ${VISIT_DESCRIPTION}  ${PET_ID}  ${OWNER_ID}
    Visit Should Be In Database  ${PET_ID}  ${VISIT_DATE}  ${VISIT_DESCRIPTION}

Create Owner Through API Validation
    Create Owner Through API     ${FIRST_NAME}  ${LAST_NAME}  ${ADDRESS}  ${CITY}  12345678910
    Owner Should Not Be In Database  ${FIRST_NAME}  ${LAST_NAME}  ${ADDRESS}  ${CITY}  12345678910

Create Pet Through API Validation
    Create Owner Through API     ${FIRST_NAME}  ${LAST_NAME}  ${ADDRESS}  ${CITY}  ${TELEPHONE}
    ${OWNER_ID} =    Owner Should Be In Database     ${FIRST_NAME}  ${LAST_NAME}  ${ADDRESS}  ${CITY}  ${TELEPHONE}
    Create Pet Through API       ${PET_NAME}  02-02-2018  ${PET_TYPE}  ${OWNER_ID}
    Pet Should Not Be In Database     ${PET_NAME}  02-02-2018  ${PET_TYPE}  ${OWNER_ID}

Create Visit Through API Validation
    Create Owner Through API     ${FIRST_NAME}  ${LAST_NAME}  ${ADDRESS}  ${CITY}  ${TELEPHONE}
    ${OWNER_ID} =    Owner Should Be In Database     ${FIRST_NAME}  ${LAST_NAME}  ${ADDRESS}  ${CITY}  ${TELEPHONE}
    Create Pet Through API       ${PET_NAME}  ${BIRTH_DATE}  ${PET_TYPE}  ${OWNER_ID}
    ${PET_ID} =    Pet Should Be In Database     ${PET_NAME}  ${BIRTH_DATE}  ${PET_TYPE}  ${OWNER_ID}
    Create Visit Through API     02-02-2018  ${VISIT_DESCRIPTION}  ${PET_ID}  ${OWNER_ID}
    Visit Should Not Be In Database  ${PET_ID}  02-02-2018  ${VISIT_DESCRIPTION}