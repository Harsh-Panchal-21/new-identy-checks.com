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


msg = Request("msg")
UserID = Session("UserID")
name = Session("name")
company = Session("company")
company_rid = Session("company_rid")

Dim last, first, strQS, thisMonth, thisYear

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
	
SQL = "Select distinct company_id From candidate "
SQL = SQL & "where date1 like '" & sDate & "/%/" & thisYear & "%'"
<!--SQL = SQL & " and hide <> 'Y'"
-->
Set conn = GetSQLServerConnection( db_machine, db_userid, db_password, db_database ) 
Set rs = GetSQLServerStaticRecordset( conn, SQL )
 
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<!--#include file="headPrintAll.asp" -->
<center>

<!-- *************************************** MAIN CONTENT AREA *************************************** -->
 
                            <%
                            If not rs.EOF then 
                                
                                Response.Write "<CENTER><TABLE id='table_reg'>" & vbcrlf
                                
								
								Do While not rs.eof
								    'company_id = rs("company_id")

									SQL2 = "Select company_id, name, contact_name, title, division, address, city, state, zip, phone, fax from subscriber Where company_id=" & rs("company_id")
                                    SQL3 = "select id, fname, lname, total From candidate where company_id=" & rs("company_id") & " and date1 like '" & sDate & "/%/" & thisYear & "%' and hide <> 'Y'"  'finished = 'Y'
                                    SQLlastInvoiceNum = "select max(invoice_num) as invoice_num from invoice"
                                    SQLcompanyInvoice = "select * from invoice where company_id = " & rs("company_id") & " and month = " & sDate

									Set rs2 = GetSQLServerStaticRecordset( conn, SQL2 )
                                    Set rs3 = GetSQLServerRecordset(conn, SQL3)
                                    set rsLastInvNum = GetSQLServerRecordset(conn, SQLlastInvoiceNum)
                                    set rscompanyInv = GetSQLServerRecordset(conn, SQLcompanyInvoice)

                                    if not rsLastInvNum.eof then
	                                    inv_num = rsLastInvNum("invoice_num") + 1
	                                    if isnull(rsLastInvNum("invoice_num"))=true then
		                                    inv_num = 300
	                                    end if
                                    end if

                                            candidate_row = candidate_row & "<div style='width:100%; height:8px;'></div><TABLE style='page-break-before:always;' width='100%'><tr><td align='left'><font size='1'>3 N Old State Capitol Plaza<br />Springfield, IL 62701 <br />(P) 217-753-4311<br />(F) 217-753-3492<br />WWW.IDENTI-CHECK.COM</font> </td>"
                                            candidate_row = candidate_row & "<td align='right'><img src='images/print_header.png' width='285' height='69' /></td></tr>"
                                            candidate_row = candidate_row & "<tr height='38px'><td>&nbsp;</td><td>&nbsp;</td></tr><tr><td>&nbsp;</td><td>&nbsp;</td></tr>"
											
                                            candidate_row = candidate_row & "<tr><td ><font style='font-size:12px; line-height:12px;'>" & rs2("name") & "</font></td><td align='right'><font style='font-size:12px; line-height:12px;'>Phone:&nbsp;" & rs2("phone") & "</font></td></tr>"
                                            candidate_row = candidate_row & "<tr><td ><font style='font-size:12px; line-height:12px;'>" & rs2("contact_name") & "</font></td><td align='right'><font style='font-size:12px; line-height:12px;'>Fax:&nbsp;" & rs2("fax") & "</font></td></tr>"
                                            candidate_row = candidate_row & "<tr><td ><font style='font-size:12px; line-height:12px;'>" & rs2("division") & "</font></td><td></td></tr>"
                                            candidate_row = candidate_row & "<tr><td><font style='font-size:12px; line-height:12px;'>" & rs2("address") & "</font></td><td></td></tr>"
                                            candidate_row = candidate_row & "<tr><td > <font style='font-size:12px; line-height:12px;'>" & rs2("city") & ",&nbsp;" & rs2("state") & "&nbsp;" & rs2("zip") & "</font></td><td></td></tr>"
		                                    candidate_row = candidate_row & "<tr><td colspan='2' align='center'><h2>Invoice</h2></td></tr>"
                                            
		                                    
		                                    
                                            
                                    if not rs3.eof then
	                                    do while not rs3.eof
                                      
		                                    If not rscompanyInv.eof then 
			                                        inv_num = rscompanyInv("invoice_num")
                                                     
		 	                                        Do while not rscompanyInv.eof
				                                        If rscompanyInv("candidate_id") = rs3("id") then
					                                        SQLinvUpdate = "update invoice set candidate_total = " & rs3("total") & "where candidate_id = " & rs3("id")
					                                        conn.execute SQLinvUpdate
					                                        rscompanyInv.movenext
				                                        else
					                                        rscompanyInv.movenext
				                                        end if
			                                        loop
			                                        rscompanyInv.movefirst
		                                        else 
			                                        SQLnewInvoice = "insert into invoice (company_id, candidate_id, candidate_total, invoice_num, month) values (" & rs("company_id") & "," & rs3("id") & "," & rs3("total") & "," & inv_num & "," & sDate & ")"
			                                        conn.execute SQLnewInvoice
		                                        end if
                                            candidate_row1 = candidate_row1 & "	<tr><td width='75%'>" & rs3("fname") & " " & rs3("lname") & "</td>" & vbcrlf
		                                    candidate_row1 =  candidate_row1 & "	<td width='25%' align='right'><font style='color:red'>" & formatcurrency(rs3("total")) & "</font></td></tr>" & vbcrlf
                                            company_total = company_total + CCur(rs3("total"))
		                                    rs3.movenext
	                                    Loop
                                        final_total = formatcurrency(company_total,2)
                                        candidate_row = candidate_row & "<tr><td>" & MonthName(Month(Now())) & " " & Day(Now()) & ", " & Year(Now()) & "&nbsp;</td><td align='right'>Invoice Number:" & right(Year(Now()),2) & "&ndash;" & inv_num & "</td></tr>"
                                        candidate_row = candidate_row & "<tr><td align='left' colspan='2'><table class='table_reg' id='table_reg'>" & vbcrlf
                                        candidate_row = candidate_row & candidate_row1
                                        candidate_row = candidate_row & "<tr><td align='right'><font size='+1'><strong>Total: </strong></font></td><td align='right'><font size='+1'>" & final_total & "</font></td></tr></tr></table>"
                                                     
                                        candidate_row = candidate_row & "<tr><td colspan='2' align='center'>We appreciate your business. Please don't hesitate to call with any questions.</td></tr></table><br><br><br><br>"
                                        company_total = 0
                                        
                                    end if
                                    inv_num =""
									candidate_row1=""
                            		rs2.close
                                    rs.MoveNext
								Loop
                        
                                Response.Write "</TABLE></font></CENTER>"  & vbcrlf
                            end if
                            rs.close
                            set rs = nothing
                            set rs2 = nothing
                            conn.close
                            set conn = nothing
                            %>
                    </td>
                </tr>
            </table>
		</td>
    </tr>
</table>
<!-- ************************************* END MAIN CONTENT AREA ************************************* -->
<table width="619px" height="419" cellpadding="0" cellspacing="0" border="0">
    <tr>
        <td width="610px" valign="top" align="center">
            <table width="590px" cellpadding="0" cellspacing="0" border="0">
                <tr align="left">
                    <td>
            
                    
                                    	<%=candidate_row%>
                                        
                                    
                                </td>
                            </tr>
                      </TABLE>
                        
						


</body>
</html>
