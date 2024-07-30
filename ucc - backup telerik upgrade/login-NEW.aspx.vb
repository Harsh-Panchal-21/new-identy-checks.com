
Partial Class login
  Inherits System.Web.UI.Page

  Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
    If Request.Form("hidGUIDA") <> "" Then
      Do_Login()
    End If
  End Sub

  Private Sub Do_Login()
    'Dim UserName As String = Request.Form("name") & ""
    'Dim Password As String = Request.Form("pass") & ""
	Dim strGUIDA As String = Request.Form("hidGUIDA")
	Dim strGUIDB As String = Request.Form("hidGUIDB")

	Dim strSQL as string = "Select u.*, isnull(s.ucc_app,'N') as ucc_app, isnull(s.name,isnull(u.company,'')) as company " & _
		"From USERS u left outer join subscriber s on u.company_id = s.company_id Where (ucc_app = 'Y' or level1 = '2') and UserID in " & _
        "(Select USER_RID From APP_LOGIN_SECURITY Where " & _
        "GUID_STRINGA = '" & strGUIDA & "' And GUID_STRINGB = '" & strGUIDB & "')"
    'Dim sSQL As String = "Select u.*, isnull(s.ucc_app,'N') as ucc_app, isnull(s.name,isnull(u.company,'')) as company " & _
    '  "From Users u left outer join subscriber s on u.company_id = s.company_id " & _
    '  "Where (ucc_app = 'Y' or level1 = '2') and UserID='" & UserName.Replace("'", "''") & "' And Password = '" & Password.Replace("'", "''") & "'"
    Dim dtUser As DataTable = FillDataTable(strSQL)
    If dtUser.Rows.Count > 0 Then
      'company_rid = rs("company_id")
      Session("validuser") = True
      Session("name") = dtUser.Rows(0).Item("name")
      Session("UserID") = dtUser.Rows(0).Item("UserID")
      Session("company") = dtUser.Rows(0).Item("company")
      Session("company_rid") = dtUser.Rows(0).Item("company_id")
      Session("ucc_app") = dtUser.Rows(0).Item("ucc_app")
      If dtUser.Rows(0).Item("level1") = "2" Then
        Session("admin") = "2"
        Response.Redirect("ucc_admin.aspx")
      Else
        Session("admin") = "0"
      End If
      strSQL = "Select company_id from subscriber where parent_company_id = " & Session("company_rid")
      Dim dtCom As DataTable = FillDataTable(strSQL)
      If dtCom.Rows.Count > 0 Then
        Session("has_sub_companies") = "Y"
      Else
        Session("has_sub_companies") = "N"
      End If
	  strSQL = "Delete From APP_LOGIN_SECURITY Where " & _
               "GUID_STRINGA = '" & strGUIDA & "' And GUID_STRINGB = '" & strGUIDB & "'"
      RunCommand(strSQL)
      dtCom.Dispose()
      dtCom = Nothing
      Response.Redirect("main.aspx")
    Else
      'error
	  response.write("error")
    End If
    dtUser.Dispose()
    dtUser = Nothing
  End Sub
End Class
