<!-- #include virtual="db_constants.fun" -->
<!-- #include virtual="DB.fun" -->
<!-- #include virtual="functions.inc" -->
<!-- #include file ="adovbs.inc" -->
<%
dim msg, userid,name,company,company_rid,company_id

id = request("id")
msg = request("msg")
name = Session("name")
company = Session("company")
company_rid = Session("company_rid")
company_id  =request.querystring("company_id")
'last_name=request("last_name")
'Response.Cookies("id") = id
'name=Request.cookies("name")
'Response.cookies("name")=name
'company=Request.cookies("company")
'Response.cookies("company")=company

If CInt(company_rid) <> CInt(company_id) and company_rid <> 0 Then
	'not valid bounce back to login
	Response.Redirect "index.asp?msg1=Invalid company selection"
End If

dim fname,lname,address,city,state,zip,county,position_type,ssn,race,dob
dim drivers_lic,dl_state,long_at_address,other,sex
dim prev_address,prev_city,prev_state,prev_zip,prev_county
dim last_employer,last_emp_city,last_emp_state,last_emp_zip,last_emp_phone
dim last_emp_county,last_emp_position,last_emp_supervisor,last_emp_begin_dt,last_emp_end_dt
dim school,school_city,school_state,school_county,school_phone,school_begin_dt,school_end_dt
dim everifyStatus, everifyFormID, everifyStateID, everifyIDExperation, everifyDOH



Set conn = GetSQLServerConnection( db_machine, db_userid, db_password, db_database ) 

If request.form("submit1") = "Update" Then
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

	'update
	dim ObjRec
	'Set ObjRec=Server.CreateObject("ADODB.RecordSet")
	'StrConnect="Provider=SQLOLEDB.1; Data Source= " & db_machine & "; User ID=" & db_userid & "; Password=" & db_password & "; Initial Catalog=" & db_database

	'ObjRec.CursorLocation = 3
	'ObjRec.Open "candidate", StrConnect, adOpenStatic, adLockOptimistic, adCmdTable
	SQL = "Select * From candidate Where id = " & id
	Set ObjRec = GetSQLServerRecordset( conn, SQL )

	ObjRec("fname") = fname
	ObjRec("lname") = lname
	ObjRec("other") = other
	ObjRec("address") = address
	ObjRec("city") = city
	ObjRec("state") = state
	ObjRec("zip") = zip
	ObjRec("county") = county
	ObjRec("position_type") = position_type
	ObjRec("ssn") = ssn
	ObjRec("dob") = dob
	ObjRec("race") = race
	ObjRec("sex") = sex
	ObjRec("drivers_lic") = drivers_lic
	ObjRec("dl_state") = dl_state
	ObjRec("long_at_address") = long_at_address
	ObjRec("prev_address") = prev_address
	ObjRec("prev_city") = prev_city
	ObjRec("prev_state") = prev_state
	ObjRec("prev_zip") = prev_zip
	ObjRec("prev_county") = prev_county
	ObjRec("last_employer") = last_employer

	ObjRec("last_emp_phone") = last_emp_phone
	ObjRec("last_emp_city") = last_emp_city
	ObjRec("last_emp_state") = last_emp_state
	ObjRec("last_emp_county") = last_emp_county
	ObjRec("last_emp_position") = last_emp_position
	ObjRec("last_emp_supervisor") = last_emp_supervisor
	ObjRec("last_emp_begin_dt") = last_emp_begin_dt
	ObjRec("last_emp_end_dt") = last_emp_end_dt
	ObjRec("school") = school
	ObjRec("school_city") = school_city
	ObjRec("school_state") = school_state
	ObjRec("school_county") = school_county
	ObjRec("school_phone") = school_phone
	ObjRec("school_degree") = school_degree
	ObjRec("school_other") = school_other
	ObjRec("school_begin_dt") = school_begin_dt
	ObjRec("school_end_dt") = school_end_dt
    ObjRec("everifyStatus") = everifyStatus
    ObjRec("everifyFormID") = everifyFormID
    ObjRec("everifyStateID") = everifyStateID
    ObjRec("everifyIDExperation") = everifyIDExperation
    ObjRec("everifyDOH") = everifyDOH
	ObjRec.Update
	ObjRec.close
	set ObjRec = nothing

	msg = "The candidate has been updated."
	Response.Redirect "main.asp?company_id=" & company_id & "&msg=" & msg
