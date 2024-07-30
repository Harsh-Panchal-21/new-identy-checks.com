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
msg=request("msg")
'UserID=request.cookies("UserID")
UserID = Session("UserID")
name = Session("name")
company = Session("company")
company_rid = Session("company_rid")
company_id = request.querystring("company_id")

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

if request.QueryString("id") <> "" then
	dim rsCand
	sql = "Select * From candidate where company_id = " & company_id & " and id = " & request.QueryString("id")
	Set rsCand = GetSQLServerRecordset( conn, sql)
	If not rsCand.eof Then
		fname = rsCand("fname").value:lname = rsCand("lname").value:address = rsCand("address").value
		city = rsCand("city").value:state = rsCand("state").value:zip = rsCand("zip").value:county = rsCand("county").value
		position_type = rsCand("position_type").value:ssn = rsCand("ssn").value:race = rsCand("race").value:sex = rsCand("sex").value
		dob = rsCand("dob").value:drivers_lic = rsCand("drivers_lic").value:dl_state = rsCand("dl_state").value
		long_at_address = rsCand("long_at_address").value:prev_address = rsCand("prev_address").value
		prev_city = rsCand("prev_city").value:prev_state = rsCand("prev_state").value:prev_zip = rsCand("prev_zip").value
		prev_county = rsCand("prev_county").value:last_employer = rsCand("last_employer").value:last_emp_phone = rsCand("last_emp_phone").value
		last_emp_city = rsCand("last_emp_city").value:last_emp_state = rsCand("last_emp_state").value
		last_emp_county = rsCand("last_emp_county").value:last_emp_position = rsCand("last_emp_position").value
		last_emp_supervisor = rsCand("last_emp_supervisor").value:last_emp_begin_dt = rsCand("last_emp_begin_dt").value
		last_emp_end_dt = rsCand("last_emp_end_dt").value:school = rsCand("school").value:school_city = rsCand("school_city").value
		school_state = rsCand("school_state").value:school_county = rsCand("school_county").value:school_phone = rsCand("school_phone").value
		school_begin_dt = rsCand("school_begin_dt").value:school_end_dt = rsCand("school_end_dt").value
		other = rsCand("other").value:school_degree = rsCand("school_degree").value:school_other = rsCand("school_other").value
        everifyStatus = rsCand("everifyStatus").value:everifyFormID = rsCand("everifyFormID").value:evaerifyStateID = rsCand("everifyStateID").value:everifyIDExperation = rsCand("everifyIDExperation").value:everifyDOH = rsCand("everifyDOH").value
	Else
		'
	End If
	rsCand.close
	Set rsCand = nothing

else
	fname = request.form("fname"):lname = request.form("lname"):address = request.form("address")
	city = request.form("city"):state = request.form("state"):zip = request.form("zip"):county = request.form("county")
	position_type = request.form("position_type"):ssn = request.form("ssn"):race = request.form("race"):sex = request.form("sex")
	dob = request.form("dob"):drivers_lic = request.form("drivers_lic"):dl_state = request.form("dl_state")
	long_at_address = request.form("long_at_address"):prev_address = request.form("prev_address")
	prev_city = request.form("prev_city"):prev_state = request.form("prev_state"):prev_zip = request.form("prev_zip")
	prev_county = request.form("prev_county"):last_employer = request.form("last_employer"):last_emp_phone = request.form("last_emp_phone")
	last_emp_city = request.form("last_emp_city"):last_emp_state = request.form("last_emp_state")
	last_emp_county = request.form("last_emp_county"):last_emp_position = request.form("last_emp_position")
	last_emp_supervisor = request.form("last_emp_supervisor"):last_emp_begin_dt = request.form("last_emp_begin_dt")
	last_emp_end_dt = request.form("last_emp_end_dt"):school = request.form("school"):school_city = request.form("school_city")
	school_state = request.form("school_state"):school_county = request.form("school_county"):school_phone = request.form("school_phone")
	school_begin_dt = request.form("school_begin_dt"):school_end_dt = request.form("school_end_dt")
	other = request.form("other"):school_degree = request.form("school_degree"):school_other = request.form("school_other")
    everifyStatus = request.form("everifyStatus"):everifyFormID = request.form("everifyFormID"):everifyStateID = request.form("everifyStateID"):everifyIDExperation = request.form("everifyIDExperation"):everifyDOH = request.form("everifyDOH"):
