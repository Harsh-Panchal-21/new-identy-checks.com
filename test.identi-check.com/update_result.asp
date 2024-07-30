<!--#include virtual="db_constants.fun" -->
<!-- #include virtual="DB.fun" -->
<!--#INCLUDE FILE="clsUpload.asp"-->
<%
dim msg, userid, name, company, candidate_id
if session("admin")<> 2 then
	Response.Redirect "index.asp?msg=Access Denied"
end if 
id = request.querystring("id")
candidate_id = request.querystring("candidate_id")
company_id = request.querystring("company_id")
msg = request.QueryString("msg")
name = Session("name")
company = Session("company")

Set conn = GetSQLServerConnection( db_machine, db_userid, db_password, db_database ) 
Set Upload = New clsUpload

'dim emphasize
 ' if cbxEmphasize.checked = true then
    'empahsize = 1
    'else
    'emphasize = 0
   ' end if 

If Upload("submit1").value = "Update" Then
	dim type1, detail, date1, state, result
	type1 = Upload.Fields("type1").value
  	detail = Upload.Fields("detail").value
	date1 = Upload.Fields("date1").value
  	state = Upload.Fields("state").value
  	result = Upload.Fields("result").value
  	status = Upload.Fields("status").value

  

'	if date1 = "" or result = "" then
'		msg="Please go back and complete all required fields."
'	else
		Set rs = GetSQLServerRecordset( conn, "Select * From result Where resultid = " & id )
	
	If upload("picture_upload").length > 0 Then
		'rs.Fields("result_filename").Value = upload.Fields("picture_upload").FileName
		rs.Fields("result_filesize").Value = upload.Fields("picture_upload").Length
		rs.Fields("result_contenttype").Value = upload.Fields("picture_upload").ContentType '"text/html"
		rs.Fields("result_file").AppendChunk upload("picture_upload").BLOB & ChrB(0)
	Else
		'no picture attached
		strFileName = ""
	end if

		rs.Fields("detail").value = detail
		rs.Fields("date1").value = date1
		rs.Fields("type1").value = type1
		rs.Fields("state").value = state
		rs.Fields("result").value = result
		rs.Fields("status").value = status
        'rs.Fields("emphasize").value = emphasize
		rs.update

		msg = "You have updated completely!"
		url = "show_result.asp?company_id=" & company_id & "&id=" & candidate_id
		response.Redirect(url)
'	end if
End If

Set rs1 = GetSQLServerRecordset( conn, "Select * From result Where resultid = " & id )
Set rs = GetSQLServerRecordset( conn, "Select * From candidate Where id = " & candidate_id )
Set rs_state = GetSQLServerRecordset( conn, "Select * From STATE_LIST" )
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<script language="javascript">
function DoEmpty(comp,cand,id){
	if (confirm("Are you sure you want to permanently delete this record?"))
	window.location = "delete_result.asp?company_id=" + comp + "&candidate_id=" + cand  + "&id=" + id;
	}
