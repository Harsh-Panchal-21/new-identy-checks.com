<% 
Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cache"
'Response.AddHeader "cache-control", "private"
Response.Expires = -1 
%>
<!--#include file="lib.Data.asp"-->
<!--#include virtual="db_constants.fun" -->
<!--#include virtual="DB.fun" -->
<!--#include virtual="functions.inc" -->
<%
dim DB : set DB = new Database_Class
DB.Initialize db_conn
dim msg, userid,name,company,company_rid,company_id

if session("validuser") <> True then
	Response.Redirect "default.asp?msg=Not a valid userid"
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

msg=Request("msg")
userid = Session("UserID")
name = Session("name")
company = Session("company")
company_rid = Session("company_rid")
company_id  = request.querystring("company_id")

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
	  'Response.write "RID: " & company_rid & " ID: " & company_id & " userid: " & userid & vbCrLf
  End If
end if

'company_id=Request("company_id")
'name=Request.cookies("name")
'Response.cookies("name")=name
'company_id=Request("company_id")
'Response.cookies("company_id")=company_id

Myself = Request.ServerVariables("PATH_INFO")

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
	SQL = SQL & "where 1=1"
	strQS = ""
End If
SQL = SQL & " and company_id = " & company_id
If CInt(session("admin")) <> 2 Then
	SQL = SQL & " and hide <> 'Y'"
End If


'If CInt(session("admin")) = 2 Then
'	SQL = "Select * From candidate where company_id = " & company_id
'Else
'	SQL = "Select * From candidate where hide <> 'Y' And company_id = " & company_id
'End If

