<!--#include file="lib.Data.asp"-->
<!--#include virtual="db_constants.fun" -->
<!-- #include virtual="DB.fun" -->
<!-- #include virtual="functions.inc" -->
<%
dim DB : set DB = new Database_Class
DB.Initialize db_conn
dim msg, userid,name,company,company_rid,company_id
if session("validuser") <> True then
	Response.Redirect "default.asp?msg=Not a valid userd"
end if 
msg = Request("msg")
id = request("id")
userid = Session("UserID")
name = Session("name")
company = Session("company")
company_rid = Session("company_rid")
company_id  =request.querystring("company_id")

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
elseif session("admin") = 2 then
   'allow admin through
else
  If CInt(company_rid) <> CInt(company_id) and company_rid <> 0 Then
	  'not valid bounce back to login
	  Response.Redirect "default.asp?msg=Invalid company selection"
  End If
end if

Set conn = GetSQLServerConnection( db_machine, db_userid, db_password, db_database ) 

Set rsResults = GetSQLServerRecordset( conn, "Select *, isnull(result_filesize,0) as resfilesize From result Where show = 'Y' and id = " & id )
Set rs = GetSQLServerRecordset( conn, "Select * From candidate Where id = " & id ) 
set rsPkg = GetSQLServerRecordset( conn, "Select * From candidate_package Where candidate_id = " & id ) 
set rsOpt = GetSQLServerRecordset( conn, "Select * From candidate_option Where candidate_id = " & id ) 

 
SQL2 = "Select S.name, S.contact_name, S.title, S.division, S.address, S.city, S.state, S.zip, S.phone, s.fax  From candidate C, subscriber S Where C.id='" & id & "'" & " and C.company_id = S.company_id;"
Set rs2 = GetSQLServerRecordset( conn, SQL2 )

if rs.EOF then
	msg="The results are not yet ready."
	'Response.Redirect "result.asp?msg=" & msg
end if

if request.form("btnFinished") = "Finished" then
	Dim sSQL, rsComp
	Dim sMsg, sSubject, sTo

	sSQL = "Select * From subscriber where company_id = " & company_id
	Set rsComp = GetSQLServerStaticRecordset( conn, sSQL )
	if not rsComp.eof then
		sTo = rsComp("email")
		sSubject = "Results ready for candidate " & rs("fname") & " " & rs("lname")
		sMsg = "<br>" & rsComp("contact_name") & ",<br><br>Your results are ready for candidate " & rs("fname") & " " & rs("lname") & _
			"<br><br>Please login to the <a href='https://www.identi-check.com'>Identi-Check website</a> and check the results."
		call SendEmail(sTo,sSubject, sMsg)

		sSQL = "Update candidate set finished = 'Y' Where id = " & id
		Call conn.execute(sSQL)

		Set rs = GetSQLServerRecordset( conn, "Select * From candidate Where id = " & id ) 
	else
		'error company not found
		msg = "Error, company not found."
	end if
	rsComp.close
	set rsComp = nothing

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
                    <center>
                        Welcome: <%=name%><br />
                        <%=now%>
                        <hr></center>
                      <h4 align="center">
                            <A href="candidate.asp?company_id=<%=company_id%>">*Submit Candidate</A>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                          <A href="SelfServeCandidate.asp?company_id=<%=company_id%>&SelfServe=true">Request Candidate</A>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <A href="main.asp?company_id=<%=company_id%>">Candidate List</A>
                        </h4>
                        
                        <a href="show_result_print.asp?company_id=<%=rs("company_id")%>&id=<%=rs("id")%>" target=new>Printable Version</a>
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
                                <td colspan="2" align="center"><h2>Confidential Information</h2></td>
                            </tr>
                            <tr>
                                <td><%=MonthName(Month(Now())) & " " & Day(Now()) & ", " & Year(Now())%><br />&nbsp;</td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr>
                                <td><%=rs2("name")%></td>
                                <td>Phone:&nbsp;<%=rs2("phone")%></td>
                            </tr>
                            <tr>
                                <td><%=rs2("contact_name")%></td>
                                <td>Fax:&nbsp;<%=rs2("fax")%></td>
                            </tr>
                            <tr>
                                <td><%=rs2("division")%></td>
                                <td></td>
                            </tr>
                            <tr>
                                <td><%=rs2("address")%></td>
                                <td></td>
                            </tr>
                            <tr>
                                <td><%=rs2("city")%>,&nbsp;<%=rs2("state")%>&nbsp;<%=rs2("zip")%></td>
                                <td></td>
                            </tr>
                            <tr>
                                <td align="left"><!--<%=company%>-->&nbsp;</td>
                                <td align="left"></td>
                            </tr>
                            <tr>
                                <td align="left">Screening:&nbsp;
                                        <%=rs("fname")%>
                                        <%=" "%>
                                        <%=rs("lname")%>
                                </td>
                                <td align="left">Position:&nbsp;<%=rs("position_type")%></td>
                            </tr>
                            <tr>
                                <td align="left">SSN:&nbsp;<%
                                'rs("ssn")%>***-**-****
                                </td>
                                <td align="left"></td>
                            </tr>
                            <tr>
                                <td align="left"><%=rs("address")%></td>
                                <td align="left"></td>
                            </tr>
                            <tr>
                                <td align="left"><%=rs("city") & ", " & rs("state") & " " & rs("zip")%></td>
                                <td align="left"></td>
                            </tr>
                      </TABLE>
                        
						<h3 align="center">FINAL RESULTS</h3>
                        <table id="table_reg">
                            <tr>
                                <th>Inquires</th>
                                <th>Detail</th>
                                <th>State</th>
                                <!--<th>Completed Date</th>-->
                                <th>Results</th>
                                <th>Status</th>
                            </tr>
                            <%  If Not rs.EOF Then
                            Do While Not rsResults.EOF  
                                Response.Write "<TR>"
                                Response.Write "<TD>" 
                                if session("admin") = 2 then
                                    Response.Write "<a href=update_result.asp?company_id=" & company_id & "&candidate_id=" & id & "&id=" & rsResults("resultid") & " >.</a>" 
                                end if
                                Response.Write rsResults("type1") & "</td>"
                                Response.Write "<TD>" & rsResults("detail") & "</td>"
                                Response.Write "<TD>" & rsResults("state") & "</td>"
                                Response.Write "<TD>" & rsResults("result")
								If CDbl(rsResults("resfilesize")) > 0  then
									Response.write" (<a href='display_file.asp?id="
									Response.Write rsResults("resultid")
									Response.Write "' target='_blank'>Download Results</a>)"
								end if
								Response.write "</TD>"
                                Response.Write "<TD>" & IIF(rsResults("status")="N","New",IIF(rsResults("status")="P","Pending","Completed")) & "</TD>"
                                Response.Write "</TR>"
                                rsResults.MoveNext  
                            Loop
