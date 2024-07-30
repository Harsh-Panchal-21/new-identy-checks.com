<!--#include file="lib.Data.asp"-->
<!--#include virtual="db_constants.fun" -->
<!-- #include virtual="DB.fun" -->
<%
dim DB : set DB = new Database_Class
DB.Initialize db_conn
dim msg, userid,name,company,company_rid,company_id
if session("validuser") <> True then
	Response.Redirect "default.asp?msg=Not a valid userd"
end if 
msg = Request("msg")
id = request("id")
userid = Session("UserID")
name = Session("name")
company = Session("company")
company_rid = Session("company_rid")
company_id  =request.querystring("company_id")

if session("multi_com") = "yes" then
  dim rs_multi
  SQL = "Select * from Users_Companies Where User_ID = ? and Company_ID = ?"
  Set rs_multi = DB.Query(SQL,Array(session("id"),company_id))
  if rs_multi.eof then
    Response.Redirect "default.asp?msg=Invalid multi company selection"
  else
    'all good
  end if
  rs_multi.close
  set rs_multi = nothing
else
  If CInt(company_rid) <> CInt(company_id) and company_rid <> 0 Then
	  'not valid bounce back to login
	  Response.Redirect "default.asp?msg=Invalid company selection"
  End If
end if

Set conn = GetSQLServerConnection( db_machine, db_userid, db_password, db_database ) 

If request.Form("btnAdd") = "Add Option" Then
	Dim strSQL, opt_cost, opt_name, opt_desc, sType
	opt_cost = request.form("hidCost")
	opt_name = request.form("admin_add")
	opt_desc = request.form("hidDesc")
	if opt_cost <> "" and opt_name <> "" then
		strSQL = "Insert Into candidate_option (candidate_id,option_name,option_desc,option_price) " & _
			"values (" & id & ",'" & opt_name & "','" & opt_desc & "'," & opt_cost & ")"
		conn.execute strSQL
		if instr(opt_name,"county_") > 0 then
			sType = "County Criminal"
		elseif instr(opt_name,"mvr_") > 0 then
			sType = "Motor Vehicle"
		elseif instr(opt_name,"state_") > 0 then
			sType = "State Criminal"
		elseif instr(opt_name,"workers_") > 0 then
			sType = "Workers Compensation"
		else
			sType = sName
		end if
		SQL = "Insert Into result (id,type1,detail,state,status) values (" & id & ",'" & sType & "','" & opt_desc & "','','N')"
		Call conn.execute(SQL)
		strSQL = "update candidate set total = convert(varchar(10),convert(money,total) + " & opt_cost & ") where id = " & id
		conn.execute strSQL
		msg = "Option added"
	else
		msg = "Option not added, no cost or name."
	end if
End If

Set rs = GetSQLServerRecordset( conn, "Select * From candidate Where id = " & id )
Set rsPkg = GetSQLServerRecordset( conn, "Select * From candidate_package Where candidate_id = " & id )
Set rsOpt = GetSQLServerRecordset( conn, "Select * From candidate_option Where candidate_id = " & id )

