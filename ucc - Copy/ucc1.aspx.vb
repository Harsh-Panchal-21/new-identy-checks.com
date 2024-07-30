Imports System.Data.SqlClient
Imports Telerik.Web.UI

Partial Class ucc1
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

      lstDebtor5_State.DataSource = lstDebtor1_State.Items
      lstDebtor5_State.DataBind()
      Try
        lstDebtor5_State.SelectedIndex = -1
        lstDebtor5_State.Items.FindByValue("IL").Selected = True
      Catch ex As Exception

      End Try

      lstDebtor6_State.DataSource = lstDebtor1_State.Items
      lstDebtor6_State.DataBind()
      Try
        lstDebtor6_State.SelectedIndex = -1
        lstDebtor6_State.Items.FindByValue("IL").Selected = True
      Catch ex As Exception

      End Try

      lstSecured_State.DataSource = lstDebtor1_State.Items
      lstSecured_State.DataBind()
      Try
        lstSecured_State.SelectedIndex = -1
        lstSecured_State.Items.FindByValue("IL").Selected = True
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

      lstSecured4_State.DataSource = lstDebtor1_State.Items
      lstSecured4_State.DataBind()
      Try
        lstSecured4_State.SelectedIndex = -1
        lstSecured4_State.Items.FindByValue("IL").Selected = True
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

      lstDebtor5_Org_Jurisdiction.DataSource = lstDebtor1_State.Items
      lstDebtor5_Org_Jurisdiction.DataBind()
      Try
        lstDebtor5_Org_Jurisdiction.SelectedIndex = -1
        lstDebtor5_Org_Jurisdiction.Items.FindByValue("IL").Selected = True
      Catch ex As Exception

      End Try

      lstDebtor6_Org_Jurisdiction.DataSource = lstDebtor1_State.Items
      lstDebtor6_Org_Jurisdiction.DataBind()
      Try
        lstDebtor6_Org_Jurisdiction.SelectedIndex = -1
        lstDebtor6_Org_Jurisdiction.Items.FindByValue("IL").Selected = True
      Catch ex As Exception

      End Try

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
      'lstDebtor5_Org_Type.DataSource = lstDebtor1_Org_Type.Items
      'lstDebtor5_Org_Type.DataBind()
      'lstDebtor6_Org_Type.DataSource = lstDebtor1_Org_Type.Items
      'lstDebtor6_Org_Type.DataBind()


      lstSecured_Org_Name.Items.Add(New ListItem("Choose Org Name", ""))
      lstSecured_Org_Name.Items.Add(New ListItem("Commodity Credit Corporation", "Commodity Credit Corporation"))
      lstSecured_Org_Name.Items.Add(New ListItem("United States of America Acting Through Farm Service Agency", "United States of America Acting Through Farm Service Agency"))

      lstSecured2_Org_Name.DataSource = lstSecured_Org_Name.Items
      lstSecured2_Org_Name.DataBind()

      lstSecured3_Org_Name.DataSource = lstSecured_Org_Name.Items
      lstSecured3_Org_Name.DataBind()

      lstSecured4_Org_Name.DataSource = lstSecured_Org_Name.Items
      lstSecured4_Org_Name.DataBind()

      lstCollateral.Items.Add(New ListItem("Choose Value to Preload", ""))
      lstCollateral.Items.Add(New ListItem("All harvested crops", "All harvested crops"))
      lstCollateral.Items.Add(New ListItem("Crops, livestock, other farm products, ...", "Crops, livestock, other farm products, farm and other equipment, supplies, inventory, accounts and contract rights. Proceeds and products of the preceding collateral are also included. Disposition of such collateral is not hereby authorized."))

      Dim dtComp As DataTable = FillDataTable("Select * From subscriber where company_id = " & Session("company_rid"))
      If dtComp.Rows.Count > 0 Then
        txtSecured_Mailing_Address.Text = dtComp.Rows(0).Item("address") & ""
        txtSecured_City.Text = dtComp.Rows(0).Item("city") & ""
        txtSecured_Zip.Text = dtComp.Rows(0).Item("zip") & ""
        txtSecured_Country.Text = "USA"
        Try
          lstSecured_State.SelectedIndex = -1
          lstSecured_State.Items.FindByValue(dtComp.Rows(0).Item("state") & "").Selected = True
        Catch ex As Exception

        End Try
      Else
        'error
      End If
      dtComp.Dispose()
      dtComp = Nothing

      'Me.txtCollateral.Attributes.Add("onKeyPress", "return textboxMultilineMaxNumber(this,1200);")
      Me.txtCollateral.Attributes.Add("onkeyup", "return textboxMultilineMaxNumber(this,1200);")
      Me.txtCollateral.Attributes.Add("onkeydown", "return textboxMultilineMaxNumber(this,1200);")
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

  Protected Sub rcbDebtor1_ItemsRequested(ByVal o As Object, ByVal e As Telerik.Web.UI.RadComboBoxItemsRequestedEventArgs)
    If e.Text.Length > 2 Then
      Dim data As DataTable = GetData(e.Text, "")

      Dim itemOffset As Integer = e.NumberOfItems
      Dim endOffset As Integer = Math.Min(itemOffset + ItemsPerRequest, data.Rows.Count)
      e.EndOfItems = endOffset = data.Rows.Count

      For i As Integer = itemOffset To endOffset - 1
        rcbDebtor1.Items.Add(New Telerik.Web.UI.RadComboBoxItem(data.Rows(i)("disp_name").ToString(), data.Rows(i)("key_name").ToString()))
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

  Protected Sub rcbDebtor5_ItemsRequested(ByVal o As Object, ByVal e As Telerik.Web.UI.RadComboBoxItemsRequestedEventArgs)
    If e.Text.Length > 2 Then
      Dim data As DataTable = GetData(e.Text, "")

      Dim itemOffset As Integer = e.NumberOfItems
      Dim endOffset As Integer = Math.Min(itemOffset + ItemsPerRequest, data.Rows.Count)
      e.EndOfItems = endOffset = data.Rows.Count

      For i As Integer = itemOffset To endOffset - 1
        rcbDebtor5.Items.Add(New Telerik.Web.UI.RadComboBoxItem(data.Rows(i)("disp_name").ToString(), data.Rows(i)("key_name").ToString()))
      Next

      e.Message = GetStatusMessage(endOffset, data.Rows.Count)
    End If
  End Sub

  Protected Sub rcbDebtor6_ItemsRequested(ByVal o As Object, ByVal e As Telerik.Web.UI.RadComboBoxItemsRequestedEventArgs)
    If e.Text.Length > 2 Then
      Dim data As DataTable = GetData(e.Text, "")

      Dim itemOffset As Integer = e.NumberOfItems
      Dim endOffset As Integer = Math.Min(itemOffset + ItemsPerRequest, data.Rows.Count)
      e.EndOfItems = endOffset = data.Rows.Count

      For i As Integer = itemOffset To endOffset - 1
        rcbDebtor6.Items.Add(New Telerik.Web.UI.RadComboBoxItem(data.Rows(i)("disp_name").ToString(), data.Rows(i)("key_name").ToString()))
      Next

      e.Message = GetStatusMessage(endOffset, data.Rows.Count)
    End If
  End Sub

  Protected Sub rcbDebtor1_SelectedIndexChanged(sender As Object, e As Telerik.Web.UI.RadComboBoxSelectedIndexChangedEventArgs) Handles rcbDebtor1.SelectedIndexChanged
    'fill in debtor info, lock fields?
    Dim tmpTextA As New TextBox, tmpTextB As New TextBox
    'tmpTextA.Text = lstDebtor1_Org_Type.SelectedValue
    'tmpTextB.Text = lstDebtor1_Org_Jurisdiction.SelectedValue
    FillDebtorInfo(rcbDebtor1.SelectedValue, Session("company_rid"), txtDebtor1_Org_Name, txtDebtor1_Ind_Last_Name, txtDebtor1_Ind_First_Name, txtDebtor1_Ind_Middle_Name, txtDebtor1_Ind_Suffix, txtDebtor1_Mailing_Address, txtDebtor1_City, lstDebtor1_State, txtDebtor1_Zip, txtDebtor1_Country, txtDebtor1_d1, tmpTextA, tmpTextB, txtDebtor1_Org_ID, chkDebtor1_Org_ID_None)
  End Sub

  Protected Sub rcbDebtor2_SelectedIndexChanged(sender As Object, e As Telerik.Web.UI.RadComboBoxSelectedIndexChangedEventArgs) Handles rcbDebtor2.SelectedIndexChanged
    'fill in debtor info, lock fields?
    Dim tmpTextA As New TextBox, tmpTextB As New TextBox
    'tmpTextA.Text = lstDebtor2_Org_Type.SelectedValue
    'tmpTextB.Text = lstDebtor2_Org_Jurisdiction.SelectedValue
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

  Protected Sub rcbDebtor5_SelectedIndexChanged(sender As Object, e As Telerik.Web.UI.RadComboBoxSelectedIndexChangedEventArgs) Handles rcbDebtor5.SelectedIndexChanged
    'fill in debtor info, lock fields?
    Dim tmpTextA As New TextBox, tmpTextB As New TextBox
    'tmpTextA.Text = lstDebtor5_Org_Type.SelectedValue
    'tmpTextB.Text = lstDebtor5_Org_Jurisdiction.SelectedValue
    FillDebtorInfo(rcbDebtor5.SelectedValue, Session("company_rid"), txtDebtor5_Org_Name, txtDebtor5_Ind_Last_Name, txtDebtor5_Ind_First_Name, txtDebtor5_Ind_Middle_Name, txtDebtor5_Ind_Suffix, txtDebtor5_Mailing_Address, txtDebtor5_City, lstDebtor5_State, txtDebtor5_Zip, txtDebtor5_Country, txtDebtor5_d1, tmpTextA, tmpTextB, txtDebtor5_Org_ID, chkDebtor5_Org_ID_None)
  End Sub

  Protected Sub rcbDebtor6_SelectedIndexChanged(sender As Object, e As Telerik.Web.UI.RadComboBoxSelectedIndexChangedEventArgs) Handles rcbDebtor6.SelectedIndexChanged
    'fill in debtor info, lock fields?
    Dim tmpTextA As New TextBox, tmpTextB As New TextBox
    'tmpTextA.Text = lstDebtor6_Org_Type.SelectedValue
    'tmpTextB.Text = lstDebtor6_Org_Jurisdiction.SelectedValue
    FillDebtorInfo(rcbDebtor6.SelectedValue, Session("company_rid"), txtDebtor6_Org_Name, txtDebtor6_Ind_Last_Name, txtDebtor6_Ind_First_Name, txtDebtor6_Ind_Middle_Name, txtDebtor6_Ind_Suffix, txtDebtor6_Mailing_Address, txtDebtor6_City, lstDebtor6_State, txtDebtor6_Zip, txtDebtor6_Country, txtDebtor6_d1, tmpTextA, tmpTextB, txtDebtor6_Org_ID, chkDebtor6_Org_ID_None)
  End Sub

  Protected Sub btnSubmit_Click(sender As Object, e As System.EventArgs) Handles btnSubmit.Click
    Dim sSQL As String = ""
    Dim sMsg As String = ""
    Dim sDebtor1 As String = "", sDebtor2 As String = "", sDebtor3 As String = ""
    Dim sDebtor4 As String = "", sDebtor5 As String = "", sDebtor6 As String = ""

    'check to make sure all reqd fields are there
    If txtDebtor1_Ind_Last_Name.Text <> "" And txtDebtor1_Org_Name.Text <> "" Then
      sMsg = sMsg & "You may provide an Organization Name or Individual Name, but not both for the 1st Debtor.<br />"
    ElseIf txtDebtor1_Ind_Last_Name.Text <> "" And txtDebtor1_Ind_First_Name.Text = "" Then
      sMsg = sMsg & "You must provide a First Name for the 1st Debtor.<br />"
    ElseIf txtDebtor1_Org_Name.Text <> "" Then
      'If lstDebtor1_Org_Type.SelectedValue = "" Or lstDebtor1_Org_Jurisdiction.SelectedValue = "" Then
      '  sMsg = sMsg & "You must provide the Organization Type and Jurisdiction for the 1st Debtor.<br />"
      'End If
      'If txtDebtor1_Org_ID.Text = "" And chkDebtor1_Org_ID_None.Checked = False Then
      '  sMsg = sMsg & "You must provide the Organization ID or check None for the 1st Debtor.<br />"
      'End If
    End If
    If txtDebtor1_Mailing_Address.Text = "" Or txtDebtor1_City.Text = "" Or lstDebtor1_State.SelectedValue = "" Or txtDebtor1_Zip.Text = "" Then
      sMsg = sMsg & "You must provide an Mailing Address, City, State and Postal Code for the 1st Debtor.<br />"
    End If

    If txtDebtor2_Ind_Last_Name.Text <> "" And txtDebtor2_Org_Name.Text <> "" Then
      sMsg = sMsg & "You may provide an Organization Name or Individual Name, but not both for the 2nd Debtor.<br />"
    ElseIf txtDebtor2_Ind_Last_Name.Text <> "" And txtDebtor2_Ind_First_Name.Text = "" Then
      sMsg = sMsg & "You must provide a First Name for the 2nd Debtor.<br />"
    ElseIf txtDebtor2_Org_Name.Text <> "" Then
      'If (lstDebtor2_Org_Type.SelectedValue = "" Or lstDebtor2_Org_Jurisdiction.SelectedValue = "") Then
      '  sMsg = sMsg & "You must provide the Organization Type and Jurisdiction for the 2nd Debtor.<br />"
      'End If
      'If txtDebtor2_Org_ID.Text = "" And chkDebtor2_Org_ID_None.Checked = False Then
      '  sMsg = sMsg & "You must provide the Organization ID or check None for the 2nd Debtor.<br />"
      'End If
    End If
    If txtDebtor2_Ind_Last_Name.Text <> "" Or txtDebtor2_Org_Name.Text <> "" Then
      If txtDebtor2_Mailing_Address.Text = "" Or txtDebtor2_City.Text = "" Or lstDebtor2_State.SelectedValue = "" Or txtDebtor2_Zip.Text = "" Then
        sMsg = sMsg & "You must provide an Mailing Address, City, State and Postal Code for the 2nd Debtor.<br />"
      End If
    End If

    If txtDebtor3_Ind_Last_Name.Text <> "" And txtDebtor3_Org_Name.Text <> "" Then
      sMsg = sMsg & "You may provide an Organization Name or Individual Name, but not both for the 3rd Debtor.<br />"
    ElseIf txtDebtor3_Ind_Last_Name.Text <> "" And txtDebtor3_Ind_First_Name.Text = "" Then
      sMsg = sMsg & "You must provide a First Name for the 3rd Debtor.<br />"
    ElseIf txtDebtor3_Org_Name.Text <> "" Then
      'If (lstDebtor3_Org_Type.SelectedValue = "" Or lstDebtor3_Org_Jurisdiction.SelectedValue = "") Then
      '  sMsg = sMsg & "You must provide the Organization Type and Jurisdiction for the 3rd Debtor.<br />"
      'End If
      'If txtDebtor3_Org_ID.Text = "" And chkDebtor3_Org_ID_None.Checked = False Then
      '  sMsg = sMsg & "You must provide the Organization ID or check None for the 3rd Debtor.<br />"
      'End If
    End If
    If txtDebtor4_Ind_Last_Name.Text <> "" And txtDebtor4_Org_Name.Text <> "" Then
      sMsg = sMsg & "You may provide an Organization Name or Individual Name, but not both for the 4th Debtor.<br />"
    ElseIf txtDebtor4_Ind_Last_Name.Text <> "" And txtDebtor4_Ind_First_Name.Text = "" Then
      sMsg = sMsg & "You must provide a First Name for the 4th Debtor.<br />"
    ElseIf txtDebtor4_Org_Name.Text <> "" Then
      'If (lstDebtor4_Org_Type.SelectedValue = "" Or lstDebtor4_Org_Jurisdiction.SelectedValue = "") Then
      '  sMsg = sMsg & "You must provide the Organization Type and Jurisdiction for the 4th Debtor.<br />"
      'End If
      'If txtDebtor4_Org_ID.Text = "" And chkDebtor4_Org_ID_None.Checked = False Then
      '  sMsg = sMsg & "You must provide the Organization ID or check None for the 4th Debtor.<br />"
      'End If
    End If
    If txtDebtor5_Ind_Last_Name.Text <> "" And txtDebtor5_Org_Name.Text <> "" Then
      sMsg = sMsg & "You may provide an Organization Name or Individual Name, but not both for the 5th Debtor.<br />"
    ElseIf txtDebtor5_Ind_Last_Name.Text <> "" And txtDebtor5_Ind_First_Name.Text = "" Then
      sMsg = sMsg & "You must provide a First Name for the 5th Debtor.<br />"
    ElseIf txtDebtor5_Org_Name.Text <> "" Then
      'If (lstDebtor5_Org_Type.SelectedValue = "" Or lstDebtor5_Org_Jurisdiction.SelectedValue = "") Then
      '  sMsg = sMsg & "You must provide the Organization Type and Jurisdiction for the 5th Debtor.<br />"
      'End If
      'If txtDebtor5_Org_ID.Text = "" And chkDebtor5_Org_ID_None.Checked = False Then
      '  sMsg = sMsg & "You must provide the Organization ID or check None for the 5th Debtor.<br />"
      'End If
    End If
    If txtDebtor6_Ind_Last_Name.Text <> "" And txtDebtor6_Org_Name.Text <> "" Then
      sMsg = sMsg & "You may provide an Organization Name or Individual Name, but not both for the 6th Debtor.<br />"
    ElseIf txtDebtor6_Ind_Last_Name.Text <> "" And txtDebtor6_Ind_First_Name.Text = "" Then
      sMsg = sMsg & "You must provide a First Name for the 6th Debtor.<br />"
    ElseIf txtDebtor6_Org_Name.Text <> "" Then
      'If (lstDebtor6_Org_Type.SelectedValue = "" Or lstDebtor6_Org_Jurisdiction.SelectedValue = "") Then
      '  sMsg = sMsg & "You must provide the Organization Type and Jurisdiction for the 6th Debtor.<br />"
      'End If
      'If txtDebtor6_Org_ID.Text = "" And chkDebtor6_Org_ID_None.Checked = False Then
      '  sMsg = sMsg & "You must provide the Organization ID or check None for the 6th Debtor.<br />"
      'End If
    End If

    If lstSecured_Org_Name.SelectedValue = "" Then
      sMsg = sMsg & "You must provide the Secured Organization Name.<br />"
    End If

    If sMsg <> "" Then
      lblMsg.Text = sMsg
      Exit Sub
    End If

    Try
      If rcbDebtor1.SelectedValue = "" Then
        'insert new debtor and get debtor_id
        sDebtor1 = AddDebtor(Session("UserID"), Session("company_rid"), txtDebtor1_Org_Name.Text, txtDebtor1_Ind_Last_Name.Text, txtDebtor1_Ind_First_Name.Text, txtDebtor1_Ind_Middle_Name.Text, txtDebtor1_Ind_Suffix.Text, txtDebtor1_Mailing_Address.Text, txtDebtor1_City.Text, lstDebtor1_State.SelectedValue, txtDebtor1_Zip.Text, txtDebtor1_Country.Text, txtDebtor1_d1.Text, lstDebtor1_Org_Type.SelectedValue, lstDebtor1_Org_Jurisdiction.SelectedValue, txtDebtor1_Org_ID.Text, IIf(chkDebtor1_Org_ID_None.Checked, "Y", "N"))
      Else
        sDebtor1 = rcbDebtor1.SelectedValue
      End If
      If chkDebtor1_RunSearch.Checked Then
        Dim sSR1 As String = IIf(chkSR1_All.Checked, "A", IIf(chkSR1_Unlapsed.Checked, "U", ""))
        Dim sCR1 As String = IIf(chkCR1_All.Checked, "A", IIf(chkCR1_Unlapsed.Checked, "U", ""))
        Dim sMoreDate As String = txtMoreDate1.Text
        Dim sMoreAddress As String = txtMoreAddress1.Text
        Dim sMoreName As String = txtMoreName1.Text
        Dim sMoreOther As String = txtMoreOther1.Text
                Dim sUS_ID As String = EnterSearch(sDebtor1, "", sSR1, "", sCR1, "", sMoreDate, sMoreAddress, sMoreName, sMoreOther, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", txtAdditional1.Text, "N", Session("UserID"), Session("company_rid"), Search_Charge_with_File, ddlLoanType.SelectedValue)
      End If

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
                Dim sUS_ID As String = EnterSearch(sDebtor2, "", sSR2, "", sCR2, "", sMoreDate, sMoreAddress, sMoreName, sMoreOther, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", txtAdditional2.Text, "N", Session("UserID"), Session("company_rid"), Search_Charge_with_File, ddlLoanType.SelectedValue)
      End If
    Catch ex As Exception
      lblMsg.Text = "Error adding debtor(s) - " & ex.ToString
      Exit Sub
    End Try
    

    Dim sAltDes As String = ""
    If chkAlt_DesignationL.Checked Then sAltDes = "L" Else sAltDes = " "
    If chkAlt_DesignationB.Checked Then sAltDes = "B" Else sAltDes = " "
    If chkAlt_DesignationC.Checked Then sAltDes = "C" Else sAltDes = " "
    If chkAlt_DesignationS.Checked Then sAltDes = "S" Else sAltDes = " "
    If chkAlt_DesignationA.Checked Then sAltDes = "A" Else sAltDes = " "
    If chkAlt_DesignationN.Checked Then sAltDes = "N" Else sAltDes = " "
    Dim sReqSearch As String = ""
    If chkReq_SearchA.Checked Then
      sReqSearch = "A"
    ElseIf chkReq_Search1.Checked Then
      sReqSearch = "1"
    ElseIf chkReq_Search2.Checked Then
      sReqSearch = "2"
    End If

    Dim sUF_ID As String = ""
    Try
            sSQL = "Insert Into ucc_financing (uf_debtor1,uf_debtor2,uf_secured_org_name,uf_secured_mailing_address," & _
            "uf_secured_city,uf_secured_state,uf_secured_zipcode,uf_secured_country,uf_finance_statement,uf_alt_designation," & _
            "uf_file_real_estate,uf_request_search,uf_loan_type,uf_reference_data,uf_date_submitted,uf_user_submitted,uf_charge,uf_company_id) Values (" & _
            sDebtor1 & "," & IIf(sDebtor2 <> "", sDebtor2, "Null") & "," & _
            "'" & lstSecured_Org_Name.SelectedValue.Replace("'", "''").ToUpper & "', " & _
            "'" & txtSecured_Mailing_Address.Text.Replace("'", "''").ToUpper & "', " & _
            "'" & txtSecured_City.Text.Replace("'", "''").ToUpper & "', " & _
            "'" & lstSecured_State.SelectedValue.Replace("'", "''").ToUpper & "', " & _
            "'" & txtSecured_Zip.Text.Replace("'", "''").ToUpper & "', " & _
            "'" & txtSecured_Country.Text.Replace("'", "''").ToUpper & "', " & _
            "'" & txtCollateral.Text.Replace("'", "''").ToUpper & "', " & _
            "'" & sAltDes & "', " & _
            "'" & IIf(chkReal_Estate.Checked, "Y", "N") & "', " & _
            "'" & sReqSearch & "', " & _
            "'" & ddlLoanType.SelectedValue & "', " & _
            "'" & txtReference_Data.Text.Replace("'", "''").ToUpper & "',getdate(),'" & Session("UserID") & "'," & _
            IIf(Filing_Charge <> "", Filing_Charge, "Null") & "," & Session("company_rid") & _
            "); Select Scope_Identity() "
      sUF_ID = ExecuteScalar(sSQL)
    Catch ex As Exception
      lblMsg.Text = "Error adding filing - " & ex.ToString
      Exit Sub
    End Try
    

    If pnlUCC1ad.Visible Then
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
                    Dim loan_type As String = ddlLoanType.SelectedValue
                    Dim sUS_ID As String = EnterSearch(sDebtor3, "", sSR3, "", sCR3, "", sMoreDate, sMoreAddress, sMoreName, sMoreOther, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", txtAdditional3.Text, "N", Session("UserID"), Session("company_rid"), Search_Charge_with_File, loan_type)
        End If
      Catch ex As Exception
        lblMsg.Text = "Error adding debtor #3 - " & ex.ToString
        Exit Sub
      End Try
      

      Dim sCovers As String = ""
      If chkAD_Timber.Checked Then sCovers = "T" Else sCovers = " "
      If chkAD_AsExtracted.Checked Then sCovers = "A" Else sCovers = " "
      If chkAD_Fixture_Filing.Checked Then sCovers = "F" Else sCovers = " "
      Dim sTrust As String = ""
      If chkAD_Transmitting_Utility.Checked Then
        sTrust = "T"
      ElseIf chkAD_Manufactured_Home.Checked Then
        sTrust = "M"
      ElseIf chkAD_Public_Finance.Checked Then
        sTrust = "P"
      End If

      'chkRealEstate - used to be with main form, but now in ad

      Dim sAD_ID As String
      Try
        sSQL = "Insert Into ucc_financing_ad (ufad_uf_id,ufad_debtor3,ufad_secured2,ufad_secured_is," & _
        "ufad_covers,ufad_misc,ufad_real_estate,ufad_record_owner,ufad_collateral,ufad_debtor_trust,ufad_debtor_is,ufad_status)" & _
        " Values (" & sUF_ID & "," & IIf(sDebtor3 <> "", sDebtor3, "Null") & ",Null,'','" & sCovers & "', " & _
        "'" & txtAD_Misc.Text.Replace("'", "''").ToUpper & "', " & _
        "'" & txtAD_Real_Estate.Text.Replace("'", "''").ToUpper & "', " & _
        "'" & txtAD_Record_Owner.Text.Replace("'", "''").ToUpper & "', " & _
        "'" & txtAD_Collateral.Text.Replace("'", "''").ToUpper & "', " & _
        "'" & sTrust & "','', " & _
        "'N'); Select Scope_Identity()"
        sAD_ID = ExecuteScalar(sSQL)
      Catch ex As Exception
        lblMsg.Text = "Error adding ad - " & ex.ToString
        Exit Sub
      End Try
      
    End If

    If pnlUCC1ap.Visible Then
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
                    Dim loan_type As String = ddlLoanType.SelectedValue
                    Dim sUS_ID As String = EnterSearch(sDebtor4, "", sSR4, "", sCR4, "", sMoreDate, sMoreAddress, sMoreName, sMoreOther, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", txtAdditional4.Text, "N", Session("UserID"), Session("company_rid"), Search_Charge_with_File, loan_type)
        End If
      Catch ex As Exception
        lblMsg.Text = "Error adding debtor #4 - " & ex.ToString
        Exit Sub
      End Try


      Try
        If rcbDebtor5.SelectedValue = "" Then
          'insert new debtor and get debtor_id
          If txtDebtor5_Org_Name.Text <> "" Or txtDebtor5_Ind_Last_Name.Text <> "" Then
            sDebtor5 = AddDebtor(Session("UserID"), Session("company_rid"), txtDebtor5_Org_Name.Text, txtDebtor5_Ind_Last_Name.Text, txtDebtor5_Ind_First_Name.Text, txtDebtor5_Ind_Middle_Name.Text, txtDebtor5_Ind_Suffix.Text, txtDebtor5_Mailing_Address.Text, txtDebtor5_City.Text, lstDebtor5_State.SelectedValue, txtDebtor5_Zip.Text, txtDebtor5_Country.Text, txtDebtor5_d1.Text, lstDebtor5_Org_Type.SelectedValue, lstDebtor5_Org_Jurisdiction.SelectedValue, txtDebtor5_Org_ID.Text, IIf(chkDebtor5_Org_ID_None.Checked, "Y", "N"))
          End If
        Else
          sDebtor5 = rcbDebtor5.SelectedValue
        End If
        If chkDebtor5_RunSearch.Checked Then
          Dim sSR5 As String = IIf(chkSR5_All.Checked, "A", IIf(chkSR5_Unlapsed.Checked, "U", ""))
          Dim sCR5 As String = IIf(chkCR5_All.Checked, "A", IIf(chkCR5_Unlapsed.Checked, "U", ""))
          Dim sMoreDate As String = txtMoreDate5.Text
          Dim sMoreAddress As String = txtMoreAddress5.Text
          Dim sMoreName As String = txtMoreName5.Text
                    Dim sMoreOther As String = txtMoreOther5.Text
                    Dim loan_type As String = ddlLoanType.SelectedValue
                    Dim sUS_ID As String = EnterSearch(sDebtor5, "", sSR5, "", sCR5, "", sMoreDate, sMoreAddress, sMoreName, sMoreOther, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", txtAdditional5.Text, "N", Session("UserID"), Session("company_rid"), Search_Charge_with_File, loan_type)
        End If
      Catch ex As Exception
        lblMsg.Text = "Error adding debtor #5 - " & ex.ToString
        Exit Sub
      End Try
      
      Try
        If rcbDebtor6.SelectedValue = "" Then
          'insert new debtor and get debtor_id
          If txtDebtor6_Org_Name.Text <> "" Or txtDebtor6_Ind_Last_Name.Text <> "" Then
            sDebtor6 = AddDebtor(Session("UserID"), Session("company_rid"), txtDebtor6_Org_Name.Text, txtDebtor6_Ind_Last_Name.Text, txtDebtor6_Ind_First_Name.Text, txtDebtor6_Ind_Middle_Name.Text, txtDebtor6_Ind_Suffix.Text, txtDebtor6_Mailing_Address.Text, txtDebtor6_City.Text, lstDebtor6_State.SelectedValue, txtDebtor6_Zip.Text, txtDebtor6_Country.Text, txtDebtor6_d1.Text, lstDebtor6_Org_Type.SelectedValue, lstDebtor6_Org_Jurisdiction.SelectedValue, txtDebtor6_Org_ID.Text, IIf(chkDebtor6_Org_ID_None.Checked, "Y", "N"))
          End If
        Else
          sDebtor6 = rcbDebtor6.SelectedValue
        End If
        If chkDebtor6_RunSearch.Checked Then
          Dim sSR6 As String = IIf(chkSR6_All.Checked, "A", IIf(chkSR6_Unlapsed.Checked, "U", ""))
          Dim sCR6 As String = IIf(chkCR6_All.Checked, "A", IIf(chkCR6_Unlapsed.Checked, "U", ""))
          Dim sMoreDate As String = txtMoreDate6.Text
          Dim sMoreAddress As String = txtMoreAddress6.Text
          Dim sMoreName As String = txtMoreName6.Text
                    Dim sMoreOther As String = txtMoreOther6.Text
                    Dim loan_type As String = ddlLoanType.SelectedValue
                    Dim sUS_ID As String = EnterSearch(sDebtor6, "", sSR6, "", sCR6, "", sMoreDate, sMoreAddress, sMoreName, sMoreOther, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", txtAdditional6.Text, "N", Session("UserID"), Session("company_rid"), Search_Charge_with_File, loan_type)
        End If
      Catch ex As Exception
        lblMsg.Text = "Error adding debtor #6 - " & ex.ToString
        Exit Sub
      End Try

      Dim sAP_ID As String
      Try
        sSQL = "Insert Into ucc_financing_ap (ufap_uf_id,ufap_misc,ufap_debtor4,ufap_debtor5,ufap_debtor6," & _
        "ufap_secured3,ufap_secured4,ufap_status) Values (" & sUF_ID & "," & _
        "'" & txtAP_Misc.Text.Replace("'", "''").ToUpper & "', " & _
        IIf(sDebtor4 <> "", sDebtor4, "Null") & "," & _
        IIf(sDebtor5 <> "", sDebtor5, "Null") & "," & _
        IIf(sDebtor6 <> "", sDebtor6, "Null") & "," & _
        "Null,Null, " & _
        "'N'); Select Scope_Identity()"
        sAP_ID = ExecuteScalar(sSQL)
      Catch ex As Exception
        lblMsg.Text = "Error adding ap - " & ex.ToString
        Exit Sub
      End Try
      
    End If

        SendEmailNew(0, 0, "A new UCC Financing Filing has been submitted.", "New UCC UCC Financing Filing submitted", IDC_Notify, "", True)

        Dim stateCheck As String
        Dim SQLstate As String



        Dim ckState As String
        ckState = lstOrg_State.selectedValue


        If ckState <> "IL" Then
            SendEmailNew(0, 0, "A new UCC has been submitted from out of state (" & ckState & ") at " & Date.Now & ".", "New out of state UCC", IDC_Notify, "", True)
        End If





            'where to redirect to, main page?
            Response.Redirect("main.aspx")
    End Sub

  Protected Sub chkShowUCC1ad_CheckedChanged(sender As Object, e As System.EventArgs) Handles chkShowUCC1ad.CheckedChanged
    If chkShowUCC1ad.Checked Then
      pnlUCC1ad.Visible = True
    Else
      pnlUCC1ad.Visible = False
    End If
  End Sub

  Protected Sub chkShowUCC1ap_CheckedChanged(sender As Object, e As System.EventArgs) Handles chkShowUCC1ap.CheckedChanged
    If chkShowUCC1ap.Checked Then
      pnlUCC1ap.Visible = True
    Else
      pnlUCC1ap.Visible = False
    End If
  End Sub

  Protected Sub lstCollateral_SelectedIndexChanged(sender As Object, e As System.EventArgs) Handles lstCollateral.SelectedIndexChanged
    txtCollateral.Text = lstCollateral.SelectedValue
    'lstCollateral
  End Sub

  Private Sub AutoFillCityState(ByRef txtAddress As TextBox, ByVal txtCity As TextBox, ByVal lstState As DropDownList)
    txtAddress.Text = txtCity.Text & ", " & lstState.SelectedValue
  End Sub

  Protected Sub chkDebtor1_RunSearch_CheckedChanged(sender As Object, e As System.EventArgs) Handles chkDebtor1_RunSearch.CheckedChanged
    If chkDebtor1_RunSearch.Checked Then
      trSearch1.Visible = True
      AutoFillCityState(txtMoreAddress1, txtDebtor1_City, lstDebtor1_State)
    Else
      trSearch1.Visible = False
    End If
  End Sub

  Protected Sub chkDebtor2_RunSearch_CheckedChanged(sender As Object, e As System.EventArgs) Handles chkDebtor2_RunSearch.CheckedChanged
    If chkDebtor2_RunSearch.Checked Then
      trSearch2.Visible = True
      AutoFillCityState(txtMoreAddress2, txtDebtor2_City, lstDebtor2_State)
    Else
      trSearch2.Visible = False
    End If
  End Sub

  Protected Sub chkDebtor3_RunSearch_CheckedChanged(sender As Object, e As System.EventArgs) Handles chkDebtor3_RunSearch.CheckedChanged
    If chkDebtor3_RunSearch.Checked Then
      trSearch3.Visible = True
      AutoFillCityState(txtMoreAddress3, txtDebtor3_City, lstDebtor3_State)
    Else
      trSearch3.Visible = False
    End If
  End Sub

  Protected Sub chkDebtor4_RunSearch_CheckedChanged(sender As Object, e As System.EventArgs) Handles chkDebtor4_RunSearch.CheckedChanged
    If chkDebtor4_RunSearch.Checked Then
      trSearch4.Visible = True
      AutoFillCityState(txtMoreAddress4, txtDebtor4_City, lstDebtor4_State)
    Else
      trSearch4.Visible = False
    End If
  End Sub

  Protected Sub chkDebtor5_RunSearch_CheckedChanged(sender As Object, e As System.EventArgs) Handles chkDebtor5_RunSearch.CheckedChanged
    If chkDebtor5_RunSearch.Checked Then
      trSearch5.Visible = True
      AutoFillCityState(txtMoreAddress5, txtDebtor5_City, lstDebtor5_State)
    Else
      trSearch5.Visible = False
    End If
  End Sub

  Protected Sub chkDebtor6_RunSearch_CheckedChanged(sender As Object, e As System.EventArgs) Handles chkDebtor6_RunSearch.CheckedChanged
    If chkDebtor6_RunSearch.Checked Then
      trSearch6.Visible = True
      AutoFillCityState(txtMoreAddress6, txtDebtor6_City, lstDebtor6_State)
    Else
      trSearch6.Visible = False
    End If
  End Sub

  Protected Sub chkSR1_All_CheckedChanged(sender As Object, e As System.EventArgs) Handles chkSR1_All.CheckedChanged
    If chkSR1_All.Checked Then
      chkSR1_Unlapsed.Checked = False
    End If
  End Sub

  Protected Sub chkSR1_Unlapsed_CheckedChanged(sender As Object, e As System.EventArgs) Handles chkSR1_Unlapsed.CheckedChanged
    If chkSR1_Unlapsed.Checked Then
      chkSR1_All.Checked = False
    End If
  End Sub

  Protected Sub chkCR1_All_CheckedChanged(sender As Object, e As System.EventArgs) Handles chkCR1_All.CheckedChanged
    If chkCR1_All.Checked Then
      chkCR1_Unlapsed.Checked = False
    End If
  End Sub

  Protected Sub chkCR1_Unlapsed_CheckedChanged(sender As Object, e As System.EventArgs) Handles chkCR1_Unlapsed.CheckedChanged
    If chkCR1_Unlapsed.Checked Then
      chkCR1_All.Checked = False
    End If
  End Sub

  Protected Sub chkSR2_All_CheckedChanged(sender As Object, e As System.EventArgs) Handles chkSR2_All.CheckedChanged
    If chkSR2_All.Checked Then
      chkSR2_Unlapsed.Checked = False
    End If
  End Sub

  Protected Sub chkSR2_Unlapsed_CheckedChanged(sender As Object, e As System.EventArgs) Handles chkSR2_Unlapsed.CheckedChanged
    If chkSR2_Unlapsed.Checked Then
      chkSR2_All.Checked = False
    End If
  End Sub

  Protected Sub chkCR2_All_CheckedChanged(sender As Object, e As System.EventArgs) Handles chkCR2_All.CheckedChanged
    If chkCR2_All.Checked Then
      chkCR2_Unlapsed.Checked = False
    End If
  End Sub

  Protected Sub chkCR2_Unlapsed_CheckedChanged(sender As Object, e As System.EventArgs) Handles chkCR2_Unlapsed.CheckedChanged
    If chkCR2_Unlapsed.Checked Then
      chkCR2_All.Checked = False
    End If
  End Sub

  Protected Sub chkSR3_All_CheckedChanged(sender As Object, e As System.EventArgs) Handles chkSR3_All.CheckedChanged
    If chkSR3_All.Checked Then
      chkSR3_Unlapsed.Checked = False
    End If
  End Sub

  Protected Sub chkSR3_Unlapsed_CheckedChanged(sender As Object, e As System.EventArgs) Handles chkSR3_Unlapsed.CheckedChanged
    If chkSR3_Unlapsed.Checked Then
      chkSR3_All.Checked = False
    End If
  End Sub

  Protected Sub chkCR3_All_CheckedChanged(sender As Object, e As System.EventArgs) Handles chkCR3_All.CheckedChanged
    If chkCR3_All.Checked Then
      chkCR3_Unlapsed.Checked = False
    End If
  End Sub

  Protected Sub chkCR3_Unlapsed_CheckedChanged(sender As Object, e As System.EventArgs) Handles chkCR3_Unlapsed.CheckedChanged
    If chkCR3_Unlapsed.Checked Then
      chkCR3_All.Checked = False
    End If
  End Sub

  Protected Sub chkSR4_All_CheckedChanged(sender As Object, e As System.EventArgs) Handles chkSR4_All.CheckedChanged
    If chkSR4_All.Checked Then
      chkSR4_Unlapsed.Checked = False
    End If
  End Sub

  Protected Sub chkSR4_Unlapsed_CheckedChanged(sender As Object, e As System.EventArgs) Handles chkSR4_Unlapsed.CheckedChanged
    If chkSR4_Unlapsed.Checked Then
      chkSR4_All.Checked = False
    End If
  End Sub

  Protected Sub chkCR4_All_CheckedChanged(sender As Object, e As System.EventArgs) Handles chkCR4_All.CheckedChanged
    If chkCR4_All.Checked Then
      chkCR4_Unlapsed.Checked = False
    End If
  End Sub

  Protected Sub chkCR4_Unlapsed_CheckedChanged(sender As Object, e As System.EventArgs) Handles chkCR4_Unlapsed.CheckedChanged
    If chkCR4_Unlapsed.Checked Then
      chkCR4_All.Checked = False
    End If
  End Sub

  Protected Sub chkSR5_All_CheckedChanged(sender As Object, e As System.EventArgs) Handles chkSR5_All.CheckedChanged
    If chkSR5_All.Checked Then
      chkSR5_Unlapsed.Checked = False
    End If
  End Sub

  Protected Sub chkSR5_Unlapsed_CheckedChanged(sender As Object, e As System.EventArgs) Handles chkSR5_Unlapsed.CheckedChanged
    If chkSR5_Unlapsed.Checked Then
      chkSR5_All.Checked = False
    End If
  End Sub

  Protected Sub chkCR5_All_CheckedChanged(sender As Object, e As System.EventArgs) Handles chkCR5_All.CheckedChanged
    If chkCR5_All.Checked Then
      chkCR5_Unlapsed.Checked = False
    End If
  End Sub

  Protected Sub chkCR5_Unlapsed_CheckedChanged(sender As Object, e As System.EventArgs) Handles chkCR5_Unlapsed.CheckedChanged
    If chkCR5_Unlapsed.Checked Then
      chkCR5_All.Checked = False
    End If
  End Sub

  Protected Sub chkSR6_All_CheckedChanged(sender As Object, e As System.EventArgs) Handles chkSR6_All.CheckedChanged
    If chkSR6_All.Checked Then
      chkSR6_Unlapsed.Checked = False
    End If
  End Sub

  Protected Sub chkSR6_Unlapsed_CheckedChanged(sender As Object, e As System.EventArgs) Handles chkSR6_Unlapsed.CheckedChanged
    If chkSR6_Unlapsed.Checked Then
      chkSR6_All.Checked = False
    End If
  End Sub

  Protected Sub chkCR6_All_CheckedChanged(sender As Object, e As System.EventArgs) Handles chkCR6_All.CheckedChanged
    If chkCR6_All.Checked Then
      chkCR6_Unlapsed.Checked = False
    End If
  End Sub

  Protected Sub chkCR6_Unlapsed_CheckedChanged(sender As Object, e As System.EventArgs) Handles chkCR6_Unlapsed.CheckedChanged
    If chkCR6_Unlapsed.Checked Then
      chkCR6_All.Checked = False
    End If
  End Sub


End Class
