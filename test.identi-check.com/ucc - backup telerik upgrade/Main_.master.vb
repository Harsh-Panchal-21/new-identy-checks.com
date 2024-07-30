
Partial Class MainMaster
  Inherits System.Web.UI.MasterPage


  Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
    If Session("UserID") = "" Then
      Response.Redirect("\index.asp?msg=Your session timed out, please login again.")
    End If

    If Not Page.IsPostBack Then
      If Session("admin") = "2" Then
        rmOne.Visible = False
        rmAdmin.Visible = True
      Else
        rmOne.Visible = True
        rmAdmin.Visible = False
      End If
    End If
  End Sub

  Public Sub SetWelcomeName(ByVal sName As String)
    lblWelcomeName.Text = sName
  End Sub

  Public Sub Testing()
    'Session("validuser") = True
    'Session("name") = "Matt Barham"
    'Session("UserID") = "matt_ucc"
    'Session("company") = "KingTech"
    'Session("company_rid") = "129"
    'Session("ucc_app") = "Y"
  End Sub
End Class

