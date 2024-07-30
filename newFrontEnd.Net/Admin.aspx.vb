
Partial Class Admin
  Inherits System.Web.UI.Page

  Protected Sub rgCompany_NeedDataSource(sender As Object, e As Telerik.Web.UI.GridNeedDataSourceEventArgs) Handles rgCompany.NeedDataSource
    rgCompany.DataSource = FillDataTable("Select *, city+ ' / ' + state + ' / ' + zip as citystatezip From subscriber where company_id > 0 and hide ='N'")
  End Sub
End Class
