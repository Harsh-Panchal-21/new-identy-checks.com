<% 
Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cache"
'Response.AddHeader "cache-control", "private"
Response.Expires = -1 
%>
<!--#include file="lib.Data.asp"-->
<!-- #include virtual="DB.fun" -->
<!-- #include virtual="db_constants.fun" -->
<!-- #include virtual="functions.inc" -->
<!-- #include file ="adovbs.inc" -->
<%
dim DB : set DB = new Database_Class
DB.Initialize db_conn
dim msg, userid,name,company,company_rid,company_id

if session("validuser") <> True then
	Response.Redirect "default.asp?msg=Not a valid userid"
end if

msg=request("msg")
'UserID=request.cookies("UserID")
UserID = Session("UserID")
name = Session("name")
company = Session("company")
company_rid = Session("company_rid")
company_id = request.querystring("company_id")
isSelfServe = request.querystring("SelfServe")
hideAndShowMain = ""
hideAndShowSelfServe = "display:none;"

'show correct input
If isSelfServe = "true" then
    hideAndShowMain = "display:none;"
    hideAndShowSelfServe = ""
end if

'name=Request.cookies("name")
'Response.cookies("name")=name
'company=Request.cookies("company")
'Response.cookies("company")=company
if session("multi_com") = "yes" then
  dim rs_multi
  SQL = "Select * from Users_Companies Where User_ID = ? and Company_ID = ?"
  Set rs_multi = DB.Query(SQL,Array(session("id"),company_id))
  if rs_multi.eof then
    Response.Redirect "default.asp?msg=Invalid multi company selection"
  else
    'all good
  end if
  rs_multi.close
  set rs_multi = nothing
else
  If CInt(company_rid) <> CInt(company_id) and company_rid <> 0 Then
	  'not valid bounce back to login
	  Response.Redirect "default.asp?msg=Invalid company selection"
  End If
end if


dim sql, conn
Set conn = GetSQLServerConnection( db_machine, db_userid, db_password, db_database )

If CInt(session("admin")) = 2 Then
	dim rsCo
	sql = "Select * From subscriber where company_id = " & company_id
	Set rsCo = GetSQLServerRecordset( conn, sql)
	If not rsCo.eof Then
		company = rsCo("name").value
	Else
		company = "Error, Not Found"
	End If
	rsCo.close
	Set rsCo = nothing
	'don't know if should change company_id or just company
	'company_id = 0
End If

dim fname,lname,address,city,state,zip,county,position,ssn,race,dob
dim drivers_lic,dl_state,long_at_address,other,sex
dim prev_address,prev_city,prev_state,prev_zip,prev_county
dim last_employer,last_emp_city,last_emp_state,last_emp_zip,last_emp_phone
dim last_emp_county,last_emp_position,last_emp_supervisor,last_emp_begin_dt,last_emp_end_dt
dim school,school_city,school_state,school_county,school_phone,school_begin_dt,school_end_dt
dim everifyStatus, everifyFormID, everifyStateID, everifyIDExperation, everifyDOH

'Request Candidate information
dim ssFname, ssLname, ssEmail, ssPhone

if request.QueryString("id") <> "" then
	'Show populated fields for selfService

    dim rsCand2
	sql = "Select * From SelfServeCandidate where candidateID = " & request.QueryString("id")
	Set rsCand2 = GetSQLServerRecordset( conn, sql)
	        If not rsCand2.eof Then
		        ssFname = rsCand2("ssFname").value:ssLname = rsCand2("ssLname").value:ssEmail = rsCand2("ssEmail").value:ssPhone = rsCand2("ssPhone").value
            else
		        'do nothing
	        End If
	        rsCand2.close
	        Set rsCand2 = nothing


else
      

        'Sets form fields for initial entry non self serve
	     ssFname = request.form("ssFname"):ssLname = request.form("ssLname"):ssEmail = request.form("ssEmail"):ssPhone = request.form("ssPhone")