</script>

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
                            <hr>
                        </center>
                        <h4 align="center">
                            <A href="candidate.asp?company_id=<%=company_id%>">*Submit Candidate</A>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <A href="main.asp?company_id=<%=company_id%>">Candidate List</A>
                        </h4>
                        <h4>Update Result</h4>
                            
                        <FORM id="myForm" name="myForm" action="update_result.asp?candidate_id=<%=candidate_id%>&id=<%=id%>&company_id=<%=company_id%>" method="post" enctype="multipart/form-data">
                            <input type=hidden name="id" value=<%=id%>><input type="hidden" name="company_id" value="<%=company_id%>" />
                            <TABLE id="table_reg">
                                <tr>
                                    <TD align=right>First Name:</TD>
                                    <td><INPUT id=text2 name="fname" size=36 value="<%=rs("fname")%>"><FONT color=red>*</FONT></td>
                                </tr>
                                <TR>
                                    <TD align=right>Last Name:</TD>
                                    <TD><INPUT value="<%=rs("lname")%>" name="lname" size=30><FONT color=red></FONT></TD>
                                </TR>
                                <tr>
                                    <TD align=right>SSN:</TD>
                                    <TD><INPUT value="<%=rs("ssn")%>"  name=ssn ID="Text1"><FONT color=#ff0000></FONT></TD>
                                </TR>
                                <TR>
                                    <TD align=right>Date of Birth:</TD>
                                    <TD><INPUT value="<%=rs("dob")%>"  name=dob ID="Text4"><FONT color=#ff0000></FONT></TD>
                                </TR>
                                <TR>
                                    <TD align=right>Inquiries:</TD>
                                    <TD>
                                        <SELECT name=type1 ID="Select1">
                                        <option value="<%=rs1("type1")%>"><%=rs1("type1")%></option>
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
                                        <option value="Workers Compensation">Workers Compensation</option>
                                        <option value="References">References</option>
                                        <option value="Military">Military</option>
                                        <option value="Corporation">Corporation</option>
                                        <option value="Drug">Drug</option>
                                        <option value="Current Address Check">Current Address Check</option>
                                        <option value="Reference Check">Reference Check</option>
                                        <option value="Other">Other</option>
                                        </select>
                                    </TD>
                                </TR>
                                <TR>
                                    <TD align=right>Detail:</TD>
                                    <TD><textarea id="Textarea1" name="detail" rows=2 cols=35><%=rs1("detail")%></textarea><FONT color=red></FONT></TD>
                                </TR>
                                <TR>
                                    <TD align=right>State:</TD>
                                    <TD><SELECT id="text10" name="state">
                                        <option value=""></option>
                                        <% 
                                        Do While Not rs_state.EOF
                                        if lcase(rs_state("STATE_ABBR")) = lcase(rs1("state")) then
                                        tmpSel = " selected"
                                        else
                                        tmpSel = ""
                                        end if
                                        Response.Write "<option value='" & rs_state("STATE_ABBR") & "'" & tmpSel & ">" & rs_state("STATE_NAME") & "</option>"
                                        rs_state.movenext
                                        Loop
                                        %>
                                        </SELECT>
                                        <FONT color=red>*</FONT>
                                    </TD>
                                </TR>
                                <TR>
                                    <TD align=right>Completed date:</TD>
                                    <TD><textarea id="Textarea3" name="date1" rows=2 cols=35><%=rs1("date1")%></textarea><FONT color=red></FONT></TD>
                                </TR>
                                <TR>
                                    <TD align=right>Result:</TD>
                                    <TD><textarea id="Textarea2" name="result" rows=2 cols=35><%=rs1("result")%></textarea><FONT color=red></FONT></TD>
                                </TR>
                                <TR>
                                    <TD align=right>File:</TD>
                                    <TD><input type=file name="picture_upload"></TD>
                                </TR>
                                <tr>
                                    <TD align=right>Status:</TD>
                                    <TD>
                                        <select name='status'>
                                            <option value='N'<% if rs1("status") = "N" Then Response.Write " selected" %>>New</option>
                                            <option value='P'<% if rs1("status") = "P" Then Response.Write " selected" %>>Pending</option>
                                            <option value='C'<% if rs1("status") = "C" Then Response.Write " selected" %>>Completed</option>
                                        </select>&nbsp;
                                        '<input id="cbxEmphasize" type="checkbox" /> Check to emphasize result
                                    </TD>
                                </tr>
                                <TR>
                                    <TD colspan=2 align="right">
                                    <INPUT id="submit1" name="submit1" type="submit" value="Update">
                                    <INPUT id=reset1 name=reset1 type=reset value=Reset>
                                    <input type="button" value="Delete"  onClick="DoEmpty(<%=company_id%>,<%=candidate_id%>,<%=id%>);" ID="Button1" NAME="Button1">       
                                    </TD>
                                </TR>
                            </TABLE>
                        </FORM>
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