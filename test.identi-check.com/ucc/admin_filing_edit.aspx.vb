Imports System.Data.SqlClient
Imports System.Net
Imports System.IO


Partial Class admin_filing_edit
  Inherits System.Web.UI.Page

  Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
    'check for admin
    If Session("UserID") = "" Then
      Response.Redirect("\index.asp?msg=Your session timed out, please login again.")
    ElseIf Session("admin") <> "2" Then
      Response.Redirect("main.aspx?msg=You do not have access to this page.")
    End If

    If Request.QueryString("id") = "" Then
      Response.Redirect("admin_main.aspx?msg=No Filing ID provided.")
    End If

    If Not Page.IsPostBack Then
      Dim myMaster As MainMaster = CType(MyBase.Master, MainMaster)
      'myMaster.Testing()
      myMaster.SetWelcomeName(Session("name"))

      lstStatus.Items.Add(New ListItem("Choose Status", ""))
      lstStatus.Items.Add(New ListItem("New", "N"))
      lstStatus.Items.Add(New ListItem("Submitted", "S"))
      lstStatus.Items.Add(New ListItem("Filed", "F"))
      lstStatus.Items.Add(New ListItem("Rejected", "R"))

      Dim sID As String = Request.QueryString("id")

      Me.Form.Enctype = "multipart/form-data"

      Dim sFrom As String, sFile As String, sIDField As String, sDebtor As String, sComID As String, sStatusReason As String
      Dim sFileNo As String, sFileDate As String, sFileStatus As String, sCharge As String, sDocReceiptID As String
      Select Case Request.QueryString("type") & ""
        Case "UCC1"
          lblType.Text = "Financing"
          sFrom = "ucc_financing inner join ucc_debtor as ud1 on uf_debtor1 = ud1.ud_id"
          sFile = "uf_file_attach"
          sIDField = "uf_id"
          sFileNo = "uf_file_no"
          sFileDate = "uf_filing_date"
          sFileStatus = "uf_status"
          sCharge = "uf_charge"
          sDocReceiptID = "uf_doc_receipt_id"
          sComID = "uf_company_id"
          sStatusReason = "uf_status_reason"
          sDebtor = "case when isnull(ud1.ud_org_name,'') <> '' then ud1.ud_org_name   else isnull(ud1.ud_ind_first_name,'') + ' ' + isnull(ud1.ud_ind_middle_name,'') + ' ' + isnull(ud1.ud_ind_last_name,'') + ' ' + isnull(ud1.ud_ind_suffix,'') end as 'name' "
        Case "UCC3"
          lblType.Text = "Amendment"
          sFrom = "ucc3"
          sFile = "u3_file_attach"
          sIDField = "u3_id"
          sFileNo = "u3_validation_number"
          sFileDate = "u3_filing_date"
          sFileStatus = "u3_status"
          sCharge = "u3_charge"
          sDocReceiptID = "u3_doc_receipt_id"
          sComID = "u3_company_id"
          sStatusReason = "u3_status_reason"
          sDebtor = "case when isnull(u3_old_org_name,'') <> '' then u3_old_org_name   else isnull(u3_old_ind_first_name,'') + ' ' + isnull(u3_old_ind_middle_name,'') + ' ' + isnull(u3_old_ind_last_name,'') + ' ' + isnull(u3_old_ind_suffix,'') end as 'name' "
        Case Else
          sFrom = ""
          sFile = ""
          sIDField = ""
          sFileNo = ""
          sFileDate = ""
          sCharge = ""
          sFileStatus = ""
          sDocReceiptID = ""
          sComID = ""
          sStatusReason = ""
          sDebtor = ""
      End Select

      Dim strSQL As String
      Dim dtData As New DataTable

      strSQL = "Select *, case when " & sFile & " IS NULL then 'N' else 'Y' end as 'FileReady', " & _
        sDebtor & _
        " From " & sFrom & " Where " & sIDField & " = " & sID
      dtData = FillDataTable(strSQL)
      If dtData.Rows.Count > 0 Then
        With dtData.Rows(0)
          lblViewPDF.Text = "<a href='View_" & Request.QueryString("type") & "" & ".aspx?id=" & sID & "&com=" & .Item(sComID) & "' target='_blank'>View PDF</a>"
          lblDebtor.Text = .Item("name") & ""
          txtFiling_Number.Text = .Item(sFileNo) & ""
          txtFiling_Date.Text = .Item(sFileDate) & ""
          txtCharge.Text = .Item(sCharge) & ""
          lblDocReceiptID.Text = .Item(sDocReceiptID) & ""
          lblError.Text = .Item(sStatusReason) & ""
          Try
            lstStatus.SelectedIndex = -1
            lstStatus.Items.FindByValue(.Item(sFileStatus) & "").Selected = True
          Catch ex As Exception

          End Try
          'txtName_Address.Text = (.Item("ur_name_address") & "").ToString.Replace("<br />", vbCrLf)
          'txtSecured_Party.Text = (.Item("ur_secured_party") & "").ToString.Replace("<br />", vbCrLf)
          If lblDocReceiptID.Text <> "" Then
            btnSubmitXML.Visible = False
          End If

          lblCom.Text = .Item(sComID) & ""
          If .Item("FileReady") & "" = "Y" Then
            lblViewAttach.Text = "<a href='View_File.aspx?type=" & Request.QueryString("type") & "" & "&id=" & sID & "&com=" & lblCom.Text & "' target='_blank'>View File</a>"
          Else
            If .Item(sFileStatus) & "" = "F" Or .Item(sFileStatus) & "" = "S" Then
              btnCheckStatus.Visible = True
            End If
          End If
        End With
        btnAdd.Visible = False
        btnUpload.Visible = True
      Else
        'add
        btnAdd.Visible = True
        btnUpload.Visible = False
      End If
      dtData.Dispose()
      dtData = Nothing
    End If
  End Sub

  Protected Sub btnUpload_Click(sender As Object, e As System.EventArgs) Handles btnUpload.Click
    'Make sure a file has been successfully uploaded
    'If UploadedFile.PostedFile Is Nothing OrElse String.IsNullOrEmpty(UploadedFile.PostedFile.FileName) OrElse UploadedFile.PostedFile.InputStream Is Nothing Then
    '  '... Show error message ...
    '  Exit Sub
    'End If

    'Make sure we are dealing with a JPG or GIF file
    'Dim extension As String = Path.GetExtension(UploadedFile.PostedFile.FileName).ToLower()
    Dim MIMEType As String = "application/pdf"

    Dim sFrom As String, sFile As String, sIDField As String
    Dim sFileNo As String, sFileDate As String, sFileStatus As String, sCharge As String
    Select Case Request.QueryString("type") & ""
      Case "UCC1"
        sFrom = "ucc_financing"
        sFile = "uf_file_attach"
        sIDField = "uf_id"
        sFileNo = "uf_file_no"
        sFileDate = "uf_filing_date"
        sFileStatus = "uf_status"
        sCharge = "uf_charge"
      Case "UCC3"
        sFrom = "ucc3"
        sFile = "u3_file_attach"
        sIDField = "u3_id"
        sFileNo = "u3_validation_number"
        sFileDate = "u3_filing_date"
        sFileStatus = "u3_status"
        sCharge = "u3_charge"
      Case Else
        sFrom = ""
        sFile = ""
        sIDField = ""
        sFileNo = ""
        sFileDate = ""
        sCharge = ""
        sFileStatus = ""
    End Select


    'Connect to the database and insert a new record into Products
    Using myConnection As New SqlConnection(CNNStr)

      Dim SQL As String = ""
      Dim myCommand As SqlCommand
      'myCommand.Parameters.AddWithValue("@name_address", txtName_Address.Text.Replace(vbCrLf, "<br />"))
      'myCommand.Parameters.AddWithValue("@secured_party", txtSecured_Party.Text.Replace(vbCrLf, "<br />"))

      If UploadedFile.HasFile Then
        SQL = "Update " & sFrom & " set " & _
        sFileNo & " = @file_no, " & _
        sFileDate & " = @file_date, " & _
        sFileStatus & " = @uf_status, " & _
        sCharge & " = @uf_charge, " & _
        sFile & " = @ImageData " & _
        " Where " & sIDField & " = " & Request.QueryString("id")
        'Load FileUpload's InputStream into Byte array
        myCommand = New SqlCommand(SQL, myConnection)
        myCommand.Parameters.AddWithValue("@file_no", IIf(txtFiling_Number.Text = "", DBNull.Value, txtFiling_Number.Text))
        myCommand.Parameters.AddWithValue("@file_date", IIf(txtFiling_Date.Text = "", DBNull.Value, txtFiling_Date.Text))
        myCommand.Parameters.AddWithValue("@uf_status", lstStatus.SelectedValue)
        myCommand.Parameters.AddWithValue("@uf_charge", IIf(txtCharge.Text = "", DBNull.Value, txtCharge.Text))

        Dim imageBytes(UploadedFile.PostedFile.InputStream.Length) As Byte
        UploadedFile.PostedFile.InputStream.Read(imageBytes, 0, imageBytes.Length)
        myCommand.Parameters.AddWithValue("@ImageData", imageBytes)
      Else
        SQL = "Update " & sFrom & " set " & _
        sFileNo & " = @file_no, " & _
        sFileDate & " = @file_date, " & _
        sFileStatus & " = @uf_status, " & _
        sCharge & " = @uf_charge " & _
        " Where " & sIDField & " = " & Request.QueryString("id")
        myCommand = New SqlCommand(SQL, myConnection)
        myCommand.Parameters.AddWithValue("@file_no", IIf(txtFiling_Number.Text = "", DBNull.Value, txtFiling_Number.Text))
        myCommand.Parameters.AddWithValue("@file_date", IIf(txtFiling_Date.Text = "", DBNull.Value, txtFiling_Date.Text))
        myCommand.Parameters.AddWithValue("@uf_status", lstStatus.SelectedValue)
        myCommand.Parameters.AddWithValue("@uf_charge", IIf(txtCharge.Text = "", DBNull.Value, txtCharge.Text))
      End If

      myConnection.Open()
      myCommand.ExecuteNonQuery()
      myConnection.Close()
    End Using

  End Sub

  'Protected Sub btnAdd_Click(sender As Object, e As System.EventArgs) Handles btnAdd.Click
  '  'Make sure we are dealing with a JPG or GIF file
  '  'Dim extension As String = Path.GetExtension(UploadedFile.PostedFile.FileName).ToLower()
  '  Dim MIMEType As String = "application/pdf"


  '  'Connect to the database and insert a new record into Products
  '  Using myConnection As New SqlConnection(CNNStr)

  '    Dim SQL As String = "Insert Into ucc_results (ur_us_id,ur_filing_number,ur_filing_date,ur_name_address,ur_secured_party,ur_file) " & _
  '      "Values (@us_id, @file_no, @file_date, @name_address, @secured_party, @ImageData)"
  '    Dim myCommand As New SqlCommand(SQL, myConnection)
  '    myCommand.Parameters.AddWithValue("@us_id", Request.QueryString("us"))
  '    myCommand.Parameters.AddWithValue("@file_no", txtFiling_Number.Text)
  '    myCommand.Parameters.AddWithValue("@file_date", txtFiling_Date.Text)
  '    myCommand.Parameters.AddWithValue("@name_address", txtName_Address.Text.Replace(vbCrLf, "<br />"))
  '    myCommand.Parameters.AddWithValue("@secured_party", txtSecured_Party.Text.Replace(vbCrLf, "<br />"))

  '    If UploadedFile.HasFile Then
  '      'Load FileUpload's InputStream into Byte array
  '      Dim imageBytes(UploadedFile.PostedFile.InputStream.Length) As Byte
  '      UploadedFile.PostedFile.InputStream.Read(imageBytes, 0, imageBytes.Length)
  '      myCommand.Parameters.AddWithValue("@ImageData", imageBytes)
  '    Else
  '      myCommand.Parameters.Add("@ImageData", SqlDbType.VarBinary, -1)
  '      myCommand.Parameters("@ImageData").Value = DBNull.Value
  '    End If

  '    myConnection.Open()
  '    myCommand.ExecuteNonQuery()
  '    myConnection.Close()
  '  End Using

  '  btnAdd.Visible = False
  '  btnUpload.Visible = True
  '  Response.Redirect("admin_results_list.aspx?id=" & Request.QueryString("us"))
  'End Sub

  Protected Sub btnFinished_Click(sender As Object, e As System.EventArgs) Handles btnFinished.Click
    Dim sMsg As String, sSubject As String, sSQL As String
    Dim sFrom As String, sFile As String, sIDField As String, sDebtor As String, sComID As String
    Dim sFileNo As String, sFileDate As String, sFileStatus As String, sCharge As String
    Dim sID As String = Request.QueryString("id")
    Select Case Request.QueryString("type") & ""
      Case "UCC1"
        sFrom = "ucc_financing inner join ucc_debtor as ud1 on uf_debtor1 = ud1.ud_id"
        sFile = "uf_file_attach"
        sIDField = "uf_id"
        sFileNo = "uf_file_no"
        sFileDate = "uf_filing_date"
        sFileStatus = "uf_status"
        sCharge = "uf_charge"
        sComID = "uf_company_id"
        sDebtor = "case when isnull(ud1.ud_org_name,'') <> '' then ud1.ud_org_name   else isnull(ud1.ud_ind_first_name,'') + ' ' + isnull(ud1.ud_ind_middle_name,'') + ' ' + isnull(ud1.ud_ind_last_name,'') + ' ' + isnull(ud1.ud_ind_suffix,'') end as 'name' "
      Case "UCC3"
        sFrom = "ucc3"
        sFile = "u3_file_attach"
        sIDField = "u3_id"
        sFileNo = "u3_validation_number"
        sFileDate = "u3_filing_date"
        sFileStatus = "u3_status"
        sCharge = "u3_charge"
        sComID = "u3_company_id"
        sDebtor = "case when isnull(u3_old_org_name,'') <> '' then u3_old_org_name   else isnull(u3_old_ind_first_name,'') + ' ' + isnull(u3_old_ind_middle_name,'') + ' ' + isnull(u3_old_ind_last_name,'') + ' ' + isnull(u3_old_ind_suffix,'') end as 'name' "
    End Select
    sSQL = "Select *, " & sDebtor & _
        " From " & sFrom & " Where " & sIDField & " = " & sID
    Dim dtData As DataTable = FillDataTable(sSQL)
    If dtData.Rows.Count > 0 Then
      sSubject = Request.QueryString("type") & " Filing complete for " & dtData.Rows(0).Item("name")
      sMsg = "<br>Your " & Request.QueryString("type") & " filing has been completed for " & dtData.Rows(0).Item("name") & _
       "<br><br>Please login to the <a href='https://www.identi-check.com'>Identi-Check website</a> and check the filing."
      SendEmailNew(dtData.Rows(0).Item(sComID) & "", 0, sMsg, sSubject, "", "", True)
    End If
    dtData.Dispose()
    dtData = Nothing


  End Sub

  Protected Sub btnSubmitXML_Click(sender As Object, e As System.EventArgs) Handles btnSubmitXML.Click
    Dim sosxml As New SOS_XML
    Dim sID As String = Request.QueryString("id")
    Dim sDocReceiptID As String = "", sPacketNum As String = ""
    Dim sFrom As String, sIDField As String, sDocField As String
    Dim sFileStatus As String, sPacketNumField As String
    Dim sResult As String = ""
    If sResult = "" Then
      Select Case Request.QueryString("type") & ""
        Case "UCC1"
          sFrom = "ucc_financing"
          sIDField = "uf_id"
          sDocField = "uf_doc_receipt_id"
          sFileStatus = "uf_status"
          sPacketNumField = "uf_packet_num"
          sResult = sosxml.Submit_Filing(sID, sDocReceiptID, sPacketNum)
        Case "UCC3"
          sFrom = "ucc3"
          sIDField = "u3_id"
          sDocField = "u3_doc_receipt_id"
          sFileStatus = "u3_status"
          sPacketNumField = "u3_packet_num"
          sResult = sosxml.Submit_Amendment(sID, sDocReceiptID, sPacketNum)
      End Select
      If sResult = "" Then
        lblDocReceiptID.Text = sDocReceiptID

        RunCommand("update " & sFrom & " set " & sDocField & " = '" & sDocReceiptID & "', " & _
                   sFileStatus & " = 'S', " & sPacketNumField & " = '" & sPacketNum & "' where " & sIDField & " = " & sID)

        btnSubmitXML.Visible = False
      Else
        lblError.Text = "<br />" & sResult
      End If

    Else
      'error, display returned value
      lblError.Text = "<br />" & sResult
    End If
    sosxml = Nothing
  End Sub

  Protected Sub btnCheckStatus_Click(sender As Object, e As EventArgs) Handles btnCheckStatus.Click
    Dim sRtn As String = ""
    Dim sosxml As New SOS_XML
    sRtn = sosxml.StatusRequest(lblDocReceiptID.Text)
    sosxml = Nothing


    'Dim request1 As WebRequest = WebRequest.Create(UCCXML_StatusRequestURL)
    'request1.Method = "POST"
    'Dim postData As String = "uid=" & UCCXML_UserID & "&pwd=" & UCCXML_Password & "&DocumentReceiptID=" & lblDocReceiptID.Text

    'Dim byteArray As Byte() = Encoding.UTF8.GetBytes(postData)
    'request.ContentType = "application/x-www-form-urlencoded"
    ''request.ContentLength = byteArray.Length
    ' '' Get the request stream.
    'Dim dataStream As Stream = request1.GetRequestStream()
    ' '' Write the data to the request stream.
    'dataStream.Write(byteArray, 0, byteArray.Length)
    ' '' Close the Stream object.
    'dataStream.Close()
    ' '' Get the response.
    'Dim response As WebResponse = request1.GetResponse()
    ' '' Display the status.
    'Dim sRtn As String = ""
    'sRtn = DirectCast(response, HttpWebResponse).StatusDescription
    ' '' Get the stream containing content returned by the server.
    'dataStream = response.GetResponseStream()
    ' '' Open the stream using a StreamReader for easy access.
    'Dim reader As New StreamReader(dataStream)
    ' '' Read the content.
    'Dim responseFromServer As String = reader.ReadToEnd()
    ' '' Display the content.
    ''Console.WriteLine(responseFromServer)
    'sRtn = sRtn & "<br>" & vbCrLf & responseFromServer & vbCrLf & postData
    ' '' Clean up the streams.
    'reader.Close()
    'dataStream.Close()
    'response.Close()

    lblError.Text = sRtn
    'txtResult.Text = sRtn
    btnCheckStatus.Visible = False

    Dim sID As String = Request.QueryString("id")
    lblViewAttach.Text = "<a href='View_File.aspx?type=" & Request.QueryString("type") & "" & "&id=" & sID & "&com=" & lblCom.Text & "' target='_blank'>View File</a>"

  End Sub
End Class
