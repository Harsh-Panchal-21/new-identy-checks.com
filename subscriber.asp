<%
Option Explicit
Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cache"
'Response.AddHeader "cache-control", "private"
Response.Expires = -1 
%>
<!--#include file="adovbs.inc" -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<!--#include virtual="db_constants.fun" -->
<!--#include file="head19.asp" -->
<!--#include virtual="rc4.inc"-->
<%
dim msg, name,	division,	address,	city,	state,	zip,	contact_name,	title,	phone,	fax,	email
dim	no_employees,	no_est_hired_2_months,	no_est_hired_12_months,	business_type,	yrs_in_business,	website
dim company_type,	state_of_inc,	owner_name1,	owner_title1,	owner_name2,	owner_title2,	referral,	person_name
dim person_phone,	person_email,	person_fax,	ap_name,	ap_phone,	ap_email,	ap_fax,	invoice1
msg=request("msg")

Function CheckCAPTCHA(valCAPTCHA)
	dim SessionCAPTCHA
	SessionCAPTCHA = Trim(Session("CAPTCHA"))
	Session("CAPTCHA") = vbNullString
	if Len(SessionCAPTCHA) < 1 then
        CheckCAPTCHA = False
        exit function
    end if
	if CStr(SessionCAPTCHA) = CStr(valCAPTCHA) then
	    CheckCAPTCHA = True
	else
	    CheckCAPTCHA = False
	end if
End Function

Response.write "<!-- Session CAPTCHA: " & Trim(Session("CAPTCHA")) & " -->" & vbCrLf
Response.write "<!-- CAPTCHA: " & Request.Form("strCAPTCHA") & " -->" & vbCrLf



