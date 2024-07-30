<% 
Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cache"
'Response.AddHeader "cache-control", "private"
Response.Expires = -1 
%>
<!-- #include virtual="db_constants.fun" -->
<!-- #include virtual="DB.fun" -->
<!-- #include file ="adovbs.inc" -->
<%
'session("validuser")=True
dim msg, userid,name,company,company_rid,company_id
dim candidate_id
msg=Request("msg")
userid = Session("UserID")
name = Session("name")
'company = Session("company")
company_rid = Session("company_rid")
company_id  =request.querystring("company_id")
company = GetCompanyName(company_id)
'candidate_id = session("candidate_id")
volume_discount = session("volume_discount")
If volume_discount = "" Then
	volume_discount = "0"
end if

dim state_il,state_ky,state_mo,state_tn
dim mvr_il,mvr_ky,mvr_mo,mvr_tn
dim workers_il,workers_ky,workers_mo,workers_tn
dim emp_verify,ed_verify,credit,ssn_verify,fed_crime
'state_il="19":state_ky="25":state_mo="22":state_tn="21"
'mvr_il="27":mvr_ky="12":mvr_mo="27":mvr_tn="27"
'workers_il="18":workers_ky="25":workers_mo="18":workers_tn="18"
'emp_verify="10":ed_verify="15":credit="15":ssn_verify="12"

dim b_desc, bp_desc, e_desc, ep_desc, c_desc, bk_desc, t_desc
b_desc = "Basic<br>Statewide Criminal Search, Motor Vehicle Report"
bp_desc = "Basic Plus<br>Statewide Criminal Search, Employment Verification, Educational Verification"
e_desc = "Enhanced<br>Statewide Criminal Search, Employment Verification, Credit Report"
ep_desc = "Enhanced Plus<br>Statewide Criminal Search, Employment Verification, Credit Report, Motor Vehicle Report"
c_desc = "Comprehensive<br>Statewide Criminal Search, Employment Verification, Credit Report, Motor Vehicle Record, Educational Verification, Social Security Number Verification"
q_desc = "Qualified<br>Statewide Criminal Search, Motor Vehicle Report, Workers Compensation Report, County Criminal History"
bk_desc = "Banker's Choice<br>Statewide Criminal Search, Federal Criminal, Motor Vehicle Report, Employment Verification"
t_desc = "Thorough<br>SSN Verification and Trace,(2) County Criminal (Current & Previous County of Residence), Motor Vehicle Report, Employment Verification"
n_desc = "No Package Selected"

'name=Request.cookies("name")
'Response.cookies("name")=name
'company=Request.cookies("company")
'Response.cookies("company")=company
'id=Request.cookies("id")
'Response.cookies("id")=id
'company_id=request("company_id")
dim dictPrice, dictDesc
dim pkg_b_checked,pkg_bp_checked,pkg_e_checked,pkg_ep_checked,pkg_c_checked,pkg_q_checked,pkg_n_checked
dim rsPrice, sql, conn
Set dictPrice = Server.createobject("Scripting.Dictionary")
Set dictDesc = Server.createobject("Scripting.Dictionary")
dictPrice.RemoveAll:dictDesc.RemoveAll
Set conn = GetSQLServerConnection( db_machine, db_userid, db_password, db_database )
sql = "Select option_name as name, option_cost as cost, price_chg_dt as date, [desc], display_order, 'Y' as special " & _
			 "From subscriber_pricing sp, pricing_option po " & _
			 "Where sp.option_name = po.name and sp.subscriber_id = " & company_id & _
			"Union All " & _
			 "Select name, default_cost as cost, '' as date, [desc], display_order, 'N' as special " & _
			 "From pricing_option " & _
			 "Where name not in (select option_name from subscriber_pricing where subscriber_id = " & company_id & ") " & _
			 " and hide <> 'Y' Order By date desc, display_order "
Set rsPrice = GetSQLServerRecordset( conn, sql)
Do While not rsPrice.EOF
	dictPrice.Add rsPrice("name").value, rsPrice("cost").value
	dictDesc.Add rsPrice("name").value, rsPrice("desc").value
	rsPrice.Movenext
Loop
rsPrice.close
set rsPrice = nothing
'rsPrice.movefirst

state_il=dictPrice.Item("state_il"):state_in=dictPrice.Item("state_in"):state_ky=dictPrice.Item("state_ky"):state_mo=dictPrice.Item("state_mo"):state_tn=dictPrice.Item("state_tn"):state_mo=dictPrice.Item("state_mo")
mvr_il=dictPrice.Item("mvr_il"):mvr_in=dictPrice.Item("mvr_in"):mvr_ky=dictPrice.Item("mvr_ky"):mvr_mo=dictPrice.Item("mvr_mo"):mvr_tn=dictPrice.Item("mvr_tn"):mvr_mo=dictPrice.Item("mvr_mo")
workers_il=dictPrice.Item("workers_il"):workers_in=dictPrice.Item("workers_in"):workers_ky=dictPrice.Item("workers_ky"):workers_mo=dictPrice.Item("workers_mo"):workers_tn=dictPrice.Item("workers_tn"):workers_mo=dictPrice.Item("workers_mo")
emp_verify=dictPrice.Item("emp_verify"):ed_verify=dictPrice.Item("ed_verify"):credit=dictPrice.Item("credit"):ssn_verify=dictPrice.Item("ssn_verify"):county_crime=dictPrice.Item("county_crime"):fed_crime=dictPrice.Item("fed_crime")

