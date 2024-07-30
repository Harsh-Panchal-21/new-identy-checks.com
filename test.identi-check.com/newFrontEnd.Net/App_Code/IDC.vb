Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Collections.Generic

Public Module IDC
  Public IDCConnStr As String
  Public strUseSSL As String = ConfigurationManager.AppSettings("USE_SSL")
  Public strURL As String = ConfigurationManager.AppSettings("APPLICATION_URL")
  Public strSSLURL As String = ConfigurationManager.AppSettings("APPLICATION_SURL")
  Public strSecureAppTransfer As String = "YES"

  Public Function IDCStr() As String
    Dim strEncStr As String = ConfigurationManager.AppSettings("DB_CONN")
    'Dim initVector As String = ")nRfr`i!"
    'Dim strKey As String = "0123456789012345"

    'Dim sym As New Encryption.Symmetric(Encryption.Symmetric.Provider.TripleDES)
    'Dim key As New Encryption.Data(strKey)
    'Dim iv As New Encryption.Data(initVector)
    'sym.IntializationVector = iv
    'Dim encryptedData As New Encryption.Data
    'encryptedData.Base64 = strEncStr
    'Dim decryptedData As Encryption.Data
    'decryptedData = sym.Decrypt(encryptedData, key)
    ''Console.WriteLine(decryptedData.ToString)
    'IDCStr = decryptedData.ToString
    IDCStr = strEncStr
    'Dim dec As Decryptor = New Decryptor(EncryptionAlgorithm.TripleDes)
    'dec.IV = Encoding.ASCII.GetBytes(initVector)
    'Dim key As Byte() = Encoding.ASCII.GetBytes(strKey)
    ' Decrypt the string
    'Dim plainText As Byte() = dec.Decrypt(Convert.FromBase64String(strEncStr), key)
    'EWRCNNStr = Encoding.ASCII.GetString(plainText)
  End Function

  Public Function FillDataTable(ByVal SQLStr As String) As DataTable
    Dim cmdObj As New SqlClient.SqlCommand
    Dim ObjDs As New DataSet
    Dim ObjDc As New SqlClient.SqlConnection
    Dim ObjDa As New SqlClient.SqlDataAdapter
    Dim TableName As String = "TableA"

    ObjDc.ConnectionString = IDCStr()
    ObjDc.Open()

    cmdObj.Connection = ObjDc
    cmdObj.CommandType = CommandType.Text
    cmdObj.CommandText = SQLStr

    ObjDa.SelectCommand = cmdObj

    ObjDs.Tables.Add(TableName)
    ObjDa.Fill(ObjDs.Tables(TableName))

    FillDataTable = ObjDs.Tables(TableName)

    ObjDc.Close()
  End Function

  Public Function FillDataTable(ByVal SQLStr As String, ByVal params As List(Of SqlClient.SqlParameter)) As DataTable

    Dim ObjDs As New DataSet
    Dim ObjDc As New SqlClient.SqlConnection
    Dim ObjDa As New SqlClient.SqlDataAdapter
    Dim TableName As String = "TableA"

    ObjDc.ConnectionString = IDCStr()
    ObjDc.Open()

    'Dim cmd As New SqlClient.SqlCommand("Select * from Table where ref=@ref", con)
    'cmd.Parameters.Add("@ref", SqlDbType.Int)
    'cmd.Parameters("@ref") = 34
    Dim cmdObj As New SqlClient.SqlCommand(SQLStr, ObjDc)
    For Each param As SqlClient.SqlParameter In params
      cmdObj.Parameters.Add(param)
    Next
    'cmdObj.Connection = ObjDc
    'cmdObj.CommandType = CommandType.Text
    'cmdObj.CommandText = SQLStr

    ObjDa.SelectCommand = cmdObj

    ObjDs.Tables.Add(TableName)
    ObjDa.Fill(ObjDs.Tables(TableName))

    FillDataTable = ObjDs.Tables(TableName)

    ObjDc.Close()
  End Function

  Public Function FillDataSet(ByVal TableName As String, ByVal SQLStr As String) As DataSet
    Dim cmdObj As New SqlClient.SqlCommand
    Dim ObjDs As New DataSet
    Dim ObjDc As New SqlClient.SqlConnection
    Dim ObjDa As New SqlClient.SqlDataAdapter

    ObjDc.ConnectionString = IDCStr()
    ObjDc.Open()

    cmdObj.Connection = ObjDc
    cmdObj.CommandType = CommandType.Text
    cmdObj.CommandText = SQLStr

    ObjDa.SelectCommand = cmdObj

    ObjDs.Tables.Add(TableName)
    ObjDa.Fill(ObjDs.Tables(TableName))

    FillDataSet = ObjDs

    ObjDc.Close()
  End Function

  Public Sub RunCommand(ByVal CommandStr As String)
    Dim cmdObj As New SqlClient.SqlCommand
    Dim ObjDc As New SqlClient.SqlConnection

    ObjDc.ConnectionString = IDCStr()
    ObjDc.Open()

    cmdObj.Connection = ObjDc
    cmdObj.CommandType = CommandType.Text
    cmdObj.CommandText = CommandStr
    cmdObj.ExecuteNonQuery()

    ObjDc.Close()
  End Sub

  Public Sub RunCommand(ByVal CommandStr As String, ByVal params As List(Of SqlClient.SqlParameter))
    'Dim cmdObj As New SqlClient.SqlCommand
    Dim ObjDc As New SqlClient.SqlConnection

    ObjDc.ConnectionString = IDCStr()
    ObjDc.Open()

    'cmdObj.Connection = ObjDc
    'cmdObj.CommandType = CommandType.Text
    'cmdObj.CommandText = CommandStr
    Dim cmdObj As New SqlClient.SqlCommand(CommandStr, ObjDc)
    For Each param As SqlClient.SqlParameter In params
      cmdObj.Parameters.Add(param)
    Next
    cmdObj.ExecuteNonQuery()

    ObjDc.Close()
  End Sub

  Public Function ExecuteScalar(ByVal sSql As String) As String
    Dim cmdObj As New SqlClient.SqlCommand
    Dim ObjDc As New SqlClient.SqlConnection

    ObjDc.ConnectionString = IDCStr()
    ObjDc.Open()

    cmdObj.Connection = ObjDc
    cmdObj.CommandType = CommandType.Text
    cmdObj.CommandText = sSql
    Dim sRet As String = cmdObj.ExecuteScalar()
    'cmdObj.ExecuteNonQuery()

    ObjDc.Close()
    Return sRet
  End Function

  Public Function ExecuteScalar(ByVal sSql As String, ByVal params As List(Of SqlClient.SqlParameter)) As String
    'Dim cmdObj As New SqlClient.SqlCommand
    Dim ObjDc As New SqlClient.SqlConnection

    ObjDc.ConnectionString = IDCStr()
    ObjDc.Open()

    'cmdObj.Connection = ObjDc
    'cmdObj.CommandType = CommandType.Text
    'cmdObj.CommandText = sSql
    'Dim sRet As String = cmdObj.ExecuteScalar()
    'cmdObj.ExecuteNonQuery()
    Dim cmdObj As New SqlClient.SqlCommand(sSql, ObjDc)
    For Each param As SqlClient.SqlParameter In params
      cmdObj.Parameters.Add(param)
    Next
    Dim sRet As String = cmdObj.ExecuteScalar()

    ObjDc.Close()
    Return sRet
  End Function

  'Function SendEmail(ByVal strTo As String, ByVal StrSubject As String, ByVal strMsg As String)

  '  Dim objCDO, objBP
  '  objCDO = Server.CreateObject("CDO.Message")
  '  objCDO.MimeFormatted = True
  '  'objCDO.To = strTo
  '  objCDO.To = "alexis@kingtech.net"
  '  objCDO.From = "online@identi-check.com"
  '  objCDO.Subject = StrSubject
  '  objCDO.HTMLBody = "<html><table cellpadding=2 cellspacing=0><tr><td><img src=""cid:myimage.jpg""></td></tr>" & _
  '   "<tr><td>" & strMsg & "</td></tr></table></html>"

  '  ' Here's the good part, thanks to some little-known members.
  '  ' This is a BodyPart object, which represents a new part of the multipart MIME-formatted message.
  '  ' Note you can provide an image of ANY name as the source, and the second parameter essentially
  '  ' renames it to anything you want.  Great for giving sensible names to dynamically-generated images.
  '  objBP = objCDO.AddRelatedBodyPart(Server.MapPath("/images/identi-check_email_banner.jpg"), "myimage.jpg", CdoReferenceTypeName)

  '  ' Now assign a MIME Content ID to the image body part.
  '  ' This is the key that was so hard to find, which makes it 
  '  ' work in mail readers like Yahoo webmail & others that don't
  '  ' recognise the default way Microsoft adds it's part id's,
  '  ' leading to "broken" images in those readers.  Note the
  '  ' < and > surrounding the arbitrary id string.  This is what
  '  ' lets you have SRC="cid:myimage.gif" in the IMG tag.
  '  objBP.Fields.Item("urn:schemas:mailheader:Content-ID") = "<myimage.jpg>"
  '  objBP.Fields.Update()

  '  objCDO.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
  '  'SMTP server
  '  objCDO.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "192.168.1.229"
  '  'SMTP port
  '  objCDO.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25
  '  objCDO.Configuration.Fields.Update()

  '  objCDO.Send()

  'End Function

  Function Lookup_Status(ByVal strStatus As String) As String
    Dim strRtn
    Select Case strStatus
      Case "N"
        strRtn = "New"
      Case "P"
        strRtn = "Pending"
      Case "C"
        strRtn = "Completed"
      Case Else
        strRtn = ""
    End Select
    Lookup_Status = strRtn
  End Function

  Function Write_State_Select(ByVal strName As String, ByVal strSelected As String) As String
    Dim sql As String, strRtn As String = "", strSel As String
    'conn = GetSQLServerConnection(db_machine, db_userid, db_password, db_database)
    sql = "Select STATE_ABBR,STATE_NAME From STATE_LIST Order By STATE_NAME"
    Dim dtState As DataTable = FillDataTable(sql)
    If dtState.Rows.Count > 0 Then
      strRtn = "<select name='" & strName & "'>" & vbCrLf
      strRtn = strRtn & "<option value=''>Select State</option>" & vbCrLf
      For Each drState As DataRow In dtState.Rows
        If drState.Item("STATE_ABBR") = strSelected Then
          strSel = " SELECTED"
        Else
          strSel = ""
        End If
        strRtn = strRtn & "<option value='" & drState.Item("STATE_ABBR") & "'" & strSel & ">" & drState.Item("STATE_NAME") & "</option>" & vbCrLf
      Next
      strRtn = strRtn & "</select>" & vbCrLf
    End If
    dtState.Dispose()
    dtState = Nothing
    Write_State_Select = strRtn
  End Function

  Function Write_Everify(ByVal strName As String, ByVal strSelected As String) As String
    Dim sql As String, strRtn As String = "", strSel As String
    sql = "Select everifyStatusName From everifyStatusNames"
    Dim dtStatus As DataTable = FillDataTable(sql)
    If dtStatus.Rows.Count > 0 Then
      strRtn = "<select name='" & strName & "'>" & vbCrLf
      strRtn = strRtn & "<option value=''>Choose One ...</option>" & vbCrLf
      For Each drStatus As DataRow In dtStatus.Rows
        If drStatus.Item("everifyStatusName") = strSelected Then
          strSel = " SELECTED"
        Else
          strSel = ""
        End If
        strRtn = strRtn & "<option value='" & drStatus.Item("everifyStatusName") & "'" & strSel & ">" & drStatus.Item("everifyStatusName") & "</option>" & vbCrLf
      Next

    End If
    dtStatus.Dispose()
    dtStatus = Nothing
    Write_Everify = strRtn
  End Function
End Module
