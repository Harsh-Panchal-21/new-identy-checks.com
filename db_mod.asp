<!--#include virtual="db_constants.fun" -->
<!-- #include virtual="DB.fun" -->
<%

Set conn = GetSQLServerConnection( db_machine, db_userid, db_password, db_database ) 
'strSQL = "Insert Into pricing_option (name, [desc], default_cost, display_order, hide) " & _
'			"values ('ed_verify2', 'Education Verification - Maiden Name', '15', 1010, 'N')"

'opt_cost = "34.75"

strSQL = "delete from invoice"
conn.execute strSQL
%>
Done