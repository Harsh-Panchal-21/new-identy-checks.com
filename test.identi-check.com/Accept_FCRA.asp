<% 
Option Explicit
Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cache"
'Response.AddHeader "cache-control", "private"
Response.Expires = -1 
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
name = Session("name")
company = Session("company")
company_rid = Session("company_rid")
fcra  = request.querystring("fcra")
'response.Write "Enc_Pass: " & Session("enc_pass")

if request.form("btnAccept") = "Accept" then
  Dim chkMain, SQL, rs
  dim DB : set DB = new Database_Class
  DB.Initialize db_conn
  chkMain = request.Form("chkMain")
  if chkMain ="YES" then
    Call DB.Execute("Update Users set AcceptFCRA='Y', AcceptFCRATime=GETDATE() Where UserID = ?",Array(userid))
    if session("admin") = 2 then
  		response.Redirect "admin.asp?company_id=" & company_rid
    elseif Session("ucc_app") = "Y" then
      response.redirect "enter_ucc.asp"
    else
      'response.Redirect "main.asp?company_id=" & company_rid
      if session("multi_com") = "yes" then
        Response.Redirect "main_companies.asp"
      else
			  Response.Redirect "main.asp?company_id=" & company_rid
      end if
    end if
  else
    msg = "You must check the checkbox."
  end if
  set DB = nothing
end if

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;
	mso-font-charset:0;
	mso-generic-font-family:swiss;
	mso-font-pitch:variable;
	mso-font-signature:-536870145 1073786111 1 0 415 0;}
@font-face
	{font-family:"Tahoma\,Bold";
	panose-1:0 0 0 0 0 0 0 0 0 0;
	mso-font-charset:0;
	mso-generic-font-family:swiss;
	mso-font-format:other;
	mso-font-pitch:auto;
	mso-font-signature:3 0 0 0 1 0;}
@font-face
	{font-family:Tahoma;
	panose-1:2 11 6 4 3 5 4 4 2 4;
	mso-font-charset:0;
	mso-generic-font-family:swiss;
	mso-font-pitch:variable;
	mso-font-signature:-520081665 -1073717157 41 0 66047 0;}
@font-face
	{font-family:SymbolOOEnc;
	panose-1:0 0 0 0 0 0 0 0 0 0;
	mso-font-alt:"Arial Unicode MS";
	mso-font-charset:136;
	mso-generic-font-family:auto;
	mso-font-format:other;
	mso-font-pitch:auto;
	mso-font-signature:1 134742016 16 0 1048576 0;}
@font-face
	{font-family:"\@SymbolOOEnc";
	panose-1:0 0 0 0 0 0 0 0 0 0;
	mso-font-charset:136;
	mso-generic-font-family:auto;
	mso-font-format:other;
	mso-font-pitch:auto;
	mso-font-signature:1 134742016 16 0 1048576 0;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{mso-style-unhide:no;
	mso-style-qformat:yes;
	mso-style-parent:"";
	margin-top:0in;
	margin-right:0in;
	margin-bottom:8.0pt;
	margin-left:0in;
	line-height:107%;
	mso-pagination:widow-orphan;
	font-size:11.0pt;
	font-family:"Calibri",sans-serif;
  color: "black";
	mso-ascii-font-family:Calibri;
	mso-ascii-theme-font:minor-latin;
	mso-fareast-font-family:Calibri;
	mso-fareast-theme-font:minor-latin;
	mso-hansi-font-family:Calibri;
	mso-hansi-theme-font:minor-latin;
	mso-bidi-font-family:"Times New Roman";
	mso-bidi-theme-font:minor-bidi;}
p.MsoHeader, li.MsoHeader, div.MsoHeader
	{mso-style-priority:99;
	mso-style-link:"Header Char";
	margin:0in;
	margin-bottom:.0001pt;
	mso-pagination:widow-orphan;
	tab-stops:center 3.25in right 6.5in;
	font-size:11.0pt;
	font-family:"Calibri",sans-serif;
	mso-ascii-font-family:Calibri;
	mso-ascii-theme-font:minor-latin;
	mso-fareast-font-family:Calibri;
	mso-fareast-theme-font:minor-latin;
	mso-hansi-font-family:Calibri;
	mso-hansi-theme-font:minor-latin;
	mso-bidi-font-family:"Times New Roman";
	mso-bidi-theme-font:minor-bidi;}
p.MsoFooter, li.MsoFooter, div.MsoFooter
	{mso-style-priority:99;
	mso-style-link:"Footer Char";
	margin:0in;
	margin-bottom:.0001pt;
	mso-pagination:widow-orphan;
	tab-stops:center 3.25in right 6.5in;
	font-size:11.0pt;
	font-family:"Calibri",sans-serif;
	mso-ascii-font-family:Calibri;
	mso-ascii-theme-font:minor-latin;
	mso-fareast-font-family:Calibri;
	mso-fareast-theme-font:minor-latin;
	mso-hansi-font-family:Calibri;
	mso-hansi-theme-font:minor-latin;
	mso-bidi-font-family:"Times New Roman";
	mso-bidi-theme-font:minor-bidi;}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:#0563C1;
	mso-themecolor:hyperlink;
	text-decoration:underline;
	text-underline:single;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-noshow:yes;
	mso-style-priority:99;
	color:#954F72;
	mso-themecolor:followedhyperlink;
	text-decoration:underline;
	text-underline:single;}
