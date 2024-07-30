<%@ Page Language="VB" AutoEventWireup="false" CodeFile="EnterUCC.aspx.vb" Inherits="EnterUCC" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>Loading Account Setup</title>
		<meta name="GENERATOR" content="Microsoft Visual Studio.NET 7.0">
		<meta name="CODE_LANGUAGE" content="Visual Basic 7.0">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
	</HEAD>
	<body MS_POSITIONING="GridLayout" onload="document.myform.submit()">
		<form id="Form1" method="post" action="/UCC/login.aspx" name="myform">
			<INPUT type="hidden" id="hidGUIDA" name="hidGUIDA" runat="server"><INPUT type="hidden" id="hidGUIDB" name="hidGUIDB" runat="server"><INPUT type="hidden" id="RID" name="RID" runat="server">
		</form>
	</body>
</HTML>