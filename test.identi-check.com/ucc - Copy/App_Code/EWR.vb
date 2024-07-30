Imports Microsoft.VisualBasic
'Imports Encryption
Imports Microsoft.Win32
'Imports System.Drawing
Imports System.Text
Imports System.Net.Mail
Imports System.Configuration
Imports iTextSharp
Imports iTextSharp.text
Imports iTextSharp.text.pdf
Imports iTextSharp.text.xml
Imports System.IO

Public Module EWR
  Public UCC1_PDF As String = ConfigurationManager.AppSettings("UCC1_PDF")
  Public UCC1ad_PDF As String = ConfigurationManager.AppSettings("UCC1ad_PDF")
  Public UCC1ap_PDF As String = ConfigurationManager.AppSettings("UCC1ap_PDF")
  Public UCC3_PDF As String = ConfigurationManager.AppSettings("UCC3_PDF")
  Public UCC3ad_PDF As String = ConfigurationManager.AppSettings("UCC3ad_PDF")
  Public UCC3ap_PDF As String = ConfigurationManager.AppSettings("UCC3ap_PDF")
  Public UCC11_PDF As String = ConfigurationManager.AppSettings("UCC11_PDF")
  Public Filing_Office_Acct_No As String = ConfigurationManager.AppSettings("Filing_Office_Acct_No")
  Public Filing_Charge As String = ConfigurationManager.AppSettings("Filing_Charge")
  Public Search_Charge_with_File As String = ConfigurationManager.AppSettings("Search_Charge_with_File")
  Public Filing_Charge_Amendment As String = ConfigurationManager.AppSettings("Filing_Charge_Amendment")
  Public Search_Charge As String = ConfigurationManager.AppSettings("Search_Charge")
  Public Search_File_Pull_Charge As String = ConfigurationManager.AppSettings("Search_File_Pull_Charge")
  Public IDC_Notify As String = ConfigurationManager.AppSettings("IDC_Notify")
  Public UCCXML_Acct_Num As String = ConfigurationManager.AppSettings("UCCXML_Acct_Num")
  Public UCCXML_UserID As String = ConfigurationManager.AppSettings("UCCXML_UserID")
  Public UCCXML_Password As String = ConfigurationManager.AppSettings("UCCXML_Password")
  Public UCCXML_PostURL As String = ConfigurationManager.AppSettings("UCCXML_PostURL")
  Public UCCXML_StatusRequestURL As String = ConfigurationManager.AppSettings("UCCXML_StatusRequestURL")
  Public UCCXML_RetrieveDocURL As String = ConfigurationManager.AppSettings("UCCXML_RetrieveDocURL")
  Public UCCXML_RetrieveImage As String = ConfigurationManager.AppSettings("UCCXML_RetrieveImage")
  Public UCCXML_Test As String = ConfigurationManager.AppSettings("UCCXML_Test")
  Public UCCXML_StatusRequestURL_Prod As String = ConfigurationManager.AppSettings("UCCXML_StatusRequestURL_Prod")
  'Public UCCXML_ As String = ConfigurationManager.AppSettings("UCCXML_")
  Public strAppURL As String = ConfigurationManager.AppSettings("APPLICATION_URL")
  Public strEncPassSring As String = ConfigurationManager.AppSettings("ENC_PASS_STRING")

  Public Telerik_Skin As String = ConfigurationManager.AppSettings("Telerik.Skin")
  'Public strUseSSL As String = ConstantsManager.getConstant("USE_SSL")
  'Public strSSLURL As String = ConstantsManager.getConstant("APPLICATION_SURL")
  'Public strSecureAppTransfer As String = ConstantsManager.getConstant("SECURE_APP_TRANSFER")
  'Public strShowEWR As String = ConstantsManager.getConstant("SHOW_EWR")
  'Public strShowELIC As String = ConstantsManager.getConstant("SHOW_ELIC")
  'Public strShowCCSEWR As String = ConstantsManager.getConstant("SHOW_CCSEWR")
  'Public strSendSingupNoticeTo As String = ConstantsManager.getConstant("SEND_SIGNUP_NOTICE_TO")
  'Public PDFInvoicePath As String = ConstantsManager.getConstant("Invoice_PDF")
  'Public Service_License_Template As String = ConfigurationManager.AppSettings("Service_License_Template")
  'Public strCOMRoles As String = CType(ConstantsManager.getConstant("COM_ROLES"), String).TrimEnd(";")
  'Public strAcctManRoles As String = CType(ConstantsManager.getConstant("MAN_ROLES"), String).TrimEnd(";")
  'Public strIssuerRoles As String = CType(ConstantsManager.getConstant("ISSUER_ROLES"), String).TrimEnd(";")
  'Public strViewerRoles As String = CType(ConstantsManager.getConstant("VIEWER_ROLES"), String).TrimEnd(";")
  'Public strHolderIDPrefix As String = CType(ConstantsManager.getConstant("HOLDER_ID_PREFIX"), String).TrimEnd(";")
  Public SessionSQL As String = ""


  Public Function CNNStr() As String
    Return ConfigurationManager.AppSettings("DB_Conn")
    'Dim strEncStr As String = ConstantsManager.getConstant("DB_ENC_CONN")
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
    'EWRCNNStr = decryptedData.ToString

    ''Dim dec As Decryptor = New Decryptor(EncryptionAlgorithm.TripleDes)
    ''dec.IV = Encoding.ASCII.GetBytes(initVector)
    ''Dim key As Byte() = Encoding.ASCII.GetBytes(strKey)
    '' Decrypt the string
    ''Dim plainText As Byte() = dec.Decrypt(Convert.FromBase64String(strEncStr), key)
    ''EWRCNNStr = Encoding.ASCII.GetString(plainText)
  End Function

  Public Function EncryptString(ByVal strToBeEncrypted As String, Optional ByVal sKey As String = "", Optional ByVal sIV As String = "") As String
    Dim strKey As String = "0123456789012345"
    If sKey <> "" Then strKey = sKey
    Dim strIV As String = ")nRfr`i!"
    If sIV <> "" Then strIV = sIV

    Dim sym As New Encryption.Symmetric(Encryption.Symmetric.Provider.TripleDES)
    Dim key As New Encryption.Data(strKey)
    Dim iv As New Encryption.Data(strIV)
    sym.IntializationVector = iv
    Dim encryptedData As Encryption.Data
    encryptedData = sym.Encrypt(New Encryption.Data(strToBeEncrypted), key)
    Dim base64EncryptedString As String = encryptedData.ToBase64
    EncryptString = base64EncryptedString

    ' Create the encryptor object, specifying 3DES as the
    ' encryption algorithm
    'Dim enc As New Encryptor(EncryptionAlgorithm.TripleDes)
    ' Get the connection string as a byte array
    'Dim plainText As Byte() = Encoding.ASCII.GetBytes(strToBeEncrypted)
    'Dim key As Byte() = Encoding.ASCII.GetBytes(strKey)
    'enc.IV = Encoding.ASCII.GetBytes(strIV)

    ' Perform the encryption
    'Dim cipherText As Byte() = enc.Encrypt(plainText, key)
    ' Store the intialization vector, as this will be required
    ' for decryption
    'txtInitializationVector.Text = Encoding.ASCII.GetString(enc.IV);
    'enc.IV = Encoding.ASCII.GetBytes(txtInitializationVector.Text);

    ' Display the encrypted string
    'txtEncryptedString.Text = Convert.ToBase64String(cipherText);
    'EncryptString = Convert.ToBase64String(cipherText)
  End Function

  Public Function CheckLogin(ByVal strUser As String, ByVal strPass As String, ByRef strUserRID As String, ByRef strComRID As String) As Boolean
    Dim strSQL As String, blnRtn As Boolean
    Dim dtUser As DataTable
    Dim tmpPassword As String = EncryptString(strPass)
    strSQL = "Select * From USERS Where LOGIN_ID='" & strUser.Replace("'", "''") & "' and PASSWORD='" & tmpPassword & "'"
    dtUser = FillDataTable(strSQL)
    If dtUser.Rows.Count > 0 Then
      strUserRID = dtUser.Rows(0).Item("RID")
      strComRID = dtUser.Rows(0).Item("COMPANY_RID")
      If dtUser.Rows(0).Item("STATUS") <> "ACTIVATED" Then
        blnRtn = False
      Else
        blnRtn = True
      End If
    Else
      blnRtn = False
    End If
    dtUser.Dispose()
    dtUser = Nothing
    CheckLogin = blnRtn

  End Function

  Public Function FillDataTable(ByVal SQLStr As String) As DataTable
    Dim cmdObj As New SqlClient.SqlCommand
    Dim ObjDs As New DataSet
    Dim ObjDc As New SqlClient.SqlConnection
    Dim ObjDa As New SqlClient.SqlDataAdapter
    Dim TableName As String = "TableA"

    ObjDc.ConnectionString = CNNStr()
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

  Public Function FillDataSet(ByVal TableName As String, ByVal SQLStr As String) As DataSet
    Dim cmdObj As New SqlClient.SqlCommand
    Dim ObjDs As New DataSet
    Dim ObjDc As New SqlClient.SqlConnection
    Dim ObjDa As New SqlClient.SqlDataAdapter

    ObjDc.ConnectionString = CNNStr()
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

  Public Function ExecuteScalar(ByVal sSql As String) As String
    Dim cmdObj As New SqlClient.SqlCommand
    Dim ObjDc As New SqlClient.SqlConnection

    ObjDc.ConnectionString = CNNStr()
    ObjDc.Open()

    cmdObj.Connection = ObjDc
    cmdObj.CommandType = CommandType.Text
    cmdObj.CommandText = sSql
    Dim sRet As String = cmdObj.ExecuteScalar()
    'cmdObj.ExecuteNonQuery()

    ObjDc.Close()
    Return sRet
  End Function

  Public Sub RunCommand(ByVal CommandStr As String)
    Dim cmdObj As New SqlClient.SqlCommand
    Dim ObjDc As New SqlClient.SqlConnection

    ObjDc.ConnectionString = CNNStr()
    ObjDc.Open()

    cmdObj.Connection = ObjDc
    cmdObj.CommandType = CommandType.Text
    cmdObj.CommandText = CommandStr
    cmdObj.ExecuteNonQuery()

    ObjDc.Close()
  End Sub

  ''' <summary>
  ''' Determine if Date String is an actual date
  ''' Date format = MM/DD/YYYY
  ''' </summary>
  ''' <param name="dateString"></param>
  ''' <returns></returns>
  ''' <remarks></remarks>
  Public Function ValidateDate(ByVal dateString As String) As Boolean
    Try
      ' for US, alter to suit if splitting on hyphen, comma, etc.
      Dim dateParts() As String = dateString.Split("/")
      ' create new date from the parts; if this does not fail
      ' the method will return true
      Dim testDate As New Date(Convert.ToInt32(dateParts(2)), _
                               Convert.ToInt32(dateParts(0)), _
                               Convert.ToInt32(dateParts(1)))
      Return True
    Catch ex As Exception
      ' if a test date cannot be created, the
      ' method will return false
      Return False
    End Try
  End Function

  Public Sub FillDebtorInfo(ByVal sDebtorID As String, ByVal sComID As String, ByRef txtOrgName As TextBox, ByRef txtLastName As TextBox, _
                            ByRef txtFirstName As TextBox, ByRef txtMiddleName As TextBox, ByRef txtSuffix As TextBox, _
                            ByRef txtMailingAddress As TextBox, ByRef txtCity As TextBox, ByRef lstState As DropDownList, _
                            ByRef txtZip As TextBox, ByRef txtCountry As TextBox, ByRef txtD1 As TextBox, _
                            ByRef txtOrgType As TextBox, ByRef txtOrgJurisdiction As TextBox, ByRef txtOrgID As TextBox, _
                            ByRef chkOrgIDNone As CheckBox)
    Dim dtDebtor As DataTable = FillDataTable("Select * From ucc_debtor where ud_id = " & sDebtorID & " and ud_company_id = " & sComID)
    If dtDebtor.Rows.Count > 0 Then
      With dtDebtor.Rows(0)
        txtOrgName.Text = .Item("ud_org_name") & ""
        txtLastName.Text = .Item("ud_ind_last_name") & ""
        txtFirstName.Text = .Item("ud_ind_first_name") & ""
        txtMiddleName.Text = .Item("ud_ind_middle_name") & ""
        txtSuffix.Text = .Item("ud_ind_suffix") & ""
        txtMailingAddress.Text = .Item("ud_mailing_address") & ""
        txtCity.Text = .Item("ud_city") & ""
        Try
          lstState.SelectedIndex = -1
          lstState.Items.FindByValue(.Item("ud_state") & "").Selected = True
        Catch ex As Exception

        End Try
        txtZip.Text = .Item("ud_zipcode") & ""
        txtCountry.Text = .Item("ud_country") & ""
        txtD1.Text = .Item("ud_d1") & ""
        txtOrgType.Text = .Item("ud_org_type") & ""
        txtOrgJurisdiction.Text = .Item("ud_org_jurisdiction") & ""
        txtOrgID.Text = .Item("ud_org_id") & ""
        chkOrgIDNone.Checked = IIf(.Item("ud_org_id_none") & "" = "Y", True, False)
      End With
    Else
      txtOrgName.Text = ""
      txtLastName.Text = ""
      txtFirstName.Text = ""
      txtMiddleName.Text = ""
      txtSuffix.Text = ""
      txtMailingAddress.Text = ""
      txtCity.Text = ""
      Try
        lstState.SelectedIndex = -1
        lstState.Items.FindByValue("IL").Selected = True
      Catch ex As Exception

      End Try
      txtZip.Text = ""
      txtCountry.Text = ""
      txtD1.Text = ""
      txtOrgType.Text = ""
      txtOrgJurisdiction.Text = ""
      txtOrgID.Text = ""
      chkOrgIDNone.Checked = False
    End If
    dtDebtor.Dispose()
    dtDebtor = Nothing
  End Sub

  Public Function AddDebtor(ByVal sUser As String, ByVal sComID As String, ByVal sDebtor1_Org_Name As String, ByVal sDebtor1_Ind_Last_Name As String, _
      ByVal sDebtor1_Ind_First_Name As String, ByVal sDebtor1_Ind_Middle_Name As String, ByVal sDebtor1_Ind_Suffix As String, _
      Optional ByVal sDebtor1_Mailing_Address As String = "", Optional ByVal sDebtor1_City As String = "", _
      Optional ByVal sDebtor1_State As String = "", Optional ByVal sDebtor1_Zip As String = "", Optional ByVal sDebtor1_Country As String = "", _
      Optional ByVal sDebtor1_d1 As String = "", Optional ByVal sDebtor1_Org_Type As String = "", Optional ByVal sDebtor1_Org_Jurisdiction As String = "", _
      Optional ByVal sDebtor1_Org_ID As String = "", Optional ByVal sDebtor1_Org_ID_None As String = "") As String

    Dim sSQL As String = "", sDebtorID As String = ""
    sSQL = "Insert Into ucc_debtor (ud_org_name,ud_ind_last_name,ud_ind_first_name,ud_ind_middle_name," & _
        "ud_ind_suffix,"
    If sDebtor1_Mailing_Address <> "" And sDebtor1_City <> "" Then
      sSQL = sSQL & "ud_mailing_address,ud_city,ud_state,ud_zipcode,ud_country,ud_d1,ud_org_type,ud_org_jurisdiction," & _
        "ud_org_id,ud_org_id_none,"
    End If
    sSQL = sSQL & "ud_date_submitted,ud_user_submitted,ud_company_id) Values ('" & sDebtor1_Org_Name.Replace("'", "''").ToUpper & "'," & _
        "'" & sDebtor1_Ind_Last_Name.Replace("'", "''").ToUpper & "'," & _
        "'" & sDebtor1_Ind_First_Name.Replace("'", "''").ToUpper & "'," & _
        "'" & sDebtor1_Ind_Middle_Name.Replace("'", "''").ToUpper & "'," & _
        "'" & sDebtor1_Ind_Suffix.Replace("'", "''").ToUpper & "',"
    If sDebtor1_Mailing_Address <> "" And sDebtor1_City <> "" Then
      sSQL = sSQL & "'" & sDebtor1_Mailing_Address.Replace("'", "''").ToUpper & "'," & _
        "'" & sDebtor1_City.Replace("'", "''").ToUpper & "'," & _
        "'" & sDebtor1_State.Replace("'", "''").ToUpper & "'," & _
        "'" & sDebtor1_Zip.Replace("'", "''").ToUpper & "'," & _
        "'" & sDebtor1_Country.Replace("'", "''").ToUpper & "'," & _
        "'" & sDebtor1_d1.Replace("'", "''").ToUpper & "'," & _
        "'" & sDebtor1_Org_Type.Replace("'", "''") & "'," & _
        "'" & sDebtor1_Org_Jurisdiction.Replace("'", "''").ToUpper & "'," & _
        "'" & sDebtor1_Org_ID.Replace("'", "''").ToUpper & "'," & _
        "'" & sDebtor1_Org_ID_None & "',"
    End If
    sSQL = sSQL & "getdate(),'" & sUser.Replace("'", "''") & "'," & sComID & "); " & _
        "Select Scope_Identity()"
    sDebtorID = ExecuteScalar(sSQL)
    Return sDebtorID
  End Function

    Public Function EnterSearch(ByVal us_debtor As String, ByVal us_sr_certified As String, ByVal us_sr As String, _
            ByVal us_cr_certified As String, ByVal us_cr As String, ByVal us_sco_certified As String, _
            ByVal us_more_date As String, ByVal us_more_address As String, ByVal us_more_name As String, ByVal us_more_other As String, _
            ByVal us_sco1_rec_no As String, ByVal us_sco1_date As String, ByVal us_sco1_type As String, _
            ByVal us_sco2_rec_no As String, ByVal us_sco2_date As String, ByVal us_sco2_type As String, _
            ByVal us_sco3_rec_no As String, ByVal us_sco3_date As String, ByVal us_sco3_type As String, _
            ByVal us_sco4_rec_no As String, ByVal us_sco4_date As String, ByVal us_sco4_type As String, _
            ByVal us_sco5_rec_no As String, ByVal us_sco5_date As String, ByVal us_sco5_type As String, _
            ByVal us_sco6_rec_no As String, ByVal us_sco6_date As String, ByVal us_sco6_type As String, _
            ByVal us_additional As String, ByVal us_status As String, ByVal us_user_submitted As String, _
            ByVal sComID As String, ByVal us_charge As String, ByVal us_loan_type As String) As String
        Dim sSQL As String = ""
        Dim sUS_ID As String = ""

        sSQL = "Insert Into ucc_search (us_debtor,us_sr_certified,us_sr,us_cr_certified,us_cr,us_sco_certified," & _
          "us_more_date,us_more_address,us_loan_type,us_more_name,us_more_other," & _
          "us_sco1_rec_no,us_sco1_date,us_sco1_type,us_sco2_rec_no,us_sco2_date,us_sco2_type,us_sco3_rec_no,us_sco3_date," & _
          "us_sco3_type,us_sco4_rec_no,us_sco4_date,us_sco4_type,us_sco5_rec_no,us_sco5_date,us_sco5_type,us_sco6_rec_no," & _
          "us_sco6_date,us_sco6_type,us_additional,us_status,us_date_submitted,us_user_submitted,us_company_id,us_charge) values (" & us_debtor & "," & _
          "'" & us_sr_certified.Replace("'", "''") & "', " & _
          "'" & us_sr.Replace("'", "''") & "', " & _
          "'" & us_cr_certified.Replace("'", "''") & "', " & _
          "'" & us_cr.Replace("'", "''") & "', " & _
          "'" & us_sco_certified.Replace("'", "''") & "', " & _
          "'" & us_more_date.Replace("'", "''").ToUpper & "', " & _
          "'" & us_more_address.Replace("'", "''").ToUpper & "', " & _
          "'" & us_loan_type & "', " & _
          "'" & us_more_name.Replace("'", "''").ToUpper & "', " & _
          "'" & us_more_other.Replace("'", "''").ToUpper & "', " & _
          "'" & us_sco1_rec_no.Replace("'", "''").ToUpper & "', " & _
          "'" & us_sco1_date.Replace("'", "''").ToUpper & "', " & _
          "'" & us_sco1_type.Replace("'", "''").ToUpper & "', " & _
          "'" & us_sco2_rec_no.Replace("'", "''").ToUpper & "', " & _
          "'" & us_sco2_date.Replace("'", "''").ToUpper & "', " & _
          "'" & us_sco2_type.Replace("'", "''").ToUpper & "', " & _
          "'" & us_sco3_rec_no.Replace("'", "''").ToUpper & "', " & _
          "'" & us_sco3_date.Replace("'", "''").ToUpper & "', " & _
          "'" & us_sco3_type.Replace("'", "''").ToUpper & "', " & _
          "'" & us_sco4_rec_no.Replace("'", "''").ToUpper & "', " & _
          "'" & us_sco4_date.Replace("'", "''").ToUpper & "', " & _
          "'" & us_sco4_type.Replace("'", "''").ToUpper & "', " & _
          "'" & us_sco5_rec_no.Replace("'", "''").ToUpper & "', " & _
          "'" & us_sco5_date.Replace("'", "''").ToUpper & "', " & _
          "'" & us_sco5_type.Replace("'", "''").ToUpper & "', " & _
          "'" & us_sco6_rec_no.Replace("'", "''").ToUpper & "', " & _
          "'" & us_sco6_date.Replace("'", "''").ToUpper & "', " & _
          "'" & us_sco6_type.Replace("'", "''").ToUpper & "', " & _
          "'" & us_additional.Replace("'", "''").ToUpper & "', " & _
          "'N', getdate(),'" & us_user_submitted.Replace("'", "''") & "'," & sComID & "," & _
          IIf(us_charge <> "", us_charge, "Null") & "); Select Scope_Identity()"
        sUS_ID = ExecuteScalar(sSQL)

        Return sUS_ID
    End Function

  Public Function GetUCC1_PDF(ByVal sID As String, ByVal sComID As String, Optional ByVal sHasCompanies As String = "N") As Byte()
    Dim strSQL As String, sWhereCom As String = ""
    Dim dtData As New DataTable
    Dim arrByte() As Byte = Nothing
    If sHasCompanies = "Y" Then
      sWhereCom = " in (Select company_id from subscriber where parent_company_id = " & sComID & ") "
    Else
      sWhereCom = " = " & sComID & " "
    End If


    strSQL = "Select uf.*, " & _
      "ud1.ud_id as ud1_id,ud1.ud_org_name as ud1_org_name,ud1.ud_ind_last_name as ud1_ind_last_name,ud1.ud_ind_first_name as ud1_ind_first_name,ud1.ud_ind_middle_name as ud1_ind_middle_name,ud1.ud_ind_suffix as ud1_ind_suffix,ud1.ud_mailing_address as ud1_mailing_address,ud1.ud_city as ud1_city,ud1.ud_state as ud1_state,ud1.ud_zipcode as ud1_zipcode,ud1.ud_country as ud1_country,ud1.ud_d1 as ud1_d1,ud1.ud_org_type as ud1_org_type,ud1.ud_org_jurisdiction as ud1_org_jurisdiction,ud1.ud_org_id as ud1_org_id,ud1.ud_org_id_none as ud1_org_id_none, " & _
      "ud2.ud_id as ud2_id,ud2.ud_org_name as ud2_org_name,ud2.ud_ind_last_name as ud2_ind_last_name,ud2.ud_ind_first_name as ud2_ind_first_name,ud2.ud_ind_middle_name as ud2_ind_middle_name,ud2.ud_ind_suffix as ud2_ind_suffix,ud2.ud_mailing_address as ud2_mailing_address,ud2.ud_city as ud2_city,ud2.ud_state as ud2_state,ud2.ud_zipcode as ud2_zipcode,ud2.ud_country as ud2_country,ud2.ud_d1 as ud2_d1,ud2.ud_org_type as ud2_org_type,ud2.ud_org_jurisdiction as ud2_org_jurisdiction,ud2.ud_org_id as ud2_org_id,ud2.ud_org_id_none as ud2_org_id_none " & _
      "From ucc_financing as uf left outer join ucc_debtor as ud1 on uf.uf_debtor1 = ud1.ud_id " & _
      "left outer join ucc_debtor as ud2 on uf.uf_debtor2 = ud2.ud_id " & _
      "Where uf_id = " & sID & " and uf_company_id " & sWhereCom

    dtData = FillDataTable(strSQL)
    If dtData.Rows.Count > 0 Then
      With dtData.Rows(0)
        Dim pdfTemplate As String = UCC1_PDF
        Dim memStream As New MemoryStream

        Dim pdfReader As New PdfReader(pdfTemplate)
        ' New FileStream(newFile, FileMode.Create)
        Dim pdfStamper = New PdfStamper(pdfReader, memStream)
        Dim pdfFormFields As AcroFields = pdfStamper.AcroFields

        'Dim iCount As Integer = 0
        '// set form pdfFormFields
        pdfFormFields.SetField("A", "Micah King, 217-753-4311")
        pdfFormFields.SetField("B", "info@identi-check.com")
        pdfFormFields.SetField("C", "Identi-Check, Inc." & Environment.NewLine & "3 North Old State Capitol Plaza" & Environment.NewLine & "Springfield, IL 62701")
        'first debtor
        '"1" is checkbox
        pdfFormFields.SetField("1a", .Item("ud1_org_name") & "")
        pdfFormFields.SetField("1bS", .Item("ud1_ind_last_name") & "")
        pdfFormFields.SetField("1bF", .Item("ud1_ind_first_name") & "")
        'additional names now, not middle name
        pdfFormFields.SetField("1bA", .Item("ud1_ind_middle_name") & "")
        pdfFormFields.SetField("1bSfx", .Item("ud1_ind_suffix") & "")
        pdfFormFields.SetField("1cMA", .Item("ud1_mailing_address") & "")
        pdfFormFields.SetField("1cCty", .Item("ud1_city") & "")
        pdfFormFields.SetField("1cS", .Item("ud1_state") & "")
        pdfFormFields.SetField("1cPC", .Item("ud1_zipcode") & "")
        pdfFormFields.SetField("1cCtry", .Item("ud1_country") & "")
        'pdfFormFields.SetField("1dsi", .Item("ud1_d1") & "")
        'pdfFormFields.SetField("1e", (.Item("ud1_org_type") & "").ToString.ToUpper)
        'pdfFormFields.SetField("1f", .Item("ud1_org_jurisdiction") & "")
        'pdfFormFields.SetField("1g", .Item("ud1_org_id") & "")
        'pdfFormFields.SetField("none", IIf(.Item("ud1_org_id_none") & "" = "Y", "Yes", "0"))
        'second debtor
        '"2" is checkbox
        pdfFormFields.SetField("2a", .Item("ud2_org_name") & "")
        pdfFormFields.SetField("2bS", .Item("ud2_ind_last_name") & "")
        pdfFormFields.SetField("2bF", .Item("ud2_ind_first_name") & "")
        'additional names now, not middle name
        pdfFormFields.SetField("2bA", .Item("ud2_ind_middle_name") & "")
        pdfFormFields.SetField("2bSfx", .Item("ud2_ind_suffix") & "")
        pdfFormFields.SetField("2cMA", .Item("ud2_mailing_address") & "")
        pdfFormFields.SetField("2cCty", .Item("ud2_city") & "")
        pdfFormFields.SetField("2cS", .Item("ud2_state") & "")
        pdfFormFields.SetField("2cPC", .Item("ud2_zipcode") & "")
        pdfFormFields.SetField("2cCtry", .Item("ud2_country") & "")
        'pdfFormFields.SetField("1dsi2", .Item("ud2_d1") & "")
        'pdfFormFields.SetField("1e2", (.Item("ud2_org_type") & "").ToString.ToUpper)
        'pdfFormFields.SetField("1f2", .Item("ud2_org_jurisdiction") & "")
        'pdfFormFields.SetField("1g2", .Item("ud2_org_id") & "")
        'pdfFormFields.SetField("none2", IIf(.Item("ud2_org_id_none") & "" = "Y", "Yes", "0"))
        'secured
        pdfFormFields.SetField("3a", .Item("uf_secured_org_name") & "")
        'pdfFormFields.SetField("3bS", .Item("ud1_ind_last_name") & "")
        'pdfFormFields.SetField("3bF", .Item("ud1_ind_first_name") & "")
        'pdfFormFields.SetField("3bA", .Item("ud1_ind_middle_name") & "")
        'pdfFormFields.SetField("3bSfx", .Item("ud1_ind_suffix") & "")
        pdfFormFields.SetField("3cMA", .Item("uf_secured_mailing_address") & "")
        pdfFormFields.SetField("3cCty", .Item("uf_secured_city") & "")
        pdfFormFields.SetField("3cS", .Item("uf_secured_state") & "")
        pdfFormFields.SetField("3cPC", .Item("uf_secured_zipcode") & "")
        pdfFormFields.SetField("3cCtry", .Item("uf_secured_country") & "")
        '4 - financing
        'approx max size is 1200 ~ 1274
        pdfFormFields.SetField("4", .Item("uf_finance_statement") & "")
        'test max length of field
        'Dim sbText As New System.Text.StringBuilder
        'For i As Integer = 0 To 1000
        '  sbText.Append("thethehtdssdhhsdfeeryeryerzbna sadhas asd fasdgf asdg agsdfag fa f")
        'Next
        'pdfFormFields.SetField("4", sbText.ToString)

        Dim sAltDes As String = .Item("uf_alt_designation") & ""
        '"5" is 1 or 2 - new field (held in trust or being administered by decedent personal rep)
        '"6a" is 1, 2, or 3 - new field (pub finance trans, man-home trans, transmitting utility)
        '"6b" is 1 or 2 - new field (ag lien or non-ucc filing) - part of old alt designation
        '"7" is 1, 2, 3, 4, or 5 - changed field (lessee, consignee, seller, bailee, licensee)
        If sAltDes.Substring(4, 1) = "A" Then
          pdfFormFields.SetField("6b", "1")
        ElseIf sAltDes.Substring(5, 1) = "N" Then
          pdfFormFields.SetField("6b", "2")
        End If
        If sAltDes.Substring(0, 1) = "L" Then
          pdfFormFields.SetField("7", "1")
        ElseIf sAltDes.Substring(1, 1) = "C" Then
          pdfFormFields.SetField("7", "2")
        ElseIf sAltDes.Substring(2, 1) = "B" Then
          pdfFormFields.SetField("7", "3")
        ElseIf sAltDes.Substring(3, 1) = "S" Then
          pdfFormFields.SetField("7", "4")
        ElseIf sAltDes.Substring(4, 1) = "?" Then
          pdfFormFields.SetField("7", "5")
        End If
        'pdfFormFields.SetField("5a", IIf(sAltDes.Substring(0, 1) = "L", "Yes", "0"))
        'pdfFormFields.SetField("5b", IIf(sAltDes.Substring(1, 1) = "C", "Yes", "0"))
        'pdfFormFields.SetField("5c", IIf(sAltDes.Substring(2, 1) = "B", "Yes", "0"))
        'pdfFormFields.SetField("5d", IIf(sAltDes.Substring(3, 1) = "S", "Yes", "0"))
        'pdfFormFields.SetField("5e", IIf(sAltDes.Substring(4, 1) = "A", "Yes", "0"))
        'pdfFormFields.SetField("5f", IIf(sAltDes.Substring(5, 1) = "N", "Yes", "0"))

        'pdfFormFields.SetField("6a", IIf(.Item("uf_file_real_estate") & "" = "Y", "Yes", "0"))

        'pdfFormFields.SetField("7a", IIf(.Item("uf_request_search") & "" = "A", "Yes", "0"))
        'pdfFormFields.SetField("7b", IIf(.Item("uf_request_search") & "" = "1", "Yes", "0"))
        'pdfFormFields.SetField("7c", IIf(.Item("uf_request_search") & "" = "2", "Yes", "0"))

        pdfFormFields.SetField("8", .Item("uf_reference_data") & "")

        '// flatten the form to remove editting options, set it to false
        '// to leave the form open to subsequent manual edits
        pdfStamper.FormFlattening = True

        '// close the pdf
        pdfStamper.Close()

        arrByte = memStream.ToArray()

        'Response.Expires = -1000
        'Response.ContentType = "application/pdf"
        'Response.AddHeader("content-length", arrByte.Length.ToString())
        'Response.AddHeader("content-disposition", "inline; filename=UCC1_" & .Item("uf_id") & ".PDF")
        'Response.BinaryWrite(arrByte)
      End With
    End If
    dtData.Dispose()
    dtData = Nothing

    Return arrByte
  End Function

  Public Function GetUCC1ad_PDF(ByVal sID As String, ByVal sComID As String, Optional ByVal sHasCompanies As String = "N") As Byte()
    Dim strSQL As String, sWhereCom As String = ""
    Dim dtData As New DataTable
    Dim arrByte() As Byte = Nothing
    If sHasCompanies = "Y" Then
      sWhereCom = " in (Select company_id from subscriber where parent_company_id = " & sComID & ") "
    Else
      sWhereCom = " = " & sComID & " "
    End If

    strSQL = "Select ufad.*, " & _
      "ud1.ud_id as ud1_id,ud1.ud_org_name as ud1_org_name,ud1.ud_ind_last_name as ud1_ind_last_name,ud1.ud_ind_first_name as ud1_ind_first_name,ud1.ud_ind_middle_name as ud1_ind_middle_name,ud1.ud_ind_suffix as ud1_ind_suffix,ud1.ud_mailing_address as ud1_mailing_address,ud1.ud_city as ud1_city,ud1.ud_state as ud1_state,ud1.ud_zipcode as ud1_zipcode,ud1.ud_country as ud1_country,ud1.ud_d1 as ud1_d1,ud1.ud_org_type as ud1_org_type,ud1.ud_org_jurisdiction as ud1_org_jurisdiction,ud1.ud_org_id as ud1_org_id,ud1.ud_org_id_none as ud1_org_id_none, " & _
      "ud2.ud_id as ud2_id,ud2.ud_org_name as ud2_org_name,ud2.ud_ind_last_name as ud2_ind_last_name,ud2.ud_ind_first_name as ud2_ind_first_name,ud2.ud_ind_middle_name as ud2_ind_middle_name,ud2.ud_ind_suffix as ud2_ind_suffix,ud2.ud_mailing_address as ud2_mailing_address,ud2.ud_city as ud2_city,ud2.ud_state as ud2_state,ud2.ud_zipcode as ud2_zipcode,ud2.ud_country as ud2_country,ud2.ud_d1 as ud2_d1,ud2.ud_org_type as ud2_org_type,ud2.ud_org_jurisdiction as ud2_org_jurisdiction,ud2.ud_org_id as ud2_org_id,ud2.ud_org_id_none as ud2_org_id_none " & _
      "From ucc_financing_ad as ufad inner join ucc_financing as uf on ufad_uf_id = uf.uf_id " & _
      "left outer join ucc_debtor as ud1 on uf.uf_debtor1 = ud1.ud_id " & _
      "left outer join ucc_debtor as ud2 on ufad.ufad_debtor3 = ud2.ud_id " & _
      "Where ufad_id = " & sID & " and uf_company_id " & sWhereCom

    dtData = FillDataTable(strSQL)
    If dtData.Rows.Count > 0 Then
      With dtData.Rows(0)
        Dim pdfTemplate As String = UCC1ad_PDF
        Dim memStream As New MemoryStream

        Dim pdfReader As New PdfReader(pdfTemplate)
        ' New FileStream(newFile, FileMode.Create)
        Dim pdfStamper = New PdfStamper(pdfReader, memStream)
        Dim pdfFormFields As AcroFields = pdfStamper.AcroFields

        'Dim iCount As Integer = 0
        '// set form pdfFormFields
        'pdfFormFields.SetField("A", "Micah King, 217-753-4311")
        'pdfFormFields.SetField("B", "Identi-Check, Inc." & Environment.NewLine & "3 North Old State Capitol Plaza" & Environment.NewLine & "Springfield, IL 62701")
        'debtor from ucc1
        pdfFormFields.SetField("9a", .Item("ud1_org_name") & "")
        'if doesn't fit on one line - pdfFormFields.SetField("9a2", .Item("ud1_org_name") & "")
        pdfFormFields.SetField("9bS", .Item("ud1_ind_last_name") & "")
        pdfFormFields.SetField("9bF", .Item("ud1_ind_first_name") & "")
        pdfFormFields.SetField("9bA", .Item("ud1_ind_middle_name") & "") 'Additional Names
        pdfFormFields.SetField("9bSfx", .Item("ud1_ind_suffix") & "")

        'additional secured party - we don't use
        '11 is 1 (secured) or 2 (assignor)
        '11a, 11bS, 11bF, 11bA, 11bSfx, 11cMA, 11cCty, 11cSt, 11cPC, 11cCtry

        'additional debtor
        pdfFormFields.SetField("10a", .Item("ud2_org_name") & "")
        pdfFormFields.SetField("10bS", .Item("ud2_ind_last_name") & "")
        pdfFormFields.SetField("10bF", .Item("ud2_ind_first_name") & "")
        pdfFormFields.SetField("10bA", .Item("ud2_ind_middle_name") & "")
        pdfFormFields.SetField("10bSfx", .Item("ud2_ind_suffix") & "")
        pdfFormFields.SetField("10cMA", .Item("ud2_mailing_address") & "")
        pdfFormFields.SetField("10cCty", .Item("ud2_city") & "")
        pdfFormFields.SetField("10cS", .Item("ud2_state") & "")
        pdfFormFields.SetField("10cPC", .Item("ud2_zipcode") & "")
        pdfFormFields.SetField("10cCtry", .Item("ud2_country") & "")
        'pdfFormFields.SetField("11d", .Item("ud2_d1") & "")
        'pdfFormFields.SetField("11e", (.Item("ud2_org_type") & "").ToString.ToUpper)
        'pdfFormFields.SetField("11f", .Item("ud2_org_jurisdiction") & "")
        'pdfFormFields.SetField("11g", .Item("ud2_org_id") & "")
        'pdfFormFields.SetField("11gCB", IIf(.Item("ud2_org_id_none") & "" = "Y", "Yes", "0"))
        'secured
        'pdfFormFields.SetField("1a3", .Item("ud1_org_name") & "")
        'pdfFormFields.SetField("1bL3", .Item("ud1_ind_last_name") & "")
        'pdfFormFields.SetField("1bF3", .Item("ud1_ind_first_name") & "")
        'pdfFormFields.SetField("1bM3", .Item("ud1_ind_middle_name") & "")
        'pdfFormFields.SetField("1bS3", .Item("ud1_ind_suffix") & "")
        'pdfFormFields.SetField("1c3", .Item("ud1_mailing_address") & "")
        'pdfFormFields.SetField("1cc3", .Item("ud1_city") & "")
        'pdfFormFields.SetField("1cs3", .Item("ud1_state") & "")
        'pdfFormFields.SetField("1cpc", .Item("ud1_zipcode") & "")
        'pdfFormFields.SetField("1cc3", .Item("ud1_country") & "")

        pdfFormFields.SetField("12", .Item("ufad_collateral") & "")
        'new field for Real estate - we won't use
        'pdfFormFields.SetField("13", "1")

        If .Item("ufad_covers") & "" = "T" Then
          pdfFormFields.SetField("14", "1")
        ElseIf .Item("ufad_covers") & "" = "A" Then
          pdfFormFields.SetField("14", "2")
        ElseIf .Item("ufad_covers") & "" = "F" Then
          pdfFormFields.SetField("14", "3")
        End If

        pdfFormFields.SetField("15", .Item("ufad_record_owner") & "")
        pdfFormFields.SetField("16", .Item("ufad_real_estate") & "")

        'If .Item("ufad_debtor_trust") & "" = "T" Then
        '  pdfFormFields.SetField("17CB", "1")
        'ElseIf .Item("ufad_debtor_trust") & "" = "E" Then
        '  pdfFormFields.SetField("17CB", "2")
        'ElseIf .Item("ufad_debtor_trust") & "" = "D" Then
        '  pdfFormFields.SetField("17CB", "3")
        'End If

        'If .Item("ufad_debtor_is") & "" = "T" Then
        '  pdfFormFields.SetField("18CB", "1")
        'ElseIf .Item("ufad_debtor_is") & "" = "M" Then
        '  pdfFormFields.SetField("18CB", "2")
        'ElseIf .Item("ufad_debtor_is") & "" = "P" Then
        '  pdfFormFields.SetField("18CB", "3")
        'End If

        pdfFormFields.SetField("17", .Item("ufad_misc") & "")

        '// flatten the form to remove editting options, set it to false
        '// to leave the form open to subsequent manual edits
        pdfStamper.FormFlattening = True

        '// close the pdf
        pdfStamper.Close()

        arrByte = memStream.ToArray()
        'Response.Expires = -1000
        'Response.ContentType = "application/pdf"
        'Response.AddHeader("content-length", arrByte.Length.ToString())
        'Response.AddHeader("content-disposition", "inline; filename=UCC1ad_" & .Item("ufad_id") & ".PDF")
        'Response.BinaryWrite(arrByte)
      End With
    End If

    dtData.Dispose()
    dtData = Nothing

    Return arrByte
  End Function

  Public Function GetUCC1ap_PDF(ByVal sID As String, ByVal sComID As String, Optional ByVal sHasCompanies As String = "N") As Byte()
    Dim strSQL As String, sWhereCom As String = ""
    Dim dtData As New DataTable
    Dim arrByte() As Byte = Nothing
    If sHasCompanies = "Y" Then
      sWhereCom = " in (Select company_id from subscriber where parent_company_id = " & sComID & ") "
    Else
      sWhereCom = " = " & sComID & " "
    End If

    strSQL = "Select ufap.*, " & _
      "ud1.ud_id as ud1_id,ud1.ud_org_name as ud1_org_name,ud1.ud_ind_last_name as ud1_ind_last_name,ud1.ud_ind_first_name as ud1_ind_first_name,ud1.ud_ind_middle_name as ud1_ind_middle_name,ud1.ud_ind_suffix as ud1_ind_suffix,ud1.ud_mailing_address as ud1_mailing_address,ud1.ud_city as ud1_city,ud1.ud_state as ud1_state,ud1.ud_zipcode as ud1_zipcode,ud1.ud_country as ud1_country,ud1.ud_d1 as ud1_d1,ud1.ud_org_type as ud1_org_type,ud1.ud_org_jurisdiction as ud1_org_jurisdiction,ud1.ud_org_id as ud1_org_id,ud1.ud_org_id_none as ud1_org_id_none, " & _
      "ud2.ud_id as ud2_id,ud2.ud_org_name as ud2_org_name,ud2.ud_ind_last_name as ud2_ind_last_name,ud2.ud_ind_first_name as ud2_ind_first_name,ud2.ud_ind_middle_name as ud2_ind_middle_name,ud2.ud_ind_suffix as ud2_ind_suffix,ud2.ud_mailing_address as ud2_mailing_address,ud2.ud_city as ud2_city,ud2.ud_state as ud2_state,ud2.ud_zipcode as ud2_zipcode,ud2.ud_country as ud2_country,ud2.ud_d1 as ud2_d1,ud2.ud_org_type as ud2_org_type,ud2.ud_org_jurisdiction as ud2_org_jurisdiction,ud2.ud_org_id as ud2_org_id,ud2.ud_org_id_none as ud2_org_id_none, " & _
      "ud3.ud_id as ud3_id,ud3.ud_org_name as ud3_org_name,ud3.ud_ind_last_name as ud3_ind_last_name,ud3.ud_ind_first_name as ud3_ind_first_name,ud3.ud_ind_middle_name as ud3_ind_middle_name,ud3.ud_ind_suffix as ud3_ind_suffix,ud3.ud_mailing_address as ud3_mailing_address,ud3.ud_city as ud3_city,ud3.ud_state as ud3_state,ud3.ud_zipcode as ud3_zipcode,ud3.ud_country as ud3_country,ud3.ud_d1 as ud3_d1,ud3.ud_org_type as ud3_org_type,ud3.ud_org_jurisdiction as ud3_org_jurisdiction,ud3.ud_org_id as ud3_org_id,ud3.ud_org_id_none as ud3_org_id_none, " & _
      "ud4.ud_id as ud4_id,ud4.ud_org_name as ud4_org_name,ud4.ud_ind_last_name as ud4_ind_last_name,ud4.ud_ind_first_name as ud4_ind_first_name,ud4.ud_ind_middle_name as ud4_ind_middle_name,ud4.ud_ind_suffix as ud4_ind_suffix,ud4.ud_mailing_address as ud4_mailing_address,ud4.ud_city as ud4_city,ud4.ud_state as ud4_state,ud4.ud_zipcode as ud4_zipcode,ud4.ud_country as ud4_country,ud4.ud_d1 as ud4_d1,ud4.ud_org_type as ud4_org_type,ud4.ud_org_jurisdiction as ud4_org_jurisdiction,ud4.ud_org_id as ud4_org_id,ud4.ud_org_id_none as ud4_org_id_none " & _
      "From ucc_financing_ap as ufap inner join ucc_financing as uf on ufap_uf_id = uf.uf_id " & _
      "left outer join ucc_debtor as ud1 on uf.uf_debtor1 = ud1.ud_id " & _
      "left outer join ucc_debtor as ud2 on ufap.ufap_debtor4 = ud2.ud_id " & _
      "left outer join ucc_debtor as ud3 on ufap.ufap_debtor5 = ud3.ud_id " & _
      "left outer join ucc_debtor as ud4 on ufap.ufap_debtor6 = ud4.ud_id " & _
      "Where ufap_id = " & sID & " and uf_company_id " & sWhereCom

    dtData = FillDataTable(strSQL)
    If dtData.Rows.Count > 0 Then
      With dtData.Rows(0)
        Dim pdfTemplate As String = UCC1ap_PDF
        Dim memStream As New MemoryStream

        Dim pdfReader As New PdfReader(pdfTemplate)
        ' New FileStream(newFile, FileMode.Create)
        Dim pdfStamper = New PdfStamper(pdfReader, memStream)
        Dim pdfFormFields As AcroFields = pdfStamper.AcroFields

        'Dim iCount As Integer = 0
        '// set form pdfFormFields
        'pdfFormFields.SetField("A", "Micah King, 217-753-4311")
        'pdfFormFields.SetField("B", "Identi-Check, Inc." & Environment.NewLine & "3 North Old State Capitol Plaza" & Environment.NewLine & "Springfield, IL 62701")
        'debtor from ucc1
        pdfFormFields.SetField("18a", .Item("ud1_org_name") & "")
        'if doesn't fit on one line - pdfFormFields.SetField("18a2", .Item("ud1_org_name") & "")
        pdfFormFields.SetField("18bS", .Item("ud1_ind_last_name") & "")
        pdfFormFields.SetField("18bF", .Item("ud1_ind_first_name") & "")
        pdfFormFields.SetField("18bA", .Item("ud1_ind_middle_name") & "")
        pdfFormFields.SetField("18bSfx", .Item("ud1_ind_suffix") & "")

        'first debtor
        pdfFormFields.SetField("19a", .Item("ud2_org_name") & "")
        pdfFormFields.SetField("19bS", .Item("ud2_ind_last_name") & "")
        pdfFormFields.SetField("19bF", .Item("ud2_ind_first_name") & "")
        pdfFormFields.SetField("19bA", .Item("ud2_ind_middle_name") & "")
        pdfFormFields.SetField("19bSfx", .Item("ud2_ind_suffix") & "")
        pdfFormFields.SetField("19cMA", .Item("ud2_mailing_address") & "")
        pdfFormFields.SetField("19cCty", .Item("ud2_city") & "")
        pdfFormFields.SetField("19cS", .Item("ud2_state") & "")
        pdfFormFields.SetField("19cPC", .Item("ud2_zipcode") & "")
        pdfFormFields.SetField("19cCtry", .Item("ud2_country") & "")
        'pdfFormFields.SetField("21d", .Item("ud2_d1") & "")
        'pdfFormFields.SetField("21e", (.Item("ud2_org_type") & "").ToString.ToUpper)
        'pdfFormFields.SetField("21f", .Item("ud2_org_jurisdiction") & "")
        'pdfFormFields.SetField("21g", .Item("ud2_org_id") & "")
        'pdfFormFields.SetField("21gCB", IIf(.Item("ud2_org_id_none") & "" = "Y", "Yes", "0"))
        'second debtor
        pdfFormFields.SetField("20a", .Item("ud3_org_name") & "")
        pdfFormFields.SetField("20bS", .Item("ud3_ind_last_name") & "")
        pdfFormFields.SetField("20bF", .Item("ud3_ind_first_name") & "")
        pdfFormFields.SetField("20bA", .Item("ud3_ind_middle_name") & "")
        pdfFormFields.SetField("20bSfx", .Item("ud3_ind_suffix") & "")
        pdfFormFields.SetField("20cMA", .Item("ud3_mailing_address") & "")
        pdfFormFields.SetField("20cCty", .Item("ud3_city") & "")
        pdfFormFields.SetField("20cS", .Item("ud3_state") & "")
        pdfFormFields.SetField("20cPC", .Item("ud3_zipcode") & "")
        pdfFormFields.SetField("20cCtry", .Item("ud3_country") & "")
        'pdfFormFields.SetField("22d", .Item("ud3_d1") & "")
        'pdfFormFields.SetField("22e", (.Item("ud3_org_type") & "").ToString.ToUpper)
        'pdfFormFields.SetField("22f", .Item("ud3_org_jurisdiction") & "")
        'pdfFormFields.SetField("22g", .Item("ud3_org_id") & "")
        'pdfFormFields.SetField("22gCB", IIf(.Item("ud3_org_id_none") & "" = "Y", "Yes", "0"))
        'third debtor
        pdfFormFields.SetField("21a", .Item("ud4_org_name") & "")
        pdfFormFields.SetField("21bS", .Item("ud4_ind_last_name") & "")
        pdfFormFields.SetField("21bF", .Item("ud4_ind_first_name") & "")
        pdfFormFields.SetField("21bA", .Item("ud4_ind_middle_name") & "")
        pdfFormFields.SetField("21bS", .Item("ud4_ind_suffix") & "")
        pdfFormFields.SetField("21cMA", .Item("ud4_mailing_address") & "")
        pdfFormFields.SetField("21cCty", .Item("ud4_city") & "")
        pdfFormFields.SetField("21cS", .Item("ud4_state") & "")
        pdfFormFields.SetField("21cPC", .Item("ud4_zipcode") & "")
        pdfFormFields.SetField("21cCtry", .Item("ud4_country") & "")
        'pdfFormFields.SetField("23d", .Item("ud4_d1") & "")
        'pdfFormFields.SetField("23e", (.Item("ud4_org_type") & "").ToString.ToUpper)
        'pdfFormFields.SetField("23f", .Item("ud4_org_jurisdiction") & "")
        'pdfFormFields.SetField("23g", .Item("ud4_org_id") & "")
        'pdfFormFields.SetField("23gCB", IIf(.Item("ud4_org_id_none") & "" = "Y", "Yes", "0"))

        '22 additional secured party
        '22 is 1 () or 2()
        '23 additional secured party
        '23 is 1 () or 2()


        pdfFormFields.SetField("24", .Item("ufap_misc") & "")

        '// flatten the form to remove editting options, set it to false
        '// to leave the form open to subsequent manual edits
        pdfStamper.FormFlattening = True

        '// close the pdf
        pdfStamper.Close()

        arrByte = memStream.ToArray()
        'Response.Expires = -1000
        'Response.ContentType = "application/pdf"
        'Response.AddHeader("content-length", arrByte.Length.ToString())
        'Response.AddHeader("content-disposition", "inline; filename=UCC1ap_" & .Item("ufap_id") & ".PDF")
        'Response.BinaryWrite(arrByte)
      End With
    End If

    dtData.Dispose()
    dtData = Nothing

    Return arrByte
  End Function

  Public Function GetUCC3_PDF(ByVal sID As String, ByVal sComID As String, Optional ByVal sHasCompanies As String = "N") As Byte()
    Dim strSQL As String, sWhereCom As String = ""
    Dim dtData As New DataTable
    Dim arrByte() As Byte = Nothing
    If sHasCompanies = "Y" Then
      sWhereCom = " in (Select company_id from subscriber where parent_company_id = " & sComID & ") "
    Else
      sWhereCom = " = " & sComID & " "
    End If

    strSQL = "Select ucc3.*, " & _
      "ud1.ud_id as ud1_id,ud1.ud_org_name as ud1_org_name,ud1.ud_ind_last_name as ud1_ind_last_name,ud1.ud_ind_first_name as ud1_ind_first_name,ud1.ud_ind_middle_name as ud1_ind_middle_name,ud1.ud_ind_suffix as ud1_ind_suffix,ud1.ud_mailing_address as ud1_mailing_address,ud1.ud_city as ud1_city,ud1.ud_state as ud1_state,ud1.ud_zipcode as ud1_zipcode,ud1.ud_country as ud1_country,ud1.ud_d1 as ud1_d1,ud1.ud_org_type as ud1_org_type,ud1.ud_org_jurisdiction as ud1_org_jurisdiction,ud1.ud_org_id as ud1_org_id,ud1.ud_org_id_none as ud1_org_id_none " & _
      "From ucc3 left outer join ucc_debtor as ud1 on ucc3.u3_new_debtor = ud1.ud_id " & _
      "Where u3_id = " & sID & " and u3_company_id " & sWhereCom

    dtData = FillDataTable(strSQL)
    If dtData.Rows.Count > 0 Then
      With dtData.Rows(0)
        Dim pdfTemplate As String = UCC3_PDF
        Dim memStream As New MemoryStream

        Dim pdfReader As New PdfReader(pdfTemplate)
        ' New FileStream(newFile, FileMode.Create)
        Dim pdfStamper = New PdfStamper(pdfReader, memStream)
        Dim pdfFormFields As AcroFields = pdfStamper.AcroFields

        'Dim iCount As Integer = 0
        '// set form pdfFormFields
        pdfFormFields.SetField("A", "Micah King, 217-753-4311")
        pdfFormFields.SetField("B", "info@identi-check.com")
        pdfFormFields.SetField("C", "Identi-Check, Inc." & Environment.NewLine & "3 North Old State Capitol Plaza" & Environment.NewLine & "Springfield, IL 62701")

        pdfFormFields.SetField("1a", .Item("u3_initial_file_no") & "")
        pdfFormFields.SetField("1b", IIf(.Item("u3_real_estate") & "" = "Y", "Yes", ""))

        'they combined fields
        pdfFormFields.SetField("2 and 4", IIf(.Item("u3_termination") & "" = "Y", "1", IIf(.Item("u3_continuation") & "" = "Y", "2", "")))
        'pdfFormFields.SetField("9CB", IIf(.Item("u3_termination") & "" = "Y", "Yes", ""))

        pdfFormFields.SetField("3 and 5", IIf(.Item("u3_assignment") & "" = "Y", "1", IIf(Trim(.Item("u3_amendment_affects") & "") <> "" Or Trim(.Item("u3_amendment") & "") <> "", "2", "")))
        'pdfFormFields.SetField("4", IIf(.Item("u3_assignment") & "" = "Y", "Yes", ""))

        If .Item("u3_assignment") & "" <> "Y" Then
          If .Item("u3_amendment_affects") & "" = "D" Then
            pdfFormFields.SetField("5a", "1")
          ElseIf .Item("u3_amendment_affects") & "" = "S" Then
            pdfFormFields.SetField("5a", "2")
          End If

          If .Item("u3_amendment") & "" = "C" Then
            pdfFormFields.SetField("5b", "1")
          ElseIf .Item("u3_amendment") & "" = "D" Then
            pdfFormFields.SetField("5b", "3")
          ElseIf .Item("u3_amendment") & "" = "A" Then
            pdfFormFields.SetField("5b", "2")
          End If
        End If

        'orig debtor
        pdfFormFields.SetField("6a", .Item("u3_old_org_name") & "")
        pdfFormFields.SetField("6bS", .Item("u3_old_ind_last_name") & "")
        pdfFormFields.SetField("6bF", .Item("u3_old_ind_first_name") & "")
        pdfFormFields.SetField("6bA", .Item("u3_old_ind_middle_name") & "")
        pdfFormFields.SetField("6bSfx", .Item("u3_old_ind_suffix") & "")

        'new debtor
        pdfFormFields.SetField("7a", .Item("ud1_org_name") & "")
        pdfFormFields.SetField("7b", .Item("ud1_ind_last_name") & "")
        pdfFormFields.SetField("7bF", .Item("ud1_ind_first_name") & "")
        pdfFormFields.SetField("7bA", .Item("ud1_ind_middle_name") & "")
        pdfFormFields.SetField("7bSfx", .Item("ud1_ind_suffix") & "")
        pdfFormFields.SetField("7cMA", .Item("ud1_mailing_address") & "")
        pdfFormFields.SetField("7cCty", .Item("ud1_city") & "")
        pdfFormFields.SetField("7cS", .Item("ud1_state") & "")
        pdfFormFields.SetField("7cPC", .Item("ud1_zipcode") & "")
        pdfFormFields.SetField("7cCtry", .Item("ud1_country") & "")
        'pdfFormFields.SetField("7d", .Item("ud1_d1") & "")
        'pdfFormFields.SetField("7e", (.Item("ud1_org_type") & "").ToString.ToUpper)
        'pdfFormFields.SetField("7f", .Item("ud1_org_jurisdiction") & "")
        'pdfFormFields.SetField("7g", .Item("ud1_org_id") & "")
        'pdfFormFields.SetField("7gCB", IIf(.Item("ud1_org_id_none") & "" = "Y", "Yes", "0"))

        If (.Item("u3_collateral_change") & "").Trim <> "" Then
          pdfFormFields.SetField("8a", "Yes")
        End If
        If .Item("u3_collateral_change") & "" = "D" Then
          pdfFormFields.SetField("8b", "2")
        ElseIf .Item("u3_collateral_change") & "" = "A" Then
          pdfFormFields.SetField("8b", "1")
        ElseIf .Item("u3_collateral_change") & "" = "R" Then
          pdfFormFields.SetField("8b", "3")
        ElseIf .Item("u3_collateral_change") & "" = "S" Then
          pdfFormFields.SetField("8b", "4")
        End If
        pdfFormFields.SetField("8", .Item("u3_collateral") & "")

        pdfFormFields.SetField("10", .Item("u3_reference_data") & "")

        'secured
        pdfFormFields.SetField("9a", .Item("u3_secured_org_name") & "")
        'pdfFormFields.SetField("9bS", .Item("ud1_ind_last_name") & "")
        'pdfFormFields.SetField("9bF", .Item("ud1_ind_first_name") & "")
        'pdfFormFields.SetField("9bA", .Item("ud1_ind_middle_name") & "")
        'pdfFormFields.SetField("9bSfx", .Item("ud1_ind_suffix") & "")
        ''pdfFormFields.SetField("9c", .Item("u3_secured_mailing_address") & "")
        ''pdfFormFields.SetField("9cc", .Item("u3_secured_city") & "")
        ''pdfFormFields.SetField("9cs", .Item("u3_secured_state") & "")
        ''pdfFormFields.SetField("9cpc", .Item("u3_secured_zipcode") & "")
        ''pdfFormFields.SetField("9cc", .Item("u3_secured_country") & "")

        '// flatten the form to remove editting options, set it to false
        '// to leave the form open to subsequent manual edits
        pdfStamper.FormFlattening = True

        '// close the pdf
        pdfStamper.Close()

        arrByte = memStream.ToArray()
        'Response.Expires = -1000
        'Response.ContentType = "application/pdf"
        'Response.AddHeader("content-length", arrByte.Length.ToString())
        'Response.AddHeader("content-disposition", "inline; filename=UCC3_" & .Item("u3_id") & ".PDF")
        'Response.BinaryWrite(arrByte)
      End With
    End If

    dtData.Dispose()
    dtData = Nothing

    Return arrByte
  End Function

  Public Function GetUCC3ad_PDF(ByVal sID As String, ByVal sComID As String, ByVal sHasCompanies As String) As Byte()
    Dim strSQL As String, sWhereCom As String = ""
    Dim dtData As New DataTable
    Dim arrByte() As Byte = Nothing
    If sHasCompanies = "Y" Then
      sWhereCom = " in (Select company_id from subscriber where parent_company_id = " & sComID & ") "
    Else
      sWhereCom = " = " & sComID & " "
    End If

    strSQL = "Select * " & _
      "From ucc3_ad as u3ad inner join ucc3 as u3 on u3ad.u3ad_u3_id = u3.u3_id " & _
      "Where u3ad_id = " & sID & " and u3_company_id " & sWhereCom

    dtData = FillDataTable(strSQL)
    If dtData.Rows.Count > 0 Then
      With dtData.Rows(0)
        Dim pdfTemplate As String = UCC3ad_PDF
        Dim memStream As New MemoryStream

        Dim pdfReader As New PdfReader(pdfTemplate)
        ' New FileStream(newFile, FileMode.Create)
        Dim pdfStamper = New PdfStamper(pdfReader, memStream)
        Dim pdfFormFields As AcroFields = pdfStamper.AcroFields

        'Dim iCount As Integer = 0
        '// set form pdfFormFields
        'pdfFormFields.SetField("A", "Micah King, 217-753-4311")
        'pdfFormFields.SetField("B", "Identi-Check, Inc." & Environment.NewLine & "3 North Old State Capitol Plaza" & Environment.NewLine & "Springfield, IL 62701")

        pdfFormFields.SetField("11", .Item("u3_initial_file_no") & "")
        pdfFormFields.SetField("12a", .Item("u3_secured_org_name") & "")
        'if won't fit on one line - pdfFormFields.SetField("12a2", .Item("u3_secured_org_name") & "")
        'pdfFormFields.SetField("12bS", .Item("u3_secured_ind_last_name") & "")
        'pdfFormFields.SetField("12bF", .Item("u3_secured_ind_first_name") & "")
        'pdfFormFields.SetField("12bA", .Item("u3_secured_ind_middle_name") & "")
        'pdfFormFields.SetField("12bSfx", .Item("u3_secured_ind_suffix") & "")

        '13 - debtor name from ucc3
        'pdfFormFields.SetField("13a", "")
        'pdfFormFields.SetField("13bS", "")
        'pdfFormFields.SetField("13bF", "")
        'pdfFormFields.SetField("12bA", "")
        'pdfFormFields.SetField("13bSfx", "")

        pdfFormFields.SetField("14", .Item("u3ad_info") & "")

        If .Item("u3ad_covers") & "" = "T" Then
          pdfFormFields.SetField("15", "1")
        ElseIf .Item("u3ad_covers") & "" = "A" Then
          pdfFormFields.SetField("15", "2")
        ElseIf .Item("u3ad_covers") & "" = "F" Then
          pdfFormFields.SetField("15", "3")
        End If

        pdfFormFields.SetField("16", .Item("u3ad_record_owner") & "")
        pdfFormFields.SetField("17", .Item("u3ad_real_estate") & "")
        pdfFormFields.SetField("18", .Item("u3ad_misc") & "")

        '// flatten the form to remove editting options, set it to false
        '// to leave the form open to subsequent manual edits
        pdfStamper.FormFlattening = True

        '// close the pdf
        pdfStamper.Close()

        arrByte = memStream.ToArray()
        'Response.Expires = -1000
        'Response.ContentType = "application/pdf"
        'Response.AddHeader("content-length", arrByte.Length.ToString())
        'Response.AddHeader("content-disposition", "inline; filename=UCC3ad_" & .Item("u3ad_id") & ".PDF")
        'Response.BinaryWrite(arrByte)
      End With
    End If

    dtData.Dispose()
    dtData = Nothing

    Return arrByte
  End Function

  Public Function GetUCC3ap_PDF(ByVal sID As String, ByVal sComID As String, Optional ByVal sHasCompanies As String = "N") As Byte()
    Dim strSQL As String, sWhereCom As String = ""
    Dim dtData As New DataTable
    Dim arrByte() As Byte = Nothing
    If sHasCompanies = "Y" Then
      sWhereCom = " in (Select company_id from subscriber where parent_company_id = " & sComID & ") "
    Else
      sWhereCom = " = " & sComID & " "
    End If

    strSQL = "Select u3.*, u3ap.*, " & _
      "ud2.ud_id as ud2_id,ud2.ud_org_name as ud2_org_name,ud2.ud_ind_last_name as ud2_ind_last_name,ud2.ud_ind_first_name as ud2_ind_first_name,ud2.ud_ind_middle_name as ud2_ind_middle_name,ud2.ud_ind_suffix as ud2_ind_suffix,ud2.ud_mailing_address as ud2_mailing_address,ud2.ud_city as ud2_city,ud2.ud_state as ud2_state,ud2.ud_zipcode as ud2_zipcode,ud2.ud_country as ud2_country,ud2.ud_d1 as ud2_d1,ud2.ud_org_type as ud2_org_type,ud2.ud_org_jurisdiction as ud2_org_jurisdiction,ud2.ud_org_id as ud2_org_id,ud2.ud_org_id_none as ud2_org_id_none, " & _
      "ud3.ud_id as ud3_id,ud3.ud_org_name as ud3_org_name,ud3.ud_ind_last_name as ud3_ind_last_name,ud3.ud_ind_first_name as ud3_ind_first_name,ud3.ud_ind_middle_name as ud3_ind_middle_name,ud3.ud_ind_suffix as ud3_ind_suffix,ud3.ud_mailing_address as ud3_mailing_address,ud3.ud_city as ud3_city,ud3.ud_state as ud3_state,ud3.ud_zipcode as ud3_zipcode,ud3.ud_country as ud3_country,ud3.ud_d1 as ud3_d1,ud3.ud_org_type as ud3_org_type,ud3.ud_org_jurisdiction as ud3_org_jurisdiction,ud3.ud_org_id as ud3_org_id,ud3.ud_org_id_none as ud3_org_id_none, " & _
      "ud4.ud_id as ud4_id,ud4.ud_org_name as ud4_org_name,ud4.ud_ind_last_name as ud4_ind_last_name,ud4.ud_ind_first_name as ud4_ind_first_name,ud4.ud_ind_middle_name as ud4_ind_middle_name,ud4.ud_ind_suffix as ud4_ind_suffix,ud4.ud_mailing_address as ud4_mailing_address,ud4.ud_city as ud4_city,ud4.ud_state as ud4_state,ud4.ud_zipcode as ud4_zipcode,ud4.ud_country as ud4_country,ud4.ud_d1 as ud4_d1,ud4.ud_org_type as ud4_org_type,ud4.ud_org_jurisdiction as ud4_org_jurisdiction,ud4.ud_org_id as ud4_org_id,ud4.ud_org_id_none as ud4_org_id_none " & _
      "From ucc3_ap as u3ap inner join ucc3 as u3 on u3ap_u3_id = u3.u3_id " & _
      "left outer join ucc_debtor as ud2 on u3ap.u3ap_debtor2 = ud2.ud_id " & _
      "left outer join ucc_debtor as ud3 on u3ap.u3ap_debtor3 = ud3.ud_id " & _
      "left outer join ucc_debtor as ud4 on u3ap.u3ap_debtor4 = ud4.ud_id " & _
      "Where u3ap_id = " & sID & " and u3_company_id " & sWhereCom

    dtData = FillDataTable(strSQL)
    If dtData.Rows.Count > 0 Then
      With dtData.Rows(0)
        Dim pdfTemplate As String = UCC3ap_PDF
        Dim memStream As New MemoryStream

        Dim pdfReader As New PdfReader(pdfTemplate)
        ' New FileStream(newFile, FileMode.Create)
        Dim pdfStamper = New PdfStamper(pdfReader, memStream)
        Dim pdfFormFields As AcroFields = pdfStamper.AcroFields

        'Dim iCount As Integer = 0
        '// set form pdfFormFields
        'pdfFormFields.SetField("A", "Micah King, 217-753-4311")
        'pdfFormFields.SetField("B", "Identi-Check, Inc." & Environment.NewLine & "3 North Old State Capitol Plaza" & Environment.NewLine & "Springfield, IL 62701")
        pdfFormFields.SetField("19", .Item("u3_initial_file_no") & "")
        pdfFormFields.SetField("20a", .Item("u3_secured_org_name") & "")
        'if won't fit on one line - pdfFormFields.SetField("20a2", .Item("u3_secured_org_name") & "")


        'first debtor
        pdfFormFields.SetField("21a", .Item("ud2_org_name") & "")
        pdfFormFields.SetField("21bS", .Item("ud2_ind_last_name") & "")
        pdfFormFields.SetField("21bF", .Item("ud2_ind_first_name") & "")
        pdfFormFields.SetField("21bA", .Item("ud2_ind_middle_name") & "")
        pdfFormFields.SetField("21bSfx", .Item("ud2_ind_suffix") & "")
        pdfFormFields.SetField("21cMA", .Item("ud2_mailing_address") & "")
        pdfFormFields.SetField("21cCty", .Item("ud2_city") & "")
        pdfFormFields.SetField("21cS", .Item("ud2_state") & "")
        pdfFormFields.SetField("21cPC", .Item("ud2_zipcode") & "")
        pdfFormFields.SetField("21cCtry", .Item("ud2_country") & "")
        'pdfFormFields.SetField("17d", .Item("ud2_d1") & "")
        'pdfFormFields.SetField("17e", (.Item("ud2_org_type") & "").ToString.ToUpper)
        'pdfFormFields.SetField("17f", .Item("ud2_org_jurisdiction") & "")
        'pdfFormFields.SetField("17g", .Item("ud2_org_id") & "")
        'pdfFormFields.SetField("17gCB", IIf(.Item("ud2_org_id_none") & "" = "Y", "Yes", "0"))
        'second debtor
        pdfFormFields.SetField("22a", .Item("ud3_org_name") & "")
        pdfFormFields.SetField("22bS", .Item("ud3_ind_last_name") & "")
        pdfFormFields.SetField("22bF", .Item("ud3_ind_first_name") & "")
        pdfFormFields.SetField("22bA", .Item("ud3_ind_middle_name") & "")
        pdfFormFields.SetField("22bSfx", .Item("ud3_ind_suffix") & "")
        pdfFormFields.SetField("22cMA", .Item("ud3_mailing_address") & "")
        pdfFormFields.SetField("22cCty", .Item("ud3_city") & "")
        pdfFormFields.SetField("22cS", .Item("ud3_state") & "")
        pdfFormFields.SetField("22cPC", .Item("ud3_zipcode") & "")
        pdfFormFields.SetField("22cCtry", .Item("ud3_country") & "")
        'pdfFormFields.SetField("18d", .Item("ud3_d1") & "")
        'pdfFormFields.SetField("18e", (.Item("ud3_org_type") & "").ToString.ToUpper)
        'pdfFormFields.SetField("18f", .Item("ud3_org_jurisdiction") & "")
        'pdfFormFields.SetField("18g", .Item("ud3_org_id") & "")
        'pdfFormFields.SetField("18gCB", IIf(.Item("ud3_org_id_none") & "" = "Y", "Yes", "0"))
        'third debtor
        pdfFormFields.SetField("23a", .Item("ud4_org_name") & "")
        pdfFormFields.SetField("23bS", .Item("ud4_ind_last_name") & "")
        pdfFormFields.SetField("23bF", .Item("ud4_ind_first_name") & "")
        pdfFormFields.SetField("23bA", .Item("ud4_ind_middle_name") & "")
        pdfFormFields.SetField("23bSfx", .Item("ud4_ind_suffix") & "")
        pdfFormFields.SetField("23cMA", .Item("ud4_mailing_address") & "")
        pdfFormFields.SetField("23cCty", .Item("ud4_city") & "")
        pdfFormFields.SetField("23cS", .Item("ud4_state") & "")
        pdfFormFields.SetField("23cPC", .Item("ud4_zipcode") & "")
        pdfFormFields.SetField("23cCtry", .Item("ud4_country") & "")
        'pdfFormFields.SetField("19d", .Item("ud4_d1") & "")
        'pdfFormFields.SetField("19e", (.Item("ud4_org_type") & "").ToString.ToUpper)
        'pdfFormFields.SetField("19f", .Item("ud4_org_jurisdiction") & "")
        'pdfFormFields.SetField("19g", .Item("ud4_org_id") & "")
        'pdfFormFields.SetField("19gCB", IIf(.Item("ud4_org_id_none") & "" = "Y", "Yes", "0"))

        'secured2 is 24
        'secured3 is 25

        pdfFormFields.SetField("26", .Item("u3ap_misc") & "")

        '// flatten the form to remove editting options, set it to false
        '// to leave the form open to subsequent manual edits
        pdfStamper.FormFlattening = True

        '// close the pdf
        pdfStamper.Close()

        arrByte = memStream.ToArray()
        'Response.Expires = -1000
        'Response.ContentType = "application/pdf"
        'Response.AddHeader("content-length", arrByte.Length.ToString())
        'Response.AddHeader("content-disposition", "inline; filename=UCC1ap_" & .Item("ufap_id") & ".PDF")
        'Response.BinaryWrite(arrByte)
      End With
    End If

    dtData.Dispose()
    dtData = Nothing

    Return arrByte
  End Function

  Public Function GetAD_AP_From_UCC1(ByVal sID As String, ByRef sAD_ID As String) As String
    Dim sRtn As String = ""

    Dim sSQL As String = "Select (Select ufad_id From ucc_financing_ad Where ufad_uf_id = " & sID & ") as AD_ID, " & _
      "(Select ufap_id From ucc_financing_ap Where ufap_uf_id = " & sID & ") as AP_ID"
    Dim dtData As DataTable = FillDataTable(sSQL)
    If dtData.Rows.Count > 0 Then
      sAD_ID = dtData.Rows(0).Item("AD_ID") & ""
      sRtn = dtData.Rows(0).Item("AP_ID") & ""
    Else
      '
    End If
    dtData.Dispose()
    dtData = Nothing

    Return sRtn
  End Function

  Public Function GetAD_AP_From_UCC3(ByVal sID As String, ByRef sAD_ID As String) As String
    Dim sRtn As String = ""

    Dim sSQL As String = "Select (Select u3ad_id From ucc3_ad Where u3ad_u3_id = " & sID & ") as AD_ID, " & _
      "(Select u3ap_id From ucc3_ap Where u3ap_u3_id = " & sID & ") as AP_ID"
    Dim dtData As DataTable = FillDataTable(sSQL)
    If dtData.Rows.Count > 0 Then
      sAD_ID = dtData.Rows(0).Item("AD_ID") & ""
      sRtn = dtData.Rows(0).Item("AP_ID") & ""
    Else
      '
    End If
    dtData.Dispose()
    dtData = Nothing

    Return sRtn
  End Function

  Public Function TextWidth(TheText As [String]) As Integer
    Dim DrawFont As System.Drawing.Font = Nothing
    Dim DrawGraphics As System.Drawing.Graphics = Nothing
    Dim TextBitmap As System.Drawing.Bitmap = Nothing
    Try
      TextBitmap = New System.Drawing.Bitmap(1, 1)
      DrawGraphics = System.Drawing.Graphics.FromImage(TextBitmap)
      DrawFont = New System.Drawing.Font("Segoe UI", 12)

      Dim Width As Integer = CInt(DrawGraphics.MeasureString(TheText, DrawFont).Width)

      Return Width
    Finally
      TextBitmap.Dispose()
      DrawFont.Dispose()
      DrawGraphics.Dispose()
    End Try
  End Function

  Public Function GetEmailTemplate() As String
    'Dim dtData As New DataTable
    Dim sbRtn As New System.Text.StringBuilder()
    Dim sbTemp As New System.Text.StringBuilder

    sbRtn.Append("<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.0 Transitional//EN""><html xmlns=""http://www.w3.org/1999/xhtml""><head>" & vbCrLf)
    sbRtn.Append("<base href=""http://www.identi-check/index.aspx"">" & vbCrLf)
    sbRtn.Append("</head><body>" & vbCrLf)
    '<table width="775" cellpadding="0" cellspacing="0" style="margin:0 auto;width:775px;border:solid #000000 1.0pt">
    sbRtn.Append("<table width=""775"" cellpadding=""0"" cellspacing=""0"" style=""margin:0 auto;width:775px;border:solid #000000 1.0pt"">" & vbCrLf)
    sbRtn.Append("<tr><td><img src=""http://www.identi-check.com/images/logo_lg.png"" alt='logo' /></td></tr>" & vbCrLf)
    sbRtn.Append("" & vbCrLf)
    sbRtn.Append("<tr><td>" & vbCrLf)
    sbRtn.Append("<!-- Content -->" & vbCrLf)
    sbRtn.Append("</td></tr>" & vbCrLf)
    sbRtn.Append("" & vbCrLf)
    sbRtn.Append("" & vbCrLf)
    sbRtn.Append("</table>" & vbCrLf)
    sbRtn.Append("</body></html>" & vbCrLf)

    '../images/middle.png - cid:image-middle
    '../images/right.png - cid:image-right
    '../images/bottom.png - cid:image-bottom
    '../images/tab_01.png - cid:image-tab1
    '../images/tab_03.png - cid:image-tab3
    '../images/tab_05.png - cid:image-tab5
    'images/logo.png - cid:image-logo
    'images/hire_right.png - cid:image-hire-right
    'images/home-white.png - cid:image-home-white
    'images/home-yellow.png - cid:image-home-yellow
    'images/about-white.png - cid:image-about-white
    'images/about-yellow.png - cid:image-about-yellow
    'images/signup-white.png - cid:image-signup-white
    'images/signup-yellow.png - cid:image-signup-yellow
    'images/services-white.png - cid:image-services-white
    'images/services-yellow.png - cid:image-service-yellow
    'images/contact-white.png - cid:image-contact-white
    'images/contact-yellow.png - cid:image-contact-yellow
    'images/faq-white.png - cid:image-faq-white
    'images/faq-yellow.png - cid:image-faq-yellow
    'images/left.png - cid:image-left
    'right_tab_edge.png - cid:image-right_tab_edge
    'images/bottom_01.png - cid:image-bottom1
    'images/bottom_02.png - cid:image-bottom2
    'images/bottom_03.png - cid:image-bottom3
    'images/bottom_04.png - cid:image-bottom4
    sbTemp.Append("<!DOCTYPE html PUBLIC ""-//W3C//DTD XHTML 1.0 Transitional//EN"" ""http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"">" & vbCrLf)
    sbTemp.Append("" & vbCrLf)
    sbTemp.Append("<html xmlns=""http://www.w3.org/1999/xhtml"">" & vbCrLf)
    sbTemp.Append("<head>" & vbCrLf)
    sbTemp.Append("    <title>Identi-Check</title>" & vbCrLf)
    sbTemp.Append("" & vbCrLf)
    sbTemp.Append("<style type=""text/css"" >" & vbCrLf)
    sbTemp.Append("" & vbCrLf)
    sbTemp.Append("/* *************************************** GENERAL CSS *************************************** */" & vbCrLf)
    sbTemp.Append("	body {" & vbCrLf)
    sbTemp.Append("		background-color: #000000;" & vbCrLf)
    sbTemp.Append("		margin: 0 auto;" & vbCrLf)
    sbTemp.Append("		font-family:Arial, Helvetica, sans-serif;" & vbCrLf)
    sbTemp.Append("		font-size: 14px;" & vbCrLf)
    sbTemp.Append("		color: #ffffff;" & vbCrLf)
    sbTemp.Append("	}" & vbCrLf)
    sbTemp.Append("	" & vbCrLf)
    sbTemp.Append("	a {" & vbCrLf)
    sbTemp.Append("		color: #eb2727;" & vbCrLf)
    sbTemp.Append("	}" & vbCrLf)
    sbTemp.Append("	" & vbCrLf)
    sbTemp.Append("	img {" & vbCrLf)
    sbTemp.Append("		border: 0px;" & vbCrLf)
    sbTemp.Append("	}" & vbCrLf)
    sbTemp.Append("	" & vbCrLf)
    sbTemp.Append("	h5 {" & vbCrLf)
    sbTemp.Append("		margin: 0;" & vbCrLf)
    sbTemp.Append("	}" & vbCrLf)
    sbTemp.Append("	" & vbCrLf)
    sbTemp.Append("	.big_text {" & vbCrLf)
    sbTemp.Append("		font-size: 13px;" & vbCrLf)
    sbTemp.Append("		font-weight: bold;" & vbCrLf)
    sbTemp.Append("	}" & vbCrLf)
    sbTemp.Append("	" & vbCrLf)
    sbTemp.Append("	ul {" & vbCrLf)
    sbTemp.Append("		/*margin: 0px 0px 10px 15px;*/" & vbCrLf)
    sbTemp.Append("		margin-top: 0px;" & vbCrLf)
    sbTemp.Append("		font-size: 12px;" & vbCrLf)
    sbTemp.Append("	}" & vbCrLf)
    sbTemp.Append("/* ************************************* END GENERAL CSS ************************************* */" & vbCrLf)
    sbTemp.Append("" & vbCrLf)
    sbTemp.Append("/* *********************************** GRAPHIC LAYOUT CSS ************************************ */" & vbCrLf)
    sbTemp.Append("	#head {" & vbCrLf)
    sbTemp.Append("		width: 900px;" & vbCrLf)
    sbTemp.Append("		height: 142px;" & vbCrLf)
    sbTemp.Append("		margin: 0 auto;" & vbCrLf)
    sbTemp.Append("	}" & vbCrLf)
    sbTemp.Append("	" & vbCrLf)
    sbTemp.Append("	#logo {" & vbCrLf)
    sbTemp.Append("		width: 318px;" & vbCrLf)
    sbTemp.Append("		height: 142px;" & vbCrLf)
    sbTemp.Append("		float: left;" & vbCrLf)
    sbTemp.Append("	}" & vbCrLf)
    sbTemp.Append("	" & vbCrLf)
    sbTemp.Append("	#topnav {" & vbCrLf)
    sbTemp.Append("		width: 582px;" & vbCrLf)
    sbTemp.Append("		height: 142px;" & vbCrLf)
    sbTemp.Append("		float: right;" & vbCrLf)
    sbTemp.Append("	}" & vbCrLf)
    sbTemp.Append("	" & vbCrLf)
    sbTemp.Append("	#menu {" & vbCrLf)
    sbTemp.Append("		padding:0;" & vbCrLf)
    sbTemp.Append("		margin:0;" & vbCrLf)
    sbTemp.Append("		white-space:nowrap;" & vbCrLf)
    sbTemp.Append("		list-style-type:none;" & vbCrLf)
    sbTemp.Append("	}" & vbCrLf)
    sbTemp.Append("	" & vbCrLf)
    sbTemp.Append("	#menu li {" & vbCrLf)
    sbTemp.Append("		display:inline;" & vbCrLf)
    sbTemp.Append("	}" & vbCrLf)
    sbTemp.Append("	" & vbCrLf)
    sbTemp.Append("	#menu li a {" & vbCrLf)
    sbTemp.Append("		padding:0;" & vbCrLf)
    sbTemp.Append("		float:left;" & vbCrLf)
    sbTemp.Append("	}" & vbCrLf)
    sbTemp.Append("	#main {" & vbCrLf)
    sbTemp.Append("		margin: 0 auto;" & vbCrLf)
    sbTemp.Append("		width: 900px;" & vbCrLf)
    sbTemp.Append("	}" & vbCrLf)
    sbTemp.Append("	" & vbCrLf)
    sbTemp.Append("	#left {" & vbCrLf)
    sbTemp.Append("		width: 162px;" & vbCrLf)
    sbTemp.Append("		float: left;" & vbCrLf)
    sbTemp.Append("	}" & vbCrLf)
    sbTemp.Append("	" & vbCrLf)
    sbTemp.Append("	#middle {" & vbCrLf)
    sbTemp.Append("		width: 619px;" & vbCrLf)
    sbTemp.Append("		float: left;" & vbCrLf)
    sbTemp.Append("		margin: 0 auto;" & vbCrLf)
    sbTemp.Append("		min-height: 419px;" & vbCrLf)
    sbTemp.Append("		background-color: #221e1f;" & vbCrLf)
    sbTemp.Append("		background-image: url(cid:image-middle);" & vbCrLf)
    sbTemp.Append("		background-repeat: repeat-y;" & vbCrLf)
    sbTemp.Append("	}" & vbCrLf)
    sbTemp.Append("	" & vbCrLf)
    sbTemp.Append("	#right {" & vbCrLf)
    sbTemp.Append("		width: 119px;" & vbCrLf)
    sbTemp.Append("		float: right;" & vbCrLf)
    sbTemp.Append("		min-height: 419px;" & vbCrLf)
    sbTemp.Append("		background-image: url(cid:image-right);" & vbCrLf)
    sbTemp.Append("	}" & vbCrLf)
    sbTemp.Append("	" & vbCrLf)
    sbTemp.Append("	#foot {" & vbCrLf)
    sbTemp.Append("		margin: 0 auto;" & vbCrLf)
    sbTemp.Append("		width: 900px;" & vbCrLf)
    sbTemp.Append("		height: 114px;" & vbCrLf)
    sbTemp.Append("/*		background-image: url(cid:image-bottom);" & vbCrLf)
    sbTemp.Append("		background-repeat: no-repeat; */" & vbCrLf)
    sbTemp.Append("		clear: both;" & vbCrLf)
    sbTemp.Append("	}" & vbCrLf)
    sbTemp.Append("/* ********************************* END GRAPHIC LAYOUT CSS ********************************** */" & vbCrLf)
    sbTemp.Append("" & vbCrLf)
    sbTemp.Append("/* **************************************** TABLES CSS *************************************** */" & vbCrLf)
    sbTemp.Append("	" & vbCrLf)
    sbTemp.Append("	#table_reg {" & vbCrLf)
    sbTemp.Append("		width: 100%;" & vbCrLf)
    sbTemp.Append("		border: thin solid #666;" & vbCrLf)
    sbTemp.Append("		border-collapse: collapse;" & vbCrLf)
    sbTemp.Append("		font-size:10px;" & vbCrLf)
    sbTemp.Append("	}" & vbCrLf)
    sbTemp.Append("	" & vbCrLf)
    sbTemp.Append("	#table_wide {" & vbCrLf)
    sbTemp.Append("		border: thin solid #666;" & vbCrLf)
    sbTemp.Append("		border-collapse: collapse;" & vbCrLf)
    sbTemp.Append("		font-size:10px;" & vbCrLf)
    sbTemp.Append("	}" & vbCrLf)
    sbTemp.Append("	" & vbCrLf)
    sbTemp.Append("	#table_wide th," & vbCrLf)
    sbTemp.Append("	#table_reg th {" & vbCrLf)
    sbTemp.Append("		font-weight: bolder;" & vbCrLf)
    sbTemp.Append("		text-align: center;" & vbCrLf)
    sbTemp.Append("		color: #ffffff;" & vbCrLf)
    sbTemp.Append("		border: thin solid #666;" & vbCrLf)
    sbTemp.Append("		background-color: #666666;" & vbCrLf)
    sbTemp.Append("		font-size:11px;" & vbCrLf)
    sbTemp.Append("	}" & vbCrLf)
    sbTemp.Append("	" & vbCrLf)
    sbTemp.Append("	#table_wide td," & vbCrLf)
    sbTemp.Append("	#table_reg td {" & vbCrLf)
    sbTemp.Append("		border: thin solid #666;" & vbCrLf)
    sbTemp.Append("	} " & vbCrLf)
    sbTemp.Append("	/* *************************************** LEFT SIDE TAB CSS ************************************** */" & vbCrLf)
    sbTemp.Append("	#left-tab-top {" & vbCrLf)
    sbTemp.Append("		background-image: url(cid:image-tab1);" & vbCrLf)
    sbTemp.Append("		background-repeat: no-repeat;" & vbCrLf)
    sbTemp.Append("		max-height: 23px;" & vbCrLf)
    sbTemp.Append("		min-height: 23px;" & vbCrLf)
    sbTemp.Append("		font-weight: bold;" & vbCrLf)
    sbTemp.Append("		text-align: right;" & vbCrLf)
    sbTemp.Append("		padding-right: 50px;" & vbCrLf)
    sbTemp.Append("	}" & vbCrLf)
    sbTemp.Append("	" & vbCrLf)
    sbTemp.Append("	#left-tab-middle {" & vbCrLf)
    sbTemp.Append("		background-image: url(cid:image-tab3);" & vbCrLf)
    sbTemp.Append("		background-repeat: repeat-y;" & vbCrLf)
    sbTemp.Append("		padding: 10px;" & vbCrLf)
    sbTemp.Append("		font-size: 12px;" & vbCrLf)
    sbTemp.Append("		text-align: left;" & vbCrLf)
    sbTemp.Append("		min-height: 375px;" & vbCrLf)
    sbTemp.Append("	}" & vbCrLf)
    sbTemp.Append("	" & vbCrLf)
    sbTemp.Append("	#left-tab-bottom {" & vbCrLf)
    sbTemp.Append("		background-image: url(cid:image-tab5);" & vbCrLf)
    sbTemp.Append("		background-repeat: no-repeat;" & vbCrLf)
    sbTemp.Append("		max-height: 2px;" & vbCrLf)
    sbTemp.Append("		min-height: 2px;" & vbCrLf)
    sbTemp.Append("	}" & vbCrLf)
    sbTemp.Append("/* *************************************** END LEFT TAB CSS **************************************** */" & vbCrLf)
    sbTemp.Append("</style>" & vbCrLf)
    sbTemp.Append("<script type=""text/javascript"">" & vbCrLf)
    sbTemp.Append("" & vbCrLf)
    sbTemp.Append("    function MM_swapImgRestore() { //v3.0" & vbCrLf)
    sbTemp.Append("        var i, x, a = document.MM_sr; for (i = 0; a && i < a.length && (x = a[i]) && x.oSrc; i++) x.src = x.oSrc;" & vbCrLf)
    sbTemp.Append("    }" & vbCrLf)
    sbTemp.Append("" & vbCrLf)
    sbTemp.Append("    function MM_preloadImages() { //v3.0" & vbCrLf)
    sbTemp.Append("        var d = document; if (d.images) {" & vbCrLf)
    sbTemp.Append("            if (!d.MM_p) d.MM_p = new Array();" & vbCrLf)
    sbTemp.Append("            var i, j = d.MM_p.length, a = MM_preloadImages.arguments; for (i = 0; i < a.length; i++)" & vbCrLf)
    sbTemp.Append("                if (a[i].indexOf(""#"") != 0) { d.MM_p[j] = new Image; d.MM_p[j++].src = a[i]; } " & vbCrLf)
    sbTemp.Append("        }" & vbCrLf)
    sbTemp.Append("    }" & vbCrLf)
    sbTemp.Append("" & vbCrLf)
    sbTemp.Append("    function MM_findObj(n, d) { //v4.01" & vbCrLf)
    sbTemp.Append("        var p, i, x; if (!d) d = document; if ((p = n.indexOf(""?"")) > 0 && parent.frames.length) {" & vbCrLf)
    sbTemp.Append("            d = parent.frames[n.substring(p + 1)].document; n = n.substring(0, p);" & vbCrLf)
    sbTemp.Append("        }" & vbCrLf)
    sbTemp.Append("        if (!(x = d[n]) && d.all) x = d.all[n]; for (i = 0; !x && i < d.forms.length; i++) x = d.forms[i][n];" & vbCrLf)
    sbTemp.Append("        for (i = 0; !x && d.layers && i < d.layers.length; i++) x = MM_findObj(n, d.layers[i].document);" & vbCrLf)
    sbTemp.Append("        if (!x && d.getElementById) x = d.getElementById(n); return x;" & vbCrLf)
    sbTemp.Append("    }" & vbCrLf)
    sbTemp.Append("" & vbCrLf)
    sbTemp.Append("    function MM_swapImage() { //v3.0" & vbCrLf)
    sbTemp.Append("        var i, j = 0, x, a = MM_swapImage.arguments; document.MM_sr = new Array; for (i = 0; i < (a.length - 2); i += 3)" & vbCrLf)
    sbTemp.Append("            if ((x = MM_findObj(a[i])) != null) { document.MM_sr[j++] = x; if (!x.oSrc) x.oSrc = x.src; x.src = a[i + 2]; }" & vbCrLf)
    sbTemp.Append("    }" & vbCrLf)
    sbTemp.Append("</script>" & vbCrLf)
    sbTemp.Append("</head>" & vbCrLf)
    sbTemp.Append("<body style=""background:black"">" & vbCrLf)
    sbTemp.Append("" & vbCrLf)
    sbTemp.Append("    <div id=""head"">" & vbCrLf)
    sbTemp.Append("        <div id=""logo"">" & vbCrLf)
    sbTemp.Append("   			<img src=""cid:image-logo"" width=""318"" height=""142"" border=""0"" />" & vbCrLf)
    sbTemp.Append("      	</div>" & vbCrLf)
    sbTemp.Append("        <div id=""topnav""><img src=""cid:image-hire-right"" width=""582"" height=""110"" border=""0"" /><ul id=""menu"">" & vbCrLf)
    sbTemp.Append("            <li><a href=""index.asp"" onMouseOut=""MM_swapImgRestore()"" onMouseOver=""MM_swapImage('Home','','cid:image-home-yellow',1)"">" & vbCrLf)
    sbTemp.Append("              <img src=""cid:image-home-white"" alt=""Home"" id=""Home"" name=""Home"" width=""50"" height=""32"" border=""0"" /></a></li>" & vbCrLf)
    sbTemp.Append("            <li><a href=""about.asp"" onMouseOut=""MM_swapImgRestore()"" onMouseOver=""MM_swapImage('About Us','','cid:image-about-yellow',1)"">" & vbCrLf)
    sbTemp.Append("              <img src=""cid:image-about-white"" alt=""About Us"" id=""About Us"" name=""About Us"" width=""91"" height=""32"" border=""0"" /></a></li>" & vbCrLf)
    sbTemp.Append("            <li><a href=""signup.asp"" onMouseOut=""MM_swapImgRestore()"" onMouseOver=""MM_swapImage('Sign Up','','cid:image-signup-yellow',1)"">" & vbCrLf)
    sbTemp.Append("              <img src=""cid:image-signup-white"" alt=""Sign Up"" id=""Sign Up"" name=""Sign Up"" width=""75"" height=""32"" border=""0"" /></a></li>" & vbCrLf)
    sbTemp.Append("            <li><a href=""services.asp"" onMouseOut=""MM_swapImgRestore()"" onMouseOver=""MM_swapImage('Services','','cid:image-service-yellow',1)"">" & vbCrLf)
    sbTemp.Append("              <img src=""cid:image-services-white"" alt=""Services"" id=""Services"" name=""Services"" width=""85"" height=""32"" border=""0"" /></a></li>" & vbCrLf)
    sbTemp.Append("            <li><a href=""contact.asp"" onMouseOut=""MM_swapImgRestore()"" onMouseOver=""MM_swapImage('Contact Us','','cid:image-contact-yellow',1)"">" & vbCrLf)
    sbTemp.Append("              <img src=""cid:image-contact-white"" alt=""Contact Us"" id=""Contact Us"" name=""Contact Us"" width=""106"" height=""32"" border=""0"" /></a></li>" & vbCrLf)
    sbTemp.Append("            <li><a href=""faq.asp"" onMouseOut=""MM_swapImgRestore()"" onMouseOver=""MM_swapImage('FAQ','','cid:image-faq-yellow',1)"">" & vbCrLf)
    sbTemp.Append("              <img src=""cid:image-faq-white"" alt=""FAQ"" id=""FAQ"" name=""FAQ"" width=""39"" height=""32"" border=""0"" /></a></ul>" & vbCrLf)
    sbTemp.Append("			<img src=""cid:image-right_tab_edge"" width=""136"" height=""32"" /></div>" & vbCrLf)
    sbTemp.Append("	</div>" & vbCrLf)
    sbTemp.Append("   <div id=""main"">" & vbCrLf)
    sbTemp.Append("    <div id=""left""><img src=""cid:image-left"" width=""162"" height=""419"" /></div>" & vbCrLf)
    sbTemp.Append("    <div id=""middle"">" & vbCrLf)
    sbTemp.Append("" & vbCrLf)
    sbTemp.Append("<!-- *************************************** MAIN CONTENT AREA *************************************** -->" & vbCrLf)
    sbTemp.Append("<table width=""619px"" height=""419"" cellpadding=""0"" cellspacing=""0"" border=""0"">" & vbCrLf)
    sbTemp.Append("    <tr>" & vbCrLf)
    sbTemp.Append("        <td width=""610px"" valign=""top"" align=""center"">" & vbCrLf)
    sbTemp.Append("            <table width=""590px"" cellpadding=""0"" cellspacing=""0"" border=""0"">" & vbCrLf)
    sbTemp.Append("                <tr>" & vbCrLf)
    sbTemp.Append("                    <td align=""center"">                                	" & vbCrLf)
    sbTemp.Append("                        <table width=""580"" cellpadding=""0"" cellspacing=""0"" border=""0"">" & vbCrLf)
    sbTemp.Append("                            <tr valign=""top"">" & vbCrLf)
    sbTemp.Append("                                <td>" & vbCrLf)
    sbTemp.Append("                                    <div id=""left-tab-top"">" & vbCrLf)
    sbTemp.Append("                                        Title Here" & vbCrLf)
    sbTemp.Append("                                    </div>" & vbCrLf)
    sbTemp.Append("                                    <div id=""left-tab-middle"">" & vbCrLf)
    sbTemp.Append("                                        <table width=""100%"">" & vbCrLf)
    sbTemp.Append("                                            <tr valign=""top"">" & vbCrLf)
    sbTemp.Append("                                                <td>" & vbCrLf)
    sbTemp.Append("                                                <p><!-- Content --></p>" & vbCrLf)
    sbTemp.Append("" & vbCrLf)
    sbTemp.Append("" & vbCrLf)
    sbTemp.Append("                                                </td>" & vbCrLf)
    sbTemp.Append("                                            </tr>" & vbCrLf)
    sbTemp.Append("                                        </table>" & vbCrLf)
    sbTemp.Append("                                    </div>" & vbCrLf)
    sbTemp.Append("                                    <div id=""left-tab-bottom"">&nbsp;</div>" & vbCrLf)
    sbTemp.Append("                                </td>" & vbCrLf)
    sbTemp.Append("                            </tr>" & vbCrLf)
    sbTemp.Append("                        </table>" & vbCrLf)
    sbTemp.Append("                    </td>" & vbCrLf)
    sbTemp.Append("                </tr>" & vbCrLf)
    sbTemp.Append("            </table>" & vbCrLf)
    sbTemp.Append("        " & vbCrLf)
    sbTemp.Append("                  </td>" & vbCrLf)
    sbTemp.Append("                </tr>" & vbCrLf)
    sbTemp.Append("            </table>" & vbCrLf)
    sbTemp.Append("        </td>" & vbCrLf)
    sbTemp.Append("    </tr>" & vbCrLf)
    sbTemp.Append("</table>" & vbCrLf)
    sbTemp.Append("<!-- ************************************* END MAIN CONTENT AREA ************************************* -->" & vbCrLf)
    sbTemp.Append("" & vbCrLf)
    sbTemp.Append("    </div>    " & vbCrLf)
    sbTemp.Append("    <div id=""right"">&nbsp;</div>" & vbCrLf)
    sbTemp.Append("</div>" & vbCrLf)
    sbTemp.Append("" & vbCrLf)
    sbTemp.Append("      <div id=""foot"">" & vbCrLf)
    sbTemp.Append("    	<table width=""900px"" cellpadding=""0"" cellspacing=""0"" border=""0"">" & vbCrLf)
    sbTemp.Append("        	<tr height=""50px"">" & vbCrLf)
    sbTemp.Append("            	<td width=""162px"" rowspan=""2"" background=""cid:image-bottom1"">&nbsp;</td>" & vbCrLf)
    sbTemp.Append("                <td width=""619px"" background=""cid:image-bottom2"">&nbsp;</td>" & vbCrLf)
    sbTemp.Append("                <td width=""119px"" rowspan=""2"" background=""cid:image-bottom3"">&nbsp;</td>" & vbCrLf)
    sbTemp.Append("            </tr>" & vbCrLf)
    sbTemp.Append("        	<tr height=""64px"" valign=""top"" align=""right"">" & vbCrLf)
    sbTemp.Append("        	  	<td background=""cid:image-bottom4""><font size=""1"">&nbsp;&copy;2012 Identi-Check. All Rights Reserved. <a href='enduser.asp'>End User Agreement</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href='legalnotice.asp'>Legal Notice</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href='privacy.asp'>Privacy Policy</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href='lawsnotices.asp'>Laws & Notices</a></font></td>" & vbCrLf)
    sbTemp.Append("      	  </tr>" & vbCrLf)
    sbTemp.Append("        </table>" & vbCrLf)
    sbTemp.Append("    </div>" & vbCrLf)
    sbTemp.Append("</body>" & vbCrLf)
    sbTemp.Append("</html>" & vbCrLf)
    sbTemp.Append("" & vbCrLf)
    'dtData = FillDataTable("Select Email_Text From IDC_Settings")
    'If dtData.Rows.Count = 0 Then
    '  strRtn = ""
    'Else
    '  strRtn = dtData.Rows(0).Item("Email_Text")
    'End If
    'dtData.Dispose()
    'dtData = Nothing
    GetEmailTemplate = sbRtn.ToString
    'GetEmailTemplate = sbTemp.ToString
  End Function

  Public Function SendEmail(ByVal COMPANY_RID As Integer, ByVal LOCATION_RID As Integer, ByVal strMessage As String, ByVal strSubject As String, Optional ByVal strBrief As String = "", Optional ByVal blnIn As Boolean = True) As String
    Dim dsDataSet As New DataSet
    Dim SelectStr As String
    Dim strAddr As String, strTemplate As String
    strAddr = ConstantsManager.getConstant("APPLICATION_URL")
    strTemplate = GetEmailTemplate.Replace("<!-- BASE -->", "<base href=""" & strAddr & "/home.aspx"" />")
    strTemplate = strTemplate.Replace("http://www.egrain.com", strAddr)

    If LOCATION_RID <> 0 Then
      'SelectStr = "Select * From USERS " & _
      ' "Where RID in " & _
      ' "(Select USERS_RID From ASSIGNED_LOCATION " & _
      ' "Where (LOCATION_RID = " & LOCATION_RID & " Or LOCATION_RID = 0)) " & _
      ' "And COMPANY_RID = " & COMPANY_RID
      SelectStr = "SELECT u.EMAIL, UN.UN_Direction, UN.UN_Frequency, AL.LOCATION_RID, AL.USER_ROLE_TYPE " & _
        " FROM USERS u inner join ASSIGNED_LOCATION AL on AL.USERS_RID = u.RID " & _
        " inner join User_Notification UN on u.RID = UN.UN_User_RID and UN.UN_App_Type = 'CCSEWR' " & _
        "Where UN.UN_Frequency = 'I' and UN.UN_Direction = '" & IIf(blnIn, "I", "O") & "' " & _
        "and COMPANY_RID = " & COMPANY_RID & " and u.STATUS = 'ACTIVATED' " & _
        "and (((AL.LOCATION_RID = " & LOCATION_RID & " and (AL.USER_ROLE_TYPE = 47 or AL.USER_ROLE_TYPE = 46)) " & _
        "  Or ((AL.USER_ROLE_TYPE = 13 or AL.USER_ROLE_TYPE = 45) and AL.LOCATION_RID = 0)))"
    Else
      SelectStr = "Select * from USERS " & _
       "Where PRODUCER_RID = " & COMPANY_RID & _
       " And PL_NOTICES = 'Y'"
    End If
    SessionSQL = SelectStr
    Dim blnTo As Boolean = False
    dsDataSet = FillDataSet("USERS", SelectStr)
    If dsDataSet.Tables("USERS").Rows.Count > 0 Then
      Dim i As Integer
      Dim strTo As String, strSQL As String
      Dim mail As New MailMessage
      mail.From = New MailAddress("webman@egrain.com")
      For i = 0 To dsDataSet.Tables("USERS").Rows.Count - 1
        If Convert.ToString(dsDataSet.Tables("USERS").Rows(i).Item("EMAIL")) <> "" Then
          'strTo = strTo & dsDataSet.Tables("USERS").Rows(i).Item("EMAIL") & ";"
          mail.To.Add(New MailAddress(dsDataSet.Tables("USERS").Rows(i).Item("EMAIL")))
          blnTo = True
        End If
        'If (dsDataSet.Tables("USERS").Rows(i).Item("EMAIL_INSTANT") And blnIn) Or _
        '  (dsDataSet.Tables("USERS").Rows(i).Item("EMAIL_INSTANT_OUT") And Not blnIn) Then
        '  'send email now
        '  If Convert.ToString(dsDataSet.Tables("USERS").Rows(i).Item("EMAIL")) <> "" Then
        '    'strTo = strTo & dsDataSet.Tables("USERS").Rows(i).Item("EMAIL") & ";"
        '    mail.To.Add(New MailAddress(dsDataSet.Tables("USERS").Rows(i).Item("EMAIL")))
        '    blnTo = True
        '  End If
        'Else
        '  'don't send email now
        '  'send either daily or weekly
        'End If
        'If Convert.ToString(dsDataSet.Tables("USERS").Rows(i).Item("EMAIL")) <> "" Then
        '  strTo = strTo & dsDataSet.Tables("USERS").Rows(i).Item("EMAIL") & ";"
        'End If
      Next
      If blnTo Then
        'strTo = Left(strTo, Len(strTo) - 1)
        'mail.To = strTo
        mail.Subject = strSubject
        mail.Body = strTemplate.Replace("<!-- Content -->", strMessage)
        mail.IsBodyHtml = True  'bodyformat = MailFormat.Html
        'SmtpMail.SmtpServer = ConstantsManager.getConstant("EMAIL_SERVER_ADDRESS")
        Try
          'SmtpMail.Send(mail)
          Dim client As New SmtpClient()
          client.Host = ConstantsManager.getConstant("EMAIL_SERVER_ADDRESS")
          client.Send(mail)
          client = Nothing
        Catch
          'do nothing, gets stored in db
        End Try
        mail = Nothing
      End If
      strSQL = "Insert Into CCSEWR_COMMUNICATIONS (FOR_COMPANY_RID,FOR_LOCATION_RID,SUBJECT,MESSAGE,DATETIME,BRIEF_MSG,INCOMING_MSG) " & _
       "Values (" & COMPANY_RID & "," & LOCATION_RID & ",'" & strSubject & "','" & _
       Replace(strTemplate.Replace("<!-- Content -->", strMessage), "'", "''") & "',GETDATE(),'" & strBrief.Replace("'", "''") & "'," & IIf(blnIn, "1", "0") & ")"
      RunCommand(strSQL)
    End If
    dsDataSet = Nothing
  End Function

  Public Function SendEmailNew(ByVal COMPANY_RID As Integer, ByVal LOCATION_RID As Integer, ByVal strMessage As String, ByVal strSubject As String, Optional ByVal strTo As String = "", Optional ByVal strBrief As String = "", Optional ByVal blnIn As Boolean = True) As String
    Dim dtData As New DataTable
    Dim sSQL As String
    Dim strAddr As String, strTemplate As String = ""
    strAddr = ConstantsManager.getConstant("APPLICATION_URL")
    strTemplate = GetEmailTemplate()
    'Dim A As System.Net.Mail.Attachment = New System.Net.Mail.Attachment(txtImagePath.Text)
    'Dim RGen As Random = New Random()
    'A.ContentId = RGen.Next(100000, 9999999).ToString()
    'EM.Body = "<img src='cid:" + A.ContentId + "'>"

    Dim mail As New MailMessage
    'Dim View As AlternateView
    'Dim resA As LinkedResource
    'View = AlternateView.CreateAlternateViewFromString(strTemplate.Replace("<!-- Content -->", strMessage), Nothing, "text/html")

    ''../images/middle.png - cid:image-middle
    'resA = New LinkedResource("c:\webs\test.identi-check.com\images\middle.png", "image/png")
    'resA.ContentId = "image-middle"
    'View.LinkedResources.Add(resA)
    ''../images/right.png - cid:image-right
    'Dim resB As New LinkedResource("c:\webs\test.identi-check.com\images\right.png", "image/png")
    'resB.ContentId = "image-right"
    'View.LinkedResources.Add(resB)
    ''../images/bottom.png - cid:image-bottom
    'Dim resC As New LinkedResource("c:\webs\test.identi-check.com\images\bottom.png", "image/png")
    'resC.ContentId = "image-bottom"
    'View.LinkedResources.Add(resC)
    ''../images/tab_01.png - cid:image-tab1
    'Dim resD As New LinkedResource("c:\webs\test.identi-check.com\images\tab_01.png", "image/png")
    'resD.ContentId = "image-tab1"
    'View.LinkedResources.Add(resD)
    ''../images/tab_03.png - cid:image-tab3
    'Dim resE As New LinkedResource("c:\webs\test.identi-check.com\images\tab_03.png", "image/png")
    'resE.ContentId = "image-tab3"
    'View.LinkedResources.Add(resE)
    ''../images/tab_05.png - cid:image-tab5
    'Dim resF As New LinkedResource("c:\webs\test.identi-check.com\images\tab_05.png", "image/png")
    'resF.ContentId = "image-tab5"
    'View.LinkedResources.Add(resF)
    ''images/logo.png - cid:image-logo
    'Dim resG As New LinkedResource("c:\webs\test.identi-check.com\images\logo.png", "image/png")
    'resG.ContentId = "image-logo"
    'View.LinkedResources.Add(resG)
    ''images/hire_right.png - cid:image-hire-right
    'Dim resH As New LinkedResource("c:\webs\test.identi-check.com\images\hire_right.png", "image/png")
    'resH.ContentId = "image-hire-right"
    'View.LinkedResources.Add(resH)
    ''images/home-white.png - cid:image-home-white
    'Dim resI As New LinkedResource("c:\webs\test.identi-check.com\images\home-white.png", "image/png")
    'resI.ContentId = "image-home-white"
    'View.LinkedResources.Add(resI)
    ''images/home-yellow.png - cid:image-home-yellow
    'Dim resJ As New LinkedResource("c:\webs\test.identi-check.com\images\home-yellow.png", "image/png")
    'resJ.ContentId = "image-home-yellow"
    'View.LinkedResources.Add(resJ)
    ''images/about-white.png - cid:image-about-white
    'Dim resK As New LinkedResource("c:\webs\test.identi-check.com\images\about-white.png", "image/png")
    'resK.ContentId = "image-about-white"
    'View.LinkedResources.Add(resK)
    ''images/about-yellow.png - cid:image-about-yellow
    'Dim resL As New LinkedResource("c:\webs\test.identi-check.com\images\about-yellow.png", "image/png")
    'resL.ContentId = "image-about-yellow"
    'View.LinkedResources.Add(resL)
    ''images/signup-white.png - cid:image-signup-white
    'Dim resM As New LinkedResource("c:\webs\test.identi-check.com\images\signup-white.png", "image/png")
    'resM.ContentId = "image-signup-white"
    'View.LinkedResources.Add(resM)
    ''images/signup-yellow.png - cid:image-signup-yellow
    'Dim resN As New LinkedResource("c:\webs\test.identi-check.com\images\signup-yellow.png", "image/png")
    'resN.ContentId = "image-signup-yellow"
    'View.LinkedResources.Add(resN)
    ''images/services-white.png - cid:image-services-white
    'Dim resO As New LinkedResource("c:\webs\test.identi-check.com\images\services-white.png", "image/png")
    'resO.ContentId = "image-services-white"
    'View.LinkedResources.Add(resO)
    ''images/services-yellow.png - cid:image-services-yellow
    'Dim resP As New LinkedResource("c:\webs\test.identi-check.com\images\services-yellow.png", "image/png")
    'resP.ContentId = "image-services-yellow"
    'View.LinkedResources.Add(resP)
    ''images/contact-white.png - cid:image-contact-white
    'Dim resQ As New LinkedResource("c:\webs\test.identi-check.com\images\contact-white.png", "image/png")
    'resQ.ContentId = "image-contact-white"
    'View.LinkedResources.Add(resQ)
    ''images/contact-yellow.png - cid:image-contact-yellow
    'Dim resR As New LinkedResource("c:\webs\test.identi-check.com\images\contact-yellow.png", "image/png")
    'resR.ContentId = "image-contact-yellow"
    'View.LinkedResources.Add(resR)
    ''images/faq-white.png - cid:image-faq-white
    'Dim resS As New LinkedResource("c:\webs\test.identi-check.com\images\faq-white.png", "image/png")
    'resS.ContentId = "image-faq-white"
    'View.LinkedResources.Add(resS)
    ''images/faq-yellow.png - cid:image-faq-yellow
    'Dim resT As New LinkedResource("c:\webs\test.identi-check.com\images\faq-yellow.png", "image/png")
    'resT.ContentId = "image-faq-yellow"
    'View.LinkedResources.Add(resT)
    ''images/left.png - cid:image-left
    'Dim resU As New LinkedResource("c:\webs\test.identi-check.com\images\left.png", "image/png")
    'resU.ContentId = "image-left"
    'View.LinkedResources.Add(resU)
    ''right_tab_edge.png - cid:image-right_tab_edge
    'Dim resV As New LinkedResource("c:\webs\test.identi-check.com\images\right_tab_edge.png", "image/png")
    'resV.ContentId = "image-right_tab_edge"
    'View.LinkedResources.Add(resV)
    ''images/bottom_01.png - cid:image-bottom1
    'Dim resW As New LinkedResource("c:\webs\test.identi-check.com\images\bottom_01.png", "image/png")
    'resW.ContentId = "image-bottom1"
    'View.LinkedResources.Add(resW)
    ''images/bottom_02.png - cid:image-bottom2
    'Dim resX As New LinkedResource("c:\webs\test.identi-check.com\images\bottom_02.png", "image/png")
    'resX.ContentId = "image-bottom2"
    'View.LinkedResources.Add(resX)
    ''images/bottom_03.png - cid:image-bottom3
    'Dim resY As New LinkedResource("c:\webs\test.identi-check.com\images\bottom_03.png", "image/png")
    'resY.ContentId = "image-bottom3"
    'View.LinkedResources.Add(resY)
    ''images/bottom_04.png - cid:image-bottom4
    'Dim resZ As New LinkedResource("c:\webs\test.identi-check.com\images\bottom_04.png", "image/png")
    'resZ.ContentId = "image-bottom4"
    'View.LinkedResources.Add(resZ)

    'mail.AlternateViews.Add(View)

    'strTemplate = GetEmailTemplate.Replace("<!-- BASE -->", "<base href=""" & strAddr & "/home.aspx"" />")
    'strTemplate = strTemplate.Replace("http://www.egrain.com", strAddr)

    If strTo <> "" Then
      'Dim mail As New MailMessage
      mail.From = New MailAddress("info@identi-check.com")
      'mail.To.Add(New MailAddress(strTo))
      If strTo.IndexOf(";") > 0 Then
        'Dim sTo As String() = strTo.Split(";")
        For Each sTo As String In strTo.Split(";")
          If sTo <> "" Then
            mail.To.Add(New MailAddress(sTo))
          End If
        Next
      Else
        mail.To.Add(New MailAddress(strTo))
      End If
      mail.Subject = strSubject
      mail.Body = strTemplate.Replace("<!-- Content -->", strMessage)
      mail.IsBodyHtml = True    'mail.BodyFormat = MailFormat.Html
      'SmtpMail.SmtpServer = ConstantsManager.getConstant("EMAIL_SERVER_ADDRESS")
      Try
        'SmtpMail.Send(mail)
        Dim client As New SmtpClient()
        client.Host = ConfigurationManager.AppSettings("EMAIL_SERVER_ADDRESS")
        client.Send(mail)
        client = Nothing
      Catch
        'do nothing, gets stored in db
      End Try
      mail = Nothing
    Else
      sSQL = "Select * From USERS Where company_id = " & COMPANY_RID
      Dim blnTo As Boolean = False
      dtData = FillDataTable(sSQL)
      If dtData.Rows.Count > 0 Then
        Dim i As Integer
        'Dim mail As New MailMessage
        mail.From = New MailAddress("online@identi-check.com")
        For i = 0 To dtData.Rows.Count - 1
          If Convert.ToString(dtData.Rows(i).Item("Email")) <> "" Then
            mail.To.Add(New MailAddress(dtData.Rows(i).Item("Email")))
            blnTo = True
          End If
        Next
        If blnTo Then
          mail.Subject = strSubject
          mail.Body = strTemplate.Replace("<!-- Content -->", strMessage)
          mail.IsBodyHtml = True
          Try
            Dim client As New SmtpClient()
            client.Host = ConfigurationManager.AppSettings("EMAIL_SERVER_ADDRESS")
            client.Send(mail)
            client = Nothing
          Catch ex As Exception
            'do nothing, gets stored in db
            Throw ex
          End Try
          mail = Nothing
        End If
        'strSQL = "Insert Into EWR_COMMUNICATIONS (FOR_COMPANY_RID,FOR_LOCATION_RID,SUBJECT,MESSAGE,DATETIME,BRIEF_MSG,INCOMING_MSG) " & _
        ' "Values (" & COMPANY_RID & "," & LOCATION_RID & ",'" & strSubject & "','" & _
        ' Replace(strTemplate.Replace("<!-- Content -->", strMessage), "'", "''") & "',GETDATE(),'" & strBrief.Replace("'", "''") & "'," & IIf(blnIn, "1", "0") & ")"
        'RunCommand(strSQL)
      End If
      dtData.Dispose()
      dtData = Nothing
    End If


  End Function

  'Public Function convertToEmbedResource(ByVal emailHtml$) As AlternateView

  '  'This is the website where the resources are located
  '  Dim webSiteUrl$ = "http://www.identi-check.com/images/"

  '  ' The first regex finds all the url/src tags.
  '  Dim matchesCol As MatchCollection = Regex.Matches(emailHtml, "url\(['|\""]+.*['|\""]\)|src=[""|'][^""']+[""|']")

  '  Dim normalRes As Match

  '  ' I didnt knew how to declare a new LinkedResourceCol so i did this :
  '  Dim resCol As AlternateView = AlternateView.CreateAlternateViewFromString("", Nothing, "text/html")
  '  Dim resId% = 0

  '  ' Between the findings
  '  For Each normalRes In matchesCol

  '    Dim resPath$

  '    ' Replace it for the new content ID that will be embeded
  '    If Left(normalRes.Value, 3) = "url" Then
  '      emailHtml = emailHtml.Replace(normalRes.Value, "url(cid:EmbedRes_" & resId & ")")
  '    Else
  '      emailHtml = emailHtml.Replace(normalRes.Value, "src=""cid:EmbedRes_" & resId & """")
  '    End If

  '    ' Clean the path

  '    resPath = Regex.Replace(normalRes.Value, "url\(['|\""]", "")
  '    resPath = Regex.Replace(resPath, "src=['|\""]", "")

  '    resPath = Regex.Replace(resPath, "['|\""]\)", "").Replace(webSiteUrl, "").Replace("""", "")

  '    ' Map it on the server
  '    resPath = Server.MapPath(resPath)


  '    ' Embed the resource
  '    Dim theResource As LinkedResource = New LinkedResource(resPath)
  '    theResource.ContentId = "EmbedRes_" & resId
  '    resCol.LinkedResources.Add(theResource)

  '    ' Next resource ID
  '    resId = resId + 1

  '  Next

  '  ' Create our final object
  '  Dim finalEmail As AlternateView = Net.Mail.AlternateView.CreateAlternateViewFromString(emailHtml, Nothing, "text/html")
  '  Dim transferResource As LinkedResource

  '  ' And transfer all the added resources to the output object
  '  For Each transferResource In resCol.LinkedResources
  '    finalEmail.LinkedResources.Add(transferResource)
  '  Next

  '  Return finalEmail

  'End Function

  Public Function ReSendEWREmail(ByVal COMPANY_RID As Integer, ByVal LOCATION_RID As Integer, ByVal strMessage As String, ByVal strSubject As String) As String
    Dim dsDataSet As New DataSet
    Dim SelectStr As String
    Dim strHdr As String, strFtr As String
    Dim strAddr As String

    If LOCATION_RID <> 0 Then
      SelectStr = "Select * From USERS " & _
       "Where RID in " & _
       "(Select USERS_RID From ASSIGNED_LOCATION " & _
       "Where (LOCATION_RID = " & LOCATION_RID & " Or LOCATION_RID = 0)) " & _
       "And COMPANY_RID = " & COMPANY_RID
    Else
      SelectStr = "Select * from USERS " & _
       "Where PRODUCER_RID = " & COMPANY_RID & _
       " And PL_NOTICES = 'Y'"
    End If
    Dim blnTo As Boolean = False
    dsDataSet = FillDataSet("USERS", SelectStr)
    If dsDataSet.Tables("USERS").Rows.Count > 0 Then
      Dim i As Integer
      Dim strTo As String, strSQL As String
      Dim mail As New MailMessage
      mail.From = New MailAddress("webman@egrain.com")
      For i = 0 To dsDataSet.Tables("USERS").Rows.Count - 1
        If dsDataSet.Tables("USERS").Rows(i).Item("EMAIL_INSTANT") Then
          'send email now
          If Convert.ToString(dsDataSet.Tables("USERS").Rows(i).Item("EMAIL")) <> "" Then
            'strTo = strTo & dsDataSet.Tables("USERS").Rows(i).Item("EMAIL") & ";"
            mail.To.Add(New MailAddress(dsDataSet.Tables("USERS").Rows(i).Item("EMAIL")))
            blnTo = True
          End If
        Else
          'don't send email now
          'send either daily or weekly
        End If
        'If Convert.ToString(dsDataSet.Tables("USERS").Rows(i).Item("EMAIL")) <> "" Then
        '  strTo = strTo & dsDataSet.Tables("USERS").Rows(i).Item("EMAIL") & ";"
        'End If
      Next
      If blnTo Then
        'strTo = Left(strTo, Len(strTo) - 1)
        'mail.To = strTo
        mail.Subject = strSubject
        mail.Body = strMessage
        mail.IsBodyHtml = True    'mail.BodyFormat = MailFormat.Html
        'SmtpMail.SmtpServer = ConstantsManager.getConstant("EMAIL_SERVER_ADDRESS")
        Try
          'SmtpMail.Send(mail)
          Dim client As New SmtpClient()
          client.Host = ConstantsManager.getConstant("EMAIL_SERVER_ADDRESS")
          client.Send(mail)
          client = Nothing
        Catch
          'do nothing, gets stored in db
        End Try
      End If
      mail = Nothing
      'strSQL = "Insert Into EWR_COMMUNICATIONS (FOR_COMPANY_RID,FOR_LOCATION_RID,SUBJECT,MESSAGE,DATETIME) " & _
      '         "Values (" & COMPANY_RID & "," & LOCATION_RID & ",'" & strSubject & "','" & _
      '         Replace(strHdr & strMessage & strFtr, "'", "''") & "',GETDATE())"
      'RunCommand(strSQL)
    End If
    dsDataSet = Nothing
  End Function

  Public Function SendErrorEmail(ByVal exErr As Exception, ByVal strUserRID As String, ByVal strCompanyRID As String, ByVal script_name As String, ByVal strQuery_String As String, ByVal http_user_agent As String, Optional ByVal strSQL As String = "") As String
    Dim strErrorDetails As String = ""
    Const EX_PERMISSION_DENIED As String = "Permission Denied"
    Const EX_FILE_NOT_FOUND As String = "404 File Not Fouund"
    Const EX_TIMEOUT As String = "Server Timeout"
    Const EX_IIS_ERROR As String = "Internal Server Error"
    Const EX_SERVER_LOAD As String = "Server Load"

    If (TypeOf (exErr) Is HttpException) Then
      '' Is it an HTTP Exception that was uncaught?
      Dim myHTTPException As HttpException = CType(exErr, HttpException)
      Select Case myHTTPException.GetHttpCode
        Case 403 : strErrorDetails = EX_PERMISSION_DENIED
        Case 404 : strErrorDetails = EX_FILE_NOT_FOUND
        Case 408 : strErrorDetails = EX_TIMEOUT
        Case 500 : strErrorDetails = EX_IIS_ERROR
        Case 503 : strErrorDetails = EX_SERVER_LOAD
        Case Else : strErrorDetails = "The server has experienced an error."
      End Select
    Else
      '' A different exception type as been thrown
      strErrorDetails = "An exception occured. Error details as follows : " & exErr.ToString
    End If

    '' Now display the error and send email to web master
    Dim strMsg As String
    strMsg = "<html><head><title>eGrain - CCS-EWR - Site Error</title></head><body>" & _
     "Error Details:<br />" & _
     "Error-ToString(): " & exErr.ToString() & "<br />" & _
     "Error: " & exErr.GetBaseException().Message() & "<br />" & _
     "Source: " & exErr.GetBaseException().Source() & "<br />" & _
     "SQL: " & strSQL & "<br />" & _
     "User RID: " & strUserRID & "<br />" & _
     "Company RID: " & strCompanyRID & "<br />" & _
     "Page: " & script_name & "<br />" & _
     "Query String: " & strQuery_String & "<br />" & _
     "URL: " & strAppURL & "<br />" & _
     "Browser: " & http_user_agent & _
     "</body></html>"
    Dim mail As New MailMessage
    mail.From = New MailAddress("webman@egrain.com")
    mail.To.Add(New MailAddress(ConstantsManager.getConstant("ERROR_EMAIL_ADDRESS")))
    mail.Subject = "eGrain - CCS-EWR - Site Error"
    mail.Body = strMsg
    mail.IsBodyHtml = True

    Try
      Dim client As New SmtpClient()
      client.Host = ConstantsManager.getConstant("EMAIL_SERVER_ADDRESS")
      client.Send(mail)
      client = Nothing
    Catch ex As Exception

    End Try
    mail = Nothing

    SendErrorEmail = strErrorDetails
  End Function
End Module
