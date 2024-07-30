Imports System.Data.SqlClient
Imports System.IO
Imports iTextSharp.text
Imports iTextSharp.text.pdf

Partial Class admin_search_results
  Inherits System.Web.UI.Page

  Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
    'Session("validuser") = True
    'Session("name") = "Matt Barham"
    'Session("UserID") = "matt_ucc"
    'Session("company") = "KingTech"
    'Session("company_rid") = "129"
    'Session("ucc_app") = "Y"

    If Session("UserID") = "" Then
      Response.Redirect("\index.asp?msg=Your session timed out, please login again.")
    ElseIf Session("admin") <> "2" Then
      Response.Redirect("main.aspx?msg=You do not have access to this page.")
    End If

    If Request.QueryString("us") = "" Then
      Response.Redirect("admin_main.aspx?msg=No US ID provided.")
    End If

    If Not Page.IsPostBack Then
      Dim myMaster As MainMaster = CType(MyBase.Master, MainMaster)
      'myMaster.Testing()
      myMaster.SetWelcomeName(Session("name"))

      Dim sID As String = Request.QueryString("id")

      Me.Form.Enctype = "multipart/form-data"

      Dim strSQL As String
      Dim dtData As New DataTable

      strSQL = "Select *, case when ur_file IS NULL then 'N' else 'Y' end as 'FileReady' " & _
        "from ucc_results inner join ucc_search on ur_us_id = us_id " & _
        "Where ur_id = " & sID
      dtData = FillDataTable(strSQL)
      If dtData.Rows.Count > 0 Then
        With dtData.Rows(0)
          txtFiling_Number.Text = .Item("ur_filing_number") & ""
          txtFiling_Date.Text = .Item("ur_filing_date") & ""
          txtName_Address.Text = (.Item("ur_name_address") & "").ToString.Replace("<br />", vbCrLf)
          txtSecured_Party.Text = (.Item("ur_secured_party") & "").ToString.Replace("<br />", vbCrLf)
          lblDateEntered.Text = .Item("ur_date_entered") & ""
          txtCharge.Text = .Item("ur_charge") & ""

          'If txtFile_No.Text <> "" Then
          If .Item("FileReady") = "Y" Then
            lblViewAttach.Text = "<a href='View_File.aspx?type=UCC11_results&id=" & sID & "&com=" & .Item("us_company_id") & _
            "' target='_blank'>View File</a>"
          End If

          'End If
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


    'Connect to the database and insert a new record into Products
    Using myConnection As New SqlConnection(CNNStr)

      Dim SQL As String = ""
      Dim myCommand As SqlCommand

      If UploadedFile.HasFile Then
        SQL = "Update ucc_results set " & _
        "ur_filing_number = @file_no, " & _
        "ur_filing_date = @file_date, " & _
        "ur_name_address = @name_address, " & _
        "ur_secured_party = @secured_party, ur_charge = @charge, ur_file = @ImageData " & _
        " Where ur_id = " & Request.QueryString("id")
        'Load FileUpload's InputStream into Byte array
        myCommand = New SqlCommand(SQL, myConnection)
        myCommand.Parameters.AddWithValue("@file_no", txtFiling_Number.Text)
        myCommand.Parameters.AddWithValue("@file_date", IIf(txtFiling_Date.Text = "" Or txtFiling_Date.Text = "1/1/1900", DBNull.Value, txtFiling_Date.Text))
        myCommand.Parameters.AddWithValue("@name_address", txtName_Address.Text.Replace(vbCrLf, "<br />"))
        myCommand.Parameters.AddWithValue("@secured_party", txtSecured_Party.Text.Replace(vbCrLf, "<br />"))
        myCommand.Parameters.AddWithValue("@charge", txtCharge.Text)
        Dim imageBytes(UploadedFile.PostedFile.InputStream.Length) As Byte
        UploadedFile.PostedFile.InputStream.Read(imageBytes, 0, imageBytes.Length)
        myCommand.Parameters.AddWithValue("@ImageData", imageBytes)
      Else
        SQL = "Update ucc_results set " & _
        "ur_filing_number = @file_no, " & _
        "ur_filing_date = @file_date, " & _
        "ur_name_address = @name_address, " & _
        "ur_secured_party = @secured_party, ur_charge = @charge " & _
        " Where ur_id = " & Request.QueryString("id")
        myCommand = New SqlCommand(SQL, myConnection)
        myCommand.Parameters.AddWithValue("@file_no", txtFiling_Number.Text)
        myCommand.Parameters.AddWithValue("@file_date", IIf(txtFiling_Date.Text = "" Or txtFiling_Date.Text = "1/1/1900", DBNull.Value, txtFiling_Date.Text))
        myCommand.Parameters.AddWithValue("@name_address", txtName_Address.Text.Replace(vbCrLf, "<br />"))
        myCommand.Parameters.AddWithValue("@secured_party", txtSecured_Party.Text.Replace(vbCrLf, "<br />"))
        myCommand.Parameters.AddWithValue("@charge", txtCharge.Text)
      End If

      myConnection.Open()
      myCommand.ExecuteNonQuery()
      myConnection.Close()
    End Using

  End Sub

  Protected Sub btnAdd_Click(sender As Object, e As System.EventArgs) Handles btnAdd.Click
    'Make sure we are dealing with a JPG or GIF file
    'Dim extension As String = Path.GetExtension(UploadedFile.PostedFile.FileName).ToLower()
    Dim MIMEType As String = "application/pdf"


    'Connect to the database and insert a new record into Products
    Using myConnection As New SqlConnection(CNNStr)

      Dim SQL As String = ""
      Dim myCommand As SqlCommand

      SQL = "Insert Into ucc_results (ur_us_id,ur_filing_number,ur_filing_date,ur_name_address,ur_secured_party,ur_file,ur_date_entered,ur_charge) " & _
        "Values (@us_id, @file_no, @file_date, @name_address, @secured_party, @ImageData, getdate(), @charge)"
      myCommand = New SqlCommand(SQL, myConnection)
      myCommand.Parameters.AddWithValue("@us_id", Request.QueryString("us"))
      myCommand.Parameters.AddWithValue("@file_no", txtFiling_Number.Text)
      myCommand.Parameters.AddWithValue("@file_date", IIf(txtFiling_Date.Text = "" Or txtFiling_Date.Text = "1/1/1900", DBNull.Value, txtFiling_Date.Text))
      myCommand.Parameters.AddWithValue("@name_address", txtName_Address.Text.Replace(vbCrLf, "<br />"))
      myCommand.Parameters.AddWithValue("@secured_party", txtSecured_Party.Text.Replace(vbCrLf, "<br />"))
      myCommand.Parameters.AddWithValue("@charge", txtCharge.Text)

      If UploadedFile.HasFile Then
        'Load FileUpload's InputStream into Byte array
        Dim imageBytes(UploadedFile.PostedFile.InputStream.Length) As Byte
        UploadedFile.PostedFile.InputStream.Read(imageBytes, 0, imageBytes.Length)
        myCommand.Parameters.AddWithValue("@ImageData", imageBytes)
      Else
        myCommand.Parameters.Add("@ImageData", SqlDbType.VarBinary, -1)
        myCommand.Parameters("@ImageData").Value = DBNull.Value
      End If

      myConnection.Open()
      myCommand.ExecuteNonQuery()
      myConnection.Close()
    End Using

    btnAdd.Visible = False
    btnUpload.Visible = True
    Response.Redirect("admin_results_list.aspx?id=" & Request.QueryString("us"))
  End Sub

  Protected Sub btnSearch_Click(sender As Object, e As EventArgs) Handles btnSearch.Click
    'Code from when we were going to buy bulk images of filings - stored on C drive
    'Dim sPath As String = FILINGS_PATH & lstFilingType.SelectedValue & "\"
    'Dim dirInfo As New DirectoryInfo(sPath)
    'Dim sFilingNo As String = txtFilingNo.Text.Trim
    'lstFilingType
    'dgFiling.DataSource = dirInfo.GetFiles("*" & sFilingNo & ".tif")
    'dgFiling.DataBind()
    '              <asp:HyperLinkColumn DataNavigateUrlFormatString="Admin_View_TIF.aspx?file={0}" DataNavigateUrlField="FullName" DataTextField="Name" HeaderText="File Name" Target="_blank" Visible="false" />

    'search existing ucc_results
    Dim sSQL As String = "Select us_company_id, ur_filing_number, ur_filing_date, ur_name_address, ur_secured_party " & _
      "From ucc_results inner join ucc_search on ur_us_id = us_id " & _
      "Where ur_filing_number like '%" & txtFilingNo.Text.Trim & "%'"
    dgFiling.DataSource = FillDataTable(sSQL)
    dgFiling.DataBind()
  End Sub

  Protected Sub dgFiling_ItemCommand(source As Object, e As DataGridCommandEventArgs) Handles dgFiling.ItemCommand
    'e.Item(0)
    If e.CommandName = "Select" Then
      Dim sFile As String = e.Item.Cells(1).Text
      Dim fiOne As New FileInfo(sFile)
      Dim sFilingNo As String = fiOne.Name.Replace(".tif", "")
      txtFiling_Number.Text = sFilingNo

      Dim myDoc As New Document()
      'Dim output = New FileStream("C:\Web_Files\UCC\test.pdf", FileMode.Create)
      Dim memStream As New MemoryStream
      Dim writer = PdfWriter.GetInstance(myDoc, memStream)
      myDoc.Open()
      AddTiff(myDoc, sFile)
      myDoc.Close()
      writer.Close()
      Dim myByte() As Byte = memStream.ToArray
      memStream.Close()
      Dim sContents As String = ""
      Dim myReader As New PdfReader(myByte)
      Dim numPages As Integer = myReader.NumberOfPages
      myReader.Close()

      Using engine = New Tesseract.TesseractEngine(Server.MapPath("~/tessdata"), "eng", Tesseract.EngineMode.[Default])
        ' have to load Pix via a bitmap since Pix doesn't support loading a stream.
        Using image = New System.Drawing.Bitmap(sFile)
          Using pix = Tesseract.PixConverter.ToPix(image)
            'pix.Save("",ImageFormat.Lpd)
            Using page = engine.Process(pix)
              'page.GetHOCRText
              'meanConfidenceLabel.InnerText = [String].Format("{0:P}", page.GetMeanConfidence())
              'txtResult.Text = [String].Format("{0:P}", page.GetMeanConfidence()) & vbCrLf & page.GetText()
              sContents = page.GetText()
            End Using
          End Using
        End Using
      End Using

      If sContents <> "" Then
        Dim sFind1A As String = "1a. ORGAN"
        Dim sFind1B As String = "OR 1b. IND"
        Dim sFind1C As String = "1c. MAIL"
        Dim sFind2 As String = "2. DEBT"
        Dim sFind3A As String = "3a. ORG"
        Dim sFind3B As String = "OR 3b. IND"
        Dim sFind3C As String = "3c. MAIL"

        txtName_Address.Text = sContents
        Exit Sub

        Dim iPos1A As Integer = sContents.IndexOf(sFind1A)
        Dim iPos1ABreak As Integer = sContents.IndexOf(vbLf, iPos1A)
        Dim iPos1B As Integer = sContents.IndexOf(sFind1B, iPos1A)
        Dim iPos1BBreak As Integer = sContents.IndexOf(vbLf, iPos1B)
        Dim iPos1C As Integer = sContents.IndexOf(sFind1C, iPos1B)
        Dim iPos1CBreak As Integer = sContents.IndexOf(vbLf, iPos1C)
        Dim iPos2 As Integer = sContents.IndexOf(sFind2, iPos1C)

        Dim iPos3A As Integer = sContents.IndexOf(sFind3A)
        Dim iPos3ABreak As Integer = sContents.IndexOf(vbLf, iPos3A)
        Dim iPos3B As Integer = sContents.IndexOf(sFind3B, iPos3A)
        Dim iPos3BBreak As Integer = sContents.IndexOf(vbLf, iPos3B)
        Dim iPos3C As Integer = sContents.IndexOf(sFind3C, iPos3B)

        Dim sDebtOrg As String = "", sDebtInd As String = "", sDebtMail As String = ""
        Dim sSecOrg As String = "", sSecInd As String = ""

        txtFiling_Date.Text = iPos1A & " - " & iPos1B & " - " & iPos1C & " - " & iPos2 & " - " & iPos1ABreak & " - " & iPos1BBreak & " - " & iPos1CBreak
        '875 - 899 - 998 - 1097 - 898 - 983 - 983
        txtName_Address.Text = sContents
        Exit Sub

        If iPos1A > 0 And iPos1B > 0 And iPos1C > 0 And iPos2 > 0 Then
          '875 - 899 - 998 - 1097
          sDebtOrg = sContents.Substring(iPos1ABreak + 1, iPos1B - (iPos1ABreak + 1))
          sDebtInd = sContents.Substring(iPos1BBreak + 1, iPos1C - (iPos1BBreak + 1))
          sDebtMail = sContents.Substring(iPos1CBreak + 1, iPos2 - (iPos1CBreak + 1))
        End If
        If iPos3A > 0 Then
          sSecOrg = sContents.Substring(iPos3ABreak + 1, iPos3B - (iPos3ABreak + 1))
          sSecInd = sContents.Substring(iPos3BBreak + 1, iPos3C - (iPos3BBreak + 1))
          'sDebtMail = sContents.Substring(iPos1CBreak + 2, iPos2 - (iPos1CBreak + 2))
        End If

        Dim sName As String = "", sSecured As String = ""
        If sDebtOrg.Trim <> "" Then
          sName = sDebtOrg.Trim
        Else
          sName = sDebtInd.Trim
        End If
        If sSecOrg.Trim <> "" Then
          sSecured = sSecOrg.Trim
        Else
          sSecured = sSecInd.Trim
        End If
        txtFiling_Date.Text = ""
        txtName_Address.Text = sName & vbCrLf & sDebtMail.Trim
        txtSecured_Party.Text = sSecured
        txtCharge.Text = numPages.ToString

        'Dim sMsg As String = "NameAddr: " & txtName_Address.Text & vbCrLf & "Secured: " & txtSecured_Party.Text & vbCrLf & "Pages: " & numPages
        'txtName_Address.Text = sContents
        Exit Sub
      End If
      
      'dgFiling.DataKeys(CInt(e.Item.ItemIndex)).ToString


      Dim MIMEType As String = "application/pdf"

      'Connect to the database and insert a new record into Products
      Using myConnection As New SqlConnection(CNNStr)

        Dim SQL As String = ""
        Dim myCommand As SqlCommand

        SQL = "Insert Into ucc_results (ur_us_id,ur_filing_number,ur_filing_date,ur_name_address,ur_secured_party,ur_file,ur_date_entered,ur_charge) " & _
          "Values (@us_id, @file_no, @file_date, @name_address, @secured_party, @ImageData, getdate(), @charge)"
        myCommand = New SqlCommand(SQL, myConnection)
        myCommand.Parameters.AddWithValue("@us_id", Request.QueryString("us"))
        myCommand.Parameters.AddWithValue("@file_no", txtFiling_Number.Text)
        myCommand.Parameters.AddWithValue("@file_date", IIf(txtFiling_Date.Text = "" Or txtFiling_Date.Text = "1/1/1900", DBNull.Value, txtFiling_Date.Text))
        myCommand.Parameters.AddWithValue("@name_address", txtName_Address.Text.Replace(vbCrLf, "<br />"))
        myCommand.Parameters.AddWithValue("@secured_party", txtSecured_Party.Text.Replace(vbCrLf, "<br />"))
        myCommand.Parameters.AddWithValue("@charge", txtCharge.Text)

        If Not myByte Is Nothing Then
          'Load FileUpload's InputStream into Byte array
          'Dim imageBytes(UploadedFile.PostedFile.InputStream.Length) As Byte
          UploadedFile.PostedFile.InputStream.Read(myByte, 0, myByte.Length)
          myCommand.Parameters.AddWithValue("@ImageData", myByte)
        Else
          myCommand.Parameters.Add("@ImageData", SqlDbType.VarBinary, -1)
          myCommand.Parameters("@ImageData").Value = DBNull.Value
        End If

        myConnection.Open()
        myCommand.ExecuteNonQuery()
        myConnection.Close()
      End Using

      btnAdd.Visible = False
      btnUpload.Visible = True
      Response.Redirect("admin_results_list.aspx?id=" & Request.QueryString("us"))

    End If
  End Sub

End Class
