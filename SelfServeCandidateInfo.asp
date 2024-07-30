<% 
Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cache"
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
dim msg,userid,name,company,company_rid,company_id,rs,token,hideAndShowForm,candidate_id

token = request.QueryString("token")

if token = "" then
	msg = "Not a valid token"
    hideAndShowForm = "display:none;"
else
    'check to see if they have been authed
    token = request.QueryString("token")
    Set rs = DB.Query("select hasAuthorized from SelfServeCandidate where authToken = ?",Array(token))
    If rs("hasAuthorized") = "0" Then
        msg = "Token not authorized for this client."
        hideAndShowForm = "display:none;"
    Else
        hideAndShowForm = ""
    End If

end if


name = Session("name")
company = Session("company")
company_id = Session("company_id")

dim sql, conn
Set conn = GetSQLServerConnection( db_machine, db_userid, db_password, db_database )

dim fname,lname,address,city,state,zip,county,position,ssn,race,dob
dim drivers_lic,dl_state,long_at_address,other,sex
dim prev_address,prev_city,prev_state,prev_zip,prev_county
dim last_employer,last_emp_city,last_emp_state,last_emp_zip,last_emp_phone
dim last_emp_county,last_emp_position,last_emp_supervisor,last_emp_begin_dt,last_emp_end_dt
dim school,school_city,school_state,school_county,school_phone,school_begin_dt,school_end_dt
dim everifyStatus, everifyFormID, everifyStateID, everifyIDExperation, everifyDOH