If request.form("submit") = "Submit" then
	dim dictCandidate
	'Set dictCandidate = Server.createobject("Scripting.Dictionary")
	Set dictCandidate = Session("dictCandidate")
	
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
	ObjRec("company")  = dictCandidate.Item("company")
	ObjRec.Update
	Set dictCandidate = nothing
	Set Session("dictCandidate") = nothing
	'Response.cookies("id")=ObjRec("id")
	Session("candidate_id") = ObjRec("id")
	candidate_id = session("candidate_id")
	ObjRec.close
	set ObjRec = nothing


	dim sub_total, pkg_discount, state,pkg_discount_val
	dim total, body, pkg_body, single_body, pkg_str, pkg_desc
	dim resultSql()
	state = request.form("selState")
	sub_total = 0
	'Set conn = GetSQLServerConnection( db_machine, db_userid, db_password, db_database )

	if request.form("packageA") = "b" then
		sub_total = sub_total + Cdbl(eval("state_" & state))
		sub_total = sub_total + CDbl(eval("mvr_" & state))
		pkg_discount = 10
		pkg_body = pkg_body & "Basic Package"
		pkg_desc = b_desc
		ReDim resultSql(2)
		resultSql(0) = "Insert Into result (id,type1,detail,state,status) values (" & candidate_id & ",'State Criminal','State Criminal - " & state & "','" & state & "','N')"
		resultSql(1) = "Insert Into result (id,type1,detail,state,status) values (" & candidate_id & ",'Motor Vehicle','MVR - " & state & "','" & state & "','N')"
	elseif request.form("packageA") = "bp" then
		sub_total = sub_total + CDbl(eval("state_" & state))
		sub_total = sub_total + CDbl(eval("emp_verify"))
		sub_total = sub_total + CDbl(eval("ed_verify"))
		pkg_discount = 10
		pkg_body = pkg_body & "Basic Plus Package"
		pkg_desc = bp_desc
		ReDim resultSql(3)
		resultSql(0) = "Insert Into result (id,type1,detail,state,status) values (" & candidate_id & ",'State Criminal','State Criminal - " & state & "','" & state & "','N')"
		resultSql(1) = "Insert Into result (id,type1,detail,state,status) values (" & candidate_id & ",'Employment','Employment Verification','" & state & "','N')"
		resultSql(2) = "Insert Into result (id,type1,detail,state,status) values (" & candidate_id & ",'Education','Education Verification','" & state & "','N')"
	elseif request.form("packageA") = "e" then
		sub_total = sub_total + CDbl(eval("state_" & state))
		sub_total = sub_total + CDbl(eval("emp_verify"))
		sub_total = sub_total + CDbl(eval("credit"))
		pkg_discount = 10
		pkg_body = pkg_body & "Enhanced Package"
		pkg_desc = e_desc
		ReDim resultSql(3)
		resultSql(0) = "Insert Into result (id,type1,detail,state,status) values (" & candidate_id & ",'State Criminal','State Criminal - " & state & "','" & state & "','N')"
		resultSql(1) = "Insert Into result (id,type1,detail,state,status) values (" & candidate_id & ",'Employment','Employment Verification','" & state & "','N')"
		resultSql(2) = "Insert Into result (id,type1,detail,state,status) values (" & candidate_id & ",'Credit','Credit History','" & state & "','N')"
	elseif request.form("packageA") = "ep" then
		sub_total = sub_total + CDbl(eval("state_" & state))
		sub_total = sub_total + CDbl(eval("mvr_" & state))
		sub_total = sub_total + CDbl(eval("emp_verify"))
		sub_total = sub_total + CDbl(eval("credit"))
		pkg_discount = 12
		pkg_body = pkg_body & "Enhanced Plus Package"
		pkg_desc = ep_desc
		ReDim resultSql(4)
		resultSql(0) = "Insert Into result (id,type1,detail,state,status) values (" & candidate_id & ",'State Criminal','State Criminal - " & state & "','" & state & "','N')"
		resultSql(1) = "Insert Into result (id,type1,detail,state,status) values (" & candidate_id & ",'Motor Vehicle','MVR - " & state & "','" & state & "','N')"
		resultSql(2) = "Insert Into result (id,type1,detail,state,status) values (" & candidate_id & ",'Employment','Employment Verification','" & state & "','N')"
		resultSql(3) = "Insert Into result (id,type1,detail,state,status) values (" & candidate_id & ",'Credit','Credit History','" & state & "','N')"
	elseif request.form("packageA") = "c" then
		sub_total = sub_total + CDbl(eval("state_" & state))
		sub_total = sub_total + CDbl(eval("mvr_" & state))
		sub_total = sub_total + CDbl(eval("emp_verify"))
		sub_total = sub_total + CDbl(eval("ed_verify"))
		sub_total = sub_total + CDbl(eval("ssn_verify"))
		sub_total = sub_total + CDbl(eval("credit"))
		pkg_discount = 16
		pkg_body = pkg_body & "Comprehensive Package"
		pkg_desc = c_desc
		ReDim resultSql(6)
		resultSql(0) = "Insert Into result (id,type1,detail,state,status) values (" & candidate_id & ",'State Criminal','State Criminal - " & state & "','" & state & "','N')"
		resultSql(1) = "Insert Into result (id,type1,detail,state,status) values (" & candidate_id & ",'Motor Vehicle','MVR - " & state & "','" & state & "','N')"
		resultSql(2) = "Insert Into result (id,type1,detail,state,status) values (" & candidate_id & ",'Employment','Employment Verification','" & state & "','N')"
		resultSql(3) = "Insert Into result (id,type1,detail,state,status) values (" & candidate_id & ",'Education','Education Verification','" & state & "','N')"
		resultSql(4) = "Insert Into result (id,type1,detail,state,status) values (" & candidate_id & ",'Social Security Number','SSN Verification','" & state & "','N')"
		resultSql(5) = "Insert Into result (id,type1,detail,state,status) values (" & candidate_id & ",'Credit','Credit History','" & state & "','N')"
	elseif request.form("packageA") = "q" then
		sub_total = sub_total + CDbl(eval("state_" & state))
		sub_total = sub_total + CDbl(eval("mvr_" & state))
		sub_total = sub_total + CDbl(eval("workers_" & state))
		sub_total = sub_total + CDbl(eval("county_crime"))
		pkg_discount = 0
		pkg_body = pkg_body & "Qualified Package"
		pkg_desc = q_desc
		ReDim resultSql(4)
		resultSql(0) = "Insert Into result (id,type1,detail,state,status) values (" & candidate_id & ",'State Criminal','State Criminal - " & state & "','" & state & "','N')"
		resultSql(1) = "Insert Into result (id,type1,detail,state,status) values (" & candidate_id & ",'Motor Vehicle','MVR - " & state & "','" & state & "','N')"
		resultSql(2) = "Insert Into result (id,type1,detail,state,status) values (" & candidate_id & ",'Workers','Workers Comp - " & state & "','" & state & "','N')"
		resultSql(3) = "Insert Into result (id,type1,detail,state,status) values (" & candidate_id & ",'County Criminal','County Criminal','" & state & "','N')"
	elseif request.form("packageA") = "bk" then
		sub_total = sub_total + CDbl(eval("state_" & state))
		sub_total = sub_total + CDbl(eval("fed_crime"))
		sub_total = sub_total + CDbl(eval("mvr_" & state))
		sub_total = sub_total + CDbl(eval("emp_verify"))
		pkg_discount = 10
		pkg_body = pkg_body & "Banker's Choice"
		pkg_desc = bk_desc
		ReDim resultSql(4)
		resultSql(0) = "Insert Into result (id,type1,detail,state,status) values (" & candidate_id & ",'State Criminal','State Criminal - " & state & "','" & state & "','N')"
		resultSql(1) = "Insert Into result (id,type1,detail,state,status) values (" & candidate_id & ",'Federal Criminal','Federal Criminal','" & state & "','N')"
		resultSql(2) = "Insert Into result (id,type1,detail,state,status) values (" & candidate_id & ",'Motor Vehicle','MVR - " & state & "','" & state & "','N')"
		resultSql(3) = "Insert Into result (id,type1,detail,state,status) values (" & candidate_id & ",'Employment','Employment Verification','" & state & "','N')"
	elseif request.form("packageA") = "t" then
		'2 - county criminal
		sub_total = sub_total + CDbl(eval("ssn_verify"))
		sub_total = sub_total + CDbl(eval("county_crime"))
		sub_total = sub_total + CDbl(eval("county_crime"))
		sub_total = sub_total + CDbl(eval("mvr_" & state))
		sub_total = sub_total + CDbl(eval("emp_verify"))
		pkg_discount = 10
		pkg_body = pkg_body & "Thorough"
		pkg_desc = t_desc
		ReDim resultSql(5)
		resultSql(0) = "Insert Into result (id,type1,detail,state,status) values (" & candidate_id & ",'State Criminal','State Criminal - " & state & "','" & state & "','N')"
		resultSql(1) = "Insert Into result (id,type1,detail,state,status) values (" & candidate_id & ",'County Criminal','County Criminal','" & state & "','N')"
		resultSql(2) = "Insert Into result (id,type1,detail,state,status) values (" & candidate_id & ",'County Criminal','County Criminal','" & state & "','N')"
		resultSql(3) = "Insert Into result (id,type1,detail,state,status) values (" & candidate_id & ",'Motor Vehicle','MVR - " & state & "','" & state & "','N')"
		resultSql(4) = "Insert Into result (id,type1,detail,state,status) values (" & candidate_id & ",'Employment','Employment Verification','" & state & "','N')"
	elseif request.form("packageA") = "n" then
		pkg_discount = 0
		pkg_body = "No Package Selected"
		pkg_desc = n_desc
		state = ""
		ReDim resultSql(0)
	end if
	pkg_discount_val = (pkg_discount * sub_total) / 100
	pkg_subtotal = (sub_total - pkg_discount_val)
	SQL = "Insert Into candidate_package (candidate_id,package,package_state,package_desc,package_cost) values (" & candidate_id & ",'" & request.form("packageA") & "','" & state & "','" & Replace(pkg_desc,"'","''") & "'," & pkg_subtotal & ")"
	Call conn.execute(SQL)
	pkg_body = "<tr><td>" & pkg_body & "</td><td>" & FormatCurrency(pkg_subtotal) & "</td></tr>" & vbCrLf
	
	'insert package searches into results as new
	For i = 0 To Ubound(resultSql) - 1
		call conn.execute(resultSql(i))
	Next

	For Each sKey in dictPrice.Keys
		strName = sKey
		strDesc = dictDesc.Item(sKey)
		if request.form(strName) then
			total = total + CDbl(Request.Form(strName))
			Call Add_Option(strName, strDesc, Request.Form(strName))
		end if
	Next
