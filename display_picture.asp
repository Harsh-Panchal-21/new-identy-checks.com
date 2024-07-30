<!--#include virtual="DB.fun" -->
<!--#include virtual="DB_constants.fun" -->
<%
Dim Sql
Dim obit_id

' Grab file ID from query string
obit_id = Request.QueryString("id")

Sql = "SELECT FileName, Content_Type, picture FROM obituary WHERE obit_id = " & obit_id
Set conn = GetSQLServerConnection(db_machine, db_userid, db_password, db_database)
Set rs = server.CreateObject("ADODB.Recordset")
rs.Open Sql, conn, 3, 3

' If we have at least one record
If Not rs.EOF Then
	' Write out the headers identifying the file
	Response.AddHeader "content-disposition", "inline; filename=" & rs("FileName")
	'Response.AddHeader "content-disposition", "attachment; filename=" & rs("FileName")
	Response.AddHeader "content-length", rs("picture").ActualSize
	Response.ContentType = rs("Content_Type")
	' Write the file
	Response.BinaryWrite rs("picture")
Else
	' Notify the visitor of the problem
	Response.Write("File could not be found")
End If

rs.Close
set rs = nothing
conn.close
set conn = nothing
%>