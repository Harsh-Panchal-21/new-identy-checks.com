Imports System.IO
Imports System.Data.SqlClient

Partial Class View_File
  Inherits System.Web.UI.Page

  Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
    'Put user code to initialize the page here
    'Session("validuser") = True
    'Session("name") = "Matt Barham"
    'Session("UserID") = "matt_ucc"
    'Session("company") = "KingTech"
    'Session("company_rid") = "129"
    'Session("ucc_app") = "Y"

    If Session("UserID") = "" Then
      Response.Redirect("\index.asp?msg=Your session timed out, please login again.")
    End If

    'ListFieldNames()
    'Exit Sub
    Dim com_id As String
    If Session("admin") = "2" Then
      com_id = Request.QueryString("com")
    Else
      com_id = Session("company_rid")
    End If

    Dim sID As String = Request.QueryString("id")
    Dim sType As String = Request.QueryString("type")
    Dim sFrom As String = ""
    Dim sImageField As String = ""
    Dim sIDfield As String = ""
    Dim sComIDfield As String = ""

    Select Case sType
      Case "UCC1"
        sFrom = "ucc_financing"
        sIDfield = "uf_id"
        sImageField = "uf_file_attach"
        sComIDfield = "uf_company_id"
      Case "UCC3"
        sFrom = "ucc3"
        sIDfield = "u3_id"
        sImageField = "u3_file_attach"
        sComIDfield = "u3_company_id"
      Case "UCC11"
        sFrom = "ucc_search"
        sIDfield = "us_id"
        sImageField = "us_confirm_file"
        sComIDfield = "us_company_id"
      Case "UCC11_results"
        sFrom = "ucc_results inner join ucc_search on ur_us_id = us_id"
        sIDfield = "ur_id"
        sImageField = "ur_file"
        sComIDfield = "us_company_id"
    End Select

    'Connect to the database and bring back the image contents & MIME type for the specified picture
    Using myConnection As New SqlConnection(CNNStr)

      'Session("has_sub_companies")
      Dim sWhereCom As String = ""
      If Session("has_sub_companies") = "Y" Then
        sWhereCom = " in (Select company_id from subscriber where parent_company_id = " & com_id & ") "
      Else
        sWhereCom = " = " & com_id & " "
      End If

      Dim SQL As String = "SELECT " & sImageField & " FROM " & sFrom & " WHERE " & sIDfield & " = @ID" & _
        " and " & sComIDfield & sWhereCom
      '" and " & sComIDfield & " = @ComID"
      Dim myCommand As New SqlCommand(SQL, myConnection)
      myCommand.Parameters.AddWithValue("@ID", sID)
      'myCommand.Parameters.AddWithValue("@ComID", com_id)

      myConnection.Open()
      Dim myReader As SqlDataReader = myCommand.ExecuteReader

      If myReader.Read Then
        Response.ContentType = "application/pdf"
        Response.BinaryWrite(myReader(sImageField))
      End If

      myReader.Close()
      myConnection.Close()
    End Using

  End Sub

End Class
