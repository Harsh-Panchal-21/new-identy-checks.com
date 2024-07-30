<!--#include virtual="db_constants.fun" -->
<!-- #include virtual="DB.fun" -->
<%
id = request.querystring("id")
candidate_id = request.querystring("candidate_id")
company_id = request.querystring("company_id")

If id <> "" Then
	If isnumeric(id)  Then
		Set conn = GetSQLServerConnection( db_machine, db_userid, db_password, db_database ) 
		'call conn.execute("Delete From result Where resultid = " &  id)
		call conn.execute("update result set show = 'N' Where resultid = " &  id)
		Set conn= nothing
	  Msg = "Deleted result"
	End If
Else
	msg = "Delete failed, no id specified"
End If

Response.Redirect "show_result.asp?company_id=" & company_id & "&id=" & candidate_id & "&Msg=" & Msg 
%>

