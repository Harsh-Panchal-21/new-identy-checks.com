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
SQL = "Select * From subscriber where company_id > 0 and hide ='N' " & _
	"order by " & sort_by & " " & sort_dir
	'"order by convert(datetime,date1)"
 
Set conn = GetSQLServerConnection( db_machine, db_userid, db_password, db_database ) 
Set rs = GetSQLServerStaticRecordset( conn, SQL )
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<!--#include file="head19.asp" -->

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
				<div class="w3-container" align="center">
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
                    </tr>
                </table>
                </center>        
						<%
						If not rs.EOF then   
							rs.PageSize = 150 '150
							intPageCount = rs.PageCount
							Page = Request.QueryString("page")
							If Page <= 1 Then 
								Page = 1
							end if
							If Page > 1 Then
								Response.write "<center><a href='admin.asp?page=" & (Page - 1) & "&by=" & sort_by & "&dir=" & sort_dir & "'>&lt;&lt; Previous Page</a></center>"
							End If
							If CInt(Page) < intPageCount Then
								Response.write "<center><a href='admin.asp?page=" & (Page + 1) & "&by=" & sort_by & "&dir=" & sort_dir & "'>Next Page &gt;&gt;</a><center>"
							'else
								'response.write "PageCount: " & intPageCount
							End If
							'if Page = 1 then
							'	Response.write "<center><a href='admin.asp?page=" & (Page + 1) & "&by=" & sort_by & "&dir=" & sort_dir & "'>Next Page &gt;&gt;</a><center>"
							'end if
							
							'ShowOnePage rs, Page
							Response.Write "<CENTER><TABLE id='table_wide'>"
							Response.Write "<TR>"
							Response.Write "<TH>#</TH>"
							Response.WRITE "<TH><a style='color: white;' href='admin.asp?by=date1&dir=" & iif(sort_by = "convert(datetime,date1)" and sort_dir = "asc","desc","asc") & "'>Date</a></TH>" 
							Response.WRITE "<TH><a style='color: white;' href='admin.asp?by=name&dir=" & iif(sort_by = "name" and sort_dir = "asc","desc","asc") & "'>Company Name</a></TH>"
							Response.WRITE "<TH>Branch / Division Name</TH>" 
							Response.WRITE "<TH>City / State / Zip</TH>"
							Response.WRITE "<TH>Contact Name</TH>" 
							Response.WRITE "<TH>Phone</TH>"
							Response.WRITE "<TH>Login</TH>"
							Response.WRITE "<TH>Detail</TH>"
							Response.WRITE "<TH>Candidate</TH>"
							Response.WRITE "<TH>Pricing</TH>"
							Response.WRITE "<TH>Delete</TH>"
							Response.Write "</TR>"
					
							rs.AbsolutePage= Page
					
							For iPage = 1 To 150 '150
								Response.Write "<TR valign='top' align='left'>"
								RecNo = (Page - 1) * rs.PageSize + iPage     
								'Response.Write "<TD>" & RecNo & "</TD>"
								Response.Write "<TD>" & rs("company_id") & "</TD>"
								Response.WRITE "<TD>" & rs("date1") & "</TD>"   
								Response.WRITE "<TD>" & rs("name") & "&nbsp;</TD>"        
								Response.WRITE "<TD>" & rs("division") & "&nbsp;</TD>" 
								Response.WRITE "<TD>" & rs("city") & " / " & rs("state") & " / " & rs("zip") & "</TD>" 
								Response.WRITE "<TD>" & rs("contact_name") & "&nbsp;</TD>" 
								Response.WRITE "<TD>" & rs("phone") & "&nbsp;</TD>"
								Response.WRITE "<TD style='padding-right:4px; padding-left:4px;'>" & "<a HREF=admin_company_logins.asp?company_id=" & rs("company_id") & " target=new>Update</TD>"
								'Response.WRITE "<TD>" & "<a HREF=candidate_update.asp?id=" & rs("id") & ">Login</TD>"  
								Response.WRITE "<TD style='padding-right:8px; padding-left:8px;'>" & "<a HREF=admin_detail.asp?company_id=" & rs("company_id") & " target=new>Detail</TD>" 
								Response.WRITE "<TD style='padding-right:8px; padding-left:8px;'>" & "<a HREF=main.asp?company_id=" & rs("company_id") & " target=new>Candidate</TD>"
								Response.WRITE "<TD style='padding-right:8px; padding-left:8px;'>" & "<a HREF=pricing.asp?company_id=" & rs("company_id") & " target=new>Pricing</TD>"
								Response.WRITE "<TD style='padding-right:8px; padding-left:8px;'>" & "<a HREF=delete.asp?company_id=" & rs("company_id") & ">" & "Delete ID:" & rs("company_id") & "</TD>"   
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
							</div>
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
