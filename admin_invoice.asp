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

Dim last, first, strQS, thisMonth, thisYear, sDate, eDate

if request.querystring("btnSubmit") = "Go" then
	thisMonth = CInt(request.querystring("selMonth"))
	thisYear = CInt(request.querystring("selYear"))
	sDate = thisMonth
	eDate = thisMonth & "/01/" & thisYear
else
	if cint(month(date)) <> 1 then
		thisMonth = cint(Month(date))
		thisYear = year(date)
		sDate = thisMonth-1
		thisMonth = thisMonth - 1
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
<!--#include file="head19.asp" -->
<center>
<FORM name="myForm" action="admin_invoice.asp" method="get">
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
                                        <a href="admin_invoice.asp">Monthly Invoices</a>&nbsp;&nbsp; | &nbsp;&nbsp;
                                        <a href="invoiceAll.asp?selMonth=<%=thisMonth%>&selYear=<%=thisYear%>" target="_blank">Print All Invoices</a>
                                    </h4>

                        <!-- <FORM id="frmSearch" action="admin_invoice.asp" method="get">
                        <TABLE>
                        <TR>
                            <TD align="center">
                                Invoice Month Date: 
                                  <input id="text2" name="sDate" value="" />
                                <br />
                                Invoice End Date: <INPUT id="text3" name="eDate" value="">
                          </TD>
                        </TR>
                        <TR>
                            <TD align=center>
                                    <FONT color="red">Please input at least 2 letters.</FONT><br />
                                <INPUT id="submit1" type="submit" value="Search" name="submit1"> <INPUT id="reset1" type="reset" value="Reset" name="reset1"></TD>
                        </TR>
                        </table>
                      </FORM>
                        <br /> -->
							<center>
								Month: <select name='selMonth'>
									<%
										for i = 1 to 12
											response.write "<option value='" & i & "'" 
											if thisMonth = i then response.write " selected"
											response.write ">" & MonthName(i) & "</option>" & vbCrLf
										next
									%>
									</select>
								Year: <select name='selYear'>
									<%
										for i = -6 to 6
											response.write "<option value='" & (i + year(date)) & "'"
											if thisYear = (i + year(date)) then response.write " selected"
											response.write ">" & (i + year(date)) & "</option>" & vbCrLf
										next
									%>
									</select>
									<input type='submit' name='btnSubmit' value='Go'>
							</center>
                            <%
                            If not rs.EOF then 
                                
                                Response.Write "<CENTER><TABLE id='table_reg'>" & vbcrlf
                                Response.Write "<TR>" & vbcrlf
                                Response.Write "<TH>ID#</TH>" & vbcrlf
                                Response.WRITE "<TH>Company</TH>" & vbcrlf
                                Response.Write "</TR>" & vbcrlf
								
								Do While not rs.eof
								    'company_id = rs("company_id")
									
									SQL2 = "select name from subscriber where company_id = " & rs("company_id")
									Set rs2 = GetSQLServerStaticRecordset( conn, SQL2 )
									
                                    Response.Write "<TD><a href='invoices.asp?company_id=" & rs("company_id") & "&selMonth=" & thisMonth & "&selYear=" & thisYear & "'>" & rs("company_id") & "</a></TD>" & vbcrlf
                                    Response.WRITE "<TD>" & rs2("name") & "</TD>"                     & vbcrlf                
                                    Response.Write "</TR>" & vbcrlf
                        			
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

    </div>    
    <div id="right">&nbsp;</div>
</div>
</form>
<!--#include file="foot.asp" -->

</body>
</html>
