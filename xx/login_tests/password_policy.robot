*** Settings ***
Documentation     This test suite aims to test password policy against requirements.
Resource          resource.txt
Suite Setup       Open Browser To Password Page
Suite Teardown    Close Browser
#Test Template     Define Password Against Password Policy




*** Test Cases ***    Invalid Password    Expired Password
Lower Case Warning
	[Tags]   Regression   Dashboard
	${lower}=   Generate Random String   8   [LOWER]
	Log   ${lower}
	Define Password Against Password Policy   ${lower}   ${EXPIRED PASSWORD}

Upper Case Warning
	[Tags]   Regression   Dashboard
	${upper}=   Generate Random String   8   [UPPER]
	Log   ${upper}
	Define Password Against Password Policy   ${upper}   ${EXPIRED PASSWORD}

Number Warning
	[Tags]   Regression   Dashboard
	${number}=   Generate Random String   8   [NUMBERS]
	Log   ${number}
	Define Password Against Password Policy   ${number}   ${EXPIRED PASSWORD}

Lower Than 8 Characters
	[Tags]   Regression   Dashboard
	${7chars}=   Generate Random String   7
	Log   ${7chars}
	Input Text   id=id_old_password   ${EXPIRED PASSWORD}
	Input Text   id=id_password   ${7chars}
	Input Text   id=id_password_2   ${7chars}
	Click Button    Save
	Page Should Contain   Ensure this value has at least 8 characters (it has 7).

Username Including Warning 1
	[Tags]   Regression   Dashboard
	${string}=   Generate Random String   7   [NUMBERS][LETTERS]
	Log    ${string}
	${userpass}=   Catenate   SEPARATOR=   ${EXPIRED USER}   ${string}
	Log   ${userpass}
	Define Password Against Password Policy   ${userpass}   ${EXPIRED PASSWORD}

Username Including Warning 2
	[Tags]   Regression   Dashboard
	${string}=   Generate Random String   7   [NUMBERS][LETTERS]
	Log    ${string}
	${userpass}=   Catenate   SEPARATOR=   ${string}   ${EXPIRED USER}
	Log   ${userpass}
	Define Password Against Password Policy   ${userpass}   ${EXPIRED PASSWORD}

Name Including Warning
	[Tags]   Regression   Dashboard
	${string}=   Generate Random String   7   [NUMBERS][LETTERS]
	Log    ${string}
	${userpass}=   Catenate   SEPARATOR=   ${EXPIRED NAME}   ${string}
	Log   ${userpass}
	Define Password Against Password Policy   ${userpass}   ${EXPIRED PASSWORD}

Surname Including Warning
	[Tags]   Regression   Dashboard
	${string}=   Generate Random String   7   [NUMBERS][LETTERS]
	Log    ${string}
	${userpass}=   Catenate   SEPARATOR=   ${EXPIRED SURNAME}   ${string}
	Log   ${userpass}
	Define Password Against Password Policy   ${userpass}   ${EXPIRED PASSWORD}





**** Keywords ***
Define Password Against Password Policy
	[Arguments]      ${new_password}   ${EXPIRED PASSWORD}
	Input Text   id=id_old_password   ${EXPIRED PASSWORD}
	Input Text   id=id_password   ${new_password}
	Input Text   id=id_password_2   ${new_password}
	Click Button    Save
	Password Update Should Have Failed


