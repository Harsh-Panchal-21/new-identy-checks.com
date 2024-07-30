<% 
Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cache"
'Response.AddHeader "cache-control", "private"
Response.Expires = -1 
%>

<!--#include file="lib.Data.asp"-->
<!-- #include virtual="DB.fun" -->
<!-- #include virtual="db_constants.fun" -->
<!-- #include virtual="functions.inc" -->
<!-- #include file ="adovbs.inc" -->
<%
dim DB : set DB = new Database_Class
DB.Initialize db_conn

dim hideAndShowForm,token,rs,conn,sql,companyName,candidateName,candidateId
dim ssPhone

token = request.querystring("token")
Set conn = GetSQLServerConnection( db_machine, db_userid, db_password, db_database )

If token = "" Then
    hideAndShowForm = "display:none;"
    msg = "Token not valid or supplied"
Else
    hideAndShowForm = ""

    'check to see if token is valid
    sql = "SELECT * FROM SelfServeCandidate WHERE authToken = '" & token & "'"
    Set rs = GetSQLServerStaticRecordset(conn, sql)

    If rs("hasAuthorized") = "0" Then
        hideAndShowForm = ""

        'get their name and company
        sql = "select * from SelfServeCandidate SSC inner join subscriber s ON s.company_id = SSC.companyID where authToken = '" & token &"'"
        Set rs = GetSQLServerStaticRecordset(conn, sql)
        companyName = rs("name")
        Session("company") = companyName
        candidateName = rs("ssFname") & " " & rs("ssLname")
        Session("name") = candidateName
        Session("company_id") = rs("companyID")
        candidateId = rs("candidateID")
        Session("candidate_id") = candidateId
    Else
        hideAndShowForm = "display:none;"
        msg = "Token has already been used."
    End If

    rs.close
    set rs = nothing

    ssPhone = request.form("ssPhone")
End If

If request.form("submit2") = "Continue" Then
    If ssPhone = "" or len(ssPhone) <> 14  or request.Form("ssAgree") = "" Then
        If ssPhone = "" or request.Form("ssAgree") = "" then
        msg="Please complete all required fields."
        end if
        if len(ssPhone) <> 14 then
            msg = msg + "<br>Please enter a valid phone number"
    end if

    Else
        'check there phone number matches up
        sql = "select * from SelfServeCandidate SSC inner join subscriber s ON s.company_id = SSC.companyID where authToken = '" & token &"'"
        Set rs = GetSQLServerStaticRecordset(conn, sql)

        If rs("ssPhone") = request.form("ssPhone") Then
            'update has auth
            Call DB.Execute("update SelfServeCandidate set hasAuthorized = 1 where authToken = ?",Array(token))

            'redirect to fill out information
            Response.Redirect "SelfServeCandidateInfo.asp?token=" & token & "&candidate_id=" & candidateId
        Else
            msg = "Phone number does not match. Please try again."
        End If

        rs.close
        set rs = nothing
    End If
End If 

%>




<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <!--#include file="head.asp" -->
    <title></title>
