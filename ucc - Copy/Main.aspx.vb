
Partial Class Main
  Inherits System.Web.UI.Page

  Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
    If Not Page.IsPostBack Then

      Dim myMaster As MainMaster = CType(MyBase.Master, MainMaster)
      'myMaster.Testing()
      myMaster.SetWelcomeName(Session("name"))
      'myMaster.LoadUser()
      'If Not myMaster.blnAuth Then Response.Redirect("default.aspx")

    End If
  End Sub

  'Protected Sub btnDebtors_Click(sender As Object, e As System.EventArgs) Handles btnDebtors.Click
  '  Response.Redirect("debtors.aspx")
  'End Sub

  'Protected Sub btnUCC1_Click(sender As Object, e As System.EventArgs) Handles btnUCC1.Click
  '  Response.Redirect("ucc1.aspx")
  'End Sub

  'Protected Sub btnUCC3_Click(sender As Object, e As System.EventArgs) Handles btnUCC3.Click
  '  Response.Redirect("ucc3.aspx")
  'End Sub

  'Protected Sub btnUCCInfo_Click(sender As Object, e As System.EventArgs) Handles btnUCCInfo.Click
  '  Response.Redirect("ucc11.aspx")
  'End Sub

  Protected Sub rgFS_NeedDataSource(sender As Object, e As Telerik.Web.UI.GridNeedDataSourceEventArgs) Handles rgFS.NeedDataSource
    Dim sSQL As String = "", sWhereCom As String = ""
    If Session("has_sub_companies") = "Y" Then
      sWhereCom = " in (Select company_id from subscriber where parent_company_id = " & Session("company_rid") & ") "
    Else
      sWhereCom = " = " & Session("company_rid") & " "
    End If

    '"--Select 'UCC1ad' as 'Doc', ufad_id as id From ucc_financing_ad " & _
    '"--Select 'UCC1ap' as 'Doc', ufap_id as id From ucc_financing_ap " & _
    '"--Select 'UCC3ad' as 'Doc', u3ad_id as id from ucc3_ad " & _
    sSQL = "Select 'UCC1' as 'Doc', uf_id as id,  " & _
       "case when isnull(ud1.ud_org_name,'') <> '' then ud1.ud_org_name  " & _
       " else isnull(ud1.ud_ind_first_name,'') + ' ' + isnull(ud1.ud_ind_middle_name,'') + ' ' + isnull(ud1.ud_ind_last_name,'') + ' ' + isnull(ud1.ud_ind_suffix,'') end as 'name', " & _
       "case when ISNULL(ufad_id,'') <> '' then ufad_id else '' end as 'ad_id', " & _
       "case when ISNULL(ufap_id,'') <> '' then ufap_id else '' end as 'ap_id',uf_date_submitted as 'date_submitted' " & _
       "From ucc_financing inner join ucc_debtor as ud1 on uf_debtor1 = ud1.ud_id " & _
       "left outer join ucc_financing_ad on ufad_uf_id = uf_id " & _
       "left outer join ucc_financing_ap on ufap_uf_id = uf_id " & _
       "where uf_company_id " & sWhereCom & _
       "union all " & _
       "Select 'UCC3' as 'Doc', u3_id as id,  " & _
       "case when isnull(u3_old_org_name,'') <> '' then u3_old_org_name  " & _
       " else isnull(u3_old_ind_first_name,'') + ' ' + isnull(u3_old_ind_middle_name,'') + ' ' + isnull(u3_old_ind_last_name,'') + ' ' + isnull(u3_old_ind_suffix,'') end as 'name', " & _
       "case when ISNULL(u3ad_id,'') <> '' then u3ad_id else '' end as 'ad_id', " & _
       "case when ISNULL(u3ap_id,'') <> '' then u3ap_id else '' end as 'ap_id'," & _
       "u3_date_submitted as 'date_submitted' " & _
       "from ucc3 " & _
       "left outer join ucc3_ad on u3ad_u3_id = u3_id " & _
       "left outer join ucc3_ap on u3ap_u3_id = u3_id " & _
       "where u3_company_id " & sWhereCom & _
       "union all " & _
        "Select 'UCC11' as 'Doc', us_id as id, " & _
       "case when isnull(ud1.ud_org_name,'') <> '' then ud1.ud_org_name  " & _
       " else isnull(ud1.ud_ind_first_name,'') + ' ' + isnull(ud1.ud_ind_middle_name,'') + ' ' + isnull(ud1.ud_ind_last_name,'') + ' ' + isnull(ud1.ud_ind_suffix,'') end as 'name', " & _
       "'' as 'ad_id', '' as 'ap_id',us_date_submitted as 'date_submitted' " & _
       "From ucc_search inner join ucc_debtor as ud1 on us_debtor = ud1.ud_id " & _
       "where us_company_id " & sWhereCom & _
       " order by date_submitted desc, Doc asc"
    rgFS.DataSource = FillDataTable(sSQL)
  End Sub

  Public Function GetPDFLink(ByVal sType As String, ByVal sID As String, Optional ByVal sAD_ID As String = "", Optional ByVal sAP_ID As String = "") As String
    Dim sRtn As String = ""

    Select Case sType
      Case "UCC1"
        sRtn = "<a href='View_UCC1.aspx?id=" & sID & "' target='_blank'>PDF</a>"
        If sAD_ID <> "" And sAD_ID <> "0" Then
          sRtn = sRtn & "&nbsp;<a href='View_UCC1ad.aspx?id=" & sAD_ID & "' target='_blank'>AD</a>"
        End If
        If sAP_ID <> "" And sAP_ID <> "0" Then
          sRtn = sRtn & "&nbsp;<a href='View_UCC1ap.aspx?id=" & sAP_ID & "' target='_blank'>AP</a>"
        End If
        If (sAD_ID <> "" And sAD_ID <> "0") Or (sAP_ID <> "" And sAP_ID <> "0") Then
          sRtn = sRtn & "&nbsp;<a href='View_UCC1.aspx?view=all&id=" & sID & "' target='_blank'>All</a>"
        End If
      Case "UCC3"
        sRtn = "<a href='View_UCC3.aspx?id=" & sID & "' target='_blank'>PDF</a>"
        If sAD_ID <> "" And sAD_ID <> "0" Then
          sRtn = sRtn & "&nbsp;<a href='View_UCC3ad.aspx?id=" & sAD_ID & "' target='_blank'>AD</a>"
        End If
        If sAP_ID <> "" And sAP_ID <> "0" Then
          sRtn = sRtn & "&nbsp;<a href='View_UCC3ap.aspx?id=" & sAP_ID & "' target='_blank'>AP</a>"
        End If
        If (sAD_ID <> "" And sAD_ID <> "0") Or (sAP_ID <> "" And sAP_ID <> "0") Then
          sRtn = sRtn & "&nbsp;<a href='View_UCC3.aspx?view=all&id=" & sID & "' target='_blank'>All</a>"
        End If
      Case "UCC11"
        sRtn = "<a href='View_UCC11.aspx?id=" & sID & "' target='_blank'>PDF</a>"
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
          If dtInfo.Rows(0).Item("uf_status") & "" = "F" Or dtInfo.Rows(0).Item("uf_file_no") & "" <> "" Then
            sRtn = "<a href='View_File.aspx?type=UCC1&id=" & dtInfo.Rows(0).Item("uf_id") & _
              "' target='_blank'>Filed - " & dtInfo.Rows(0).Item("uf_file_no") & "" & "</a>"
          Else
            sRtn = "Not Filed"
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
          If dtInfo.Rows(0).Item("u3_status") & "" = "F" Or dtInfo.Rows(0).Item("u3_validation_number") & "" <> "" Then
            sRtn = "<a href='View_File.aspx?type=UCC3&id=" & dtInfo.Rows(0).Item("u3_id") & _
              "' target='_blank'>Filed - " & dtInfo.Rows(0).Item("u3_validation_number") & "" & "</a>"
          Else
            sRtn = "Not Filed"
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
          'dtInfo.Rows(0).item("") & ""
          If dtInfo.Rows(0).Item("ur_id") & "" <> "" Then
            sRtn = "<a href='search_results.aspx?id=" & dtInfo.Rows(0).Item("us_id") & "'>Results</a>"
            'sRtn = "<a href='View_File.aspx?type=UCC3&id=" & dtInfo.Rows(0).Item("u3_id") & _
            '  "' target='_blank'>Filed - " & dtInfo.Rows(0).Item("u3_validation_number") & "" & "</a>"

          Else
            sRtn = "No Results Yet"
          End If
        Else
          'error
        End If
        dtInfo.Dispose()
        dtInfo = Nothing
        'sRtn = ""
    End Select

    Return sRtn
  End Function

  Public Function GetStartLink(ByVal sType As String, ByVal sID As String, Optional ByVal sAD_ID As String = "", Optional ByVal sAP_ID As String = "") As String
    Dim sRtn As String = ""

    Select Case sType
      Case "UCC1"
        sRtn = "<a href='ucc3.aspx?id=" & sID & "'>UCC3</a>"
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
End Class
