<!-- #include virtual="CCookies.fun" -->
<%Response.Buffer = True %>
<% session("validuser")=False %>
<%UserID=request.cookies("UserID")%>
<HTML>
<title>Bank of Springfield : : : Log In</title>
<HEAD>
<link href="bos.css" rel="stylesheet" type="text/css">
<META NAME="GENERATOR" Content="Microsoft Visual Studio 6.0">
<meta name="Microsoft Border" content="t, default">
</HEAD>
<BODY><!--msnavigation--><table border="0" cellpadding="0" cellspacing="0" width="100%"><tr><td>

<p align="center"><font size="6"><strong></strong></font><br>
</p>
<p align="center">&nbsp;</p>

</td></tr><!--msnavigation--></table><!--msnavigation--><table border="0" cellpadding="0" cellspacing="0" width="100%"><tr><!--msnavigation--><td valign="top">
<P align=center>&nbsp;</P>


<table border="2" width="65%" height="306" bordercolordark="#6699cc" bordercolorlight="#6699ff" bgColor="#6699cc" align=center style="HEIGHT: 314px; WIDTH: 494px">
<tbody>
  <tr>
    <td width="22%" align="middle" height="300">
    
    <TABLE border=0 cellPadding=0 cellSpacing=0 
vspace="0" style="HEIGHT: 150px; WIDTH: 441px" dwcopytype="CopyTableColumn">
  
  <TR>
    <TD colSpan=2 height=95 align=center>
				<OBJECT classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"   codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=5,0,0,0"  WIDTH=300 HEIGHT=80 id=ShockwaveFlash1>
 					<PARAM NAME=movie VALUE="smbanner.swf"> <PARAM NAME=loop VALUE=false> <PARAM NAME=menu VALUE=false> <PARAM NAME=quality VALUE=best> <PARAM NAME=bgcolor VALUE=#FFFFFF> 
 					<EMBED src="smbanner.swf" loop=false menu=false quality=best bgcolor=#FFFFFF  WIDTH=300 HEIGHT=80 TYPE="application/x-shockwave-flash" PLUGINSPAGE="http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash"></EMBED>
					</OBJECT></TD></TR>

  <TR>
    <TD width="18%">
         
            <DIV align=center>
            <HR style="HEIGHT: 2px; WIDTH: 455px">
            </DIV>
            <P align=center> 
			<b>Access Denied! <br>UserID and Password are required to login or your session may be expired.<br>Please <a href="login.asp" class="note">re-login</a></font> again</font>
</td></tr><!--msnavigation--></table></BODY>
</HTML>
