*** Settings ***
Documentation      Try to Charging a improper sale and validate returned error
...                Messages
#Suite Teardown    Close Browser
Suite Setup        Create A Session
Resource          resourceApi.robot
Suite Tear Down   Delete All Sessions

*** Test Cases ***
Charge A Rejected Sale
	[Tags]   Api   Regression   Smoke
	#Session Created at the Test Setup. May be a suite setup later
    ${data}=   json.dumps   ${rejectdata}
    Log To Console   \nData that has been loaded is:\n${data}
    ${headers}=   Create Dictionary   Content-type=application/json
    ${resp}=   Post   CS   api/v1/charge/   data=${data}   headers=${headers}
	Log   ${resp}
    Should Be Equal As Strings   ${resp.status_code}   400
    #This section takes as json and below test case takes as text, json would be very handfull indeed.
    ${json}=   Set Variable   ${resp.json()}
    Log   ${json}
    Dictionary Should Contain Value   ${json}   Sale rejected due to fraud check result.   msg=No reject error detected, check the log file

Charge A Paid Sale
    [Tags]   Api   Regression   Smoke
    #Session Created at the Test Setup. May be a suite setup later
    ${data}=   json.dumps   ${paiddata}
    Log   ${data}
    Log To Console   \nData that has been loaded is:\n${data}
    ${headers}=   Create Dictionary   Content-type=application/json
    ${resp}=   Post   CS   api/v1/charge/   data=${data}   headers=${headers}
    Log   ${resp}
    Should Be Equal As Strings   ${resp.status_code}   400
    ${json}=   Set Variable   ${resp.text}
    Log   ${json}
    List Should Contain Value   ${json}   There is already succeeded sale transaction   msg=No reject error detected, check the log file


*** Keywords ***
#Deprecated will be removed, now using dictionary veriable coming with Robot FW 2.9
Get Test Datas   [Arguments]       ${filename}
    ${data}=   Get Binary File   ${CURDIR}/${filename}
    [return]   ${data}


*** Variables ***
&{rejectdata}=   sale=/api/v1/sale/96b4589817224babb3e681bbf07bf8b0/   number=4824894728063019   cvc=959   expiration=06/2017   card_holder_name=Robot Card Holder

&{paiddata}=   sale=/api/v1/sale/afc7816cf93141aab271c6d5f29f17e3/   number=4824894728063019   cvc=959   expiration=06/2017   card_holder_name=Robot Card Holder   secure_charge=False