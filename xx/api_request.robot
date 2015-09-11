*** settings ***
Library  Collections
Library  requests


*** test cases ***
simpleRequest
    ${result} =   Get   http://echo.jsontest.com/framework/robot-framework/api/rest
    Should Be Equal   ${result.status_code}   ${200}
    ${json} =   Set Variable   ${result.json()}
    ${framework} =   Get From Dictionary   ${json}   framework
    Should Be Equal   ${framework}   robot-framework
    ${api} =   Get From Dictionary   ${json}   api
    Should Be Equal   ${api}   rest

dsadnasd dfmdsşfmdslmdsfmsdfkm