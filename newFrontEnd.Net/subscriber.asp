
<!--#include file="adovbs.inc" -->
<%
msg=request("msg")

If request.form("submit1") = "Continue" Then
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

	if name = "" or address = "" or city = "" or state = ""  _
	 or zip = "" or contact_name = "" or phone = ""  _
	 or fax = "" or email = "" then
		msg=" Please go back and complete all required fields."
	else
		dim ObjRec
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
		ObjRec.Update

		dim ObjRec1
		Set ObjRec1=Server.CreateObject("ADODB.RecordSet")
		ObjRec1.CursorLocation = 3
		ObjRec1.Open "Users", StrConnect, adOpenStatic, adLockOptimistic, adCmdTable

		ObjRec1.AddNew
		ObjRec1("company_id") = ObjRec("company_id")
		ObjRec1("UserID") = email	'company11

		D1 = Fix(Rnd * 100000) + 1
		D2 = Fix(Rnd * 100000) + 1
		D3 = Fix(Rnd * 100000) + 1
		trackid= D1+D2+D3
		ObjRec1("Password") = trackid
		ObjRec1("Name") = contact_name	'company7
		ObjRec1("Email") = email	'company11
		ObjRec1("level1") = "1"
		ObjRec1("company") = name	'Company1
		ObjRec1.Update

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

		Response.Redirect  "ThankYou.asp"
 end if
End If
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<!--#include file="headNew.asp" -->


