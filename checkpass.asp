<% 
Option Explicit
Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cache"
'Response.AddHeader "cache-control", "private"
Response.Expires = -1 
%>
<!--#include file="lib.Data.asp"-->
<!--#include virtual="db_constants.fun" -->
<!--#include virtual="DB.fun" -->
<!--#include virtual="functions.inc" -->
<!--#include virtual="rc4.inc"-->
<%
dim DB : set DB = new Database_Class
DB.Initialize db_conn

Response.Buffer = False
session("validuser")=False
'UserID=request.cookies("UserID")
'UserID, Password, 
Dim company_rid, msg1, sql, rs, enc_pass, UserID, rs_multi
msg1 = request("msg")

If request.form("Send") = "SUBMIT" Then
	if Request("UserID") ="" then
		Response.redirect "login.asp?msg=Login failed"
		msg1=" Please enter your user name!"
	elseif Request.form("Password") = "" Then
		Response.redirect "login.asp?msg=Login failed"
		UserID = Request( "UserID" )
		msg1="Please enter your password!"
	else
		UserID = Request.form("UserID") 'replace(Request.form("UserID"),"'","''")
		'Password = replace(Request.form("Password"),"'","''")
		'level="Individual"
		'SQL = "Select u.*, isnull(s.ucc_app,'N') as ucc_app, isnull(s.name,isnull(u.company,'')) as company " & _
		' "From Users u left outer join subscriber s on u.company_id = s.company_id " & _
		' "Where UserID='" & UserID & "' And Password = '" & Password & "'"

		'Set conn = GetSQLServerConnection( db_machine, db_userid, db_password, db_database ) 
		'Set rs = GetSQLServerStaticRecordset( conn, SQL )
    dim myPass : myPass = Request.form("Password")
    enc_pass = EnDeCrypt(myPass,enc_pass_string)
    'response.write "------------------" & myPass & "<br />" & enc_pass_string & "<br />"
    SQL = "Select u.*, isnull(s.ucc_app,'N') as ucc_app, isnull(s.name,isnull(u.company,'')) as company, " & _
     "case when PasswordDate < GetDATE() then 'Y' else 'N' end as PassChangeRequired, " & _
     "case when FailedTime is null then 'N' when DateAdd(mi,10,FailedTime) > GETDATE() then 'Y' else 'N' end as AccountLockout " & _
		 "From Users u left outer join subscriber s on u.company_id = s.company_id " & _
		 "Where UserID=? And ((Password = ? and EncryptedPassword = 'N') or (Password = ? and EncryptedPassword = 'Y'))"
    Set rs = DB.Query(SQL,Array(UserID,Request.form("Password"),enc_pass))
		If Not rs.EOF Then
			company_rid = rs("company_id")
			session("validuser")= True 
			session("name") = rs("name")
			Session("UserID") = rs("UserID")
			Session("company") = rs("company")
			Session("company_rid") = company_rid
			Session("ucc_app") = rs("ucc_app")
      session("pass") = Request.form("Password")
      session("enc_pass") = enc_pass
      Session("id") = rs("id")
      SQL = "Select * From Users_Companies Where User_ID = ?"
      Set rs_multi = DB.Query(SQL,Array(session("id")))
      if not rs_multi.EOF then
        session("multi_com") = "yes"
      end if
      rs_multi.close
      set rs_multi = nothing
      if rs("level1")="2" then
				session("admin")=2
			else
				session("admin")=0
			end if
      if rs("AccountLockout") = "Y" then
        Call DB.Execute("Update Users set FailedTime = GETDATE() Where UserID = ?",Array(UserID))
        Response.redirect "login.asp?msg=Login Failed, Account lockout still in effect. Lockout has been extended 10 minutes."
      else
        Call DB.Execute("Update Users set FailedTime = Null, FailedCount = 0 Where UserID = ?",Array(UserID))
      end if
      if rs("PassChangeRequired") = "Y" then
        Call DB.Execute("Insert Into logins (date_time,userid,company_id,company_name,ip_address) Values " & _
				  " (GETDATE(),?,?,?,?)",Array(UserID,company_rid,rs("company"),request.servervariables("REMOTE_ADDR")))
        dim sQS
        sQS = ""
        'if rs("AcceptFCRA") = "N" then sQS = "?fcra=N"
        'Micah asked to make all users accept fcra again when changing passwords
        sQS = "?fcra=N"
        Response.Redirect "Change_Pass.asp" & sQS
      elseif rs("AcceptFCRA") = "N" then
        Call DB.Execute("Update Users set Password=?, EncryptedPassword='Y' Where UserID = ?",Array(enc_pass,UserID))
        Call DB.Execute("Insert Into logins (date_time,userid,company_id,company_name,ip_address) Values " & _
				  " (GETDATE(),?,?,?,?)",Array(UserID,company_rid,rs("company"),request.servervariables("REMOTE_ADDR")))
        Response.Redirect "Accept_FCRA.asp"
      end if
			if rs("level1")="2" then
				Response.Redirect "admin.asp?company_id=" & company_rid
			end if
      Call DB.Execute("Update Users set Password=?, EncryptedPassword='Y' Where UserID = ?",Array(enc_pass,UserID))

      Call DB.Execute("Insert Into logins (date_time,userid,company_id,company_name,ip_address) Values " & _
				" (GETDATE(),?,?,?,?)",Array(UserID,company_rid,rs("company"),request.servervariables("REMOTE_ADDR")))
			'conn.execute(SQL)
			if rs("ucc_app") = "Y" then
				'response.redirect "ucc_main.asp?company_id=" & company_rid
				session("pass") = Request.form("Password")
				response.redirect "enter_ucc.asp"
			else
        if session("multi_com") = "yes" then
          Response.Redirect "main_companies.asp"
        else
				  Response.Redirect "main.asp?company_id=" & company_rid
        end if
        'if level = ? then multi company screen
			end if
		Else
      SQL = "Insert Into Users_Failed_Logins (username,password,ip_address,time_stamp) values (?,?,?,GETDATE())"
      Call DB.Execute(SQL,Array(UserID,enc_pass,Request.ServerVariables("REMOTE_ADDR")))
      Dim rsU
      Set rsU = DB.Query("Select * from users where userid = ?",Array(UserID))
      If not rsU.eof then
        if rsU("FailedCount") >= 5 then
          Call DB.Execute("Update Users set FailedTime = GETDATE() where userid=?",Array(UserID))
          msg1 = "Login Failed, 5th attempt, account has been locked out for 10 minutes."
        else
          Call DB.Execute("Update Users set FailedCount = isnull(FailedCount,0) + 1 where userid=?",Array(UserID))
          msg1 = "Login Failed, please try again."
        end if
	  else
		msg1 = "Login Failed, please try again."
      end if
      rsU.close
      Set rsU = nothing
      
			'msg1="Login failed, please try again"
			Response.redirect "login.asp?msg=" & msg1
		end if
		rs.close
		set rs = nothing
		'conn.close
		'set conn = nothing
	end if
End If

%>
