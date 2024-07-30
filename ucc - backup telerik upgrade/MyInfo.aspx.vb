Imports System.Data.SqlClient

Partial Class MyInfo
  Inherits System.Web.UI.Page

  Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
    If Session("UserID") = "" Then
      Response.Redirect("\index.asp?msg=Your session timed out, please login again.")
    End If

    If Not Page.IsPostBack Then
      Dim myMaster As MainMaster = CType(MyBase.Master, MainMaster)
      'myMaster.Testing()
      myMaster.SetWelcomeName(Session("name"))

      Dim strSQL As String
      Dim dtData As New DataTable

      strSQL = "Select * from users " & _
        "Where userid = '" & Session("UserID") & "'"
      dtData = FillDataTable(strSQL)
      If dtData.Rows.Count > 0 Then
        With dtData.Rows(0)
          lblUserID.Text = .Item("UserID") & ""
          txtName.Text = .Item("name") & ""
          txtEmail.Text = .Item("email") & ""
          'txtName_Address.Text = (.Item("ur_name_address") & "").ToString.Replace("<br />", vbCrLf)
          'txtSecured_Party.Text = (.Item("ur_secured_party") & "").ToString.Replace("<br />", vbCrLf)
          'lblDateEntered.Text = .Item("ur_date_entered") & ""
        End With
      End If
      dtData.Dispose()
      dtData = Nothing
    End If
  End Sub

  Protected Sub btnSave_Click(sender As Object, e As System.EventArgs) Handles btnSave.Click
    'Session("name")
    'Session("UserID")
    Dim sMsg As String = ""
    If txtEmail.Text = "" Then
      sMsg = sMsg & "Please provide an email address.<br />"
    End If
    If txtName.Text = "" Then
      sMsg = sMsg & "Please provide a name.<br />"
    End If
    If txtPass2.Text <> txtPass2.Text Then
      sMsg = sMsg & "Your Password and Password Confirmation do not match.<br />"
    End If

    If sMsg <> "" Then
      lblMsg.Text = sMsg
    End If

    Using myConnection As New SqlConnection(CNNStr)
      Dim SQL As String = ""
      Dim myCommand As SqlCommand
      SQL = "Update users set " & _
        "name = @name, " & _
        "email = @email "
      If txtPass1.Text <> "" Then
        SQL = SQL & ", password = @password "
      End If
      SQL = SQL & " Where UserID = '" & Session("UserID") & "'"
      myCommand = New SqlCommand(SQL, myConnection)
      myCommand.Parameters.AddWithValue("@name", txtName.Text)
      myCommand.Parameters.AddWithValue("@email", txtEmail.Text)
      If txtPass1.Text <> "" Then
        myCommand.Parameters.AddWithValue("@password", txtPass1.Text)
      End If
      myConnection.Open()
      myCommand.ExecuteNonQuery()
      myConnection.Close()

      Session("name") = txtName.Text
    End Using

    lblMsg.Text = "Your information has been updated.<br />"
  End Sub
End Class
