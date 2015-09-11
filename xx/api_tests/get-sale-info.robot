*** Settings ***
Documentation       Getting a sale info

Suite Setup       Create A Session
Resource          resourceApi.robot
Suite Tear Down   Delete All Sessions





*** Test Case ***
Unknown Sale Info
	[Tags]   Get   Regression
	#Session created from resource file
	Create A Session
	${random token} =   Generate Random String   32   [LOWER][NUMBERS]
	${resp}=   Get   CS   api/v1/sale/${random token}/
	Log To Console   \nTry to get info of random generated token: ${random token}
	Log   ${resp}
    Should Be Equal As Strings   ${resp.status_code}   404

Validate A Sale Info
	[Tags]   Get   Regression
	Create A Session
	${resp}=   Get   CS   api/v1/sale/${valid_token}/
	Log To Console   \nTry to get info of a valid token: ${valid_token}
	Log   ${resp}
    Should Be Equal As Strings   ${resp.status_code}   200
    ${json}=   Set Variable   ${resp.text}
    Log   ${json}
    List Should Contain Value   ${json}   transactions   msg=Unable to find Transactions
    List Should Contain Value   ${json}   max_retry_count   msg=Unable to find max retry count
    List Should Contain Value   ${json}   paytrek_ref_id   msg=Unable to find Paytrek Ref Id
    #Log To Console   ${SUITE NAME}
