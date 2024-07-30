<%
'---------------------------------------------------
Dim db_machine, db_userid, db_password, db_database, db_platform, email_url
db_machine = "ktivm-webdev"
db_userid = "identi_asp"
db_password = "identi911"
db_database = "identi-check"
db_platform = "test"
'db_platform = "prod"
email_url = "https://test.identi-check.com/"

Dim db_conn
db_conn = "Provider=SQLOLEDB.1"
db_conn = db_conn & ";Data Source=" & db_machine
db_conn = db_conn & ";User ID=" & db_userid
db_conn = db_conn & ";Password=" & db_password
db_conn = db_conn & ";Initial Catalog=" & db_database

Dim enc_pass_string
enc_pass_string = "asd73jhbasdf@sdf927as6-DSFW#4334qwsadar23"

Const CdoReferenceTypeName = 1

function SendEmail(strTo,StrSubject,strMsg)

	Dim objCDO, objBP
	Set objCDO = Server.CreateObject("CDO.Message")
	objCDO.MimeFormatted = True
	'objCDO.To = strTo
	objCDO.To = "matt@kingtech.net"
	objCDO.From = "online@identi-check.com"
	objCDO.Subject = StrSubject
	objCDO.HTMLBody = "<html><table cellpadding=2 cellspacing=0><tr><td><img src=""cid:myimage.jpg""></td></tr>" & _
		"<tr><td>" & strMsg & "</td></tr></table></html>"

	' Here's the good part, thanks to some little-known members.
	' This is a BodyPart object, which represents a new part of the multipart MIME-formatted message.
	' Note you can provide an image of ANY name as the source, and the second parameter essentially
	' renames it to anything you want.  Great for giving sensible names to dynamically-generated images.
	Set objBP = objCDO.AddRelatedBodyPart(Server.MapPath("/images/identi-check_email_banner.jpg"), "myimage.jpg", CdoReferenceTypeName)

	' Now assign a MIME Content ID to the image body part.
	' This is the key that was so hard to find, which makes it 
	' work in mail readers like Yahoo webmail & others that don't
	' recognise the default way Microsoft adds it's part id's,
	' leading to "broken" images in those readers.  Note the
	' < and > surrounding the arbitrary id string.  This is what
	' lets you have SRC="cid:myimage.gif" in the IMG tag.
	objBP.Fields.Item("urn:schemas:mailheader:Content-ID") = "<myimage.jpg>"
	objBP.Fields.Update
	
	objCDO.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing")=2 
	'SMTP server
    objCDO.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver")="127.0.0.1"
    'SMTP port
    objCDO.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport")=25 
    objCDO.Configuration.Fields.Update

	objCDO.Send

end function

function SendHTMLEmail(strTo,StrSubject,strMsg)

	Dim objCDO, objBP
	Set objCDO = Server.CreateObject("CDO.Message")
	objCDO.MimeFormatted = True
	objCDO.To = strTo
	objCDO.From = "online@identi-check.com"
	objCDO.Subject = StrSubject
	objCDO.HTMLBody = strMsg
	
	objCDO.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing")=2 
	'SMTP server
    objCDO.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver")="127.0.0.1"
    'SMTP port
    objCDO.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport")=25 
    objCDO.Configuration.Fields.Update

	objCDO.Send

end function
%>