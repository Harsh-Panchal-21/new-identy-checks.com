<!--#include virtual="DB.fun" -->
<!--#include virtual="DB_constants.fun" -->
<%
Dim Sql
Dim result_id

if session("validuser") <> True then
	Response.Redirect "index.asp?msg=Not a valid userd"
end if 

' Grab file ID from query string
result_id = Request.QueryString("id")
if result_id = "" then
	response.end
end if

Sql = "SELECT result_file, result_contenttype, result_filesize,result_FileName FROM result WHERE resultid = " & result_id
Set conn = GetSQLServerConnection(db_machine, db_userid, db_password, db_database)
Set rs = server.CreateObject("ADODB.Recordset")
rs.Open Sql, conn, 3, 3

' If we have at least one record
If Not rs.EOF Then
	' Write out the headers identifying the file
	response.clear
	Response.ContentType = rs("result_contenttype")
	Response.AddHeader "content-disposition", "attachment; filename=" & rs("result_FileName")
	'Response.AddHeader "content-length", rs("result_filesize")
	'Write the file
	Response.BinaryWrite rs("result_file")
	'Response.Write(rs("result_FileName") & "<br>" & rs("result_filesize") & "<br>" & rs("result_contenttype") & "<br>" & CStr(rs("result_file")))
	'Response.end
Else
	' Notify the visitor of the problem
	Response.Write("File could not be found")
End If

rs.Close
set rs = nothing
conn.close
set conn = nothing
%>