Imports System.Data.SqlClient
Imports Telerik.Web.UI

Partial Class ucc11
	Inherits System.Web.UI.Page

	Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
		If Not Page.IsPostBack Then
			Dim myMaster As MainMaster = CType(MyBase.Master, MainMaster)

			'myMaster.Testing()
			myMaster.SetWelcomeName(Session("name"))

			Dim sState As String = Session("ucc_state") & ""
			If sState.Trim = "" Then sState = "IL"
			'change based on state of county office

			If sState = "WI" Then
				Try
					'ddlLoanType.
					ddlLoanType.SelectedIndex = -1
					ddlLoanType.Items.FindByValue("MAL").Selected = True
				Catch ex As Exception

				End Try
			End If

			lstOrg_State.DataSource = FillDataTable("Select * From state_list order by state_name")
			lstOrg_State.DataTextField = "STATE_ABBR"
			lstOrg_State.DataValueField = "STATE_ABBR"
			lstOrg_State.DataBind()
			lstOrg_State.SelectedIndex = -1
			lstOrg_State.Items.FindByValue(sState).Selected = True

			'PdfManipulation.ExtractPdfPage(UCC1_PDF, 1, UCC1_PDF.Replace(".pdf", "_mine.pdf"))
			'PdfManipulation.ExtractPdfPage(UCC1ad_PDF, 1, UCC1ad_PDF.Replace(".pdf", "_mine.pdf"))
			'PdfManipulation.ExtractPdfPage(UCC1ap_PDF, 1, UCC1ap_PDF.Replace(".pdf", "_mine.pdf"))
			'PdfManipulation.ExtractPdfPage(UCC3_PDF, 1, UCC3_PDF.Replace(".pdf", "_mine.pdf"))
			'PdfManipulation.ExtractPdfPage(UCC3ad_PDF, 1, UCC3ad_PDF.Replace(".pdf", "_mine.pdf"))
			'PdfManipulation.ExtractPdfPage(UCC11_PDF, 1, UCC11_PDF.Replace(".pdf", "_mine.pdf"))
			'PdfManipulation.ExtractPdfPage("\webs\test.identi-check.com\ucc\pdf\UCCfilling_Search.pdf", 1, "c:\webs\test.identi-check.com\ucc\pdf\ucc1_file_1.pdf")
			'PdfManipulation.ExtractPdfPage("\webs\test.identi-check.com\ucc\pdf\UCCfilling_Search.pdf", 2, "c:\webs\test.identi-check.com\ucc\pdf\ucc1_term_a.pdf")
			'PdfManipulation.ExtractPdfPage("\webs\test.identi-check.com\ucc\pdf\UCCfilling_Search.pdf", 3, "c:\webs\test.identi-check.com\ucc\pdf\ucc1_term_b.pdf")
		End If
	End Sub

	Private Shared Function GetStatusMessage(ByVal offset As Integer, ByVal total As Integer) As String
    If total <= 0 Then
      Return "No matches"
    End If

    Return [String].Format("Items <b>1</b>-<b>{0}</b> out of <b>{1}</b>", offset, total)
  End Function

	Private Shared Function GetData(ByVal text As String, ByVal sFrom As String, ByVal sCompanyID As String, ByVal sParentCompanyID As String) As DataTable
		Dim sSQL As String = "Select ud_id, isnull(ud_org_name,'') + ' - ' + isnull(ud_ind_first_name,'') + ' ' + isnull(ud_ind_middle_name,'') + ' ' + isnull(ud_ind_last_name,'') as 'disp_name', " &
				"ud_id as 'key_name' From ucc_debtor " &
				"where ud_company_id in (Select company_id from subscriber where ucc_app = 'Y' and (company_id = " & sCompanyID & " or parent_company_id = " & sParentCompanyID & " or parent_company_id = " & sCompanyID & ")) " &
				" and " &
				"(isnull(ud_ind_first_name,'') + ' ' + isnull(ud_ind_middle_name,'') + ' ' + isnull(ud_ind_last_name,'') like '%' + @text + '%' or " &
				" isnull(ud_org_name,'') like '%' + @text + '%') " &
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
			Dim data As DataTable = GetData(e.Text, "", Session("company_rid") & "", Session("parent_company_id") & "")

			Dim itemOffset As Integer = e.NumberOfItems
      Dim endOffset As Integer = Math.Min(itemOffset + ItemsPerRequest, data.Rows.Count)
      e.EndOfItems = endOffset = data.Rows.Count

      For i As Integer = itemOffset To endOffset - 1
        rcbDebtor1.Items.Add(New Telerik.Web.UI.RadComboBoxItem(data.Rows(i)("disp_name").ToString(), data.Rows(i)("key_name").ToString()))
      Next

      e.Message = GetStatusMessage(endOffset, data.Rows.Count)
    End If
  End Sub

  Protected Sub rcbDebtor1_SelectedIndexChanged(sender As Object, e As Telerik.Web.UI.RadComboBoxSelectedIndexChangedEventArgs) Handles rcbDebtor1.SelectedIndexChanged
    Dim txt1 As New TextBox
    Dim txt2 As New TextBox
    Dim txt3 As New TextBox
    Dim txt4 As New TextBox
    Dim txt5 As New TextBox
    Dim txt6 As New TextBox
    Dim txt7 As New TextBox
    Dim txt8 As New TextBox
    Dim txt9 As New TextBox
    Dim lst1 As New DropDownList
    Dim chk1 As New CheckBox

		'fill in debtor info, lock fields?
		FillDebtorInfo(rcbDebtor1.SelectedValue, Session("company_rid") & "", Session("parent_company_id") & "", txtDebtor1_Org_Name, txtDebtor1_Ind_Last_Name, txtDebtor1_Ind_First_Name, txtDebtor1_Ind_Middle_Name, txtDebtor1_Ind_Suffix, txt1, txt2, lst1, txt4, txt5, txt6, txt7, txt8, txt9, chk1)
	End Sub

  Protected Sub btnSubmit_Click(sender As Object, e As System.EventArgs) Handles btnSubmit.Click
    Dim sMsg As String = ""
		'are they required on searches
		Dim ckState As String
		ckState = lstOrg_State.SelectedValue
		If lstOrg_State.SelectedValue = "" Then
			sMsg = sMsg & "You must provide the state the corporation was organized in.<br />"
		End If

		If ckState = "IL" Then
			If ddlLoanType.SelectedValue = "0" Then
				sMsg = sMsg & "You must choose a Loan Type.<br />"
			End If
			If ddlLoanType.SelectedValue = "FSFL" And ddlFY.SelectedValue = "0" Then
				'uf_fsfl_fy
				sMsg = sMsg & "You must provide the Fiscal Year with FSFL Loans.<br />"
			End If
		End If

		If sMsg <> "" Then
      lblMsg.Text = sMsg
      Exit Sub
    End If

    Dim sDebtor1 As String = ""
    If rcbDebtor1.SelectedValue = "" Then
      'insert new debtor and get debtor_id
      Try
        sDebtor1 = AddDebtor(Session("UserID"), Session("company_rid"), txtDebtor1_Org_Name.Text, txtDebtor1_Ind_Last_Name.Text, txtDebtor1_Ind_First_Name.Text, txtDebtor1_Ind_Middle_Name.Text, txtDebtor1_Ind_Suffix.Text)
      Catch ex As Exception
        lblMsg.Text = "Error adding debtor: " & ex.ToString
        Exit Sub
      End Try
    Else
      sDebtor1 = rcbDebtor1.SelectedValue
    End If

    Dim sSR As String = IIf(chkSR_All.Checked, "A", IIf(chkSR_Unlapsed.Checked, "U", ""))
    Dim sCR As String = IIf(chkCR_All.Checked, "A", IIf(chkCR_Unlapsed.Checked, "U", ""))
    Dim sMoreDate As String = txtMoreDate.Text
    Dim sMoreAddress As String = txtMoreAddress.Text
    Dim sMoreName As String = txtMoreName.Text
    Dim sMoreOther As String = txtMoreOther.Text

    Dim sRec1 As String = txtSCO_RN1.Text.Replace("'", "''")
    Dim sRec2 As String = txtSCO_RN2.Text.Replace("'", "''")
    Dim sRec3 As String = txtSCO_RN3.Text.Replace("'", "''")
    Dim sRec4 As String = txtSCO_RN4.Text.Replace("'", "''")
    Dim sRec5 As String = txtSCO_RN5.Text.Replace("'", "''")
    Dim sRec6 As String = txtSCO_RN6.Text.Replace("'", "''")
    Dim sDate1 As String = txtSCO_DRF1.Text.Replace("'", "''")
    Dim sDate2 As String = txtSCO_DRF2.Text.Replace("'", "''")
    Dim sDate3 As String = txtSCO_DRF3.Text.Replace("'", "''")
    Dim sDate4 As String = txtSCO_DRF4.Text.Replace("'", "''")
    Dim sDate5 As String = txtSCO_DRF5.Text.Replace("'", "''")
    Dim sDate6 As String = txtSCO_DRF6.Text.Replace("'", "''")
    Dim sType1 As String = txtSCO_Type1.Text.Replace("'", "''")
    Dim sType2 As String = txtSCO_Type2.Text.Replace("'", "''")
    Dim sType3 As String = txtSCO_Type3.Text.Replace("'", "''")
    Dim sType4 As String = txtSCO_Type4.Text.Replace("'", "''")
    Dim sType5 As String = txtSCO_Type5.Text.Replace("'", "''")
    Dim sType6 As String = txtSCO_Type6.Text.Replace("'", "''")
    Dim us_loan_type As String = ddlLoanType.SelectedValue.ToString
    Dim us_fsfl_fy As String = ddlFY.SelectedValue.ToString

    Try
			Dim sUS_ID As String = EnterSearch(sDebtor1, "", sSR, "", sCR, "", sMoreDate, sMoreAddress, sMoreName, sMoreOther, sRec1, sDate1, sType1, sRec2, sDate2, sType2, sRec3, sDate3, sType3, sRec4, sDate4, sType4, sRec5, sDate5, sType5, sRec6, sDate6, sType6, txtAdditional.Text.Replace("'", "''"), "N", Session("UserID"), Session("company_rid"), Search_Charge, us_loan_type, us_fsfl_fy, ckState)
		Catch ex As Exception
      lblMsg.Text = "<br />Debtor added, but there was an error submitting the search. - " & ex.ToString
      Exit Sub
    End Try

		SendEmailNew(0, 0, "A new UCC Search has been submitted for " & ckState & ".", "New UCC Search submitted for " & ckState & "", IDC_Notify, "", True)


		If ckState <> "IL" And ckState <> "WI" Then
			SendEmailNew(0, 0, "A new UCC has been submitted from out of state (" & ckState & ") at " & Date.Now & ".", "New out of state UCC", IDC_Notify, "", True)
		End If

		Response.Redirect("main.aspx")
  End Sub

  Protected Sub btnSubmitStay_Click(sender As Object, e As System.EventArgs) Handles btnSubmitStay.Click
		Dim sMsg As String = ""
		Dim ckState As String
		ckState = lstOrg_State.SelectedValue
		If lstOrg_State.SelectedValue = "" Then
			sMsg = sMsg & "You must provide the state the corporation was organized in.<br />"
		End If

		If ckState = "IL" Then
			If ddlLoanType.SelectedValue = "0" Then
				sMsg = sMsg & "You must choose a Loan Type.<br />"
			End If
			If ddlLoanType.SelectedValue = "FSFL" And ddlFY.SelectedValue = "0" Then
				'uf_fsfl_fy
				sMsg = sMsg & "You must provide the Fiscal Year with FSFL Loans.<br />"
			End If
		End If


		If sMsg <> "" Then
      lblMsg.Text = sMsg
      Exit Sub
    End If

    Dim sDebtor1 As String = ""
    If rcbDebtor1.SelectedValue = "" Then
      'insert new debtor and get debtor_id
      Try
        sDebtor1 = AddDebtor(Session("UserID"), Session("company_rid"), txtDebtor1_Org_Name.Text, txtDebtor1_Ind_Last_Name.Text, txtDebtor1_Ind_First_Name.Text, txtDebtor1_Ind_Middle_Name.Text, txtDebtor1_Ind_Suffix.Text)
      Catch ex As Exception
        lblMsg.Text = "Error adding debtor: " & ex.ToString
        Exit Sub
      End Try
    Else
      sDebtor1 = rcbDebtor1.SelectedValue
    End If

    Dim sSR As String = IIf(chkSR_All.Checked, "A", IIf(chkSR_Unlapsed.Checked, "U", ""))
    Dim sCR As String = IIf(chkCR_All.Checked, "A", IIf(chkCR_Unlapsed.Checked, "U", ""))
    Dim sMoreDate As String = txtMoreDate.Text
    Dim sMoreAddress As String = txtMoreAddress.Text
    Dim sMoreName As String = txtMoreName.Text
    Dim sMoreOther As String = txtMoreOther.Text

    Dim sRec1 As String = txtSCO_RN1.Text.Replace("'", "''")
    Dim sRec2 As String = txtSCO_RN2.Text.Replace("'", "''")
    Dim sRec3 As String = txtSCO_RN3.Text.Replace("'", "''")
    Dim sRec4 As String = txtSCO_RN4.Text.Replace("'", "''")
    Dim sRec5 As String = txtSCO_RN5.Text.Replace("'", "''")
    Dim sRec6 As String = txtSCO_RN6.Text.Replace("'", "''")
    Dim sDate1 As String = txtSCO_DRF1.Text.Replace("'", "''")
    Dim sDate2 As String = txtSCO_DRF2.Text.Replace("'", "''")
    Dim sDate3 As String = txtSCO_DRF3.Text.Replace("'", "''")
    Dim sDate4 As String = txtSCO_DRF4.Text.Replace("'", "''")
    Dim sDate5 As String = txtSCO_DRF5.Text.Replace("'", "''")
    Dim sDate6 As String = txtSCO_DRF6.Text.Replace("'", "''")
    Dim sType1 As String = txtSCO_Type1.Text.Replace("'", "''")
    Dim sType2 As String = txtSCO_Type2.Text.Replace("'", "''")
    Dim sType3 As String = txtSCO_Type3.Text.Replace("'", "''")
    Dim sType4 As String = txtSCO_Type4.Text.Replace("'", "''")
    Dim sType5 As String = txtSCO_Type5.Text.Replace("'", "''")
    Dim sType6 As String = txtSCO_Type6.Text.Replace("'", "''")
    Dim us_loan_type As String = ddlLoanType.SelectedValue.ToString
    Dim us_fsfl_fy As String = ddlFY.SelectedValue.ToString

    Try
			'Dim sUS_ID As String = EnterSearch(sDebtor1, "", sSR, "", sCR, "", sRec1, sDate1, sType1, sRec2, sDate2, sType2, sRec3, sDate3, sType3, sRec4, sDate4, sType4, sRec5, sDate5, sType5, sRec6, sDate6, sType6, txtAdditional.Text.Replace("'", "''"), "N", Session("UserID"), Session("company_rid"), Search_Charge)
			Dim sUS_ID As String = EnterSearch(sDebtor1, "", sSR, "", sCR, "", sMoreDate, sMoreAddress, sMoreName, sMoreOther, sRec1, sDate1, sType1, sRec2, sDate2, sType2, sRec3, sDate3, sType3, sRec4, sDate4, sType4, sRec5, sDate5, sType5, sRec6, sDate6, sType6, txtAdditional.Text.Replace("'", "''"), "N", Session("UserID"), Session("company_rid"), Search_Charge, us_loan_type, us_fsfl_fy, ckState)
		Catch ex As Exception
      lblMsg.Text = "<br />Debtor added, but there was an error submitting the search. - " & ex.ToString
      Exit Sub
    End Try

    rcbDebtor1.SelectedValue = ""
    rcbDebtor1.Text = ""
    rcbDebtor1.ClearSelection()

		SendEmailNew(0, 0, "A new UCC Search has been submitted for " & ckState & ".", "New UCC Search submitted for " & ckState & "", IDC_Notify, "", True)


		If ckState <> "IL" And ckState <> "WI" Then
			SendEmailNew(0, 0, "A new UCC has been submitted from out of state (" & ckState & ") at " & Date.Now & ".", "New out of state UCC", IDC_Notify, "", True)
		End If

		lblMsg.Text = "<br />Search Entered. Please change the names and submit again for the name variation."
  End Sub
End Class
