<!--#include virtual="db_constants.fun" -->
<!-- #include virtual="DB.fun" -->
<!-- #include virtual="functions.inc" -->
<%
dim msg, userid,name,company,company_rid,company_id, total
dim thisMonth, thisYear
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

if request.querystring("selMonth") <> "" and request.querystring("selYear") <> "" then
	thisMonth = CInt(request.querystring("selMonth"))
	thisYear = CInt(request.querystring("selYear"))
	sDate = thisMonth
	eDate = thisMonth & "/01/" & thisYear
else
	if cint(month(date)) <> 1 then
		thisMonth = cint(Month(date))
		thisYear = year(date)
		sDate = thisMonth-1
		eDate = thisMonth & "/01/" & year(date)
	else
		thisMonth = 12
		thisYear = year(date)-1
		sDate = thisMonth
		eDate = thisMonth & "/01/" & year(date)-1
	end if
end if

SQL = "Select company_id, name, contact_name, title, division, address, city, state, zip, phone, fax from subscriber Where company_id=" & company_id
SQL2 = "select id, fname, lname, total From candidate where company_id=" & company_id & " and date1 like '" & sDate & "/%/" & thisYear & "%' and hide <> 'Y'"  '& " and hide <> 'Y'" 'finished = 'Y'
'SQL2 = "select id, fname, lname, total From candidate where company_id=" & company_id & " and date1 like '12/%/2010%'" & " and hide <> 'Y'"
SQLlastInvoiceNum = "select max(invoice_num) as invoice_num from invoice"
SQLcompanyInvoice = "select * from invoice where company_id = " & company_id & " and month = " & sDate & " and year = " & thisYear

Set rs = GetSQLServerRecordset(conn, SQL)
Set rs2 = GetSQLServerRecordset(conn, SQL2)
set rsLastInvNum = GetSQLServerRecordset(conn, SQLlastInvoiceNum)
set rscompanyInv = GetSQLServerRecordset(conn, SQLcompanyInvoice)

if not rsLastInvNum.eof then
	inv_num = rsLastInvNum("invoice_num") + 1
	if isnull(rsLastInvNum("invoice_num"))=true then
		inv_num = 300
	end if
end if

if not rs2.eof then
	do while not rs2.eof
		candidate_row = candidate_row & "<tr>" & vbcrlf
		candidate_row = candidate_row & "	<td width='75%'>" & rs2("fname") & " " & rs2("lname") & "</td>" & vbcrlf
		candidate_row = candidate_row & "	<td width='25%' align='right'><a href='show_price1.asp?id=" & rs2("id") & "&company_id=" & company_id & "'>" & formatcurrency(rs2("total")) & "</a></td>" & vbcrlf
		candidate_row = candidate_row & "</tr>" & vbcrlf
		company_total = company_total + CCur(rs2("total"))

		If not rscompanyInv.eof then 
      dim blnFound
      blnFound = false
			inv_num = rscompanyInv("invoice_num")
		 	Do while not rscompanyInv.eof
				If rscompanyInv("candidate_id") = rs2("id") then
					SQLinvUpdate = "update invoice set candidate_total = " & rs2("total") & "where candidate_id = " & rs2("id")
					conn.execute SQLinvUpdate
          blnFound = true
					rscompanyInv.movenext
				else
					rscompanyInv.movenext
				end if
			loop
			rscompanyInv.movefirst
      if not blnFound then
        SQLnewInvoice = "insert into invoice (company_id, candidate_id, candidate_total, invoice_num, month, year) values (" & rs("company_id") & "," & rs3("id") & "," & rs3("total") & "," & inv_num & "," & sDate & "," & thisYear & ")"
			  conn.execute SQLnewInvoice
      end if
		else 
			SQLnewInvoice = "insert into invoice (company_id, candidate_id, candidate_total, invoice_num, month, year) values (" & rs("company_id") & "," & rs2("id") & "," & rs2("total") & "," & inv_num & "," & sDate & "," & thisYear & ")"
			conn.execute SQLnewInvoice
		end if
		rs2.movenext
	Loop
end if
 
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
                                <td align="right">Invoice Number: <%=right(Year(Now()),2)%>&ndash;<%=inv_num%></td>
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
                        
                        
                        
	<p><a href="invoices_print.asp?company_id=<%=rs("company_id")%>&selMonth=<%=thisMonth%>&selYear=<%=thisYear%>" target='_blank'>Printable Version</a><p>
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