'	rsPrice.MoveFirst
'	Do While Not rsPrice.EOF
'		strName = rsPrice("name")
'		strDesc = rsPrice("desc")
'		if request.form(strName) then
'			total = total + CDbl(Request.Form(strName))
'			Call Add_Option(strDesc, Request.Form(strName))
'		end if
'		rsPrice.movenext
'	Loop

'	if request.form("credit") then
'		total = total + CDbl(Request.Form("credit"))
'		'pkg_body = pkg_body & "<tr><td>Credit History</td><td>" & FormatCurrency(Request.Form("credit")) & "</td></tr>" & vbCrLf
'		Call Add_Option("Credit History",Request.Form("credit"))
'	end if
	total = total * 100
	
	discount_val = (discount * total) / 100
	total = (total - discount_val) / 100
	total = total + pkg_subtotal
	'Response.write "<!-- Pkg SubTotal: " & pkg_subtotal & " -->" & vbCrLf
	'Response.write "<!-- Total: " & total & " -->" & vbCrLf
	SQL = "Update candidate set total = " & total & " Where id = " & candidate_id
	Call conn.execute(SQL)

	Set rs = GetSQLServerStaticRecordset(conn, "Select * From candidate where id = " & candidate_id)
	'rs("total")=total
	'rs.update
	body= "<html><head><title>New Identi-Check Candidate Submission</title></head></body>"  & vbCrLf
	body= body & "<table cellpadding=1 cellspacing=0 border=1>"  & vbCrLf
	body= body & "<tr><td>Time</td><td>" & rs("date1") & "</td></tr>" & vbCrLf
	body= body & "<tr><td>Company Name</td><td>" & rs("company") & "</td></tr>" & vbCrLf
	body= body & "<tr><td>Company #</td><td>" & rs("company_id") & "</td></tr>" & vbCrLf
	body= body & "<tr><td>Candidate ID</td><td>" & candidate_id & "</td></tr>" & vbCrLf
	body= body & "<tr><td>Name</td><td>" & rs("fname") & " " & rs("lname") & "</td></tr>" & vbCrLf
	'body= body & "<tr><td>Alias</td><td>" & rs("other") & "</td></tr>" & vbCrLf
	'body= body & "<tr><td>Address</td><td>" & rs("address") & "</td></tr>" & vbCrLf
	'body= body & "<tr><td>City, ST Zip</td><td>" & rs("city") & ", " & rs("state") & " " & rs("zip") &  "</td></tr>" & vbCrLf
	'body= body & "<tr><td>County</td><td>" & rs("county") & "</td></tr>" & vbCrLf
	'body= body & "<tr><td>SSN</td><td>" & rs("ssn") & "</td></tr>" & vbCrLf
	'body= body & "<tr><td>DOB</td><td>" & rs("dob") & "&nbsp;</td></tr>" & vbCrLf
	'body= body & "<tr><td>Sex</td><td>" & rs("sex") & "&nbsp;</td></tr>" & vbCrLf
	'body= body & "<tr><td>Position Type</td><td>" & rs("position_type") & "&nbsp;</td></tr>" & vbCrLf
	'body= body & "<tr><td>ST - Driver's License #</td><td>" & rs("dl_state") & " - " & rs("drivers_lic") & "&nbsp;</td></tr>" & vbCrLf
	'body= body & "<tr><td>How long for this address</td><td>" & rs("long_at_address") & "&nbsp;</td></tr>" & vbCrLf
	'body= body & "<tr><td colspan=2>&nbsp;</td></tr>" & vbCrLf
	'body= body & "<tr><td>Previous address</td><td>" & rs("prev_address") & "&nbsp;</td></tr>" & vbCrLf
	'body= body & "<tr><td>City, ST Zip</td><td>" & rs("prev_city") & ", " & rs("prev_state") & " " & rs("prev_zip") & "&nbsp;</td></tr>" & vbCrLf
	'body= body & "<tr><td>County</td><td>" & rs("prev_county") & "&nbsp;</td></tr>" & vbCrLf
	'body= body & "<tr><td colspan=2>&nbsp;</td></tr>" & vbCrLf
	'body= body & "<tr><td>Last/Current Employer</td><td>" & rs("last_employer") & "</td></tr>" & vbCrLf
	'body= body & "<tr><td>City, ST</td><td>" & rs("last_emp_city") & ", " & rs("last_emp_state") & "&nbsp;</td></tr>" & vbCrLf
	'body= body & "<tr><td>County</td><td>" & rs("last_emp_county") & "&nbsp;</td></tr>" & vbCrLf
	'body= body & "<tr><td>Phone</td><td>" & rs("last_emp_phone") & "&nbsp;</td></tr>" & vbCrLf
	'body= body & "<tr><td>Position</td><td>" & rs("last_emp_position") & "&nbsp;</td></tr>" & vbCrLf
	'body= body & "<tr><td>Supervisor</td><td>" & rs("last_emp_supervisor") & "&nbsp;</td></tr>" & vbCrLf
	'body= body & "<tr><td>Begin</td><td>" & rs("last_emp_begin_dt") & "&nbsp;</td></tr>" & vbCrLf
	'body= body & "<tr><td>End</td><td>" & rs("last_emp_end_dt") & "&nbsp;</td></tr>" & vbCrLf
	'body= body & "<tr><td colspan=2>&nbsp;</td></tr>" & vbCrLf
	'body= body & "<tr><td>University/School</td><td>" & rs("school") & "&nbsp;</td></tr>" & vbCrLf
	'body= body & "<tr><td>City, ST</td><td>" & rs("school_city") & ", " & rs("school_state") & "&nbsp;</td></tr>" & vbCrLf
	'body= body & "<tr><td>County</td><td>" & rs("school_county") & "&nbsp;</td></tr>" & vbCrLf
	'body= body & "<tr><td>Phone</td><td>" & rs("school_phone") & "&nbsp;</td></tr>" & vbCrLf
	'body= body & "<tr><td>Degree</td><td>" & rs("school_degree") & "&nbsp;</td></tr>" & vbCrLf
	'body= body & "<tr><td>Other</td><td>" & rs("school_other") & "&nbsp;</td></tr>" & vbCrLf
	'body= body & "<tr><td>Begin</td><td>" & rs("school_begin_dt") & "&nbsp;</td></tr>" & vbCrLf
	'body= body & "<tr><td>End</td><td>" & rs("school_end_dt") & "&nbsp;</td></tr>" & vbCrLf
	body= body & "<tr><td colspan=2>&nbsp;</td></tr>" & vbCrLf
	body= body & "<tr><td><b>Package</b></td><td><b>Price</b></td></tr>" & vbCrLf
	body= body & pkg_body
	body= body & "<tr><td><b>Single Options</b></td><td>&nbsp;</td></tr>" & vbCrLf
	body= body & single_body
	body= body & "<tr><td>Total</td><td>" & FormatCurrency(total) & "</td></tr>" & vbCrLf
	body= body & "</table>" & vbCrLf
	body= body & "</body></html>" & vbCrLf
	rs.close
	set rs = nothing
	'conn.close
	'set conn = nothing

	dim sTo,sSubject
      

	'Set Mailer=Server.CreateObject("CDONTS.NewMail")
	If db_platform = "test" Then
		sTo="matt@kingtech.net"
	Else
		'Mailer.To="jennifer@identi-check.com;micah@identi-check.com;matt@kingtech.net"
		sTo="jennifer@identi-check.com;micah@identi-check.com;denis@kingtech.net"
	End If
	'Mailer.To="matt@kingtech.net"
	'Mailer.From="on-line@identi-check.com"

	If CInt(session("admin")) = 2 Then
		sSubject="Internally Submitted - New Candidate for Identi-check"	
	Else
		sSubject="New Candidate for Identi-check"
	End If
	'Mailer.Body = body
	' Use the following to format email in HTML
	'Mailer.BodyFormat = 0 ' CdoBodyFormatHTML
	'Outlook gives you grief unless you also set:
	'Mailer.MailFormat = 0 ' CdoMailFormatMime

	'Mailer.Send
	call SendHTMLEmail(sTo, sSubject, body)

	msg="You have successfully submitted a candidate!"
	Response.Redirect "main.asp?company_id=" & company_id & "&msg=" & msg