End If

SQL = "Select * From candidate Where id = " & id
Set rs = GetSQLServerRecordset( conn, SQL )

fname = rs("fname"):lname = rs("lname"):address = rs("address")
city = rs("city"):state = rs("state"):zip = rs("zip"):county = rs("county")
position_type = rs("position_type"):ssn = rs("ssn"):race = rs("race"):sex = rs("sex")
dob = rs("dob"):drivers_lic = rs("drivers_lic"):dl_state = rs("dl_state")
long_at_address = rs("long_at_address"):prev_address = rs("prev_address")
prev_city = rs("prev_city"):prev_state = rs("prev_state"):prev_zip = rs("prev_zip")
prev_county = rs("prev_county"):last_employer = rs("last_employer"):last_emp_phone = rs("last_emp_phone")
last_emp_city = rs("last_emp_city"):last_emp_state = rs("last_emp_state")
last_emp_county = rs("last_emp_county"):last_emp_position = rs("last_emp_position")
last_emp_supervisor = rs("last_emp_supervisor"):last_emp_begin_dt = rs("last_emp_begin_dt")
last_emp_end_dt = rs("last_emp_end_dt"):school = rs("school"):school_city = rs("school_city")
school_state = rs("school_state"):school_county = rs("school_county"):school_phone = rs("school_phone")
school_begin_dt = rs("school_begin_dt"):school_end_dt = rs("school_end_dt")
other = rs("other"):school_degree = rs("school_degree"):school_other = rs("school_other")
everifyStatus = rs("everifyStatus").value:everifyFormID = rs("everifyFormID").value
everifyStateID = rs("everifyStateID").value:everifyIDExperation = rs("everifyIDExperation").value
everifyDOH = rs("everifyDOH").value
rs.close
set rs = nothing

