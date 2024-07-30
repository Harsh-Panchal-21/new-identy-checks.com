<!--#include virtual="db_constants.fun" -->
<!-- #include virtual="DB.fun" -->
<%
dim msg, userid,name,company,company_rid,company_id
if session("validuser") <> True then
	Response.Redirect "index.asp?msg=Not a valid userd"
end if 
msg = Request("msg")
id = request("id")
userid = Session("UserID")
name = Session("name")
company = Session("company")
company_rid = Session("company_rid")
company_id  =request.querystring("company_id")
opt = request.QueryString("opt")

'If CInt(company_rid) <> CInt(company_id) and company_rid <> 0 Then
	'not valid bounce back to login
'	Response.Redirect "index.asp?msg1=Invalid company selection"
'End If

Set conn = GetSQLServerConnection( db_machine, db_userid, db_password, db_database ) 

SQL_convert = "select total from candidate where id = " & id
set rs_convert = conn.execute(SQL_convert)
total_convert = rs_convert("total")

If request.Form("btnAdd") = "Submit" Then
	Dim strSQL, opt_cost, opt_name, opt_desc, sType
	opt_cost = request.form("opt_price")
	current_price = request.QueryString("price")
	
	if opt_cost <> current_price then
		strSQL = "update candidate_option set option_price = " & opt_cost & " where candidate_id = " & id & " and option_name = '" & opt & "'"
		conn.execute strSQL
		
		SQL = "update candidate set total = " & total_convert & " + " & opt_cost & " - " & current_price & " where id = " & id
		conn.execute SQL
		
		response.Redirect("show_price1.asp?id=" & id & "&company_id=" & company_id)
	else
		msg = "Option not added, no cost or name."
	end if
End If

Set rs = GetSQLServerRecordset( conn, "Select * From candidate Where id = " & id )
'company_id = rs("company_id")
Set rsOpt = GetSQLServerRecordset( conn, "Select * From candidate_option Where candidate_id = " & id & " and option_name = '" & opt & "'" )

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<!--#include file="head.asp" -->

<center>

<!-- *************************************** MAIN CONTENT AREA *************************************** -->
<table width="619px" height="419" cellpadding="0" cellspacing="0" border="0">
    <tr>
        <td width="610px" valign="top" align="center">
            <table width="590px" cellpadding="0" cellspacing="0" border="0">
                <tr align="left">
                    <td>
                    <center>
                        Welcome: <%=name%><br />
                        <%=now%>
                        <hr></center>
                        <h4 align="center">
                            <A href="candidate.asp?company_id=<%=company_id%>">*Submit Candidate</A>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <A href="SelfServeCandidate.asp?company_id=<%=company_id%>&SelfServe=true">Request Candidate</A>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <A href="main.asp?company_id=<%=company_id%>">Candidate List</A>
                        </h4>
                        <h4>Update Candidate Pricing for <%=rs("fname")%>&nbsp;<%=rs("lname")%></h4>
                        
                        <table id="table_reg">
	                        <form action='price_edit.asp?id=<%=id%>&opt=<%=rsOpt("option_name")%>&company_id=<%=company_id%>&price=<%=rsOpt("option_price")%>' method='post' id=form1 name=form1>
                            <% If Not rsOpt.EOF then %>
                                <tr>
                                	<td><%=rsOpt("option_desc")%></td>
                                    <td align=right><input type="text" name="opt_price" value="<%=formatcurrency(rsOpt("option_price"),2)%>"</td>
                                </tr>
                            <% end if %>
                                <tr>
                                    <td colspan="2" align='right'>
                                        <input type='submit' name='btnAdd' value='Submit' style='font-size: 7pt;'>
                                    </td>
                                </tr>
                            </form>
                        </table>
					</td>
    			</tr>
			</table>
		</td>
    </tr>
</table>
<!-- ************************************* END MAIN CONTENT AREA ************************************* -->

    </div>    
    <div id="right">&nbsp;</div>
</div>
<!--#include file="foot.asp" -->

</body>
</html>
<%
rs.close
'rsPkg.close
rsOpt.close
set rs = nothing
'set rsPkg = nothing
set rsOpt = nothing
conn.close
set conn = nothing
%>