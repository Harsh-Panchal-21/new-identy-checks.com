<!-- #include file="adovbs.inc" -->
<!--#include virtual="db_constants.fun" -->
<!-- #include virtual="DB.fun" -->
<%
id = Request.querystring("id")
company_id = request.querystring("company_id")

If id = "" Then
   Msg= "Candidate not un-deleted, id not provided"
Else
	Set conn = GetSQLServerConnection( db_machine, db_userid, db_password, db_database ) 
  call conn.execute("Update candidate set hide = 'N' Where id=" &  ID)
	conn.close
	Set conn= nothing
  Msg = "Un-Deleted ID= " & ID & "."
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
