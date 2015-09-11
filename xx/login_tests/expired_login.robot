*** Settings ***
Documentation     A test suite containing tests related to password expiry policy.
...               User should have to update his/her password in a 30 days cycle.


Suite Setup       Open Browser To Login Page
Suite Teardown    Close Browser
Test Setup        Go To Login Page
Resource          resource.txt

*** Test Cases ***
Expired Password Message
	[Tags]   Regression   Dashboard
    Input Username    ${EXPIRED USER}
	Input Password     ${EXPIRED PASSWORD}
	#This is a user defined keyword, not the default Selenium library one
	Log To Console    \nTry to login with ${EXPIRED USER}
	Submit Credentials
	Log Location
	Log Title
	Login Page Should Be Open
	Page Should Contain   Your password is older than 30 days. Please update your password for your             own security.
	Page Should Contain Element   id=id_old_password   message=No Old Password Field
	Page Should Contain Element   id=id_password   message=No new password field
	Page Should Contain Element   id=id_password_2   message=No validation field
