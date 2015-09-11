*** Settings ***
Documentation       Verifies Charge Resource validations are working.

Suite Setup       Create A Session
Resource          resourceApi.robot
Suite Tear Down   Delete All Sessions





*** Test Case ***
Invalid Token
	[Tags]   Regression   Smoke   Api
	${random_token} =   faker.Md 5
    Log   ${random_token}
    Charge Request   ${random_token}
    Should Be Equal As Strings   @{returned}[0]   400
    #This section takes as json and below test case takes as text, json would be very handfull indeed.
    Dictionary Should Contain Value   @{returned}[1]   Could not find the provided object via resource URI '/api/v1/sale/${random_token}/'.   msg=No ${TEST NAME} error detected, check the log file

Empty Card Holder Name
    [Tags]   Regression   Smoke   Api
    Charge Request   card_holder=${EMPTY}
    Should Be Equal As Strings   @{returned}[0]   400
    #This section takes as json and below test case takes as text, json would be very handfull indeed.
    Dictionary Should Contain Value   @{returned}[1]   Please enter a valid card holder name   msg=No ${TEST NAME} error detected, check the log file

Empty Card Holder Name - Empty String
    [Tags]   Regression   Smoke   Api
    Charge Request   card_holder=${SPACE}
    #${SPACE} is a built in empty string default keyword
    Should Be Equal As Strings   @{returned}[0]   400
    #This section takes as json and below test case takes as text, json would be very handfull indeed.
    Dictionary Should Contain Value   @{returned}[1]   Please enter a valid card holder name   msg=No ${TEST NAME} error detected, check the log file

Empty Credit Card Number
    [Tags]   Regression   Smoke   Api
    Charge Request   number=${EMPTY}
    Should Be Equal As Strings   @{returned}[0]   400
    #This section takes as json and below test case takes as text, json would be very handfull indeed.
    Dictionary Should Contain Value   @{returned}[1]   Please enter a valid card number.   msg=No ${TEST NAME} error detected, check the log file

Empty Credit Card Number - Empty String
    [Tags]   Regression   Smoke   Api
    Charge Request   number=${SPACE}
    Should Be Equal As Strings   @{returned}[0]   400
    #This section takes as json and below test case takes as text, json would be very handfull indeed.
    Dictionary Should Contain Value   @{returned}[1]   Please enter a valid card number.   msg=No ${TEST NAME} error detected, check the log file

Invalid Credit Card Number Master/Visa
    [Tags]   Regression   Smoke   Api
    ${random_card} =   Generate Random String   16   [NUMBERS]
    ${faker_card}=   faker.Credit Card Number   card_type=visa   validate=True   max_check=9
    Log To Console   \n Fake Card ${faker_card}
    Charge Request   number=${random_card}
    Should Be Equal As Strings   @{returned}[0]   400
    #This section takes as json and below test case takes as text, json would be very handfull indeed.
    Dictionary Should Contain Value   @{returned}[1]   Please enter a valid card number.   msg=No ${TEST NAME} error detected, check the log file

Invalid Credit Card Number Amex
    [Tags]   Regression   Smoke   Api
    ${random_card} =   Generate Random String   15   [NUMBERS]
    Charge Request   number=${random_card}
    Should Be Equal As Strings   @{returned}[0]   400
    #This section takes as json and below test case takes as text, json would be very handfull indeed.
    Dictionary Should Contain Value   @{returned}[1]    Please enter a valid card number.   msg=No ${TEST NAME} error detected, check the log file

Invalid Expiration Dates
    [Tags]   Regression   Smoke   Api
    ${expiry1}=   faker.Credit Card Expire   start=now   date_format=%B/%Y
    ${expiry2}=   faker.Credit Card Expire   star=now   date_format=%m/%y
    ${expiry3}=   faker.Credit Card Expire   star=now   date_format=%b/%Y
    ${expiry4}=   faker.Credit Card Expire   star=now   date_format=%b/%y
    ${expiry5}=   Set Variable   /
    @{expiries}=   Create List   ${expiry1}   ${expiry2}   ${expiry3}   ${expiry4}   ${expiry5}
    :FOR   ${days}   IN   @{expiries}
    \      Charge Request   expiration=${days}
    \      Should Be Equal As Strings   @{returned}[0]   400
    #This section takes as json and below test case takes as text, json would be very handfull indeed.
    \      #${json}=   Set Variable   ${resp.json()}
    \      Dictionary Should Contain Value   @{returned}[1]   Please enter a valid expiration date (MM/YY).   msg=No ${TEST NAME} error detected, check the log file








*** Variables ***
&{sample_data}=   sale=api/v1/sale/96b4589817224babb3e681bbf07bf8b0/   number=4824894728063019   cvc=959   expiration=06/2017   card_holder_name=Robot Card Holder   secure_charge=False



*** Keywords ***
Charge Request   [Arguments]   ${token}=${valid_token}   ${card_holder}=Robot Card Holder   ${number}=4824894728063019   ${cvc}=959   ${expiration}=06/2017   ${secure_charge}=False
#Default values of arguments are defined.
    Set To Dictionary   ${sample_data}   sale=/api/v1/sale/${token}/
    Set To Dictionary   ${sample_data}   card_holder_name=${card_holder}
    Set To Dictionary   ${sample_data}   number=${number}
    Set To Dictionary   ${sample_data}   cvc=${cvc}
    Set To Dictionary   ${sample_data}   expiration=${expiration}
    Set To Dictionary   ${sample_data}   secure_charge=${secure_charge}
    ${data}=   json.dumps   ${sample_data}
    Log To Console   \nData that has been loaded is:\n${data}
    ${headers}=   Create Dictionary   Content-type=application/json
    ${resp}=   Post   CS   api/v1/charge/   data=${data}   headers=${headers}
    Log   ${resp}
    #${body}   ${html_status}=   Create List   ${resp.json()}
    @{returned}=   Create List   ${resp.status_code}   ${resp.json()}
    Set Test Variable   @{returned}
    [return]   @{returned}