check = Request("check")
total = rs("total")

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
                            <A href="main.asp?company_id=<%=company_id%>">Candidate List</A>
                        </h4>
                        <h4>Candidate Pricing for <%=rs("fname")%>&nbsp;<%=rs("lname")%></h4>
                        
                        <table id="table_reg">
                            <tr>
                                <th width=400>Package</th>
                                <th width=80>Price</th>
                            </tr>
                            <% If Not rsPkg.EOF Then %>
                            <tr>
                                <td>State: <%=UCase(rsPkg("package_state")) & " - " & rsPkg("package_desc")%></td>
                                <td align=right><%=formatcurrency(rsPkg("package_cost"),2)%></td>
                            </tr>
                            <% end If %>
                            <tr>
                                <td><b>Single Options</b></td>
                                <td>&nbsp;</td>
                            </tr>
                            <% Do While Not rsOpt.EOF %>
                                <tr>
                                	<td><%=rsOpt("option_desc")%></td>
                                    <td align=right>
                                    <% if session("admin") = 2 then %>
										<a href="price_edit.asp?opt=<%=rsOpt("option_name")%>&id=<%=rs("id")%>&company_id=<%=company_id%>"><%=formatcurrency(rsOpt("option_price"),2)%></a>
                                    <% else %>
                                    	<%=formatcurrency(rsOpt("option_price"),2)%>
                                    <% end if %>
                                    </td>
                                </tr>
                            <% rsOpt.Movenext
                            Loop %>	
                      		<tr>
                                <td><b>Total</b></td>
                                <td align=right><b><%=formatcurrency(total,2)%></b></td>
                            </tr>
                            <% 
                            If CInt(session("admin")) = 2 Then 
                                sql = "Select option_name as name, option_cost as cost, [desc], display_order, 'Y' as special " & _
                                    "From subscriber_pricing sp, pricing_option po " & _
                                    "Where sp.option_name = po.name and sp.subscriber_id = " & company_id & _
                                    "Union All " & _
                                    "Select name, default_cost as cost, [desc], display_order, 'N' as special " & _
                                    "From pricing_option " & _
                                    "Where name not in (select option_name from subscriber_pricing where subscriber_id = " & company_id & ") " & _
                                    " and hide <> 'Y' Order By display_order "
                                Set rsPrice = GetSQLServerRecordset( conn, sql)
                                If not rsPrice.eof then %>
                                    <form action='show_price1.asp?id=<%=id%>&company_id=<%=company_id%>' method='post' id=form1 name=form1>
                                    	<tr>
                                    		<td align='right'><select name='admin_add' onChange='show_price(this)'>
                                    			<option value=''>Select Option</option>
                                    <% Do while not rsPrice.eof %>
                                        		<option value='<%=rsPrice("name")%>'><%=rsPrice("desc")%></option>
                                    <% rsPrice.MoveNext
                                    Loop %>
                                    			<input type='submit' name='btnAdd' value='Add Option' style='font-size: 7pt;'>
                                    		</td>
                                            <td align=right><span id='lblCost' align='right'>$0.00</span>
                                        		<input type='hidden' name='hidCost' value=''><input type='hidden' name='hidDesc' value=''>
                                            </td>
                                    	</tr>
                                    </form>
                            <% end if				
                            End If
                            'Number(myForm." & sKey & ".value)
                            response.Write "<script>" & vbCrLf
                            response.Write "	function show_price(objSel)" & vbCrLf
                            response.Write "	{" & vbCrLf
                            'response.Write "		alert(objSel.options[objSel.selectedIndex].value);" & vbCrLf
                            'response.Write "		document.all(""lblCost"").innerHTML = '$' + objSel.options[objSel.selectedIndex].value;" & vbCrLf
                            response.Write "		var cost;" & vbCrLf
                            response.Write "		var option_name = objSel.options[objSel.selectedIndex].value;" & vbCrLf
                            response.Write "		var option_desc = objSel.options[objSel.selectedIndex].value;" & vbCrLf
                            rsPrice.movefirst
                            response.Write "		if (option_name == '') cost = '';" & vbCrLf
                            Do while not rsPrice.eof
                                'rsPrice("name"),rsPrice("cost"),rsPrice("desc")
                                response.Write "		if (option_name == '" & rsPrice("name") & "') cost = '" & rsPrice("cost") & "';" & vbCrLf
                                rsPrice.MoveNext
                            Loop
                            response.Write "		document.all(""lblCost"").innerHTML = '$' + cost;" & vbCrLf
                            response.Write "		document.form1.hidDesc.value = option_desc;" & vbCrLf
                            response.Write "		document.form1.hidCost.value = cost;" & vbCrLf
                            response.Write "	}" & vbCrLf
                            response.Write "</script>" & vbCrLf
                            %>
                        </table>
                        
                        <h4 align="center">If you need to change your option, please contact us at 217-753-4311.</h4>
                        <% If CInt(session("admin")) = 2 Then %>
                        <a href="invoices.asp?company_id=<%=company_id%>">Back to Invoice</a>
                        <% end if %>
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
rsPkg.close
rsOpt.close
set rs = nothing
set rsPkg = nothing
set rsOpt = nothing
conn.close
set conn = nothing
%>