conn.close
set conn = nothing

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
                        <h4>Update Candidate Information</h4>
                        
                        <FORM name="" action="candidate_update.asp?id=<%=id%>&company_id=<%=company_id%>" method="post">
                            <TABLE id="table_reg">
                                <tr>
                                    <th colspan="2">Personal Information</th>
                                </tr>
                                <tr>
                                    <TD align=right><FONT color=red>*</FONT>First Name:</TD>
                                    <td><INPUT id=text2 name="fname" size=36 value="<%=fname%>"></td>
                                </tr>
                                <TR>
                                    <TD align=right><FONT color=red>*</FONT>Middle Name:</TD>
                                    <TD>&nbsp;<INPUT value="<%=other%>" id=text3 name="other" size=30></TD>
                                </TR>
                                <TR>
                                    <TD align=right><FONT color=red>*</FONT>Last Name:</TD>
                                    <TD><INPUT value="<%=lname%>" name="lname" size=30></TD>
                                </TR>
                                <TR>
                                    <TD align=right>Address:</TD>
                                    <TD><INPUT value="<%=address%>" id=text4 name=address size=30></TD>
                                </TR>
                                <TR>
                                    <TD align=right><FONT color=red>*</FONT>City:</TD>
                                    <TD><INPUT value="<%=city%>" id=text5 name=city size=10></TD>
                                </TR>
                                <TR>
                                    <TD align=right><FONT color=red>*</FONT>State:</TD>
                                    <TD><%=Write_State_Select("state",state)%>
                                    <!--<INPUT value="<%=state%>" id=text16 name=state size=10>-->
                                    </TD>
                                </TR>
                                <TR>
                                    <TD align=right><FONT color=red>*</FONT>Zip:</TD>
                                    <TD><INPUT value="<%=zip%>" id=text16 name=zip></TD>
                                </TR>
                                <TR>
                                    <TD align=right><FONT color=red>*</FONT>County:</TD>
                                    <TD><INPUT value="<%=county%>" id=text6 name=county></TD>
                                </TR>
                                <TR>
                                    <TD align=right><FONT color=red></FONT>Position Type:</TD>
                                    <TD><INPUT value="<%=position_type%>" id="Text13" name=position_type></TD>
                                </TR>
                                <TR>
                                    <TD align=right><FONT color=red>*</FONT>SSN:</TD>
                                    <TD><INPUT value="<%=ssn%>"  name=ssn></TD>
                                </TR>
                                <TR>
                                    <TD align=right><FONT color=red>*</FONT>Date of Birth:</TD>
                                    <TD><INPUT value="<%=dob%>"  name=dob>(MM/dd/yy) (EX:02/16/70)</TD>
                                </TR>
                                <TR>
                                    <TD align=right>Sex:</TD>
                                    <TD><input  name="sex" value="<%=sex%>"> </TD>
                                </TR>
                                <TR>
                                    <TD align=right>Race:</TD>
                                    <TD><INPUT value="<%=race%>" name=race></TD>
                                </TR>
                                <TR>
                                    <TD align=right>Driver's License #:</TD>
                                    <TD><INPUT value="<%=drivers_lic%>" name=drivers_lic>&nbsp;&nbsp; from state:<INPUT value="<%=dl_state%>" style="WIDTH: 81px; HEIGHT: 22px" size=10 name=dl_state></TD>
                                </TR>
                                <TR>
                                    <TD align=right><FONT color=red>*</FONT>How long at this address?:</TD>
                                    <TD><INPUT value="<%=long_at_address%>" id=text7 name=long_at_address></TD>
                                </TR>
                                <tr>
                                    <th colspan="2">(If less than 7 years, list all other addresses below)<br />
                                    Previous Addresses</th>
                                </tr>
                                <TR>
                                    <TD align=right>1. Address:</TD>
                                    <TD><INPUT value="<%=prev_address%>" id=text8 name=prev_address size=36></TD>
                                </TR>
                                <TR>
                                    <TD align=right>City:</TD>
                                    <TD><INPUT value="<%=prev_city%>" id=text9 name=prev_city></TD>
                                </TR>
                                <TR>
                                    <TD align=right>County:</TD>
                                    <TD><INPUT value="<%=prev_county%>" id=text10 name=prev_county></TD>
                                </TR>
                                <TR>
                                    <TD align=right>State:</TD>
                                    <TD>
                                    <%=Write_State_Select("prev_state",prev_state)%>
                                    <!--<INPUT value="<%=prev_state%>" id=text18 name=prev_state>-->
                                    </TD>
                                </TR>
                                <TR>
                                    <TD align=right>Zip:</TD>
                                    <TD><INPUT value="<%=prev_zip%>" id=text1 name=prev_zip size=10></TD>
                                </TR>
                                <tr>
                                    <th colspan="2"><b>Last/Current Employer/Education</b></td>
                                </tr>
                                <TR>
                                    <TD align=right>Employer:</TD>
                                    <TD><INPUT value="<%=last_employer%>" id=text8 name=last_employer size=36></TD>
                                </TR>
                                <TR>
                                    <TD align=right>City:</TD>
                                    <TD><INPUT value="<%=last_emp_city%>" id=text9 name=last_emp_city></TD>
                                </TR>
                                <TR>
                                    <TD align=right>State:</TD>
                                    <TD>
                                    <%=Write_State_Select("last_emp_state",last_emp_state)%>
                                    <!--<INPUT value="<%=last_emp_state%>" id=text10 name=last_emp_state>-->
                                    </TD>
                                </TR>
                                <TR>
                                    <TD align=right>County:</TD>
                                    <TD><INPUT value="<%=last_emp_county%>" id=text18 name=last_emp_county></TD>
                                </TR>
                                <TR>
                                    <TD align=right>Phone:</TD>
                                    <TD><INPUT value="<%=last_emp_phone%>" id=text1 name=last_emp_phone></TD>
                                </TR>
                                <TR>
                                    <TD align=right>Position:</TD>
                                    <TD><INPUT value="<%=last_emp_position%>" id=text11 name=last_emp_position size=36></TD>
                                </TR>
                                <TR>
                                    <TD align=right>Supervisor:</TD>
                                    <TD><INPUT value="<%=last_emp_supervisor%>" id=text12 name=last_emp_supervisor size=36></TD>
                                </TR> 
                                <TR>
                                    <TD align=right>Beginning Date:</TD>
                                    <TD><INPUT value="<%=last_emp_begin_dt%>" id=text12 name=last_emp_begin_dt></TD>
                                </TR> 
                                <TR>
                                    <TD align=right>Ending Date:</TD>
                                    <TD><INPUT value="<%=last_emp_end_dt%>" id=text12 name=last_emp_end_dt></TD>
                                </TR> 
                                <tr>
                                    <th colspan=2>Education</th>
                                </tr>
                                <TR>
                                    <TD align=right>University/School:</TD>
                                    <TD><INPUT value="<%=school%>" id=text8 name=school size=36></TD>
                                </TR>
                                <TR>
                                    <TD align=right>City:</TD>
                                    <TD><INPUT value="<%=school_city%>" id=text9 name=school_city></TD>
                                </TR>
                                <TR>
                                    <TD align=right>State:</TD>
                                    <TD>
                                    <%=Write_State_Select("school_state",school_state)%>
                                    <!--<INPUT value="<%=school_state%>" id=text10 name=school_state>-->
                                	</TD>
                                </TR>
                                <TR>
                                    <TD align=right>County:</TD>
                                    <TD><INPUT value="<%=school_county%>" id=text18 name=school_county></TD>
                                </TR>
                                <TR>
                                    <TD align=right>Phone:</TD>
                                    <TD><INPUT value="<%=school_phone%>" id=text1 name=school_phone></TD>
                                </TR>
                                <TR>
                                    <TD align=right>Degree:</TD>
                                    <TD><INPUT value="<%=school_degree%>" id=text11 name=school_degree size=36></TD>
                                </TR>
                                <TR>
                                    <TD align=right>Other</TD>
                                    <TD><INPUT value="<%=school_other%>" id=text12 name=school_other size=36></TD>
                                </TR> 
                                <TR>
                                    <TD align=right>Beginning Date:</TD>
                                    <TD><INPUT value="<%=school_begin_dt%>" id=text12 name=school_begin_dt></TD>
                                </TR> 
                                <TR>
                                    <TD align=right>Ending Date:</TD>
                                    <TD><INPUT value="<%=school_end_dt%>" id=text12 name=school_end_dt></TD>
                                </TR> 
                                <tr>
                            <th colspan=2>Required info for E-Verify Employment Eligibility Verification</th>
                            </tr>
                            <TR>
                            <TD align=right>Citizen status chosen on Section 1 of I9:</TD>
                            <TD><%=Write_Everify("everifyStatus",everifyStatus)%></TD></TR>
                            <TR>
                            <TD align=right>Form of ID provided:</TD>
                            <TD><INPUT name=everifyFormID id="Text17" value="<%=everifyFormID%>" maxlength="50"></TD></TR>
                            <TR>
                            <TD align=right>State of Provided ID:</TD>
                            <TD><INPUT name=everifyStateID id=text19 value="<%=everifyStateID%>" maxlength="50"></TD></TR>
                            <TR>
                            <TD align=right>ID Experation date:</TD>
                            <TD>
                            <INPUT name=everifyIDExperation id=text20 value="<%=everifyIDExperation%>" maxlength="50">
                            </TD></TR>
                             <TR>
                            <TD align=right>Date of hire:</TD>
                            <TD>
                            <INPUT name=everifyDOH id=text21 value="<%=everifyDOH%>" maxlength="50">
                            </TD></TR>
                                <TR>
                                    <TD colspan=2 align="right">
																		<% if session("admin") = 2 then	%>
																			<INPUT id=submit1 name=submit1 type=submit value=Update>
																			<INPUT id=reset1 name=reset1 type=reset value=Reset>
																		<% else %>
																		&nbsp;
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