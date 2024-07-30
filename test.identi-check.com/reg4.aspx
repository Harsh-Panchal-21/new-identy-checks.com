<%@ Page Language="VB" ContentType="text/html" ResponseEncoding="utf-8" %>
<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include virtual="checkhack.asp" -->
<%
Dim conn, sql, sql2, rs1, rs2
Set conn = Server.CreateObject("ADODB.Connection")
conn.open Application("DBConnection")

'if Session("userid") = "" then
'	response.redirect "index.asp"
'end if

If request.form("next") <> "" then

end if
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!--#Include virtual="head.asp"-->

</head>

<body class="body_black">
<!--#Include virtual="top_black.asp"-->
<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
  <tr height="43">
    <td width="43" background="images/box_orange_upleft.gif"></td>
    <td background="images/box_orange_top.gif"></td>
    <td width="43" background="images/box_orange_upright.gif"></td>
  </tr>
  <tr bgcolor="#F78F1E">
    <td width="43" background="images/box_orange_left.gif"></td>
    <td><p><font size="4">User Registration<strong> </strong></font></p>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-bottom:20px;">
        <tr>
          <td height="2" background="images/dash.gif"></td>
        </tr>
      </table>
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td width="7" height="7" background="images/box_wht_upleft.gif"></td>
          <td bgcolor="#FFFFFF"></td>
          <td width="7" background="images/box_wht_upright.gif"></td>
        </tr>
        <tr>
          <td bgcolor="#FFFFFF"></td>
          <td bgcolor="#FFFFFF"><div class="textblack">
            <h3>Your Information</h3>
            <p>Please complete the following.</p>
            <form id="reg4" action="reg4.asp" method="post">
              How old are you?
              <label>
              <label>
                <input type="radio" name="age" value="12" />
                12 or Under</label>
              &nbsp;&nbsp;&nbsp;
              <label>
                <input type="radio" name="age" value="13" />
                13 or Over</label>
              <br />
              <br />
              Enter your parent's email address (if 12 or under): 
              <input type="text" name="pemail" id="pemail" />
              <br />
              <br />
              Enter your email address (if 13 or over): 
              <input type="text" name="pemail" id="pemail" />
              <br />
              <br />
              <input type="submit" name="next" id="next" value="Next >>" />
              <p></p>
            </form>
          </div></td>
          <td bgcolor="#FFFFFF"></td>
        </tr>
        <tr>
          <td height="7" background="images/box_wht_botleft.gif"></td>
          <td bgcolor="#FFFFFF"></td>
          <td height="7" background="images/box_wht_botright.gif"></td>
        </tr>
      </table></td>
    <td width="43" background="images/box_orange_right.gif"></td>
  </tr>
  <tr height="43">
    <td width="43" background="images/box_orange_botleft.gif"></td>
    <td background="images/box_orange_bot.gif"></td>
    <td width="43" background="images/box_orange_botright.gif"></td>
  </tr>
</table>
<!--#Include virtual="bottom_black.asp"-->
<!--#Include virtual="footer.asp"-->
</body>
</html>