If request.form("submit1") = "Continue" then
	name = Request("name")	'company1
	division = Request("division")	'company2
	address = Request("address")	'company3
	city = Request("city")	'company4
	state = Request("state")	'company5
	zip = Request("zip")	'company6
	contact_name = Request("contact_name")	'company7
	title = Request("title")	'company8
	phone = Request("phone")	'company9
	fax = Request("fax")	'company10.
	email = Request("email")	'company11
	no_employees = Request("no_employees")	'company12
	no_est_hired_2_months = Request("no_est_hired_2_months")	'company13
	no_est_hired_12_months = Request("no_est_hired_12_months")	'company14
	business_type = Request("business_type")	'company15
	yrs_in_business = Request("yrs_in_business")		'company16
	website = Request("website")	'company17
	company_type = Request("company_type")	'company18
	state_of_inc = Request("state_of_inc")	'company19
	owner_name1 = Request("owner_name1")	'owners1
	owner_title1 = Request("owner_title1")	'owners2
	owner_name2 = Request("owner_name2")	'owners3
	owner_title2 = Request("owner_title2")	'owners4
	referral = Request("referral")	'owners5
	person_name = Request("person_name")	'person1
	person_phone = Request("person_phone")	'person2
	person_email = Request("person_email")	'person3
	person_fax = Request("person_fax")	'person4
	ap_name = Request("ap_name")	'accounts1
	ap_phone = Request("ap_phone")	'accounts2
	ap_email = Request("ap_email")	'accounts3
	ap_fax = Request("ap_fax")	'accounts4
  invoice1 = Request("invoice1")

  Dim sSignature, sPrintedName, sSignTitle, sSignDate, sCompanyFEIN
  sSignature = Request("txtSignature")
  sPrintedName = Request("txtSignPrintedName")
  sSignTitle = Request("txtSignTitle")
  sSignDate = Request("txtSignDate")
  sCompanyFEIN = Request("txtCompanyFEIN")

  if not CheckCAPTCHA(Trim(Request.Form("strCAPTCHA"))) then
    msg = "Incorrect characters entered."
	elseif name = "" or address = "" or city = "" or state = ""  _
	 or zip = "" or contact_name = "" or phone = ""  _
	 or fax = "" or email = "" or sSignature = "" or sPrintedName = "" _
   or sSignTitle = "" or sSignDate = "" or sCompanyFEIN = "" then
		msg=" Please go back and complete all required fields."
  elseif not isDate(sSignDate) then
    msg = "Please provide a valid Signature Date"
	else
		dim ObjRec, StrConnect
		Set ObjRec=Server.CreateObject("ADODB.RecordSet")
		StrConnect="Provider=SQLOLEDB.1; Data Source= " & db_machine & "; User ID=" & db_userid & "; Password=" & db_password & "; Initial Catalog=" & db_database

		ObjRec.CursorLocation = 3
		ObjRec.Open "subscriber", StrConnect, adOpenStatic, adLockOptimistic, adCmdTable

		ObjRec.AddNew
		ObjRec("date1") = now()
		ObjRec("name") = name
		ObjRec("division") = division
		ObjRec("address") = address
		ObjRec("city") = city
		ObjRec("state") = state
		ObjRec("zip") = zip
		ObjRec("contact_name") = contact_name
		ObjRec("title") = title
		ObjRec("phone") = phone
		ObjRec("fax") = fax
		ObjRec("email") = email
		ObjRec("no_employees") = no_employees
		ObjRec("no_est_hired_2_months") = no_est_hired_2_months
		ObjRec("no_est_hired_12_months") = no_est_hired_12_months
		ObjRec("business_type") = business_type
		ObjRec("yrs_in_business") = yrs_in_business
		ObjRec("website") = website
		ObjRec("company_type") = company_type
		ObjRec("state_of_inc") = state_of_inc
		ObjRec("company_type") = company_type
		ObjRec("state_of_inc") = state_of_inc
		ObjRec("owner_name1") = owner_name1
		ObjRec("owner_title1") = owner_title1
		ObjRec("owner_name2") = owner_name2
		ObjRec("owner_title2") = owner_title2
		ObjRec("referral") = referral
		ObjRec("person_name") = person_name
		ObjRec("person_phone") = person_phone
		ObjRec("person_email") = person_email
		ObjRec("person_fax") = person_fax
		ObjRec("ap_name") = ap_name
		ObjRec("ap_phone") = ap_phone
		ObjRec("ap_email") = ap_email
		ObjRec("ap_fax") = ap_fax

		ObjRec("invoice1")  =invoice1

    ObjRec("signature") = sSignature
    ObjRec("printed_name") = sPrintedName
    ObjRec("sign_title") = sSignTitle
    ObjRec("sign_date") = sSignDate
    ObjRec("company_fein") = sCompanyFEIN

		ObjRec.Update

		dim ObjRec1
		Set ObjRec1=Server.CreateObject("ADODB.RecordSet")
		ObjRec1.CursorLocation = 3
		ObjRec1.Open "Users", StrConnect, adOpenStatic, adLockOptimistic, adCmdTable

		ObjRec1.AddNew
		ObjRec1("company_id") = ObjRec("company_id")
		ObjRec1("UserID") = email	'company11

    dim trackid, D1, D2, D3
		D1 = Fix(Rnd * 100000) + 1
		D2 = Fix(Rnd * 100000) + 1
		D3 = Fix(Rnd * 100000) + 1
		trackid= D1+D2+D3
		ObjRec1("Password") = trackid
		ObjRec1("Name") = contact_name	'company7
		ObjRec1("Email") = email	'company11
		ObjRec1("level1") = "1"
		ObjRec1("company") = name	'Company1
    ObjRec1("AcceptFCRA") = "N"
    ObjRec1("EncryptedPassword") = "N"
    ObjRec1("Date1") = sSignDate
		ObjRec1.Update

    session("validuser")= True 
		session("name") = contact_name
		Session("UserID") = email
		Session("company") = name
		Session("company_rid") = ObjRec("company_id")
		Session("ucc_app") = "N"
    session("pass") = trackid
    'session("enc_pass") = enc_pass

    dim body
		body= "<html><head><title>New Identi-Check Candidate Submission</title></head></body>"  & vbCrLf
		body= body & "<table cellpadding=1 cellspacing=0 border=1>"  & vbCrLf
		body= body & "<tr><td>Company Name</td><td>" & name & "</td></tr>" & vbCrLf
		body= body & "<tr><td>Division</td><td>" & division & "</td></tr>" & vbCrLf
		body= body & "<tr><td>Address</td><td>" & address & "</td></tr>" & vbCrLf
		body= body & "<tr><td>City, ST Zip</td><td>" & city & ", " & state & " " & zip &  "</td></tr>" & vbCrLf
		body= body & "<tr><td colspan=2><b>Contact Information</b></td></tr>" & vbCrLf
		body= body & "<tr><td>Contact Name</td><td>" & contact_name & "</td></tr>" & vbCrLf
		body= body & "<tr><td>Title</td><td>" & title & "</td></tr>" & vbCrLf
		body= body & "<tr><td>Phone</td><td>" & phone & "&nbsp;</td></tr>" & vbCrLf
		body= body & "<tr><td>Fax</td><td>" & fax & "&nbsp;</td></tr>" & vbCrLf
		body= body & "<tr><td>Email</td><td>" & email & "&nbsp;</td></tr>" & vbCrLf
		body= body & "<tr><td colspan=2>&nbsp;</td></tr>" & vbCrLf
		body= body & "<tr><td>No. Employees</td><td>" & no_employees & "&nbsp;</td></tr>" & vbCrLf
		body= body & "<tr><td>Emp Est Hired 2 Months</td><td>" & no_est_hired_2_months & "&nbsp;</td></tr>" & vbCrLf
		body= body & "<tr><td>Emp Est Hired 2 Months</td><td>" & no_est_hired_12_months & "&nbsp;</td></tr>" & vbCrLf
		body= body & "<tr><td>Business Type</td><td>" & business_type & "&nbsp;</td></tr>" & vbCrLf
		body= body & "<tr><td>Website</td><td>" & website & "&nbsp;</td></tr>" & vbCrLf
		body= body & "<tr><td>Type of Company</td><td>" & company_type & "&nbsp;</td></tr>" & vbCrLf
		body= body & "<tr><td>State of Incorporation</td><td>" & state_of_inc & "&nbsp;</td></tr>" & vbCrLf
		body= body & "<tr><td colspan=2><b>Owners and/or Executives of Company</b></td></tr>" & vbCrLf
		body= body & "<tr><td>1.&nbsp;&nbsp;Name</td><td>" & owner_name1 & "&nbsp;Title:&nbsp;" & owner_title1 & "</td></tr>" & vbCrLf
		body= body & "<tr><td>2.&nbsp;&nbsp;Name</td><td>" & owner_name2 & "&nbsp;Title:&nbsp;" & owner_title2 & "</td></tr>" & vbCrLf
		body= body & "<tr><td>Referral From</td><td>" & referral & "&nbsp;</td></tr>" & vbCrLf
		body= body & "<tr><td colspan=2><b>Person Responsible for Payment Approval</b></td></tr>" & vbCrLf
		body= body & "<tr><td>Name</td><td>" & person_name & "&nbsp;</td></tr>" & vbCrLf
		body= body & "<tr><td>Phone</td><td>" & person_phone & "&nbsp;</td></tr>" & vbCrLf
		body= body & "<tr><td>Fax</td><td>" & person_fax & "&nbsp;</td></tr>" & vbCrLf
		body= body & "<tr><td>Email</td><td>" & person_email & "&nbsp;</td></tr>" & vbCrLf
		body= body & "<tr><td colspan=2><b>Account Payable Contact</b></td></tr>" & vbCrLf
		body= body & "<tr><td>Name</td><td>" & ap_name & "&nbsp;</td></tr>" & vbCrLf
		body= body & "<tr><td>Phone</td><td>" & ap_phone & "&nbsp;</td></tr>" & vbCrLf
		body= body & "<tr><td>Fax</td><td>" & ap_fax & "&nbsp;</td></tr>" & vbCrLf
		body= body & "<tr><td>Email</td><td>" & ap_email & "&nbsp;</td></tr>" & vbCrLf
		body= body & "</table>" & vbCrLf
		body= body & "</body></html>" & vbCrLf

    dim Mailer
		Set Mailer=Server.CreateObject("CDONTS.NewMail")
		Mailer.To="jennifer@identi-check.com;micah@identi-check.com;matt@kingtech.net"
		'Mailer.To="matt@kingtech.net"
		Mailer.From="on-line@identi-check.com"
		Mailer.Subject="New Subscriber Application filled out Online for Identi-check"
		
		Mailer.Body = body
		' Use the following to format email in HTML
		Mailer.BodyFormat = 0 ' CdoBodyFormatHTML
		'Outlook gives you grief unless you also set:
		Mailer.MailFormat = 0 ' CdoMailFormatMime

		Mailer.Send

	  'Response.Redirect  "ThankYou.asp"
    Response.Redirect  "Change_Pass.asp?fcra=N"
 end if