end if
conn.close
set conn = nothing

If request.form("submit1") = "Continue" Then
	If fname = "" or lname = "" or other = "" or address = "" or city = "" or state = "" or county = "" or _
		ssn = "" or dob = "" or long_at_address = "" Then

		msg="Please complete all required fields."
	Else
		'dim ObjRec
		'Set ObjRec=Server.CreateObject("ADODB.RecordSet")
		'StrConnect="Provider=SQLOLEDB.1; Data Source= " & db_machine & "; User ID=" & db_userid & "; Password=" & db_password & "; Initial Catalog=" & db_database

		'ObjRec.CursorLocation = 3
		'ObjRec.Open "candidate", StrConnect, adOpenStatic, adLockOptimistic, adCmdTable

		'ObjRec.AddNew
		'ObjRec("date1")  =now()
		Dim dictCandidate
		Set dictCandidate = CreateObject("Scripting.Dictionary")
		dictCandidate.Add "company_id", company_id
		dictCandidate.Add "fname", fname
		dictCandidate.Add "lname", lname
		dictCandidate.Add "other", other
		dictCandidate.Add "address", address
		dictCandidate.Add "city", city
		dictCandidate.Add "state", state
		dictCandidate.Add "zip", zip
		dictCandidate.Add "county", county
		dictCandidate.Add "position_type", position_type
		dictCandidate.Add "ssn", ssn
		dictCandidate.Add "dob", dob
		dictCandidate.Add "sex", sex
		dictCandidate.Add "race", race
		dictCandidate.Add "drivers_lic", drivers_lic
		dictCandidate.Add "dl_state", dl_state
		dictCandidate.Add "long_at_address", long_at_address
		dictCandidate.Add "prev_address", prev_address
		dictCandidate.Add "prev_city", prev_city
		dictCandidate.Add "prev_state", prev_state
		dictCandidate.Add "prev_zip", prev_zip
		dictCandidate.Add "prev_county", prev_county
		dictCandidate.Add "last_employer", last_employer
		dictCandidate.Add "last_emp_phone", last_emp_phone
		dictCandidate.Add "last_emp_city", last_emp_city
		dictCandidate.Add "last_emp_state", last_emp_state
		dictCandidate.Add "last_emp_county", last_emp_county
		dictCandidate.Add "last_emp_position", last_emp_position
		dictCandidate.Add "last_emp_supervisor", last_emp_supervisor
		dictCandidate.Add "last_emp_begin_dt", last_emp_begin_dt
		dictCandidate.Add "last_emp_end_dt", last_emp_end_dt
		dictCandidate.Add "school", school
		dictCandidate.Add "school_city", school_city
		dictCandidate.Add "school_state", school_state
		dictCandidate.Add "school_county", school_county
		dictCandidate.Add "school_phone", school_phone
		dictCandidate.Add "school_degree", school_degree
		dictCandidate.Add "school_other", school_other
		dictCandidate.Add "school_begin_dt", school_begin_dt
		dictCandidate.Add "school_end_dt", school_end_dt
		dictCandidate.Add "company", company
        dictCandidate.Add "everifyStatus", everifyStatus
        dictCandidate.Add "everifyFormID", everifyFormID
        dictCandidate.Add "everifyStateID", everifyStateID
        dictCandidate.Add "everifyIDExperation", everifyIDExperation
        dictCandidate.Add "everifyDOH", everifyDOH 
		Set Session("dictCandidate") = dictCandidate
		Set dictCandidate = Nothing
		'ObjRec.Update
		'Response.cookies("id")=dictCandidate.Add "id")
		'Session("candidate_id") = ObjRec("id")
		'ObjRec.close
		'set ObjRec = nothing

		Response.Redirect "price.asp?company_id=" & company_id
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
                            <A href="main.asp?company_id=<%=company_id%>">Candidate List</A>
                        </h4>
                        <h4>Candidate Application - <%=company%></h4>
                        <font color="#FF0000"><strong><%=msg%></strong></font>
                        <FORM name="myForm" action="candidate.asp?company_id=<%=company_id%>" method="post">
                        <TABLE id="table_reg">
                            <tr>
                                <th colspan=2>Personal Information</th>
                            </tr>
                            <tr>
                                <TD align=right>First Name:</TD>
                                <td><INPUT name="fname" id=text2 value="<%=fname%>" size=36 maxlength="50"><FONT color=red>*</FONT></td>
                            </tr>
                            <TR>
                                <TD align=right>Middle Name:</TD>
                                <TD><INPUT name="other" id=text3 value="<%=other%>" size=30 maxlength="50"><FONT color=red>*</FONT></TD></TR>
                            <TR>
                                <TD align=right>Last Name:</TD>
                                <TD><INPUT name="lname" id=text2 value="<%=lname%>" size=30 maxlength="50"><FONT color=red>*</FONT></TD></TR>
                            <TR>
                                <TD align=right>Address:</TD>
                                <TD><INPUT name=address id=text4 value="<%=address%>" size=30 maxlength="50"><FONT color=red>*</FONT></TD></TR>
                            <TR>
                                <TD align=right>City:</TD>
                                <TD>
                          <INPUT name=city id=text5 value="<%=city%>" size=10 maxlength="50"><FONT color=red>*</FONT></TD></TR>
                                
                            <TR>
                                <TD align=right>State:</TD>
                                <TD>
                                <%=Write_State_Select("state",state)%>
                                <!--<INPUT id=text16 name=state size=10 value="<%=state%>">-->
                                <FONT color=red>*</FONT></TD></TR>
                            <TR>
                            <TD align=right>Zip:</TD>
                            <TD><INPUT name=zip id=text16 value="<%=zip%>" maxlength="50"><FONT color=red>*</FONT></TD></TR>
                            <TR>
                            <TD align=right>County:</TD>
                            <TD><INPUT name=county id=text6 value="<%=county%>" maxlength="50"><FONT color=red>*</FONT></TD></TR>
                            <TR>
                            <TD align=right>Position Type:</TD>
                            <TD><INPUT name=position_type id="Text13" value="<%=position_type%>" maxlength="50"><FONT color=red></FONT></TD></TR>
                            <TR>
                            <TD align=right>SSN:</TD>
                            <TD><INPUT name=ssn id=text6 value="<%=ssn%>" maxlength="50"><FONT color=#ff0000>*</FONT><FONT color=#000000> (EX: 
                          123-56-7890)</FONT></TD></TR>
                            <TR>
                            <TD align=right>Date of Birth:</TD>
                            <TD><INPUT name=dob id=text6 value="<%=dob%>" maxlength="50"><FONT color=#ff0000>*</FONT>(MM/dd/yy) 
                          (EX:02/16/70)</TD></TR>
                            <TR>
                            <TD align=right>Sex:</TD>
                            <TD><input type=radio name="sex" value="M" <% if sex = "M" then response.Write " checked" %>
                             >M<input type=radio name="sex" value="F" <% if sex = "F" then response.Write " checked" %>
                             >F</TD></TR>
                            <TR>
                            <TD align=right>Race:</TD>
                            <TD><INPUT name=race id=text6 value="<%=race%>" maxlength="50"></TD></TR>
                            <TR>
                            <TD align=right>Driver's License #:</TD>
                            <TD><INPUT name=drivers_lic id=text6 value="<%=drivers_lic%>" maxlength="50">&nbsp;&nbsp; from state:<INPUT name=dl_state id=text6 
                              style="WIDTH: 81px; HEIGHT: 22px" value="<%=dl_state%>" size=10 maxlength="50"><FONT 
                              color=#ff0000></FONT></TD></TR>
                            <TR>
                            <TD align=right>How long at this address?:</TD>
                            <TD><INPUT name=long_at_address id=text7 value="<%=long_at_address%>" maxlength="50"><FONT color=red>*</FONT></TD></TR>
                            <tr>
                            <th colspan=2><u>(If less than 7 years, list all other addresses below)</u></th>
                            </tr>
                            <tr>
                            <th colspan=2>Previous Addresses</th>
                            </tr>
                            <TR>
                            <TD align=right>1. Address:</TD>
                            <TD><INPUT name=prev_address id=text8 value="<%=prev_address%>" size=36 maxlength="50"></TD></TR>
                            <TR>
                            <TD align=right>City:</TD>
                            <TD><INPUT name=prev_city id=text9 value="<%=prev_city%>" maxlength="50"></TD></TR>
                            <TR>
                            <TD align=right>County:</TD>
                            <TD><INPUT name=prev_county id=text10 value="<%=prev_county%>" maxlength="50"></TD></TR>
                            <TR>
                            <TD align=right>State:</TD>
                            <TD>
                            <%=Write_State_Select("prev_state",prev_state)%>
                            <!--<INPUT id=text18 name=prev_state value="<%=prev_state%>">--></TD></TR>
                            <TR>
                            <TD align=right>Zip:</TD>
                            <TD><INPUT name=prev_zip id=text1 value="<%=prev_zip%>" size=10 maxlength="50"></TD></TR> 
                            <tr>
                            <th colspan=2>Last/Current Employer</th>
                            </tr>
                            <TR>
                            <TD align=right>Employer:</TD>
                            <TD><INPUT name=last_employer id=text8 value="<%=last_employer%>" size=36 maxlength="50"></TD></TR>
                            <TR>
                            <TD align=right>City:</TD>
                            <TD><INPUT name=last_emp_city id=text9 value="<%=last_emp_city%>" maxlength="50"></TD></TR>
                            <TR>
                            <TD align=right>State:</TD>
                            <TD>
                            <%=Write_State_Select("last_emp_state",last_emp_state)%>
                            <!--<INPUT id=text10 name=last_emp_state value="<%=last_emp_state%>">-->
                            </TD></TR>
                            <TR>
                            <TD align=right>County:</TD>
                            <TD><INPUT name=last_emp_county id=text18 value="<%=last_emp_county%>" maxlength="50"></TD></TR>
                            <TR>
                            <TD align=right>Phone:</TD>
                            <TD><INPUT name=last_emp_phone id=text1 value="<%=last_emp_phone%>" maxlength="50"></TD></TR>
                            <TR>
                            <TD align=right>Position:</TD>
                            <TD><INPUT name=last_emp_position id=text11 value="<%=last_emp_position%>" size=36 maxlength="50"></TD></TR>
                            <TR>
                            <TD align=right>Supervisor:</TD>
                            <TD><INPUT name=last_emp_supervisor id=text12 value="<%=last_emp_supervisor%>" size=36 maxlength="50"></TD></TR> 
                            <TR>
                            <TD align=right>Beginning Date:</TD>
                            <TD><INPUT name=last_emp_begin_dt id=text12 value="<%=last_emp_begin_dt%>" maxlength="50"></TD></TR> 
                            <TR>
                            <TD align=right>Ending Date:</TD>
                            <TD><INPUT name=last_emp_end_dt id=text12 value="<%=last_emp_end_dt%>" maxlength="50"></TD></TR> 
                            <tr>
                            <th colspan=2>Education</th>
                            </tr>
                            <TR>
                            <TD align=right>University/School:</TD>
                            <TD><INPUT name=school id=text8 value="<%=school%>" size=36 maxlength="50"></TD></TR>
                            <TR>
                            <TD align=right>Address:</TD>
                            <TD><INPUT name=school_address id="Text14" value="<%=school%>" size=36 maxlength="50"></TD></TR>
                            <TR>
                            <TD align=right>City:</TD>
                            <TD><INPUT name=school_city id=text9 value="<%=school_city%>" maxlength="50"></TD></TR>
                            <TR>
                            <TD align=right>State:</TD>
                            <TD>
                            <%=Write_State_Select("school_state",school_state)%>
                            <!--<INPUT id=text10 name=school_state value="<%=school_state%>">-->
                            </TD></TR>
                            <TR>
                            <TD align=right>County:</TD>
                            <TD><INPUT name=school_county id=text18 value="<%=school_county%>" maxlength="50"></TD></TR>
                            <TR>
                            <TD align=right>Phone:</TD>
                            <TD><INPUT name=school_phone id=text1 value="<%=school_phone%>" maxlength="50"></TD></TR>
                            <TR>
                            <TD align=right>Degree:</TD>
                            <TD><INPUT name=school_degree id=text11 value="<%=school_degree%>" size=36 maxlength="50"></TD></TR>
                            <TR>
                            <TD align=right>Other:</TD>
                            <TD><INPUT name=school_other id=text12 value="<%=school_other%>" size=36 maxlength="50"></TD></TR>
                            <TR>
                            <TD align=right>Beginning Date:</TD>
                            <TD><INPUT name=school_begin_dt id=text12 value="<%=school_begin_dt%>" maxlength="50"></TD></TR> 
                            <TR>
                            <TD align=right>Ending Date:</TD>
                            <TD><INPUT name=school_end_dt id=text12 value="<%=school_end_dt%>" maxlength="50"></TD></TR> 
                            <tr>
                            <th colspan=2>Required info for E-Verify Employment Eligibility Verification</th>
                            </tr>
                            <TR>
                            <TD align=right>Citizen status chosen on Section 1 of I-9:</TD>
                            <TD><!--<INPUT name=everifyStatus id=text15 value="<%=everifyStatus%>" maxlength="50">-->
                            <!--<select id =everifyStatus>
                                 <option value="">Chose One ...</option>
                                 <option value="A citizen of the United States">A citizen of the United States</option>
                                 <option value="A noncitizen of the United States">A noncitizen of the United States</option>
                                 <option value="A lawful permanent resident">A lawful permanent resident</option>
                                 <option value="An alien authorized to work<">An alien authorized to work</option>
                            </select>-->
                            
                            <%=Write_Everify("everifyStatus",everifyStatus)%>
                            </TD></TR>
                            <TR>
                            <TD align=right>Form of ID provided:</TD>
                            <TD><INPUT name=everifyFormID id="Text17" value="<%=everifyFormID%>" maxlength="50"></TD></TR>
                            <TR>
                            <TD align=right>State of Provided ID:</TD>
                            <TD><INPUT name=everifyStateID id=text19 value="<%=everifyStateID%>" maxlength="50"></TD></TR>
                            <TR>
                            <TD align=right>ID Expiration date:</TD>
                            <TD>
                            <INPUT name=everifyIDExperation id=text20 value="<%=everifyIDExperation%>" maxlength="50">
                            </TD></TR>
                             <TR>
                            <TD align=right>Date of hire:</TD>
                            <TD>
                            <INPUT name=everifyDOh id=text21 value="<%=everifyDOH%>" maxlength="50">
                            </TD></TR>
                            <TD colspan=2><INPUT id=submit1 name=submit1 type=submit value="Continue">
                            <INPUT id=reset1 name=reset1 type=reset value=Reset>&nbsp; 
                              <font color=red>Please continue finishing next page to complete your 
                            submiting.</font></TD>
                            </TR>
                        </TABLE></FORM>
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
<!--#include file="foot.asp" -->

</body>
</html>