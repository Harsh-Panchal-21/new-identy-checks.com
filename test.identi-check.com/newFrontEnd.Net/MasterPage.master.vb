
Partial Class MasterPage
  Inherits System.Web.UI.MasterPage

  Protected Sub btnLogin_Click(sender As Object, e As System.EventArgs) Handles btnLogin.Click
    If txtUserID.Text.Trim = "" Then
      lblLoginMsg.Text = " Please enter your user name!"
      Exit Sub
    ElseIf txtPassword.Text.Trim = "" Then
      lblLoginMsg.Text = " Please enter your password!"
      Exit Sub
    Else
      '  UserID = Replace(Request.Form("UserID"), "'", "''")
      '  Password = Replace(Request.Form("Password"), "'", "''")
      '  'level="Individual"
      Dim sSQL As String = "Select u.*, isnull(s.ucc_app,'N') as ucc_app, isnull(s.name,isnull(u.company,'')) as company " & _
       "From Users u left outer join subscriber s on u.company_id = s.company_id " & _
       "Where UserID='" & txtUserID.Text.Trim.Replace("'", "''") & "' And Password = '" & txtPassword.Text.Trim.Replace("'", "''") & "'"
      Dim dtUser As DataTable = FillDataTable(sSQL)
      If dtUser.Rows.Count > 0 Then
        Dim company_rid As String = dtUser.Rows(0).Item("company_id")
        Dim company As String = dtUser.Rows(0).Item("company") & ""
        Session("validuser") = True
        Session("name") = dtUser.Rows(0).Item("name")
        Session("UserID") = dtUser.Rows(0).Item("UserID")
        Session("company") = company
        Session("company_rid") = company_rid
        Session("ucc_app") = dtUser.Rows(0).Item("ucc_app")
        If dtUser.Rows(0).Item("level1") = "2" Then
          Session("admin") = 2
          'Session("pass") = Request.Form("Password")
          Response.Redirect("admin.aspx?company_id=" & company_rid)
        Else
          Session("admin") = 0
        End If
        sSQL = "Insert Into logins (date_time,userid,company_id,company_name,ip_address) Values " & _
         " (GETDATE(),'" & txtUserID.Text.Trim.Replace("'", "''") & "'," & company_rid & ",'" & company.Replace("'", "''") & "','" & Request.ServerVariables("REMOTE_ADDR") & "')"
        RunCommand(sSQL)
        If dtUser.Rows(0).Item("ucc_app") = "Y" Then
          'response.redirect "ucc_main.asp?company_id=" & company_rid
          'Session("pass") = Request.Form("Password")
          Response.Redirect("EnterUCC.aspx")
          'redo by inserting quid into database with username
        Else
          Response.Redirect("main.aspx?company_id=" & company_rid)
        End If
      Else
        lblLoginMsg.Text = "Login failed, please try again"
        Exit Sub
      End If
    End If
  End Sub
End Class

