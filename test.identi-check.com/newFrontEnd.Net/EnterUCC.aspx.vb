Imports System.Collections.Generic

Partial Class EnterUCC
  Inherits System.Web.UI.Page

  Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
    'Put user code to initialize the page here
    If Session("UserID") = "" Then
      Response.Redirect("\home.aspx?msg=Your session timed out, please login again.")
    End If

    If strSecureAppTransfer = "YES" Then
      Dim params As New List(Of SqlClient.SqlParameter)()
      Dim MyGuidA As Guid = Guid.NewGuid()
      Dim MyGuidB As Guid = Guid.NewGuid()
      Dim strSQL As String
      strSQL = "Insert Into APP_LOGIN_SECURITY " & _
               "(GUID_STRINGA,GUID_STRINGB,USER_RID) Values " & _
               "(@GUIDA_string,@GUIDB_string,@USER_RID)"
      params.Add(New SqlClient.SqlParameter("@GUIDA_string", MyGuidA.ToString))
      params.Add(New SqlClient.SqlParameter("@GUIDB_string", MyGuidB.ToString))
      params.Add(New SqlClient.SqlParameter("@USER_RID", Session("UserID")))
      RunCommand(strSQL, params)
      hidGUIDA.Value = MyGuidA.ToString
      hidGUIDB.Value = MyGuidB.ToString
    Else
      RID.Value = Session("LoginedUserRID")
    End If
  End Sub
End Class
