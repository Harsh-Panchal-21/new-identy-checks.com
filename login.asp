<!--#include virtual="db_constants.fun" -->
<%
Dim sScriptName, sServerName, sNewURL, sNewScript
Dim iPosA, UserID
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
<!--#include file="head19.asp" -->


<!-- *************************************** MAIN CONTENT AREA *************************************** -->
<div class="w3-container w3-padding" align="center">
	<h2><strong>Member Log-in</strong></h2><br /><br />
	<table width="100%" cellpadding="0" cellspacing="0" border="0">
                            <tr valign="bottom">
                               
                                <td width="100%">
								
                                    <div id="login-middle">
                                    	<form name="logon" action="<%=sNewURL%>" method="post">
                                        <table cellpadding="0" align="center">
                                        <tr>
                                            <td align="center">
                                        	<span style="font-family:Oxygen;">USERNAME:</span>
                                            </td>
                                            <td align="center">
                                            <input id="UserID" name="UserID" type="text" value="<%=UserID%>" size="20" style="background:#ffffff" />
                                            </td>
                                        </tr>    
                                        <tr>
                                            <td align="center">
                                            <span style="font-family:Oxygen;">PASSWORD:</span>
                                            </td>
                                            <td align="center">
                                            <input name="Password" type="password" size="20" style="background:#ffffff" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" align="center">
                                             <% if msg <> "" then
									response.write "<span style='color:#eb2727;font-weight:bold; font-size:14px;'>" & msg & "</span><br />"
                                end if %>
                                            <!--</td>
                                            <td align="center">-->
                                            <input id="submit1" name="Send" type="submit" value="SUBMIT" style="border-color: #eb2727; border-style:groove; font-size:10px; font-family:Oxygen;" />
                                            <input id="reset1" name="reset1" type="reset" value="RESET" style="border-color: #eb2727; border-style:groove; font-size:10px; font-family:Oxygen;" />
                                            </td>
                                        </tr>
                                        </table>
                                        </form>
                                    </div>
                                    <div id="login-bottom"></div>
                                </td>
                            </tr>
                            
</table>
	<br /><br />
	<h2>Online Sign Up Instructions</h2>
	<p>Becoming a registered user is a simple process.<br />
	Complete the Subscriber Application.  All required fields must be completed<br />or your application will not be processed.<br /><br />
	<a href="/subscriber.asp">Click Here for Application</a><br /><br />
		<a href="pdf/subscriber_agreement.pdf">Click Here for Subsriber Agreement</a><br /><br />
	If you have any questions about the registration process, please contact us at<br />
	<a href="tel:2177534311">217-753-4311<a/> or visit our <a href="pdf/FAQ.pdf">FAQ page.</a></p>
</div>	
<!-- ************************************* END MAIN CONTENT AREA ************************************* -->

    
<!--#include file="footNew.asp" -->

</body>
</html>
