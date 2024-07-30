<!--#include virtual="db_constants.fun" -->
<!--#include virtual="DB.fun" -->
<%
if session("admin") <> 2 then
	Response.Redirect "index.asp?msg=Access denied"
end if 
dim msg, userid,name,company,company_rid,company_id

company_id = request.querystring("company_id")
msg = request.querystring("msg")
name = Session("name")
UserID = Session("UserID")

Dim sSQL, conn, rsPrice
dim dictPrice, dictDesc, dictOrder
Set dictPrice = Server.createobject("Scripting.Dictionary")
Set dictDesc = Server.createobject("Scripting.Dictionary")
Set dictOrder = Server.createobject("Scripting.Dictionary")
Set conn = GetSQLServerConnection( db_machine, db_userid, db_password, db_database )

If request.form("btnSave") = "Save Changes" Then
	Call Load_Pricing()
	For Each sKey in dictPrice.Keys
		If request.form("chk_" & sKey) ="on" Then
			'sSQL = "Delete From pricing_option where name = '" & sKey & "'"
			sSQL = "Update pricing_option set hide='Y' Where name = '" & sKey & "'"
			Call conn.execute(sSQL)
		Else
			If request.form(sKey & "_desc") <> request.form("orig_" & sKey & "_desc") or _
				request.form(sKey & "_price") <> request.form("orig_" & sKey & "_price") or _
				request.form(sKey & "_order") <> request.form("orig_" & sKey & "_order") then

				sSQL = "update pricing_option set [desc] = '" & request.form(sKey & "_desc") & "', " & _
							" default_cost = " & request.form(sKey & "_price") & ", " & _
							" display_order = " & request.form(sKey & "_order") & _
							" where name = '" & sKey & "'"
				Response.write "<!-- SQL:" & sSQL & " -->"
				Call conn.execute(sSQL)
			end if
		End If
	Next
	Call Load_Pricing()
ElseIf request.form("btnAdd") = "Add New" Then
	sSQL = "Insert Into pricing_option (name,[desc],default_cost,display_order) " & _
				 "values ('" & request.form("txtName") & "','" & request.form("txtDesc") & "'," & _
				 Request.Form("txtCost") & "," & request.form("txtOrder") & ")"
	Call conn.execute(sSQL)
	Call Load_Pricing()
Else
	Call Load_Pricing()
End If

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
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
            <FORM name="myForm" action="admin_pricing.asp" method="post">
              	<table id="table_reg">
                    <tr>
                        <th>Name</th>
                        <th>Description</th>
                        <th>Delete</th>
                        <th>Price</th>
                        <th>Display Order</th>
                    </tr>
                    <%
                    For Each sKey in dictPrice.Keys
                    %>
                    <tr>
                        <td style="font-size:13px; font-weight:bold;"><%=sKey%></td>
                        <td>
                            <input name="<%=sKey%>_desc" value="<%=dictDesc.Item(sKey)%>" size=35>
                            <input type=hidden name="orig_<%=sKey%>_desc" value="<%=dictDesc.Item(sKey)%>">
                        </td>
                        <td align="center"><input type=checkbox name="chk_<%=sKey%>" value="on"></td>
                        <td valign=top align=right>
                            <INPUT name="<%=sKey%>_price" value="<%=formatcurrency(dictPrice.Item(sKey))%>" size=6>
                            <INPUT name="orig_<%=sKey%>_price" value="<%=dictPrice.Item(sKey)%>" type=hidden size=6>
                        </td>
                        <td align="center">
                            <input name="<%=sKey%>_order" value="<%=dictOrder.Item(sKey)%>" size=3>
                            <input type=hidden name="orig_<%=sKey%>_order" value="<%=dictOrder.Item(sKey)%>">
                        </td>
                    </tr>
                    <%
                    Next
                    %>
                    <TR>
                        <TD colspan=5 align="right"><input name="btnSave" type=submit value="Save Changes"></TD>
                    </TR>
                <!-- </table>
                <table width="100%"> -->
                    <tr>
                        <td colspan=5 class="big_text"><br />Add New Pricing Option</span></td>
                    </tr>
                    <tr>
                        <th>Name</th>
                        <th colspan="2">Desc</th>
                        <th>Cost</th>
                        <th>Display Order</th>
                    </tr>
                    <tr>
                        <td><input name="txtName" size=10 ></td>
                        <td colspan="2"><input name="txtDesc" size=35 ></td>
                        <td align="right"><input name="txtCost" size=6 /></td>
                        <td align="center"><input name="txtOrder" size=4 /></td>
                    </tr>
                    <TR>
                        <TD colspan=5 align="right"><input id=btnAdd name=btnAdd type=submit value="Add New"></TD>
                    </TR>
            </FORM>
            </td>
            </tr>
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
conn.close
set conn = nothing

Sub Load_Pricing()
	dictPrice.removeAll
	dictDesc.removeAll
	dictOrder.removeAll
	sSQL = "Select * " & _
				 "From pricing_option " & _
				 " where hide <> 'Y' Order By display_order "
	Set rsPrice = GetSQLServerRecordset( conn, sSQL )
	Do While not rsPrice.EOF
		dictPrice.Add rsPrice("name").value, rsPrice("default_cost").value
		dictDesc.Add rsPrice("name").value, rsPrice("desc").value
		dictOrder.Add rsPrice("name").value, rsPrice("display_order").value
		rsPrice.Movenext
	Loop
	rsPrice.close
	set rsPrice = nothing
End Sub
%>
