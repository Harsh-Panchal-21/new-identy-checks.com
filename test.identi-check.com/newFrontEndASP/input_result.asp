<!--#include virtual="db_constants.fun" -->
<!--#include virtual="DB.fun" -->
<!--#include virtual="functions.inc" -->
<%
dim msg, userid,name,company,company_rid,company_id

if session("admin") <> 2 then
	Response.Redirect "index.asp"
end if 

msg = Request("msg")
id = request("id")
userid = Session("UserID")
name = Session("name")
company = Session("company")
company_rid = Session("company_rid")
company_id  =request.querystring("company_id")
 
Set conn = GetSQLServerConnection( db_machine, db_userid, db_password, db_database )
dim type1,detail,state,date1,result

If request.form("submit1") = "Input" Then
	type1=request.form("type1")
	detail=request.form("detail")
	state=request.form("state")
	date1=request.form("date1")
	result=request.form("result")
	status=request.Form("status")
	If type1 = "" or detail = "" or state = "" or date1 = "" or result = "" then
		msg = "Please fill in all required fields."
	else
		SQL = "Insert Into result (id,type1,detail,state,date1,result,show,status) " & _
			"values (" & id & ",'" & type1 & "','" & replace(detail,"'","''") & "','" & state & _
			"','" & replace(date1,"'","''") & "','" & replace(result,"'","''") & "','Y','" & status & "')"
		Call conn.execute(SQL)
		msg = "Result has been entered"
		type1="":detail="":state="":date1="":result="":status=""
	end if
End If

