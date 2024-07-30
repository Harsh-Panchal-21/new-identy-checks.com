<!-- #include file   ="adovbs.inc" -->
<!--#include virtual="db_constants.fun" -->
<!-- #include virtual="DB.fun" -->
<%
ID=Request("company_id")

If ID=Empty  Then
   Msg2= "Please try again!"

Else
  'Set conn = GetSQLServerConnection( "GIS_Server", "sa", "", "identi-check" )
	Set conn = GetSQLServerConnection( db_machine, db_userid, db_password, db_database ) 
  Set rs = GetSQLServerStaticRecordset( conn, "subscriber" )

  'while not rs.EOF
    

   ' If rs("suggID").value= ID Then
    ' response.write "Sorry, a blank form is not allowed here!"  & rs("suggID").value & "ID" & ID
      ' rs.delete
    'End If
    'rs.MoveNext
  'Wend
 
   Set cmd = Server.CreateObject( "ADODB.Command")
   Set cmd.ActiveConnection = rs.ActiveConnection
   'SQL = "Delete From subscriber "
   'SQL = SQL & " Where company_id=" &  ID
   SQL = "Update subscriber set hide = 'Y' "
   SQL = SQL & " Where company_id=" &  ID
   cmd.CommandText = SQL
   cmd.Execute



   rs.UpdateBatch
   rs.Close

   Set conn= nothing
   Set rs = Nothing


   'rs("Subject") = Subject
   'Msg1=rs("Subject")
  
  ' rs.Update
   Msg = "Deleted ID= " & ID & "."

    
End If

 Response.Redirect "admin.asp?Msg=" & Msg 
%>
<html>

<head>
<title></title>
</head>

<body>
</body>
</html>
