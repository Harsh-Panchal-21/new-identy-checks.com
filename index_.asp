<!--#include virtual="db_constants.fun" -->
<%
Dim sScriptName, sServerName, sNewURL, sNewScript
Dim iPosA
sServerName = Request.ServerVariables("SERVER_NAME")
sScriptName = Request.ServerVariables("SCRIPT_NAME")
iPosA = InstrRev(sScriptName, "/")
sNewScript = Mid(sScriptName, 1, iPosA) & "checkpass.asp"
if db_platform = "test" then
	sNewURL = "http://" & sServerName & sNewScript
else
	sNewURL = "https://" & sServerName & sNewScript
end if
'Response.write "<!-- SCRIPT_NAME: " & sScriptName & "  -->" & vbCrLf
'Response.write "<!-- SERVER_NAME: " & sServerName & "  -->" & vbCrLf
'Response.write "<!-- NewScript: " & sNewScript & "  -->" & vbCrLf
'Response.write "<!-- NewURL: " & sNewURL & "  -->" & vbCrLf

msg = request.QueryString("msg")
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<script type="text/javascript">
function focusIt()
	{
	var mytext = document.getElementById("UserID");
	mytext.focus();
	}
	//document.logon.UserID.focus()
</script>
<!--#include file="head2.asp" -->

<div id="main">
    <div id="left"><img src="images/left.png" width="162" height="419" /></div>
    <div id="middle">
    
<!-- *************************************** MAIN CONTENT AREA *************************************** -->
<table width="619px" height="419" cellpadding="0" cellspacing="0" border="0">
    <tr>
        <td width="610px" valign="top" align="center">
            <table width="590px" cellpadding="0" cellspacing="0" border="0">
                <tr>
                    <td align="center"><br /><img src="images/logo_lg.png" width="403" height="94" alt="Identi-Check Logo" /><br />&nbsp;</td>
                </tr>
                <tr>
                    <td align="center">
                        Identi-Check Inc. is a full service, licensed, and insured pre-employment background 
                        screening company that is based out of Illinois, offering services nationwide, which also includes nationwide drug 
                        testing. Using state-of-the-market technology and 10 years of experience, we accomplish our mission by assisting 
                        employers to "HIRE RIGHT THE FIRST TIME" . The primary goal of Identi-Check's 
                        professional staff is to assist employers in hiring qualified people in a timely manner.<br /><br />

                        <i>Welcome <strong>Illinois Farm Service Agency</strong>. <bR />We look forward to providing you with UCC filings and searches.</i><br /><br />
                        </r>
                    </td>
                </tr>
                <tr>
                
                    <td align="center">                     
                    <table border="0" align="left" cellpadding="5" cellspacing="0" 
                            style="width: 146px">
                        <tr>
                        <td align="center" valign="top">
                        <img src="images/everi.png" /><br>
                        </tr>
                        
                        </table><div style="width:100%; height:4px"></div>
                       <span style="font-size:10px"> Now offering E-Verify verifications free Registration and Searches ensuring that employees are legal U.S. Workers by confirming employment eligibility with data from U.S. Department of Homeland Security and Social Security Administration records to confirm employment eligibility.</span>
                    </td>
                    </tr>
                    </table>           	
                        <table width="580" cellpadding="0" cellspacing="0" border="0">
                            <tr valign="bottom">
                                <td width="368">
                                    <div id="mission-top">
                                        MISSION
                                    </div>
                                    <div id="mission-middle">
                                        Identi-Check, Inc. specializes in background and drug screening and it is our mission to help businesses 
                                        with their hiring needs by providing them with valuable information on their potential employees. 
                                        Identi-Check, Inc. wants to improve businesses&rsquo; good hiring practices by helping them find the best qualified 
                                  people for the positions being filled and in return decrease employee turnover. (<a href="about.asp">More</a>) </div>
                                    <div id="mission-bottom">&nbsp;</div>
                                </td>
                                <td width="206">
								<% if msg <> "" then
									response.write "<center><span style='color:#eb2727;font-weight:bold;'>" & msg & "</span></center><br />"
                                end if %>
                                    <div id="login-top">
                                        MEMBER LOG IN
                                    </div>
                                    <div id="login-middle">
                                    	<form name="logon" action="<%=sNewURL%>" method="post">
                                        	USER: <input id="UserID" name="UserID" type="text" value="<%=UserID%>" size="10" style="background:#eb2727" /><br />
                                            PASSWORD: <input name="Password" type="password" size="10" style="background:#eb2727" /><br />
                                            <input id="submit1" name="Send" type="submit" value="SUBMIT" style="border-color: #eb2727; border-style:groove; font-size:10px" />
                                            <input id="reset1" name="reset1" type="reset" value="RESET" style="border-color: #eb2727; border-style:groove; font-size:10px" />
                                        </form>
                                    </div>
                                    <div id="login-bottom">&nbsp;</div>
                                </td>
                            </tr>
                            <tr valign="top">
                                <td>
                                  <div id="stats-top">&nbsp;</div>
                                    <div id="stats-middle">
                                        <ul class="tab-list">
                                            <li>Over 52% of job applications and resumes are falsified or exaggerated.</li>
                                            <li>The average settlement in negligent hiring and retention cases is now over 1.6 million dollars.</li>
                                            <li>Employers are being held liable for employee misconduct, whether or not the misconduct occurs inside the scope or place of employment.</li>
                                            <li>Homicide is the second leading cause of fatal occupational injury in the United States, each year nearly 
                                                1,000 workers are murdered and 1.5 million are victims of violence in the workplace.</li>
                                        </ul>
                                    </div>
                                    <div id="stats-bottom">INDUSTRY STATISTICS</div>
                                </td>
                                <td>
                                    <div id="credit-top">&nbsp;</div>
                                    <div id="credit-middle"><a href="https://www.creditcommander.com/identicheck" target="_blank"><img src="images/credit.png" /></a></div>
                                    <div id="credit-bottom">&nbsp;</div>
                                </td> 
                            </tr>
                            <tr><td><br /><br /></td></tr>
                        </table>
                        <table align="left"
                        <tr>
                        <td>
                        
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
