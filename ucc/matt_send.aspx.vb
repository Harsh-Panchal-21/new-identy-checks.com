
Partial Class matt_send
  Inherits System.Web.UI.Page

  Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load

    If Session("UserID") = "" Then
      Response.Redirect("\index.asp?msg=Your session timed out, please login again.")
    ElseIf Session("admin") <> "2" Then
      Response.Redirect("main.aspx?msg=You do not have access to this page.")
    End If

    If Not Page.IsPostBack Then
      Dim myMaster As MainMaster = CType(MyBase.Master, MainMaster)
      'myMaster.Testing()
      myMaster.SetWelcomeName(Session("name"))

    End If
  End Sub

  Protected Sub btnSend_Click(sender As Object, e As System.EventArgs) Handles btnSend.Click
    Dim sSQL As String
    Dim iCount As Integer = 1
    Dim dtUsers As DataTable

    'sSQL = "Select * From Users Where company_id in (select company_id from subscriber where parent_company_id = 160 or company_id = 160)"
    sSQL = "Select * From Users Where id > 20574 and company_id in (select company_id from subscriber where parent_company_id = 496 or company_id = 496)"
    dtUsers = FillDataTable(sSQL)
    If dtUsers.Rows.Count > 0 Then
      For Each drUser As DataRow In dtUsers.Rows
        'If iCount > 1 Then Exit For

        Dim sRid, sUserID, sPass, sEmail As String
        sRid = drUser.Item("ID")
        sUserID = drUser.Item("UserID")
        sPass = drUser.Item("password") 'DecryptString(drUser.Item("Password"))
        sEmail = drUser.Item("Email")

        'send email
        Dim sMsg, sBrief, sSubject As String
        sMsg = "Your Identi-Check UCC account has been activated.<br /><br />" & _
          "Your temporary login information follows:<br />" & _
          "User ID: " & sUserID & "<br />" & _
          "Password: " & sPass & "<br /><br />" & _
          "Please login to <a href='https://www.identi-check.com/'>Identi-Check</a> to make sure you can access your account and to change your password.<br /><br />"
        sBrief = "Identi-Check UCC has been activated."
        sSubject = "Identi-Check UCC Account Activated"
        'sEmail = "matt@kingtech.net"
        'sEmail = "mbarham@thehopeinstitute.us"
        If sEmail.Trim <> "" Then
          Call SendEmailNew(160, -1, sMsg, sSubject, sEmail, sBrief, True)
        End If
        iCount += 1
        'Dim img As System.Drawing.Image
        'img.Dispose()
      Next
    End If
    dtUsers.Dispose()
  End Sub
End Class