end if
conn.close
set conn = nothing


	dim validateE


	Function validate(ssEmailv)
		  dim isValidE
		  dim regEx

		  isValidE = True
		  set regEx = New RegExp

		  regEx.IgnoreCase = False

		  regEx.Pattern = "^[-+.\w]{1,64}@[-.\w]{1,64}\.[-.\w]{2,6}$"
		  isValidE = regEx.Test(ssEmailv)

		  validateE = isValidE
  End Function


'continue for self serve
 If request.form("submit2") = "Continue" Then
	validate(ssEmail)

	If ssFname = "" or ssLname = "" or ssEmail = "" or ssPhone = "" or len(ssPhone) <> 14 or validateE = False  Then

				

					if ssFname = "" or ssLname = "" or ssEmail = "" or ssPhone = "" then
						msg="Please complete all required fields."
					End if

					if validateE = False then
						msg=msg + "<br>Please enter a valid email address."
					end if
					if len(ssPhone) <> 14 then 

						msg=msg +  "<br>Please enter a valid phone number."
					End if
			
		
	Else
		'insert into candidate information
		Dim dictCandidate1
		Set dictCandidate1 = CreateObject("Scripting.Dictionary")
		dictCandidate1.Add "company_id", company_id
		dictCandidate1.Add "fname", ssFname
		dictCandidate1.Add "lname", ssLname
		dictCandidate1.Add "company", company
		dim dictCandidate
	set dictCandidate  = dictCandidate1
		Set dictCandidate1 = Nothing

	
	dim ObjRec
	Set ObjRec=Server.CreateObject("ADODB.RecordSet")
	StrConnect="Provider=SQLOLEDB.1; Data Source= " & db_machine & "; User ID=" & db_userid & "; Password=" & db_password & "; Initial Catalog=" & db_database

	ObjRec.CursorLocation = 3
	ObjRec.Open "candidate", StrConnect, adOpenStatic, adLockOptimistic, adCmdTable

	ObjRec.AddNew
	ObjRec("date1") = now()
	ObjRec("company_id") = dictCandidate.Item("company_id")
	ObjRec("fname") = dictCandidate.Item("fname")
	ObjRec("lname") = dictCandidate.Item("lname")
	ObjRec("company") = dictCandidate.Item("company")
    ObjRec.Update
	Set dictCandidate = nothing
	'Response.cookies("id")=ObjRec("id")
	Session("candidate_id") = ObjRec("id")
	candidate_id = session("candidate_id")
	ObjRec.close
	set ObjRec = nothing

    'insert into selfServeCandidate
        Dim dictSelfServeCandidate
		Set dictSelfServeCandidate = CreateObject("Scripting.Dictionary")
        dictSelfServeCandidate.Add "candidateID", session("candidate_id")
		dictSelfServeCandidate.Add "companyID", company_id
        dictSelfServeCandidate.Add "ssPhone", ssPhone
		dictSelfServeCandidate.Add "ssFname", ssFname
        dictSelfServeCandidate.Add "ssEmail", ssEmail
		dictSelfServeCandidate.Add "ssLname", ssLname
		Set Session("dictSelfServeCandidate") = dictSelfServeCandidate
		
		'guid for email login
	dim authToken 
	Dim TypeLib
	Set TypeLib = CreateObject("Scriptlet.TypeLib")
	authToken = Mid(TypeLib.Guid, 2, 36)

    dim ObjRec22
	Set ObjRec2=Server.CreateObject("ADODB.RecordSet")
	StrConnect="Provider=SQLOLEDB.1; Data Source= " & db_machine & "; User ID=" & db_userid & "; Password=" & db_password & "; Initial Catalog=" & db_database

	ObjRec2.CursorLocation = 3
	ObjRec2.Open "SelfServeCandidate", StrConnect, adOpenStatic, adLockOptimistic, adCmdTable

	ObjRec2.AddNew
	ObjRec2("candidateID") = Session("candidate_id")
	ObjRec2("companyID") = dictSelfServeCandidate.Item("companyID")
	ObjRec2("ssFname") = dictSelfServeCandidate.Item("ssFname")
	ObjRec2("ssLname") = dictSelfServeCandidate.Item("ssLname")
	ObjRec2("ssEmail") = dictSelfServeCandidate.Item("ssEmail")
	ObjRec2("ssPhone") = dictSelfServeCandidate.Item("ssPhone")
	ObjRec2("authToken") = authToken
    ObjRec2.Update
	Set dictSelfServeCandidate = nothing
	ObjRec2.close
	set ObjRec2 = nothing
	Set dictSelfServeCandidate = Nothing

	'need to make new price page that allows paymetn
		Response.Redirect "SelfServePrice.asp?company_id=" & company_id 
	end if