else
	pkg_n_checked = " CHECKED"
end if
conn.close
set conn = nothing
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<!--#include file="head.asp" -->

<div id="main">
    <div id="left"><img src="images/left.png" width="162" height="419" /></div>
    <div id="middle">

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
                        <h4>Identi-check's Pricing</h4>
                        <font color="red"><%=request("msg")%></font>
			<form name=myForm action="price.asp?company_id=<%=company_id%>" method="post">
			<span style='color: red; font-weight: bold;'>Please choose your package before choosing individual options<br>Changing packages clears all individual options.</span>
			<table id="table_reg">
			<tr valign=top>
				<td width=400>
					<b>Package Options</b>&nbsp;
					<select name="selState" onChange="do_package()">
					<option value='il'>Illinois<option value='in'>Indiana<option value='ky'>Kentucky<option value='mo'>Missouri<option value='tn'>Tennesee
					</select>
				</td>
				<td>&nbsp;</td>
				<td width=60 align='right'><b>Discount</b></td>
			</tr>	
			<tr valign=top>
				<td>Basic<br>Statewide Criminal Search, Motor Vehicle Report</td>
				<td valign=top align=center><INPUT name=packageA value='b' type=radio onClick="do_package()"<%=pkg_b_checked%>></td>
				<td align='right'>10%</td>
			</tr>
			<tr valign=top>
				<td>Basic Plus<br>Statewide Criminal Search, Employment Verification, Educational Verification</td>
				<td valign=top align=center><INPUT name=packageA value='bp' type=radio onClick="do_package()"<%=pkg_bp_checked%>></td>
				<td align='right'>10%</td>
			</tr>
			<tr valign=top>
				<td>Enhanced<br>Statewide Criminal Search, Employment Verification, Credit Report</td>
				<td valign=top align=center><INPUT name=packageA value='e' type=radio onClick="do_package()"<%=pkg_e_checked%>></td>
				<td align='right'>10%</td>
			</tr>
			<tr valign=top>
				<td>Enhanced Plus<br>Statewide Criminal Search, Employment Verification, Credit Report, Motor Vehicle Report</td>
					<td valign=top align=center><INPUT name=packageA value='ep' type=radio onClick="do_package()"<%=pkg_ep_checked%>></td>
				<td align='right'>12%</td>
			</tr>
			<tr valign=top>
				<td>Comprehensive<br>Statewide Criminal Search, Employment Verification, Credit Report, Motor Vehicle Report, Educational Verification, Social Security Number Verification</td>
				<td valign=top align=center><INPUT name=packageA value='c' type=radio onClick="do_package()"<%=pkg_c_checked%>></td>
				<td align='right'>16%</td>
			</tr>
			<tr valign=top>
				<td>Qualified<br>Workers Compensation Report, Statewide Criminal Search, County Criminal History, Motor Vehicle Report</td>
				<td valign=top align=center><INPUT name=packageA value='q' type=radio onClick="do_package()"<%=pkg_q_checked%>></td>
				<td align='right'>0%</td>
			</tr>
			<tr valign=top>
				<td>Banker's Choice<br>Statewide Criminal Search, Federal Criminal, Motor Vehicle Report, Employment Verification</td>
				<td valign=top align=center><INPUT name=packageA value='bk' type=radio onClick="do_package()"<%=pkg_bk_checked%>></td>
				<td align='right'>10%</td>
			</tr>
			<tr valign=top>
				<td>Thorough<br>SSN Verification and Trace, (2) County Criminal (Current & Previous County of Residence), Motor Vehicle Report, Employment Verification</td>
				<td valign=top align=center><INPUT name=packageA value='t' type=radio onClick="do_package()"<%=pkg_t_checked%>></td>
				<td align='right'>10%</td>
			</tr>
			<tr valign=top>
				<td colspan=2><b>Package SubTotal</b></td>
				<td align='right'><span id="lblPkgSubTotal" align='right'>$0.00</span></td>
			</tr>
			<tr valign=top>
				<td>None</td>
				<td valign=top align=center><INPUT name=packageA value='n' type=radio onClick="do_package()"<%=pkg_n_checked%>></td>
				<td align='right'>&nbsp;</td>
			</tr>
			<tr valign=top>
				<td colspan=2><b>Single Options</b></td>
				<td align='right'><b>Price</b></td>
			</tr>
			<%
			'rsPrice.MoveFirst
			'Do While not rsPrice.EOF
			For Each sKey in dictPrice.Keys
				%>
				<tr valign=top>
					<td><%=dictDesc.Item(sKey)%></td>
					<td valign=top align=center><INPUT name="<%=sKey%>" value='<%=dictPrice.Item(sKey)%>' type=checkbox onClick="check_total()"></td>
					<td align='right'><%=FormatCurrency(dictPrice.Item(sKey))%></td>
				</tr>
				<%
			Next
			'	rsPrice.MoveNext
			'Loop
			%>
			<tr valign=top>
				<td>Volume Discount</td>			
				<td valign=top align=center>&nbsp;</td>
				<td align='right'><span id="lblVolumeDiscount" align='right'>$0.00</span></td>
			</tr>
			<tr valign=top>
				<td>Total</td>			
				<td valign=top align=center>&nbsp;</td>
				<td align='right'><span id="lblTotal" align='right'>$0.00</span>
				</td>
			</tr>
			<tr>
				<td colspan=3 align=right>
				<INPUT name=Submit type=submit value=Submit>&nbsp; 
				<INPUT name=reset type=reset value=Reset></td>
			</tr>
			</table>
			</form><h4 align="center">Statewide criminal searches for states other <br />
                                        than Illinois may require additional fees.<br /><br />
                                        
                                        Any combination of single options can <br />
                                        be combined to create a custom package. <br /><br />
                                        
                                        Call 217-753-4311 for details.</h4>
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



