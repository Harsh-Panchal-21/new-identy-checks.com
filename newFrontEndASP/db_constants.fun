<%
'---------------------------------------------------
Dim db_machine, db_userid, db_password, db_database, db_platform
db_machine = "ktidev1"
'db_machine = "gators"
'db_machine = "gis_server"
db_userid = "identi_asp"
db_password = "identi911"
db_database = "identi-check"
db_platform = "test"
'db_platform = "prod"

Const CdoReferenceTypeName = 1

function SendEmail(strTo,StrSubject,strMsg)

	Dim objCDO, objBP
	Set objCDO = Server.CreateObject("CDO.Message")
	objCDO.MimeFormatted = True
	'objCDO.To = strTo
	objCDO.To = "alexis@kingtech.net"
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
    objCDO.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver")="192.168.1.229"
    'SMTP port
    objCDO.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport")=25 
    objCDO.Configuration.Fields.Update

	objCDO.Send

end function
%>