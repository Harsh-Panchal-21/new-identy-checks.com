<!--#include virtual="db_constants.fun" -->
<!--#include virtual="DB.fun" -->
<%
if session("admin") <> 2 then
	Response.Redirect "index.asp?msg=Access denied"
end if 
dim msg, userid,name,company,company_rid,company_id

company_id = request.querystring("company_id")
msg = request.querystring("msg")
UserID = Session("UserID")
name = Session("name")
company = Session("company")
company_rid = Session("company_rid")

If CInt(company_rid) <> CInt(company_id) and company_rid <> 0 Then
	'not valid bounce back to login
	Response.Redirect "index.asp?msg1=Invalid company selection"
End If

Dim sSQL, conn, rs
Set conn = GetSQLServerConnection( db_machine, db_userid, db_password, db_database )

If request.Form("btnSave") = "Save Changes" Then
	sSQL = "Update subscriber set " & _
				 "name = '" & Replace(request.form("name"),"'","''") & "', " & _
				 "division = '" & Replace(request.form("division"),"'","''") & "', " & _
				 "address = '" & request.form("address") & "', " & _
				 "city = '" & request.form("city") & "', " & _
				 "state = '" & request.form("state") & "', " & _
				 "zip = '" & request.form("zip") & "', " & _
				 "contact_name = '" & request.form("contact_name") & "', " & _
				 "title = '" & request.form("title") & "', " & _
				 "phone = '" & request.form("phone") & "', " & _
				 "fax = '" & request.form("fax") & "', " & _
				 "email = '" & request.form("email") & "', " & _
				 "no_employees = '" & request.form("no_employees") & "', " & _
				 "no_est_hired_2_months = '" & request.form("no_est_hired_2_months") & "', " & _
				 "no_est_hired_12_months = '" & request.form("no_est_hired_12_months") & "', " & _
				 "business_type = '" & request.form("business_type") & "', " & _
				 "yrs_in_business = '" & request.form("yrs_in_business") & "', " & _
				 "website = '" & request.form("website") & "', " & _
				 "company_type = '" & request.form("company_type") & "', " & _
				 "state_of_inc = '" & request.form("state_of_inc") & "', " & _
				 "owner_name1 = '" & request.form("owner_name1") & "', " & _
				 "owner_title1 = '" & request.form("owner_title1") & "', " & _
				 "owner_name2 = '" & request.form("owner_name2") & "', " & _
				 "owner_title2 = '" & request.form("owner_title2") & "', " & _
				 "referral = '" & request.form("referral") & "', " & _
				 "person_name = '" & request.form("person_name") & "', " & _
				 "person_phone = '" & request.form("person_phone") & "', " & _
				 "person_email = '" & request.form("person_email") & "', " & _
				 "person_fax = '" & request.form("person_fax") & "', " & _
				 "ap_name = '" & request.form("ap_name") & "', " & _
				 "ap_phone = '" & request.form("ap_phone") & "', " & _
				 "ap_email = '" & request.form("ap_email") & "', " & _
				 "ap_fax = '" & request.form("ap_fax") & "', " & _
				 "invoice1 = '" & request.form("invoice1") & "' " & _
				 "where company_id = " & company_id
	Call conn.execute(sSQL)
End If

sSQL = "Select * From subscriber where company_id = " & company_id
Set rs = GetSQLServerStaticRecordset( conn, sSQL )

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<!--#include file="head.asp" -->
<center>