<script language='javascript'>
var discount = <%=volume_discount%>;
var pkg_subtotal = 0;

function do_package()
{
	var sub_total = 0;
	var pkg_discount = 0;
	var pkg_discount_val = 0;
	var sPkg = myForm.packageA;
	var sState = myForm.selState.options[myForm.selState.selectedIndex].value;
	var state_crim = 'state_' + sState
	var state_mvr = 'mvr_' + sState
	var state_workers = 'workers_' + sState

	if(sPkg[0].checked && sPkg[0].value == 'b')
	{
		sub_total += Number(myForm.elements[state_crim].value);
		sub_total += Number(myForm.elements[state_mvr].value);
		myForm.elements[state_crim].checked = false;
		myForm.elements[state_mvr].checked = false;
		pkg_discount = 10
		//document.all("lblPkgDiscount").innerHTML = sState;
	}
	else if(sPkg[1].checked && sPkg[1].value == 'bp')
	{
		sub_total += Number(myForm.elements[state_crim].value);
		sub_total += Number(myForm.emp_verify.value);
		sub_total += Number(myForm.ed_verify.value);
		myForm.elements[state_crim].checked = false;
		myForm.emp_verify.checked = false;
		myForm.ed_verify.checked = false;
		pkg_discount = 10
	}
	else if(sPkg[2].checked && sPkg[2].value == 'e')
	{
		sub_total += Number(myForm.elements[state_crim].value);
		sub_total += Number(myForm.emp_verify.value);
		sub_total += Number(myForm.credit.value);
		myForm.elements[state_crim].checked = false;
		myForm.emp_verify.checked = false;
		myForm.credit.checked = false;
		pkg_discount = 10
	}
	else if(sPkg[3].checked && sPkg[3].value == 'ep')
	{
		sub_total += Number(myForm.elements[state_crim].value);
		sub_total += Number(myForm.elements[state_mvr].value);
		sub_total += Number(myForm.emp_verify.value);
		sub_total += Number(myForm.credit.value);
		myForm.elements[state_crim].checked = false;
		myForm.elements[state_mvr].checked = false;
		myForm.emp_verify.checked = false;
		myForm.credit.checked = false;
		pkg_discount = 12
	}
	else if(sPkg[4].checked && sPkg[4].value ==  'c')
	{
		sub_total += Number(myForm.elements[state_crim].value);
		sub_total += Number(myForm.elements[state_mvr].value);
		sub_total += Number(myForm.emp_verify.value);
		sub_total += Number(myForm.ed_verify.value);
		sub_total += Number(myForm.ssn_verify.value);
		sub_total += Number(myForm.credit.value);
		myForm.elements[state_crim].checked = false;
		myForm.elements[state_mvr].checked = false;
		myForm.emp_verify.checked = false;
		myForm.ed_verify.checked = false;
		myForm.ssn_verify.checked = false;
		myForm.credit.checked = false;
		pkg_discount = 16
	}
	else if(sPkg[5].checked && sPkg[5].value ==  'q')
	{
		sub_total += Number(myForm.elements[state_crim].value);
		sub_total += Number(myForm.elements[state_mvr].value);
		sub_total += Number(myForm.elements[state_workers].value);
		sub_total += Number(myForm.county_crime.value);
		myForm.elements[state_crim].checked = false;
		myForm.elements[state_mvr].checked = false;
		myForm.elements[state_workers].checked = false;
		myForm.county_crime.checked = false;
		pkg_discount = 0
	}
	else if(sPkg[6].checked && sPkg[6].value ==  'bk')
	{
		sub_total += Number(myForm.elements[state_crim].value);
		sub_total += Number(myForm.fed_crime.value);
		sub_total += Number(myForm.elements[state_mvr].value);
		sub_total += Number(myForm.emp_verify.value);
		myForm.elements[state_crim].checked = false;
		myForm.fed_crime.checked = false;
		myForm.elements[state_mvr].checked = false;
		myForm.emp_verify.checked = false;
		pkg_discount = 10
	}
	else if(sPkg[7].checked && sPkg[7].value ==  't')
	{
		sub_total += Number(myForm.ssn_verify.value);
		sub_total += Number(myForm.county_crime.value);
		sub_total += Number(myForm.county_crime.value);
		sub_total += Number(myForm.elements[state_mvr].value);
		sub_total += Number(myForm.emp_verify.value);
		myForm.ssn_verify.checked = false;
		myForm.county_crime.checked = false;
		myForm.elements[state_mvr].checked = false;
		myForm.emp_verify.checked = false;
		pkg_discount = 10
	}
	else if(sPkg[8].checked && sPkg[7].value == 'n')
	{
		//document.all("lblPkgDiscount").innerHTML = '$0.00';
		pkg_discount = 0;
	}
	pkg_discount_val = (pkg_discount * sub_total) / 100;
	pkg_subtotal = (sub_total - pkg_discount_val);
	var strPkgDiscount = String(pkg_discount_val/100);
	var strPkgTotal = String(pkg_subtotal);
	dec = strPkgTotal.indexOf(".");
  if (dec > 0)
  { 
	  dollars = strPkgTotal.substring(0,dec); 
	  cents = strPkgTotal.substring(dec+1,dec+3);
	  cents = (cents.length < 2) ? cents + "0" : cents;
	  strPkgTotal = dollars + "." + cents;
  }
	else
	{
		strPkgTotal = strPkgTotal + '.00';
	}
	document.all("lblPkgSubTotal").innerHTML = '$' + String(strPkgTotal);
	check_total();
}