End If
if state = "" then state = "IL"
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>


<!--#include file="head.asp" -->

<center>

<!-- *************************************** MAIN CONTENT AREA *************************************** -->
<table width="619px" height="419" cellpadding="0" cellspacing="0" border="0">
    <tr>
        <td width="610px" valign="top" align="center">
            <table width="590px" cellpadding="0" cellspacing="0" border="0">
                <tr align="left">
                    <td>
                    <center>
                        Welcome: <%=name%><br />
                        <%=now%>
                        <hr></center>
                        <h4 align="center">
                            <A href="candidate.asp?company_id=<%=company_id%>">*Submit Candidate</A>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <A href="SelfServeCandidate.asp?company_id=<%=company_id%>&SelfServe=true">Request Candidate</A>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <A href="main.asp?company_id=<%=company_id%>">Candidate List</A>
                        </h4>
                        <h4>Candidate Application - <%=company%></h4>
                        <font color="#FF0000"><strong><%=msg%></strong></font>
                        <FORM name="myForm" action="SelfServeCandidate.asp?company_id=<%=company_id%>" method="post">
                        

            <TABLE id="table_reg">
                            <tr>
                                <th colspan=2>Personal Information: <br />Please enter a valid phone number and email so your candidate can verify before adding their information.</th>
                            </tr>
                            <tr>
                                <TD align=right>First Name:</TD>
                                <td><INPUT name="ssFname" id=ssFname value="<%=ssFname%>" size=30 maxlength="50"><FONT color=red>*</FONT></td>
                            </tr>
                            <TR>
                                <TD align=right>Last Name:</TD>
                                <TD><INPUT name="ssLName" id=ssLname value="<%=ssLname%>" size=30 maxlength="50"><FONT color=red>*</FONT></TD></TR>
                            <TR>
                                <TD align=right>Email:</TD>
                                <TD><INPUT name="ssEmail" id=ssEmail value="<%=ssEmail%>" size=30 maxlength="50"><FONT color=red>*</FONT></TD></TR>
                            <TR>
                                <TD align=right>Phone Number:</TD>
                                <TD><INPUT name="ssPhone" id=ssPhone value="<%=ssPhone%>" size=30 maxlength="50"  placeholder="(555) 555-5555"/><FONT color=red>*</FONT></TD></TR>
                            
                            <tr>
                            <TD colspan=2><INPUT id=submit2 name=submit2 type=submit value="Continue">
                            <INPUT id=reset2 name=reset2 type=reset value=Reset>&nbsp; 
                              <font color=red>Please continue finishing next page to complete your 
                            submiting.</font></TD>
                            </TR>
                        </TABLE>
            
            
            
            </FORM>
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

    </div>    
    <div id="right">&nbsp;</div>
</div>

	<script type="text/javascript">
        document.getElementById('ssPhone').addEventListener('input', function (e) {
            var x = e.target.value.replace(/\D/g, '').match(/(\d{0,3})(\d{0,3})(\d{0,4})/);
            e.target.value = !x[2] ? x[1] : '(' + x[1] + ') ' + x[2] + (x[3] ? '-' + x[3] : '');
		});

    </script>

<!--#include file="foot.asp" -->


</body>
</html>