<!-- *************************************** MAIN CONTENT AREA *************************************** -->
<table width="800px" height="419" cellpadding="0" cellspacing="0" border="0">
    <tr>
        <td width="100%" valign="top" align="center">
            <table width="100%" cellpadding="0" cellspacing="0" border="0">
                <tr align="left">
                    <td align="center">                                	
                        <table width="100%" cellpadding="0" cellspacing="0" border="0">
                            <tr valign="top">
                                <td>
                                    <div id="left-tab-top">
                                        <h1>SIGN UP</h1>
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
                                                        <td><INPUT id=text2 name="name" size=36></td>
                                                    </tr>
                                                    <TR>
                                                        <TD align=right>Branch/Division Name:</TD>
                                                <TD><INPUT id=text2 name="division" size=30></TD>
                                                    </TR>
                                              <TR>
                                                        <TD align=right><FONT color=red>*</FONT>Address:</TD>
                                                <TD><INPUT id=text3 name="address" size=30></TD>
                                                    </TR>
                                              <TR>
                                                        <TD align=right><FONT color=#ff0000>*</FONT>City:</TD>
                                                <TD>
                                                            <INPUT id=text4 name=city>
                                                            &nbsp;<FONT color=red>*</FONT>State:&nbsp;<INPUT id=text5 name=state size=3>
                                                            &nbsp;<FONT color=red>*</FONT>Zip:&nbsp;<INPUT id=text16 name=zip size=7>
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
                                                            <INPUT id=text16 name=contact_name size=25>
                                                            &nbsp;Title:&nbsp;
                                                            <INPUT id=text6 name=title size=15>
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
                                                            <INPUT id=text7 name=phone >
                                                            &nbsp;<FONT color=red>*</FONT>Fax:&nbsp;<INPUT id=text8 name=fax >
                                                        </TD>
                                                    </TR><!--
                                              <TR>
                                                <TD align=right>Fax:</TD>
                                                <TD><INPUT id=text8 name=fax><FONT color=red>*</FONT></TD>
                                                    </TR>
                                                    -->
                                              <TR>
                                                        <TD align=right><FONT color=red>*</FONT>E-mail:</TD>
                                                        <TD><INPUT id=text9 name=email></TD>
                                                    </TR>
                                                    <tr>
                                                        <td colspan=2 align=middle>&nbsp;</td>
                                                    </tr>
                                                    <TR>
                                                        <TD align=right><!-- <FONT color=red>*</FONT> -->No. of 
                                                          Employees:</TD>
                                                        <TD><INPUT id=text10 name=no_employees></TD>
                                                    </TR>
                                                    <TR>
                                                        <TD align=right><FONT color=red></FONT>No. of estimated hires next two months:</TD>
                                                        <TD><INPUT id=text18 name=no_est_hired_2_months></TD>
                                                    </TR>
                                                    <TR>
                                                        <TD align=right><FONT color=red></FONT>No. of estimated hires next 12 months:</TD>
                                                        <TD><INPUT id=text1 name=no_est_hired_12_months></TD>
                                                    </TR>
                                                    <TR>
                                                        <TD align=right><!-- <FONT color=red>*</FONT> -->Type of business:</TD>
                                                        <TD>
                                                            <INPUT id=text11 name=business_type>
                                                            &nbsp;Yrs in business:&nbsp;<INPUT id=text12 name=yrs_in_business size=4>
                                                        </TD>
                                                    </TR>
                                                    <TR>
                                                        <TD align=right>Website address:</TD>
                                                        <TD><INPUT id=text13 name=website></TD>
                                                    </TR>
                                                    <TR>
                                                        <TD align=right><!-- <FONT color=red>*</FONT> -->Type of company (check one):</TD>
                                                        <TD>
                                                            <INPUT type=radio name=company_type value="inc"> Corporation &nbsp;
                                                            <INPUT type=radio name=company_type value="partner"> Partnership &nbsp;
                                                            <INPUT type=radio name=company_type value="sole"> Sole Proprietor
                                                        </TD>
                                                    </TR>
                                                    <TR>
                                                        <TD align=right>State of incorporation:</TD>
                                                        <TD><INPUT id=text14 name=state_of_inc></TD>
                                                    </TR>
                                                    <tr>
                                                        <td colspan=2 align=middle><b>Owners and/or Executives of Company</b></td>
                                                    </tr>
                                                    <TR>
                                                        <TD align=right>1.&nbsp;&nbsp;Name:</TD>
                                                        <TD>
                                                            <INPUT id=text15 name=owner_name1 size=25>
                                                            &nbsp;Title:&nbsp;<INPUT id=text16 name=owner_title1 size=15>
                                                        </TD>
                                                    </TR>
                                                    <TR>
                                                        <TD align=right>2.&nbsp;&nbsp;Name:</TD>
                                                        <TD>
                                                            <INPUT id=text15 name=owner_name2 size=25>
                                                            &nbsp;Title:&nbsp;<INPUT id=text16 name=owner_title2 size=15>
                                                        </TD>
                                                    </TR>
                                                    <tr>
                                                        <td colspan=2 align=middle><b><!-- <FONT color=red>*</FONT> -->How did you hear about Identi-check, Inc.?</b></td>
                                                    </tr>
                                                    <TR>
                                                        <TD colspan=2>
                                                            <INPUT type=radio name=referral value="il_state_chamber"> Illinois State Chamber of Commerce &nbsp;
                                                            <INPUT type=radio name=referral value="il_man_assoc"> Illinois Manufacturers' Association<br>
                                                            <INPUT type=radio name=referral value="cust_ref"> Customer Referral &nbsp;
                                                            <INPUT type=radio name=referral value="internet"> Internet &nbsp;
                                                            <INPUT type=radio name=referral value="sales_call"> Sales Call &nbsp;
                                                            <INPUT type=radio name=referral value="true_pay"> True Pay &nbsp;
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
                                                            <INPUT id=text15 name=person_name size=30>
                                                            &nbsp;Telephone:&nbsp;<INPUT id=text16 name=person_phone size=15>
                                                        </TD>
                                                    </TR>
                                                    <TR>
                                                        <TD align=right>E-Mail:</TD>
                                                        <TD>
                                                            <INPUT id=text15 name=person_email size=30>
                                                            &nbsp;Fax:&nbsp;<INPUT id=text16 name=person_fax size=15>
                                                        </TD>
                                                    </TR>
                                                    <tr>
                                                        <td colspan=2 align=middle><b>Accounts Payable Contact</b></td>
                                                    </tr>
                                                    <TR>
                                                        <TD align=right>Name:</TD>
                                                <TD>
                                                            <INPUT id=text12 name=ap_name size=30>
                                                            &nbsp;Telephone:&nbsp;<INPUT id=text12 name=ap_phone size=15>
                                                        </TD>
                                                    </TR>
                                              <TR>
                                                <TD align=right>E-mail:</TD>
                                                <TD>
                                                            <INPUT id=text12 name=ap_email size=30>
                                                            &nbsp;Fax:&nbsp;<INPUT id=text12 name=ap_fax size=15>
                                                        </TD>
                                                    </TR>
                                              <tr>
                                                        <td colspan=2 align=middle><b><FONT color=red>*</FONT>Invoice Delivery Method</b></td>
                                                    </tr>
                                                    <TR>
                                                  <TD align=right></TD>
                                                  <TD>
                                                                <INPUT type=radio name=invoice1 value="Fax" >Fax &nbsp;
                                                                <INPUT type=radio name=invoice1 value="Mail" >Mail
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
                                                </TABLE>
                                                <table id="table_reg">
                                              		<TR>
                                              			<td align="right"><FONT color=red>We appreciate payment within 30days.</FONT>
                                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                            <INPUT id=submit1 name=submit1 type=submit value=Continue>
                                                  <INPUT id=reset1 name=reset1 type=reset value=Reset>                                                 
                                                        </TD>
                                                  </TR>
                                                  </TABLE>
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
<!-- ************************************* END MAIN CONTENT AREA ************************************* -->

    
<!--#include file="footNew.asp" -->

</body>
</html>
