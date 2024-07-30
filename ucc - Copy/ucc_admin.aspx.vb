
Partial Class ucc_admin
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

      '
    End If
  End Sub

  Protected Sub rgFS_DeleteCommand(sender As Object, e As Telerik.Web.UI.GridCommandEventArgs) Handles rgFS.DeleteCommand
    Dim sID As String = e.Item.OwnerTableView.DataKeyValues(e.Item.ItemIndex)("id")
    Dim sTyp As String = e.Item.OwnerTableView.DataKeyValues(e.Item.ItemIndex)("Doc")
    Try
      Select Case sTyp
        Case "UCC1"
          RunCommand("Delete From ucc_financing_ap where ufap_uf_id = " & sID)
          RunCommand("Delete From ucc_financing_ad where ufad_uf_id = " & sID)
          RunCommand("Delete From ucc_financing where uf_id = " & sID)
        Case "UCC3"
          RunCommand("Delete From ucc3_ad where u3ad_u3_id = " & sID)
          RunCommand("Delete From ucc3 where u3_id = " & sID)
        Case "UCC11"
          RunCommand("Delete From ucc_results where ur_us_id = " & sID)
          RunCommand("Delete From ucc_search where us_id = " & sID)
      End Select
      'RunCommand("Delete From ucc_results where ur_id = " & sID)
    Catch ex As Exception
      lblMsg.Text = "<br />Error deleting result: " & ex.ToString
      Exit Sub
    End Try
    lblMsg.Text = "<br />" & sTyp & " Deleted"
  End Sub

  Protected Sub rgFS_NeedDataSource(sender As Object, e As Telerik.Web.UI.GridNeedDataSourceEventArgs) Handles rgFS.NeedDataSource
    Dim sSQL As String
    '"--Select 'UCC1ad' as 'Doc', ufad_id as id From ucc_financing_ad " & _
    '"--Select 'UCC1ap' as 'Doc', ufap_id as id From ucc_financing_ap " & _
    '"--Select 'UCC3ad' as 'Doc', u3ad_id as id from ucc3_ad " & _
    sSQL = "Select 'UCC1' as 'Doc', uf_id as id,  " & _
       "case when isnull(ud1.ud_org_name,'') <> '' then ud1.ud_org_name  " & _
       " else isnull(ud1.ud_ind_first_name,'') + ' ' + isnull(ud1.ud_ind_middle_name,'') + ' ' + isnull(ud1.ud_ind_last_name,'') + ' ' + isnull(ud1.ud_ind_suffix,'') end as 'name', " & _
       "case when ISNULL(ufad_id,'') <> '' then ufad_id else '' end as 'ad_id', " & _
       "case when ISNULL(ufap_id,'') <> '' then ufap_id else '' end as 'ap_id',uf_date_submitted as 'date_submitted', uf_company_id as company_id, " & _
       "case when isnull(uf_status,'') = 'F' then 'Filed' when isnull(uf_status,'') = 'N' then 'New' when isnull(uf_status,'') = 'S' then 'Submitted' end as status " & _
       "From ucc_financing inner join ucc_debtor as ud1 on uf_debtor1 = ud1.ud_id " & _
       "left outer join ucc_financing_ad on ufad_uf_id = uf_id " & _
       "left outer join ucc_financing_ap on ufap_uf_id = uf_id " & _
       "union all " & _
       "Select 'UCC3' as 'Doc', u3_id as id,  " & _
       "case when isnull(u3_old_org_name,'') <> '' then u3_old_org_name  " & _
       " else isnull(u3_old_ind_first_name,'') + ' ' + isnull(u3_old_ind_middle_name,'') + ' ' + isnull(u3_old_ind_last_name,'') + ' ' + isnull(u3_old_ind_suffix,'') end as 'name', " & _
       "case when ISNULL(u3ad_id,'') <> '' then u3ad_id else '' end as 'ad_id', " & _
       "case when ISNULL(u3ap_id,'') <> '' then u3ap_id else '' end as 'ap_id'," & _
       "u3_date_submitted as 'date_submitted', u3_company_id as company_id, " & _
       "case when isnull(u3_status,'') = 'F' then 'Filed' when isnull(u3_status,'') = 'N' then 'New' when isnull(u3_status,'') = 'S' then 'Submitted' end as status " & _
       "from ucc3 " & _
       "left outer join ucc3_ad on u3ad_u3_id = u3_id " & _
       "left outer join ucc3_ap on u3ap_u3_id = u3_id " & _
       "union all " & _
        "Select 'UCC11' as 'Doc', us_id as id, " & _
       "case when isnull(ud1.ud_org_name,'') <> '' then ud1.ud_org_name else isnull(ud1.ud_ind_first_name,'') + ' ' + isnull(ud1.ud_ind_middle_name,'') + ' ' + isnull(ud1.ud_ind_last_name,'') + ' ' + isnull(ud1.ud_ind_suffix,'') end as 'name', " & _
       "'' as 'ad_id', '' as 'ap_id',us_date_submitted as 'date_submitted', us_company_id as company_id, " & _
       "case when isnull(us_status,'') = 'F' then 'Finished' when isnull(us_status,'') = 'N' then 'New' when isnull(us_status,'') = 'S' then 'Started' end as status " & _
       "From ucc_search inner join ucc_debtor as ud1 on us_debtor = ud1.ud_id order by date_submitted desc"
    rgFS.DataSource = FillDataTable(sSQL)
  End Sub

  Public Function GetPDFLink(ByVal sType As String, ByVal sID As String, ByVal sComID As String, Optional ByVal sAD_ID As String = "", Optional ByVal sAP_ID As String = "") As String
    Dim sRtn As String = ""

    Select Case sType
      Case "UCC1"
        sRtn = "<a href='View_UCC1.aspx?id=" & sID & "&com=" & sComID & "' target='_blank'>PDF</a>"
        If sAD_ID <> "" And sAD_ID <> "0" Then
          sRtn = sRtn & "&nbsp;<a href='View_UCC1ad.aspx?id=" & sAD_ID & "&com=" & sComID & "' target='_blank'>AD</a>"
        End If
        If sAP_ID <> "" And sAP_ID <> "0" Then
          sRtn = sRtn & "&nbsp;<a href='View_UCC1ap.aspx?id=" & sAP_ID & "&com=" & sComID & "' target='_blank'>AP</a>"
        End If
        If (sAD_ID <> "" And sAD_ID <> "0") Or (sAP_ID <> "" And sAP_ID <> "0") Then
          sRtn = sRtn & "&nbsp;<a href='View_UCC1.aspx?view=all&id=" & sID & "&com=" & sComID & "' target='_blank'>All</a>"
        End If
      Case "UCC3"
        sRtn = "<a href='View_UCC3.aspx?id=" & sID & "&com=" & sComID & "' target='_blank'>PDF</a>"
        If sAD_ID <> "" And sAD_ID <> "0" Then
          sRtn = sRtn & "&nbsp;<a href='View_UCC3ad.aspx?id=" & sAD_ID & "&com=" & sComID & "' target='_blank'>AD</a>"
        End If
        If sAP_ID <> "" And sAP_ID <> "0" Then
          sRtn = sRtn & "&nbsp;<a href='View_UCC3ap.aspx?id=" & sAP_ID & "&com=" & sComID & "' target='_blank'>AP</a>"
        End If
        If (sAD_ID <> "" And sAD_ID <> "0") Or (sAP_ID <> "" And sAP_ID <> "0") Then
          sRtn = sRtn & "&nbsp;<a href='View_UCC3.aspx?view=all&id=" & sID & "&com=" & sComID & "' target='_blank'>All</a>"
        End If
        'If sAD_ID <> "" And sAD_ID <> "0" Then
        '  sRtn = sRtn & "&nbsp;<a href='View_UCC3ad.aspx?id=" & sAD_ID & "&com=" & sComID & "' target='_blank'>AD</a>"
        '  sRtn = sRtn & "&nbsp;<a href='View_UCC3.aspx?view=all&id=" & sID & "&com=" & sComID & "' target='_blank'>All</a>"
        'End If
      Case "UCC11"
        sRtn = "<a href='View_UCC11.aspx?id=" & sID & "&com=" & sComID & "' target='_blank'>PDF</a>"
    End Select

    Return sRtn
  End Function

  Public Function BuildResults(ByVal sType As String, ByVal sID As String, Optional ByVal sAD_ID As String = "", Optional ByVal sAP_ID As String = "") As String
    Dim sRtn As String = ""
    Dim sSQL As String = ""
    Dim dtInfo As DataTable

    Select Case sType
      Case "UCC1"
        sSQL = "Select * From ucc_financing Where uf_id = " & sID
        dtInfo = FillDataTable(sSQL)
        If dtInfo.Rows.Count > 0 Then
          'dtInfo.Rows(0).item("") & ""
          If dtInfo.Rows(0).Item("uf_status") & "" = "R" Then
            sRtn = "Rejected - <a href='admin_filing_edit.aspx?type=UCC1&id=" & sID & "' target='_blank'>File</a>"
          ElseIf dtInfo.Rows(0).Item("uf_status") & "" = "F" Or dtInfo.Rows(0).Item("uf_file_no") & "" <> "" Then
            sRtn = "<a href='View_File.aspx?type=UCC1&id=" & dtInfo.Rows(0).Item("uf_id") & _
              "&com=" & dtInfo.Rows(0).Item("uf_company_id") & "' target='_blank'>Filed - " & dtInfo.Rows(0).Item("uf_file_no") & "" & "</a>" & _
              " - <a href='admin_filing_edit.aspx?type=UCC1&id=" & sID & "' target='_blank'>Edit</a>"
          Else
            sRtn = "Not Filed - <a href='admin_filing_edit.aspx?type=UCC1&id=" & sID & "' target='_blank'>File</a>"
          End If
        Else
          'error
        End If
          dtInfo.Dispose()
          dtInfo = Nothing
          'sRtn = ""
      Case "UCC3"
          sSQL = "Select * From ucc3 Where u3_id = " & sID
          dtInfo = FillDataTable(sSQL)
          If dtInfo.Rows.Count > 0 Then
            'dtInfo.Rows(0).item("") & ""
          If dtInfo.Rows(0).Item("u3_status") & "" = "R" Then
            sRtn = "Rejected - <a href='admin_filing_edit.aspx?type=UCC3&id=" & sID & "' target='_blank'>File</a>"
          ElseIf dtInfo.Rows(0).Item("u3_status") & "" = "F" Or dtInfo.Rows(0).Item("u3_validation_number") & "" <> "" Then
            sRtn = "<a href='View_File.aspx?type=UCC3&id=" & dtInfo.Rows(0).Item("u3_id") & _
              "&com=" & dtInfo.Rows(0).Item("u3_company_id") & "' target='_blank'>Filed - " & dtInfo.Rows(0).Item("u3_validation_number") & "" & "</a>" & _
              " - <a href='admin_filing_edit.aspx?type=UCC3&id=" & sID & "' target='_blank'>Edit</a>"
          Else
            sRtn = "Not Filed - <a href='admin_filing_edit.aspx?type=UCC3&id=" & sID & "' target='_blank'>File</a>"
          End If
          Else
            'error
          End If
          dtInfo.Dispose()
          dtInfo = Nothing
          'sRtn = ""
      Case "UCC11"
          sSQL = "Select * From ucc_search left outer join ucc_results on us_id = ur_us_id Where us_id = " & sID
          dtInfo = FillDataTable(sSQL)
          If dtInfo.Rows.Count > 0 Then
            If dtInfo.Rows(0).Item("us_charge") & "" <> Search_Charge & "00" Then
              sRtn = "SEARCH AFTER<br />"
            End If

            If dtInfo.Rows(0).Item("ur_id") & "" <> "" Then
              sRtn += "<a href='admin_results_list.aspx?id=" & dtInfo.Rows(0).Item("us_id") & "&com=" & _
                dtInfo.Rows(0).Item("us_company_id") & "' target='_blank'>Results</a>"
              'sRtn = "<a href='View_File.aspx?type=UCC3&id=" & dtInfo.Rows(0).Item("u3_id") & _
              '  "' target='_blank'>Filed - " & dtInfo.Rows(0).Item("u3_validation_number") & "" & "</a>"

            Else
              sRtn += "No Results Yet - <a href='admin_results_list.aspx?id=" & sID & "' target='_blank'>Add</a>"
            End If
          Else
            'error
          End If
          dtInfo.Dispose()
          dtInfo = Nothing
    End Select

    Return sRtn
  End Function

  Public Function GetStartLink(ByVal sType As String, ByVal sID As String, Optional ByVal sAD_ID As String = "", Optional ByVal sAP_ID As String = "") As String
    Dim sRtn As String = ""

    Select Case sType
      Case "UCC1"
        'sRtn = "<a href='ucc3.aspx?id=" & sID & "'>UCC3</a>"
        'If sAD_ID <> "" And sAD_ID <> "0" Then
        '  sRtn = sRtn & "&nbsp;<a href='View_UCC1ad.aspx?id=" & sAD_ID & "' target='_blank'>AD</a>"
        'End If
        'If sAP_ID <> "" And sAP_ID <> "0" Then
        '  sRtn = sRtn & "&nbsp;<a href='View_UCC1ap.aspx?id=" & sAP_ID & "' target='_blank'>AP</a>"
        'End If
        'If sAD_ID <> "0" Or sAP_ID <> "0" Then
        '  'sRtn = sRtn & "&nbsp;<a href='View_UCC1.aspx?view=all&id=" & sID & "' target='_blank'>All</a>"
        'End If
      Case "UCC3"
        'sRtn = "<a href='View_UCC3.aspx?id=" & sID & "' target='_blank'>PDF</a>"
        'If sAD_ID <> "" Then
        '  sRtn = sRtn & "&nbsp;<a href='View_UCC3ad.aspx?id=" & sAD_ID & "' target='_blank'>AD</a>"
        '  'sRtn = sRtn & "&nbsp;<a href='View_UCC3.aspx?view=all&id=" & sID & "' target='_blank'>All</a>"
        'End If
      Case "UCC11"
        'sRtn = "<a href='View_UCC11.aspx?id=" & sID & "' target='_blank'>PDF</a>"
    End Select

    Return sRtn
  End Function

  Protected Sub Timer1_Tick(sender As Object, e As System.EventArgs) Handles Timer1.Tick
    rgFS.Rebind()
  End Sub
End Class
