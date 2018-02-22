*** Settings ***
Documentation     Basic functionality tests for petclinic
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
${EDITED_FIRST}             Edited_first
${EDITED_LAST}              Edited_last
${EDITED_ADDRESS}           Edited_address
${EDITED_CITY}              Edited_city
${EDITED_TELEPHONE}         123456
${PET_NAME}                 Pluto
${BIRTH_DATE}               2018-02-02
${PET_TYPE}                 dog
${EDITED_PET_NAME}          Edited_hamster
${EDITED_BIRTH_DATE}        2018-02-03
${EDITED_PET_TYPE}          hamster
${VISIT_DATE}               2018-02-04
${VISIT_DESCRIPTION}        First checkout

*** Test Cases ***
Main Page Can Be Accessed
    Open Browser To Main Page

A New Owner Is Created
    Open Browser To Main Page
    Add New Owner    ${FIRST_NAME}  ${LAST_NAME}  ${ADDRESS}  ${CITY}  ${TELEPHONE}
    ${OWNER_ID} =     Owner Should Be In Database     ${FIRST_NAME}  ${LAST_NAME}  ${ADDRESS}  ${CITY}  ${TELEPHONE}
    URL Should Be    ${OWNER_ID}

Existing Owner Is Searched
    Open Browser To Main Page
    Add New Owner    ${FIRST_NAME}  ${LAST_NAME}  ${ADDRESS}  ${CITY}  ${TELEPHONE}
    ${OWNER_ID} =     Owner Should Be In Database     ${FIRST_NAME}  ${LAST_NAME}  ${ADDRESS}  ${CITY}  ${TELEPHONE}
    Search For Owner     ${LAST_NAME}
    URL Should Be        ${OWNER_ID}

Existing Owner Is Edited
    Open Browser To Main Page
    Add New Owner    ${FIRST_NAME}  ${LAST_NAME}  ${ADDRESS}  ${CITY}  ${TELEPHONE}
    Search For Owner     ${LAST_NAME}
    Edit Owner       ${EDITED_FIRST}  ${EDITED_LAST}  ${EDITED_ADDRESS}  ${EDITED_CITY}  ${EDITED_TELEPHONE}
    ${OWNER_ID} =     Owner Should Be In Database     ${EDITED_FIRST}  ${EDITED_LAST}  ${EDITED_ADDRESS}  ${EDITED_CITY}  ${EDITED_TELEPHONE}
    URL Should Be        ${OWNER_ID}

A New Pet Is Added
    Open Browser To Main Page
    Add New Owner    ${FIRST_NAME}  ${LAST_NAME}  ${ADDRESS}  ${CITY}  ${TELEPHONE}
    ${OWNER_ID} =     Owner Should Be In Database     ${FIRST_NAME}  ${LAST_NAME}  ${ADDRESS}  ${CITY}  ${TELEPHONE}
    Search For Owner     ${LAST_NAME}
    Add New Pet      ${PET_NAME}  ${BIRTH_DATE}  ${PET_TYPE}
    Pet Should Be In Database    ${PET_NAME}  ${BIRTH_DATE}  ${PET_TYPE}  ${OWNER_ID}

Existing Pet Is Edited
    Open Browser To Main Page
    Add New Owner    ${FIRST_NAME}  ${LAST_NAME}  ${ADDRESS}  ${CITY}  ${TELEPHONE}
    ${OWNER_ID} =    Owner Should Be In Database     ${FIRST_NAME}  ${LAST_NAME}  ${ADDRESS}  ${CITY}  ${TELEPHONE}
    Search For Owner     ${LAST_NAME}
    Add New Pet      ${PET_NAME}  ${BIRTH_DATE}  ${PET_TYPE}
    Edit Pet         ${EDITED_PET_NAME}  ${EDITED_BIRTH_DATE}  ${EDITED_PET_TYPE}
    Pet Should Be In Database    ${EDITED_PET_NAME}  ${EDITED_BIRTH_DATE}  ${EDITED_PET_TYPE}  ${OWNER_ID}

A New Visit Is Added
    Open Browser To Main Page
    Add New Owner    ${FIRST_NAME}  ${LAST_NAME}  ${ADDRESS}  ${CITY}  ${TELEPHONE}
    ${OWNER_ID} =    Owner Should Be In Database     ${FIRST_NAME}  ${LAST_NAME}  ${ADDRESS}  ${CITY}  ${TELEPHONE}
    Search For Owner              ${LAST_NAME}
    Add New Pet      ${PET_NAME}  ${BIRTH_DATE}  ${PET_TYPE}
    ${PET_ID} =    Pet Should Be In Database     ${PET_NAME}  ${BIRTH_DATE}  ${PET_TYPE}  ${OWNER_ID}
    Add Visit        ${VISIT_DATE}  ${VISIT_DESCRIPTION}
    Visit Should Be In Database     ${PET_ID}  ${VISIT_DATE}  ${VISIT_DESCRIPTION}
