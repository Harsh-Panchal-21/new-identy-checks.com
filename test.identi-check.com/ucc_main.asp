<% 
Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cache"
'Response.AddHeader "cache-control", "private"
Response.Expires = -1 
%>
<!--#include virtual="db_constants.fun" -->
<!--#include virtual="DB.fun" -->
<!--#include virtual="functions.inc" -->
<%
dim msg, userid,name,company,company_rid,company_id

if session("validuser") <> True then
	Response.Redirect "index.asp?msg=Not a valid userid"
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

If CInt(company_rid) <> CInt(company_id) and company_rid <> 0 Then
	'not valid bounce back to login
	Response.Redirect "index.asp?msg1=Invalid company selection"
	'Response.write "RID: " & company_rid & " ID: " & company_id & " userid: " & userid & vbCrLf
End If
if Session("ucc_app") <> "Y" then
	Response.Redirect "index.asp?msg1=Invalid Company in UCC"
end if

'company_id=Request("company_id")
'name=Request.cookies("name")
'Response.cookies("name")=name
'company_id=Request("company_id")
'Response.cookies("company_id")=company_id

Myself = Request.ServerVariables("PATH_INFO")

Dim last, first, strQS

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<!--#include file="head.asp" -->

<div id="main">
    <div id="left"><img src="images/left.png" width="162" height="419" /></div>
    <div id="middle">

<!-- *************************************** MAIN CONTENT AREA *************************************** -->
<table width="619px" height="419" cellpadding="0" cellspacing="0" border="0">
    <tr>
        <td width="610px" valign="top" align="center">
            <table width="590px" cellpadding="0" cellspacing="0" border="0">
            	<tr>
                	<td align="center">
                    <center>
                        Welcome: <%=name%><br />
                        <%=now%>
                        <hr></center>
                        <h4 align="center">
                            <A href="candidate.asp?company_id=<%=company_id%>">*Submit Candidate</A>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <A href="main.asp?company_id=<%=company_id%>">Candidate List</A>
                        </h4>
                    <h4 align="left">Candidate List</h4>
                        <FORM id="frmSearch" action="ucc_main.asp" method="get">
                        
						<table>
							
						</table>
						
                        </FORM>
                        <br />
                        
						
						
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