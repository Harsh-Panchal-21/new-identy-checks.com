
Partial Class admin_results_list
  Inherits System.Web.UI.Page

  Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
    'check for admin
    If Session("UserID") = "" Then
      Response.Redirect("\index.asp?msg=Your session timed out, please login again.")
    ElseIf Session("admin") <> "2" Then
      Response.Redirect("main.aspx?msg=You do not have access to this page.")
    End If

    If Not Page.IsPostBack Then
      Dim myMaster As MainMaster = CType(MyBase.Master, MainMaster)
      'myMaster.Testing()
      myMaster.SetWelcomeName(Session("name"))

      Dim sID As String = Request.QueryString("id") & ""
      lblAddNew.Text = "<a href='admin_search_results.aspx?id=0&us=" & sID & "'>Add New Result</a>"

      Dim sbHdr As New System.Text.StringBuilder
      Dim sSQL As String = "Select us.*, users.name as user_name, users.email, sub.name as sub_name, sub.phone, " & _
      "ud1.ud_id as ud1_id,ud1.ud_org_name as ud1_org_name,ud1.ud_ind_last_name as ud1_ind_last_name,ud1.ud_ind_first_name as ud1_ind_first_name,ud1.ud_ind_middle_name as ud1_ind_middle_name,ud1.ud_ind_suffix as ud1_ind_suffix,ud1.ud_mailing_address as ud1_mailing_address,ud1.ud_city as ud1_city,ud1.ud_state as ud1_state,ud1.ud_zipcode as ud1_zipcode,ud1.ud_country as ud1_country,ud1.ud_d1 as ud1_d1,ud1.ud_org_type as ud1_org_type,ud1.ud_org_jurisdiction as ud1_org_jurisdiction,ud1.ud_org_id as ud1_org_id,ud1.ud_org_id_none as ud1_org_id_none " & _
      "From ucc_search us inner join subscriber sub on us.us_company_id = sub.company_id  " & _
      "inner join users on us_user_submitted = users.userid " & _
      "left outer join ucc_debtor as ud1 on us.us_debtor = ud1.ud_id " & _
      "Where us_id = " & sID
      Dim dtSearch As DataTable = FillDataTable(sSQL)
      If dtSearch.Rows.Count > 0 Then
        With dtSearch.Rows(0)
          Dim sOrgOrInd As String, sName As String, sSR As String, sCR As String
          If .Item("ud1_org_name") & "" <> "" Then
            sOrgOrInd = "Organization: "
            sName = .Item("ud1_org_name") & ""
          Else
            sOrgOrInd = "Individual: "
            sName = .Item("ud1_ind_first_name") & " " & .Item("ud1_ind_middle_name") & " " & .Item("ud1_ind_last_name") & " " & .Item("ud1_ind_suffix")
          End If
          ''lblOrgName.Text = .Item("ud1_org_name") & ""
          ''lblIndName.Text = .Item("ud1_ind_first_name") & " " & .Item("ud1_ind_middle_name") & " " & .Item("ud1_ind_last_name") & " " & .Item("ud1_ind_suffix")
          sSR = IIf(.Item("us_sr") & "" = "A", "All", "Unlapsed")
          sCR = IIf(.Item("us_cr") & "" = "A", "All", "Unlapsed")
          Dim sMore As String = ""
          If .Item("us_more_date") & "" <> "" Or .Item("us_more_address") & "" <> "" Or .Item("us_more_name") & "" <> "" Or .Item("us_more_other") & "" <> "" Then
            sMore = "Date: <b>" & .Item("us_more_date") & "</b><br />Address, City, State: <b>" & .Item("us_more_address") & "</b><br />" & _
              "Name Variations: <b>" & .Item("us_more_name") & "</b><br />Other: <b>" & .Item("us_more_other") & "</b>"
            'lblMore.Text = sMore
            'trMore.Visible = True
          Else
            'trMore.Visible = False
          End If

          Dim sSpec As String = ""
          If .Item("us_sco1_rec_no") & .Item("us_sco1_date") & .Item("us_sco1_type") & "" <> "" Then
            sSpec = .Item("us_sco1_rec_no") & " - " & .Item("us_sco1_date") & " - " & .Item("us_sco1_type")
          End If
          If .Item("us_sco2_rec_no") & .Item("us_sco2_date") & .Item("us_sco2_type") & "" <> "" Then
            sSpec += "<br />" & .Item("us_sco2_rec_no") & " - " & .Item("us_sco2_date") & " - " & .Item("us_sco2_type")
          End If
          If .Item("us_sco3_rec_no") & .Item("us_sco3_date") & .Item("us_sco3_type") & "" <> "" Then
            sSpec += "<br />" & .Item("us_sco3_rec_no") & " - " & .Item("us_sco3_date") & " - " & .Item("us_sco3_type")
          End If
          If .Item("us_sco4_rec_no") & .Item("us_sco4_date") & .Item("us_sco4_type") & "" <> "" Then
            sSpec += "<br />" & .Item("us_sco4_rec_no") & " - " & .Item("us_sco4_date") & " - " & .Item("us_sco4_type")
          End If
          If .Item("us_sco5_rec_no") & .Item("us_sco5_date") & .Item("us_sco5_type") & "" <> "" Then
            sSpec += "<br />" & .Item("us_sco5_rec_no") & " - " & .Item("us_sco5_date") & " - " & .Item("us_sco5_type")
          End If
          If .Item("us_sco6_rec_no") & .Item("us_sco6_date") & .Item("us_sco6_type") & "" <> "" Then
            sSpec += "<br />" & .Item("us_sco6_rec_no") & " - " & .Item("us_sco6_date") & " - " & .Item("us_sco6_type")
          End If
          'If sSpec <> "" Then
          '  lblSpecific.Text = sSpec
          '  trSpec.Visible = True
          'Else
          '  trSpec.Visible = False
          'End If
          'If .Item("us_additional") & "" <> "" Then
          '  lblAdditional.Text = .Item("us_additional") & ""
          '  trAdd.Visible = True
          'Else
          '  trAdd.Visible = False
          'End If
          'lblRequestedBy.Text = .Item("user_name") & " (" & .Item("email") & ") of " & .Item("sub_name") & " - " & .Item("phone")
          sbHdr.Append("<table cellpadding='2' cellspacing='0'>")
          sbHdr.Append("<tr>")
          sbHdr.Append("<td>" & sOrgOrInd & "</td><td><b>" & sName & "</b></td>")
          sbHdr.Append("</tr>")
          sbHdr.Append("<tr>")
          sbHdr.Append("<td colspan='2'>Search Response: <b>" & sSR & "</b>&nbsp;&nbsp;&nbsp;&nbsp;")
          sbHdr.Append("Copy Request: <b>" & sCR & "</b>")
          sbHdr.Append("</td>")
          sbHdr.Append("</tr>")
          If sMore <> "" Then
            sbHdr.Append("<tr>")
            sbHdr.Append("<td colspan='2'>" & sMore & "</td>")
            sbHdr.Append("</tr>")
          End If
          If sSpec <> "" Then
            sbHdr.Append("<tr>")
            sbHdr.Append("<td>Specific:</td><td>" & sSpec & "</td>")
            sbHdr.Append("</tr>")
          End If
          If .Item("us_additional") & "" <> "" Then
            sbHdr.Append("<tr>")
            sbHdr.Append("<td>Additional:</td><td>" & .Item("us_additional") & "</td>")
            sbHdr.Append("</tr>")
          End If
          sbHdr.Append("<tr>")
          sbHdr.Append("<td colspan='2'>Requested By:<b>" & .Item("user_name") & " (" & .Item("email") & ") of " & .Item("sub_name") & " - " & .Item("phone") & "</b></td>")
          sbHdr.Append("</tr>")
          sbHdr.Append("</table>")

          lblHdr.Text = sbHdr.ToString
          rgSR.MasterTableView.Caption = sbHdr.ToString
          'rgSR.ExportSettings.Pdf.PageTitle = "<b>Test</b>"
        End With
      Else
        'error
      End If
      dtSearch.Dispose()
      dtSearch = Nothing

    End If
  End Sub

  Protected Sub rgSR_DeleteCommand(sender As Object, e As Telerik.Web.UI.GridCommandEventArgs) Handles rgSR.DeleteCommand
    Try
      Dim sID As String = e.Item.OwnerTableView.DataKeyValues(e.Item.ItemIndex)("ur_id")
      RunCommand("Delete From ucc_results where ur_id = " & sID)
    Catch ex As Exception
      lblMsg.Text = "<br />Error deleting result: " & ex.ToString
      Exit Sub
    End Try
    lblMsg.Text = "<br />Result Deleted"
  End Sub

  Protected Sub rgSR_GridExporting(sender As Object, e As Telerik.Web.UI.GridExportingArgs) Handles rgSR.GridExporting
    'Dim customHTML As String = "<table><tr><td>Something</td><td>Something else</td></tr><table>"
    'e.ExportOutput = e.ExportOutput.Replace("<body>", "<body>" & customHTML)
  End Sub

  Protected Sub rgSR_PdfExporting(sender As Object, e As Telerik.Web.UI.GridPdfExportingArgs) Handles rgSR.PdfExporting
    'Dim customHTML As String = "<table><tr><td>Something</td><td>Something else</td></tr><table>"
    'e.RawHTML = e.RawHTML.Replace("<body>", "<body>" & customHTML)
    Dim sHdr As String = lblHdr.Text
    sHdr = sHdr.Replace("<table cellpadding='2' cellspacing='0'>", "")
    sHdr = sHdr.Replace("</table>", "")
    sHdr = sHdr.Replace("<tr>", "")
    sHdr = sHdr.Replace("</tr>", "<br />")
    sHdr = sHdr.Replace("</td><td>", "&nbsp;&nbsp;&nbsp;")
    sHdr = sHdr.Replace("<td>", "<div>")
    sHdr = sHdr.Replace("<td colspan='2'>", "<div>")
    sHdr = sHdr.Replace("</td>", "</div>")
    e.RawHTML = sHdr + e.RawHTML
  End Sub

  Protected Sub rgSR_NeedDataSource(sender As Object, e As Telerik.Web.UI.GridNeedDataSourceEventArgs) Handles rgSR.NeedDataSource
    Dim sSQL As String = ""
    sSQL = "Select ucc_results.*, us_company_id, case when ur_file IS NULL then 'N' else 'Y' end as 'FileReady' " & _
      "From ucc_results inner join ucc_search on ur_us_id = us_id where ur_us_id = " & Request.QueryString("id")
    rgSR.DataSource = FillDataTable(sSQL)
  End Sub

  Public Function GetPDFLink(ByVal sID As String, ByVal sComID As String, ByVal sFileReady As String) As String
    Dim sRtn As String = ""

    If sFileReady = "Y" Then
      sRtn = "<a href='View_File.aspx?type=UCC11_results&id=" & sID & "&com=" & sComID & "' target='_blank'>PDF</a>"
    Else
      sRtn = "File Not ready"
    End If


    Return sRtn
  End Function

  Protected Sub btnFinished_Click(sender As Object, e As System.EventArgs) Handles btnFinished.Click
    Dim sMsg As String, sSubject As String, sSQL As String
    Try
      'lblMsg.Text = "Test1"
      sSQL = "Select ucc_results.*, us_company_id, " & _
      "case when isnull(ud1.ud_org_name,'') <> '' then ud1.ud_org_name else isnull(ud1.ud_ind_first_name,'') + ' ' + isnull(ud1.ud_ind_middle_name,'') + ' ' + isnull(ud1.ud_ind_last_name,'') + ' ' + isnull(ud1.ud_ind_suffix,'') end as 'name' " & _
      " From ucc_results inner join ucc_search on ur_us_id = us_id " & _
      " inner join ucc_debtor as ud1 on us_debtor = ud1.ud_id where ur_us_id = " & Request.QueryString("id")
      Dim dtData As DataTable = FillDataTable(sSQL)
      If dtData.Rows.Count > 0 Then
        'lblMsg.Text = "Test2"
        sSubject = "Search complete for " & dtData.Rows(0).Item("name")
        sMsg = "<br>Your search has been completed for " & dtData.Rows(0).Item("name") & _
         "<br><br>Please login to the <a href='https://www.identi-check.com'>Identi-Check website</a> and check the results."
        SendEmailNew(dtData.Rows(0).Item("us_company_id") & "", 0, sMsg, sSubject, "", "", True)
        RunCommand("Update ucc_search set us_status = 'F' Where us_id = " & dtData.Rows(0).Item("ur_us_id") & "")
      End If
      dtData.Dispose()
      dtData = Nothing
    Catch ex As Exception
      lblMsg.Text = "Error: " & ex.ToString
    End Try
    
  End Sub

End Class
