
Partial Class login
  Inherits System.Web.UI.Page

  Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
    If Request.Form("name") <> "" Then
      Do_Login()
    End If
    'Response.Write("Name: " & Request.Form("name"))
    'Response.Write("Pass: " & Request.Form("pass"))
    'Response.Write("Pass: " & Server.HtmlDecode(Request.Form("enc_pass")))
  End Sub

  Private Sub Do_Login()
    'Response.Write("DoLogin<br />")
    Dim UserName As String = Request.Form("name") & ""
    Dim sGuid As String = Request.Form("guidpass") & ""
		'Dim Password As String = Request.Form("pass") & ""
		'Dim EncPassword As String  '= Request.Form("enc_pass") & ""
		'Dim rc4 As New rc4encrypt()
		'rc4.Password = strEncPassSring
		'rc4.PlainText = Password
		'EncPassword = rc4.EnDeCrypt()
		'rc4 = Nothing

		Dim sSQL As String = "Select u.*, isnull(s.ucc_app,'N') as ucc_app, isnull(s.name,isnull(u.company,'')) as sub_name, " &
			"isnull(s.state,'') as sub_state, isnull(s.parent_company_id,'') as parent_company_id " &
			"From Users u left outer join subscriber s on u.company_id = s.company_id " &
			"Where (ucc_app = 'Y' or level1 = '2') and UserID='" & UserName.Replace("'", "''") & "' " &
			"and AppTransGuid = '" & sGuid & "'"
		'"And ((Password = '" & Password.Replace("'", "''") & "' and EncryptedPassword = 'N') or (Password = '" & EncPassword.Replace("'", "''") & "' and EncryptedPassword = 'Y'))"
		Dim dtUser As DataTable = FillDataTable(sSQL)
    If dtUser.Rows.Count > 0 Then
      'company_rid = rs("company_id")
      Session("validuser") = True
      Session("name") = dtUser.Rows(0).Item("name")
      Session("UserID") = dtUser.Rows(0).Item("UserID")
			Session("company") = dtUser.Rows(0).Item("sub_name")
			Session("ucc_state") = dtUser.Rows(0).Item("sub_state")
			Session("company_rid") = dtUser.Rows(0).Item("company_id")
			Session("parent_company_id") = dtUser.Rows(0).Item("parent_company_id") & ""
			Session("ucc_app") = dtUser.Rows(0).Item("ucc_app")
      RunCommand("update Users set AppTransGuid = null Where UserID = '" & UserName.Replace("'", "''") & "'")
      If dtUser.Rows(0).Item("level1") = "2" Then
        Session("admin") = "2"
        Response.Redirect("ucc_admin.aspx")
      Else
        Session("admin") = "0"
      End If
      sSQL = "Select company_id from subscriber where parent_company_id = " & Session("company_rid")
      Dim dtCom As DataTable = FillDataTable(sSQL)
      If dtCom.Rows.Count > 0 Then
        Session("has_sub_companies") = "Y"
      Else
        Session("has_sub_companies") = "N"
      End If
      dtCom.Dispose()
      dtCom = Nothing
      Response.Redirect("main.aspx")
    Else
      'error
      Response.Write("Error - " & sGuid)
    End If
    dtUser.Dispose()
    dtUser = Nothing
  End Sub
End Class
