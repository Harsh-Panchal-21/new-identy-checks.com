Imports Telerik.Web.UI

Partial Class reports
  Inherits System.Web.UI.Page
  Private isExport As Boolean = False
  Private _ordersExpandedState As Hashtable

  Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
    If Not Page.IsPostBack Then
      'reset states
      Me._ordersExpandedState = Nothing
      Me.Session("_ordersExpandedState") = Nothing

      Dim myMaster As MainMaster = CType(MyBase.Master, MainMaster)
      'myMaster.Testing()
      myMaster.SetWelcomeName(Session("name"))
      'myMaster.LoadUser()
      'If Not myMaster.blnAuth Then Response.Redirect("default.aspx")

      'default to this month
      rdpFromDate.SelectedDate = New Date(Now.Year, Now.Month, 1)
      rdpToDate.SelectedDate = New Date(Now.Year, Now.Month, 1).AddMonths(1).AddDays(-1)
      Dim sHdr As String = "Identi-Check Inc.<br />" & _
        "Charges from " & New Date(Now.Year, Now.Month, 1).ToShortDateString & "  to  " & New Date(Now.Year, Now.Month, 1).AddMonths(1).AddDays(-1).ToShortDateString
      lblHdr.Text = sHdr
      rgCharge.MasterTableView.Caption = sHdr

    End If
  End Sub

  Protected Sub rgCharge_DataBound(sender As Object, e As System.EventArgs) Handles rgCharge.DataBound
    If True Then 'RadioButtonList1.SelectedValue = "Expanded" Then
      'Expand all items using our custom storage
      Dim indexes As String() = New String(Me.ExpandedStates.Keys.Count - 1) {}
      Me.ExpandedStates.Keys.CopyTo(indexes, 0)

      Dim arr As New ArrayList(indexes)
      'Sort so we can guarantee that a parent item is expanded before any of 
      'its children
      arr.Sort()

      Try
        For Each key As String In arr
          Dim value As Boolean = CBool(Me.ExpandedStates(key))
          If value Then
            rgCharge.Items(key).Expanded = True
          End If
        Next
      Catch ex As Exception

      End Try

    End If
  End Sub

  Protected Sub rgCharge_NeedDataSource(sender As Object, e As Telerik.Web.UI.GridNeedDataSourceEventArgs) Handles rgCharge.NeedDataSource
    If Not e.IsFromDetailTable Then
      Dim sSQL As String = "", sWhereCom As String = "", sWhereDates As String = ""
      If Session("has_sub_companies") = "Y" Then
        sWhereCom = " in (Select company_id from subscriber where parent_company_id = " & Session("company_rid") & ") "
      Else
        sWhereCom = " = " & Session("company_rid") & " "
      End If
      sWhereDates = " between '" & rdpFromDate.DbSelectedDate & " 00:00:00' and '" & rdpToDate.DbSelectedDate & " 23:59:59'"
      'sWhereDates = " between '9/1/2012 00:00:00' and '9/30/2012 23:59:59' "

            sSQL = "Select company_id, sub.name as office_name, 'UCC1' as 'typ', SUM(isnull(uf_charge,0)) as charge " & _
              "from ucc_financing inner join subscriber sub on uf_company_id = sub.company_id " & _
              "where uf_company_id " & sWhereCom & " and uf_date_submitted " & sWhereDates & ""
            If ddlLoanType.SelectedIndex <> 0 Then
                sSQL = sSQL + " and uf_loan_type = '" & ddlLoanType.SelectedValue & "'"
            End If
            sSQL += " group by company_id, sub.name " & _
        "union all " & _
        "Select company_id, sub.name as office_name, 'UCC3' as 'typ', SUM(isnull(u3_charge,0)) as charge " & _
        "from ucc3 inner join subscriber sub on u3_company_id = sub.company_id " & _
        "where u3_company_id " & sWhereCom & " and u3_date_submitted " & sWhereDates & ""
            If ddlLoanType.SelectedIndex <> 0 Then
                sSQL = sSQL + " and u3_loan_type = '" & ddlLoanType.SelectedValue & "'"
            End If
            sSQL += " group by company_id, sub.name " & _
        "union all " & _
        "Select company_id, sub.name as office_name, 'UCC11' as 'typ', SUM(isnull(us_charge,0)) as charge " & _
        "from ucc_search inner join subscriber sub on us_company_id = sub.company_id " & _
        "where us_company_id " & sWhereCom & " and us_date_submitted " & sWhereDates & ""
            If ddlLoanType.SelectedIndex <> 0 Then
                sSQL = sSQL + " and us_loan_type = '" & ddlLoanType.SelectedValue & "'"
            End If
            sSQL += " group by company_id, sub.name " & _
        "union all " & _
        "Select company_id, sub.name as office_name, 'UCC11_result' as 'typ', SUM(isnull(ur_charge,0)) as charge " & _
        "from ucc_results inner join ucc_search on ur_us_id = us_id " & _
        " inner join subscriber sub on us_company_id = sub.company_id " & _
        "where us_company_id " & sWhereCom & " and ur_date_entered " & sWhereDates & ""
            If ddlLoanType.SelectedIndex <> 0 Then
                sSQL += " and ur_loan_type = '" & ddlLoanType.SelectedValue & "'"
            End If
            sSQL += " group by company_id, sub.name "

      rgCharge.DataSource = FillDataTable(sSQL)
    End If
  End Sub

  Protected Sub rgCharge_DetailTableDataBind(sender As Object, e As Telerik.Web.UI.GridDetailTableDataBindEventArgs) Handles rgCharge.DetailTableDataBind
    Dim dataItem As GridDataItem = CType(e.DetailTableView.ParentItem, GridDataItem)
    Select e.DetailTableView.Name
      Case "Charges"
        Dim sType As String = dataItem.GetDataKeyValue("typ").ToString()
        Dim sComID As String = dataItem.GetDataKeyValue("company_id").ToString
        Dim sSQL As String = "", sWhereCom As String = "", sWhereDates As String = ""
        If Session("has_sub_companies") = "Y" Then
          'sWhereCom = " in (Select company_id from subscriber where parent_company_id = " & Session("company_rid") & ") "
        Else
          'sWhereCom = " = " & Session("company_rid") & " "
        End If
        sWhereCom = " = " & sComID
        sWhereDates = " between '" & rdpFromDate.DbSelectedDate & " 00:00:00' and '" & rdpToDate.DbSelectedDate & " 23:59:59'"
        'sWhereDates = " between '9/1/2012 00:00:00' and '9/30/2012 23:59:59' "

        Select Case sType
                    Case "UCC1"
                        sSQL = "Select uf_id as id, case when isnull(ud1.ud_org_name,'') <> '' then ud1.ud_org_name  else isnull(ud1.ud_ind_first_name,'') + ' ' + isnull(ud1.ud_ind_middle_name,'') + ' ' + isnull(ud1.ud_ind_last_name,'') + ' ' + isnull(ud1.ud_ind_suffix,'') end as 'name', " & _
                          "uf_date_submitted as date_submitted, uf_charge as charge, uf_loan_type as loan " & _
                          "from ucc_financing inner join ucc_debtor ud1 on uf_debtor1 = ud1.ud_id " & _
                          "where uf_company_id " & sWhereCom & " and uf_date_submitted " & sWhereDates & ""
                        If ddlLoanType.SelectedIndex <> 0 Then
                            sSQL = sSQL + " and uf_loan_type = '" & ddlLoanType.SelectedValue & "'"
                        End If
                    Case "UCC3"
                        sSQL = "Select u3_id as id, case when isnull(u3_old_org_name,'') <> '' then u3_old_org_name  " & _
                          " else isnull(u3_old_ind_first_name,'') + ' ' + isnull(u3_old_ind_middle_name,'') + ' ' + isnull(u3_old_ind_last_name,'') + ' ' + isnull(u3_old_ind_suffix,'') end as 'name', " & _
                          "u3_date_submitted as date_submitted, u3_charge as charge, u3_loan_type as loan " & _
                          "from ucc3 " & _
                          "where u3_company_id " & sWhereCom & " and u3_date_submitted " & sWhereDates & ""
                        If ddlLoanType.SelectedIndex <> 0 Then
                            sSQL = sSQL + " and u3_loan_type = '" & ddlLoanType.SelectedValue & "'"
                        End If
                    Case "UCC11"
                        sSQL = "Select us_id as id, case when isnull(ud1.ud_org_name,'') <> '' then ud1.ud_org_name  else isnull(ud1.ud_ind_first_name,'') + ' ' + isnull(ud1.ud_ind_middle_name,'') + ' ' + isnull(ud1.ud_ind_last_name,'') + ' ' + isnull(ud1.ud_ind_suffix,'') end as 'name', " & _
                          "us_date_submitted as date_submitted, us_charge as charge, us_loan_type as loan " & _
                          "from ucc_search inner join ucc_debtor as ud1 on us_debtor = ud1.ud_id " & _
                          "where us_company_id " & sWhereCom & " and us_date_submitted " & sWhereDates & ""
                        If ddlLoanType.SelectedIndex <> 0 Then
                            sSQL = sSQL + " and us_loan_type = '" & ddlLoanType.SelectedValue & "'"
                        End If
          Case "UCC11_result"
            sSQL = "Select ur_id as id, case when isnull(ud1.ud_org_name,'') <> '' then ud1.ud_org_name  else isnull(ud1.ud_ind_first_name,'') + ' ' + isnull(ud1.ud_ind_middle_name,'') + ' ' + isnull(ud1.ud_ind_last_name,'') + ' ' + isnull(ud1.ud_ind_suffix,'') end as 'name', " & _
              "ur_date_entered as date_submitted, ur_charge as charge " & _
              "from ucc_results inner join ucc_search on ur_us_id = us_id " & _
              "inner join ucc_debtor as ud1 on us_debtor = ud1.ud_id " & _
              "where us_company_id " & sWhereCom & " and ur_date_entered " & sWhereDates
        End Select

        e.DetailTableView.DataSource = FillDataTable(sSQL)

    End Select
    
  End Sub

  Protected Sub btnSearch_Click(sender As Object, e As System.EventArgs) Handles btnSearch.Click
    Dim sHdr As String = "Identi-Check Inc.<br />" & _
        "Charges from " & CDate(rdpFromDate.SelectedDate).ToShortDateString & "  to  " & CDate(rdpToDate.SelectedDate).ToShortDateString
    lblHdr.Text = sHdr
    rgCharge.MasterTableView.Caption = sHdr
    rgCharge.Rebind()
  End Sub

  'Save/load expanded states Hash from the session
  'this can also be implemented in the ViewState
  Private ReadOnly Property ExpandedStates() As Hashtable
    Get
      If Me._ordersExpandedState Is Nothing Then
        _ordersExpandedState = TryCast(Me.Session("_ordersExpandedState"), Hashtable)
        If _ordersExpandedState Is Nothing Then
          _ordersExpandedState = New Hashtable()
          Me.Session("_ordersExpandedState") = _ordersExpandedState
        End If
      End If

      Return Me._ordersExpandedState
    End Get
  End Property

  'Clear the state for all expanded children if a parent item is collapsed
  Private Sub ClearExpandedChildren(ByVal parentHierarchicalIndex As String)
    Dim indexes As String() = New String(Me.ExpandedStates.Keys.Count - 1) {}
    Me.ExpandedStates.Keys.CopyTo(indexes, 0)
    For Each index As String In indexes
      'all indexes of child items
      If index.StartsWith(parentHierarchicalIndex + "_") OrElse index.StartsWith(parentHierarchicalIndex + ":") Then
        Me.ExpandedStates.Remove(index)
      End If
    Next
  End Sub

  Protected Sub rgCharge_ItemCommand(sender As Object, e As Telerik.Web.UI.GridCommandEventArgs) Handles rgCharge.ItemCommand
    If e.CommandName.Contains("Export") Then
      isExport = True
      If True Then 'RadioButtonList1.SelectedValue = "All" Then
        rgCharge.MasterTableView.HierarchyDefaultExpanded = True 'for the first level
        rgCharge.MasterTableView.DetailTables(0).HierarchyDefaultExpanded = True ' for the second level 

        'rgCharge.MasterTableView.GetColumn("RID").Visible = False
        'rgCharge.MasterTableView.GetColumn("RIDPDF").Visible = False

        'rgCharge.MasterTableView.GetColumn("chkboxTransfer").Visible = False
        'rgCharge.MasterTableView.GetColumn("chkboxCancel").Visible = False
        'rgCharge.MasterTableView.GetColumn("chkboxFile").Visible = False
      End If
    End If

    'save the expanded/selected state in the session
    If e.CommandName = RadGrid.ExpandCollapseCommandName Then
      'Is the item about to be expanded or collapsed
      If Not e.Item.Expanded Then
        'Save its unique index among all the items in the hierarchy
        Me.ExpandedStates(e.Item.ItemIndexHierarchical) = True
      Else
        'collapsed
        Me.ExpandedStates.Remove(e.Item.ItemIndexHierarchical)
        Me.ClearExpandedChildren(e.Item.ItemIndexHierarchical)
      End If
    End If
  End Sub

  Protected Sub rgCharge_ItemCreated(sender As Object, e As Telerik.Web.UI.GridItemEventArgs) Handles rgCharge.ItemCreated
    If isExport Then
      If TypeOf e.Item Is GridHeaderItem Then
        Select Case e.Item.OwnerTableView.Name
          Case "Main"
            e.Item.OwnerTableView.BackColor = System.Drawing.Color.LightGray
            Exit Select
          Case "Charges"
            e.Item.OwnerTableView.BackColor = System.Drawing.Color.Gray
            Exit Select
            'Case "OrderDetails"
            '  e.Item.OwnerTableView.BackColor = System.Drawing.Color.DarkGray
            '  Exit Select
        End Select
      End If
    End If
  End Sub

  Protected Sub rgCharge_PdfExporting(sender As Object, e As Telerik.Web.UI.GridPdfExportingArgs) Handles rgCharge.PdfExporting
    Dim sHdr As String = lblHdr.Text
    e.RawHTML = sHdr + e.RawHTML
  End Sub
End Class
