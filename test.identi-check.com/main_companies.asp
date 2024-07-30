<!--#include virtual="db_constants.fun" -->
<!--#include virtual="DB.fun" -->
<!--#include virtual="functions.inc" -->
<%
if session("validuser") <> True then
	Response.Redirect "default.asp?msg=You must login"
end if 
if session("multi_com") <> "yes" then
	Response.Redirect "default.asp?msg=Access denied"
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
SQL = "Select * From subscriber where company_id in (Select Company_ID From Users_companies Where User_ID = " & session("id") & ") and hide ='N' " & _
	"order by " & sort_by & " " & sort_dir
	'"order by convert(datetime,date1)"
 
Set conn = GetSQLServerConnection( db_machine, db_userid, db_password, db_database ) 
Set rs = GetSQLServerStaticRecordset( conn, SQL )
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<!--#include file="head.asp" -->

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
                                        <a href="main_companies.asp">Company List</a>
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
								Response.write "<center><a href='main_companies.asp?page=" & (Page - 1) & "&by=" & sort_by & "&dir=" & sort_dir & "'>&lt;&lt; Previous Page</a></center>"
							End If
							If CInt(Page) < intPageCount Then
								Response.write "<center><a href='main_companies.asp?page=" & (Page + 1) & "&by=" & sort_by & "&dir=" & sort_dir & "'>Next Page &gt;&gt;</a><center>"
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
							Response.WRITE "<TH><a style='color: white;' href='main_companies.asp?by=date1&dir=" & iif(sort_by = "convert(datetime,date1)" and sort_dir = "asc","desc","asc") & "'>Date</a></TH>" 
							Response.WRITE "<TH><a style='color: white;' href='main_companies.asp?by=name&dir=" & iif(sort_by = "name" and sort_dir = "asc","desc","asc") & "'>Company Name</a></TH>"
							Response.WRITE "<TH>Branch / Division Name</TH>" 
							Response.WRITE "<TH>City / State / Zip</TH>"
							Response.WRITE "<TH>Contact Name</TH>" 
							Response.WRITE "<TH>Phone</TH>"
							Response.WRITE "<TH>Candidates</TH>"
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
								Response.WRITE "<TD style='padding-right:8px; padding-left:8px;'>" & "<a HREF=main.asp?company_id=" & rs("company_id") & " target=new>Candidates</TD>"
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


<!--#include file="foot.asp" -->

</body>
</html>