Else
	' Notify the visitor of the problem
	Response.Write("File could not be found")
End If
                    
                            if session("admin") = 2 then
                                'Response.Write "<a href=update_result.asp?company_id=" & company_id & "&candidate_id=" & id & "&id=" & rsResults("resultid") & " >.</a>" 
                                Response.write "<tr><td colspan=5 align=center>"
                                if rs("finished") = "Y" then
                                    response.write "You have already sent the finished email and marked the candidate as finished.<br>"
                                else
                                    '
                                end if
                                Response.write "<form name=myForm action='show_result.asp?company_id=" & company_id & "&id=" & id & "' method='post'><input type=submit name='btnFinished' value='Finished'></form>"
                                Response.write "</td></tr>"
                            end if
                            %>
                        </table>
                        <p>&nbsp;</p>
                        
                        <!--<h4>Inquiries</h4> -->
                        <table id="table_reg">
                            <tr>
                                <th width=400>Package</th>
                                <th width=80>Price</th>
                            </tr>
                            <% If Not rsPkg.EOF Then %>
                            <tr>
                                <td>State: <b><%=UCase(rsPkg("package_state")) & " - " & rsPkg("package_desc")%></td>
                                <td align=right><%=FormatCurrency(rsPkg("package_cost"))%></td>
                            </tr>
                            <% end If %>
                            <tr>
                                <th>Single Options</b></th>
                                <th>Price</th>
                            </tr>
                            <% 
                            Do While Not rsOpt.EOF %>
                            <tr>
                            	<td><%=rsOpt("option_desc")%></td>
                                <td align=right><%=FormatCurrency(rsOpt("option_price"))%></td>
                            </tr>
                            <% rsOpt.Movenext
                            Loop %>	
                            <tr>
                                <td><b>Total</b></td>
                                <td align=right><b><%=FormatCurrency(rs("total"))%></b></td>
                            </tr>
                        </table>
                        
	<p><a href="show_result_print.asp?company_id=<%=rs("company_id")%>&id=<%=rs("id")%>" target=new>Printable Version</a><p>
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