p.Default, li.Default, div.Default
	{mso-style-name:Default;
	mso-style-unhide:no;
	mso-style-parent:"";
	margin:0in;
	margin-bottom:.0001pt;
	mso-pagination:widow-orphan;
	mso-layout-grid-align:none;
	text-autospace:none;
	font-size:12.0pt;
	font-family:"Times New Roman",serif;
	mso-fareast-font-family:Calibri;
	mso-fareast-theme-font:minor-latin;
	color:black;}
span.HeaderChar
	{mso-style-name:"Header Char";
	mso-style-priority:99;
	mso-style-unhide:no;
	mso-style-locked:yes;
	mso-style-link:Header;}
span.FooterChar
	{mso-style-name:"Footer Char";
	mso-style-priority:99;
	mso-style-unhide:no;
	mso-style-locked:yes;
	mso-style-link:Footer;}
.MsoChpDefault
	{mso-style-type:export-only;
	mso-default-props:yes;
	font-family:"Calibri",sans-serif;
	mso-ascii-font-family:Calibri;
	mso-ascii-theme-font:minor-latin;
	mso-fareast-font-family:Calibri;
	mso-fareast-theme-font:minor-latin;
	mso-hansi-font-family:Calibri;
	mso-hansi-theme-font:minor-latin;
	mso-bidi-font-family:"Times New Roman";
	mso-bidi-theme-font:minor-bidi;}
.MsoPapDefault
	{mso-style-type:export-only;
	margin-bottom:8.0pt;
	line-height:107%;}
 /* Page Definitions */
 @page
	{mso-footnote-separator:url("end%20user%20certification_files/header.htm") fs;
	mso-footnote-continuation-separator:url("end%20user%20certification_files/header.htm") fcs;
	mso-endnote-separator:url("end%20user%20certification_files/header.htm") es;
	mso-endnote-continuation-separator:url("end%20user%20certification_files/header.htm") ecs;}
@page WordSection1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;
	mso-header-margin:.5in;
	mso-footer-margin:.5in;
	mso-footer:url("end%20user%20certification_files/header.htm") f1;
	mso-paper-source:0;}
div.WordSection1
	{page:WordSection1;}
-->
</style>
<!--[if gte mso 10]>
<style>
 /* Style Definitions */
 table.MsoNormalTable
	{mso-style-name:"Table Normal";
	mso-tstyle-rowband-size:0;
	mso-tstyle-colband-size:0;
	mso-style-noshow:yes;
	mso-style-priority:99;
	mso-style-parent:"";
	mso-padding-alt:0in 5.4pt 0in 5.4pt;
	mso-para-margin-top:0in;
	mso-para-margin-right:0in;
	mso-para-margin-bottom:8.0pt;
	mso-para-margin-left:0in;
	line-height:107%;
	mso-pagination:widow-orphan;
	font-size:11.0pt;
	font-family:"Calibri",sans-serif;
	mso-ascii-font-family:Calibri;
	mso-ascii-theme-font:minor-latin;
	mso-hansi-font-family:Calibri;
	mso-hansi-theme-font:minor-latin;}
</style>
<![endif]-->
<!--#include file="head.asp" -->

<center>
<!-- *************************************** MAIN CONTENT AREA *************************************** -->
 <table width="900px" cellpadding="0" cellspacing="0" border="0">
					
    <tr>
        <td width="610px" valign="top" align="center">
            <table width="590px" cellpadding="0" cellspacing="0" border="0">
            	<tr>
                	<td>
                    <center>
                        Welcome: <%=name%><br />
                        <%=now%>
                        <hr /></center>

                    <div class=WordSection1>

