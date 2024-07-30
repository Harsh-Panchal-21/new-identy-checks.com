Imports System.Data.SqlClient

Partial Class admin_amendment
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

    If Not Page.IsPostBack Then
      Dim myMaster As MainMaster = CType(MyBase.Master, MainMaster)
      'myMaster.Testing()
      myMaster.SetWelcomeName(Session("name"))

      Dim sID As String = Request.QueryString("id")

      Me.Form.Enctype = "multipart/form-data"

      Dim strSQL As String
      Dim dtData As New DataTable

      ''"ud1.ud_id as ud1_id,ud1.ud_org_name as ud1_org_name,ud1.ud_ind_last_name as ud1_ind_last_name,ud1.ud_ind_first_name as ud1_ind_first_name,ud1.ud_ind_middle_name as ud1_ind_middle_name,ud1.ud_ind_suffix as ud1_ind_suffix,ud1.ud_mailing_address as ud1_mailing_address,ud1.ud_city as ud1_city,ud1.ud_state as ud1_state,ud1.ud_zipcode as ud1_zipcode,ud1.ud_country as ud1_country,ud1.ud_d1 as ud1_d1,ud1.ud_org_type as ud1_org_type,ud1.ud_org_jurisdiction as ud1_org_jurisdiction,ud1.ud_org_id as ud1_org_id,ud1.ud_org_id_none as ud1_org_id_none, " & _
      '"ud2.ud_id as ud2_id,ud2.ud_org_name as ud2_org_name,ud2.ud_ind_last_name as ud2_ind_last_name,ud2.ud_ind_first_name as ud2_ind_first_name,ud2.ud_ind_middle_name as ud2_ind_middle_name,ud2.ud_ind_suffix as ud2_ind_suffix,ud2.ud_mailing_address as ud2_mailing_address,ud2.ud_city as ud2_city,ud2.ud_state as ud2_state,ud2.ud_zipcode as ud2_zipcode,ud2.ud_country as ud2_country,ud2.ud_d1 as ud2_d1,ud2.ud_org_type as ud2_org_type,ud2.ud_org_jurisdiction as ud2_org_jurisdiction,ud2.ud_org_id as ud2_org_id,ud2.ud_org_id_none as ud2_org_id_none " & _
      strSQL = "Select u3.* " & _
        "From ucc3 as u3 left outer join ucc_debtor as ud1 on u3.u3_new_debtor = ud1.ud_id " & _
        "Where u3_id = " & sID
      dtData = FillDataTable(strSQL)
      If dtData.Rows.Count > 0 Then
        With dtData.Rows(0)
          'txtDebtor1_Org_Name.Text = .Item("ud1_org_name") & ""
          'txtDebtor1_Ind_Last_Name.Text = .Item("ud1_ind_last_name") & ""
          'txtDebtor1_Ind_First_Name.Text = .Item("ud1_ind_first_name") & ""
          'txtDebtor1_Ind_Middle_Name.Text = .Item("ud1_ind_middle_name") & ""
          'txtDebtor1_Ind_Suffix.Text = .Item("ud1_ind_suffix") & ""
          'txtDebtor1_Mailing_Address.Text = .Item("ud1_mailing_address") & ""
          'txtDebtor1_City.Text = .Item("ud1_city") & ""
          'lstDebtor1_State.Text = .Item("ud1_state") & ""
          'txtDebtor1_Zip.Text = .Item("ud1_zipcode") & ""
          'txtDebtor1_Country.Text = .Item("ud1_country") & ""
          'txtDebtor1_d1.Text = .Item("ud1_d1") & ""
          'txtDebtor1_Org_Type.Text = .Item("ud1_org_type") & ""
          'txtDebtor1_Org_Jurisdiction.Text = .Item("ud1_org_jurisdiction") & ""
          'txtDebtor1_Org_ID.Text = .Item("ud1_org_id") & ""
          'chkDebtor1_Org_ID_None.Text = IIf(.Item("ud1_org_id_none") & "" = "Y", "Yes", "0")

          'txtDebtor2_Org_Name.Text = .Item("ud2_org_name") & ""
          'txtDebtor2_Ind_Last_Name.Text = .Item("ud2_ind_last_name") & ""
          'txtDebtor2_Ind_First_Name.Text = .Item("ud2_ind_first_name") & ""
          'txtDebtor2_Ind_Middle_Name.Text = .Item("ud2_ind_middle_name") & ""
          'txtDebtor2_Ind_Suffix.Text = .Item("ud2_ind_suffix") & ""
          'txtDebtor2_Mailing_Address.Text = .Item("ud2_mailing_address") & ""
          'txtDebtor2_City.Text = .Item("ud2_city") & ""
          'lstDebtor2_State.Text = .Item("ud2_state") & ""
          'txtDebtor2_Zip.Text = .Item("ud2_zipcode") & ""
          'txtDebtor2_Country.Text = .Item("ud2_country") & ""
          'txtDebtor2_d1.Text = .Item("ud2_d1") & ""
          'txtDebtor2_Org_Type.Text = .Item("ud2_org_type") & ""
          'txtDebtor2_Org_Jurisdiction.Text = .Item("ud2_org_jurisdiction") & ""
          'txtDebtor2_Org_ID.Text = .Item("ud2_org_id") & ""
          'chkDebtor2_Org_ID_None.Text = IIf(.Item("ud2_org_id_none") & "" = "Y", "Yes", "0")

          ''secured
          'lstSecured_Org_Name.Text = .Item("uf_secured_org_name") & ""
          'txtSecured_Ind_Last_Name.Text = .Item("ud1_ind_last_name") & ""
          'txtSecured_Ind_First_Name.Text = .Item("ud1_ind_first_name") & ""
          'txtSecured_Ind_Middle_Name.Text = .Item("ud1_ind_middle_name") & ""
          'txtSecured_Ind_Suffix.Text = .Item("ud1_ind_suffix") & ""
          'txtSecured_Mailing_Address.Text = .Item("uf_secured_mailing_address") & ""
          'txtSecured_City.Text = .Item("uf_secured_city") & ""
          'lstSecured_State.Text = .Item("uf_secured_state") & ""
          'txtSecured_Zip.Text = .Item("uf_secured_zipcode") & ""
          'txtSecured_Country.Text = .Item("uf_secured_country") & ""

          ''4 - financing
          'txtCollateral.Text = .Item("uf_finance_statement") & ""

          txtFile_No.Text = .Item("u3_validation_number") & ""

          If txtFile_No.Text <> "" Then
            lblViewAttach.Text = "<a href='View_File.aspx?type=UCC3&id=" & sID & "' target='_blank'>View Confirmation</a>"
          End If
        End With
      End If
      dtData.Dispose()
      dtData = Nothing
    End If
  End Sub

  Protected Sub btnUpload_Click(sender As Object, e As System.EventArgs) Handles btnUpload.Click
    'Make sure a file has been successfully uploaded
    If UploadedFile.PostedFile Is Nothing OrElse String.IsNullOrEmpty(UploadedFile.PostedFile.FileName) OrElse UploadedFile.PostedFile.InputStream Is Nothing Then
      '... Show error message ...
      Exit Sub
    End If

    'Make sure we are dealing with a JPG or GIF file
    'Dim extension As String = Path.GetExtension(UploadedFile.PostedFile.FileName).ToLower()
    Dim MIMEType As String = "application/pdf"


    'Connect to the database and insert a new record into Products
    Using myConnection As New SqlConnection(CNNStr)

      Dim SQL As String = "Update ucc3 set " & _
        "u3_validation_number = @file_no, u3_file_attach = @ImageData Where u3_id = " & Request.QueryString("id")
      Dim myCommand As New SqlCommand(SQL, myConnection)
      myCommand.Parameters.AddWithValue("@file_no", txtFile_No.Text)

      'Load FileUpload's InputStream into Byte array
      Dim imageBytes(UploadedFile.PostedFile.InputStream.Length) As Byte
      UploadedFile.PostedFile.InputStream.Read(imageBytes, 0, imageBytes.Length)
      myCommand.Parameters.AddWithValue("@ImageData", imageBytes)

      myConnection.Open()
      myCommand.ExecuteNonQuery()
      myConnection.Close()
    End Using

  End Sub
End Class
