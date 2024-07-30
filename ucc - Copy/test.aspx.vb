Imports System.Xml
Imports System.Net
Imports System.IO

Partial Class test
  Inherits System.Web.UI.Page

  Protected Sub btnShowXML_Click(sender As Object, e As System.EventArgs) Handles btnShowXML.Click
    'Dim sXML As String = "<?xml version=""1.0"" encoding=""UTF-8""?><Document><XMLVersion Version=""01262006""/><Header><Date>20121019</Date></Header><Record><PacketNum>16672012101912375100001</PacketNum><SeqNumber>1</SeqNumber><DocumentReceiptID>667122931240562067758</DocumentReceiptID><SubmitterRef>ucc-Filing</SubmitterRef><Status value=""OK""/><StatusDate>20121019</StatusDate></Record></Document>"
    'If sXML.IndexOf("DocumentReceiptID") > 0 Then
    '  Dim retDoc As New XmlDocument
    '  retDoc.LoadXml(sXML)
    '  Dim doc_receipt_id As XmlElement = retDoc.SelectSingleNode("//Document/Record/DocumentReceiptID")
    '  'Dim status As XmlElement = retDoc.GetElementById("Status")
    '  txtResult.Text = doc_receipt_id.InnerText
    '  'status.Attributes("value") 'should be "OK"
    'Else
    '  'error, return details
    '  'sRtn = responseFromServer
    'End If
    Dim sosxml As New SOS_XML
    txtResult.Text = sosxml.TestXML(txtUF_ID.Text)
    sosxml = Nothing
  End Sub

  Protected Sub btnDoSubmit_Click(sender As Object, e As System.EventArgs) Handles btnDoSubmit.Click
    Dim sosxml As New SOS_XML
    Dim sDocReceiptID As String = "", sPacketNum As String = ""
    txtResult.Text = sosxml.Submit_Filing(txtUF_ID.Text, sDocReceiptID, sPacketNum) & vbCrLf & "DocReceiptID: " & sDocReceiptID & vbCrLf & "PacketNum: " & sPacketNum
    sosxml = Nothing
  End Sub

  Protected Sub btnCheckStatus_Click(sender As Object, e As System.EventArgs) Handles btnCheckStatus.Click
    Dim sosxml As New SOS_XML
    txtResult.Text = sosxml.StatusRequest(txtDocRefNum.Text)
    sosxml = Nothing
  End Sub

  Protected Sub btnGetPDF_Click(sender As Object, e As System.EventArgs) Handles btnGetPDF.Click
    Dim sosxml As New SOS_XML
    'txtResult.Text = sosxml.RetrieveDocument(txtDocRefNum.Text)
    Dim byteTemp As Byte() = Nothing
    txtResult.Text = sosxml.RetrieveDocument(txtDocRefNum.Text, byteTemp)
    sosxml = Nothing
    'RetrieveImage
    Response.Clear()
    Response.BinaryWrite(byteTemp)
    Response.End()
  End Sub

  Protected Sub btnGetFile_Click(sender As Object, e As System.EventArgs) Handles btnGetFile.Click
    Dim sosxml As New SOS_XML
    txtResult.Text = sosxml.RetrieveImage(txtFileNumber.Text)
    sosxml = Nothing
  End Sub

  Protected Sub btnShowXMLAmend_Click(sender As Object, e As System.EventArgs) Handles btnShowXMLAmend.Click
    Dim sosxml As New SOS_XML
    txtResult.Text = sosxml.TextXMLAmend(txtU3_ID.Text)
    sosxml = Nothing
  End Sub

  Protected Sub btnSubmitAmend_Click(sender As Object, e As System.EventArgs) Handles btnSubmitAmend.Click
    Dim sosxml As New SOS_XML
    Dim sDocReceiptID As String = "", sPacketNum As String = ""
    txtResult.Text = sosxml.Submit_Amendment(txtU3_ID.Text, sDocReceiptID, sPacketNum) & vbCrLf & "DocReceiptID: " & sDocReceiptID & vbCrLf & "PacketNum: " & sPacketNum
    sosxml = Nothing
  End Sub

  Protected Sub btnTestSOSReturn_Click(sender As Object, e As System.EventArgs) Handles btnTestSOSReturn.Click
    Dim sosxml As New SOS_XML
    txtResult.Text = sosxml.TestSOSReturn()
    sosxml = Nothing
  End Sub

  'UCCXML_StatusRequestURL_Prod
  Protected Sub btnCheckStatusProd_Click(sender As Object, e As System.EventArgs) Handles btnCheckStatusProd.Click
    Dim request As WebRequest = WebRequest.Create(UCCXML_StatusRequestURL_Prod)
    request.Method = "POST"
    Dim postData As String = "uid=" & UCCXML_UserID & "&pwd=" & UCCXML_Password & "&DocumentReceiptID=" & txtDocRefNum.Text

    Dim byteArray As Byte() = Encoding.UTF8.GetBytes(postData)
    request.ContentType = "application/x-www-form-urlencoded"
    'request.ContentLength = byteArray.Length
    '' Get the request stream.
    Dim dataStream As Stream = request.GetRequestStream()
    '' Write the data to the request stream.
    dataStream.Write(byteArray, 0, byteArray.Length)
    '' Close the Stream object.
    dataStream.Close()
    '' Get the response.
    Dim response As WebResponse = request.GetResponse()
    '' Display the status.
    Dim sRtn As String = ""
    sRtn = DirectCast(response, HttpWebResponse).StatusDescription
    '' Get the stream containing content returned by the server.
    dataStream = response.GetResponseStream()
    '' Open the stream using a StreamReader for easy access.
    Dim reader As New StreamReader(dataStream)
    '' Read the content.
    Dim responseFromServer As String = reader.ReadToEnd()
    '' Display the content.
    'Console.WriteLine(responseFromServer)
    sRtn = sRtn & "<br>" & vbCrLf & responseFromServer
    '' Clean up the streams.
    reader.Close()
    dataStream.Close()
    response.Close()

    txtResult.Text = sRtn
  End Sub

  Protected Sub btnTestSOSReturnProd_Click(sender As Object, e As System.EventArgs) Handles btnTestSOSReturnProd.Click
    'txtResult.Text = ""
    Dim request As WebRequest = WebRequest.Create("https://www.identi-check.com/ucc/sos_return.aspx")
    request.Method = "POST"
    ' Create POST data and convert it to a byte array.
    'Dim postData As String = "<?xml version=""1.0"" encoding=""UTF-8""?><Document><XMLVersion Version=""01262006""/><Header>     <Filer>       <Names>         <OrganizationName>Identi-Check</OrganizationName>         <MailAddress>3 North Old State Capitol Plaza</MailAddress>         <City>Springfield</City>         <State>IL</State>         <PostalCode>62701</PostalCode>         <County>84</County>         <Country>USA</Country>         <TaxID/>         <OrganizationalType>Corporation</OrganizationalType>         <OrganizationalJuris>IL</OrganizationalJuris>         <OrganizationalID/>         <Mark/>       </Names>       <ClientAccountNum>667</ClientAccountNum>       <ContactName>Micah King</ContactName>       <ContactPhone>217-753-4311</ContactPhone>       <ContactEmail>micah@identi-check.com</ContactEmail>       <ContactFax>217-753-3492</ContactFax>       <ReturnURL>http://test.identi-check.com/ucc/sos_return.aspx</ReturnURL>       <ReturnUserID>sos_return</ReturnUserID>       <ReturnUserPWD>d743bd67s</ReturnUserPWD>     </Filer>     <PacketNum>10000006672012101913510300001</PacketNum>     <Test Choice=""Yes""/>   </Header><Record>     <SeqNumber>1</SeqNumber>     <TransType Type=""Initial""/>     <SubmitterRef>     </SubmitterRef>     <AltNameDesignation AltName=""NOAltName""/>     <AltFilingType AltType=""NOAltType""/>     <Debtors>       <DebtorName>         <Names>           <IndividualName>             <LastName>USER</LastName>             <FirstName>TEST</FirstName>             <MiddleName>TEST</MiddleName>             <Suffix>JR.</Suffix>           </IndividualName>           <MailAddress>111 EAST DRIVE</MailAddress>           <City>SPRINGFIELD</City>           <State>IL</State>           <PostalCode>62701</PostalCode>           <County/>           <Country>USA</Country>           <TaxID/>           <OrganizationalType Type=""NOType""/>           <OrganizationalJuris/>           <OrganizationalID>None</OrganizationalID>           <Mark/>         </Names>         <DebtorAltCapacity AltCapacity=""NOAltCapacity""/>       </DebtorName>     </Debtors>     <Secured>       <SecuredName>         <Names>           <OrganizationName>UNITED STATES OF AMERICA ACTING THROUGH FARM SERVICE AGENCY</OrganizationName>           <MailAddress>3500 WABASH AVE</MailAddress>           <City>SPRINGFIELD</City>           <State>IL</State>           <PostalCode>62711</PostalCode>           <County/>           <Country>USA</Country>           <TaxID/>           <Mark/>         </Names>       </SecuredName>     </Secured>     <Collateral>       <ColText>ALL HARVESTED CROPS</ColText>     </Collateral>   <Acknowledgement><FileNumber>15409924</FileNumber><FileDate>20121019</FileDate><FileTime>1354</FileTime><FeeAmount>20.00</FeeAmount><AdditionalFees>0.00</AdditionalFees><FilingOffice>Illinois Secretary of State</FilingOffice><FileStatus Status=""Accepted""/></Acknowledgement></Record></Document>"
    'Dim postData As String = "<?xml version=""1.0"" encoding=""UTF-8""?><Document><XMLVersion Version=""01262006""/><Header>     <Filer>       <Names>         <OrganizationName>Identi-Check</OrganizationName>         <MailAddress>3 North Old State Capitol Plaza</MailAddress>         <City>Springfield</City>         <State>IL</State>         <PostalCode>62701</PostalCode>         <County>84</County>         <Country>USA</Country>         <TaxID/>         <OrganizationalType>Corporation</OrganizationalType>         <OrganizationalJuris>IL</OrganizationalJuris>         <OrganizationalID/>         <Mark/>       </Names>       <ClientAccountNum>667</ClientAccountNum>       <ContactName>Micah King</ContactName>       <ContactPhone>217-753-4311</ContactPhone>       <ContactEmail>micah@identi-check.com</ContactEmail>       <ContactFax>217-753-3492</ContactFax>       <ReturnURL>http://test.identi-check.com/ucc/sos_return.aspx</ReturnURL>       <ReturnUserID>sos_return</ReturnUserID>       <ReturnUserPWD>d743bd67s</ReturnUserPWD>     </Filer>     <PacketNum>16672012101920480000001</PacketNum>     <Test Choice=""Yes""/>   </Header><Record>     <SeqNumber>1</SeqNumber>     <TransType Type=""Amendment""/>     <AmendmentType Type=""AmendmentParties""/>     <AmendmentAction Action=""DebtorAdd""/>     <InitialFileNumber>15409932</InitialFileNumber>     <SubmitterRef>     </SubmitterRef>     <AltNameDesignation AltName=""NOAltName""/>     <AltFilingType AltType=""NOAltType""/>     <CurrentName>       <IndividualName>         <LastName>USER</LastName>         <FirstName>TEST</FirstName>         <MiddleName>TEST</MiddleName>         <Suffix>JR.</Suffix>       </IndividualName>     </CurrentName>     <Debtors>       <DebtorName>         <Names>           <IndividualName>             <LastName>USER</LastName>             <FirstName>JANE</FirstName>             <MiddleName>             </MiddleName>             <Suffix>             </Suffix>           </IndividualName>           <MailAddress>3 NORTH OLD STATE CAPITOL PLAZA</MailAddress>           <City>SPRINGFIELD</City>           <State>IL</State>           <PostalCode>62701</PostalCode>           <County/>           <Country>USA</Country>           <TaxID/>           <OrganizationalType Type=""NOType""/>           <OrganizationalJuris/>           <OrganizationalID>None</OrganizationalID>           <Mark/>         </Names>         <DebtorAltCapacity AltCapacity=""NOAltCapacity""/>       </DebtorName>     </Debtors>     <AuthorizingParty>       <AuthSecuredParty>         <OrganizationName>COMMODITY CREDIT CORPORATION</OrganizationName>       </AuthSecuredParty>     </AuthorizingParty>   <Acknowledgement><FileNumber>09050390</FileNumber><FileDate>20121019</FileDate><FileTime>2051</FileTime><FeeAmount>20.00</FeeAmount><AdditionalFees>0.00</AdditionalFees><FilingOffice>Illinois Secretary of State</FilingOffice><FileStatus Status=""Accepted""/></Acknowledgement></Record></Document>"
    Dim postData As String = "<?xml version=""1.0"" encoding=""UTF-8""?><Document><XMLVersion Version=""01262006""/><Header>     <Filer>       <Names>         <OrganizationName>Identi-Check</OrganizationName>         <MailAddress>3 North Old State Capitol Plaza</MailAddress>         <City>Springfield</City>         <State>IL</State>         <PostalCode>62701</PostalCode>         <County>84</County>         <Country>USA</Country>         <TaxID/>         <OrganizationalType>Corporation</OrganizationalType>         <OrganizationalJuris>IL</OrganizationalJuris>         <OrganizationalID/>         <Mark/>       </Names>       <ClientAccountNum>667</ClientAccountNum>       <ContactName>Micah King</ContactName>       <ContactPhone>217-753-4311</ContactPhone>       <ContactEmail>micah@identi-check.com</ContactEmail>       <ContactFax>217-753-3492</ContactFax>       <ReturnURL>https://www.identi-check.com/ucc/sos_return.aspx</ReturnURL>       <ReturnUserID>sos_return</ReturnUserID>       <ReturnUserPWD>d743bd67s</ReturnUserPWD>     </Filer>     " & _
      "<PacketNum>" & txtProdTicketNum.Text & "</PacketNum>     <Test Choice=""No""/>   </Header><Record>     <SeqNumber>1</SeqNumber>     " & _
      "<TransType Type=""" & txtProdTransType.Text & """/>     <AmendmentType Type=""AmendmentParties""/>     <AmendmentAction Action=""DebtorAdd""/>     <InitialFileNumber>15409924</InitialFileNumber>     <SubmitterRef>     </SubmitterRef>     <AltNameDesignation AltName=""NOAltName""/>     <AltFilingType AltType=""NOAltType""/>     <CurrentName>       <IndividualName>         <LastName>USER</LastName>         <FirstName>TEST</FirstName>         <MiddleName>TEST</MiddleName>         <Suffix>JR.</Suffix>       </IndividualName>     </CurrentName>     <Debtors>       <DebtorName>         <Names>           <IndividualName>             <LastName>USER</LastName>             <FirstName>JANE</FirstName>             <MiddleName>             </MiddleName>             <Suffix>             </Suffix>           </IndividualName>           <MailAddress>3 NORTH OLD STATE CAPITOL PLAZA</MailAddress>           <City>SPRINGFIELD</City>           <State>IL</State>           <PostalCode>62701</PostalCode>           <County/>           <Country>USA</Country>           <TaxID/>           <OrganizationalType Type=""NOType""/>           <OrganizationalJuris/>           <OrganizationalID>None</OrganizationalID>           <Mark/>         </Names>         <DebtorAltCapacity AltCapacity=""NOAltCapacity""/>       </DebtorName>     </Debtors>     <AuthorizingParty>       <AuthSecuredParty>         <OrganizationName>COMMODITY CREDIT CORPORATION</OrganizationName>       </AuthSecuredParty>     </AuthorizingParty>   " & _
      "<Acknowledgement><FileNumber>" & txtProdFileNo.Text & "</FileNumber>" & _
      "<FileDate>" & txtProdFileDate.Text & "</FileDate><FileTime>" & txtProdFileTime.Text & "</FileTime><FeeAmount>20.00</FeeAmount><AdditionalFees>0.00</AdditionalFees><FilingOffice>Illinois Secretary of State</FilingOffice>" & _
      "<FileStatus Status=""" & txtProdStatus.Text & """/></Acknowledgement></Record></Document>"
    '667123181734329858650
    Dim byteArray As Byte() = Encoding.UTF8.GetBytes(postData)
    ' Set the ContentType property of the WebRequest.
    request.ContentType = "application/x-www-form-urlencoded"
    'request.ContentType = "text/xml"
    '' Set the ContentLength property of the WebRequest.
    request.ContentLength = byteArray.Length
    '' Get the request stream.
    Dim dataStream As Stream = request.GetRequestStream()
    '' Write the data to the request stream.
    dataStream.Write(byteArray, 0, byteArray.Length)
    '' Close the Stream object.
    dataStream.Close()
    '' Get the response.
    Dim response As WebResponse = request.GetResponse()
    '' Display the status.
    Dim sRtn As String = ""
    sRtn = DirectCast(response, HttpWebResponse).StatusDescription
    '' Get the stream containing content returned by the server.
    dataStream = response.GetResponseStream()
    '' Open the stream using a StreamReader for easy access.
    Dim reader As New StreamReader(dataStream)
    '' Read the content.
    Dim responseFromServer As String = reader.ReadToEnd()
    '' Display the content.
    'Console.WriteLine(responseFromServer)

    'sRtn = sRtn & "<br>" & vbCrLf & responseFromServer
    '' Clean up the streams.
    reader.Close()
    dataStream.Close()
    response.Close()

    txtResult.Text = sRtn
  End Sub
End Class
