*** Settings ***
Documentation     A resource file with reusable keywords and variables.
...
...               The system specific keywords created here form our own
...               domain specific language. They utilize keywords provided
...               by the imported Selenium2Library.
Library           RequestsLibrary
Library           String
Library           Collections
Library           OperatingSystem
Library           json
Library           FakerLibrary   With Name   faker
Library           DateTime

*** Variables ***
${SERVER}           https://sandbox.paytrek.com/
#${BROWSER}          Firefox
#${DELAY}            0
${API USER}         test
${API PASSWORD}     test1234
#${LOGIN URL}       ${SERVER}
#${WELCOME URL}      https://luna.met.ms/dashboard/



*** Keywords ***
Create A Session
	[Documentation]   Creating a CS called session with API USER and API PASSWORD in variables
	${auth}=   Create List   ${API USER}   ${API PASSWORD}
	Log   ${auth}
	Create Session   CS   ${SERVER}   auth=${auth}   verify=False


*** Variables ***
#On the next release may be a db connection or read from file
${valid_token}=   1b39b0d0d1b746a4bc09d9b387937915
