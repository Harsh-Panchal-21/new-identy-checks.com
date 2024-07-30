<% 
Option Explicit
Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cache"
'Response.AddHeader "cache-control", "private"
Response.Expires = -1 

if session("validuser") <> True then
	Response.Redirect "default.asp?msg=Not a valid userid"
end if
%>
<!--#include file="lib.Data.asp"-->
<!--#include virtual="db_constants.fun" -->
<!--#include virtual="DB.fun" -->
<!--#include virtual="functions.inc" -->
<!--#include virtual="rc4.inc"-->
<%
dim msg, userid,name,company,fcra,company_rid, enc_pass
msg=Request("msg")
userid = Session("UserID")
name = trim(Session("name"))
company = Session("company")
company_rid = Session("company_rid")
fcra  = request.querystring("fcra")

if request.form("btnChange") = "Change Password" then
  Dim Pass1, Pass2, SQL, rs, sWhereToGo
  sWhereToGo = ""
  dim DB : set DB = new Database_Class
  DB.Initialize db_conn
  Pass1 = request.Form("txtPassword1")
  Pass2 = request.Form("txtPassword2")
  if Pass1 <> Pass2 then
    msg = "<br />Passwords do not match."
  else
    if ComplexPassword(Pass1,userid,name) then
      'Passwords match and meet requirements
      'msg = "GOOD"
      session("pass") = Pass1
      enc_pass = EnDeCrypt(Pass1,enc_pass_string)
      'msg = enc_pass & "<br />" & enc_pass_string & "<br />" & EnDeCrypt("See123",enc_pass_string)

      'check for using old password
      Set rs = DB.Query("Select Password,PasswordOld1,PasswordOld2,PasswordOld3,PasswordOld4 From Users Where UserID = ?",Array(userid))
      if not rs.EOF then
        Dim sOldPass, sOldPass1, sOldPass2, sOldPass3, sOldPass4 
        sOldPass = rs("Password")
        sOldPass1 = rs("PasswordOld1") & ""
        sOldPass2 = rs("PasswordOld2") & ""
        sOldPass3 = rs("PasswordOld3") & ""
        sOldPass4 = rs("PasswordOld4") & ""
        If enc_pass = sOldPass Or enc_pass = sOldPass1 Or enc_pass = sOldPass2 Or enc_pass = sOldPass3 Or enc_pass = sOldPass4 Then
          msg = "<br />Your password can not be any of your previous 5 passwords."
        Else
          Call DB.Execute("Update Users set Password=?, EncryptedPassword='Y', PasswordDate = GETDATE() + 60, PasswordOld1=Password, PasswordOld2=PasswordOld1, PasswordOld3=PasswordOld2, PasswordOld4=PasswordOld3 Where UserID = ?",Array(enc_pass,userid))
          if fcra = "N" then 
            sWhereToGo =  "Accept_FCRA.asp"
          elseif session("admin") = 2 then
  		      sWhereToGo =  "admin.asp?company_id=" & company_rid
          elseif Session("ucc_app") = "Y" then
            sWhereToGo =  "enter_ucc.asp"
          else
            'sWhereToGo =  "main.asp?company_id=" & company_rid
            if session("multi_com") = "yes" then
              sWhereToGo = "main_companies.asp"
            else
				      sWhereToGo = "main.asp?company_id=" & company_rid
            end if
          end if
        End If
      else
        'error cannot proceed
        msg = "Unknown error"
      end if
      set rs = nothing

      if sWhereToGo <> "" then response.Redirect sWhereToGo
    else
      msg = "<br />Password does not meet the requirements."
    end if
  end if
  set DB = nothing
else
  'enc_pass = EnDeCrypt("See123",enc_pass_string)
  'Response.Write enc_pass & "<br />" & enc_pass_string & "<br />" & EnDeCrypt("See123",enc_pass_string)
end if

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<!--#include file="head.asp" -->

<center>
<!-- *************************************** MAIN CONTENT AREA *************************************** -->
 <table width="900px" cellpadding="0" cellspacing="0" border="0">
					
    <tr>
        <td width="610px" valign="top" align="center">
            <table width="590px" cellpadding="0" cellspacing="0" border="0">
            	<tr>
                	<td align="center">
                    <center>
                        Welcome: <%=name%><br />
                        <%=now%>
                        <hr /></center>

              <h4 align="left">Required Password Change</h4>
              <span style="font-size: 10pt;">Due to FCRA regulations, we are requiring you to change your password every 60 days.</span><br />
              <span style="font-size: 10pt;">Password must be a minimum of six (6) characters and a maximum of twenty (20) characters.<br />
                They must contain upper and lower case letters and at least one (1) number.</span>
              <form name="form1" action="Change_Pass.asp?fcra=<%=request.querystring("fcra")%>" method="post" onsubmit="return CheckPassword(document.form1.txtPassword1, document.form1.txtPassword2, 'spanAlert');">
                 <table>
                   <tr>
                     <td align="right">New Password</td>
                     <td><input type="password" name="txtPassword1" id="txtPassword1" />
                       <span id="spanAlert" style="color: red; font-size: 10pt;"><%=msg %></span>
                     </td>
                   </tr>
                   <tr>
                     <td align="right">Confirm Password</td>
                     <td><input type="password" name="txtPassword2" id="txtPassword2" /></td>
                   </tr>
                   <tr>
                     <td colspan="2" align="right">
                       <input type="submit" name="btnChange" id="btnChange" value="Change Password" />
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
<script src="/scripts/check-password.js"></script>
</body>
</html>