<!--#include virtual="db_constants.fun" -->
<!-- #include virtual="DB.fun" -->
<!-- #include virtual="functions.inc" -->
<%
dim msg, userid,name,company,company_rid,company_id, total
if session("validuser") <> True then
	Response.Redirect "index.asp?msg=Not a valid user"
end if 

msg = Request("msg")
id = request("id")
userid = Session("UserID")
name = Session("name")
company = Session("company")
company_rid = Session("company_rid")
company_id  =request.querystring("company_id")

Set conn = GetSQLServerConnection( db_machine, db_userid, db_password, db_database ) 

thisMonth = cint(Month(date))
thisYear = year(date)
sDate = 02
eDate = "02/01/" & year(date)

SQL = "Select company_id, name, contact_name, title, division, address, city, state, zip, phone, fax from subscriber Where company_id=239"
SQL2 = "select id, fname, lname, total From candidate where company_id=239 and date1 like '02/%/2010%'" & " and hide <> 'Y' and id = 18603"

Set rs = GetSQLServerRecordset(conn, SQL)
Set rs2 = GetSQLServerRecordset(conn, SQL2)

if not rs2.eof then
	do while not rs2.eof
		candidate_row = candidate_row & "<tr>" & vbcrlf
		candidate_row = candidate_row & "	<td width='75%'>" & rs2("fname") & " " & rs2("lname") & "</td>" & vbcrlf
		candidate_row = candidate_row & "	<td width='25%' align='right'><a href='show_price1.asp?id=" & rs2("id") & "&company_id=" & company_id & "'>" & formatcurrency(rs2("total")) & "</a></td>" & vbcrlf
		candidate_row = candidate_row & "</tr>" & vbcrlf
		company_total = company_total + CCur(rs2("total"))
		rs2.movenext
	Loop
end if
 
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
                <tr align="left">
                    <td>
<a href="invoices_print.asp?company_id=<%=rs("company_id")%>" target=new>Printable Version</a>
            <TABLE width="100%">
                    <tr>
                                <td align="right"></td>
                                <td align="right">
                                        (P) 217-753-4311<br>
                                        (F) 217-753-3492<br>
                                        WWW.IDENTI-CHECK.COM
                                </td>
                  </tr>
                            <tr>
                                <td colspan="2" align="center"><h2>Invoice</h2></td>
                            </tr>
                            <tr>
                                <td><%=MonthName(Month(Now())) & " " & Day(Now()) & ", " & Year(Now())%><br />&nbsp;</td>
                                <td align="right"><!-- Invoice Number: #### --></td>
                            </tr>
                            <tr>
                                <td><%=rs("name")%></td>
                                <td>Phone:&nbsp;<%=rs("phone")%></td>
                            </tr>
                            <tr>
                                <td><%=rs("contact_name")%></td>
                                <td>Fax:&nbsp;<%=rs("fax")%></td>
                            </tr>
                            <tr>
                                <td><%=rs("division")%></td>
                                <td></td>
                            </tr>
                            <tr>
                                <td><%=rs("address")%></td>
                                <td></td>
                            </tr>
                            <tr>
                                <td><%=rs("city")%>,&nbsp;<%=rs("state")%>&nbsp;<%=rs("zip")%></td>
                                <td></td>
                            </tr>
                            <tr>
                                <td align="left"><!--<%=company%>-->&nbsp;</td>
                                <td align="left"></td>
                            </tr>
                            <tr>
                                <td align="left" colspan="2">
                                	<table class="table_reg" id="table_reg">
                                    	<%=candidate_row%>
                                        <tr>
                                        	<td align="right"><font size="+1"><strong>Total: </strong></font></td>
                                            <td align="right"><font size="+1"><%=formatcurrency(company_total,2)%></font></td>
                                            
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                      </TABLE>
                        
						
                        <p>&nbsp;</p>
                        
                        
                        
	<p><a href="invoices_print.asp?company_id=<%=rs("company_id")%>" target=new>Printable Version</a><p>
</td>
			</tr>
	</table>
</form>
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