<!-- *************************************** MAIN CONTENT AREA *************************************** -->
 <table width="900px" cellpadding="0" cellspacing="0" border="0">
					<tr>
                    	<td width="100%"  align="center" class="menu">
                        <table width="100%" cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <td align="center" class="menu">
                                    Welcome: <%=name%><br />
                                    <%=now%>
                                    <hr>
                                    <h4 align="center">
                                        <a href="admin.asp">Company List</a>&nbsp;&nbsp; | &nbsp;&nbsp;
                                        <a href="admin1.asp">Candidate List</a>&nbsp;&nbsp; | &nbsp;&nbsp;
                                        <a href="admin_pricing.asp">Pricing List</a>&nbsp;&nbsp; | &nbsp;&nbsp;
                                        <a href="admin_pending.asp">Pending List</a>&nbsp;&nbsp; | &nbsp;&nbsp;
                                        <a href="admin_new.asp">New List</a>&nbsp;&nbsp; | &nbsp;&nbsp;
                                        <a href="admin_invoice.asp">Monthly Invoices</a>
                                    </h4>
                                    </tr>
    <tr>
        <td width="610px" valign="top" align="center">
            <table width="590px" cellpadding="0" cellspacing="0" border="0">
                <tr align="left">
                    <td>
                    <h4 align="left">Subscriber Application</h4>
                    <FORM  action="admin_detail.asp?company_id=<%=company_id%>" method="post">
                    <TABLE id="table_reg">   
                        <tr>
                            <th colspan=2>General Information</th>
                        </tr>
                        <tr>
                            <TD align=right>Company Name:</TD>
                            <td>
                                <input value="<%=rs("name")%>"  id=text2 name="name" size=36><FONT color=red>*</FONT>
                            </td>
                        </tr>
                        <TR>
                            <TD align=right>Branch/Division Name:</TD>
                            <TD>
                                <input value="<%=rs("division")%>" id=text2 name="division" size=30><FONT color=red>*</FONT>
                            </TD>
                        </TR>
                        <TR>
                            <TD align=right>Address:</TD>
                            <TD>
                                <input value="<%=rs("address")%>" id=text3 name="address" size=30><FONT color=red>*</FONT>
                            </TD>
                        </TR>
                        <TR>
                            <TD align=right>City, State Zip</TD>
                            <TD>
                                <input value="<%=rs("city")%>" id=text4 name=city size=20><FONT color=#ff0000>*</FONT></FONT>&nbsp;,&nbsp;
                                <input value="<%=rs("state")%>" id=text5 name=state size=4><FONT color=red>*</FONT>&nbsp;&nbsp;
                                <input value="<%=rs("zip")%>" id=text16 name=zip size=10><FONT color=red>*</FONT>
                            </TD>
                        </tr>
                        <tr>
                            <th colspan=2>Contact Information</th>
                        </tr>
                        <TR>
                            <TD align=right>Name:</TD>
                            <TD>
                                <input value="<%=rs("contact_name")%>" id=text17 name=contact_name size=25><FONT color=red>*</FONT>
                                &nbsp;Title:&nbsp;<input value="<%=rs("title")%>" id=text6 name=title size=15><FONT color=red>*</FONT>
                            </TD>
                        </TR>
                        <TR>
                            <TD align=right>Telphone:</TD>
                            <TD>
                                <input value="<%=rs("phone")%>" id=text7 name=phone size=15><FONT color=red>*</FONT>
                                &nbsp;Fax:&nbsp;<input value="<%=rs("fax")%>" id=text8 name=fax size=15><FONT color=red>*</FONT>
                            </TD>
                        </TR>
                        <TR>
                            <TD align=right>E-mail:</TD>
                            <TD>
                                <input value="<%=rs("email")%>" id=text9 name=email size=35><FONT color=red>*</FONT>
                            </TD>
                        </TR>
                        <tr>
                            <th colspan=2>Company Information</th>
                        </tr>
                        <TR>
                            <TD align=right>No. of Employees:</FONT></TD>
                            <TD>
                                <input value="<%=rs("no_employees")%>" id=text10 name=no_employees><FONT color=red>*</FONT>
                            </TD>
                        </TR>
                        <TR>
                            <TD align=right>No. of estimated hires next two months:</TD>
                            <TD>
                                <input value="<%=rs("no_est_hired_2_months")%>" id=text18 name=no_est_hired_2_months><FONT color=red>*</FONT>
                            </TD>
                        </TR>
                        <TR>
                            <TD align=right>No. of estimated hires next 12 months:</TD>
                            <TD>
                                <input value="<%=rs("no_est_hired_12_months")%>" id=text1 name=no_est_hired_12_months><FONT color=red>*</FONT>
                            </TD>
                        </TR>
                        <TR>
                            <TD align=right>Type of business:</TD>
                            <TD>
                                <input value="<%=rs("business_type")%>" id=text11 name=business_type><FONT color=red>*</FONT>
                                &nbsp;Yrs in business&nbsp;<input value="<%=rs("yrs_in_business")%>" id=text11 name=yrs_in_business size=4>
                            </TD>
                        </TR>
                        <TR>
                            <TD align=right>Website address:</TD>
                            <TD>
                                <input value="<%=rs("website")%>" id=text13 name=website size=35>
                            </TD>
                        </TR>
                        <TR>
                            <TD align=right>Type of Company:</TD>
                            <TD>
                                <input type=radio name=company_type value="inc" <% If rs("company_type") = "inc" Then Response.write " CHECKED" %>>Corporation&nbsp;&nbsp;
                                <input type=radio name=company_type value="partner" <% If rs("company_type") = "partner" Then Response.write " CHECKED" %>>Partnership&nbsp;&nbsp;
                                <input type=radio name=company_type value="sole"<% If rs("company_type") = "sole" Then Response.write " CHECKED" %>>Sole Proprietor&nbsp;&nbsp;
                            </TD>
                        </TR>
                        <TR>
                            <TD align=right>State of Incorporation:</TD>
                            <TD>
                                <input value="<%=rs("state_of_inc")%>" id=text13 name=state_of_inc size=10>
                            </TD>
                        </TR>
                        <TR>
                            <TD align=right>Owners and/or Executives of Company</TD>
                            <TD>
                                1.&nbsp&nbsp Name: <input value="<%=rs("owner_name1")%>" id=text13 name=owner_name1 size=25>
                                &nbsp;Title:&nbsp;<input value="<%=rs("owner_title1")%>" id=text13 name=owner_title1 size=15>
                            </TD>
                        </TR>
                        <TR>
                            <TD align=right>&nbsp;</TD>
                            <TD>
                                2.&nbsp&nbsp Name: <input value="<%=rs("owner_name2")%>" id=text13 name=owner_name2 size=25>
                                &nbsp;Title:&nbsp;<input value="<%=rs("owner_title2")%>" id=text13 name=owner_title2 size=15>
                            </TD>
                        </TR>
                        <tr>
                        </tr>
                        <TR>
                            <td align=right><b>Referred From</b></td>
                            <TD>
                                <input type=radio name=referral value="il_state_chamber" <% If rs("referral") = "il_state_chamber" Then Response.write " CHECKED" %>>Illinois State Chamber of Commerce&nbsp;&nbsp;
                                <input type=radio name=referral value="il_man_assoc" <% If rs("referral") = "il_man_assoc" Then Response.write " CHECKED" %>>Illinois Manufactures' Association&nbsp;&nbsp;<br>
                                <input type=radio name=referral value="cust_ref" <% If rs("referral") = "cust_ref" Then Response.write " CHECKED" %>>Customer Referral&nbsp;&nbsp;
                                <input type=radio name=referral value="internet" <% If rs("referral") = "internet" Then Response.write " CHECKED" %>>Internet&nbsp;&nbsp;
                                <input type=radio name=referral value="sales_call" <% If rs("referral") = "sales_call" Then Response.write " CHECKED" %>>Sales Call&nbsp;&nbsp;
                            </TD>
                        </TR>
                        <tr>
                            <th colspan=2>Person Responsible for Payment Approval</th>
                        </tr>
                        <TR>
                            <TD align=right>Name:</TD>
                            <TD>
                                <input value="<%=rs("person_name")%>" id=text12 name=person_name size=36>
                            </TD>
                        </TR>
                        <TR>
                            <TD align=right>Telephone:</TD>
                            <TD>
                                <input value="<%=rs("person_phone")%>" id=text12 name=person_phone>
                            </TD>
                        </TR>
                        <TR>
                            <TD align=right>E-mail:</TD>
                            <TD>
                                <input value="<%=rs("person_email")%>" id=text12 name=person_email>
                            </TD>
                        </TR>
                        <TR>
                            <TD align=right>Fax:</TD>
                            <TD>
                                <input value="<%=rs("person_fax")%>" id=text12 name=person_fax>
                            </TD>
                        </TR>
                        <tr>
                            <th colspan=2>Accounts Payable Contact</th>
                        </tr>
                        <TR>
                            <TD align=right>Name:</TD>
                            <TD>
                                <input value="<%=rs("ap_name")%>" id=text12 name=ap_name size=36>
                            </TD>
                        </TR>
                        <TR>
                            <TD align=right>Telephone:</TD>
                            <TD>
                                <input value="<%=rs("ap_phone")%>" id=text12 name=ap_phone>
                            </TD>
                        </TR>
                        <TR>
                            <TD align=right>E-mail:</TD>
                            <TD>
                                <input value="<%=rs("ap_email")%>" id=text12 name=ap_email>
                            </TD>
                        </TR>
                        <TR>
                            <TD align=right>Fax:</TD>
                            <TD>
                                <input value="<%=rs("ap_fax")%>" id=text12 name=ap_fax>
                            </TD>
                        </TR>
                        <tr>
                            <td align=right><b>Invoice Delivery Method</b><FONT color=red>*</FONT></td>
                            <td>
                                <input type=radio name=invoice1 value="Email" <% If rs("invoice1") = "Email" Then Response.write " CHECKED" %>>Email&nbsp;&nbsp;
                                <input type=radio name=invoice1 value="Fax" <% If rs("invoice1") = "Fax" Then Response.write " CHECKED" %>>Fax&nbsp;&nbsp;
                                <input type=radio name=invoice1 value="Mail" <% If rs("invoice1") = "Mail" Then Response.write " CHECKED" %>>Mail&nbsp;&nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td colspan=2 align="right"><input type=submit name="btnSave" value="Save Changes" /></td>
                        </tr>
                  </TABLE>
                    </FORM>
                    </Td>
                </TR>
            </table>
        </td>
    </tr>
</table>
<!-- ************************************* END MAIN CONTENT AREA ************************************* -->

    </div>    
    <div id="right">&nbsp;</div>
</div>
<!--#include file="foot.asp" -->

</body>
</html>
