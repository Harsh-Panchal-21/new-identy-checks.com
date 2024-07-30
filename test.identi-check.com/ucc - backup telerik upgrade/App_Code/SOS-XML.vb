Imports System
Imports System.IO
Imports System.Net
Imports System.Text
Imports Microsoft.VisualBasic
Imports System.Xml
Imports System.Xml.Schema

Public Class SOS_XML
  Public sXML As String
  Dim doc As XmlDocument
  Dim root As XmlElement

  Public Enum AmendmentAction
    DebtorAdd
    DebtorChange
    DebtorDelete
    SecuredPartyAdd
    SecuredPartyChange
    SecuredPartyDelete
    CollateralAdd
    CollateralChange
    CollateralDelete
    CollateralRestate
    CollateralAssign
    NOAction
  End Enum

  Public Enum AmendmentType
    AmendmentCollateral
    AmendmentParties
    Assignment
    Correct
    Continuation
    Correction
    TerminationDebtor
    TerminationSecuredParty
    OfficerStatement
    NOType
  End Enum

  Public Enum OrgType
    Corporation
    ForeignAssociation
    GeneralPartnership
    LimitedLiabilityCompany
    LimitedLiabilityLimitedPartnership
    LimitedLiabilityPartnership
    RegisteredLimitedLiabilityLimitedPartnership
    SoleProprietorship
    UnincorporatedAssociation
    UnincorporatedNonprofitAssociation
    NOType
  End Enum

  Public Sub New()
    Me.doc = New XmlDocument
    Me.root = doc.CreateElement("Document")
  End Sub

  Public Sub Dispose()
    Me.doc = Nothing
    Me.root = Nothing
  End Sub

  Public Function Submit_Filing(ByVal sUF_ID As String, ByRef sDocReceiptID As String, ByRef sPacketNum As String) As String
    System.Net.ServicePointManager.SecurityProtocol = System.Net.SecurityProtocolType.Tls12
    Dim request As WebRequest = WebRequest.Create(UCCXML_PostURL)
    request.Method = "POST"
    Dim postData As String = "uid=" & UCCXML_UserID & "&pwd=" & UCCXML_Password & "&xmlData="

    Dim xmlDeclaration As XmlDeclaration = doc.CreateXmlDeclaration("1.0", "utf-8", String.Empty)
    doc.InsertBefore(xmlDeclaration, doc.DocumentElement)
    Dim xml_version As XmlElement = doc.CreateElement("XMLVersion")
    xml_version.SetAttribute("Version", "02242013") '01262006
    root.AppendChild(xml_version)

    Dim sMon As String = Now.Month
    Dim sDay As String = Now.Day
    Dim sHour As String = Now.Hour
    Dim sMin As String = Now.Minute
    Dim sSec As String = Now.Second
    Dim sPN As String = "1" & Right("000000000" & UCCXML_Acct_Num, 9) & Now.Year & Right("00" & sMon, 2) & Right("00" & sDay, 2) & _
      Right("00" & sHour, 2) & Right("00" & sMin, 2) & Right("00" & sSec, 2) & "00001"
    sPacketNum = sPN

    BuildHeader(sPN)

    BuildFiling(sUF_ID)

    doc.AppendChild(root)

    Dim memStream As New MemoryStream
    memStream.Position = 0
    doc.Save(memStream)

    Dim strXML As String = Encoding.UTF8.GetString(memStream.ToArray())
    If strXML.StartsWith(Encoding.UTF8.GetString(Encoding.UTF8.GetPreamble())) Then
      strXML = strXML.Remove(0, Encoding.UTF8.GetString(Encoding.UTF8.GetPreamble()).Length)
    End If
    'Return postData & strXML 'sRtn 'doc.OuterXml
    'Exit Function
    Try
      RunCommand("insert into ucc_xml_out (uxo_date,uxo_xml,uxo_type,uxo_type_id) values (getdate(),'" & strXML.Replace("'", "''") & "','UCC1'," & sUF_ID & ")")
    Catch ex As Exception
      'do nothing
    End Try

    Dim byteArray As Byte() = Encoding.UTF8.GetBytes(postData & HttpUtility.UrlEncode(strXML))
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
    sRtn = ""
    If responseFromServer.IndexOf("DocumentReceiptID") > 0 Then
      Dim retDoc As New XmlDocument
      retDoc.LoadXml(responseFromServer)
      Dim doc_receipt_id As XmlElement = retDoc.SelectSingleNode("//Document/Record/DocumentReceiptID")
      Dim status As XmlElement = retDoc.SelectSingleNode("//Document/Record/Status")
      If status.Attributes("value").Value <> "OK" Then
        'error
        sRtn = responseFromServer
      Else
        sDocReceiptID = doc_receipt_id.InnerText
      End If
      'status.Attributes("value") 'should be "OK"
      'sRtn = responseFromServer
    Else
      'error, return details
      sRtn = responseFromServer
    End If

    'sRtn = sRtn & "<br>" & vbCrLf & responseFromServer
    '' Clean up the streams.
    reader.Close()
    dataStream.Close()
    response.Close()

    Return sRtn
  End Function

  Public Function Submit_Amendment(ByVal sU3_ID As String, ByRef sDocReceiptID As String, ByRef sPacketNum As String) As String
    System.Net.ServicePointManager.SecurityProtocol = System.Net.SecurityProtocolType.Tls12
    Dim request As WebRequest = WebRequest.Create(UCCXML_PostURL)
    request.Method = "POST"
    Dim postData As String = "uid=" & UCCXML_UserID & "&pwd=" & UCCXML_Password & "&xmlData="

    Dim xmlDeclaration As XmlDeclaration = doc.CreateXmlDeclaration("1.0", "utf-8", String.Empty)
    doc.InsertBefore(xmlDeclaration, doc.DocumentElement)
    Dim xml_version As XmlElement = doc.CreateElement("XMLVersion")
    xml_version.SetAttribute("Version", "02242013") '01262006
    root.AppendChild(xml_version)

    Dim sMon As String = Now.Month
    Dim sDay As String = Now.Day
    Dim sHour As String = Now.Hour
    Dim sMin As String = Now.Minute
    Dim sSec As String = Now.Second
    Dim sPN As String = "1" & Right("000000000" & UCCXML_Acct_Num, 9) & Now.Year & Right("00" & sMon, 2) & Right("00" & sDay, 2) & _
      Right("00" & sHour, 2) & Right("00" & sMin, 2) & Right("00" & sSec, 2) & "00001"
    sPacketNum = sPN

    BuildHeader(sPN)

    Build_Amendment(sU3_ID)

    doc.AppendChild(root)

    Dim memStream As New MemoryStream
    memStream.Position = 0
    doc.Save(memStream)

    Dim strXML As String = Encoding.UTF8.GetString(memStream.ToArray())
    If strXML.StartsWith(Encoding.UTF8.GetString(Encoding.UTF8.GetPreamble())) Then
      strXML = strXML.Remove(0, Encoding.UTF8.GetString(Encoding.UTF8.GetPreamble()).Length)
    End If
    'Return postData & strXML 'sRtn 'doc.OuterXml
    'Exit Function
    Try
      RunCommand("insert into ucc_xml_out (uxo_date,uxo_xml,uxo_type,uxo_type_id) values (getdate(),'" & strXML.Replace("'", "''") & "','UCC3'," & sU3_ID & ")")
    Catch ex As Exception
      'do nothing
      'Throw ex
    End Try

    Dim byteArray As Byte() = Encoding.UTF8.GetBytes(postData & HttpUtility.UrlEncode(strXML))
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

    sRtn = ""
    If responseFromServer.IndexOf("DocumentReceiptID") > 0 Then
      Dim retDoc As New XmlDocument
      retDoc.LoadXml(responseFromServer)
      Dim doc_receipt_id As XmlElement = retDoc.SelectSingleNode("//Document/Record/DocumentReceiptID")
      Dim status As XmlElement = retDoc.SelectSingleNode("//Document/Record/Status")
      If status.Attributes("value").Value <> "OK" Then
        'error
        sRtn = responseFromServer
      Else
        sDocReceiptID = doc_receipt_id.InnerText
      End If
      'status.Attributes("value") 'should be "OK"
      'sRtn = responseFromServer
    Else
      'error, return details
      sRtn = responseFromServer
    End If

    'sRtn = sRtn & "<br>" & vbCrLf & responseFromServer
    '' Clean up the streams.
    reader.Close()
    dataStream.Close()
    response.Close()

    Return sRtn
  End Function

  Public Function StatusRequest(ByVal sDocRefNum As String) As String
    System.Net.ServicePointManager.SecurityProtocol = System.Net.SecurityProtocolType.Tls12
    Dim request As WebRequest = WebRequest.Create(UCCXML_StatusRequestURL)
    request.Method = "POST"
    Dim postData As String = "uid=" & UCCXML_UserID & "&pwd=" & UCCXML_Password & "&DocumentReceiptID=" & sDocRefNum

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

    Return sRtn
  End Function

  Public Function RetrieveDocument(ByVal sDocRefNum As String, ByRef byteTemp As Byte()) As String
    System.Net.ServicePointManager.SecurityProtocol = System.Net.SecurityProtocolType.Tls12
    Dim postData As String = "uid=" & UCCXML_UserID & "&pwd=" & UCCXML_Password & "&DocumentReceiptID=" & sDocRefNum
    Dim request As WebRequest = WebRequest.Create(UCCXML_RetrieveDocURL & "?" & postData)
    'Dim request As WebRequest = WebRequest.Create("http://test.identi-check.com/ucc/RetrieveDocument_UCC1_79.pdf")
    request.Method = "GET"

    'Dim byteArray As Byte() = Encoding.UTF8.GetBytes(postData)
    'request.ContentType = "application/x-www-form-urlencoded"
    ''request.ContentLength = byteArray.Length
    ' '' Get the request stream.
    'Dim dataStream As Stream
    'Dim dataStream As Stream = request.GetRequestStream()
    ' '' Write the data to the request stream.
    'dataStream.Write(byteArray, 0, byteArray.Length)
    ' '' Close the Stream object.
    'dataStream.Close()
    '' Get the response.
    Dim response As WebResponse = request.GetResponse()

    '' Display the status.
    Dim sRtn As String = ""
    sRtn = DirectCast(response, HttpWebResponse).StatusDescription

    '' Get the stream containing content returned by the server.
    'dataStream = response.GetResponseStream()

    'Dim readStream As IO.StreamReader = New IO.StreamReader(dataStream, New UTF8Encoding)
    'Dim binaryReader As IO.BinaryReader = New IO.BinaryReader(dataStream, New UTF8Encoding)
    'byteTemp = binaryReader.ReadBytes(dataStream.Length)
    'byteTemp = New UTF8Encoding().GetBytes(readStream.ReadToEnd())
    Dim buffer As Byte() = New Byte(4095) {}
    Using responseStream As Stream = response.GetResponseStream()
      Using memoryStream As New MemoryStream()
        Dim count As Integer = 0
        Do
          count = responseStream.Read(buffer, 0, buffer.Length)

          memoryStream.Write(buffer, 0, count)
        Loop While count <> 0

        byteTemp = memoryStream.ToArray()
      End Using
    End Using


    '' Open the stream using a StreamReader for easy access.
    'Dim reader As New StreamReader(dataStream)

    '' Read the content.
    'Dim responseFromServer As String = reader.ReadToEnd()
    '' Display the content.
    'Console.WriteLine(responseFromServer)
    'sRtn = sRtn & "<br>" & vbCrLf & responseFromServer
    '' Clean up the streams.
    'reader.Close()
    'dataStream.Close()
    response.Close()

    Return sRtn
  End Function

  Public Function RetrieveImage(ByVal sFileNumber As String) As String
    System.Net.ServicePointManager.SecurityProtocol = System.Net.SecurityProtocolType.Tls12
    Dim request As WebRequest = WebRequest.Create(UCCXML_RetrieveImage)
    request.Method = "POST"
    Dim postData As String = "uid=" & UCCXML_UserID & "&pwd=" & UCCXML_Password & "&FileNumber=" & sFileNumber

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

    Return sRtn
  End Function

  Public Function TestXML(ByVal sUF_ID As String) As String
    System.Net.ServicePointManager.SecurityProtocol = System.Net.SecurityProtocolType.Tls12
    ' Create a request using a URL that can receive a post.
    Dim request As WebRequest = WebRequest.Create(UCCXML_PostURL)
    'Dim request As WebRequest = WebRequest.Create("http://test.identi-check.com/ucc/sos_return.aspx")
    'UCCXML_StatusRequestURL
    'UCCXML_RetrieveDocURL
    ' Set the Method property of the request to POST.
    request.Method = "POST"
    ' Create POST data and convert it to a byte array.
    Dim postData As String = "uid=" & UCCXML_UserID & "&pwd=" & UCCXML_Password & "&xmlData="
    'Dim postData As String = "uid=" & UCCXML_UserID & "&pwd=" & UCCXML_Password & "&DocumentReceiptID=" & ""
    'Dim postData As String = "uid=" & UCCXML_UserID & "&pwd=" & UCCXML_Password & "&DocumentReceiptID=" & ""

    'Dim doc As New XmlDocument()

    'Dim root As XmlElement = doc.CreateElement("Document")
    Dim xmlDeclaration As XmlDeclaration = doc.CreateXmlDeclaration("1.0", "utf-8", String.Empty)
    'xmlDeclaration.Encoding = New UTF8Encoding(False)
    doc.InsertBefore(xmlDeclaration, doc.DocumentElement)
    Dim xml_version As XmlElement = doc.CreateElement("XMLVersion")
    xml_version.SetAttribute("Version", "01262006")
    root.AppendChild(xml_version)

    Dim sMon As String = Now.Month
    Dim sDay As String = Now.Day
    Dim sHour As String = Now.Hour
    Dim sMin As String = Now.Minute
    Dim sSec As String = Now.Second
    Dim sPN As String = "1" & Right("000000000" & UCCXML_Acct_Num, 9) & Now.Year & Right("00" & sMon, 2) & Right("00" & sDay, 2) & _
      Right("00" & sHour, 2) & Right("00" & sMin, 2) & Right("00" & sSec, 2)

    BuildHeader(sPN & "00001")

    BuildFiling(sUF_ID)

    'BuildAmendment()

    doc.AppendChild(root)


    '' Set the validation settings.
    'Dim settings As XmlReaderSettings = New XmlReaderSettings()
    'settings.ProhibitDtd = False
    'settings.ValidationType = ValidationType.DTD

    'AddHandler settings.ValidationEventHandler, AddressOf ValidationCallBack

    ' Create the XmlReader object.
    'Dim reader As XmlReader = XmlReader.Create("itemDTD.xml", settings)

    Dim memStream As New MemoryStream
    memStream.Position = 0
    doc.Save(memStream)

    Dim strXML As String = Encoding.UTF8.GetString(memStream.ToArray())
    If strXML.StartsWith(Encoding.UTF8.GetString(Encoding.UTF8.GetPreamble())) Then
      strXML = strXML.Remove(0, Encoding.UTF8.GetString(Encoding.UTF8.GetPreamble()).Length)
    End If
    Return postData & strXML 'sRtn 'doc.OuterXml
    Exit Function
  End Function

  Public Function TextXMLAmend(ByVal sU3_ID As String) As String
    System.Net.ServicePointManager.SecurityProtocol = System.Net.SecurityProtocolType.Tls12
    ' Create a request using a URL that can receive a post.
    Dim request As WebRequest = WebRequest.Create(UCCXML_PostURL)
    'Dim request As WebRequest = WebRequest.Create("http://test.identi-check.com/ucc/sos_return.aspx")
    'UCCXML_StatusRequestURL
    'UCCXML_RetrieveDocURL
    ' Set the Method property of the request to POST.
    request.Method = "POST"
    ' Create POST data and convert it to a byte array.
    Dim postData As String = "uid=" & UCCXML_UserID & "&pwd=" & UCCXML_Password & "&xmlData="
    'Dim postData As String = "uid=" & UCCXML_UserID & "&pwd=" & UCCXML_Password & "&DocumentReceiptID=" & ""
    'Dim postData As String = "uid=" & UCCXML_UserID & "&pwd=" & UCCXML_Password & "&DocumentReceiptID=" & ""

    'Dim doc As New XmlDocument()

    'Dim root As XmlElement = doc.CreateElement("Document")
    Dim xmlDeclaration As XmlDeclaration = doc.CreateXmlDeclaration("1.0", "utf-8", String.Empty)
    'xmlDeclaration.Encoding = New UTF8Encoding(False)
    doc.InsertBefore(xmlDeclaration, doc.DocumentElement)
    Dim xml_version As XmlElement = doc.CreateElement("XMLVersion")
    xml_version.SetAttribute("Version", "01262006")
    root.AppendChild(xml_version)

    Dim sMon As String = Now.Month
    Dim sDay As String = Now.Day
    Dim sHour As String = Now.Hour
    Dim sMin As String = Now.Minute
    Dim sSec As String = Now.Second
    Dim sPN As String = "1" & Right("000000000" & UCCXML_Acct_Num, 9) & Now.Year & Right("00" & sMon, 2) & Right("00" & sDay, 2) & _
      Right("00" & sHour, 2) & Right("00" & sMin, 2) & Right("00" & sSec, 2)

    BuildHeader(sPN & "00001")

    Build_Amendment(sU3_ID)

    doc.AppendChild(root)


    '' Set the validation settings.
    'Dim settings As XmlReaderSettings = New XmlReaderSettings()
    'settings.ProhibitDtd = False
    'settings.ValidationType = ValidationType.DTD

    'AddHandler settings.ValidationEventHandler, AddressOf ValidationCallBack

    ' Create the XmlReader object.
    'Dim reader As XmlReader = XmlReader.Create("itemDTD.xml", settings)

    Dim memStream As New MemoryStream
    memStream.Position = 0
    doc.Save(memStream)

    Dim strXML As String = Encoding.UTF8.GetString(memStream.ToArray())
    If strXML.StartsWith(Encoding.UTF8.GetString(Encoding.UTF8.GetPreamble())) Then
      strXML = strXML.Remove(0, Encoding.UTF8.GetString(Encoding.UTF8.GetPreamble()).Length)
    End If
    Return postData & strXML 'sRtn 'doc.OuterXml
    Exit Function
  End Function

  Public Function TestSOSReturn() As String
    System.Net.ServicePointManager.SecurityProtocol = System.Net.SecurityProtocolType.Tls12
    Dim request As WebRequest = WebRequest.Create("http://test.identi-check.com/ucc/sos_return.aspx")
    request.Method = "POST"
    ' Create POST data and convert it to a byte array.
    'Dim postData As String = "<?xml version=""1.0"" encoding=""UTF-8""?><Document><XMLVersion Version=""01262006""/><Header>     <Filer>       <Names>         <OrganizationName>Identi-Check</OrganizationName>         <MailAddress>3 North Old State Capitol Plaza</MailAddress>         <City>Springfield</City>         <State>IL</State>         <PostalCode>62701</PostalCode>         <County>84</County>         <Country>USA</Country>         <TaxID/>         <OrganizationalType>Corporation</OrganizationalType>         <OrganizationalJuris>IL</OrganizationalJuris>         <OrganizationalID/>         <Mark/>       </Names>       <ClientAccountNum>667</ClientAccountNum>       <ContactName>Micah King</ContactName>       <ContactPhone>217-753-4311</ContactPhone>       <ContactEmail>micah@identi-check.com</ContactEmail>       <ContactFax>217-753-3492</ContactFax>       <ReturnURL>http://test.identi-check.com/ucc/sos_return.aspx</ReturnURL>       <ReturnUserID>sos_return</ReturnUserID>       <ReturnUserPWD>d743bd67s</ReturnUserPWD>     </Filer>     <PacketNum>10000006672012101913510300001</PacketNum>     <Test Choice=""Yes""/>   </Header><Record>     <SeqNumber>1</SeqNumber>     <TransType Type=""Initial""/>     <SubmitterRef>     </SubmitterRef>     <AltNameDesignation AltName=""NOAltName""/>     <AltFilingType AltType=""NOAltType""/>     <Debtors>       <DebtorName>         <Names>           <IndividualName>             <LastName>USER</LastName>             <FirstName>TEST</FirstName>             <MiddleName>TEST</MiddleName>             <Suffix>JR.</Suffix>           </IndividualName>           <MailAddress>111 EAST DRIVE</MailAddress>           <City>SPRINGFIELD</City>           <State>IL</State>           <PostalCode>62701</PostalCode>           <County/>           <Country>USA</Country>           <TaxID/>           <OrganizationalType Type=""NOType""/>           <OrganizationalJuris/>           <OrganizationalID>None</OrganizationalID>           <Mark/>         </Names>         <DebtorAltCapacity AltCapacity=""NOAltCapacity""/>       </DebtorName>     </Debtors>     <Secured>       <SecuredName>         <Names>           <OrganizationName>UNITED STATES OF AMERICA ACTING THROUGH FARM SERVICE AGENCY</OrganizationName>           <MailAddress>3500 WABASH AVE</MailAddress>           <City>SPRINGFIELD</City>           <State>IL</State>           <PostalCode>62711</PostalCode>           <County/>           <Country>USA</Country>           <TaxID/>           <Mark/>         </Names>       </SecuredName>     </Secured>     <Collateral>       <ColText>ALL HARVESTED CROPS</ColText>     </Collateral>   <Acknowledgement><FileNumber>15409924</FileNumber><FileDate>20121019</FileDate><FileTime>1354</FileTime><FeeAmount>20.00</FeeAmount><AdditionalFees>0.00</AdditionalFees><FilingOffice>Illinois Secretary of State</FilingOffice><FileStatus Status=""Accepted""/></Acknowledgement></Record></Document>"
    'Dim postData As String = "<?xml version=""1.0"" encoding=""UTF-8""?><Document><XMLVersion Version=""01262006""/><Header>     <Filer>       <Names>         <OrganizationName>Identi-Check</OrganizationName>         <MailAddress>3 North Old State Capitol Plaza</MailAddress>         <City>Springfield</City>         <State>IL</State>         <PostalCode>62701</PostalCode>         <County>84</County>         <Country>USA</Country>         <TaxID/>         <OrganizationalType>Corporation</OrganizationalType>         <OrganizationalJuris>IL</OrganizationalJuris>         <OrganizationalID/>         <Mark/>       </Names>       <ClientAccountNum>667</ClientAccountNum>       <ContactName>Micah King</ContactName>       <ContactPhone>217-753-4311</ContactPhone>       <ContactEmail>micah@identi-check.com</ContactEmail>       <ContactFax>217-753-3492</ContactFax>       <ReturnURL>http://test.identi-check.com/ucc/sos_return.aspx</ReturnURL>       <ReturnUserID>sos_return</ReturnUserID>       <ReturnUserPWD>d743bd67s</ReturnUserPWD>     </Filer>     <PacketNum>16672012101920480000001</PacketNum>     <Test Choice=""Yes""/>   </Header><Record>     <SeqNumber>1</SeqNumber>     <TransType Type=""Amendment""/>     <AmendmentType Type=""AmendmentParties""/>     <AmendmentAction Action=""DebtorAdd""/>     <InitialFileNumber>15409932</InitialFileNumber>     <SubmitterRef>     </SubmitterRef>     <AltNameDesignation AltName=""NOAltName""/>     <AltFilingType AltType=""NOAltType""/>     <CurrentName>       <IndividualName>         <LastName>USER</LastName>         <FirstName>TEST</FirstName>         <MiddleName>TEST</MiddleName>         <Suffix>JR.</Suffix>       </IndividualName>     </CurrentName>     <Debtors>       <DebtorName>         <Names>           <IndividualName>             <LastName>USER</LastName>             <FirstName>JANE</FirstName>             <MiddleName>             </MiddleName>             <Suffix>             </Suffix>           </IndividualName>           <MailAddress>3 NORTH OLD STATE CAPITOL PLAZA</MailAddress>           <City>SPRINGFIELD</City>           <State>IL</State>           <PostalCode>62701</PostalCode>           <County/>           <Country>USA</Country>           <TaxID/>           <OrganizationalType Type=""NOType""/>           <OrganizationalJuris/>           <OrganizationalID>None</OrganizationalID>           <Mark/>         </Names>         <DebtorAltCapacity AltCapacity=""NOAltCapacity""/>       </DebtorName>     </Debtors>     <AuthorizingParty>       <AuthSecuredParty>         <OrganizationName>COMMODITY CREDIT CORPORATION</OrganizationName>       </AuthSecuredParty>     </AuthorizingParty>   <Acknowledgement><FileNumber>09050390</FileNumber><FileDate>20121019</FileDate><FileTime>2051</FileTime><FeeAmount>20.00</FeeAmount><AdditionalFees>0.00</AdditionalFees><FilingOffice>Illinois Secretary of State</FilingOffice><FileStatus Status=""Accepted""/></Acknowledgement></Record></Document>"
    Dim postData As String = "<?xml version=""1.0"" encoding=""UTF-8""?><Document><XMLVersion Version=""01262006""/><Header>     <Filer>       <Names>         <OrganizationName>Identi-Check</OrganizationName>         <MailAddress>3 North Old State Capitol Plaza</MailAddress>         <City>Springfield</City>         <State>IL</State>         <PostalCode>62701</PostalCode>         <County>84</County>         <Country>USA</Country>         <TaxID/>         <OrganizationalType>Corporation</OrganizationalType>         <OrganizationalJuris>IL</OrganizationalJuris>         <OrganizationalID/>         <Mark/>       </Names>       <ClientAccountNum>667</ClientAccountNum>       <ContactName>Micah King</ContactName>       <ContactPhone>217-753-4311</ContactPhone>       <ContactEmail>micah@identi-check.com</ContactEmail>       <ContactFax>217-753-3492</ContactFax>       <ReturnURL>http://test.identi-check.com/ucc/sos_return.aspx</ReturnURL>       <ReturnUserID>sos_return</ReturnUserID>       <ReturnUserPWD>d743bd67s</ReturnUserPWD>     </Filer>     <PacketNum>16672012101920565500001</PacketNum>     <Test Choice=""Yes""/>   </Header><Record>     <SeqNumber>1</SeqNumber>     <TransType Type=""Amendment""/>     <AmendmentType Type=""AmendmentParties""/>     <AmendmentAction Action=""DebtorAdd""/>     <InitialFileNumber>15409924</InitialFileNumber>     <SubmitterRef>     </SubmitterRef>     <AltNameDesignation AltName=""NOAltName""/>     <AltFilingType AltType=""NOAltType""/>     <CurrentName>       <IndividualName>         <LastName>USER</LastName>         <FirstName>TEST</FirstName>         <MiddleName>TEST</MiddleName>         <Suffix>JR.</Suffix>       </IndividualName>     </CurrentName>     <Debtors>       <DebtorName>         <Names>           <IndividualName>             <LastName>USER</LastName>             <FirstName>JANE</FirstName>             <MiddleName>             </MiddleName>             <Suffix>             </Suffix>           </IndividualName>           <MailAddress>3 NORTH OLD STATE CAPITOL PLAZA</MailAddress>           <City>SPRINGFIELD</City>           <State>IL</State>           <PostalCode>62701</PostalCode>           <County/>           <Country>USA</Country>           <TaxID/>           <OrganizationalType Type=""NOType""/>           <OrganizationalJuris/>           <OrganizationalID>None</OrganizationalID>           <Mark/>         </Names>         <DebtorAltCapacity AltCapacity=""NOAltCapacity""/>       </DebtorName>     </Debtors>     <AuthorizingParty>       <AuthSecuredParty>         <OrganizationName>COMMODITY CREDIT CORPORATION</OrganizationName>       </AuthSecuredParty>     </AuthorizingParty>   <Acknowledgement><FileNumber>09050392</FileNumber><FileDate>20121019</FileDate><FileTime>2100</FileTime><FeeAmount>20.00</FeeAmount><AdditionalFees>0.00</AdditionalFees><FilingOffice>Illinois Secretary of State</FilingOffice><FileStatus Status=""Accepted""/></Acknowledgement></Record></Document>"

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

    Return sRtn
  End Function

  ' Display any validation errors.
  Private Shared Sub ValidationCallBack(sender As Object, e As ValidationEventArgs)
    'Console.WriteLine("Validation Error: {0}", e.Message)
    Throw New Exception("ValidationError: " & e.Message)
  End Sub

  Public Sub BuildHeader(ByVal sPacketNum As String)
    Dim header As XmlElement = doc.CreateElement("Header")
    Dim filer As XmlElement = doc.CreateElement("Filer")
    Dim names As XmlElement = doc.CreateElement("Names")
    Dim filer_org_name As XmlElement = doc.CreateElement("OrganizationName")
    filer_org_name.InnerText = "Identi-Check"
    Dim filer_mail_address As XmlElement = doc.CreateElement("MailAddress")
    filer_mail_address.InnerText = "3 North Old State Capitol Plaza"
    Dim filer_city As XmlElement = doc.CreateElement("City")
    filer_city.InnerText = "Springfield"
    Dim filer_state As XmlElement = doc.CreateElement("State")
    filer_state.InnerText = "IL"
    Dim filer_zip As XmlElement = doc.CreateElement("PostalCode")
    filer_zip.InnerText = "62701"
    'Dim filer_county As XmlElement = doc.CreateElement("County")
    'filer_county.InnerText = "84"
    Dim filer_country As XmlElement = doc.CreateElement("Country")
    filer_country.InnerText = "USA"
    'Dim filer_taxid As XmlElement = doc.CreateElement("TaxID")
    'Dim filer_org_type As XmlElement = doc.CreateElement("OrganizationalType")
    'filer_org_type.InnerText = "Corporation"
    'Dim filer_org_juris As XmlElement = doc.CreateElement("OrganizationalJuris")
    'filer_org_juris.InnerText = "IL"
    'Dim filer_org_id As XmlElement = doc.CreateElement("OrganizationalID")
    'filer_org_id.InnerText = ""
    'Dim filer_mark As XmlElement = doc.CreateElement("Mark")

    Dim filer_can As XmlElement = doc.CreateElement("ClientAccountNum")
    filer_can.InnerText = UCCXML_Acct_Num
    Dim filer_con_name As XmlElement = doc.CreateElement("ContactName")
    filer_con_name.InnerText = "Micah King"
    Dim filer_con_phone As XmlElement = doc.CreateElement("ContactPhone")
    filer_con_phone.InnerText = "217-753-4311"
    Dim filer_con_email As XmlElement = doc.CreateElement("ContactEmail")
    filer_con_email.InnerText = "micah@identi-check.com"
    Dim filer_con_fax As XmlElement = doc.CreateElement("ContactFax")
    filer_con_fax.InnerText = "217-753-3492"
    Dim filer_return_url As XmlElement = doc.CreateElement("ReturnURL")
    filer_return_url.InnerText = strAppURL & "ucc/sos_return.aspx"
    Dim filer_return_user As XmlElement = doc.CreateElement("ReturnUserID")
    filer_return_user.InnerText = "sos_return"
    Dim filer_return_pwd As XmlElement = doc.CreateElement("ReturnUserPWD")
    filer_return_pwd.InnerText = "d743bd67s"

    Dim packet_num As XmlElement = doc.CreateElement("PacketNum")
    packet_num.InnerText = sPacketNum
    Dim test As XmlElement = doc.CreateElement("Test")
    test.SetAttribute("Choice", UCCXML_Test)

    names.AppendChild(filer_org_name)
    names.AppendChild(filer_mail_address)
    names.AppendChild(filer_city)
    names.AppendChild(filer_state)
    names.AppendChild(filer_zip)
    'names.AppendChild(filer_county)
    names.AppendChild(filer_country)
    'names.AppendChild(filer_taxid)
    'names.AppendChild(filer_org_type)
    'names.AppendChild(filer_org_juris)
    'names.AppendChild(filer_org_id)
    'names.AppendChild(filer_mark)

    filer.AppendChild(names)
    filer.AppendChild(filer_can)
    filer.AppendChild(filer_con_name)
    filer.AppendChild(filer_con_phone)
    filer.AppendChild(filer_con_email)
    filer.AppendChild(filer_con_fax)
    filer.AppendChild(filer_return_url)
    filer.AppendChild(filer_return_user)
    filer.AppendChild(filer_return_pwd)

    header.AppendChild(filer)
    header.AppendChild(packet_num)
    header.AppendChild(test)
    root.AppendChild(header)
  End Sub

  Public Sub BuildFiling(ByVal sUF_ID As String)
    Dim sSQL As String = "Select uf.*, ufad.*, ufap.*, " & _
      "ud1.ud_id as ud1_id,ud1.ud_org_name as ud1_org_name,ud1.ud_ind_last_name as ud1_ind_last_name,ud1.ud_ind_first_name as ud1_ind_first_name,ud1.ud_ind_middle_name as ud1_ind_middle_name,ud1.ud_ind_suffix as ud1_ind_suffix,ud1.ud_mailing_address as ud1_mailing_address,ud1.ud_city as ud1_city,ud1.ud_state as ud1_state,ud1.ud_zipcode as ud1_zipcode,ud1.ud_country as ud1_country,ud1.ud_d1 as ud1_d1,ud1.ud_org_type as ud1_org_type,ud1.ud_org_jurisdiction as ud1_org_jurisdiction,ud1.ud_org_id as ud1_org_id,ud1.ud_org_id_none as ud1_org_id_none, " & _
      "ud2.ud_id as ud2_id,ud2.ud_org_name as ud2_org_name,ud2.ud_ind_last_name as ud2_ind_last_name,ud2.ud_ind_first_name as ud2_ind_first_name,ud2.ud_ind_middle_name as ud2_ind_middle_name,ud2.ud_ind_suffix as ud2_ind_suffix,ud2.ud_mailing_address as ud2_mailing_address,ud2.ud_city as ud2_city,ud2.ud_state as ud2_state,ud2.ud_zipcode as ud2_zipcode,ud2.ud_country as ud2_country,ud2.ud_d1 as ud2_d1,ud2.ud_org_type as ud2_org_type,ud2.ud_org_jurisdiction as ud2_org_jurisdiction,ud2.ud_org_id as ud2_org_id,ud2.ud_org_id_none as ud2_org_id_none, " & _
      "ud3.ud_id as ud3_id,ud3.ud_org_name as ud3_org_name,ud3.ud_ind_last_name as ud3_ind_last_name,ud3.ud_ind_first_name as ud3_ind_first_name,ud3.ud_ind_middle_name as ud3_ind_middle_name,ud3.ud_ind_suffix as ud3_ind_suffix,ud3.ud_mailing_address as ud3_mailing_address,ud3.ud_city as ud3_city,ud3.ud_state as ud3_state,ud3.ud_zipcode as ud3_zipcode,ud3.ud_country as ud3_country,ud3.ud_d1 as ud3_d1,ud3.ud_org_type as ud3_org_type,ud3.ud_org_jurisdiction as ud3_org_jurisdiction,ud3.ud_org_id as ud3_org_id,ud3.ud_org_id_none as ud3_org_id_none, " & _
      "ud4.ud_id as ud4_id,ud4.ud_org_name as ud4_org_name,ud4.ud_ind_last_name as ud4_ind_last_name,ud4.ud_ind_first_name as ud4_ind_first_name,ud4.ud_ind_middle_name as ud4_ind_middle_name,ud4.ud_ind_suffix as ud4_ind_suffix,ud4.ud_mailing_address as ud4_mailing_address,ud4.ud_city as ud4_city,ud4.ud_state as ud4_state,ud4.ud_zipcode as ud4_zipcode,ud4.ud_country as ud4_country,ud4.ud_d1 as ud4_d1,ud4.ud_org_type as ud4_org_type,ud4.ud_org_jurisdiction as ud4_org_jurisdiction,ud4.ud_org_id as ud4_org_id,ud4.ud_org_id_none as ud4_org_id_none, " & _
      "ud4.ud_id as ud4_id,ud4.ud_org_name as ud4_org_name,ud4.ud_ind_last_name as ud4_ind_last_name,ud4.ud_ind_first_name as ud4_ind_first_name,ud4.ud_ind_middle_name as ud4_ind_middle_name,ud4.ud_ind_suffix as ud4_ind_suffix,ud4.ud_mailing_address as ud4_mailing_address,ud4.ud_city as ud4_city,ud4.ud_state as ud4_state,ud4.ud_zipcode as ud4_zipcode,ud4.ud_country as ud4_country,ud4.ud_d1 as ud4_d1,ud4.ud_org_type as ud4_org_type,ud4.ud_org_jurisdiction as ud4_org_jurisdiction,ud4.ud_org_id as ud4_org_id,ud4.ud_org_id_none as ud4_org_id_none, " & _
      "ud5.ud_id as ud5_id,ud5.ud_org_name as ud5_org_name,ud5.ud_ind_last_name as ud5_ind_last_name,ud5.ud_ind_first_name as ud5_ind_first_name,ud5.ud_ind_middle_name as ud5_ind_middle_name,ud5.ud_ind_suffix as ud5_ind_suffix,ud5.ud_mailing_address as ud5_mailing_address,ud5.ud_city as ud5_city,ud5.ud_state as ud5_state,ud5.ud_zipcode as ud5_zipcode,ud5.ud_country as ud5_country,ud5.ud_d1 as ud5_d1,ud5.ud_org_type as ud5_org_type,ud5.ud_org_jurisdiction as ud5_org_jurisdiction,ud5.ud_org_id as ud5_org_id,ud5.ud_org_id_none as ud5_org_id_none, " & _
      "ud6.ud_id as ud6_id,ud6.ud_org_name as ud6_org_name,ud6.ud_ind_last_name as ud6_ind_last_name,ud6.ud_ind_first_name as ud6_ind_first_name,ud6.ud_ind_middle_name as ud6_ind_middle_name,ud6.ud_ind_suffix as ud6_ind_suffix,ud6.ud_mailing_address as ud6_mailing_address,ud6.ud_city as ud6_city,ud6.ud_state as ud6_state,ud6.ud_zipcode as ud6_zipcode,ud6.ud_country as ud6_country,ud6.ud_d1 as ud6_d1,ud6.ud_org_type as ud6_org_type,ud6.ud_org_jurisdiction as ud6_org_jurisdiction,ud6.ud_org_id as ud6_org_id,ud6.ud_org_id_none as ud6_org_id_none " & _
      "From ucc_financing as uf left outer join ucc_debtor as ud1 on uf.uf_debtor1 = ud1.ud_id " & _
      "left outer join ucc_debtor as ud2 on uf.uf_debtor2 = ud2.ud_id " & _
      "left outer join ucc_financing_ad as ufad on uf.uf_id = ufad_uf_id " & _
      "left outer join ucc_financing_ap as ufap on uf.uf_id = ufap_uf_id " & _
      "left outer join ucc_debtor as ud3 on ufad.ufad_debtor3 = ud3.ud_id " & _
      "left outer join ucc_debtor as ud4 on ufap.ufap_debtor4 = ud4.ud_id " & _
      "left outer join ucc_debtor as ud5 on ufap.ufap_debtor5 = ud5.ud_id " & _
      "left outer join ucc_debtor as ud6 on ufap.ufap_debtor6 = ud6.ud_id " & _
      "Where uf_id = " & sUF_ID
    Dim dtFile As DataTable = FillDataTable(sSQL)
    If dtFile.Rows.Count > 0 Then
      With dtFile.Rows(0)

        Dim record As XmlElement = doc.CreateElement("Record")
        Dim rec_seq_num As XmlElement = doc.CreateElement("SeqNumber")
        rec_seq_num.InnerText = "1"
        record.AppendChild(rec_seq_num)
        Dim rec_trans_type As XmlElement = doc.CreateElement("TransType")
        rec_trans_type.SetAttribute("Type", "Initial")
        record.AppendChild(rec_trans_type)
        Dim rec_submitter_ref As XmlElement = doc.CreateElement("SubmitterRef")
        rec_submitter_ref.InnerText = .Item("uf_reference_data") & ""
        record.AppendChild(rec_submitter_ref)
        Dim rec_alt_name_des As XmlElement = doc.CreateElement("AltNameDesignation")
        rec_alt_name_des.SetAttribute("AltName", "NOAltName")
        record.AppendChild(rec_alt_name_des)
        Dim rec_alt_filing_type As XmlElement = doc.CreateElement("AltFilingType")
        rec_alt_filing_type.SetAttribute("AltType", "NOAltType")
        record.AppendChild(rec_alt_filing_type)
        Dim rec_alt_filing_type1 As XmlElement = doc.CreateElement("AltFilingType1")
        rec_alt_filing_type1.SetAttribute("AltType", "NOAltType")
        record.AppendChild(rec_alt_filing_type1)
        '<AltNameDesignation AltName="NOAltName" /> 
        '<AltFilingType AltType="NOAltType" /> 

        'FileInRealEstate - not needed by fsa


        Dim rec_debtors As XmlElement = doc.CreateElement("Debtors")

        'if more than one debotr repeat DebtorName section
        If .Item("ud1_org_name") & "" <> "" Or .Item("ud1_ind_last_name") & "" <> "" Then
          rec_debtors.AppendChild(Build_Debtor_Name(.Item("ud1_org_name") & "", .Item("ud1_ind_last_name") & "", .Item("ud1_ind_first_name") & "", .Item("ud1_ind_middle_name") & "", .Item("ud1_ind_suffix") & "", .Item("ud1_mailing_address") & "", .Item("ud1_city") & "", .Item("ud1_state") & "", .Item("ud1_zipcode") & "", "", .Item("ud1_country") & "", "", .Item("ud1_org_type") & "", .Item("ud1_org_jurisdiction") & "", .Item("ud1_org_id") & "", "", "", ""))
        End If
        If .Item("ud2_org_name") & "" <> "" Or .Item("ud2_ind_last_name") & "" <> "" Then
          rec_debtors.AppendChild(Build_Debtor_Name(.Item("ud2_org_name") & "", .Item("ud2_ind_last_name") & "", .Item("ud2_ind_first_name") & "", .Item("ud2_ind_middle_name") & "", .Item("ud2_ind_suffix") & "", .Item("ud2_mailing_address") & "", .Item("ud2_city") & "", .Item("ud2_state") & "", .Item("ud2_zipcode") & "", "", .Item("ud2_country") & "", "", .Item("ud2_org_type") & "", .Item("ud2_org_jurisdiction") & "", .Item("ud2_org_id") & "", "", "", ""))
        End If
        If .Item("ud3_org_name") & "" <> "" Or .Item("ud3_ind_last_name") & "" <> "" Then
          rec_debtors.AppendChild(Build_Debtor_Name(.Item("ud3_org_name") & "", .Item("ud3_ind_last_name") & "", .Item("ud3_ind_first_name") & "", .Item("ud3_ind_middle_name") & "", .Item("ud3_ind_suffix") & "", .Item("ud3_mailing_address") & "", .Item("ud3_city") & "", .Item("ud3_state") & "", .Item("ud3_zipcode") & "", "", .Item("ud3_country") & "", "", .Item("ud3_org_type") & "", .Item("ud3_org_jurisdiction") & "", .Item("ud3_org_id") & "", "", "", ""))
        End If
        If .Item("ud4_org_name") & "" <> "" Or .Item("ud4_ind_last_name") & "" <> "" Then
          rec_debtors.AppendChild(Build_Debtor_Name(.Item("ud4_org_name") & "", .Item("ud4_ind_last_name") & "", .Item("ud4_ind_first_name") & "", .Item("ud4_ind_middle_name") & "", .Item("ud4_ind_suffix") & "", .Item("ud4_mailing_address") & "", .Item("ud4_city") & "", .Item("ud4_state") & "", .Item("ud4_zipcode") & "", "", .Item("ud4_country") & "", "", .Item("ud4_org_type") & "", .Item("ud4_org_jurisdiction") & "", .Item("ud4_org_id") & "", "", "", ""))
        End If
        If .Item("ud5_org_name") & "" <> "" Or .Item("ud5_ind_last_name") & "" <> "" Then
          rec_debtors.AppendChild(Build_Debtor_Name(.Item("ud5_org_name") & "", .Item("ud5_ind_last_name") & "", .Item("ud5_ind_first_name") & "", .Item("ud5_ind_middle_name") & "", .Item("ud5_ind_suffix") & "", .Item("ud5_mailing_address") & "", .Item("ud5_city") & "", .Item("ud5_state") & "", .Item("ud5_zipcode") & "", "", .Item("ud5_country") & "", "", .Item("ud5_org_type") & "", .Item("ud5_org_jurisdiction") & "", .Item("ud5_org_id") & "", "", "", ""))
        End If
        If .Item("ud6_org_name") & "" <> "" Or .Item("ud6_ind_last_name") & "" <> "" Then
          rec_debtors.AppendChild(Build_Debtor_Name(.Item("ud6_org_name") & "", .Item("ud6_ind_last_name") & "", .Item("ud6_ind_first_name") & "", .Item("ud6_ind_middle_name") & "", .Item("ud6_ind_suffix") & "", .Item("ud6_mailing_address") & "", .Item("ud6_city") & "", .Item("ud6_state") & "", .Item("ud6_zipcode") & "", "", .Item("ud6_country") & "", "", .Item("ud6_org_type") & "", .Item("ud6_org_jurisdiction") & "", .Item("ud6_org_id") & "", "", "", ""))
        End If

        record.AppendChild(rec_debtors)

        Dim rec_secured As XmlElement = doc.CreateElement("Secured")

        'repeat SecuredName for multiple secured
        If .Item("uf_secured_org_name") & "" <> "" Then 'Or .Item("uf_secured_ind_last_name") & "" <> ""
          'rec_secured.AppendChild(Build_Secured(.Item("uf_secured_org_name") & "", .Item("uf_secured_ind_last_name") & "", .Item("uf_secured_ind_first_name") & "", .Item("uf_secured_ind_middle_name") & "", .Item("uf_secured_ind_suffix") & "", .Item("uf_secured_mailing_address") & "", .Item("uf_secured_city") & "", .Item("uf_secured_state") & "", .Item("uf_secured_zipcode") & "", "", .Item("uf_secured_country") & "", "", .Item("uf_secured_org_type") & "", .Item("uf_secured_org_jurisdiction") & "", .Item("uf_secured_org_id") & ""))
          rec_secured.AppendChild(Build_Secured(.Item("uf_secured_org_name") & "", "", "", "", "", .Item("uf_secured_mailing_address") & "", .Item("uf_secured_city") & "", .Item("uf_secured_state") & "", .Item("uf_secured_zipcode") & "", "", .Item("uf_secured_country") & "", "", "", "", ""))
        End If

        record.AppendChild(rec_secured)

        Dim rec_collateral As XmlElement = doc.CreateElement("Collateral")
        Dim rec_collateral_text As XmlElement = doc.CreateElement("ColText")
        rec_collateral_text.AppendChild(doc.CreateTextNode("String"))
        'rec_collateral_text.Value = "Test, Nothing of importance."
        'Dim rec_collateral_text As XmlElement = doc.CreateElement("ColText")
        rec_collateral_text.InnerText = .Item("uf_finance_statement") & ""
        
        rec_collateral.AppendChild(rec_collateral_text)

        Dim rec_collateral_design As XmlElement = doc.CreateElement("CollateralDesignation")
        rec_collateral_design.SetAttribute("Designation", "NODesignation") 'NODesignation
        'can base64 encode a pdf file and attach
        'Dim rec_collateral_attach As XmlElement = doc.CreateElement("Attachment")
        'Dim rec_collateral_attach_mime As XmlElement = doc.CreateElement("MIMEType")
        'rec_collateral_attach_mime.SetAttribute("Type", "PDF")
        'rec_collateral_attach.AppendChild(rec_collateral_attach)
        'Dim rec_collateral_attach_text As XmlElement = doc.CreateElement("TextData")
        'rec_collateral_attach_text.innertext = "BASE64 encoded pdf file"
        'rec_collateral_attach.AppendChild(rec_collateral_attach_text)
        'rec_collateral.AppendChild(rec_collateral_attach)

        record.AppendChild(rec_collateral)
        record.AppendChild(rec_collateral_design)
        root.AppendChild(record)

      End With
    End If
    dtFile.Dispose()
    dtFile = Nothing

  End Sub

  Public Sub Build_Amendment(ByVal sU3_ID As String)
    Dim sSQL As String = "Select ucc3.*, u3ad.*, u3ap.*, " & _
      "ud1.ud_id as ud1_id,ud1.ud_org_name as ud1_org_name,ud1.ud_ind_last_name as ud1_ind_last_name,ud1.ud_ind_first_name as ud1_ind_first_name,ud1.ud_ind_middle_name as ud1_ind_middle_name,ud1.ud_ind_suffix as ud1_ind_suffix,ud1.ud_mailing_address as ud1_mailing_address,ud1.ud_city as ud1_city,ud1.ud_state as ud1_state,ud1.ud_zipcode as ud1_zipcode,ud1.ud_country as ud1_country,ud1.ud_d1 as ud1_d1,ud1.ud_org_type as ud1_org_type,ud1.ud_org_jurisdiction as ud1_org_jurisdiction,ud1.ud_org_id as ud1_org_id,ud1.ud_org_id_none as ud1_org_id_none, " & _
      "ud2.ud_id as ud2_id,ud2.ud_org_name as ud2_org_name,ud2.ud_ind_last_name as ud2_ind_last_name,ud2.ud_ind_first_name as ud2_ind_first_name,ud2.ud_ind_middle_name as ud2_ind_middle_name,ud2.ud_ind_suffix as ud2_ind_suffix,ud2.ud_mailing_address as ud2_mailing_address,ud2.ud_city as ud2_city,ud2.ud_state as ud2_state,ud2.ud_zipcode as ud2_zipcode,ud2.ud_country as ud2_country,ud2.ud_d1 as ud2_d1,ud2.ud_org_type as ud2_org_type,ud2.ud_org_jurisdiction as ud2_org_jurisdiction,ud2.ud_org_id as ud2_org_id,ud2.ud_org_id_none as ud2_org_id_none, " & _
      "ud3.ud_id as ud3_id,ud3.ud_org_name as ud3_org_name,ud3.ud_ind_last_name as ud3_ind_last_name,ud3.ud_ind_first_name as ud3_ind_first_name,ud3.ud_ind_middle_name as ud3_ind_middle_name,ud3.ud_ind_suffix as ud3_ind_suffix,ud3.ud_mailing_address as ud3_mailing_address,ud3.ud_city as ud3_city,ud3.ud_state as ud3_state,ud3.ud_zipcode as ud3_zipcode,ud3.ud_country as ud3_country,ud3.ud_d1 as ud3_d1,ud3.ud_org_type as ud3_org_type,ud3.ud_org_jurisdiction as ud3_org_jurisdiction,ud3.ud_org_id as ud3_org_id,ud3.ud_org_id_none as ud3_org_id_none, " & _
      "ud4.ud_id as ud4_id,ud4.ud_org_name as ud4_org_name,ud4.ud_ind_last_name as ud4_ind_last_name,ud4.ud_ind_first_name as ud4_ind_first_name,ud4.ud_ind_middle_name as ud4_ind_middle_name,ud4.ud_ind_suffix as ud4_ind_suffix,ud4.ud_mailing_address as ud4_mailing_address,ud4.ud_city as ud4_city,ud4.ud_state as ud4_state,ud4.ud_zipcode as ud4_zipcode,ud4.ud_country as ud4_country,ud4.ud_d1 as ud4_d1,ud4.ud_org_type as ud4_org_type,ud4.ud_org_jurisdiction as ud4_org_jurisdiction,ud4.ud_org_id as ud4_org_id,ud4.ud_org_id_none as ud4_org_id_none " & _
      "From ucc3 left outer join ucc_debtor as ud1 on ucc3.u3_new_debtor = ud1.ud_id " & _
      "left outer join ucc3_ad as u3ad on ucc3.u3_id = u3ad_u3_id " & _
      "left outer join ucc3_ap as u3ap on ucc3.u3_id = u3ap_u3_id " & _
      "left outer join ucc_debtor as ud2 on u3ap.u3ap_debtor2 = ud2.ud_id " & _
      "left outer join ucc_debtor as ud3 on u3ap.u3ap_debtor3 = ud3.ud_id " & _
      "left outer join ucc_debtor as ud4 on u3ap.u3ap_debtor4 = ud4.ud_id " & _
      "Where u3_id = " & sU3_ID
    Dim dtFile As DataTable = FillDataTable(sSQL)
    If dtFile.Rows.Count > 0 Then
      With dtFile.Rows(0)

        'Illinois only allows one action and one change on an Amendment
        'Can do (Continuation or Termination or Assignment or ChangeTo (Debtor or Secured Party or Collateral))
        'Actions = DebtorAdd,DebtorChange,DebtorDelete,
        'SecuredPartyAdd,SecuredPartyChange,SecuredPartyDelete,
        'CollateralAdd,CollateralChange,CollateralDelete,CollateralRestate, CollateralAssign,
        'NOAction
        'AmendmentTypes = AmendmentCollateral, AmendmentParties
        'Assignment, Correct, Continuation, Correction
        'TerminationDebtor, TerminationSecuredParty
        'OfficerStatement, NOType

        'Required Fields:
        'X - All require these: AmendType, AmendAction, InitialFileNumber, SubmitterRef, AuthorizingParty
        ' - Continuation - No addtnl
        ' - Termination - No addtnl
        ' - Assignment - Secured, Assignor
        ' - DebtorChange - CurrentName, Debtors
        ' - SecuredPartyChange - CurrentName, Secured
        ' - CollateralChange - Collateral
        Dim blnNeedAssignor As Boolean = False, blnNeedSecured As Boolean = False
        Dim blnNeedCurrentName As Boolean = False, blnNeedDebtors As Boolean = False
        Dim blnNeedCollChange As Boolean = False

        '.Item("u3ad_info") & ""
        Dim sAmendType As String = ""
        Dim sAmendAction As String = ""
        If .Item("u3_termination") & "" = "Y" Then 'term
          sAmendType = AmendmentType.TerminationSecuredParty.ToString
          sAmendAction = AmendmentAction.NOAction.ToString

        ElseIf .Item("u3_continuation") & "" = "Y" Then 'continue
          sAmendType = AmendmentType.Continuation.ToString
          sAmendAction = AmendmentAction.NOAction.ToString
        ElseIf .Item("u3_assignment") & "" = "Y" Then 'assignment
          sAmendType = AmendmentType.Assignment.ToString
          sAmendAction = AmendmentAction.NOAction.ToString
          blnNeedAssignor = True
          blnNeedSecured = True
          'needs Assignor/Names(many)
          'needs Secured/SecuredName/Names(many)
        ElseIf .Item("u3_amendment_affects") & "" = "S" Then
          'secured party
          blnNeedCurrentName = True
          blnNeedSecured = True
          If .Item("u3_amendment") & "" = "C" Then
            'change name/address
            sAmendType = AmendmentType.AmendmentParties.ToString
            sAmendAction = AmendmentAction.SecuredPartyChange.ToString
          ElseIf .Item("u3_amendment") & "" = "D" Then
            'delete name - use old
            sAmendType = AmendmentType.AmendmentParties.ToString
            sAmendAction = AmendmentAction.SecuredPartyDelete.ToString
          ElseIf .Item("u3_amendment") & "" = "A" Then
            'add from new 7a or 7b, and 7c and 7e-g
            sAmendType = AmendmentType.AmendmentParties.ToString
            sAmendAction = AmendmentAction.SecuredPartyAdd.ToString
          End If
        ElseIf .Item("u3_amendment_affects") & "" = "D" Then
          'debtor
          blnNeedCurrentName = True
          blnNeedDebtors = True
          If .Item("u3_amendment") & "" = "C" Then
            'change name/address
            sAmendType = AmendmentType.AmendmentParties.ToString
            sAmendAction = AmendmentAction.DebtorChange.ToString
          ElseIf .Item("u3_amendment") & "" = "D" Then
            'delete name - use old
            sAmendType = AmendmentType.AmendmentParties.ToString
            sAmendAction = AmendmentAction.DebtorDelete.ToString
            blnNeedDebtors = False
          ElseIf .Item("u3_amendment") & "" = "A" Then
            'add from new 7a or 7b, and 7c and 7e-g
            sAmendType = AmendmentType.AmendmentParties.ToString
            sAmendAction = AmendmentAction.DebtorAdd.ToString
          End If
        ElseIf .Item("u3_collateral_change") & "" = "D" Then
          sAmendType = AmendmentType.AmendmentCollateral.ToString
          sAmendAction = AmendmentAction.CollateralDelete.ToString
          blnNeedCollChange = True
        ElseIf .Item("u3_collateral_change") & "" = "A" Then
          sAmendType = AmendmentType.AmendmentCollateral.ToString
          sAmendAction = AmendmentAction.CollateralAdd.ToString
          blnNeedCollChange = True
        ElseIf .Item("u3_collateral_change") & "" = "R" Then
          sAmendType = AmendmentType.AmendmentCollateral.ToString
          sAmendAction = AmendmentAction.CollateralRestate.ToString
          blnNeedCollChange = True
        ElseIf .Item("u3_collateral_change") & "" = "S" Then
          sAmendType = AmendmentType.AmendmentCollateral.ToString
          sAmendAction = AmendmentAction.CollateralAssign.ToString
          blnNeedCollChange = True
        Else
          '.Item("u3_collateral_change") = "D","A","R","S"
          sAmendType = AmendmentType.NOType.ToString
          sAmendAction = AmendmentAction.NOAction.ToString
        End If

        Dim record As XmlElement = doc.CreateElement("Record")
        Dim rec_seq_num As XmlElement = doc.CreateElement("SeqNumber")
        rec_seq_num.InnerText = "1"
        record.AppendChild(rec_seq_num)
        Dim rec_trans_type As XmlElement = doc.CreateElement("TransType")
        rec_trans_type.SetAttribute("Type", "Amendment")
        record.AppendChild(rec_trans_type)
        Dim rec_amend_type As XmlElement = doc.CreateElement("AmendmentType")
        rec_amend_type.SetAttribute("Type", sAmendType)
        record.AppendChild(rec_amend_type)
        Dim rec_amend_action As XmlElement = doc.CreateElement("AmendmentAction")
        rec_amend_action.SetAttribute("Action", sAmendAction)
        record.AppendChild(rec_amend_action)
        Dim rec_init_file_num As XmlElement = doc.CreateElement("InitialFileNumber")
        rec_init_file_num.InnerText = .Item("u3_initial_file_no") & ""
        record.AppendChild(rec_init_file_num)
        'InitialFileDate 'not required by IL
        Dim rec_submitter_ref As XmlElement = doc.CreateElement("SubmitterRef")
        If .Item("u3_reference_data") & "" <> "" Then rec_submitter_ref.InnerText = .Item("u3_reference_data") & ""
        record.AppendChild(rec_submitter_ref)
        'ActionCode

        'Dim rec_alt_name_des As XmlElement = doc.CreateElement("AltNameDesignation")
        'rec_alt_name_des.SetAttribute("AltName", "NOAltName")
        'record.AppendChild(rec_alt_name_des)
        'Dim rec_alt_filing_type As XmlElement = doc.CreateElement("AltFilingType")
        'rec_alt_filing_type.SetAttribute("AltType", "NOAltType")
        'record.AppendChild(rec_alt_filing_type)
        'Dim rec_alt_filing_type1 As XmlElement = doc.CreateElement("AltFilingType1")
        'rec_alt_filing_type1.SetAttribute("AltType", "NOAltType")
        'record.AppendChild(rec_alt_filing_type1)

        '<AltNameDesignation AltName="NOAltName"/>
        '<AltFilingType AltType="NOAltType"/>
        '<AltFilingType1 AltType="NOAltType"/>


        If .Item("u3_real_estate") & "" = "Y" Then
          Dim rec_alt_name_des As XmlElement = doc.CreateElement("AltNameDesignation")
          rec_alt_name_des.SetAttribute("AltName", "NOAltName")
          record.AppendChild(rec_alt_name_des)
          Dim rec_alt_filing_type As XmlElement = doc.CreateElement("AltFilingType")
          rec_alt_filing_type.SetAttribute("AltType", "NOAltType")
          record.AppendChild(rec_alt_filing_type)
          Dim rec_alt_filing_type1 As XmlElement = doc.CreateElement("AltFilingType1")
          rec_alt_filing_type1.SetAttribute("AltType", "NOAltType")
          record.AppendChild(rec_alt_filing_type1)


          Dim rec_file_realestate As XmlElement = doc.CreateElement("FileInRealEstate") 'FileInRealEstate element
          Dim rec_re_filed As XmlElement = doc.CreateElement("Filed") '-> Filed
          rec_re_filed.SetAttribute("Filed", "NotFiled")
          rec_file_realestate.AppendChild(rec_re_filed)

          Dim rec_re_desig As XmlElement = doc.CreateElement("RealEstateDesignation") '-> Designation - attribute Type
          'u3ad_covers = "T", "A" or "F"
          Dim sCovers As String = .Item("u3ad_covers") & ""
          If sCovers.Trim <> "" Then
            Select Case sCovers
              Case "T"
                rec_re_desig.SetAttribute("Type", "Timber")
              Case "A"
                rec_re_desig.SetAttribute("Type", "AsExtractedCollateral")
              Case "F"
                rec_re_desig.SetAttribute("Type", "Fixtures")
              Case Else
                rec_re_desig.SetAttribute("Type", "NOType")
            End Select
          Else
            rec_re_desig.SetAttribute("Type", "NOType")
          End If
          rec_file_realestate.AppendChild(rec_re_desig)

          Dim rec_re_desc As XmlElement = doc.CreateElement("RealEstateDescription") 'RealEstateDescription
          rec_re_desc.InnerText = .Item("u3ad_real_estate") & ""
          rec_file_realestate.AppendChild(rec_re_desc)

          If .Item("u3ad_record_owner") & "" <> "" Then
            Dim rec_re_names As XmlElement = doc.CreateElement("RealEstateNames") 'Names
            rec_re_names.InnerText = .Item("u3ad_record_owner") & ""
            rec_file_realestate.AppendChild(rec_re_names)
          End If

          record.AppendChild(rec_file_realestate)
        End If


        'CurrentName
        '->OrganizationName -this or IndividiualName
        '->IndividiualName - this or OrganizationName
        '->->LastName, FirstName, MiddleName, suffix
        If blnNeedCurrentName Then
          Dim rec_current_name As XmlElement = doc.CreateElement("CurrentName")
          
          If .Item("u3_old_org_name") & "" <> "" Then
            Dim rec_current_name_org_name As XmlElement = doc.CreateElement("OrganizationName")
            rec_current_name_org_name.InnerText = .Item("u3_old_org_name") & ""
            rec_current_name.AppendChild(rec_current_name_org_name)
          Else
            Dim rec_current_name_ind_name As XmlElement = doc.CreateElement("IndividualName")
            Dim rec_current_name_ind_last_name As XmlElement = doc.CreateElement("LastName")
            rec_current_name_ind_last_name.InnerText = .Item("u3_old_ind_last_name") & ""
            rec_current_name_ind_name.AppendChild(rec_current_name_ind_last_name)

            Dim rec_current_name_ind_first_name As XmlElement = doc.CreateElement("FirstName")
            rec_current_name_ind_first_name.InnerText = .Item("u3_old_ind_first_name") & ""
            rec_current_name_ind_name.AppendChild(rec_current_name_ind_first_name)

            Dim rec_current_name_ind_middle_name As XmlElement = doc.CreateElement("MiddleName")
            rec_current_name_ind_middle_name.InnerText = .Item("u3_old_ind_middle_name") & ""
            rec_current_name_ind_name.AppendChild(rec_current_name_ind_middle_name)

            Dim rec_current_name_ind_suffix As XmlElement = doc.CreateElement("Suffix")
            rec_current_name_ind_suffix.InnerText = .Item("u3_old_ind_suffix") & ""
            rec_current_name_ind_name.AppendChild(rec_current_name_ind_suffix)

            rec_current_name.AppendChild(rec_current_name_ind_name)
          End If
          record.AppendChild(rec_current_name)
        End If

        'Debtors
        '->DebtorName - multiple
        '-> -> Names
        '-> -> DebtorAltCapacity - attribute AltCapacity
        '-> -> Not-Indexed-Reason?
        '-> -> Trust
        '-> -> TrustDate
        If blnNeedDebtors Then
          Dim rec_debtors As XmlElement = doc.CreateElement("Debtors")
          If .Item("ud1_org_name") & "" <> "" Or .Item("ud1_ind_last_name") & "" <> "" Then
            rec_debtors.AppendChild(Build_Debtor_Name(.Item("ud1_org_name") & "", .Item("ud1_ind_last_name") & "", .Item("ud1_ind_first_name") & "", .Item("ud1_ind_middle_name") & "", .Item("ud1_ind_suffix") & "", .Item("ud1_mailing_address") & "", .Item("ud1_city") & "", .Item("ud1_state") & "", .Item("ud1_zipcode") & "", "", .Item("ud1_country") & "", "", .Item("ud1_org_type") & "", .Item("ud1_org_jurisdiction") & "", .Item("ud1_org_id") & "", "", "", ""))
          End If

          If .Item("ud2_org_name") & "" <> "" Or .Item("ud2_ind_last_name") & "" <> "" Then
            rec_debtors.AppendChild(Build_Debtor_Name(.Item("ud2_org_name") & "", .Item("ud2_ind_last_name") & "", .Item("ud2_ind_first_name") & "", .Item("ud2_ind_middle_name") & "", .Item("ud2_ind_suffix") & "", .Item("ud2_mailing_address") & "", .Item("ud2_city") & "", .Item("ud2_state") & "", .Item("ud2_zipcode") & "", "", .Item("ud2_country") & "", "", .Item("ud2_org_type") & "", .Item("ud2_org_jurisdiction") & "", .Item("ud2_org_id") & "", "", "", ""))
          End If
          If .Item("ud3_org_name") & "" <> "" Or .Item("ud3_ind_last_name") & "" <> "" Then
            rec_debtors.AppendChild(Build_Debtor_Name(.Item("ud3_org_name") & "", .Item("ud3_ind_last_name") & "", .Item("ud3_ind_first_name") & "", .Item("ud3_ind_middle_name") & "", .Item("ud3_ind_suffix") & "", .Item("ud3_mailing_address") & "", .Item("ud3_city") & "", .Item("ud3_state") & "", .Item("ud3_zipcode") & "", "", .Item("ud3_country") & "", "", .Item("ud3_org_type") & "", .Item("ud3_org_jurisdiction") & "", .Item("ud3_org_id") & "", "", "", ""))
          End If
          If .Item("ud4_org_name") & "" <> "" Or .Item("ud4_ind_last_name") & "" <> "" Then
            rec_debtors.AppendChild(Build_Debtor_Name(.Item("ud4_org_name") & "", .Item("ud4_ind_last_name") & "", .Item("ud4_ind_first_name") & "", .Item("ud4_ind_middle_name") & "", .Item("ud4_ind_suffix") & "", .Item("ud4_mailing_address") & "", .Item("ud4_city") & "", .Item("ud4_state") & "", .Item("ud4_zipcode") & "", "", .Item("ud4_country") & "", "", .Item("ud4_org_type") & "", .Item("ud4_org_jurisdiction") & "", .Item("ud4_org_id") & "", "", "", ""))
          End If

          record.AppendChild(rec_debtors)
        End If

        'Secured
        '->SecuredName - multiple
        '-> -> Names
        '-> -> Not-Indexed-Reason?
        If blnNeedSecured Then
          Dim rec_secured As XmlElement = doc.CreateElement("Secured")
          'repeat SecuredName for multiple secured
          If .Item("ud1_org_name") & "" <> "" Then 'Or .Item("uf_secured_ind_last_name") & "" <> ""
            'rec_secured.AppendChild(Build_Secured(.Item("uf_secured_org_name") & "", .Item("uf_secured_ind_last_name") & "", .Item("uf_secured_ind_first_name") & "", .Item("uf_secured_ind_middle_name") & "", .Item("uf_secured_ind_suffix") & "", .Item("uf_secured_mailing_address") & "", .Item("uf_secured_city") & "", .Item("uf_secured_state") & "", .Item("uf_secured_zipcode") & "", "", .Item("uf_secured_country") & "", "", .Item("uf_secured_org_type") & "", .Item("uf_secured_org_jurisdiction") & "", .Item("uf_secured_org_id") & ""))
            rec_secured.AppendChild(Build_Secured(.Item("ud1_org_name") & "", .Item("ud1_ind_last_name") & "", .Item("ud1_ind_first_name") & "", .Item("ud1_ind_middle_name") & "", .Item("ud1_ind_suffix") & "", .Item("ud1_mailing_address") & "", .Item("ud1_city") & "", .Item("ud1_state") & "", .Item("ud1_zipcode") & "", "", .Item("ud1_country") & "", "", .Item("ud1_org_type") & "", .Item("ud1_org_jurisdiction") & "", .Item("ud1_org_id") & ""))
          End If

          record.AppendChild(rec_secured)
        End If

        'Assignor
        '-> Names - multiple
        If blnNeedAssignor Then
          Dim rec_assignor As XmlElement = doc.CreateElement("Assignor")
          If .Item("u3_secured_org_name") & "" <> "" Then 'Or .Item("uf_secured_ind_last_name") & "" <> ""
            rec_assignor.AppendChild(Build_Secured(.Item("u3_secured_org_name") & "", "", "", "", "", .Item("u3_secured_mailing_address") & "", .Item("u3_secured_city") & "", .Item("u3_secured_state") & "", .Item("u3_secured_zipcode") & "", "", .Item("u3_secured_country") & "", "", "Corporation", "IL", "", True))
          End If
          record.AppendChild(rec_assignor)
        End If


        'Collateral
        '-> ColText
        '-> FSAProducts - not used in IL
        '-> -> Name-Code - multiple
        '-> -> -> Years 
        '-> -> -> -> Year(4) - multiple
        '-> -> -> Counties
        '-> -> -> -> County(50) - multiple
        '-> -> -> Unit(50), Quantity(10), Location(100), Description(100)
        '-> Attachment
        '-> -> MimeType - attribute Type - from list of attribute type
        '-> -> TextData - base64 encoded pdf document -~1.5mb max
        If blnNeedCollChange Then
          '.Item("u3_collateral_change") = "D","A","R","S"
          Dim rec_collateral As XmlElement = doc.CreateElement("Collateral")
          Dim rec_collateral_text As XmlElement = doc.CreateElement("ColText")
          If .Item("u3_collateral") & "" <> "" Then rec_collateral_text.InnerText = .Item("u3_collateral") & ""
          rec_collateral.AppendChild(rec_collateral_text)
          record.AppendChild(rec_collateral)
        End If

        'AuthorizingParty
        '-> AuthSecuredParty - either this or AuthDebtor
        '-> -> OrganizationName
        '-> -> IndividualName
        '-> -> -> LastName, FirstName, MiddleName, Suffix
        '-> AuthDebtor - either this or AuthSecuredParty
        '-> -> OrganizationName
        '-> -> IndividualName
        '-> -> -> LastName, FirstName, MiddleName, Suffix
        Dim rec_auth_party As XmlElement = doc.CreateElement("AuthorizingParty")
        Dim rec_auth_secured_party As XmlElement = doc.CreateElement("AuthSecuredParty")
        Dim rec_auth_secured_party_org_name As XmlElement = doc.CreateElement("OrganizationName")
        rec_auth_secured_party_org_name.InnerText = .Item("u3_secured_org_name") & ""
        rec_auth_secured_party.AppendChild(rec_auth_secured_party_org_name)
        rec_auth_party.AppendChild(rec_auth_secured_party)
        record.AppendChild(rec_auth_party)

        'Dim rec_miscinfo As XmlElement = doc.CreateElement("MiscInfo")
        'If .Item("u3ad_info") & "" <> "" Then rec_miscinfo.InnerText = .Item("u3ad_info") & ""
        'record.AppendChild(rec_miscinfo)


        root.AppendChild(record)

      End With
    End If
    dtFile.Dispose()
    dtFile = Nothing
  End Sub

  Public Function Build_Debtor_Name(ByVal sOrgName As String, ByVal sIndLastName As String, ByVal sIndFirstName As String, _
    ByVal sIndMiddleName As String, ByVal sIndSuffix As String, ByVal sMailAddress As String, ByVal sCity As String, _
    ByVal sState As String, ByVal sPostalCode As String, ByVal sCounty As String, ByVal sCountry As String, _
    ByVal sTaxID As String, ByVal sOrgType As String, ByVal sOrgJuris As String, ByVal sOrgID As String, _
    ByVal sDebtorAltCap As String, ByVal sTrust As String, ByVal sTrustDate As String) As XmlElement

    Dim rec_debt_name As XmlElement = doc.CreateElement("DebtorName")
    Dim rec_debt_names As XmlElement = doc.CreateElement("Names")

    If sOrgName <> "" Then
      Dim debtor1_org_name As XmlElement = doc.CreateElement("OrganizationName")
      debtor1_org_name.InnerText = sOrgName
      rec_debt_names.AppendChild(debtor1_org_name)
    Else
      Dim debtor1_ind_name As XmlElement = doc.CreateElement("IndividualName")
      Dim debtor1_ind_last_name As XmlElement = doc.CreateElement("LastName")
      debtor1_ind_last_name.InnerText = sIndLastName
      debtor1_ind_name.AppendChild(debtor1_ind_last_name)

      Dim debtor1_ind_first_name As XmlElement = doc.CreateElement("FirstName")
      debtor1_ind_first_name.InnerText = sIndFirstName
      debtor1_ind_name.AppendChild(debtor1_ind_first_name)

      Dim debtor1_ind_middle_name As XmlElement = doc.CreateElement("MiddleName")
      debtor1_ind_middle_name.InnerText = sIndMiddleName
      debtor1_ind_name.AppendChild(debtor1_ind_middle_name)

      Dim debtor1_ind_suffix As XmlElement = doc.CreateElement("Suffix")
      debtor1_ind_suffix.InnerText = sIndSuffix
      debtor1_ind_name.AppendChild(debtor1_ind_suffix)

      rec_debt_names.AppendChild(debtor1_ind_name)
    End If
    
    Dim debtor1_mail_address As XmlElement = doc.CreateElement("MailAddress")
    debtor1_mail_address.InnerText = sMailAddress
    rec_debt_names.AppendChild(debtor1_mail_address)
    Dim debtor1_city As XmlElement = doc.CreateElement("City")
    debtor1_city.InnerText = sCity
    rec_debt_names.AppendChild(debtor1_city)
    Dim debtor1_state As XmlElement = doc.CreateElement("State")
    debtor1_state.InnerText = sState
    rec_debt_names.AppendChild(debtor1_state)
    Dim debtor1_zip As XmlElement = doc.CreateElement("PostalCode")
    debtor1_zip.InnerText = sPostalCode
    rec_debt_names.AppendChild(debtor1_zip)
    'Dim debtor1_county As XmlElement = doc.CreateElement("County")
    'debtor1_county.InnerText = sCounty
    'rec_debt_names.AppendChild(debtor1_county)
    Dim debtor1_country As XmlElement = doc.CreateElement("Country")
    If sCountry <> "" Then
      debtor1_country.InnerText = sCountry
    Else
      debtor1_country.InnerText = "USA"
    End If
    rec_debt_names.AppendChild(debtor1_country)
    'Dim debtor1_taxid As XmlElement = doc.CreateElement("TaxID")
    'rec_debt_names.AppendChild(debtor1_taxid)
    'If sOrgName <> "" Then
    '  Dim debtor1_org_type As XmlElement = doc.CreateElement("OrganizationalType")
    '  debtor1_org_type.SetAttribute("Type", sOrgType)
    '  'debtor1_org_type.InnerText = sOrgType
    '  rec_debt_names.AppendChild(debtor1_org_type)
    '  Dim debtor1_org_juris As XmlElement = doc.CreateElement("OrganizationalJuris")
    '  If sOrgJuris <> "" Then debtor1_org_juris.InnerText = sOrgJuris
    '  rec_debt_names.AppendChild(debtor1_org_juris)
    '  Dim debtor1_org_id As XmlElement = doc.CreateElement("OrganizationalID")
    '  If sOrgID <> "" Then
    '    debtor1_org_id.InnerText = sOrgID
    '  Else
    '    debtor1_org_id.InnerText = "None"
    '  End If
    '  rec_debt_names.AppendChild(debtor1_org_id)
    'Else
    '  Dim debtor1_org_type As XmlElement = doc.CreateElement("OrganizationalType")
    '  debtor1_org_type.SetAttribute("Type", "NOType")
    '  rec_debt_names.AppendChild(debtor1_org_type)
    '  Dim debtor1_org_juris As XmlElement = doc.CreateElement("OrganizationalJuris")
    '  rec_debt_names.AppendChild(debtor1_org_juris)
    '  Dim debtor1_org_id As XmlElement = doc.CreateElement("OrganizationalID")
    '  debtor1_org_id.InnerText = "None"
    '  rec_debt_names.AppendChild(debtor1_org_id)
    'End If
    'Dim debtor1_mark As XmlElement = doc.CreateElement("Mark")
    'rec_debt_names.AppendChild(debtor1_mark)

    rec_debt_name.AppendChild(rec_debt_names)

    'Dim debtor1_alt_cap As XmlElement = doc.CreateElement("DebtorAltCapacity")
    'debtor1_alt_cap.SetAttribute("AltCapacity", "NOAltCapacity")
    'rec_debt_name.AppendChild(debtor1_alt_cap)

    Return rec_debt_name
  End Function

  Public Function Build_Secured(ByVal sOrgName As String, ByVal sIndLastName As String, ByVal sIndFirstName As String, _
    ByVal sIndMiddleName As String, ByVal sIndSuffix As String, ByVal sMailAddress As String, ByVal sCity As String, _
    ByVal sState As String, ByVal sPostalCode As String, ByVal sCounty As String, ByVal sCountry As String, _
    ByVal sTaxID As String, ByVal sOrgType As String, ByVal sOrgJuris As String, ByVal sOrgID As String, Optional ByVal blnAssignor As Boolean = False) As XmlElement

    Dim rec_sec_name As XmlElement = doc.CreateElement("SecuredName")
    Dim rec_sec_names As XmlElement = doc.CreateElement("Names")

    If sOrgName <> "" Then
      Dim secured1_org_name As XmlElement = doc.CreateElement("OrganizationName")
      secured1_org_name.InnerText = sOrgName
      rec_sec_names.AppendChild(secured1_org_name)
    Else
      Dim secured1_ind_name As XmlElement = doc.CreateElement("IndividualName")
      Dim secured1_ind_last_name As XmlElement = doc.CreateElement("LastName")
      secured1_ind_last_name.InnerText = sIndLastName
      secured1_ind_name.AppendChild(secured1_ind_last_name)

      Dim secured1_ind_first_name As XmlElement = doc.CreateElement("FirstName")
      secured1_ind_first_name.InnerText = sIndFirstName
      secured1_ind_name.AppendChild(secured1_ind_first_name)

      Dim secured1_ind_middle_name As XmlElement = doc.CreateElement("MiddleName")
      secured1_ind_middle_name.InnerText = sIndMiddleName
      secured1_ind_name.AppendChild(secured1_ind_middle_name)

      Dim secured1_ind_suffix As XmlElement = doc.CreateElement("Suffix")
      secured1_ind_suffix.InnerText = sIndSuffix
      secured1_ind_name.AppendChild(secured1_ind_suffix)

      rec_sec_names.AppendChild(secured1_ind_name)
    End If


    Dim secured1_mail_address As XmlElement = doc.CreateElement("MailAddress")
    secured1_mail_address.InnerText = sMailAddress
    rec_sec_names.AppendChild(secured1_mail_address)
    Dim secured1_city As XmlElement = doc.CreateElement("City")
    secured1_city.InnerText = sCity
    rec_sec_names.AppendChild(secured1_city)
    Dim secured1_state As XmlElement = doc.CreateElement("State")
    secured1_state.InnerText = sState
    rec_sec_names.AppendChild(secured1_state)
    Dim secured1_zip As XmlElement = doc.CreateElement("PostalCode")
    secured1_zip.InnerText = sPostalCode
    rec_sec_names.AppendChild(secured1_zip)
    'Dim secured1_county As XmlElement = doc.CreateElement("County")
    'If sCounty <> "" Then secured1_county.InnerText = sCounty
    'rec_sec_names.AppendChild(secured1_county)
    Dim secured1_country As XmlElement = doc.CreateElement("Country")
    secured1_country.InnerText = sCountry
    rec_sec_names.AppendChild(secured1_country)
    'Dim secured1_taxid As XmlElement = doc.CreateElement("TaxID")
    'rec_sec_names.AppendChild(secured1_taxid)
    'Dim secured1_mark As XmlElement = doc.CreateElement("Mark")
    'rec_sec_names.AppendChild(secured1_mark)
    'If False Then 'sOrgName <> "" Then
    '  Dim secured1_org_type As XmlElement = doc.CreateElement("OrganizationalType")
    '  secured1_org_type.SetAttribute("Type", "Corporation")
    '  'secured1_org_type.InnerText = sOrgType
    '  rec_sec_names.AppendChild(secured1_org_type)
    '  Dim secured1_org_juris As XmlElement = doc.CreateElement("OrganizationalJuris")
    '  'secured1_org_juris.InnerText = sOrgJuris
    '  rec_sec_names.AppendChild(secured1_org_juris)
    '  Dim secured1_org_id As XmlElement = doc.CreateElement("OrganizationalID")
    '  'secured1_org_id.InnerText = sOrgID
    '  rec_sec_names.AppendChild(secured1_org_id)
    'End If

    If blnAssignor Then
      'rec_sec_name.AppendChild(rec_sec_names)
      Return rec_sec_names
    Else
      rec_sec_name.AppendChild(rec_sec_names)
      Return rec_sec_name
    End If
    
  End Function

  Public Sub BuildAmendment()
    Dim record As XmlElement = doc.CreateElement("Record")
    Dim rec_seq_num As XmlElement = doc.CreateElement("SeqNumber")
    rec_seq_num.InnerText = "1"
    record.AppendChild(rec_seq_num)
    Dim rec_trans_type As XmlElement = doc.CreateElement("TransType")
    rec_trans_type.SetAttribute("Type", "Amendment")
    record.AppendChild(rec_trans_type)

    Dim rec_amend_type As XmlElement = doc.CreateElement("AmendmentType")
    rec_trans_type.SetAttribute("Type", AmendmentType.Assignment.ToString)
    record.AppendChild(rec_trans_type)
    Dim rec_amend_action As XmlElement = doc.CreateElement("AmendmentAction")
    rec_trans_type.SetAttribute("Action", AmendmentAction.NOAction.ToString)
    record.AppendChild(rec_trans_type)
    Dim rec_initial_file As XmlElement = doc.CreateElement("InitialFileNumber")
    rec_initial_file.InnerText = "1234567"
    record.AppendChild(rec_initial_file)
    Dim rec_initial_date As XmlElement = doc.CreateElement("InitialFileDate")
    record.AppendChild(rec_initial_date)

    Dim rec_submitter_ref As XmlElement = doc.CreateElement("SubmitterRef")
    rec_submitter_ref.InnerText = ""
    record.AppendChild(rec_submitter_ref)
    Dim rec_alt_name As XmlElement = doc.CreateElement("AltNameDesignation")
    rec_alt_name.SetAttribute("AltName", "NOAltName")
    record.AppendChild(rec_alt_name)
    Dim rec_alt_filing_type As XmlElement = doc.CreateElement("AltFilingType")
    rec_alt_filing_type.SetAttribute("AltType", "NOAltType")
    record.AppendChild(rec_alt_filing_type)

    Dim rec_debtors As XmlElement = doc.CreateElement("Debtors")
    Dim rec_debt_name As XmlElement = doc.CreateElement("DebtorName")
    Dim rec_debt_names As XmlElement = doc.CreateElement("Names")

    Dim debtor1_org_name As XmlElement = doc.CreateElement("OrganizationName")
    debtor1_org_name.InnerText = "Debtor"
    rec_debt_names.AppendChild(debtor1_org_name)
    Dim debtor1_mail_address As XmlElement = doc.CreateElement("MailAddress")
    debtor1_mail_address.InnerText = "3 North Old State Capitol Plaza"
    rec_debt_names.AppendChild(debtor1_mail_address)
    Dim debtor1_city As XmlElement = doc.CreateElement("City")
    debtor1_city.InnerText = "Springfield"
    rec_debt_names.AppendChild(debtor1_city)
    Dim debtor1_state As XmlElement = doc.CreateElement("State")
    debtor1_state.InnerText = "IL"
    rec_debt_names.AppendChild(debtor1_state)
    Dim debtor1_zip As XmlElement = doc.CreateElement("PostalCode")
    debtor1_zip.InnerText = "62701"
    rec_debt_names.AppendChild(debtor1_zip)
    Dim debtor1_county As XmlElement = doc.CreateElement("County")
    debtor1_county.InnerText = "Sangamon"
    rec_debt_names.AppendChild(debtor1_county)
    Dim debtor1_country As XmlElement = doc.CreateElement("Country")
    debtor1_country.InnerText = "USA"
    rec_debt_names.AppendChild(debtor1_country)
    Dim debtor1_taxid As XmlElement = doc.CreateElement("TaxID")
    rec_debt_names.AppendChild(debtor1_taxid)
    Dim debtor1_org_type As XmlElement = doc.CreateElement("OrganizationalType")
    debtor1_org_type.InnerText = ""
    rec_debt_names.AppendChild(debtor1_org_type)
    Dim debtor1_org_juris As XmlElement = doc.CreateElement("OrganizationalJuris")
    debtor1_org_juris.InnerText = "IL"
    rec_debt_names.AppendChild(debtor1_org_juris)
    Dim debtor1_org_id As XmlElement = doc.CreateElement("OrganizationalID")
    debtor1_org_id.InnerText = ""
    rec_debt_names.AppendChild(debtor1_org_id)

    rec_debt_name.AppendChild(rec_debt_names)

    Dim debtor1_alt_cap As XmlElement = doc.CreateElement("DebtorAltCapacity")
    debtor1_alt_cap.SetAttribute("AltCapacity", "NOAltCapacity")
    rec_debt_name.AppendChild(debtor1_alt_cap)

    rec_debtors.AppendChild(rec_debt_name)
    record.AppendChild(rec_debtors)

    Dim rec_secured As XmlElement = doc.CreateElement("Secured")
    Dim rec_sec_name As XmlElement = doc.CreateElement("SecuredName")
    Dim rec_sec_names As XmlElement = doc.CreateElement("Names")

    Dim secured1_org_name As XmlElement = doc.CreateElement("OrganizationName")
    secured1_org_name.InnerText = "Secured"
    rec_sec_names.AppendChild(secured1_org_name)
    Dim secured1_mail_address As XmlElement = doc.CreateElement("MailAddress")
    secured1_mail_address.InnerText = "3 North Old State Capitol Plaza"
    rec_sec_names.AppendChild(secured1_mail_address)
    Dim secured1_city As XmlElement = doc.CreateElement("City")
    secured1_city.InnerText = "Springfield"
    rec_sec_names.AppendChild(secured1_city)
    Dim secured1_state As XmlElement = doc.CreateElement("State")
    secured1_state.InnerText = "IL"
    rec_sec_names.AppendChild(secured1_state)
    Dim secured1_zip As XmlElement = doc.CreateElement("PostalCode")
    secured1_zip.InnerText = "62701"
    rec_sec_names.AppendChild(secured1_zip)
    Dim secured1_county As XmlElement = doc.CreateElement("County")
    secured1_county.InnerText = "Sangamon"
    rec_sec_names.AppendChild(secured1_county)
    Dim secured1_country As XmlElement = doc.CreateElement("Country")
    secured1_country.InnerText = "USA"
    rec_sec_names.AppendChild(secured1_country)
    Dim secured1_taxid As XmlElement = doc.CreateElement("TaxID")
    rec_sec_names.AppendChild(secured1_taxid)
    Dim secured1_org_type As XmlElement = doc.CreateElement("OrganizationalType")
    secured1_org_type.InnerText = ""
    rec_sec_names.AppendChild(secured1_org_type)
    Dim secured1_org_juris As XmlElement = doc.CreateElement("OrganizationalJuris")
    secured1_org_juris.InnerText = "IL"
    rec_sec_names.AppendChild(secured1_org_juris)
    Dim secured1_org_id As XmlElement = doc.CreateElement("OrganizationalID")
    secured1_org_id.InnerText = ""
    rec_sec_names.AppendChild(secured1_org_id)

    rec_sec_name.AppendChild(rec_sec_names)
    rec_secured.AppendChild(rec_sec_name)
    record.AppendChild(rec_secured)

    Dim rec_collateral As XmlElement = doc.CreateElement("Collateral")
    Dim rec_collateral_text As XmlElement = doc.CreateElement("ColText")
    rec_collateral_text.AppendChild(doc.CreateTextNode("String"))
    'rec_collateral_text.Value = "String"
    'Dim rec_collateral_text As XmlElement = doc.CreateElement("ColText")
    'rec_collateral_text.InnerText = ""
    rec_collateral.AppendChild(rec_collateral_text)
    record.AppendChild(rec_collateral)
    root.AppendChild(record)
  End Sub

End Class