End If
%>

<!-- *************************************** MAIN CONTENT AREA *************************************** -->
<div class="w3-container w3-padding" align="center">
<h1>SIGN UP</h1>
<div id="centerEv" style="width:100%" align="center">   
<table width="800px" height="419" cellpadding="0" cellspacing="0" border="0">
    <tr>
        <td width="100%" valign="top" align="center">
        
            <table width="100%" cellpadding="0" cellspacing="0" border="0">
                <tr align="left">
                    <td align="left">             
                                    	
                        <table width="800px" cellpadding="0" cellspacing="0" border="0">
                            <tr valign="top">
                                <td>
                                    <div id="left-tab-top">
                                        
                                    </div>
                                    <div id="left-tab-middle">
                                        <table width="100%">
                                            <tr valign="top">
                                                <td><h4>Subscriber Application</h4>
                                                    <FORM  action="subscriber.asp" method="post"><FONT color=red>* Required
                                                    <br /><%=msg%></FONT>
                                                    <p>
                                                    <TABLE id="table_reg">    
                                              <tr>
                                                        <td colspan=2 align=middle><b>Company Information</b></td>
                                                    </tr>
                                                    <tr>
                                                        <TD align=right><FONT color=red>*</FONT>Company Name:</TD>
                                                        <td><INPUT id=name name="name" size="36" value="<%=name%>"></td>
                                                    </tr>
                                                    <TR>
                                                        <TD align=right>Branch/Division Name:</TD>
                                                <TD><INPUT id=division name="division" size=30 value="<%=division%>"></TD>
                                                    </TR>
                                              <TR>
                                                        <TD align=right><FONT color=red>*</FONT>Address:</TD>
                                                <TD><INPUT id=address name="address" size=30 value="<%=address%>"></TD>
                                                    </TR>
                                              <TR>
                                                        <TD align=right><FONT color=#ff0000>*</FONT>City:</TD>
                                                <TD>
                                                            <INPUT id=text4 name=city value="<%=city%>">
                                                            &nbsp;<FONT color=red>*</FONT>State:&nbsp;<INPUT id=state name=state size=3 value="<%=state%>">
                                                            &nbsp;<FONT color=red>*</FONT>Zip:&nbsp;<INPUT id=zip name=zip size=7 value="<%=zip%>">
                                                        </TD>
                                                    </TR><!--
                                              <TR>
                                                <TD align=right>State:</TD>
                                                <TD><P><INPUT id=text5 name=state size=10><FONT color=red>*</FONT></P></TD>
                                                    </TR>
                                                    <TR>
                                                        <TD align=right>Zip:</TD>
                                                <TD><INPUT id=text16 name=zip size=10><FONT color=red>*</FONT></TD>
                                                    </TR>
                                                    -->
                                                     <tr>
                                                        <td colspan=2 align=middle><b>Contact Information</b></td>
                                                    </tr>
                                              <TR>
                                                        <TD align=right><FONT color=red>*</FONT>Name:</TD>
                                                <TD>
                                                            <INPUT id=contact_name name=contact_name size=25 value="<%=contact_name%>">
                                                            &nbsp;Title:&nbsp;
                                                            <INPUT id=title name=title size=15 value="<%=title%>">
                                                        </TD>
                                                    </TR><!--
                                              <TR>
                                                        <TD align=right>Title:</TD>
                                                <TD><INPUT id=text6 name=title size=36><FONT color=red>*</FONT></TD>
                                                    </TR>
                                                    -->
                                              <TR>
                                                        <TD align=right><FONT color=red>*</FONT>Telephone:</TD>
                                                <TD>
                                                            <INPUT id=phone name=phone  value="<%=phone%>">
                                                            &nbsp;<FONT color=red>*</FONT>Fax:&nbsp;<INPUT id=fax name=fax  value="<%=fax%>">
                                                        </TD>
                                                    </TR><!--
                                              <TR>
                                                <TD align=right>Fax:</TD>
                                                <TD><INPUT id=text8 name=fax><FONT color=red>*</FONT></TD>
                                                    </TR>
                                                    -->
                                              <TR>
                                                        <TD align=right><FONT color=red>*</FONT>E-mail/Username:</TD>
                                                        <TD><INPUT id=email name=email value="<%=email%>"></TD>
                                                    </TR>
                                                    <tr>
                                                        <td colspan=2 align=middle>&nbsp;</td>
                                                    </tr>
                                                    <TR>
                                                        <TD align=right><!-- <FONT color=red>*</FONT> -->No. of 
                                                          Employees:</TD>
                                                        <TD><INPUT id=no_employees name=no_employees value="<%=no_employees%>"></TD>
                                                    </TR>
                                                    <TR>
                                                        <TD align=right><FONT color=red></FONT>No. of estimated hires next two months:</TD>
                                                        <TD><INPUT id=no_est_hired_2_months name=no_est_hired_2_months value="<%=no_est_hired_2_months%>"></TD>
                                                    </TR>
                                                    <TR>
                                                        <TD align=right><FONT color=red></FONT>No. of estimated hires next 12 months:</TD>
                                                        <TD><INPUT id=no_est_hired_12_months name=no_est_hired_12_months value="<%=no_est_hired_12_months%>"></TD>
                                                    </TR>
                                                    <TR>
                                                        <TD align=right><!-- <FONT color=red>*</FONT> -->Type of business:</TD>
                                                        <TD>
                                                            <INPUT id=business_type name=business_type value="<%=business_type%>">
                                                            &nbsp;Yrs in business:&nbsp;<INPUT id=yrs_in_business name=yrs_in_business size=4 value="<%=yrs_in_business%>">
                                                        </TD>
                                                    </TR>
                                                    <TR>
                                                        <TD align=right>Website address:</TD>
                                                        <TD><INPUT id=website name=website value="<%=website%>"></TD>
                                                    </TR>
                                                    <TR>
                                                        <TD align=right><!-- <FONT color=red>*</FONT> -->Type of company (check one):</TD>
                                                        <TD>
                                                            <INPUT type=radio name=company_type value="inc" <% if company_type = "inc" then response.write " checked" %>> Corporation &nbsp;
                                                            <INPUT type=radio name=company_type value="partner" <% if company_type = "partner" then response.write " checked" %>> Partnership &nbsp;
                                                            <INPUT type=radio name=company_type value="sole" <% if company_type = "sole" then response.write " checked" %>> Sole Proprietor
                                                        </TD>
                                                    </TR>
                                                    <TR>
                                                        <TD align=right>State of incorporation:</TD>
                                                        <TD><INPUT id=state_of_inc name=state_of_inc value="<%=state_of_inc%>"></TD>
                                                    </TR>
                                                    <tr>
                                                        <td colspan=2 align=middle><b>Owners and/or Executives of Company</b></td>
                                                    </tr>
                                                    <TR>
                                                        <TD align=right>1.&nbsp;&nbsp;Name:</TD>
                                                        <TD>
                                                            <INPUT id=owner_name1 name=owner_name1 size=25 value="<%=owner_name1%>">
                                                            &nbsp;Title:&nbsp;<INPUT id=owner_title1 name=owner_title1 size=15 value="<%=owner_title1%>">
                                                        </TD>
                                                    </TR>
                                                    <TR>
                                                        <TD align=right>2.&nbsp;&nbsp;Name:</TD>
                                                        <TD>
                                                            <INPUT id=owner_name2 name=owner_name2 size=25 value="<%=owner_name2%>">
                                                            &nbsp;Title:&nbsp;<INPUT id=owner_title2 name=owner_title2 size=15 value="<%=owner_title2%>">
                                                        </TD>
                                                    </TR>
                                                    <tr>
                                                        <td colspan=2 align=middle><b><!-- <FONT color=red>*</FONT> -->How did you hear about Identi-check, Inc.?</b></td>
                                                    </tr>
                                                    <TR>
                                                        <TD colspan=2>
                                                            <INPUT type=radio name=referral value="il_state_chamber" <% if referral = "il_state_chamber" then response.write " checked" %>> Illinois State Chamber of Commerce &nbsp;
                                                            <INPUT type=radio name=referral value="il_man_assoc" <% if referral = "il_man_assoc" then response.write " checked" %>> Illinois Manufacturers' Association<br>
                                                            <INPUT type=radio name=referral value="cust_ref" <% if referral = "cust_ref" then response.write " checked" %>> Customer Referral &nbsp;
                                                            <INPUT type=radio name=referral value="internet" <% if referral = "internet" then response.write " checked" %>> Internet &nbsp;
                                                            <INPUT type=radio name=referral value="sales_call" <% if referral = "sales_call" then response.write " checked" %>> Sales Call &nbsp;
                                                            <INPUT type=radio name=referral value="true_pay" <% if referral = "true_pay" then response.write " checked" %>> True Pay &nbsp;
                                                        </TD>
                                                    </TR>
                                                    <tr>
                                                        <td colspan=2 align=middle><b>Financial Information</b></td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan=2 align=left><b>Credit Application</b><br>
                                                        Identi-check will invoice all customers monthly, via the method checked below. Terms are Net 15 days. 
                                                        The first invoice will include a $30.00 application fee.
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan=2 align=middle><b>Person Responsible For Payment Approval</b></td>
                                                    </tr>
                                                    <TR>
                                                        <TD align=right>Name:</TD>
                                                        <TD>
                                                            <INPUT id=person_name name=person_name size=30 value="<%=person_name%>">
                                                            &nbsp;Telephone:&nbsp;<INPUT id=person_phone name=person_phone size=15 value="<%=person_phone%>">
                                                        </TD>
                                                    </TR>
                                                    <TR>
                                                        <TD align=right>E-Mail:</TD>
                                                        <TD>
                                                            <INPUT id=person_email name=person_email size=30 value="<%=person_email%>">
                                                            &nbsp;Fax:&nbsp;<INPUT id=person_fax name=person_fax size=15 value="<%=person_fax%>">
                                                        </TD>
                                                    </TR>
                                                    <tr>
                                                        <td colspan=2 align=middle><b>Accounts Payable Contact</b></td>
                                                    </tr>
                                                    <TR>
                                                        <TD align=right>Name:</TD>
                                                <TD>
                                                            <INPUT id=ap_name name=ap_name size=30 value="<%=ap_name%>">
                                                            &nbsp;Telephone:&nbsp;<INPUT id=ap_phone name=ap_phone size=15 value="<%=ap_phone%>">
                                                        </TD>
                                                    </TR>
                                              <TR>
                                                <TD align=right>E-mail:</TD>
                                                <TD>
                                                            <INPUT id=ap_email name=ap_email size=30 value="<%=ap_email%>">
                                                            &nbsp;Fax:&nbsp;<INPUT id=ap_fax name=ap_fax size=15 value="<%=ap_fax%>">
                                                        </TD>
                                                    </TR>
                                              <tr>
                                                        <td colspan=2 align=middle><b>Invoice Delivery Method</b></td>
                                                    </tr>
                                                    <TR>
                                                  <TD align=right></TD>
                                                  <TD>
                                                            <INPUT type=radio name=invoice1 value="e-mail" <% if invoice1 = "e-mail" then response.write " checked" %>>e-mail &nbsp;
                                                                <INPUT type=radio name=invoice1 value="Fax" <% if invoice1 = "Fax" then response.write " checked" %>>Fax &nbsp;
                                                                <INPUT type=radio name=invoice1 value="Mail" <% if invoice1 = "Mail" then response.write " checked" %>>Mail
                                                            </TD>
                                                    </TR>
                                                    <tr>
                                                        <td colspan=2>
                                                        By submitting this application, applicant warrants that all information provided by Ident-check, Inc. 
                                                        will be used only for employment screening purposes. Applicant further authorizes Identi-check, Inc. 
                                                        to verify all information provided on this application. All invoices must be paid on time each month, 
                                                        or service will be subject to termination until payment is received.
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                      <td colspan="2" align="center">
                                                        <br /><b>SUBSCRIBER AGREEMENT</b><br /><br />