SQL = SQL & " ORDER BY " & replace(sort_by,"date1","CONVERT(datetime, date1)") & " " & sort_dir
'SQL = SQL & " ORDER BY CONVERT(datetime, date1) DESC "
'response.Write "SQL: " & SQL & "<BR>" & vbCrLf
'response.End
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
        <td width="610px" valign="top" align="center">
            <table width="590px" cellpadding="0" cellspacing="0" border="0">
            	<tr>
                	<td align="center">
                    <center>
                        Welcome: <%=name%><br />
                        <%=now%>
                        <hr></center>
                        <div width="100%" align="center">
						<div style="width:318px;" align="left">
						<h1 style="font-size:15px;">Information Now Available from your <br>online account.</h1>
						<a class="linkBtn" href="pdf/AuthorizationCandidateform.docx" target="_blank">Authorization for Release of Information</a>
							<a class="linkBtn" href="pdf/PreAdverse Action.docx" target="_blank">Pre-Adverse Action Example Letter</a>
							<a  class="linkBtn"href="pdf/Adverse Action Letter.doc" target="_blank">Adverse Action Example Letter</a>
							<a  class="linkBtn"href="pdf/consumerRightsUnderFCRA.doc" target="_blank">Consumer's Rights Under FCRA</a>
							<a  class="linkBtn"href="pdf/stateVSfederalCrime.pdf" target="_blank">State vs. Federal Crime Description</a>
							<a  class="linkBtn"href="pdf/legalTermCheatSheet.pdf" target="_blank">Legal Terms Cheat Sheet</a>
							<a  class="linkBtn"href="pdf/empBackroundReportGeneralPolicy.doc" target="_blank">Employment Background Report General Policy</a>
							<a  class="linkBtn"href="pdf/empBackroundReportGeneralPolicy.doc" target="_blank">Helpful Tips for Best Hiring Practices</a>
							</div>
							</div>
							<br><br>
							<h4 align="center">
                            <A href="candidate.asp?company_id=<%=company_id%>">*Submit Candidate</A>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <A href="main.asp?company_id=<%=company_id%>">Candidate List</A>
                        </h4>
                    <h4 align="left">Candidate List</h4>
                        <FORM id="frmSearch" action="main.asp" method="get">
                        <TABLE>
                        <TR>
                            <TD align="center">
                                <FONT color="red">*</FONT>Last Name: <INPUT id="text2" name="lname" value="<%=lname%>"><br />
                                <FONT color="red">*</FONT>First Name: <INPUT id="text3" name="fname" value="<%=fname%>"><input type=hidden name='company_id' value='<%=company_id%>'>
                            </TD>
                        </TR>
                        <TR>
                            <TD align=center>
                                    <FONT color="red">Please input at least 2 letters.</FONT><br />
                                <INPUT id="submit1" type="submit" value="Search" name="submit1" > <INPUT id="reset1" type="reset" value="Reset" name="reset1" ></TD>
                        </TR>
                        </table>
                        </FORM>
                        <br />
                        <%
                        If not rs.EOF then   
                        rs.PageSize = 50
                        intPageCount = rs.PageCount
                        Page = Cint(Request("Page"))
                        If Page < 1 Then 
                        	Page = 1
                        end if
						
                        If Page > 1 Then
                        	Response.write "<a href='main.asp?by=" & sort_by & "&dir=" & sort_dir & "&company_id=" & company_id & "&page=" & (Page - 1) & strQS & "'>&lt;&lt; Previous Page</a>&nbsp;"
                        End If
                        If Page < intPageCount Then
                        Response.write "&nbsp;<a href='main.asp?by=" & sort_by & "&dir=" & sort_dir & "&company_id=" & company_id & "&page=" & (Page + 1) & strQS & "'>Next Page &gt;&gt;</a>"
                        End If
                        
                        Response.Write "<CENTER><TABLE id='table_reg'>"
                        Response.Write "<TR>"
                        Response.Write "<Th>Number</th>"
                        Response.WRITE "<Th><a style='color: white;' href='main.asp?company_id=" & company_id & "&by=lname,fname&dir=" & iif(sort_by = "lname,fname" and sort_dir = "asc","desc","asc") & strQS & "'>Name</a></th>"
                        Response.WRITE "<Th><a style='color: white;' href='main.asp?company_id=" & company_id & "&by=date1&dir=" & iif(sort_by = "date1" and sort_dir = "asc","desc","asc") & strQS & "'>Date</a></th>" 
                        if session("admin") = 2 then	
                          Response.WRITE "<Th>Update</th>" 
                        end if
                        Response.WRITE "<Th>Price</th>" 
                        Response.WRITE "<Th>Result</th>"
                        Response.WRITE "<Th>ReSubmit</th>"
						If CInt(session("admin")) = 2 Then
							Response.WRITE "<Th>Delete</th>"
						End If
                        Response.Write "</TR>"
                        
                        rs.AbsolutePage= Page
                        
                        For iPage = 1 To 50
                        Response.Write "<TR>"
                        RecNo = (Page - 1) * rs.PageSize + iPage
                        if session("admin") = 2 then		
                        Response.Write "<TD>" & RecNo & "<a HREF='input_result.asp?id=" & rs("id") & "&company_id=" & rs("company_id") & "'> .</a></TD>"
                        else
                        Response.Write "<TD>" & RecNo & ".</TD>"
                        end if
                        Response.WRITE "<TD>" & rs("fname") & " " & rs("lname") & "</TD>"
                        Response.WRITE "<TD>" & rs("date1") & "</TD>"
												if session("admin") = 2 then	
													Response.WRITE "<TD>" & "<a HREF=candidate_update.asp?company_id=" & rs("company_id") & "&id=" & rs("id") & ">" & "Click" & "</TD>"  
												else
													'Response.Write "<TD>&nbsp;</TD>"
												end if
						Response.WRITE "<TD align='right'>" & "<a HREF=show_price1.asp?company_id=" & rs("company_id")& "&id=" & rs("id") & " target=new>"
							If rs("total") <> "" and rs("total") <> 0 then
								response.write formatcurrency(rs("total"))
							else
								response.Write rs("total")
							end if
						response.write "</TD>"      
                        Response.WRITE "<TD>" & "<a HREF=show_result.asp?company_id=" & rs("company_id") & "&id=" & rs("id") & " target=new>" & "Click" & "</TD>"
                        Response.WRITE "<TD>" & "<a HREF='candidate.asp?company_id=" & rs("company_id") & "&id=" & rs("id") & "'>ReSubmit</TD>"
                        If CInt(session("admin")) = 2 Then
							If rs("hide") <> "Y" Then
								Response.WRITE "<TD>" & "<a HREF=delete_candidate.asp?company_id=" & rs("company_id") & "&id=" & rs("id") & ">" & "<font color=red>Delete ID:" & rs("id") & "</font>" & "</TD>"
							Else
								Response.WRITE "<TD>" & "<a HREF=undelete_candidate.asp?company_id=" & rs("company_id") & "&id=" & rs("id") & ">" & "<font color='lt blue'>UnDelete ID:" & rs("id") & "</font>" & "</TD>"
								'Response.WRITE "<TD><font color=red>Deleted<font></TD>"
							End If
                        Else
							'Response.WRITE "<TD>" & "<a HREF=delete_candidate.asp?company_id=" & rs("company_id") & "&id=" & rs("id") & ">" & "<font color=red>Delete ID:" & rs("id") & "</font>" & "</TD>"
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