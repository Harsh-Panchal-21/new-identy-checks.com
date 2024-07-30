Imports System.IO

Partial Class Admin_View_TIF
  Inherits System.Web.UI.Page


  Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
    Response.Expires = -1

    If Session("UserID") = "" Then
      Response.Redirect("\default.asp?msg=Your session timed out, please login again.")
    ElseIf Session("admin") <> "2" Then
      Response.Redirect("main.aspx?msg=You do not have access to this page.")
    End If
    If Request.QueryString("file") = "" Then
      Response.Redirect("admin_main.aspx?msg=No file provided.")
    End If

    Dim sFile As String = Request.QueryString("file")
    Dim fiOne As New FileInfo(sFile)

    Response.ContentType = "image/tiff"
    ' this is the important bit that gives the user the prompt to save
    Response.AppendHeader("Content-Disposition", "attachment; filename=" & fiOne.Name)
    Response.TransmitFile(sFile)
    Response.End()
  End Sub
End Class
