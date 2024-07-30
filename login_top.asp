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
<!-- *************************************** MAIN CONTENT AREA *************************************** -->
           	
                        <table width="100%" cellpadding="0" cellspacing="0" border="0">
                            <tr valign="bottom">
                               
                                <td width="100%">
								
                                    <div id="login-middle">
                                    	<form name="logon" action="<%=sNewURL%>" method="post">
                                        <table cellpadding="0" align="right">
                                        <tr>
                                            <td align="right">
                                        	<span style="font-family:Oxygen; color:White">USERNAME:</span>
                                            </td>
                                            <td align="left">
                                            <input id="UserID" name="UserID" type="text" value="<%=UserID%>" size="20" style="background:#ffffff" />
                                            </td>
                                        </tr>    
                                        <tr>
                                            <td align="right">
                                            <span style="font-family:Oxygen; color:White">PASSWORD:</span>
                                            </td>
                                            <td align="left">
                                            <input name="Password" type="password" size="20" style="background:#ffffff" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" align="right">
                                             <% if msg <> "" then
									response.write "<span style='color:#eb2727;font-weight:bold; font-size:14px;'>" & msg & "</span>"
                                end if %>
                                            <!--</td>
                                            <td align="right">-->
                                            <input id="submit1" name="Send" type="submit" value="SUBMIT" style="border-color: #eb2727; border-style:groove; font-size:10px; font-family:Oxygen;" />
                                            <input id="reset1" name="reset1" type="reset" value="RESET" style="border-color: #eb2727; border-style:groove; font-size:10px; font-family:Oxygen;" />
                                            </td>
                                        </tr>
                                        </table>
                                        </form>
                                    </div>
                                    <div id="login-bottom">&nbsp;</div>
                                </td>
                            </tr>
                            
</table>
<!-- ************************************* END MAIN CONTENT AREA ************************************* -->



</body>
</html>