</head>
<body>
    <center>

        <!-- *************************************** MAIN CONTENT AREA *************************************** -->
        <table width="619px" height="419" cellpadding="0" cellspacing="0" border="0" id="phoneTable">
            <tr>
                <td width="610px" valign="top" align="center">
                    <table width="590px" cellpadding="0" cellspacing="0" border="0">
                        <tr align="left">
                            <td>

                                <h4>Request Candidate Verification</h4>
                                <font color="#FF0000"><strong><%=msg%></strong></font>
                                <form name="myForm" action="SelfServeAuth.asp?ssPhone=<%=ssPhone%>&token=<%=token%>" method="post" style="<%=hideAndShowForm%>">


                                    <table id="table_reg">
                                        <tr>
                                            <td align="right">Phone Number:
                                            </td>
                                            <td>
                                                <input name="ssPhone" id="ssPhone" value="<%=ssPhone%>" size="30" maxlength="50" /><font color="red">*</font>
                                            </td>

                                        </tr>
                                        <tr>
                                            <td colspan="2">
                                                <input type="checkbox" id="ssAgree" size="30" name="ssAgree"/>
                                                <label for="ssAgree">By clicking this check box you are agreeing to the terms below.<font color="red">*</font></label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2">
                                                In connection with my application for employment with <%=companyName%>
                                                I <%=candidateName%>,authorize the procurement of a background screening report 
                                                prior to any employment offer as well as periodic screening during employment should
                                                an offer be tendered and accepted. I understand that it may contain information about
                                                my background, character, general reputation, mode of living, criminal history, driving 
                                                record, educational background, and job performance. <br /><br />

                                                I further understand that my credit history may be obtained if necessary and authorized by the exceptions 
                                                and exemptions listed under the Illinois Employee Credit Privacy Act, which allows credit reports to be 
                                                obtained and used under the following situations:
                     
                                                <ul style="color: black !important; font-size: 12px !important;">
                                                    <li>
                                                    Banks and financial companies
                                                    </li><li>
                                                    Insurance companies
                                                    </li><li>
                                                    State law enforcement or investigative units.
                                                    </li><li>
                                                    State and local government agencies that require the use of an employee’s credit history.
                                                    </li><li>
                                                    Any entity defined as a debt collector.
                                                    </li><li>
                                                    State or federal law requires bonding or other security covering an individual holding the position.
                                                    </li><li>
                                                    The duties of the position include custody of or unsupervised access to cash or marketable assets valued at $2,500.00 or more.
                                                    </li><li>
                                                    The duties of the position include signatory power over business assets of $100 or more per transaction.
                                                    </li><li>
                                                    The position is a managerial position which involves setting the direction or control of the business.
                                                    </li><li>
                                                    The position involves access to personal or confidential information, financial information, trade secrets, or State or national security information.
                                                    </li><li>
                                                    The position meets criteria in administrative rules, if any, that the U.S. Department of Labor or the Illinois Department of Labor has 
                                                        promulgated to establish the circumstances in which a credit history is a bona fide occupational requirement.
                                                    </li><li>
                                                    The employee's or applicant's credit history is otherwise required by or exempt under Federal or State law.
                                                    </li>
                                                </ul>
                                              
                                                I understand that, upon written request within a reasonable period of time, I am entitled to additional information concerning 
                                                the nature and scope of this pre-employment screening. I hereby release IDENTI-CHECK, Inc., its officers, agents, employees and 
                                                servants from any liability arising from the preparation of this report or pre-employment screenings relating thereto.
                                                <br /><br />
                                                This authorization for release of information includes, but is not limited to, matters of opinion relating to my character, ability, 
                                                reputation and past performance. I authorize all persons, schools, companies, corporations, and law enforcement agencies to release 
                                                such information without restriction or qualifications to IDENTI-CHECK, Inc. and any of its officers, agents, employees and servants. 
                                                I voluntarily waive all recourse and release them from liability from complying with this authorization. I authorize that a 
                                                photocopy of this release be considered as valid as the original.
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2">
                                                <input id="submit2" name="submit2" type="submit" value="Continue"/>
                                                <input id="reset2" name="reset2" type="reset" value="Reset"/>&nbsp; 
                              <font color="red">Please provide your phone number without dashes.</font></td>
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
    </center>

    <script type="text/javascript">
        document.getElementById('ssPhone').addEventListener('input', function (e) {
            var x = e.target.value.replace(/\D/g, '').match(/(\d{0,3})(\d{0,3})(\d{0,4})/);
            e.target.value = !x[2] ? x[1] : '(' + x[1] + ') ' + x[2] + (x[3] ? '-' + x[3] : '');
        });

    </script>

    <!--#include file="foot.asp" -->

</body>
</html>
