
Partial Class Admin1
  Inherits System.Web.UI.Page

  Protected Sub rgCompany_NeedDataSource(sender As Object, e As Telerik.Web.UI.GridNeedDataSourceEventArgs) Handles rgCompany.NeedDataSource
    rgCompany.DataSource = FillDataTable("Select * From candidate Where hide <> 'Y' and id > 0")
  End Sub

  Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
    If Session("admin") = 2 Then
      rgCompany.Columns.FindByUniqueName("InputResult").Visible = False
      'hide input result column

      'change delete column if candidate has been deleted, change link and change color
    End If
  End Sub
End Class