Set rs = GetSQLServerRecordset( conn, "Select * From candidate Where id = " & id )
Set rsPkg = GetSQLServerRecordset( conn, "Select * From candidate_package Where candidate_id = " & id )
Set rsOpt = GetSQLServerRecordset( conn, "Select * From candidate_option Where candidate_id = " & id )
Set rsResults = GetSQLServerRecordset( conn, "Select * From result Where show = 'Y' and id = " & id )
Set rs_state = GetSQLServerRecordset( conn, "Select * From STATE_LIST" )
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
                    <td><center>
                        Welcome: <%=name%><br />
                        <%=now%>
                        <hr>
                        <h4 align="center">
                        <A href="candidate.asp?company_id=<%=company_id%>">*Submit Candidate</A>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <A href="main.asp?company_id=<%=company_id%>">Candidate List</A>
                        </h4>
                    	<h4 align="left">Ordered Searches</h4>
                            <table id="table_reg">
                                <tr>
                                    <th width=400h>Package</th>
                                    <th width=80>Price</th>
                                </tr>
                                <% If not rsPkg.EOF then %>
                                <tr>
                                    <td>State: <%=UCase(rsPkg("package_state")) & " - " & rsPkg("package_desc")%></td>
                                    <td align="right"><%=formatcurrency(rsPkg("package_cost"))%></td>
                                </tr>
                                <% End If %>
                                <% Do While Not rsOpt.EOF %>
                                    <tr>
                                        <th>Single Options</th>
                                        <th>Price</th>
                                    </tr>
                                    <tr>
                                    	<td><%=rsOpt("option_desc")%></td>
                                        <td align='right'><%=formatcurrency(rsOpt("option_price"))%></td>
                                    </tr>
                                <% rsOpt.Movenext
                                Loop %>
                            </table>
                            
                        <h4 align="left">Results Entered</h4>
                            <table id="table_reg">
                                <tr>
                                    <th>Inquires</th>
                                    <th>Detail</th>
                                    <th>State</th>
                                    <!--<td><font size="2">Completed Date</font></td>-->
                                    <th>Results</th>
                                    <th>Status</th>
                                </tr>
                                <%
                                If not rsResults.EOF Then
                                    Do While Not rsResults.EOF  
                                        Response.Write "<TR>"
                                        Response.Write "<TD>"
                                        if session("admin") = 2 then
                                            Response.Write "<a href=update_result.asp?company_id=" & company_id & "&candidate_id=" & id & "&id=" & rsResults("resultid") & " >.</a>"
                                        end if
                                        Response.Write rsResults("type1") 
                                        Response.Write "</td>"
                                        Response.Write "<TD>" & rsResults("detail") & "</td>"
                                        Response.Write "<TD>" & rsResults("state") & "</td>"
                                        Response.Write "<TD>" & rsResults("result") & "</TD>"
                                        Response.Write "<TD>" & Lookup_Status(rsResults("status")) & "</TD>"
                                        Response.Write "</TR>"
                                        rsResults.MoveNext  
                                    Loop
                                Else
                                    Response.Write "<TR><TD colspan=4>No results entered yet</TD></TR>"
                                End If
                                %>
                            </table>
                            
                        <h4 align="left">Input Result</h4>
                        <FORM name="myForm" action="input_result.asp?id=<%=id%>&company_id=<%=company_id%>" method="post">		
                        <TABLE id="table_reg">   
                            <tr>
                                <TD align=right >Name:</TD>
                                <td><b><%=rs("fname") & " " & rs("lname")%></b></td>
                            </tr>
                            <tr>
                                <TD align=right >SSN:</TD>
                                <td><b><%=rs("ssn")%></b></TD>
                            </TR>
                            <TR>
                                <TD align=right >Date of Birth:</TD>
                                <td><b><%=rs("dob")%></b></TD>
                            </TR>
                            <TR>
                                <TD align=right >Inquiries:</TD>
                                <td>
                                    <SELECT name=type1 ID="Select1">
                                        <option value="Civil Search">Civil Search</option>
                                        <option value="Credit Report">Credit Report</option>
                                        <option value="County Criminal">County Criminal</option>
                                        <option value="State Criminal">State Criminal</option>
                                        <option value="Federal Criminal">Federal Criminal</option>
                                        <option value="County Criminal">County Criminal</option>
                                        <option value="Employment">Employment</option>
                                        <option value="Education">Education</option>
                                        <option value="Motor Vehicle">Motor Vehicle</option>
                                        <option value="Professional License">Professional License</option>
                                        <option value="Social Security Number">Social Security Number</option>
                                        <option value="State Workers Comp">State Workers Comp</option>
                                        <option value="References">References</option>
                                        <option value="Military">Military</option>
                                        <option value="Corporation">Corporation</option>
                                        <option value="Drug">Drug</option>
                                        <option value="Current Address Check">Current Address Check</option>
                                        <option value="Reference Check">Reference Check</option>
                                        <option value="Other">Other</option>
                                </TD>
                            </TR>
                            <TR>
                                <TD align=right ><FONT color=red>*</FONT>Detail:</TD>
                                <td><textarea id="Textarea1" name="detail" size=30 rows=7 cols=50></textarea></TD>
                            </TR>
                            <TR>
                                <TD align=right ><FONT color=red>*</FONT>State:</TD>
                                <td>
                                    <SELECT id="text10" name="state">
                                        <% 
                                        Do While Not rs_state.EOF
                                            'if rs_state("STATE_ABBR") = rs1("state") then
                                            '	tmpSel = " selected"
                                            'else
                                            '	tmpSel = ""
                                            'end if
                                            Response.Write "<option value='" & rs_state("STATE_ABBR") & "'" & tmpSel & ">" & rs_state("STATE_NAME") & "</option>"
                                            rs_state.movenext
                                        Loop
                                        %>
                                    </SELECT>
                                </TD>
                            </TR>
                            <TR>
                                <TD align=right ><FONT color=red>*</FONT>Completed date:</TD>
                                <td><textarea id="Textarea3" name="date1" rows=7 cols=50></textarea></TD>
                            </TR>
                            <TR>
                                <TD align=right ><FONT color=red>*</FONT>Result:</TD>
                                <td><textarea id="Textarea2" name="result" size=50 rows=7 cols=50></textarea></TD>
                            </TR>
                            <TR>
                                <TD align=right >Status:</TD>
                                <td>
                                    <SELECT name=status>
                                        <option value="N">New</option>
                                        <option value="P">Pending</option>
                                        <option value="C">Completed</option>
                                    </select>
                                </TD>
                            </TR>
                            <TR>
                                <TD colspan=2 align="right"><INPUT id=submit1 name=submit1 type=submit value=Input>
                                <INPUT id=reset1 name=reset1 type=reset value=Reset></TD>
                            </TR>
                        </TABLE>
                        </FORM>
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