<!--#include virtual="db_constants.fun" -->
<!--#include virtual="DB.fun" -->
<%
if session("admin") <> 2 then
	Response.Redirect "index.asp?msg=Access denied"
end if 
dim msg, userid,name,company,company_rid,company_id

company_id = request.querystring("company_id")
msg = request.querystring("msg")
UserID = Session("UserID")
name = Session("name")
company = Session("company")
company_rid = Session("company_rid")

If CInt(company_rid) <> CInt(company_id) and company_rid <> 0 Then
	'not valid bounce back to login
	Response.Redirect "index.asp?msg1=Invalid company selection"
End If

Dim sSQL, conn, rsPrice, rsAllPrices
dim dictPrice, dictDesc, dictAllPrice, dictDescAll
Set dictPrice = Server.createobject("Scripting.Dictionary")
Set dictDesc = Server.createobject("Scripting.Dictionary")
Set dictAllPrice = Server.createobject("Scripting.Dictionary")
Set dictAllDesc = Server.createobject("Scripting.Dictionary")
Set conn = GetSQLServerConnection( db_machine, db_userid, db_password, db_database )

If request.form("btnSave") = "Save Changes" Then
	Call Load_Pricing()
	For Each sKey in dictPrice.Keys
		If request.form("chk_" & sKey) ="on" Then
			sSQL = "Delete From subscriber_pricing where option_name = '" & sKey & _
						 "' and subscriber_id = " & company_id
			Call conn.execute(sSQL)
		Else
			If request.form(sKey) <> request.form("orig_" & sKey) then
				sSQL = "update subscriber_pricing set option_cost = " & request.form(sKey) & _
							", price_chg_dt = '" & now() & "' where option_name = '" & sKey & "' and subscriber_id = " & company_id 
				Call conn.execute(sSQL)
			end if
		End If
	Next
	Call Load_Pricing()
ElseIf request.form("btnAdd") = "Add New" Then
	sSQL = "Insert Into subscriber_pricing (subscriber_id,option_name,option_cost,price_chg_dt) " & _
				 "values (" & company_id & ",'" & request.form("selPrice") & "'," & _
				 Request.Form("txtNewPrice") & ", '" & now() & "')"
	Call conn.execute(sSQL)
	Call Load_Pricing()
Else
	Call Load_Pricing()
End If

sSQL = "Select name, default_cost as cost, [desc], display_order, 'N' as special " & _
			 "From pricing_option " & _
			 "Where name not in (select option_name from subscriber_pricing where subscriber_id = " & company_id & ") " & _
			 " and hide <> 'Y' Order By display_order "
Set rsAllPrices = GetSQLServerStaticRecordset( conn, sSQL )
Do While not rsAllPrices.EOF
	dictAllPrice.Add rsAllPrices("name").value, rsAllPrices("cost").value
	dictallDesc.Add rsAllPrices("name").value, rsAllPrices("desc").value
	rsAllPrices.Movenext
Loop
rsAllPrices.close
set rsAllPrices = nothing

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<script type="text/javascript">
function get_price(selInd)
{
	var strName = myForm.selPrice.options[selInd].value;
	if(strName == '')
	{
		myForm.txtNewPrice.value = '';
	}
	else
	{
		var strCost = myForm.elements[strName].value
		alert('Cost: ' + strCost);
		myForm.txtNewPrice.value = strCost;
	}
}
</script>
<!--#include file="head.asp" -->
<center>

<!-- *************************************** MAIN CONTENT AREA *************************************** -->
 <table width="900px" cellpadding="0" cellspacing="0" border="0">
					<tr>
                    	<td width="100%"  align="center" class="menu">
                        <table width="100%" cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <td align="center" class="menu">
                                    Welcome: <%=name%><br />
                                    <%=now%>
                                    <hr>
                                    <h4 align="center">
                                        <a href="admin.asp">Company List</a>&nbsp;&nbsp; | &nbsp;&nbsp;
                                        <a href="admin1.asp">Candidate List</a>&nbsp;&nbsp; | &nbsp;&nbsp;
                                        <a href="admin_pricing.asp">Pricing List</a>&nbsp;&nbsp; | &nbsp;&nbsp;
                                        <a href="admin_pending.asp">Pending List</a>&nbsp;&nbsp; | &nbsp;&nbsp;
                                        <a href="admin_new.asp">New List</a>&nbsp;&nbsp; | &nbsp;&nbsp;
                                        <a href="admin_invoice.asp">Monthly Invoices</a>
                                    </h4>
                                    </tr>
    <tr>
        <td width="610px" valign="top" align="center">
            <table width="590px" cellpadding="0" cellspacing="0" border="0">
                <tr align="left">
                    <td>
                    <h4 align="left">Special Company Pricing</h4>
                    <FORM name="myForm" action="pricing.asp?company_id=<%=company_id%>" method="post">
                    <TABLE id="table_reg">
                        <tr>
                            <th>Option</th>
                            <th>Delete</th>
                            <th>Price</th>
                        </tr>
                        <%
                        For Each sKey in dictPrice.Keys
                        %>
                        <tr valign=top>
                            <td class="big_text"><%=dictDesc.Item(sKey)%></td>
                            <td align="center"><input type=checkbox name="chk_<%=sKey%>" value="on"></td>
                            <td align="center">
                                <INPUT name="<%=sKey%>" value='<%=dictPrice.Item(sKey)%>' type=text size=6>
                                <INPUT name="orig_<%=sKey%>" value='<%=dictPrice.Item(sKey)%>' type=hidden size=6>
                            </td>
                        </tr>
                        <%
                        Next
                        %>
                        <TR>
                            <TD colspan=3><input name="btnSave" type=submit value="Save Changes"></TD>
                        </TR>
                    </table>
                    <h4 align="left">Add New Special Pricing</h4>
                    <table>
                        <tr>
                            <td>
                                <select name="selPrice" onChange="get_price(this.selectedIndex)">
                                    <option value="">Select Pricing Option</option>
                                    <% For Each sKey in dictAllPrice.Keys %>
                                    <option value="<%=sKey%>"><%=dictAllDesc.Item(sKey)%></option>
                                    <% Next %>
                                </select>
                            </td>
                            <td align=right><input type=text name="txtNewPrice" value="" size=6></td>
                        </tr>
                        <TR>
                            <TD colspan=2><input id=btnAdd name=btnAdd type=submit value="Add New"></TD>
                        </TR>
                    </TABLE>
                    <% For Each sKey in dictAllPrice.Keys %>
                    <input type=hidden name="<%=sKey%>" value="<%=dictAllPrice.Item(sKey)%>"></option>
                    <% Next %>
                    </FORM>
                    </td>
                </tr>
            </table
        ></td>
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
conn.close
set conn = nothing

Sub Load_Pricing()
	dictPrice.removeAll
	dictDesc.removeAll
	sSQL = "Select option_name as name, option_cost as cost, [desc], display_order, 'Y' as special " & _
				 "From subscriber_pricing sp, pricing_option po " & _
				 "Where sp.option_name = po.name and sp.subscriber_id = " & company_id & _
				 " Order By display_order "
	Set rsPrice = GetSQLServerRecordset( conn, sSQL )
	Do While not rsPrice.EOF
		dictPrice.Add rsPrice("name").value, rsPrice("cost").value
		dictDesc.Add rsPrice("name").value, rsPrice("desc").value
		rsPrice.Movenext
	Loop
	rsPrice.close
	set rsPrice = nothing
End Sub
%>
