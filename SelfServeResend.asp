<!-- #include file="adovbs.inc" -->
<!--#include virtual="db_constants.fun" -->
<!-- #include virtual="DB.fun" -->
<!--#include file="lib.Data.asp"-->
<%
dim DB : set DB = new Database_Class
DB.Initialize db_conn

candidate_id = Request.querystring("id")
company_id = request.querystring("company_id")

If candidate_id = "" Then
   Msg= "Request Candidate resend error, id not provided"
Else

	dim sTo,sSubject,candidate
	Set conn = GetSQLServerConnection( db_machine, db_userid, db_password, db_database )

	Set rs = GetSQLServerStaticRecordset(conn, "SELECT * FROM SelfServeCandidate WHERE candidateID = " & candidate_id & " AND companyID = " & company_id)
	set rc = GetSQLServerStaticRecordset(conn, "SELECT * FROM candidate WHERE id = " & candidate_id)
	company = GetCompanyName(company_id)

	sSubject = company & " - Information Request"

	sTo= rs("ssEmail")
	
	Call DB.Execute("update SelfServeCandidate set hasAuthorized = 0 where candidateID = ? AND companyID = ?",Array(candidate_id,company_id))

	'make the body of the email with the link and the token
	body= "<html><head><title>Request Candidate Request</title></head></body>"  & vbCrLf
	body= body & rc("fname") & " " & rc("lname") & ", <br>"
	body= body & "<br>"
	body= body & "Please click the following link to fill out the required information. <br>" 
	body= body & "<a href='" & email_url & "SelfServeAuth.asp?token=" & rs("authToken")& "'>Click here to fill out your information</a>"
	body= body & "</body></html>" & vbCrLf

	rs.close
	rc.close
	set rs = nothing
	set rc = nothing


	'send email to candidate to fill out information
	call SendHTMLEmail(sTo, sSubject, body)


  Msg = "Resend ID= " & ID & "."
End If

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

 Response.Redirect "main.asp?company_id=" & company_id & "&Msg=" & Msg 
%>
<html>

<head>
<title></title>
</head>

<body>
</body>
</html>