function check_total()
{
	var total = 0;
	var discount_val = 0;
	<%
	For Each sKey in dictPrice.Keys
		Response.write "	if(myForm." & sKey & ".checked)" & vbCrLf
		response.write "	{" & vbCrLf
		response.write "		total += Number(myForm." & sKey & ".value);" & vbCrLf
		response.write "	}" & vbCrLf
	Next
	'rsPrice.MoveFirst
	'Do While Not rsPrice.EOF
	'	Response.write "	if(myForm." & rsPrice("name") & ".checked)" & vbCrLf
	'	response.write "	{" & vbCrLf
	'	response.write "		total += Number(myForm." & rsPrice("name") & ".value);" & vbCrLf
	'	response.write "	}" & vbCrLf
	'	rsPrice.MoveNext
	'Loop
	%>
	total = total * 100;
	
	discount_val = (discount * total) / 100;
	total = (total - discount_val) / 100;
	total += pkg_subtotal;
	var strDiscount = String(discount_val/100);
	var strTotal = String(total);
	dec = strDiscount.indexOf(".");
  if (dec > 0)
  { 
	  dollars = strDiscount.substring(0,dec); 
	  cents = strDiscount.substring(dec+1,dec+3);
	  cents = (cents.length < 2) ? cents + "0" : cents;
	  strDiscount = dollars + "." + cents;
  }
	else
	{
		strDiscount = strDiscount + '.00';
	}
	dec = strTotal.indexOf(".");
  if (dec > 0)
  { 
	  dollars = strTotal.substring(0,dec); 
	  cents = strTotal.substring(dec+1,dec+3);
	  cents = (cents.length < 2) ? cents + "0" : cents;
	  strTotal = dollars + "." + cents;
  }
	else
	{
		strTotal = strTotal + '.00';
	}
	document.all("lblVolumeDiscount").innerHTML = '$' + String(strDiscount);
	document.all("lblTotal").innerHTML = '$' + String(strTotal);

}

