<%@ CODEPAGE = 1252 %> 
<%
Option Explicit
Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cache"
'Response.AddHeader "cache-control", "private"
Response.Expires = -1 
%>
<!--#include file="lib.Data.asp"-->
<!--#include virtual="db_constants.fun" -->
<!-- #include virtual="DB.fun" -->
<!--#include virtual="functions.inc" -->
<!--#include virtual="rc4.inc"-->
<%
if session("admin") <> 2 then
	Response.Redirect "default.asp?msg=Access denied"
end if 
dim msg, userid,name,company,company_rid,company_id,id
Dim blnAdd
blnAdd = false

company_id = request.querystring("company_id")
id = request.querystring("id")
if id = "0" then blnAdd = true

msg = request.querystring("msg")
UserID = Session("UserID")
name = Session("name")
company = Session("company")
company_rid = Session("company_rid")

If CInt(company_rid) <> CInt(company_id) and company_rid <> 0 Then
	'not valid bounce back to login
	Response.Redirect "default.asp?msg=Invalid company selection"
End If

Dim sSQL, conn, rs
Dim sPassword, sUserID, sEmail, sCompanyID, sName, sPassEnc
'Set conn = GetSQLServerConnection( db_machine, db_userid, db_password, db_database )
dim DB : set DB = new Database_Class
DB.Initialize db_conn

If request.form("submit1") = "Update" Then
  'company_id, name, 
	'Dim sPassword, sCompany, sUserID, sEmail, sCompanyID, sName
	'sCompany = request.form("company")
	sUserID = request.form("userid")
	sPassword = CStr(request.form("password"))
  'response.Write "---------- Pass: " & sPassword
  'response.Write "---------- EncPassString: " & enc_pass_string
  sPassEnc = EnDeCrypt(request.form("password"),enc_pass_string)
  'response.Write "---------- Enc Pass: " & sPassEnc
  'response.Write "---------- Enc 11111: " & EnDeCrypt(11111,enc_pass_string)
	sEmail = request.form("email")
  sCompanyID = request.form("lstCompanyID")
  sName = request.form("txtName")
	sSQL = "Update users set company_id = ?, UserID = ?, password = ?, Name = ?, email = ?, EncryptedPassword = 'Y',PasswordDate = GETDATE() + 60 Where id = ?"
	'Call conn.execute(sSQL)
  Call DB.Execute(sSQL,Array(sCompanyID,sUserID,sPassEnc,sName,sEmail,id))
	msg="Information has been updated"
elseIf request.form("btnAdd") = "Add" Then
  'enc_pass = EnDeCrypt(Pass1,enc_pass_string)
  sUserID = request.form("userid")
	sPassword = request.form("password")
  sPassEnc = EnDeCrypt(sPassword,enc_pass_string)
	sEmail = request.form("email")
  sCompanyID = request.form("lstCompanyID")
  sName = request.form("txtName")
  sSQL = "Insert Into users (company_id,UserID,password,Name,email,level1,PasswordDate,date1,EncryptedPassword) Values (?,?,?,?,?,1,GETDATE(),GETDATE(),'Y')"
  'Call conn.execute(sSQL)
  Call DB.Execute(sSQL,Array(sCompanyID,sUserID,sPassEnc,sName,sEmail))
  msg = "User Added"
  response.Redirect "admin_company_logins.asp?company_id=" & company_id & "&msg=" & msg
elseIf request.form("btnDelete") = "Delete" Then
  msg = "User Deleted"
  'Call conn.execute("Delete from users where id = " & id)
  Call DB.Execute("Delete from users where id = ?",Array(id))
  response.Redirect "admin_company_logins.asp?company_id=" & company_id & "&msg=" & msg
End If

dim lComID, lUserName, lPassword, lEmail, lName
'sSQL = "Select * From users Where id = " & id
'Set rs = GetSQLServerRecordset( conn, sSQL )
Set rs = DB.Query("Select * From Users Where id = ?",Array(id))
if blnAdd then
  lComID = company_id
  lUserName = ""
  lPassword = ""
  lEmail = ""
  lName = ""
else
  lComID = rs("company_id")
  lUserName = rs("UserID")
  lPassword = rs("Password")
  if rs("EncryptedPassword") = "Y" then
    sPassEnc = EnDeCrypt(lPassword,enc_pass_string)
    lPassword = sPassEnc
  end if  
  lEmail = rs("Email")
  lName = rs("Name")
end if

%><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
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
    <tr>
        <td width="610px" valign="top" align="center">
            <table width="590px" cellpadding="0" cellspacing="0" border="0">
                <tr align="left">
                    <td>
                    <h4 align="left">Update Login Information</h4> - <a href="admin_company_logins.asp?company_id=<%=company_id%>">back to login list</a>
                      <%=msg %>
                    <FORM name="" action="log_update.asp?id=<%=id%>&company_id=<%=company_id%>" method="post">
                        <TABLE id="table_reg">
                            <tr>
                                <TD align=right class="big_text">Company Name:</TD>
                                <td>
                                  <select name="lstCompanyID">
                                    <option value="">Select Company</option>
                                    <% dim rsCom
                                    'Set rsCom = GetSQLServerRecordset( conn, "select name, company_id from subscriber Where hide = 'N'" )
                                    Set rsCom = DB.Query("select name, company_id from subscriber Where hide = 'N'",Array(""))
                                    do while not rsCom.eof
                                      response.Write "<option value='" & rsCom("company_id") & "'" 
                                      if rsCom("company_id") = CInt(lComID) then
                                        response.Write " selected"
                                      end if
                                      response.write ">" & rsCom("name") & "</option>" & vbCrLf
                                      rsCom.movenext
                                    loop
                                    set rsCom = nothing
                                    %>
                                  </select>
                                  <!--<INPUT id=text2 name="company" size=36 value="">-->
                                  <FONT color=red>*</FONT>
                                </td>
                            </tr>
                            <TR>
                                <TD align=right class="big_text">User Name:</TD>
                                <TD><INPUT value="<%=lUserName%>" name="UserID" size=30><FONT color=red>*</FONT></TD>
                            </TR>
                            <TR>
                                <TD align=right class="big_text">Password:</TD>
                                <TD><INPUT value="<%=lPassword%>" id=text3 name="Password" size=30><FONT color=red>*</FONT></TD>
							              </TR>
                            <TR>
                                <TD align=right class="big_text">Name:</TD>
                                <TD><INPUT value="<%=lName%>" name="txtName" size=30><FONT color=red>*</FONT></TD>
                            </TR>
							              <TR>
                                <TD align=right class="big_text">Email:</TD>
                                <TD><INPUT value="<%=lEmail%>" name="Email" size=30><FONT color=red>*</FONT></TD>
                            </TR>
                            <TR>
                                <TD colspan=2 align="right">
                                  <% if blnAdd then %>
                                    <INPUT id='btnAdd' name='btnAdd' type='submit' value='Add'>
                                  <% else %>
                                    <INPUT id=submit1 name=submit1 type=submit value=Update>
                                    <INPUT id="btnDelete" name="btnDelete" type=submit value="Delete" onclick="return confirm('Are you sure you want to delete this user?')">
                                    <INPUT id=reset1 name=reset1 type=reset value=Reset>
                                  <% end if %>
                                </TD>
                            </TR>
                        </TABLE>
                    </FORM>
                    </td>
                </tr>
        	</table>
        </td>
    </tr>
</table>
<!-- ************************************* END MAIN CONTENT AREA ************************************* -->
<%
set DB = nothing
%>
    </div>    
    <div id="right">&nbsp;</div>
</div>
<!--#include file="foot.asp" -->

</body>
</html>
