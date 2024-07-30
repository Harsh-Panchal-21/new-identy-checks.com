<!-- #include file="adovbs.inc" -->
<!--#include virtual="db_constants.fun" -->
<!-- #include virtual="DB.fun" -->
<%
id = Request.querystring("id")
company_id = request.querystring("company_id")

If id = "" Then
   Msg= "Request Candidate not deleted, id not provided"
Else
	Set conn = GetSQLServerConnection( db_machine, db_userid, db_password, db_database ) 
  call conn.execute("Update SelfServeCandidate set deleted = 1 Where selfServeCandidateId=" &  ID)
	conn.close
	Set conn= nothing
  Msg = "Deleted ID= " & ID & "."
End If

 Response.Redirect "main.asp?company_id=" & company_id & "&Msg=" & Msg 
%>
<html>

<head>
<title></title>
</head>

<body>
</body>
</html>
