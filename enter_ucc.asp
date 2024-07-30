<% 
Option Explicit
Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cache"
'Response.AddHeader "cache-control", "private"
Response.Expires = -1 
%>
<!--#include file="lib.Data.asp"-->
<!--#include virtual="db_constants.fun" -->
<!--#include virtual="functions.inc" -->
<%
dim DB : set DB = new Database_Class
DB.Initialize db_conn
Dim sGuid : sGuid = CreateGuid()
Call DB.Execute("Update Users set AppTransGuid = ? Where UserID = ?",Array(sGuid,Session("UserID")))
  'onload="document.myform.submit()"
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>Enter UCC</title>
	</HEAD>
	<body onload="document.myform.submit()">
		<form id="Form1" method="post" action="/ucc/login.aspx" name="myform">
			<INPUT type="hidden" id="name" name="name" value="<%=Session("UserID")%>"> 
      <INPUT type="hidden" id="guidpass" name="guidpass" value="<%=sGuid%>">
			<INPUT type="hidden" id="pass" name="pass" value="<%=session("pass1")%>">
		</form>
	</body>
</HTML>