if request.QueryString("candidate_id") <> "" then
	dim rsCand
	sql = "Select * From candidate where company_id = " & company_id & " and id = " & request.QueryString("candidate_id")
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
		ssn = "" or dob = "" or long_at_address = "" or drivers_lic = "" or dl_state = ""  Then

		msg="Please complete all required fields."
	Else

        'copied code to load into dictionary... not really needed but it works.
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
		
        'Update the record
        
        SQL = "Select * From candidate Where id = " & Session("candidate_id")
        Set conn = GetSQLServerConnection( db_machine, db_userid, db_password, db_database )
	    Set ObjRec = GetSQLServerRecordset( conn, SQL )
        
	    ObjRec("fname") = dictCandidate.Item("fname")
	    ObjRec("lname") = dictCandidate.Item("lname")
	    ObjRec("other") = dictCandidate.Item("other")
	    ObjRec("address") = dictCandidate.Item("address")
	    ObjRec("city") = dictCandidate.Item("city")
	    ObjRec("state") = dictCandidate.Item("state")
	    ObjRec("zip") = dictCandidate.Item("zip")
	    ObjRec("county") = dictCandidate.Item("county")
	    ObjRec("position_type") = dictCandidate.Item("position_type")
	    ObjRec("ssn") = dictCandidate.Item("ssn")
	    ObjRec("dob") = dictCandidate.Item("dob")
	    ObjRec("sex") = dictCandidate.Item("sex")
	    ObjRec("race") = dictCandidate.Item("race")
	    ObjRec("drivers_lic") = dictCandidate.Item("drivers_lic")
	    ObjRec("dl_state") = dictCandidate.Item("dl_state")
	    ObjRec("long_at_address") = dictCandidate.Item("long_at_address")
	    ObjRec("prev_address") = dictCandidate.Item("prev_address")
	    ObjRec("prev_city") = dictCandidate.Item("prev_city")
	    ObjRec("prev_state") = dictCandidate.Item("prev_state")
	    ObjRec("prev_zip") = dictCandidate.Item("prev_zip")
	    ObjRec("prev_county") = dictCandidate.Item("prev_county")
	    ObjRec("last_employer") = dictCandidate.Item("last_employer")
	    ObjRec("last_emp_phone") = dictCandidate.Item("last_emp_phone")
	    ObjRec("last_emp_city") = dictCandidate.Item("last_emp_city")
	    ObjRec("last_emp_state") = dictCandidate.Item("last_emp_state")
	    ObjRec("last_emp_county") = dictCandidate.Item("last_emp_county")
	    ObjRec("last_emp_position") = dictCandidate.Item("last_emp_position")
	    ObjRec("last_emp_supervisor") = dictCandidate.Item("last_emp_supervisor")
	    ObjRec("last_emp_begin_dt") = dictCandidate.Item("last_emp_begin_dt")
	    ObjRec("last_emp_end_dt") = dictCandidate.Item("last_emp_end_dt")
	    ObjRec("school") = dictCandidate.Item("school")
	    ObjRec("school_city") = dictCandidate.Item("school_city")
	    ObjRec("school_state") = dictCandidate.Item("school_state")
	    ObjRec("school_county") = dictCandidate.Item("school_county")
	    ObjRec("school_phone") = dictCandidate.Item("school_phone")
	    ObjRec("school_degree") = dictCandidate.Item("school_degree")
	    ObjRec("school_other") = dictCandidate.Item("school_other")
	    ObjRec("school_begin_dt") = dictCandidate.Item("school_begin_dt")
	    ObjRec("school_end_dt") = dictCandidate.Item("school_end_dt")
        ObjRec("everifyStatus")  = dictCandidate.Item("everifyStatus")
        ObjRec("everifyFormID")  = dictCandidate.Item("everifyFormID")
	    ObjRec("everifyStateID")  = dictCandidate.Item("everifyStateID")
        ObjRec("everifyIDExperation")  = dictCandidate.Item("everifyIDExperation")
        ObjRec("everifyDOH")  = dictCandidate.Item("everifyDOH")
	    ObjRec.Update
	    ObjRec.close
	    set ObjRec = nothing

        'update has entered
        Call DB.Execute("update SelfServeCandidate set hasEntered = 1 where authToken = ?",Array(token))

        'update the results to match the state that was supplied
        Call DB.Execute("update result set state = ? where id = ?",Array(dictCandidate.Item("state"),Session("candidate_id")))

        dim sTo,sSubject

        Set rs = GetSQLServerStaticRecordset(conn, "Select * From candidate where id = " & Session("candidate_id"))

	    body= "<html><head><title>New Identi-Check Candidate Submission</title></head></body>"  & vbCrLf
	    body= body & "<table cellpadding=1 cellspacing=0 border=1>"  & vbCrLf
	    body= body & "<tr><td>Time</td><td>" & rs("date1") & "</td></tr>" & vbCrLf
	    body= body & "<tr><td>Company Name</td><td>" & rs("company") & "</td></tr>" & vbCrLf
	    body= body & "<tr><td>Company #</td><td>" & rs("company_id") & "</td></tr>" & vbCrLf
	    body= body & "<tr><td>Candidate ID</td><td>" & Session("candidate_id") & "</td></tr>" & vbCrLf
	    body= body & "<tr><td>Name</td><td>" & rs("fname") & " " & rs("lname") & "</td></tr>" & vbCrLf
	    body= body & "<tr><td colspan=2>&nbsp;</td></tr>" & vbCrLf
	    'body= body & "<tr><td><b>Package</b></td><td><b>Price</b></td></tr>" & vbCrLf
	    'body= body & pkg_body
	    'body= body & "<tr><td><b>Single Options</b></td><td>&nbsp;</td></tr>" & vbCrLf
	    'body= body & single_body
	    body= body & "<tr><td>Total</td><td>" & FormatCurrency(rs("total")) & "</td></tr>" & vbCrLf
	    body= body & "</table>" & vbCrLf
	    body= body & "</body></html>" & vbCrLf
	    rs.close
	    set rs = nothing

	    If db_platform = "test" Then
			sTo="micah@identi-check.com"
			sSubject="Self Serve  - New Candidate for Identi-check - TEST SERVER"
	    Else
			sTo="jennifer@identi-check.com;micah@identi-check.com"
			sSubject="Self Serve  - New Candidate for Identi-check"
	    End If

		sSubject="Self Serve  - New Candidate for Identi-check"	

	    call SendHTMLEmail(sTo, sSubject, body)

        hideAndShowForm = "display:none;"
        msg = "Information has been submitted."

        'reset session vars just in case.
        Session("company") = ""
        Session("name") = ""
        Session("company_id") = ""
        Session("candidate_id") = ""
	end if

