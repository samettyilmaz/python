*** Settings ***
Documentation     This test suite aims to test Dashboards navigations in general.
Resource          resource.txt
Suite Setup       Open Browser To Login Page
Suite Teardown    Close Browser
Test Teardown     Log Location And Take Screenshot On Failure


*** Test Cases ***
Main Screen Navigation Items
	[Tags]   Regression   Dashboard
	Input Username   ${BASIC USER}
	Input Password   ${BASIC PASSWORD}
	Submit Credentials
	Welcome Page Should Be Open
	Page Should Contain   Sale Statistics
	Page Should Contain   Last Transactions


Sale Volumes By Currency Check
	[Tags]   Regression   Dashboard
	Statistics Chart Verify   Last 7 Days   ${timeoutCurrency}   ${TEST NAME}

	Statistics Chart Verify   Last 30 Days   ${timeoutCurrency}   ${TEST NAME}

	Statistics Chart Verify   This Year   ${timeoutCurrency}   ${TEST NAME}


Percentage of Sale Check
	[Tags]   Regression   Dashboard
	Percentage Chart Verify   xpath=(//a[contains(text(),'Last 7 Days')])[2]   ${timeoutPercentage}   ${TEST NAME}

	Percentage Chart Verify   xpath=(//a[contains(text(),'Last 30 Days')])[2]   ${timeoutPercentage}   ${TEST NAME}

	Percentage Chart Verify   xpath=(//a[contains(text(),'This Year')])[2]   ${timeoutPercentage}   ${TEST NAME}


Transaction Table Header Contents
	[Tags]   Regression   Dashboard
	:FOR   ${item}   IN   @{transaction_table}
	\      Table Header Verify   ${item}
	#Calling 'Table Header Verify' keyword for iterating over transaction_table header items defined in Keywords


Transaction Table Items Ordering
	[Tags]   Regression   Dashboard
	${last_transaction}=   Get Table Cell   css=table.paytrek-table   2   8   Log Level=TRACE
	${epoch1}=   Convert Date To Epoch   ${last transaction}
	${secondToLast_transaction}=   Get Table Cell   css=table.paytrek-table   3   8   Log Level=TRACE
	${epoch2}=   Convert Date To Epoch   ${secondToLast_transaction}
	Should Be True   ${epoch1}>=${epoch2}   msg=Transaction list is not ordered correctly
	Log To Console   \nLast transaction Date Time is ${last_transaction}
	Log To Console   \nSecond To Last transaction Date Time is ${secondToLast_transaction}


Transaction Table Redirection
	[Tags]   Regression   Dashboard
	${last_tnx_id}=   Get Table Cell   css=table.paytrek-table   2   1   Log Level=TRACE
	Click Element   link=${last_tnx_id}
	Title Should Be   paytrek | transaction detail
	Location Should Be   ${WELCOME URL}transactions/${last_tnx_id}
	Go Back


TEMP Sale Info Search and Verify
	[Tags]   Regression   Dashboard
	#Scan sales table headers and verifies
	Click Element   css=li.nav-link.dropdown
	Click Element   css=a > li
	Title Should Be   paytrek | sales
	:FOR   ${item}   IN   @{sale_table}
	\      Table Header Verify   ${item}

	${second_token}   Get Table Cell   css=table.paytrek-table   3   1   Log Level=TRACE
	#Takes second token from the sale table, search for it and verifies the result
	Input Text   id=id_search   ${second_token}
	Click Element   css=button.btn
	Register Keyword To Run On Failure   Log Location
	#Run Log Location on failure
	Location Should Contain   ${second_token}
	Table Cell Should Contain   css=table.paytrek-table   2   1   ${second_token}   Log Level=TRACE
	Go Back

	#Takes second order id from the sale table, search for it and verifies the result
	${second_order_id}   Get Table Cell   css=table.paytrek-table   3   2   Log Level=TRACE
	Input Text   id=id_search   ${second_order_id}
	Click Element   css=button.btn
	Register Keyword To Run On Failure   Log Location
	#Run Log Location on failure
	Location Should Contain   ${second_order_id}
	Table Cell Should Contain   css=table.paytrek-table   2   2   ${second_order_id}   Log Level=TRACE
	Go Back

	#Take first token from table, click and verify full detail of view
	${first_token}=   Get Table Cell   css=table.paytrek-table   2   1   Log Level=TRACE
	Click Element   link=${first_token}
	Register Keyword To Run On Failure   Log Location
	#Run 'Log Location' on failure
	Location Should Be   ${WELCOME URL}sales/${first_token}
	Click Element   css=span.action
	Select Window   paytrek | sale details
	#Below loop scans over 30 items and takes much time. Might be refactor. Exit for loop used for only scan through the specific item
	:FOR   ${item}   IN   @{sale_detail_table}
	\      Exit For Loop If   '${item}'=='commission'
	\      Table Column Verify   ${item}
	Select Window


Capture Sale Action
	[Tags]   Regression   Dashboard   Action
	#Scans sale table until find a capture action and clicks it for user verification pop-up and than confirms it
	Click Element   css=li.nav-link.dropdown
	Click Element   css=a > li
	Wait Until Page Contains Element   css=table.paytrek-table   timeout=3
	Find And Capture Sale   PreAuthorized


Cancel Sale Action
	[Tags]   Regression   Dashboard   Action
	#Scans sale table until find a cancel action and clicks it for user verification pop-up and than confirms it
	Click Element   css=li.nav-link.dropdown
	Click Element   css=a > li
	Wait Until Page Contains Element   css=table.paytrek-table   timeout=3
	Find And Cancel Sale   Paid













*** Variables ***
${timeoutCurrency}=     2
${timeoutPercentage}=   2
@{transaction_table}=   id   succeeded   info   pos   3d secure   type   amount   created at
#Paytrek Transaction Table elements in dashboard main page
@{sale_table}=   token   order-id   status   pos   channel   amount   created at   actions
#Paytrek Sale Table elements in dashboard sale page
@{sale_detail_table}=   secure_option   pos   half_secure   currency   billing_address   pre_auth   billing_country   max_retry_count   customer_last_name   locked_at   must_be_secure   billing_zipcode   cancel_url   penalty   commission   customer_ip_address   unlocked_at   channel   status   remittance_currency   customer_email   description   tags   order_id   must_pre_auth   expires_at   hosted_payment   has_failover_transaction   is_dcc_enabled   settlement_currency   account   billing_city   installment   refunded_amount   is_locked   created_at   max_secure_retry_count   modified_at   secondary_pos   retry_count   amount   billing_state   fraud_check_enabled   customer_first_name   return_url   secure_threshold
#Paytrek Full Sale Details Table elements in sale pop-up page




*** Keywords ***
Convert Date To Epoch
	[arguments]   ${date}
	${epoch_date}=   Convert Date   ${date}   result_format=epoch   date_format=%d %b %Y - %H:%M
	[return]   ${epoch_date}

Table Header Verify
	[arguments]   ${header_element}
	Table Header Should Contain   css=table.paytrek-table   ${header_element}   loglevel=TRACE

Table Column Verify
	[arguments]   ${column_element}
	Table Column Should Contain   css=table.paytrek-table   1   ${column_element}   loglevel=TRACE

Statistics Chart Verify
	[arguments]   ${day}   ${timeout}   ${test_name}
	Click Link   ${day}
	Wait Until Page Contains   Sale Volumes by Currency   timeout=${timeout}   error=Unable to load ${test_name} chart in ${timeout} seconds

Percentage Chart Verify
	[arguments]   ${day}   ${timeout}   ${test_name}
	Click Element   ${day}
	Wait Until Page Contains   Percentage of Sales   timeout=${timeout}   error=Unable to load ${test_name} chart in ${timeout} seconds


Sale Status Check
	[arguments]   ${sale_column}
	Table Column Should Contain   css=table.paytrek-table   3   ${sale_column}   loglevel=TRACE

Find And Capture Sale
	#Scans the sale table for the given ${item} (status of sale) and captures the sale, if not, calls the next page keyword to scan next sale table items
	[arguments]   ${item}
	${index}=   Set Variable   ${2}
	:FOR   ${index}   IN RANGE   2   32
	\      ${status}=   Get Table Cell   css=table.paytrek-table   ${index}   3
	\      Run Keyword If   '${item}'=='${status}'   Exit For Loop   ELSE IF   ${index}==31   Next Page Capture
	Capture Sale   ${index}

Find And Cancel Sale
	#Scans the sale table for the given ${item} (status of sale) and cancels the sale, if not, calls the 'next page' keyword to scan next sale table items
	[arguments]   ${item}
	${index}=   Set Variable   ${2}
	:FOR   ${index}   IN RANGE   2   32
	\      ${status}=   Get Table Cell   css=table.paytrek-table   ${index}   3
	\      Run Keyword If   '${item}'=='${status}'   Exit For Loop   ELSE IF   ${index}==31   Next Page Cancel
	Cancel Sale   ${index}

Next Page Capture
	#goes to next page of sale table
	Click Link   Next
	Log Location
	Find And Capture Sale   PreAuthorized

Next Page Cancel
	#goes to next page of sale table
	Click Link   Next
	Log Location
	Find And Cancel Sale   Paid

Capture Sale
	[arguments]   ${capture_index}
	${capture_order_id}=   Get Table Cell   css=table.paytrek-table   ${capture_index}   2
	Log   \nTry to capturing sale with order Id ${capture_order_id}   console=yes
	Click Element   css=.paytrek-table > tbody:nth-child(2) > tr:nth-child(${capture_index-1}) > td:nth-child(8) > a:nth-child(2)
	Confirm Action
	Page Should Contain   Sale ${capture_order_id} successfully captured
	#Some Preauthorized sales are expired and raises an error. Should be handeled.

Cancel Sale
	[arguments]   ${cancel_index}
	${cancel_order_id}=   Get Table Cell   css=table.paytrek-table   ${cancel_index}   2
	Log   \nTry to canceling sale with order Id ${cancel_order_id}   console=yes
	Click Element   css=.paytrek-table > tbody:nth-child(2) > tr:nth-child(${cancel_index-1}) > td:nth-child(8) > a:nth-child(1)
	Confirm Action
	Page Should Contain   Sale ${cancel_order_id} successfully cancelled





