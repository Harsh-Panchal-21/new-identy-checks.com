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
if sort_by = "" then
	sort_by = "date1"
end if
if sort_dir = "" then
	sort_dir = "desc"
end if

msg = Request("msg")
UserID = Session("UserID")
name = Session("name")
company = Session("company")
company_rid = Session("company_rid")

Dim last, first, strQS
'Response.write "submit1: (" & request.querystring("submit1") & ")" & vbCrLf
SQL = "Select * From candidate "
If request.querystring("submit1") = "Search" Then
	lname = request.querystring("lname")
	fname = request.querystring("fname")
	
	TempSearch = Replace(lname,"'","''")
	TempSearch1 = Replace(fname,"'","''")
	
	SQL = SQL & "where lname like '%" & Replace(TempSearch, " ","%") & "%' "
	SQL = SQL & "and fname like '%" & Replace(TempSearch1, " ","%") & "%' "

	strQS = "&lname=" & lname & "&fname=" & fname & "&submit1=Search"
Else
	SQL = SQL & "where hide <> 'Y' and id > 0"
	strQS = ""
End If
SQL = SQL & " And id in (select id from result where status = 'N' and show <> 'N') "
SQL = SQL & " ORDER BY " & replace(sort_by,"date1","CONVERT(datetime, date1)") & " " & sort_dir

Set conn = GetSQLServerConnection( db_machine, db_userid, db_password, db_database ) 
Set rs = GetSQLServerStaticRecordset( conn, SQL )
 
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
                        <FORM id="frmSearch" action="admin1.asp" method="get">
                        <TABLE>
                        <TR>
                            <TD align="center">
                                <FONT color="red">*</FONT>Last Name: <INPUT id="text2" name="lname" value="<%=lname%>"><br />
                                <FONT color="red">*</FONT>First Name: <INPUT id="text3" name="fname" value="<%=fname%>">
                            </TD>
                        </TR>
                        <TR>
                            <TD align=center>
                                    <FONT color="red">Please input at least 2 letters.</FONT><br />
                                <INPUT id="submit1" type="submit" value="Search" name="submit1"> <INPUT id="reset1" type="reset" value="Reset" name="reset1"></TD>
                        </TR>
                        </table>
                        </FORM>
                        <br />
			<%
			If not rs.EOF then   
				rs.PageSize = 50
				intPageCount = rs.PageCount
				Page = CInt(Request("Page"))
				If Page < 1 Then 
					Page = 1
				end if
				If Page > 1 Then
					Response.write "<a href='admin_new.asp?by=" & sort_by & "&dir=" & sort_dir & "&page=" & (Page - 1) & strQS & "'>&lt;&lt; Previous Page</a>"
				End If
				Response.write "&nbsp;&nbsp;"
				If Page < intPageCount Then
					Response.write "<a href='admin_new.asp?by=" & sort_by & "&dir=" & sort_dir & "&page=" & (Page + 1) & strQS & "'>Next Page &gt;&gt;</a>"
				End If	
				
				Response.Write "<CENTER><TABLE id='table_reg'>"
				Response.Write "<TR>"
				Response.Write "<th>Number</th>"
				Response.WRITE "<th><a style='color: white;' href='admin_new.asp?by=company&dir=" & iif(sort_by = "company" and sort_dir = "asc","desc","asc") & strQS & "'>Company</a></th>"
				Response.WRITE "<th><a style='color: white;' href='admin_new.asp?by=lname,fname&dir=" & iif(sort_by = "lname,fname" and sort_dir = "asc","desc","asc") & strQS & "'>Name</a></th>"
				Response.WRITE "<th><a style='color: white;' href='admin_new.asp?by=date1&dir=" & iif(sort_by = "date1" and sort_dir = "asc","desc","asc") & strQS & "'>Date</a></th>" 
				Response.WRITE "<th>Update</th>"
				Response.WRITE "<th>Price</th>"
				Response.WRITE "<th>Result</th>"
				Response.WRITE "<th><font color=red>Delete</font>" & "</th>"
				Response.Write "</TR>"
		
				rs.AbsolutePage= Page
		
				For iPage = 1 To 50
					Response.Write "<TR>"
					RecNo = (Page - 1) * rs.PageSize + iPage     
					if session("admin") = 2 then		
						Response.Write "<TD>" & RecNo & "<a HREF=input_result.asp?id=" & rs("id") & "&company_id=" & rs("company_id") & "> .</a></TD>"
					else
						Response.Write "<TD>" & RecNo & ".</TD>"
					end if
					Response.WRITE "<TD>" & rs("company") & "&nbsp;</TD>"
					Response.WRITE "<TD>" & rs("fname") & " " & rs("lname") & "</TD>"
					Response.WRITE "<TD>" & rs("date1") & "</TD>" 
					Response.WRITE "<TD>" & "<a HREF=candidate_update.asp?company_id=" & rs("company_id") & "&id=" & rs("id") & ">" & "Click" & "</TD>"  
					Response.WRITE "<TD align='right'>" & "<a HREF=show_price1.asp?company_id=" & rs("company_id")& "&id=" & rs("id") & " target=new>"
						If rs("total") <> "" and rs("total") <> 0 then
							response.write formatcurrency(rs("total"))
						else
							response.Write rs("total")
						end if
						response.write "</TD>"      
					Response.WRITE "<TD>" & "<a HREF=show_result.asp?company_id=" & rs("company_id") & "&id=" & rs("id") & " target=new>" & "Click" & "</TD>"  
					If CInt(session("admin")) = 2 Then
						If rs("hide") <> "Y" Then
							Response.WRITE "<TD>" & "<a HREF=delete_candidate.asp?company_id=" & rs("company_id") & "&id=" & rs("id") & ">" & "<font color=red>Delete ID:" & rs("id") & "</font>" & "</TD>"
						Else
							Response.WRITE "<TD>" & "<a HREF=undelete_candidate.asp?company_id=" & rs("company_id") & "&id=" & rs("id") & ">" & "<font color=blue>UnDelete ID:" & rs("id") & "</font>" & "</TD>"
							'Response.WRITE "<TD><font color=red>Deleted<font></TD>"
						End If
					Else
						Response.WRITE "<TD>" & "<a HREF=delete_candidate.asp?company_id=" & rs("company_id") & "&id=" & rs("id") & ">" & "<font color=red>Delete ID:" & rs("id") & "</font>" & "</TD>"
					End If
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