function do_package_old()
{
	var sPkg = myForm.packageA;
	var sState = myForm.selState.options[myForm.selState.selectedIndex].value;
	var state_crim = 'state_' + sState
	var state_mvr = 'mvr_' + sState

	myForm.elements['state_il'].checked = false;
	myForm.elements['state_ky'].checked = false;
	myForm.elements['state_mo'].checked = false;
	myForm.elements['state_tn'].checked = false;
	myForm.elements['mvr_il'].checked = false;
	myForm.elements['mvr_ky'].checked = false;
	myForm.elements['mvr_mo'].checked = false;
	myForm.elements['mvr_tn'].checked = false;
	myForm.emp_verify.checked = false;
	myForm.ed_verify.checked = false;
	myForm.ssn_verify.checked = false;
	myForm.credit.checked = false;

	if(sPkg[0].checked && sPkg[0].value == 'b')
	{
		myForm.elements[state_crim].checked = true;
		myForm.elements[state_mvr].checked = true;
		discount = 10
		//document.all("lblPkgDiscount").innerHTML = sState;
	}
	else if(sPkg[1].checked && sPkg[1].value == 'bp')
	{
		myForm.elements[state_crim].checked = true;
		myForm.emp_verify.checked = true;
		myForm.ed_verify.checked = true;
		discount = 10
	}
	else if(sPkg[2].checked && sPkg[2].value == 'e')
	{
		myForm.elements[state_crim].checked = true;
		myForm.emp_verify.checked = true;
		myForm.credit.checked = true;
		discount = 10
	}
	else if(sPkg[3].checked && sPkg[3].value == 'ep')
	{
		myForm.elements[state_crim].checked = true;
		myForm.elements[state_mvr].checked = true;
		myForm.emp_verify.checked = true;
		myForm.credit.checked = true;
		discount = 12
	}
	else if(sPkg[4].checked && sPkg[4].value ==  'c')
	{
		myForm.elements[state_crim].checked = true;
		myForm.elements[state_mvr].checked = true;
		myForm.emp_verify.checked = true;
		myForm.ed_verify.checked = true;
		myForm.ssn_verify.checked = true;
		myForm.credit.checked = true;
		discount = 16
	}
	else if(sPkg[5].checked && sPkg[5].value == 'n')
	{
		//
		//document.all("lblPkgDiscount").innerHTML = '$0.00';
		discount = 0;
	}
	check_total();
}
</script>
</body></html>
<%
Sub Add_Option(sName, sDesc, sCost)
	Dim SQL, sType
	single_body = single_body & "<tr><td>" & sDesc & "</td><td>" & FormatCurrency(sCost) & "</td></tr>" & vbCrLf
	SQL = "Insert Into candidate_option (candidate_id,option_name,option_desc,option_price) values (" & candidate_id & ",'" & sName & "','" & sDesc & "'," & sCost & ")"
	Call conn.execute(SQL)
	if instr(sName,"county_") > 0 then
		sType = "County Criminal"
	elseif instr(sName,"mvr_") > 0 then
		sType = "Motor Vehicle"
	elseif instr(sName,"state_") > 0 then
		sType = "State Criminal"
	elseif instr(sName,"workers_") > 0 then
		sType = "Workers Compensation"
	else
		sType = sName
	end if
	SQL = "Insert Into result (id,type1,detail,state,status) values (" & candidate_id & ",'" & sType & "','" & sDesc & "','','N')"
	Call conn.execute(SQL)
End Sub

Function GetCompanyName(CompanyID)
	Dim conn, rs, sql, tmpName
	Set conn = GetSQLServerConnection( db_machine, db_userid, db_password, db_database ) 
	
	SQL = "Select name From subscriber Where company_id = " & CompanyID
	Set rs = GetSQLServerStaticRecordset( conn, SQL )
	If Not rs.EOF Then
		tmpName = rs("name")
	Else
		tmpName = ""
	End If

	rs.close
	set rs = nothing
	conn.close
	set conn = nothing

	GetCompanyName = tmpName
End Function
%>