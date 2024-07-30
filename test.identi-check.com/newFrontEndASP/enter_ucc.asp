<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>Enter UCC</title>
		<meta name="GENERATOR" content="Microsoft Visual Studio.NET 7.0">
		<meta name="CODE_LANGUAGE" content="Visual Basic 7.0">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
	</HEAD>
	<body onload="document.myform.submit()">
		<form id="Form1" method="post" action="/ucc/login.aspx" name="myform">
			<INPUT type="hidden" id="name" name="name" value="<%=Session("UserID")%>"> 
			<INPUT type="hidden" id="pass" name="pass" value="<%=session("pass")%>">
		</form>
	</body>
</HTML>
