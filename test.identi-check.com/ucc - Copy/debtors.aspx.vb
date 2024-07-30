Imports Telerik.Web.UI

Partial Class debtors
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

    End If
  End Sub

  Protected Sub rgD_DataBound(sender As Object, e As System.EventArgs) Handles rgD.DataBound
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
            rgD.Items(key).Expanded = True
          End If
        Next
      Catch ex As Exception

      End Try

    End If

  End Sub

  Protected Sub rgD_NeedDataSource(sender As Object, e As Telerik.Web.UI.GridNeedDataSourceEventArgs) Handles rgD.NeedDataSource
    Dim sSQL As String
    If Not e.IsFromDetailTable Then
      '"--Select 'UCC1ad' as 'Doc', ufad_id as id From ucc_financing_ad " & _
      '"--Select 'UCC1ap' as 'Doc', ufap_id as id From ucc_financing_ap " & _
      '"--Select 'UCC3ad' as 'Doc', u3ad_id as id from ucc3_ad " & _
      sSQL = "Select *,  " & _
         "case when isnull(ud_org_name,'') <> '' then ud_org_name  " & _
         " else isnull(ud_ind_first_name,'') + ' ' + isnull(ud_ind_middle_name,'') + ' ' + isnull(ud_ind_last_name,'') + ' ' + isnull(ud_ind_suffix,'') end as 'name' " & _
         "From ucc_debtor "
      rgD.DataSource = FillDataTable(sSQL)
    End If
  End Sub

  Private Sub rgD_DetailTableDataBind(ByVal source As Object, ByVal e As GridDetailTableDataBindEventArgs) Handles rgD.DetailTableDataBind
    Dim dataItem As GridDataItem = CType(e.DetailTableView.ParentItem, GridDataItem)
    Select Case e.DetailTableView.Name
      Case "FilingSearches"
        Dim ID As String = dataItem.GetDataKeyValue("ud_id").ToString()
        Dim sSQL As String = "Select 'UCC1' as 'Doc', uf_id as id,  " & _
           "case when isnull(ud1.ud_org_name,'') <> '' then ud1.ud_org_name  " & _
           " else isnull(ud1.ud_ind_first_name,'') + ' ' + isnull(ud1.ud_ind_middle_name,'') + ' ' + isnull(ud1.ud_ind_last_name,'') + ' ' + isnull(ud1.ud_ind_suffix,'') end as 'name', " & _
           "case when ISNULL(ufad_id,'') <> '' then ufad_id else '' end as 'ad_id', " & _
           "case when ISNULL(ufap_id,'') <> '' then ufap_id else '' end as 'ap_id',uf_date_submitted as 'date_submitted' " & _
           "From ucc_financing inner join ucc_debtor as ud1 on uf_debtor1 = ud1.ud_id and ud1.ud_id = " & ID & _
           "left outer join ucc_financing_ad on ufad_uf_id = uf_id " & _
           "left outer join ucc_financing_ap on ufap_uf_id = uf_id " & _
           "union all " & _
           "Select 'UCC11' as 'Doc', us_id as id, " & _
           "case when isnull(ud1.ud_org_name,'') <> '' then ud1.ud_org_name  " & _
           " else isnull(ud1.ud_ind_first_name,'') + ' ' + isnull(ud1.ud_ind_middle_name,'') + ' ' + isnull(ud1.ud_ind_last_name,'') + ' ' + isnull(ud1.ud_ind_suffix,'') end as 'name', " & _
           "'' as 'ad_id', '' as 'ap_id',us_date_submitted as 'date_submitted' " & _
           "From ucc_search inner join ucc_debtor as ud1 on us_debtor = ud1.ud_id and ud1.ud_id = " & ID
        e.DetailTableView.DataSource = FillDataTable(sSQL)
        'Case "OrderDetails"
        '  Dim OrderID As String = dataItem.GetDataKeyValue("OrderID").ToString()
        '  e.DetailTableView.DataSource = FillDataTable("SELECT * FROM [Order Details] WHERE OrderID = " & OrderID)
    End Select
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
        If sAD_ID <> "0" Or sAP_ID <> "0" Then
          sRtn = sRtn & "&nbsp;<a href='View_UCC1.aspx?view=all&id=" & sID & "' target='_blank'>All</a>"
        End If
      Case "UCC3"
        sRtn = "<a href='View_UCC3.aspx?id=" & sID & "' target='_blank'>PDF</a>"
        If sAD_ID <> "" And sAD_ID <> "0" Then
          sRtn = sRtn & "&nbsp;<a href='View_UCC3ad.aspx?id=" & sAD_ID & "' target='_blank'>AD</a>"
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

  Protected Sub rgD_ItemCommand(sender As Object, e As Telerik.Web.UI.GridCommandEventArgs) Handles rgD.ItemCommand
    'If e.CommandName = "FilterRadGrid" Then
    '  RadFilter1.FireApplyCommand()
    'ElseIf e.CommandName.Contains("Export") Then
    '  isExport = True
    '  If True Then 'RadioButtonList1.SelectedValue = "All" Then
    '    rgD.MasterTableView.HierarchyDefaultExpanded = True 'for the first level
    '    rgD.MasterTableView.DetailTables(0).HierarchyDefaultExpanded = True ' for the second level 

    '    rgD.MasterTableView.GetColumn("RID").Visible = False
    '    rgD.MasterTableView.GetColumn("RIDPDF").Visible = False

    '    rgD.MasterTableView.GetColumn("chkboxTransfer").Visible = False
    '    rgD.MasterTableView.GetColumn("chkboxCancel").Visible = False
    '    rgD.MasterTableView.GetColumn("chkboxFile").Visible = False
    '  End If
    'End If

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

  Protected Sub rgD_ItemCreated(sender As Object, e As Telerik.Web.UI.GridItemEventArgs) Handles rgD.ItemCreated
    'If isExport Then
    '  If TypeOf e.Item Is GridHeaderItem Then
    '    Select Case e.Item.OwnerTableView.Name
    '      Case "CCSEWR_Receipt"
    '        e.Item.OwnerTableView.BackColor = System.Drawing.Color.LightGray
    '        Exit Select
    '      Case "Commodities"
    '        e.Item.OwnerTableView.BackColor = System.Drawing.Color.Gray
    '        Exit Select
    '        'Case "OrderDetails"
    '        '  e.Item.OwnerTableView.BackColor = System.Drawing.Color.DarkGray
    '        '  Exit Select
    '    End Select
    '  End If
    'End If
  End Sub
End Class
