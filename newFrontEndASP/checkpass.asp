<% 
Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cache"
'Response.AddHeader "cache-control", "private"
Response.Expires = -1 
%>
<!--#include virtual="db_constants.fun" -->
<!-- #include virtual="DB.fun" -->
<%
Response.Buffer = False
session("validuser")=False
'UserID=request.cookies("UserID")
Dim UserID, Password, company_rid, msg1
msg1 = request("msg")

If request.form("Send") = "SUBMIT" Then
	if Request("UserID") ="" then
    Response.redirect "default.asp?msg=Login failed"
		msg1=" Please enter your user name!"
	elseif Request.form("Password") = "" Then
    Response.redirect "default.asp?msg=Login failed"
		UserID = Request( "UserID" )
		msg1="Please enter your password!"
	else
		UserID = replace(Request.form("UserID"),"'","''")
		Password = replace(Request.form("Password"),"'","''")
		'level="Individual"
		SQL = "Select u.*, isnull(s.ucc_app,'N') as ucc_app, isnull(s.name,isnull(u.company,'')) as company " & _
		 "From Users u left outer join subscriber s on u.company_id = s.company_id " & _
		 "Where UserID='" & UserID & "' And Password = '" & Password & "'"

		Set conn = GetSQLServerConnection( db_machine, db_userid, db_password, db_database ) 
		Set rs = GetSQLServerStaticRecordset( conn, SQL )
		
		If Not rs.EOF Then
			company_rid = rs("company_id")
			session("validuser")= True 
			session("name") = rs("name")
			Session("UserID") = rs("UserID")
			Session("company") = rs("company")
			Session("company_rid") = company_rid
			Session("ucc_app") = rs("ucc_app")
			if rs("level1")="2" then
				session("admin")=2
				session("pass") = Request.form("Password")
				Response.Redirect "admin.asp?company_id=" & company_rid
			else
				session("admin")=0
			end if
			SQL = "Insert Into logins (date_time,userid,company_id,company_name,ip_address) Values " & _
				" (GETDATE(),'" & UserID & "'," & company_rid & ",'" & Replace(rs("company"),"'","''") & "','" & request.servervariables("REMOTE_ADDR") & "')"
			conn.execute(SQL)
			if rs("ucc_app") = "Y" then
				'response.redirect "ucc_main.asp?company_id=" & company_rid
				session("pass") = Request.form("Password")
				response.redirect "enter_ucc.asp"
			else
				Response.Redirect "main.asp?company_id=" & company_rid
			end if
		Else
			msg1="Login failed, please try again"
			Response.redirect "default.asp?msg=Login failed"
		end if
		rs.close
		set rs = nothing
		conn.close
		set conn = nothing
	end if
End If

%>