IDENTI-CHECK, INC. agrees to provide a report on each employment candidate as requested by the client.  IDENTI-CHECK, INC. will use repositories to gather this information and will supply the data to the client in report form.  Please be advised that once the information is furnished to the client, it is no longer in the control of IDENTI-CHECK, and the use of the information becomes the responsibility of the client.  Accordingly, by signing below, the client company agrees that it will defend, indemnify and hold IDENTI-CHECK, INC. harmless for any and all legal actions, losses, claims, demands, liabilities, causes of action, costs or expenses imposed upon IDENTI-CHECK, INC. as a result of the use or misuse of any information by the client, its employees, agents or representatives supplied by IDENTI-CHECK, INC.<br /><br />
Understand that if the client is using the services of IDENTI-CHECK on-line, the signed original of the Candidate Agreement MUST be retained at the client’s place of business.<br /><br />
Pre-employment screening services will be billed at the prices outlined in the Price Structure section of the IDENTI-CHECK web site and under the terms stated, unless a special volume agreement is entered into between the client company and IDENTI-CHECK, INC.  Although due diligence will be used in obtaining pre-employment screening data, IDENTI-CHECK, INC. must rely on secondary sources and, therefore, charges are for each search undertaken without regard to the content of the report produced.<br /><br />
Please provide authorization to proceed and agreement to the terms and conditions set forth in this letter as indicated by your signature below and return this document to IDENTI-CHECK, INC. by fax at 217-753-3428.<br /><br />
AUTHORIZATION TO PROCEED:<br />
Authorized Representative of Client Company:<br />
<span style="font-size: 8pt;">Typing your name in the box below, is equivalent to signing the document.</span><br />
</td>
                                                    </tr>
                                                    <tr>
                                                      <td align="right"><FONT color=red>*</FONT>Signature:  <input type="text" name="txtSignature" value="<%=sSignature%>" /></td>
                                                      <td>&nbsp;&nbsp;&nbsp;<FONT color=red>*</FONT>Printed Name:  <input type="text" name="txtSignPrintedName" value="<%=sPrintedName%>" /></td>
                                                    </tr>
                                                    <tr>
                                                      <td align="right"><FONT color=red>*</FONT>Title:  <input type="text" name="txtSignTitle" value="<%=sSignTitle%>" /></td>
                                                      <td>
                                                        &nbsp;&nbsp;&nbsp;<FONT color=red>*</FONT>Date:  <input type="text" name="txtSignDate" value="<%=sSignDate%>" style="width: 75px;" />
                                                        &nbsp;&nbsp;&nbsp;<FONT color=red>*</FONT>Company FEIN:  <input type="text" name="txtCompanyFEIN" value="<%=sCompanyFEIN%>" style="width: 75px;" />
                                                      </td>
                                                    </tr>
                                                </TABLE>
                                                <div style="width:100%" align="center">
                                                <table id="table_reg">
                                              		<TR>
                                              			<td align="center"><FONT color=red>We appreciate payment within 30days.</FONT>

                                                        <p align="center"> <img src="aspcaptcha.asp" width="86" height="21" /><br />
<%
if request.Form("submit1") = "Continue" then
	response.Write("<font color='#FF0000'><b>Incorrect combination of characters entered.</b></font>")
End if
%>
                      <br />
                      <font color="#FF0000" size="2" face="Arial, Helvetica, sans-serif">*</font> Verify the characters in the image above by re-typing them here:<br />
                      <input name="strCAPTCHA" type="text" id="strCAPTCHA" maxlength="8" />
                    </p>

                                                            <INPUT id=submit1 name=submit1 type=submit value=Continue>
                                                  <INPUT id=reset1 name=reset1 type=reset value=Reset>                                                 
                                                        </TD>
                                                  </TR>
                                                  </TABLE>
                                                  </div>
                                                    </FORM></td>
                                            </tr>
                                        </table>
                                    </div>
                                    <div id="left-tab-bottom">&nbsp;</div>
                                </td>
                            </tr>
                        </table>
                    
                  </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</div>														
</div><!--center ev-->
<!-- ************************************* END MAIN CONTENT AREA ************************************* -->

    
<!--#include file="footNew.asp" -->

</body>
</html>
