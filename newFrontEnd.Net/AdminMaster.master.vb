
Partial Class AdminMaster
  Inherits System.Web.UI.MasterPage

  Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
    If Session("validuser") <> True Then
      Response.Redirect("default.aspx?msg=You must login")
    End If
    If Session("admin") <> 2 Then
      Response.Redirect("default.aspx?msg=Access denied")
    End If

    If Not Page.IsPostBack Then
      lblUser.Text = Session("name")
    End If
  End Sub
End Class

