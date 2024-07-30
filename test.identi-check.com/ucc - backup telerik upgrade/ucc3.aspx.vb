Imports System.Data.SqlClient
Imports Telerik.Web.UI

Partial Class ucc3
  Inherits System.Web.UI.Page

  Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
    If Not Page.IsPostBack Then
      Dim myMaster As MainMaster = CType(MyBase.Master, MainMaster)

      myMaster.Testing()
      myMaster.SetWelcomeName(Session("name"))

      lstDebtor1_State.DataSource = FillDataTable("Select * From state_list order by state_name")
      lstDebtor1_State.DataTextField = "STATE_ABBR"
      lstDebtor1_State.DataValueField = "STATE_ABBR"
      lstDebtor1_State.DataBind()

      lstOrg_State.DataSource = FillDataTable("Select * From state_list order by state_name")
      lstOrg_State.DataTextField = "STATE_ABBR"
      lstOrg_State.DataValueField = "STATE_ABBR"
      lstOrg_State.DataBind()

      Try
        lstDebtor1_State.SelectedIndex = -1
        lstDebtor1_State.Items.FindByValue("IL").Selected = True
        lstOrg_State.SelectedIndex = -1
        lstOrg_State.Items.FindByValue("IL").Selected = True
      Catch ex As Exception

      End Try

      lstDebtor2_State.DataSource = lstDebtor1_State.Items
      lstDebtor2_State.DataBind()
      Try
        lstDebtor2_State.SelectedIndex = -1
        lstDebtor2_State.Items.FindByValue("IL").Selected = True
      Catch ex As Exception

      End Try

      lstDebtor3_State.DataSource = lstDebtor1_State.Items
      lstDebtor3_State.DataBind()
      Try
        lstDebtor3_State.SelectedIndex = -1
        lstDebtor3_State.Items.FindByValue("IL").Selected = True
      Catch ex As Exception

      End Try

      lstDebtor4_State.DataSource = lstDebtor1_State.Items
      lstDebtor4_State.DataBind()
      Try
        lstDebtor4_State.SelectedIndex = -1
        lstDebtor4_State.Items.FindByValue("IL").Selected = True
      Catch ex As Exception

      End Try

      lstDebtor1_Org_Jurisdiction.DataSource = lstDebtor1_State.Items
      lstDebtor1_Org_Jurisdiction.DataBind()
      Try
        lstDebtor1_Org_Jurisdiction.SelectedIndex = -1
        lstDebtor1_Org_Jurisdiction.Items.FindByValue("IL").Selected = True
      Catch ex As Exception

      End Try

      lstDebtor2_Org_Jurisdiction.DataSource = lstDebtor1_State.Items
      lstDebtor2_Org_Jurisdiction.DataBind()
      Try
        lstDebtor2_Org_Jurisdiction.SelectedIndex = -1
        lstDebtor2_Org_Jurisdiction.Items.FindByValue("IL").Selected = True
      Catch ex As Exception

      End Try

      lstDebtor3_Org_Jurisdiction.DataSource = lstDebtor1_State.Items
      lstDebtor3_Org_Jurisdiction.DataBind()
      Try
        lstDebtor3_Org_Jurisdiction.SelectedIndex = -1
        lstDebtor3_Org_Jurisdiction.Items.FindByValue("IL").Selected = True
      Catch ex As Exception

      End Try

      lstDebtor4_Org_Jurisdiction.DataSource = lstDebtor1_State.Items
      lstDebtor4_Org_Jurisdiction.DataBind()
      Try
        lstDebtor4_Org_Jurisdiction.SelectedIndex = -1
        lstDebtor4_Org_Jurisdiction.Items.FindByValue("IL").Selected = True
      Catch ex As Exception

      End Try

      lstSecured2_State.DataSource = lstDebtor1_State.Items
      lstSecured2_State.DataBind()
      Try
        lstSecured2_State.SelectedIndex = -1
        lstSecured2_State.Items.FindByValue("IL").Selected = True
      Catch ex As Exception

      End Try

      lstSecured3_State.DataSource = lstDebtor1_State.Items
      lstSecured3_State.DataBind()
      Try
        lstSecured3_State.SelectedIndex = -1
        lstSecured3_State.Items.FindByValue("IL").Selected = True
      Catch ex As Exception

      End Try

      lstSecured_Org_Name.Items.Add(New ListItem("Choose Org Name", ""))
      lstSecured_Org_Name.Items.Add(New ListItem("COMMODITY CREDIT CORPORATION", "COMMODITY CREDIT CORPORATION"))
      lstSecured_Org_Name.Items.Add(New ListItem("UNITED STATES OF AMERICA ACTING THROUGH FARM SERVICE AGENCY", "UNITED STATES OF AMERICA ACTING THROUGH FARM SERVICE AGENCY"))

      lstSecured2_Org_Name.DataSource = lstSecured_Org_Name.Items
      lstSecured2_Org_Name.DataBind()

      lstSecured3_Org_Name.DataSource = lstSecured_Org_Name.Items
      lstSecured3_Org_Name.DataBind()

      'Dim enumValues As Array = System.[Enum].GetValues(GetType(SOS_XML.OrgType))
      'lstDebtor1_Org_Type.Items.Add(New ListItem("Choose Org Type", ""))
      'For Each item As SOS_XML.OrgType In enumValues
      '  lstDebtor1_Org_Type.Items.Add(New ListItem(item.ToString(), item.ToString()))
      'Next
      'lstDebtor2_Org_Type.DataSource = lstDebtor1_Org_Type.Items
      'lstDebtor2_Org_Type.DataBind()
      'lstDebtor3_Org_Type.DataSource = lstDebtor1_Org_Type.Items
      'lstDebtor3_Org_Type.DataBind()
      'lstDebtor4_Org_Type.DataSource = lstDebtor1_Org_Type.Items
      'lstDebtor4_Org_Type.DataBind()

      'Me.txtCollateral.Attributes.Add("onkeyup", "return textboxMultilineMaxNumber(this,1200);")
      'Me.txtCollateral.Attributes.Add("onkeydown", "return textboxMultilineMaxNumber(this,1200);")

      If Request.QueryString("id") <> "" Then
        'load values from ucc1
        Dim sSQL As String = "Select uf.*,  " & _
          "ud1.ud_id as ud1_id,ud1.ud_org_name as ud1_org_name,ud1.ud_ind_last_name as ud1_ind_last_name,ud1.ud_ind_first_name as ud1_ind_first_name,ud1.ud_ind_middle_name as ud1_ind_middle_name,ud1.ud_ind_suffix as ud1_ind_suffix,ud1.ud_mailing_address as ud1_mailing_address,ud1.ud_city as ud1_city,ud1.ud_state as ud1_state,ud1.ud_zipcode as ud1_zipcode,ud1.ud_country as ud1_country,ud1.ud_d1 as ud1_d1,ud1.ud_org_type as ud1_org_type,ud1.ud_org_jurisdiction as ud1_org_jurisdiction,ud1.ud_org_id as ud1_org_id,ud1.ud_org_id_none as ud1_org_id_none " & _
          "from ucc_financing as uf left outer join ucc_debtor as ud1 on uf.uf_debtor1 = ud1.ud_id " & _
          "where uf_id = " & Request.QueryString("id")
        Dim dtUF As DataTable = FillDataTable(sSQL)
        If dtUF.Rows.Count > 0 Then
          txtInitial_file_No.Text = dtUF.Rows(0).Item("uf_file_no") & ""
          txtOrig_Org_Name.Text = dtUF.Rows(0).Item("ud1_org_name") & ""
          txtOrig_Ind_First_Name.Text = dtUF.Rows(0).Item("ud1_ind_first_name") & ""
          txtOrig_Ind_Middle_Name.Text = dtUF.Rows(0).Item("ud1_ind_middle_name") & ""
          txtOrig_Ind_Last_Name.Text = dtUF.Rows(0).Item("ud1_ind_last_name") & ""
          txtOrig_Ind_Suffix.Text = dtUF.Rows(0).Item("ud1_ind_suffix") & ""
          Try
            lstSecured_Org_Name.SelectedIndex = -1
            lstSecured_Org_Name.Items.FindByValue(dtUF.Rows(0).Item("uf_secured_org_name") & "").Selected = True
          Catch ex As Exception

          End Try
        Else
          'error
        End If
        dtUF.Dispose()
        dtUF = Nothing
      End If
    End If
  End Sub

  Private Shared Function GetStatusMessage(ByVal offset As Integer, ByVal total As Integer) As String
    If total <= 0 Then
      Return "No matches"
    End If

    Return [String].Format("Items <b>1</b>-<b>{0}</b> out of <b>{1}</b>", offset, total)
  End Function

  Private Shared Function GetData(ByVal text As String, ByVal sFrom As String) As DataTable
    Dim sSQL As String = "Select ud_id, isnull(ud_org_name,'') + ' - ' + isnull(ud_ind_first_name,'') + ' ' + isnull(ud_ind_middle_name,'') + ' ' + isnull(ud_ind_last_name,'') as 'disp_name', " & _
        "ud_id as 'key_name' From ucc_debtor " & _
        "where isnull(ud_ind_first_name,'') + ' ' + isnull(ud_ind_middle_name,'') + ' ' + isnull(ud_ind_last_name,'') like '%' + @text + '%' or " & _
        " isnull(ud_org_name,'') like '%' + @text + '%' " & _
        "order by ud_org_name, ud_ind_last_name, ud_ind_first_name"

    Dim adapter As New SqlDataAdapter(sSQL, CNNStr)
    adapter.SelectCommand.Parameters.AddWithValue("@text", text)

    Dim data As New DataTable()
    adapter.Fill(data)

    Return data
  End Function

  Private Const ItemsPerRequest As Integer = 50

  Protected Sub rcbNewDebtor_ItemsRequested(sender As Object, e As Telerik.Web.UI.RadComboBoxItemsRequestedEventArgs)
    If e.Text.Length > 2 Then
      Dim data As DataTable = GetData(e.Text, "")

      Dim itemOffset As Integer = e.NumberOfItems
      Dim endOffset As Integer = Math.Min(itemOffset + ItemsPerRequest, data.Rows.Count)
      e.EndOfItems = endOffset = data.Rows.Count

      For i As Integer = itemOffset To endOffset - 1
        rcbNew_Debtor.Items.Add(New Telerik.Web.UI.RadComboBoxItem(data.Rows(i)("disp_name").ToString(), data.Rows(i)("key_name").ToString()))
      Next

      e.Message = GetStatusMessage(endOffset, data.Rows.Count)
    End If
  End Sub

  Protected Sub rcbDebtor2_ItemsRequested(ByVal o As Object, ByVal e As Telerik.Web.UI.RadComboBoxItemsRequestedEventArgs)
    If e.Text.Length > 2 Then
      Dim data As DataTable = GetData(e.Text, "")

      Dim itemOffset As Integer = e.NumberOfItems
      Dim endOffset As Integer = Math.Min(itemOffset + ItemsPerRequest, data.Rows.Count)
      e.EndOfItems = endOffset = data.Rows.Count

      For i As Integer = itemOffset To endOffset - 1
        rcbDebtor2.Items.Add(New Telerik.Web.UI.RadComboBoxItem(data.Rows(i)("disp_name").ToString(), data.Rows(i)("key_name").ToString()))
      Next

      e.Message = GetStatusMessage(endOffset, data.Rows.Count)
    End If
  End Sub

  Protected Sub rcbDebtor3_ItemsRequested(ByVal o As Object, ByVal e As Telerik.Web.UI.RadComboBoxItemsRequestedEventArgs)
    If e.Text.Length > 2 Then
      Dim data As DataTable = GetData(e.Text, "")

      Dim itemOffset As Integer = e.NumberOfItems
      Dim endOffset As Integer = Math.Min(itemOffset + ItemsPerRequest, data.Rows.Count)
      e.EndOfItems = endOffset = data.Rows.Count

      For i As Integer = itemOffset To endOffset - 1
        rcbDebtor3.Items.Add(New Telerik.Web.UI.RadComboBoxItem(data.Rows(i)("disp_name").ToString(), data.Rows(i)("key_name").ToString()))
      Next

      e.Message = GetStatusMessage(endOffset, data.Rows.Count)
    End If
  End Sub

  Protected Sub rcbDebtor4_ItemsRequested(ByVal o As Object, ByVal e As Telerik.Web.UI.RadComboBoxItemsRequestedEventArgs)
    If e.Text.Length > 2 Then
      Dim data As DataTable = GetData(e.Text, "")

      Dim itemOffset As Integer = e.NumberOfItems
      Dim endOffset As Integer = Math.Min(itemOffset + ItemsPerRequest, data.Rows.Count)
      e.EndOfItems = endOffset = data.Rows.Count

      For i As Integer = itemOffset To endOffset - 1
        rcbDebtor4.Items.Add(New Telerik.Web.UI.RadComboBoxItem(data.Rows(i)("disp_name").ToString(), data.Rows(i)("key_name").ToString()))
      Next

      e.Message = GetStatusMessage(endOffset, data.Rows.Count)
    End If
  End Sub

  Protected Sub rcbNew_Debtor_SelectedIndexChanged(sender As Object, e As Telerik.Web.UI.RadComboBoxSelectedIndexChangedEventArgs) Handles rcbNew_Debtor.SelectedIndexChanged
    'fill in debtor info, lock fields?
    Dim tmpTextA As New TextBox, tmpTextB As New TextBox
    'tmpTextA.Text = lstDebtor1_Org_Type.SelectedValue
    'tmpTextB.Text = lstDebtor1_Org_Jurisdiction.SelectedValue
    FillDebtorInfo(rcbNew_Debtor.SelectedValue, Session("company_rid"), txtDebtor1_Org_Name, txtDebtor1_Ind_Last_Name, txtDebtor1_Ind_First_Name, txtDebtor1_Ind_Middle_Name, txtDebtor1_Ind_Suffix, txtDebtor1_Mailing_Address, txtDebtor1_City, lstDebtor1_State, txtDebtor1_Zip, txtDebtor1_Country, txtDebtor1_d1, tmpTextA, tmpTextB, txtDebtor1_Org_ID, chkDebtor1_Org_ID_None)
    'Try
    '  lstDebtor1_Org_Type.SelectedIndex = -1
    '  lstDebtor1_Org_Type.Items.FindByValue(tmpTextA.Text).Selected = True
    'Catch ex As Exception

    'End Try
    'Try
    '  lstDebtor1_Org_Jurisdiction.SelectedIndex = -1
    '  lstDebtor1_Org_Jurisdiction.Items.FindByValue(tmpTextB.Text).Selected = True
    'Catch ex As Exception

    'End Try
  End Sub

  Protected Sub rcbDebtor2_SelectedIndexChanged(sender As Object, e As Telerik.Web.UI.RadComboBoxSelectedIndexChangedEventArgs) Handles rcbDebtor2.SelectedIndexChanged
    'fill in debtor info, lock fields?
    Dim tmpTextA As New TextBox, tmpTextB As New TextBox
    tmpTextA.Text = lstDebtor2_Org_Type.SelectedValue
    tmpTextB.Text = lstDebtor2_Org_Jurisdiction.SelectedValue
    FillDebtorInfo(rcbDebtor2.SelectedValue, Session("company_rid"), txtDebtor2_Org_Name, txtDebtor2_Ind_Last_Name, txtDebtor2_Ind_First_Name, txtDebtor2_Ind_Middle_Name, txtDebtor2_Ind_Suffix, txtDebtor2_Mailing_Address, txtDebtor2_City, lstDebtor2_State, txtDebtor2_Zip, txtDebtor2_Country, txtDebtor2_d1, tmpTextA, tmpTextB, txtDebtor2_Org_ID, chkDebtor2_Org_ID_None)
  End Sub

  Protected Sub rcbDebtor3_SelectedIndexChanged(sender As Object, e As Telerik.Web.UI.RadComboBoxSelectedIndexChangedEventArgs) Handles rcbDebtor3.SelectedIndexChanged
    'fill in debtor info, lock fields?
    Dim tmpTextA As New TextBox, tmpTextB As New TextBox
    'tmpTextA.Text = lstDebtor3_Org_Type.SelectedValue
    'tmpTextB.Text = lstDebtor3_Org_Jurisdiction.SelectedValue
    FillDebtorInfo(rcbDebtor3.SelectedValue, Session("company_rid"), txtDebtor3_Org_Name, txtDebtor3_Ind_Last_Name, txtDebtor3_Ind_First_Name, txtDebtor3_Ind_Middle_Name, txtDebtor3_Ind_Suffix, txtDebtor3_Mailing_Address, txtDebtor3_City, lstDebtor3_State, txtDebtor3_Zip, txtDebtor3_Country, txtDebtor3_d1, tmpTextA, tmpTextB, txtDebtor3_Org_ID, chkDebtor3_Org_ID_None)
  End Sub

  Protected Sub rcbDebtor4_SelectedIndexChanged(sender As Object, e As Telerik.Web.UI.RadComboBoxSelectedIndexChangedEventArgs) Handles rcbDebtor4.SelectedIndexChanged
    'fill in debtor info, lock fields?
    Dim tmpTextA As New TextBox, tmpTextB As New TextBox
    'tmpTextA.Text = lstDebtor4_Org_Type.SelectedValue
    'tmpTextB.Text = lstDebtor4_Org_Jurisdiction.SelectedValue
    FillDebtorInfo(rcbDebtor4.SelectedValue, Session("company_rid"), txtDebtor4_Org_Name, txtDebtor4_Ind_Last_Name, txtDebtor4_Ind_First_Name, txtDebtor4_Ind_Middle_Name, txtDebtor4_Ind_Suffix, txtDebtor4_Mailing_Address, txtDebtor4_City, lstDebtor4_State, txtDebtor4_Zip, txtDebtor4_Country, txtDebtor4_d1, tmpTextA, tmpTextB, txtDebtor4_Org_ID, chkDebtor4_Org_ID_None)
  End Sub

  Protected Sub chkShowUCC3ad_CheckedChanged(sender As Object, e As System.EventArgs) Handles chkShowUCC3ad.CheckedChanged
    If chkShowUCC3ad.Checked Then
      pnlUCC3ad.Visible = True
    Else
      pnlUCC3ad.Visible = False
    End If
  End Sub

  Protected Sub chkShowUCC3ap_CheckedChanged(sender As Object, e As System.EventArgs) Handles chkShowUCC3ap.CheckedChanged
    If chkShowUCC3ap.Checked Then
      pnlUCC3ap.Visible = True
    Else
      pnlUCC3ap.Visible = False
    End If
  End Sub

  Protected Sub btnSubmit_Click(sender As Object, e As System.EventArgs) Handles btnSubmit.Click
    Dim sSQL As String = ""
    Dim sMsg As String = ""
    Dim sNew_Debtor As String = "", sDebtor2 As String = "", sDebtor3 As String = "", sDebtor4 As String = ""
    Dim sUF_ID As String

    'check to make sure all reqd fields are there
    If lstSecured_Org_Name.SelectedValue = "" Then
      sMsg = sMsg & "You must provide the Secured Organization Name.<br />"
    End If
    If txtInitial_file_No.Text = "" Then
      sMsg = sMsg & "You must provide the Initial Financing Statement File #.<br />"
    End If
    If txtInitialName.Text.Trim = "" Then
      'u3_initial_name
      sMsg = sMsg & "You must provide the Initial Organization/Individual Name.<br />"
    End If
    If ddlLoanType.SelectedValue = "0" Then
      sMsg = sMsg & "You must choose a Loan Type.<br />"
    End If
    If ddlLoanType.SelectedValue = "FSFL" And ddlFY.SelectedValue = "0" Then
      'u3_fsfl_fy
      sMsg = sMsg & "You must provide the Fiscal Year with FSFL Loans.<br />"
    End If

    'Illinois only allows one action and one change on an Amendment
    'Can do (Continuation or Termination or Assignment or ChangeTo (Debtor or Secured Party or Collateral))
    'Actions = DebtorAdd,DebtorChange,DebtorDelete,
    'SecuredPartyAdd,SecuredPartyChange,SecuredPartyDelete,
    'CollateralAdd,CollateralChange,CollateralDelete,CollateralRestate, CollateralAssign,
    'NOAction
    'AmendmentTypes = AmendmentCollateral, AmendmentParties
    'Assignment, Correct, Continuation, Correction
    'TerminationDebtor, TerminationSecuredParty
    'OfficerStatement, NOType

    Dim intAction As Integer = 0
    If chkTermination.Checked Then intAction += 1
    If chkContinuation.Checked Then intAction += 1
    If chkAssignment.Checked Then intAction += 1
    If chkPartyChange.Checked Then intAction += 1
    If chkCollateralChange.Checked Then intAction += 1
    If intAction > 1 Then
      sMsg = sMsg & "You can only perform one action per amendment. Choose either 2, 3, 4, 5 or 8.<br />"
    End If

    If sMsg <> "" Then
      '?where to display message
      lblMsg.Text = sMsg
      Exit Sub
    End If


    Dim bln6reqd As Boolean = False
    Dim bln7reqd As Boolean = False
    If chkTermination.Checked Then
      'only thing checked, make sure org (9a) is selected
      'ignore info in 6
    ElseIf chkContinuation.Checked Then
      'only thing checked, make sure org (9a) is selected
      'ignore info in 6
    ElseIf chkAssignment.Checked Then
      '?not applicable to fsa
      'changing secured party
      'give name of assignee in 7a or b and address in 7c
      bln7reqd = True
      'ignore info in 6
    ElseIf chkPartyChange.Checked Then
      'chkAmend_Debtor.Checked Or chkAmend_Secured_Party.Checked 
      'ANDr chkAmend_Add.Checked Or chkAmend_Change.Checked Or chkAmend_Delete.Checked
      'amendment
      If Not chkAmend_Debtor.Checked And Not chkAmend_Secured_Party.Checked Then
        sMsg = sMsg & "You must choose who the amendment affects, Debtor or Secured Party.<br />"
      ElseIf Not chkAmend_Add.Checked And Not chkAmend_Change.Checked And Not chkAmend_Delete.Checked Then
        sMsg = sMsg & "You must choose the type of amendment; Change, Delete or Add. <br />"
      Else
        If chkAmend_Debtor.Checked Then
          'provide old debtor in 6
          If chkAmend_Change.Checked Or chkAmend_Delete.Checked Then
            bln6reqd = True
          End If
          If chkAmend_Change.Checked Or chkAmend_Add.Checked Then
            bln7reqd = True
          End If
        ElseIf chkAmend_Secured_Party.Checked Then
          'provide old secured party in 6
          If chkAmend_Change.Checked Or chkAmend_Delete.Checked Then
            bln6reqd = True
          End If
          If chkAmend_Change.Checked Or chkAmend_Add.Checked Then
            bln7reqd = True
          End If
        ElseIf chkAmend_Delete.Checked Then
          'provide old debtor in 6 - should be prepopulated if clicked from UCC1
          If chkAmend_Change.Checked Or chkAmend_Delete.Checked Then
            bln6reqd = True
          End If
          If chkAmend_Change.Checked Or chkAmend_Add.Checked Then
            bln7reqd = True
          End If

        End If
      End If
    ElseIf chkCollateralChange.Checked Then
      'chkCollateral_Added.Checked Or chkCollateral_Assigned.Checked Or chkCollateral_Deleted.Checked Or chkCollateral_Restated.Checked Or chkContinuation.Checked
      If Not chkCollateral_Added.Checked And Not chkCollateral_Assigned.Checked And Not chkCollateral_Deleted.Checked And Not chkCollateral_Restated.Checked Then
        sMsg = sMsg & "You must indicate what action you are performing on the collateral.<br />"
      End If
      'collateral amendment - require collateral statement
      If txtCollateral.Text = "" Then
        sMsg = sMsg & "You must provide a collateral statement.<br />"
      End If
    ElseIf chkContinuation.Checked Then
      'Continuation - nothing more needed
    Else
      'nothing checked error
      sMsg = sMsg & "You must choose an action to perform.<br />"
    End If

    If bln6reqd Then
      If txtOrig_Ind_Last_Name.Text <> "" And txtOrig_Org_Name.Text <> "" Then
        sMsg = sMsg & "You may provide an Organization Name or Individual Name, but not both for section 6.<br />"
      ElseIf txtOrig_Ind_Last_Name.Text = "" And txtOrig_Ind_First_Name.Text = "" And txtOrig_Org_Name.Text = "" Then
        sMsg = sMsg & "You must provide an Organization Name or Individual Name for section 6.<br />"
      ElseIf txtOrig_Ind_Last_Name.Text <> "" And txtOrig_Ind_First_Name.Text = "" Then
        sMsg = sMsg & "You must provide a First Name for section 6.<br />"
      ElseIf txtOrig_Ind_Last_Name.Text = "" And txtOrig_Ind_First_Name.Text <> "" Then
        sMsg = sMsg & "You must provide a Last Name for section 6.<br />"
        'ElseIf txtOrig_Org_Name.Text <> "" Then
        '  If lstOrig_Org_Type.SelectedValue = "" Or lstOrig_Org_Jurisdiction.SelectedValue = "" Then
        '    sMsg = sMsg & "You must provide the Organization Type and Jurisdiction for section 6.<br />"
        '  End If
        '  If txtOrig_Org_I.Text = "" And chkOrig_Org_ID_None.Checked = False Then
        '    sMsg = sMsg & "You must provide the Organization ID or check None for section 6.<br />"
        '  End If
        'End If
        'If txtOrig_Mailing_Address.Text = "" Or txtOrig_City.Text = "" Or lstOrig_State.SelectedValue = "" Or txtOrig_Zip.Text = "" Then
        '  sMsg = sMsg & "You must provide an Mailing Address, City, State and Postal Code for section 6.<br />"
      End If
    End If

    If bln7reqd Then
      If txtDebtor1_Ind_Last_Name.Text <> "" And txtDebtor1_Org_Name.Text <> "" Then
        sMsg = sMsg & "You may provide an Organization Name or Individual Name, but not both for section 7.<br />"
      ElseIf txtDebtor1_Ind_Last_Name.Text = "" And txtDebtor1_Ind_First_Name.Text = "" And txtDebtor1_Org_Name.Text = "" Then
        sMsg = sMsg & "You must provide an Organization Name or Individual Name for section 7.<br />"
      ElseIf txtDebtor1_Ind_Last_Name.Text <> "" And txtDebtor1_Ind_First_Name.Text = "" Then
        sMsg = sMsg & "You must provide a First Name for section 7.<br />"
      ElseIf txtDebtor1_Ind_Last_Name.Text = "" And txtDebtor1_Ind_First_Name.Text <> "" Then
        sMsg = sMsg & "You must provide a Last Name for section 7.<br />"
        'ElseIf txtDebtor1_Org_Name.Text <> "" Then
        'If lstDebtor1_Org_Type.SelectedValue = "" Or lstDebtor1_Org_Jurisdiction.SelectedValue = "" Then
        '  sMsg = sMsg & "You must provide the Organization Type and Jurisdiction for section 7.<br />"
        'End If
        'If txtDebtor1_Org_ID.Text = "" And chkDebtor1_Org_ID_None.Checked = False Then
        '  sMsg = sMsg & "You must provide the Organization ID or check None for section 7.<br />"
        'End If
      End If
      If txtDebtor1_Mailing_Address.Text = "" Or txtDebtor1_City.Text = "" Or lstDebtor1_State.SelectedValue = "" Or txtDebtor1_Zip.Text = "" Then
        sMsg = sMsg & "You must provide a Mailing Address, City, State and Postal Code for section 7.<br />"
      End If

      If txtDebtor2_Ind_Last_Name.Text <> "" And txtDebtor2_Org_Name.Text <> "" Then
        sMsg = sMsg & "You may provide an Organization Name or Individual Name, but not both for the 2nd Debtor.<br />"
        'ElseIf txtDebtor2_Ind_Last_Name.Text = "" And txtDebtor2_Ind_First_Name.Text = "" And txtDebtor2_Org_Name.Text = "" Then
        '  sMsg = sMsg & "You must provide an Organization Name or Individual Name for the 2nd Debtor.<br />"
      ElseIf txtDebtor2_Ind_Last_Name.Text <> "" And txtDebtor2_Ind_First_Name.Text = "" Then
        sMsg = sMsg & "You must provide a First Name for the 2nd Debtor.<br />"
      ElseIf txtDebtor2_Ind_Last_Name.Text = "" And txtDebtor2_Ind_First_Name.Text <> "" Then
        sMsg = sMsg & "You must provide a Last Name for the 2nd Debtor.<br />"
        'ElseIf txtDebtor2_Org_Name.Text <> "" Then
        'If (lstDebtor2_Org_Type.SelectedValue = "" Or lstDebtor2_Org_Jurisdiction.SelectedValue = "") Then
        '  sMsg = sMsg & "You must provide the Organization Type and Jurisdiction for the 2nd Debtor.<br />"
        'End If
        'If txtDebtor2_Org_ID.Text = "" And chkDebtor2_Org_ID_None.Checked = False Then
        '  sMsg = sMsg & "You must provide the Organization ID or check None for the 2nd Debtor.<br />"
        'End If
      End If
      If txtDebtor2_Ind_Last_Name.Text <> "" Or txtDebtor2_Org_Name.Text <> "" Then
        If txtDebtor2_Mailing_Address.Text = "" Or txtDebtor2_City.Text = "" Or lstDebtor2_State.SelectedValue = "" Or txtDebtor2_Zip.Text = "" Then
          sMsg = sMsg & "You must provide a Mailing Address, City, State and Postal Code for the 2nd Debtor.<br />"
        End If
      End If

      If txtDebtor3_Ind_Last_Name.Text <> "" And txtDebtor3_Org_Name.Text <> "" Then
        sMsg = sMsg & "You may provide an Organization Name or Individual Name, but not both for the 3rd Debtor.<br />"
        'ElseIf txtDebtor3_Ind_Last_Name.Text = "" And txtDebtor3_Ind_First_Name.Text = "" And txtDebtor3_Org_Name.Text = "" Then
        '  sMsg = sMsg & "You must provide an Organization Name or Individual Name for the 3rd Debtor.<br />"
      ElseIf txtDebtor3_Ind_Last_Name.Text <> "" And txtDebtor3_Ind_First_Name.Text = "" Then
        sMsg = sMsg & "You must provide a First Name for the 3rd Debtor.<br />"
      ElseIf txtDebtor3_Ind_Last_Name.Text = "" And txtDebtor3_Ind_First_Name.Text <> "" Then
        sMsg = sMsg & "You must provide a Last Name for the 3rd Debtor.<br />"
        'ElseIf txtDebtor3_Org_Name.Text <> "" Then
        'If (lstDebtor3_Org_Type.SelectedValue = "" Or lstDebtor3_Org_Jurisdiction.SelectedValue = "") Then
        '  sMsg = sMsg & "You must provide the Organization Type and Jurisdiction for the 3rd Debtor.<br />"
        'End If
        'If txtDebtor3_Org_ID.Text = "" And chkDebtor3_Org_ID_None.Checked = False Then
        '  sMsg = sMsg & "You must provide the Organization ID or check None for the 3rd Debtor.<br />"
        'End If
      End If
      If txtDebtor3_Ind_Last_Name.Text <> "" Or txtDebtor3_Org_Name.Text <> "" Then
        If txtDebtor3_Mailing_Address.Text = "" Or txtDebtor3_City.Text = "" Or lstDebtor3_State.SelectedValue = "" Or txtDebtor3_Zip.Text = "" Then
          sMsg = sMsg & "You must provide a Mailing Address, City, State and Postal Code for the 3rd Debtor.<br />"
        End If
      End If

      If txtDebtor4_Ind_Last_Name.Text <> "" And txtDebtor4_Org_Name.Text <> "" Then
        sMsg = sMsg & "You may provide an Organization Name or Individual Name, but not both for the 4th Debtor.<br />"
        'ElseIf txtDebtor4_Ind_Last_Name.Text = "" And txtDebtor4_Ind_First_Name.Text = "" And txtDebtor4_Org_Name.Text = "" Then
        '  sMsg = sMsg & "You must provide an Organization Name or Individual Name for the 4th Debtor.<br />"
      ElseIf txtDebtor4_Ind_Last_Name.Text <> "" And txtDebtor4_Ind_First_Name.Text = "" Then
        sMsg = sMsg & "You must provide a First Name for the 4th Debtor.<br />"
      ElseIf txtDebtor4_Ind_Last_Name.Text = "" And txtDebtor4_Ind_First_Name.Text <> "" Then
        sMsg = sMsg & "You must provide a Last Name for the 4th Debtor.<br />"
        'ElseIf txtDebtor4_Org_Name.Text <> "" Then
        'If (lstDebtor4_Org_Type.SelectedValue = "" Or lstDebtor4_Org_Jurisdiction.SelectedValue = "") Then
        '  sMsg = sMsg & "You must provide the Organization Type and Jurisdiction for the 4th Debtor.<br />"
        'End If
        'If txtDebtor4_Org_ID.Text = "" And chkDebtor4_Org_ID_None.Checked = False Then
        '  sMsg = sMsg & "You must provide the Organization ID or check None for the 4th Debtor.<br />"
        'End If
      End If
      If txtDebtor4_Ind_Last_Name.Text <> "" Or txtDebtor4_Org_Name.Text <> "" Then
        If txtDebtor4_Mailing_Address.Text = "" Or txtDebtor4_City.Text = "" Or lstDebtor4_State.SelectedValue = "" Or txtDebtor4_Zip.Text = "" Then
          sMsg = sMsg & "You must provide a Mailing Address, City, State and Postal Code for the 4th Debtor.<br />"
        End If
      End If

    End If
    If txtReference_Data.Text.Length > 80 Then
      sMsg = sMsg & "Reference Data can only be 80 characters long.<br />"
    End If

    If sMsg <> "" Then
      '?where to display message
      lblMsg.Text = sMsg
      Exit Sub
    End If


    Try
      If rcbNew_Debtor.SelectedValue = "" Then
        If txtDebtor1_Org_Name.Text <> "" Or txtDebtor1_Ind_Last_Name.Text <> "" Or txtDebtor1_Ind_First_Name.Text <> "" Or txtDebtor1_Ind_Middle_Name.Text <> "" Or txtDebtor1_Ind_Suffix.Text <> "" Or txtDebtor1_Mailing_Address.Text <> "" Or txtDebtor1_City.Text <> "" Or txtDebtor1_Zip.Text <> "" Or txtDebtor1_Org_ID.Text <> "" Or lstDebtor1_Org_Jurisdiction.SelectedValue <> "" Or lstDebtor1_Org_Type.SelectedValue <> "" Then
          'insert new debtor and get debtor_id
          sNew_Debtor = AddDebtor(Session("UserID"), Session("company_rid"), txtDebtor1_Org_Name.Text, txtDebtor1_Ind_Last_Name.Text, txtDebtor1_Ind_First_Name.Text, txtDebtor1_Ind_Middle_Name.Text, txtDebtor1_Ind_Suffix.Text, txtDebtor1_Mailing_Address.Text, txtDebtor1_City.Text, lstDebtor1_State.SelectedValue, txtDebtor1_Zip.Text, txtDebtor1_Country.Text, txtDebtor1_d1.Text, lstDebtor1_Org_Type.SelectedValue, lstDebtor1_Org_Jurisdiction.SelectedValue, txtDebtor1_Org_ID.Text, IIf(chkDebtor1_Org_ID_None.Checked, "Y", "N"))
        Else
          sNew_Debtor = "Null"
        End If
      Else
        sNew_Debtor = rcbNew_Debtor.SelectedValue
      End If

      If Request.QueryString("id") <> "" Then
        sUF_ID = Request.QueryString("id")
      Else
        sUF_ID = "Null"
      End If

      Dim sSecMailAddress As String, sSecCity As String, sSecZip As String, sSecCountry As String, sSecState As String
      Dim dtComp As DataTable = FillDataTable("Select * From subscriber where company_id = " & Session("company_rid"))
      If dtComp.Rows.Count > 0 Then
        sSecMailAddress = dtComp.Rows(0).Item("address") & ""
        sSecCity = dtComp.Rows(0).Item("city") & ""
        sSecZip = dtComp.Rows(0).Item("zip") & ""
        sSecCountry = "USA"
        sSecState = dtComp.Rows(0).Item("state") & ""
      Else
        sSecMailAddress = ""
        sSecCity = ""
        sSecZip = ""
        sSecCountry = ""
        sSecState = ""
      End If
      dtComp.Dispose()
      dtComp = Nothing

      'chkPartyChange
      'chkCollateralChange

      'u3_secured_mailing_address,u3_secured_city,u3_secured_state,u3_secured_zipcode,u3_secured_country,
      '"'Address','City','ST','Zip','Country'," & _
      sSQL = "Insert Into ucc3 (u3_uf_id,u3_initial_file_no,u3_real_estate,u3_loan_type,u3_initial_name,u3_fsfl_fy,u3_termination,u3_continuation,u3_assignment,u3_amendment_affects," & _
        "u3_amendment,u3_old_org_name,u3_old_ind_last_name,u3_old_ind_first_name,u3_old_ind_middle_name,u3_old_ind_suffix ," & _
        "u3_new_debtor,u3_collateral_change,u3_collateral,u3_secured_org_name, " & _
        "u3_secured_mailing_address, u3_secured_city, u3_secured_state, u3_secured_zipcode, u3_secured_country, " & _
        "u3_reference_data,u3_date_submitted,u3_user_submitted, " & _
        "u3_status,u3_charge,u3_company_id) Values (" & _
        sUF_ID & ",'" & txtInitial_file_No.Text.Replace("'", "''").ToUpper & "'," & _
        "'" & IIf(chkReal_Estate.Checked, "Y", "N") & "', " & _
        "'" & ddlLoanType.SelectedValue & "', " & _
        "'" & txtInitialName.Text.Replace("'", "''").ToUpper & "'," & _
        "" & ddlFY.SelectedValue & ", " & _
        "'" & IIf(chkTermination.Checked, "Y", "N") & "', " & _
        "'" & IIf(chkContinuation.Checked, "Y", "N") & "', " & _
        "'" & IIf(chkAssignment.Checked, "Y", "N") & "', " & _
        "'" & IIf(chkAmend_Debtor.Checked, "D", IIf(chkAmend_Secured_Party.Checked, "S", "")) & "', " & _
        "'" & IIf(chkAmend_Change.Checked, "C", IIf(chkAmend_Delete.Checked, "D", IIf(chkAmend_Add.Checked, "A", ""))) & "', " & _
        "'" & txtOrig_Org_Name.Text.Replace("'", "''").ToUpper & "', " & _
        "'" & txtOrig_Ind_Last_Name.Text.Replace("'", "''").ToUpper & "', " & _
        "'" & txtOrig_Ind_First_Name.Text.Replace("'", "''").ToUpper & "', " & _
        "'" & txtOrig_Ind_Middle_Name.Text.Replace("'", "''").ToUpper & "', " & _
        "'" & txtOrig_Ind_Suffix.Text.Replace("'", "''").ToUpper & "', " & _
        sNew_Debtor & "," & _
        "'" & IIf(chkCollateral_Deleted.Checked, "D", IIf(chkCollateral_Added.Checked, "A", IIf(chkCollateral_Restated.Checked, "R", IIf(chkCollateral_Assigned.Checked, "S", "")))) & "', " & _
        "'" & txtCollateral.Text.Replace("'", "''").ToUpper & "', " & _
        "'" & lstSecured_Org_Name.SelectedValue.Replace("'", "''").ToUpper & "', " & _
        "'" & sSecMailAddress & "','" & sSecCity & "','" & sSecZip & "','" & sSecCountry & "','" & sSecState & "', " & _
        "'" & txtReference_Data.Text.Replace("'", "''").ToUpper & "',getdate(),'" & Session("UserID") & "','N'," & _
        IIf(Filing_Charge_Amendment <> "", Filing_Charge_Amendment, "Null") & "," & Session("company_rid") & _
        "); Select Scope_Identity() "

      Dim sU3_ID As String = ExecuteScalar(sSQL)

      If pnlUCC3ad.Visible Then
        'chkAD_Timber
        'chkAD_AsExtracted
        'chkAD_Fixture_Filing
        'txtAD_Record_Owner
        'txtAD_Real_Estate
        'txtAD_Misc
        'u3ad_covers	char(1)	Checked
        'u3ad_real_estate	varchar(500)	Checked
        'u3ad_record_owner	varchar(200)	Checked
        'u3ad_misc	varchar(200)	Checked
        Dim sCovers As String = ""
        If chkAD_Timber.Checked Then sCovers = "T" Else sCovers = " "
        If chkAD_AsExtracted.Checked Then sCovers = "A" Else sCovers = " "
        If chkAD_Fixture_Filing.Checked Then sCovers = "F" Else sCovers = " "

        sSQL = "Insert Into ucc3_ad (u3ad_u3_id,u3ad_info,u3ad_covers,u3ad_real_estate,u3ad_record_owner,u3ad_misc)" & _
          " Values (" & sU3_ID & ",'" & txtAD_Additional.Text.Replace("'", "''").ToUpper & "','" & sCovers & "', " & _
          "'" & txtAD_Real_Estate.Text.Replace("'", "''").ToUpper & "','" & _
          txtAD_Record_Owner.Text.Replace("'", "''").ToUpper & "','" & _
          txtAD_Misc.Text.Replace("'", "''").ToUpper & "'" & _
          "); Select Scope_Identity()"
        Dim sAD_ID As String = ExecuteScalar(sSQL)
      End If

      If pnlUCC3ap.Visible Then
        Try
          If rcbDebtor2.SelectedValue = "" Then
            'insert new debtor and get debtor_id
            If txtDebtor2_Org_Name.Text <> "" Or txtDebtor2_Ind_Last_Name.Text <> "" Then
              sDebtor2 = AddDebtor(Session("UserID"), Session("company_rid"), txtDebtor2_Org_Name.Text, txtDebtor2_Ind_Last_Name.Text, txtDebtor2_Ind_First_Name.Text, txtDebtor2_Ind_Middle_Name.Text, txtDebtor2_Ind_Suffix.Text, txtDebtor2_Mailing_Address.Text, txtDebtor2_City.Text, lstDebtor2_State.SelectedValue, txtDebtor2_Zip.Text, txtDebtor2_Country.Text, txtDebtor2_d1.Text, lstDebtor2_Org_Type.SelectedValue, lstDebtor2_Org_Jurisdiction.SelectedValue, txtDebtor2_Org_ID.Text, IIf(chkDebtor2_Org_ID_None.Checked, "Y", "N"))
            End If
          Else
            sDebtor2 = rcbDebtor2.SelectedValue
          End If
          If chkDebtor2_RunSearch.Checked Then
            Dim sSR2 As String = IIf(chkSR2_All.Checked, "A", IIf(chkSR2_Unlapsed.Checked, "U", ""))
            Dim sCR2 As String = IIf(chkCR2_All.Checked, "A", IIf(chkCR2_Unlapsed.Checked, "U", ""))
            Dim sMoreDate As String = txtMoreDate2.Text
            Dim sMoreAddress As String = txtMoreAddress2.Text
            Dim sMoreName As String = txtMoreName2.Text
            Dim sMoreOther As String = txtMoreOther2.Text
            Dim sUS_ID As String = EnterSearch(sDebtor2, "", sSR2, "", sCR2, "", sMoreDate, sMoreAddress, sMoreName, sMoreOther, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", txtAdditional2.Text, "N", Session("UserID"), Session("company_rid"), Search_Charge_with_File, ddlLoanType.SelectedValue, ddlFY.SelectedValue)
          End If
        Catch ex As Exception
          lblMsg.Text = "Error adding debtor #2 - " & ex.ToString
          Exit Sub
        End Try


        Try
          If rcbDebtor3.SelectedValue = "" Then
            'insert new debtor and get debtor_id
            If txtDebtor3_Org_Name.Text <> "" Or txtDebtor3_Ind_Last_Name.Text <> "" Then
              sDebtor3 = AddDebtor(Session("UserID"), Session("company_rid"), txtDebtor3_Org_Name.Text, txtDebtor3_Ind_Last_Name.Text, txtDebtor3_Ind_First_Name.Text, txtDebtor3_Ind_Middle_Name.Text, txtDebtor3_Ind_Suffix.Text, txtDebtor3_Mailing_Address.Text, txtDebtor3_City.Text, lstDebtor3_State.SelectedValue, txtDebtor3_Zip.Text, txtDebtor3_Country.Text, txtDebtor3_d1.Text, lstDebtor3_Org_Type.SelectedValue, lstDebtor3_Org_Jurisdiction.SelectedValue, txtDebtor3_Org_ID.Text, IIf(chkDebtor3_Org_ID_None.Checked, "Y", "N"))
            End If
          Else
            sDebtor3 = rcbDebtor3.SelectedValue
          End If
          If chkDebtor3_RunSearch.Checked Then
            Dim sSR3 As String = IIf(chkSR3_All.Checked, "A", IIf(chkSR3_Unlapsed.Checked, "U", ""))
            Dim sCR3 As String = IIf(chkCR3_All.Checked, "A", IIf(chkCR3_Unlapsed.Checked, "U", ""))
            Dim sMoreDate As String = txtMoreDate3.Text
            Dim sMoreAddress As String = txtMoreAddress3.Text
            Dim sMoreName As String = txtMoreName3.Text
            Dim sMoreOther As String = txtMoreOther3.Text
            Dim sUS_ID As String = EnterSearch(sDebtor3, "", sSR3, "", sCR3, "", sMoreDate, sMoreAddress, sMoreName, sMoreOther, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", txtAdditional3.Text, "N", Session("UserID"), Session("company_rid"), Search_Charge_with_File, ddlLoanType.SelectedValue, ddlFY.SelectedValue)
          End If
        Catch ex As Exception
          lblMsg.Text = "Error adding debtor #3 - " & ex.ToString
          Exit Sub
        End Try

        Try
          If rcbDebtor4.SelectedValue = "" Then
            'insert new debtor and get debtor_id
            If txtDebtor4_Org_Name.Text <> "" Or txtDebtor4_Ind_Last_Name.Text <> "" Then
              sDebtor4 = AddDebtor(Session("UserID"), Session("company_rid"), txtDebtor4_Org_Name.Text, txtDebtor4_Ind_Last_Name.Text, txtDebtor4_Ind_First_Name.Text, txtDebtor4_Ind_Middle_Name.Text, txtDebtor4_Ind_Suffix.Text, txtDebtor4_Mailing_Address.Text, txtDebtor4_City.Text, lstDebtor4_State.SelectedValue, txtDebtor4_Zip.Text, txtDebtor4_Country.Text, txtDebtor4_d1.Text, lstDebtor4_Org_Type.SelectedValue, lstDebtor4_Org_Jurisdiction.SelectedValue, txtDebtor4_Org_ID.Text, IIf(chkDebtor4_Org_ID_None.Checked, "Y", "N"))
            End If
          Else
            sDebtor4 = rcbDebtor4.SelectedValue
          End If
          If chkDebtor4_RunSearch.Checked Then
            Dim sSR4 As String = IIf(chkSR4_All.Checked, "A", IIf(chkSR4_Unlapsed.Checked, "U", ""))
            Dim sCR4 As String = IIf(chkCR4_All.Checked, "A", IIf(chkCR4_Unlapsed.Checked, "U", ""))
            Dim sMoreDate As String = txtMoreDate4.Text
            Dim sMoreAddress As String = txtMoreAddress4.Text
            Dim sMoreName As String = txtMoreName4.Text
            Dim sMoreOther As String = txtMoreOther4.Text
            Dim sUS_ID As String = EnterSearch(sDebtor4, "", sSR4, "", sCR4, "", sMoreDate, sMoreAddress, sMoreName, sMoreOther, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", txtAdditional4.Text, "N", Session("UserID"), Session("company_rid"), Search_Charge_with_File, ddlLoanType.SelectedValue, ddlFY.SelectedValue)
          End If
        Catch ex As Exception
          lblMsg.Text = "Error adding debtor #4 - " & ex.ToString
          Exit Sub
        End Try

        Dim sAP_ID As String
        Try
          sSQL = "Insert Into ucc3_ap (u3ap_u3_id,u3ap_misc,u3ap_Debtor2,u3ap_Debtor3,u3ap_Debtor4," & _
          "u3ap_secured2,u3ap_secured3) Values (" & sU3_ID & "," & _
          "'" & txtAP_Misc.Text.Replace("'", "''").ToUpper & "', " & _
          IIf(sDebtor2 <> "", sDebtor2, "Null") & "," & _
          IIf(sDebtor3 <> "", sDebtor3, "Null") & "," & _
          IIf(sDebtor4 <> "", sDebtor4, "Null") & "," & _
          "Null,Null); Select Scope_Identity()"
          sAP_ID = ExecuteScalar(sSQL)
        Catch ex As Exception
          lblMsg.Text = "Error adding ap - " & ex.ToString
          Exit Sub
        End Try

      End If
    Catch ex As Exception
      lblMsg.Text = "Error adding addendum, " & ex.ToString & "<br >" & sSQL
      Exit Sub
    End Try


    SendEmailNew(0, 0, "A new UCC Amendment Filing has been submitted.", "New UCC Amendment Filing submitted", IDC_Notify, "", True)

    Dim ckState As String
    ckState = lstOrg_State.SelectedValue


    If ckState <> "IL" Then
      SendEmailNew(0, 0, "A new UCC has been submitted from out of state (" & ckState & ") at " & Date.Now & ".", "New out of state UCC", IDC_Notify, "", True)
    End If


    'where to redirect to, main page?
    Response.Redirect("main.aspx")
  End Sub
End Class
