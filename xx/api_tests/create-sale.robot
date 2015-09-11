*** Settings ***
Documentation     Creating a sale with validations

#Suite Teardown   Close Browser
Suite Setup       Create A Session
Resource          resourceApi.robot
Suite Tear Down   Delete All Sessions

*** Test Cases ***
Create A New Sale
	[Tags]   Api   Regression

    ${ip_v4}=   faker.Ipv 4
    ${md5}=   faker.md5
    ${email}=   faker.Email
    ${datetime}=   Get Current Date   result_format=%d-%m-%Y-%H-%M-%S   exclude_millis=True
    Log   ${datetime}
    ${orderid}=   Catenate   SEPARATOR=--   Luna-robot   ${datetime}
    Log   ${orderid}


    Set To Dictionary   ${data}   customer_email=${email}
    Set To Dictionary   ${data}   order_id=${orderid}
    Set To Dictionary   ${data}   customer_ip_address=${ip_v4}
    Set To Dictionary   ${data}   half_secure=True
    Set To Dictionary   &{mdddict}   1=Nikolay
    Log To Console   \n mdd Dictionary value 1 is: &{mdddict}[1]
    # Should be handeled.
    Log Dictionary   ${data}
    ${json_data}=   json.dumps   ${data}
    ${headers}=   Create Dictionary   Content-type=application/json

    ${resp}=  Post Request   CS   api/v1/sale/   data=${json_data}   headers=${headers}
	Log   ${resp}

    Should Be Equal As Strings   ${resp.status_code}   201
    ${json}=   Set Variable   ${resp.json()}
    Log   ${json}
    Dictionary Should Contain Item   ${json}   status   Incomplete   msg=Unable to verify status as Incomplete
    Dictionary Should Contain Key    ${json}   token   msg=No token detected
    Dictionary Should Contain Item   ${json}   order_id   ${orderid}   msg=No orderId match


No Currency Validation
    Set To Dictionary   ${data}   currency=${EMPTY}
    Should Be Equal As Strings   ${resp.status_code}   400

First Name Validation
    ${random_name}=   Generate Random String   lenght=61   chars=[LETTERS]
    Set To Dictionary   ${data}   customer_first_name=${random_name}




*** Keywords ***
#Deprecated, can be removed.
Get Test Datas   [Arguments]       ${filename}
    ${cs}=   Get Binary File   ${CURDIR}/${filename}
    [return]   ${cs}



*** Variables ***
#Generating static test dictionary(dictionary in dictionary and list in dictionary) below
&{data}   pos=/api/v1/pos/otel-gc/   amount=299.00   currency=/api/v1/currency/USD/   order_id=Nst-Luna-0240230620151429   max_retry_count=5   installment=1   is_dcc_enabled=False   pre_auth=False   fraud_check_enabled=True   half_secure=False   secure_option=No   sale_data=${extra_sale_data}   customer_first_name=Angel Di    customer_last_name=Maria   customer_email=mustafa.tasli@paytrek.com   customer_ip_address=201.101.26.242    billing_address=1295 Charleston    billing_city=Mountain View   billing_state=CA    billing_country=US    billing_zipcode=34845

&{extra_sale_data}   submerchantname=nesatsubmerchav02   cybersource=${cybersourcedict}   payment_methods=${paymentlist}
@{paymentlist}   unionpay
&{cybersourcedict}   mddFields=${mdddict}
&{mdddict}   1=Nesat   2=Ufuk   3=Turkey   98=4
