Imports System.Data.SqlClient

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
End Class
