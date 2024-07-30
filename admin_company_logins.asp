<!--#include virtual="db_constants.fun" -->
<!--#include virtual="DB.fun" -->
<!--#include virtual="functions.inc" -->
<%
if session("validuser") <> True then
	Response.Redirect "index.asp?msg=You must login"
end if 
if session("admin") <> 2 then
	Response.Redirect "index.asp?msg=Access denied"
end if 

Dim company_id

company_id = request.querystring("company_id")

dim sort_by, sort_dir
sort_by = request.QueryString("by")
sort_dir = request.QueryString("dir")
if sort_by = "" or sort_by = "date1" or sort_by = "convert(datetime,date1)" then
	sort_by = "convert(datetime,date1)"
end if
if sort_dir = "" then
	sort_dir = "asc"
end if

msg=Request("msg")
UserID = Session("UserID")
name = Session("name")
company = Session("company")
company_rid = Session("company_rid")

Myself = Request.ServerVariables("PATH_INFO")
SQL = "Select * From users where company_id = " & company_id & _
	"order by " & sort_by & " " & sort_dir
	'"order by convert(datetime,date1)"
 
Set conn = GetSQLServerConnection( db_machine, db_userid, db_password, db_database ) 
Set rs = GetSQLServerStaticRecordset( conn, SQL )
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<!--#include file="head.asp" -->

<!-- 
<div id="main">
    <div id="left"><img src="images2/left.png" width="162" height="419" /></div>
    <div id="middle">
-->

<!-- *************************************** MAIN CONTENT AREA *************************************** -->
<!-- 
<table width="619px" height="419" cellpadding="0" cellspacing="0" border="0">
    <tr>
        <td width="4px" background="images2/content-edge-left.png"></td>
        <td width="610px" valign="top" align="center">
            <table width="590px" cellpadding="0" cellspacing="0" border="0">
                <tr>
                    <td align="center">Welcome: <font color="red"><%=name%></font>
                    </td>
                </tr>
				<tr>
					<td align="center"><font color="red"><%=msg%></font></td>
				</tr>
				<tr>
					<td align="center"><%=now%></td>
				</tr>
                <tr>
                	<td>
-->             
				<center>
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
                                        <a href="admin_invoice.asp">Monthly Invoices</a>&nbsp;&nbsp; | &nbsp;&nbsp;
																				<a href="enter_ucc.asp" target='_blank'>UCC Admin</a>
                                    </h4>
                                </td>
                            </tr>
                        </table>
                        </td>
                        <td width="119">&nbsp;</td>
                    </tr>
                </table>
                </center>        
						<%
						If not rs.EOF then   
							rs.PageSize = 150
							intPageCount = rs.PageCount
							Page = Request.QueryString("page")
							If Page <= 1 Then 
								Page = 1
							end if
							If Page > 1 Then
								Response.write "<center><a href='admin_company_logins.asp?company_id=" & company_id & "&page=" & (Page - 1) & "&by=" & sort_by & "&dir=" & sort_dir & "'>&lt;&lt; Previous Page</a></center>"
							End If
							If Page < intPageCount Then
								Response.write "<center><a href='admin_company_logins.asp?company_id=" & company_id & "&page=" & (Page + 1) & "&by=" & sort_by & "&dir=" & sort_dir & "'>Next Page &gt;&gt;</a><center>"
							End If
							'if Page = 1 then
							'	Response.write "<center><a href='admin.asp?page=" & (Page + 1) & "&by=" & sort_by & "&dir=" & sort_dir & "'>Next Page &gt;&gt;</a><center>"
							'end if
							
							'ShowOnePage rs, Page
							Response.Write "<CENTER><TABLE id='table_wide'>"
              Response.Write "<tr>"
					    Response.Write "<td align=""center"" colspan='4'><font color=""red"">" & msg & "</font></td>"
				      Response.Write "</tr>"
              Response.Write "<tr>"
					    Response.Write "<td align=""center"" colspan='4'><a HREF=log_update.asp?id=0&company_id=" & company_id & " target=new>Add New Login</a></td>"
				      Response.Write "</tr>"
							Response.Write "<TR>"
							Response.Write "<TH>#</TH>"
							Response.WRITE "<TH><a style='color: white;' href='admin_company_logins.asp?company_id=" & company_id & "&by=date1&dir=" & iif(sort_by = "userid" and sort_dir = "asc","desc","asc") & "'>User ID</a></TH>" 
							Response.WRITE "<TH><a style='color: white;' href='admin_company_logins.asp?company_id=" & company_id & "&by=name&dir=" & iif(sort_by = "name" and sort_dir = "asc","desc","asc") & "'>Name</a></TH>"
							Response.WRITE "<TH>Email</TH>" 
							Response.Write "</TR>"
					
							rs.AbsolutePage= Page
					
							For iPage = 1 To 150
								Response.Write "<TR valign='top' align='left'>"
								RecNo = (Page - 1) * rs.PageSize + iPage     
								'Response.Write "<TD>" & RecNo & "</TD>"
								Response.Write "<TD>" & rs("id") & "</TD>"
								'Response.WRITE "<TD>" & rs("userid") & "</TD>" 
								Response.WRITE "<TD>" & "<a HREF=log_update.asp?id=" & rs("id") & "&company_id=" & rs("company_id") & " target=new>" & rs("userid") & "</TD>"
								Response.WRITE "<TD>" & rs("name") & "&nbsp;</TD>"        
								Response.WRITE "<TD>" & rs("email") & "&nbsp;</TD>" 
								Response.Write "</TR>"
					
								rs.MoveNext
								If rs.EOF Then Exit For
							Next
							Response.Write "</TABLE></CENTER>" 
						end if
						rs.close
						set rs = nothing
						conn.close
						set conn = nothing
						%>
<!-- 
                    </td>
                </tr>
            </table>			

        </td>
    </tr>
</table> -->
<!-- ************************************* END MAIN CONTENT AREA ************************************* -->

<!--
    </div>    
    <div id="right">&nbsp;</div>
</div>
-->

<!--#include file="foot.asp" -->

</body>
</html>