<p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
text-align:center;line-height:normal;mso-layout-grid-align:none;text-autospace:
none'><b><u><span style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;
mso-bidi-font-family:"Tahoma\,Bold";color:black'>END USER CERTIFICATION<o:p></o:p></span></u></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'><o:p>&nbsp;</o:p></span></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'>In compliance with the Fair Credit Reporting Act
(&#8220;FCRA&#8221;) End User hereby certifies to Identi-Check, Inc.
(&#8220;Identi-Check&#8221;) that it understands and will comply with End
User&#8217;s obligations, under the FCRA, as set forth below:<o:p></o:p></span></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'><o:p>&nbsp;</o:p></span></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'>End Users of consumer reports must comply with all
applicable regulations. Information about applicable regulations currently in
effect can be found at the Consumer Financial Protection Bureau&#8217;s website,
</span></b><a href="http://www.consumerfinance.gov/learnmore"><b><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold"'>www.consumerfinance.gov/learnmore</span></b></a><b><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'>.<o:p></o:p></span></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'><o:p>&nbsp;</o:p></span></b></p>

<p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
text-align:center;line-height:normal;mso-layout-grid-align:none;text-autospace:
none'><b><span style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;
mso-bidi-font-family:"Tahoma\,Bold";color:black'>NOTICE TO USERS OF CONSUMER
REPORTS:<o:p></o:p></span></b></p>

<p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
text-align:center;line-height:normal;mso-layout-grid-align:none;text-autospace:
none'><b><span style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;
mso-bidi-font-family:"Tahoma\,Bold";color:black'>OBLIGATIONS OF USERS UNDER THE
FCRA<o:p></o:p></span></b></p>

<p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
text-align:center;line-height:normal;mso-layout-grid-align:none;text-autospace:
none'><b><span style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;
mso-bidi-font-family:"Tahoma\,Bold";color:black'><o:p>&nbsp;</o:p></span></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>The Fair Credit Reporting
Act (FCRA), 15 U.S.C. 1681-1681y, requires that this notice be provided to
inform users of consumer reports of their legal obligations. State law may
impose additional requirements. The text of the FCRA is set forth in full at
the Consumer Financial Protection Bureau&#8217;s (CFPB) website at </span><span
style='font-size:9.0pt;font-family:"Tahoma",sans-serif;color:blue'>www.consumerfinance.gov/learnmore</span><span
style='font-size:9.0pt;font-family:"Tahoma",sans-serif;color:black'>. At the
end of this document is a list of United States Code citations for the FCRA.
Other information about user duties is also available at the CFPB&#8217;s
website. </span><b><span style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;
mso-bidi-font-family:"Tahoma\,Bold";color:black'>Users must consult the relevant
provisions of the FCRA for details about their obligations under the FCRA.<o:p></o:p></span></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'><o:p>&nbsp;</o:p></span></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>The first section of this
summary sets forth the responsibilities imposed by the FCRA on all users of
consumer reports. The subsequent sections discuss the duties of users of
reports that contain specific types of information, or that are used for
certain purposes, and the legal consequences of violations. If you are a
furnisher of information to a consumer reporting agency (CRA), you have
additional obligations and will receive a separate notice from the CRA describing
your duties as a furnisher.<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'>I. OBLIGATIONS OF ALL USERS OF CONSUMER REPORTS<o:p></o:p></span></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'><o:p>&nbsp;</o:p></span></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><u><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'>A. Users Must Have a Permissible Purpose<o:p></o:p></span></u></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><u><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'><o:p><span style='text-decoration:none'>&nbsp;</span></o:p></span></u></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>Congress has limited the use
of consumer reports to protect consumers&#8217; privacy. All users must have a
permissible purpose under the FCRA to obtain a consumer report. Section 604
contains a list of the permissible purposes under the law. These are:<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>&#8226; As ordered by a
court or a federal grand jury subpoena. Section 604(a)(1)<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>&#8226; As instructed by the
consumer in writing. Section 604(a)(2)<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>&#8226; For the extension of
credit as a result of an application from a consumer, or the review or
collection of a consumer&#8217;s account. Section 604(a)(3)(A)<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>&#8226; For employment
purposes, including hiring and promotion decisions, where the consumer has given
written permission. Sections 604(a)(3)(B) and 604(b)<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>&#8226; For the underwriting
of insurance as a result of an application from a consumer. Section
604(a)(3)(C)<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>&#8226; When there is a
legitimate business need, in connection with a business transaction that is initiated
by the consumer. Section 604(a)(3)(F)(i)<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>&#8226; To review a
consumer&#8217;s account to determine whether the consumer continues to meet
the terms of the account. Section 604(a)(3)(F)(ii)<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>&#8226; To determine a
consumer&#8217;s eligibility for a license or other benefit granted by a
governmental instrumentality required by law to consider an applicant&#8217;s
financial responsibility or status. Section 604(a)(3)(D)<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>&#8226; For use by a
potential investor or servicer, or current insurer, in a valuation or
assessment of the credit or prepayment risks associated with an existing credit
obligation. Section 604(a)(3)(E)<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>&#8226; For use by state and
local officials in connection with the determination of child support payments,
or modifications and enforcement thereof. Sections 604(a)(4) and 604(a)(5)<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>In addition, creditors and
insurers may obtain certain consumer report information for the purpose of
making &#8220;prescreened&#8221; unsolicited offers of credit or insurance.
Section 604(c). The particular obligations of users of &#8220;prescreened&#8221;
information are described in Section VII below.<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><u><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'>B. Users Must Provide Certifications<o:p></o:p></span></u></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'><o:p>&nbsp;</o:p></span></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>Section 604(f) prohibits any
person from obtaining a consumer report from a consumer reporting agency (CRA) unless
the person has certified to the CRA the permissible purpose(s) for which the
report is being obtained and certifies that the report will not be used for any
other purpose.<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal><b><u><span style='font-size:9.0pt;line-height:107%;
font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:"Tahoma\,Bold";
color:black'>C. Users Must Notify Consumers When Adverse Actions Are Taken<o:p></o:p></span></u></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>The term &#8220;adverse action&#8221; is
defined very broadly by Section 603. &#8220;Adverse actions&#8221; include all
business, credit, and employment actions affecting consumers that can be
considered to have a negative impact as defined by Section 603(k) of the FCRA
&#8211; such as denying or canceling credit or insurance, or denying employment
or promotion. No adverse action occurs in a credit transaction where the
creditor makes a counteroffer that is accepted by the consumer.<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'>1. Adverse Actions Based on Information Obtained From a CRA<o:p></o:p></span></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'><o:p>&nbsp;</o:p></span></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>If a user takes any type of adverse
action as defined by the FCRA that is based at least in part on information contained
in a consumer report, Section 615(a) requires the user to notify the consumer.
The notification may be done in writing, orally, or by electronic means. It
must include the following:<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>&#8226; The name, address, and telephone
number of the CRA (including a toll-free telephone number, if it is a nationwide
CRA) that provided the report.<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>&#8226; A statement that the CRA did not
make the adverse decision and is not able to explain why the decision was made.<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>&#8226; A statement setting forth the
consumer&#8217;s right to obtain a free disclosure of the consumer&#8217;s file
from the CRA if the consumer makes a request within 60 days.<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>&#8226; A statement setting forth the
consumer&#8217;s right to dispute directly with the CRA the accuracy or completeness
of any information provided by the CRA.<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'>2. Adverse Actions Based on Information Obtained From Third
Parties Who Are Not Consumer<o:p></o:p></span></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'>Reporting Agencies<o:p></o:p></span></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'><o:p>&nbsp;</o:p></span></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>If a person denies (or increases the
charge for) credit for personal, family, or household purposes based either wholly
or partly upon information from a person other than a CRA, and the information
is the type of consumer information covered by the FCRA, Section 615(b)(1)
requires that the user clearly and accurately disclose to the consumer his or
her right to be told the nature of the information that was relied upon if the
consumer makes a written request within 60 days of notification. The user must
provide the disclosure within a reasonable period of time following the
consumer&#8217;s written request.<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'>3. Adverse Actions Based on Information Obtained From
Affiliates<o:p></o:p></span></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'><o:p>&nbsp;</o:p></span></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>If a person takes an adverse action
involving insurance, employment, or a credit transaction initiated by the consumer,
based on information of the type covered by the FCRA, and this information was
obtained from an entity affiliated with the user of the information by common
ownership or control, Section 615(b)(2) requires the user to notify the
consumer of the adverse action. The notice must inform the consumer that he or
she may obtain a disclosure of the nature of the information relied upon by
making a written request within 60 days of receiving the adverse action notice.
If the consumer makes such a request, the user must disclose the nature of the
information not later than 30 days after receiving the request. If consumer
report information is shared among affiliates and then used for an adverse
action, the user must make an adverse action disclosure as set forth in I.C.1
above.<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'>D. Users Have Obligations When Fraud and Active Duty Military
Alerts are in Files<o:p></o:p></span></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'><o:p>&nbsp;</o:p></span></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>When a consumer has placed a fraud
alert, including one relating to identify theft, or an active duty military
alert with a nationwide consumer reporting agency as defined in Section 603(p)
and resellers, Section 605A(h) imposes limitations on users of reports obtained
from the consumer reporting agency in certain circumstances, including the establishment
of a new credit plan and the issuance of additional credit cards. For initial
fraud alerts and active duty alerts, the user must have reasonable policies and
procedures in place to form a belief that the user knows the identity of the
applicant or contact the consumer at a telephone number specified by the
consumer; in the case of extended fraud alerts, the user must contact the
consumer in accordance with the contact information provided in the
consumer&#8217;s alert.<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'>E. Users Have Obligations When Notified of an Address
Discrepancy<o:p></o:p></span></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'><o:p>&nbsp;</o:p></span></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>Section 605(h) requires nationwide CRAs,
as defined in Section 603(p), to notify users that request reports when the address
for a consumer provided by the user in requesting the report is substantially
different from the addresses in the consumer&#8217;s file. When this occurs,
users must comply with regulations specifying the procedures to be
followed.<span style='mso-spacerun:yes'>&nbsp; </span><span style='color:black'>Federal
regulations are available at <a href="http://www.consumerfinance.gov/learnmore">www.consumerfinance.gov/learnmore</a>.<o:p></o:p></span></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><u><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'>F. Users Have Obligations When Disposing of Records<o:p></o:p></span></u></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'><o:p>&nbsp;</o:p></span></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>Section 628 requires that
all users of consumer report information have in place procedures to properly
dispose of records containing this information. Federal regulations are
available at </span><a href="http://www.consumerfinance.gov/learnmore"><span
style='font-size:9.0pt;font-family:"Tahoma",sans-serif'>www.consumerfinance.gov/learnmore</span></a><span
style='font-size:9.0pt;font-family:"Tahoma",sans-serif;color:black'>.<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'>II. CREDITORS MUST MAKE ADDITIONAL DISCLOSURES<o:p></o:p></span></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'><o:p>&nbsp;</o:p></span></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>If a person uses a consumer
report in connection with an application for, or a grant, extension, or
provision of, credit to a consumer on material terms that are materially less
favorable than the most favorable terms available to a substantial proportion
of consumers from or through that person, based in whole or in part on a
consumer report, the person must provide a risk-based pricing notice to the
consumer in accordance with regulations prescribed by the CFPB. Section 609(g)
requires a disclosure by all persons that make or arrange loans secured by
residential real property (one to four units) and that use credit scores. These
persons must provide credit scores and other information about credit scores to
applicants, including the disclosure set forth in Section 609(g)(1)(D)
(&#8220;Notice to the Home Loan Applicant&#8221;).<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'>III. OBLIGATIONS OF USERS WHEN CONSUMER REPORTS ARE
OBTAINED FOR EMPLOYMENT PURPOSES<o:p></o:p></span></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'><o:p>&nbsp;</o:p></span></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><u><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'>A. Employment Other Than in the Trucking Industry<o:p></o:p></span></u></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'><o:p>&nbsp;</o:p></span></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>If the information from a
CRA is used for employment purposes, the user has specific duties, which are
set forth in Section 604(b) of the FCRA. The user must:<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>&#8226; Make a clear and conspicuous
written disclosure to the consumer before the report is obtained, in a document
that consists solely of the disclosure, that a consumer report may be obtained.<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>&#8226; Obtain from the
consumer prior written authorization. Authorization to access reports during
the term of employment may be obtained at the time of employment.<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>&#8226; Certify to the CRA
that the above steps have been followed, that the information being obtained
will not be used in violation of any federal or state equal opportunity law or
regulation, and that, if any adverse action is to be taken based on the
consumer report, a copy of the report and a summary of the consumer&#8217;s rights
will be provided to the consumer.<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:SymbolOOEnc;mso-hansi-font-family:Tahoma;mso-bidi-font-family:
SymbolOOEnc;color:black'>&#61623; </span><b><span style='font-size:9.0pt;
font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:"Tahoma\,Bold";
color:black'>Before </span></b><span style='font-size:9.0pt;font-family:"Tahoma",sans-serif;
color:black'>taking an adverse action, the user must provide a copy of the report
to the consumer as well as the summary of consumer&#8217;s rights (The user
should receive this summary from the CRA.) A Section 615(a) adverse action
notice should be sent after the adverse action is taken. An adverse action
notice also is required in employment situations if credit information (other
than transactions and experience data) obtained from an affiliate is used to
deny employment. Section 615(b)(2). The procedures for investigative consumer
reports and employee misconduct investigations are set forth below.<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><u><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'>B. Employment in the Trucking Industry<o:p></o:p></span></u></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'><o:p>&nbsp;</o:p></span></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>Special rules apply for
truck drivers where the only interaction between the consumer and the potential
employer is by mail, telephone, or computer. In this case, the consumer may
provide consent orally or electronically, and an adverse action may be made
orally, in writing, or electronically. The consumer may obtain a copy of any
report relied upon by the trucking company by contacting the company.<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'>IV. OBLIGATIONS WHEN INVESTIGATIVE CONSUMER REPORTS
ARE USED<o:p></o:p></span></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'><o:p>&nbsp;</o:p></span></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>Investigative consumer
reports are a special type of consumer report in which information about a
consumer&#8217;s character, general reputation, personal characteristics, and
mode of living is obtained through personal interviews by an entity or person
that is a consumer reporting agency. Consumers who are the subjects of such
reports are given special rights under the FCRA. If a user intends to obtain an
investigative consumer report, Section 606 requires the following:<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>&#8226; The user must disclose to the
consumer that an investigative consumer report may be obtained. This must be
done in a written disclosure that is mailed, or otherwise delivered, to the
consumer at some time before or not later than three days after the date on
which the report was first requested. The disclosure must include a statement
informing the consumer of his or her right to request additional disclosures of
the nature and scope of the investigation as described below, and the summary
of consumer rights required by Section 609 of the FCRA. (The summary of
consumer rights will be provided by the CRA that conducts the investigation.)<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>&#8226; The user must certify to the CRA
that the disclosures set forth above have been made and that the user will make
the disclosure described below.<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>&#8226; Upon the written request of a
consumer made within a reasonable period of time after the disclosures required
above, the user must make a complete disclosure of the nature and scope of the
investigation. This must be made in a written statement that is mailed or
otherwise delivered, to the consumer no later than five days after the date on
which the request was received from the consumer or the report was first requested,
whichever is later in time.<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'>V. SPECIAL PROCEDURES FOR EMPLOYMEE INVESTIGATIONS<o:p></o:p></span></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'><o:p>&nbsp;</o:p></span></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>Section 603(x) provides special
procedures for investigations of suspected misconduct by an employee or for compliance
with Federal, state or local laws and regulations or the rules of a
self-regulatory organization, and compliance with written policies of the employer.
These investigations are not treated as consumer reports so long as the
employer or its agent complies with the procedures set forth in Section 603(x),
and a summary describing the nature and scope of the inquiry is made to the
employee if an adverse action is taken based on the investigation.<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'>VI. OBLIGATIONS OF USERS OF MEDICAL INFORMATION<o:p></o:p></span></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'><o:p>&nbsp;</o:p></span></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>Section 604(g) limits the use of medical
information obtained from consumer reporting agencies (other than payment information
that appears in a coded form that does not identify the medical provider). If
the information is to be used for an insurance transaction, the consumer must
give consent to the user of the report or the information must be coded. If the
report is to be used for employment purposes &#8211; or in connection with a
credit transaction (except as provided in regulations) the consumer must
provide specific written consent and the medical information must be relevant.
Any user who receives medical information shall not disclose the information to
any other person (except where necessary to carry out the purpose for which the
information was disclosed, or a permitted by statute, regulation, or order).<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'>VII. OBLIGATIONS OF USERS OF &#8220;PRESCREENED&#8221; LISTS<o:p></o:p></span></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'><o:p>&nbsp;</o:p></span></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>The FCRA permits creditors and insurers
to obtain limited consumer report information for use in connection with unsolicited
offers of credit or insurance under certain circumstances. Sections 603(1),
604(c), 604(e), and 615(d). This practice is known as
&#8220;prescreening&#8221; and typically involves obtaining from a CRA a list
of consumers who meet certain preestablished criteria. If any person intends to
use prescreened lists, that person must (1) before the offer is made, establish
the criteria that will be relied upon to make the offer and to grant credit or
insurance, and (2) maintain such criteria on file for a three-year period
beginning on the date on which the offer is made to each consumer. In addition,
any user must provide with each written solicitation a clear and conspicuous
statement that:<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>&#8226; Information contained in a
consumer&#8217;s CRA file was used in connection with the transaction.<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>&#8226; The consumer received the offer
because he or she satisfied the criteria for credit worthiness or insurability
used to screen for the offer.<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>&#8226; Credit or insurance may not be
extended if, after the consumer responds, it is determined that the consumer
does not meet the criteria used for screening or any applicable criteria
bearing on credit worthiness or insurability, or the consumer does not furnish
required collateral.<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:SymbolOOEnc;mso-hansi-font-family:Tahoma;mso-bidi-font-family:
SymbolOOEnc'>&#61623;</span><span style='font-size:9.0pt;font-family:"Tahoma",sans-serif;color:black'>The
consumer may prohibit the use of information in his or her file in connection
with future prescreened offers of credit or insurance by contacting the
notification system established by the CRA that provided the report. The
statement must include the address and toll-free telephone number of the
appropriate notification system.<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>In addition, the CFPB has established
the format, type size, and manner of the disclosure required by Section 615(d),
with which users must comply. The relevant regulation is 12 CFR 1022.54.<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'>VIII. OBLIGATIONS OF RESELLERS<o:p></o:p></span></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><u><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'>A. Disclosure and Certification Requirements<o:p></o:p></span></u></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'><o:p>&nbsp;</o:p></span></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>Section 607(e) requires any
person who obtains a consumer report for resale to take the following steps:<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>&#8226; Disclose the
identity of the end-user to the source CRA.<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>&#8226; Identify to the
source CRA each permissible purpose for which the report will be furnished to
the end-user.<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>&#8226; Establish and follow
reasonable procedures to ensure that reports are resold only for permissible purposes,
including procedures to obtain: <o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>(1) the identify of all
end-users;<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>(2) certifications from all
users of each purpose for which reports will be used; and<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>(3) certifications that
reports will not be used for any purpose other than the purpose(s) specified to
the reseller. <o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>Resellers must make reasonable
efforts to verify this information before selling the report.<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><u><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'>B. Reinvestigations by Resellers<o:p></o:p></span></u></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><u><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'><o:p><span style='text-decoration:none'>&nbsp;</span></o:p></span></u></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>Under Section 611(f), if a
consumer disputes the accuracy or completeness of information in a report
prepared by a reseller, the reseller must determine whether this is a result of
an action or omission on its part and, if so, correct or delete the
information. If not, the reseller must send the dispute to the source CRA for
reinvestigation. When any CRA notifies the reseller of the results of an
investigation, the reseller must immediately convey the information to the
consumer.<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><u><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'>C. Fraud Alerts and Resellers<o:p></o:p></span></u></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'><o:p>&nbsp;</o:p></span></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>Section 605A(f) requires
resellers who receive fraud alerts or active duty alerts from another consumer
reporting agency to include these in their reports.<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'>IX. LIABILITY FOR VIOLATIONS OF THE FCRA<o:p></o:p></span></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'><o:p>&nbsp;</o:p></span></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>Failure to comply with the
FCRA can result in state government or federal government enforcement actions,
as well as private lawsuits. Sections 616, 617, and 621. In addition, any
person who knowingly and willfully obtains a consumer report under false
pretenses may face criminal prosecution. Section 619.<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'>The CFPB&#8217;s website, </span></b><b><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:blue'>www.consumerfinance.gov/learnmore</span></b><b><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'>, has more information about the FCRA, including
publications for businesses and the full text of the FCRA.<o:p></o:p></span></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'><o:p>&nbsp;</o:p></span></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'>Citations for FCRA sections in the U.S. Code, 15
U.S.C. &sect; 1681 et seq.:<o:p></o:p></span></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><b><span
style='font-size:9.0pt;font-family:"Tahoma,Bold",sans-serif;mso-bidi-font-family:
"Tahoma\,Bold";color:black'><o:p>&nbsp;</o:p></span></b></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>Section 602<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>Section 603<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>15 U.S.C. 1681<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>15 U.S.C. 1681a<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>Section 604 15 U.S.C. 1681b<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>Section 605 15 U.S.C. 1681c<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>Section 605A 15 U.S.C.
1681c-A<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>Section 605B 15 U.S.C.
1681c-B<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>Section 606 15 U.S.C. 1681d<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>Section 607 15 U.S.C. 1681e<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>Section 608 15 U.S.C. 1681f<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>Section 609 15 U.S.C. 1681g<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>Section 610 15 U.S.C. 1681h<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>Section 611 15 U.S.C. 1681i<o:p></o:p></span></p>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal;mso-layout-grid-align:none;text-autospace:none'><span style='font-size:
9.0pt;font-family:"Tahoma",sans-serif;color:black'>Section 612 15 U.S.C. 1681j<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:9.0pt;line-height:107%;font-family:
"Tahoma",sans-serif;color:black'>Section 613 15 U.S.C. 1681k<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:9.0pt;line-height:107%;font-family:
"Tahoma",sans-serif;color:black'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal><span style='font-size:9.0pt;line-height:107%;font-family:
"Tahoma",sans-serif;color:black'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal><span style='font-size:9.0pt;line-height:107%;font-family:
"Tahoma",sans-serif;color:black'><o:p>&nbsp;</o:p></span></p>

<p class=Default><o:p>&nbsp;</o:p></p>

<p class=Default align=center style='text-align:center'><span style='font-size:
10.0pt'>A Summary of<span style='mso-spacerun:yes'>&nbsp; </span>Consumer
Rights Under the Fair Credit Reporting Act<o:p></o:p></span></p>

<p class=Default><span style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

<p class=Default><span style='font-size:10.0pt'>The federal Fair Credit
Reporting Act (FCRA) promotes the accuracy, fairness, and privacy of
information in the files of consumer reporting agencies. There are many types
of consumer reporting agencies, including credit bureaus and specialty agencies
(such as agencies that sell information about check writing histories, medical
records, and rental history records). Here is a summary of your major rights
under the FCRA. <b>For more information, including information about additional
rights, go to www.consumerfinance.gov/learnmore or write to: Consumer Financial
Protection Bureau, 1700 G Street N.W., Washington, DC 20552. <o:p></o:p></b></span></p>

<p class=Default><span style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

<p class=Default><span style='font-size:10.0pt'>&#8226; <b>You must be told if
information in your file has been used against you. </b>Anyone who uses a
credit report or another type of consumer report to deny your application for
credit, insurance, or employment &#8211; or to take another adverse action
against you &#8211; must tell you, and must give you the name, address, and
phone number of the agency that provided the information. <o:p></o:p></span></p>

<p class=Default><span style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

<p class=Default><span style='font-size:10.0pt'>&#8226; <b>You have the right
to know what is in your file. </b>You may request and obtain all the
information about you in the files of a consumer reporting agency (your
&#8220;file disclosure&#8221;). You will be required to provide proper
identification, which may include your Social Security number. In many cases,
the disclosure will be free. You are entitled to a free file disclosure if: <o:p></o:p></span></p>

<p class=Default><span style='font-size:10.0pt'>&#8226; a person has taken
adverse action against you because of information in your credit report; <o:p></o:p></span></p>

<p class=Default><span style='font-size:10.0pt'>&#8226; you are the victim of
identity theft and place a fraud alert in your file; <o:p></o:p></span></p>

<p class=Default><span style='font-size:10.0pt'>&#8226; your file contains
inaccurate information as a result of fraud; <o:p></o:p></span></p>

<p class=Default><span style='font-size:10.0pt'>&#8226; you are on public
assistance; <o:p></o:p></span></p>

<p class=Default><span style='font-size:10.0pt'>&#8226; you are unemployed but
expect to apply for employment within 60 days. <o:p></o:p></span></p>

<p class=Default><span style='font-size:10.0pt'>In addition, all consumers are
entitled to one free disclosure every 12 months upon request from each
nationwide credit bureau and from nationwide specialty consumer reporting
agencies. See www.consumerfinance.gov/learnmore for additional information. <o:p></o:p></span></p>

<p class=Default><span style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

<p class=Default><span style='font-size:10.0pt'>&#8226; <b>You have the right
to ask for a credit score. </b>Credit scores are numerical summaries of your
credit-worthiness based on information from credit bureaus. You may request a
credit score from consumer reporting agencies that create scores or distribute
scores used in residential real property loans, but you will have to pay for
it. In some mortgage transactions, you will receive credit score information
for free from the mortgage lender. <o:p></o:p></span></p>

<p class=Default><span style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

<p class=Default><span style='font-size:10.0pt'>&#8226; <b>You have the right
to dispute incomplete or inaccurate information. </b>If you identify
information in your file that is incomplete or inaccurate, and report it to the
consumer reporting agency, the agency must investigate unless your dispute is
frivolous. See www.consumerfinance.gov/learnmore for an explanation of dispute
procedures.<o:p></o:p></span></p>

<p class=Default><span style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

<p class=Default><span style='font-size:10.0pt'>&#8226; <b>Consumer reporting
agencies must correct or delete inaccurate, incomplete, or unverifiable
information. </b>Inaccurate, incomplete, or unverifiable information must be
removed or corrected, usually within 30 days. However, a consumer reporting
agency may continue to report information it has verified as accurate. <o:p></o:p></span></p>

<p class=Default><span style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

<p class=Default><span style='font-size:10.0pt'>&#8226; <b>Consumer reporting
agencies may not report outdated negative information. </b>In most cases, a
consumer reporting agency may not report negative information that is more than
seven years old, or bankruptcies that are more than 10 years old. <o:p></o:p></span></p>

<p class=Default><span style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

<p class=Default><span style='font-size:10.0pt'>&#8226; <b>Access to your file
is limited. </b>A consumer reporting agency may provide information about you
only to people with a valid need -- usually to consider an application with a
creditor, insurer, employer, landlord, or other business. The FCRA specifies
those with a valid need for access. <o:p></o:p></span></p>

<p class=Default><span style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

<p class=Default><span style='font-size:10.0pt'>&#8226; <b>You must give your
consent for reports to be provided to employers. </b>A consumer reporting
agency may not give out information about you to your employer, or a potential
employer, without your written consent given to the employer. Written consent
generally is not required in the trucking industry. For more information, go to
</span><a href="http://www.consumerfinance.gov/learnmore"><span
style='font-size:10.0pt'>www.consumerfinance.gov/learnmore</span></a><span
style='font-size:10.0pt'>. <o:p></o:p></span></p>

<p class=Default><span style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

<p class=Default><span style='font-size:10.0pt'>&#8226; <b>You many limit
&#8220;prescreened&#8221; offers of credit and insurance you get based on
information in your credit report. </b>Unsolicited &#8220;prescreened&#8221;
offers for credit and insurance must include a toll-free phone number you can
call if you choose to remove your name and address from the lists these offers
are based on. You may opt out with the nationwide credit bureaus at 1-888-5-OPTOUT
(1-888-567-8688). <o:p></o:p></span></p>

<p class=Default><span style='font-size:10.0pt'>&#8226; <b>You may seek damages
from violators. </b>If a consumer reporting agency, or, in some cases, a user
of consumer reports or a furnisher of information to a consumer reporting
agency violates the FCRA, you may be able to sue in state or federal court. <o:p></o:p></span></p>

<p class=Default><span style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

<p class=Default><span style='font-size:10.0pt'>&#8226; <b>Identity theft
victims and active duty military personnel have additional rights. </b>For more
information, visit </span><a href="http://www.consumerfinance.gov/learnmore"><span
style='font-size:10.0pt'>www.consumerfinance.gov/learnmore</span></a><span
style='font-size:10.0pt'>. <o:p></o:p></span></p>

<p class=Default><span style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

<p class=Default><b><span style='font-size:10.0pt;line-height:107%'>States
may enforce the FCRA, and many states have their own consumer reporting laws.
In some cases, you may have more rights under state law. For more information,
contact your state or local consumer protection agency or your state Attorney
General.<o:p></o:p></span></b></p>

<p class=Default><span style='font-size:10.0pt;line-height:107%;mso-bidi-font-weight:
bold'>End User confirms that it must inform Identi-Check if any requested
report is not to be used for employment purposes.<span
style='mso-spacerun:yes'>&nbsp; </span>End User confirms that it will not use
the information contained in a report in violation of any applicable federal,
state or local equal employment opportunity or other law, rule, regulation,
code or guideline, including, but not limited to the Fair Credit Reporting Act
and Title VII of the Civil Rights Act of 1964.<span
style='mso-spacerun:yes'>&nbsp; </span>End User accepts full responsibility for
complying with all such laws and using the information products it receives
from Identi-Check in a legally acceptable fashion.<span
style='mso-spacerun:yes'>&nbsp; </span>To that end, End User agrees to comply
with and provide all statutorily required notices in Section 615 of the Fair
Credit Reporting Act or other state laws when using information products.<span
style='mso-spacerun:yes'>&nbsp; </span>End User accepts full responsibility for
any and all consequences of use and/or dissemination of those products.<o:p></o:p></span></p>

<p class=Default><span style='font-size:10.0pt;line-height:107%;mso-bidi-font-weight:
bold'>End User further agrees that each consumer report will only be used for a
one-time use.<span style='mso-spacerun:yes'>&nbsp; </span>End User agrees to
have reasonable procedures for the fair and equitable use of background
information and to secure the confidentiality of private information.<span
style='mso-spacerun:yes'>&nbsp; </span>End user agrees to take precautionary
measures to protect the security and dissemination of all consumer report or
investigative consumer report information including, for example, restricting
terminal access, and utilizing passwords to restrict access to terminal
devices, and securing access to dissemination and destruction of electronic and
hard copy reports. <o:p></o:p></span></p>

<p class=Default><span style='font-size:10.0pt;line-height:107%;mso-bidi-font-weight:
bold'>As a condition of entering into this Agreement, End User certifies that
it has in place reasonable procedures designed to comply with all applicable
local, state, and federal laws.<span style='mso-spacerun:yes'>&nbsp; </span>End
User also certifies that it will retain any information it receives from
Identi-Check for a period of five years from the date the report was received,
and will make such reports available to Identi-Check upon request.<span
style='mso-spacerun:yes'>&nbsp; </span><o:p></o:p></span></p>

<p class=Default><span style='font-size:10.0pt;line-height:107%;mso-bidi-font-weight:
bold'>End User also confirms that while it might provide Identi-Check with
copies of consent forms or related documents in order to convey necessary information,
Identi-Check is not required to maintain copies of such documents.<span
style='mso-spacerun:yes'>&nbsp; </span>Any obligations to retain such documents
under federal or state law remain solely with End User.<span
style='mso-spacerun:yes'>&nbsp; </span>End User agrees to indemnify and hold
harmless Identi-Check, its successors and assigns, and their current officers,
directors, employees, and agents from any liability due to End User&#8217;s
violation of the terms of this Certification or failure to comply with
applicable law.<o:p></o:p></span></p>

                      </div>
                    
                    <form name="form1" action="Accept_FCRA.asp" method="post">
                     <table>
                       <tr>
                         <td align="right" style="font-size: 12pt;">Acknowledgement that you have read, understand and agree to follow all rules in the Summary of Consumer Rights under the Fair Credit Reporting Act.</td>
                         <td>&nbsp;</td>
                       </tr>
                       <tr>
                         <td colspan="2" align="left">
                           <input type="checkbox" name="chkMain" id="chkMain" value="YES" />
                           &nbsp;<input type="submit" name="btnAccept" id="btnAccept" value="Accept" />
                           <span style="color:red;"><%=msg %></span>
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
</body>
</html>