End If
if state = "" then state = "IL"
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
      <title></title>
    <!--#include file="head.asp" -->
</head>
<body>
    <center>
        <!-- *************************************** MAIN CONTENT AREA *************************************** -->
        <table width="619px" height="419" cellpadding="0" cellspacing="0" border="0">
            <tr>
                <td width="610px" valign="top" align="center">
                    <table width="590px" cellpadding="0" cellspacing="0" border="0">
                        <tr align="left">
                            <td>

                                <h4>Request Candidate Application - <%=company%></h4>
                                <font color="#FF0000"><strong><%=msg%></strong></font>
                                <form name="myForm" action="SelfServeCandidateInfo.asp?token=<%=token%>" method="post" style="<%=hideAndShowForm%>">
                                    <table id="table_reg">
                                        <tr>
                                            <th colspan="2">Personal Information</th>
                                        </tr>
                                        <tr>
                                            <td align="right">First Name:</td>
                                            <td>
                                                <input name="fname" id="text2" value="<%=fname%>" size="36" maxlength="50"/><font color="red">*</font></td>
                                        </tr>
                                        <tr>
                                            <td align="right">Middle Name:</td>
                                            <td>
                                                <input name="other" id="text3" value="<%=other%>" size="30" maxlength="50"/><font color="red">*</font></td>
                                        </tr>
                                        <tr>
                                            <td align="right">Last Name:</td>
                                            <td>
                                                <input name="lname" id="text2" value="<%=lname%>" size="30" maxlength="50"/><font color="red">*</font></td>
                                        </tr>
                                        <tr>
                                            <td align="right">Address:</td>
                                            <td>
                                                <input name="address" id="text4" value="<%=address%>" size="30" maxlength="50"/><font color="red">*</font></td>
                                        </tr>
                                        <tr>
                                            <td align="right">City:</td>
                                            <td>
                                                <input name="city" id="text5" value="<%=city%>" size="10" maxlength="50"/><font color="red">*</font></td>
                                        </tr>

                                        <tr>
                                            <td align="right">State:</td>
                                            <td>
                                                <%=Write_State_Select("state",state)%>
                                                <!--<INPUT id=text16 name=state size=10 value="<%=state%>">-->
                                                <font color="red">*</font></td>
                                        </tr>
                                        <tr>
                                            <td align="right">Zip:</td>
                                            <td>
                                                <input name="zip" id="text16" value="<%=zip%>" maxlength="50"/><font color="red">*</font></td>
                                        </tr>
                                        <tr>
                                            <td align="right">County:</td>
                                            <td>
                                                <input name="county" id="text6" value="<%=county%>" maxlength="50"/><font color="red">*</font></td>
                                        </tr>
                                        <tr>
                                            <td align="right">Position Type:</td>
                                            <td>
                                                <input name="position_type" id="Text13" value="<%=position_type%>" maxlength="50"/><font color="red"></font></td>
                                        </tr>
                                        <tr>
                                            <td align="right">SSN:</td>
                                            <td>
                                                <input name="ssn" id="text6" value="<%=ssn%>" maxlength="50"/><font color="#ff0000">*</font><font color="#000000"> (EX: 
                          123-56-7890)</font></td>
                                        </tr>
                                        <tr>
                                            <td align="right">Date of Birth:</td>
                                            <td>
                                                <input name="dob" id="text6" value="<%=dob%>" maxlength="50"/><font color="#ff0000">*</font>(MM/dd/yy) 
                          (EX:02/16/70)</td>
                                        </tr>
                                        <tr>
                                            <td align="right">Sex:</td>
                                            <td>
                                                <input type="radio" name="sex" value="M" <% if sex = "M" then response.Write " checked" %>/>M<input type="radio" name="sex" value="F" <% if sex = "F" then response.Write " checked" %>/>F</td>
                                        </tr>
                                        <tr>
                                            <td align="right">Race:</td>
                                            <td>
                                                <input name="race" id="text6" value="<%=race%>" maxlength="50"/></td>
                                        </tr>
                                        <tr>
                                            <td align="right">Drivers License or State ID Number:</td>
                                            <td>
                                                <input name="drivers_lic" id="text6" value="<%=drivers_lic%>" maxlength="50"/><font color="red">*</font>&nbsp;&nbsp; from state:<input name="dl_state" id="text6"
                                                    style="width: 81px; height: 22px" value="<%=dl_state%>" size="10" maxlength="50"/><font
                                                        color="#ff0000"></font><font color="red">*</font></td>
                                        </tr>
                                        <tr>
                                            <td align="right">How long at this address?:</td>
                                            <td>
                                                <input name="long_at_address" id="text7" value="<%=long_at_address%>" maxlength="50"/><font color="red">*</font></td>
                                        </tr>
                                        <tr>
                                            <th colspan="2"><u>(If less than 7 years, list all other addresses below)</u></th>
                                        </tr>
                                        <tr>
                                            <th colspan="2">Previous Addresses</th>
                                        </tr>
                                        <tr>
                                            <td align="right">1. Address:</td>
                                            <td>
                                                <input name="prev_address" id="text8" value="<%=prev_address%>" size="36" maxlength="50"/></td>
                                        </tr>
                                        <tr>
                                            <td align="right">City:</td>
                                            <td>
                                                <input name="prev_city" id="text9" value="<%=prev_city%>" maxlength="50"/></td>
                                        </tr>
                                        <tr>
                                            <td align="right">County:</td>
                                            <td>
                                                <input name="prev_county" id="text10" value="<%=prev_county%>" maxlength="50"/></td>
                                        </tr>
                                        <tr>
                                            <td align="right">State:</td>
                                            <td>
                                                <%=Write_State_Select("prev_state",prev_state)%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right">Zip:</td>
                                            <td>
                                                <input name="prev_zip" id="text1" value="<%=prev_zip%>" size="10" maxlength="50"/></td>
                                        </tr>
                                        <tr>
                                            <th colspan="2">Last/Current Employer</th>
                                        </tr>
                                        <tr>
                                            <td align="right">Employer:</td>
                                            <td>
                                                <input name="last_employer" id="text8" value="<%=last_employer%>" size="36" maxlength="50"/></td>
                                        </tr>
                                        <tr>
                                            <td align="right">City:</td>
                                            <td>
                                                <input name="last_emp_city" id="text9" value="<%=last_emp_city%>" maxlength="50"/></td>
                                        </tr>
                                        <tr>
                                            <td align="right">State:</td>
                                            <td>
                                                <%=Write_State_Select("last_emp_state",last_emp_state)%>
                                                <!--<INPUT id=text10 name=last_emp_state value="<%=last_emp_state%>">-->
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right">County:</td>
                                            <td>
                                                <input name="last_emp_county" id="text18" value="<%=last_emp_county%>" maxlength="50"/></td>
                                        </tr>
                                        <tr>
                                            <td align="right">Phone:</td>
                                            <td>
                                                <input name="last_emp_phone" id="text1" value="<%=last_emp_phone%>" maxlength="50"/></td>
                                        </tr>
                                        <tr>
                                            <td align="right">Position:</td>
                                            <td>
                                                <input name="last_emp_position" id="text11" value="<%=last_emp_position%>" size="36" maxlength="50"/></td>
                                        </tr>
                                        <tr>
                                            <td align="right">Supervisor:</td>
                                            <td>
                                                <input name="last_emp_supervisor" id="text12" value="<%=last_emp_supervisor%>" size="36" maxlength="50"/></td>
                                        </tr>
                                        <tr>
                                            <td align="right">Beginning Date:</td>
                                            <td>
                                                <input name="last_emp_begin_dt" id="text12" value="<%=last_emp_begin_dt%>" maxlength="50"/></td>
                                        </tr>
                                        <tr>
                                            <td align="right">Ending Date:</td>
                                            <td>
                                                <input name="last_emp_end_dt" id="text12" value="<%=last_emp_end_dt%>" maxlength="50"/></td>
                                        </tr>
                                        <tr>
                                            <th colspan="2">Education</th>
                                        </tr>
                                        <tr>
                                            <td align="right">University/School:</td>
                                            <td>
                                                <input name="school" id="text8" value="<%=school%>" size="36" maxlength="50"/></td>
                                        </tr>
                                        <tr>
                                            <td align="right">Address:</td>
                                            <td>
                                                <input name="school_address" id="Text14" value="<%=school%>" size="36" maxlength="50"/></td>
                                        </tr>
                                        <tr>
                                            <td align="right">City:</td>
                                            <td>
                                                <input name="school_city" id="text9" value="<%=school_city%>" maxlength="50"/></td>
                                        </tr>
                                        <tr>
                                            <td align="right">State:</td>
                                            <td>
                                                <%=Write_State_Select("school_state",school_state)%>
                                                <!--<INPUT id=text10 name=school_state value="<%=school_state%>">-->
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right">County:</td>
                                            <td>
                                                <input name="school_county" id="text18" value="<%=school_county%>" maxlength="50"/></td>
                                        </tr>
                                        <tr>
                                            <td align="right">Phone:</td>
                                            <td>
                                                <input name="school_phone" id="text1" value="<%=school_phone%>" maxlength="50"/></td>
                                        </tr>
                                        <tr>
                                            <td align="right">Degree:</td>
                                            <td>
                                                <input name="school_degree" id="text11" value="<%=school_degree%>" size="36" maxlength="50"/></td>
                                        </tr>
                                        <tr>
                                            <td align="right">Other:</td>
                                            <td>
                                                <input name="school_other" id="text12" value="<%=school_other%>" size="36" maxlength="50"/></td>
                                        </tr>
                                        <tr>
                                            <td align="right">Beginning Date:</td>
                                            <td>
                                                <input name="school_begin_dt" id="text12" value="<%=school_begin_dt%>" maxlength="50"/>td>
                                        </tr>
                                        <tr>
                                            <td align="right">Ending Date:</td>
                                            <td>
                                                <input name="school_end_dt" id="text12" value="<%=school_end_dt%>" maxlength="50"/></td>
                                        </tr>
                                        <tr>
                                            <th colspan="2">Required info for E-Verify Employment Eligibility Verification</th>
                                        </tr>
                                        <tr>
                                            <td align="right">Citizen status chosen on Section 1 of I-9:</td>
                                            <td>
                                                <%=Write_Everify("everifyStatus",everifyStatus)%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right">Form of ID provided:</td>
                                            <td>
                                                <input name="everifyFormID" id="Text17" value="<%=everifyFormID%>" maxlength="50"/></td>
                                        </tr>
                                        <tr>
                                            <td align="right">State of Provided ID:</td>
                                            <td>
                                                <input name="everifyStateID" id="text19" value="<%=everifyStateID%>" maxlength="50"/></td>
                                        </tr>
                                        <tr>
                                            <td align="right">ID Expiration date:</td>
                                            <td>
                                                <input name="everifyIDExperation" id="text20" value="<%=everifyIDExperation%>" maxlength="50"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right">Date of hire:</td>
                                            <td>
                                                <input name="everifyDOh" id="text21" value="<%=everifyDOH%>" maxlength="50"/>
                                            </td>
                                        </tr>
                                        <tr>
                                        <td colspan="2">
                                            <input id="submit1" name="submit1" type="submit" value="Continue"/>
                                            <input id="reset1" name="reset1" type="reset" value="Reset"/>&nbsp; 
                              <font color="red">Please continue finishing next page to complete your submiting.</font>

                                        </td>
                                        </tr>
                        </tr>
                    </table>
                    </FORM>
                </td>
            </tr>
        </table>
        </td>
    </tr>
</table>
            

        <!-- ************************************* END MAIN CONTENT AREA ************************************* -->
</center>
        <!--#include file="foot.asp" -->
</body>
</html>
