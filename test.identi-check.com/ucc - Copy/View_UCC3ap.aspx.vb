Imports iTextSharp
Imports iTextSharp.text
Imports iTextSharp.text.pdf
Imports iTextSharp.text.xml
Imports System.IO
Imports System.Text

Partial Class View_UCC3ap
  Inherits System.Web.UI.Page

  Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
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

    Dim sID As String
    sID = Request.QueryString("id")

    Dim arrByte() As Byte = Nothing
    arrByte = GetUCC3ap_PDF(sID, com_id, Session("has_sub_companies"))


    'Dim combineMemStream As New IO.MemoryStream

    'Dim document As New Document
    'Dim copy As New PdfSmartCopy(document, combineMemStream)
    'document.Open()
    ''For i As Integer = 0 To 1
    'Dim reader As New PdfReader("c:\webs\test.identi-check.com\ucc\pdf\ucc3ap.pdf")
    'copy.AddPage(copy.GetImportedPage(reader, 1))
    'copy.CopyAcroForm(reader)

    'Dim blnClose As Boolean = copy.CloseStream()
    'copy.Close()

    'Dim arrByteAll() As Byte = combineMemStream.ToArray()

    'Response.Expires = -1000
    'Response.ContentType = "application/pdf"
    'Response.AddHeader("content-length", arrByteAll.Length.ToString())
    'Response.AddHeader("content-disposition", "inline; filename=UCC3ap_" & sID & ".PDF")
    'Response.BinaryWrite(arrByteAll)


    Response.Expires = -1000
    Response.ContentType = "application/pdf"
    Response.AddHeader("content-length", arrByte.Length.ToString())
    Response.AddHeader("content-disposition", "inline; filename=UCC3ap_" & sID & ".PDF")
    Response.BinaryWrite(arrByte)
  End Sub

  Private Sub ListFieldNames()

    'c:\webs\test.identi-check.com\ucc\pdf\ucc3ap_mine.pdf
    'Dim pdfTemplate As String = UCC3ap_PDF
    Dim pdfTemplate As String = "c:\webs\test.identi-check.com\ucc\pdf\ucc3ap.pdf"

    '// title the form
    'this.Text += " - " + PdfTemplate

    '// create a new PDF reader based on the PDF template document
    Dim PdfReader As PdfReader = New PdfReader(pdfTemplate)

    '// create and populate a string builder with each of the 
    '// field names available in the subject PDF
    Dim memStream As New MemoryStream

    ' New FileStream(newFile, FileMode.Create)
    Dim pdfStamper = New PdfStamper(PdfReader, memStream)
    Dim pdfFormFields As AcroFields = pdfStamper.AcroFields

    Dim sb As New StringBuilder
    For Each de As DictionaryEntry In PdfReader.AcroFields.Fields
      sb.Append(de.Key.ToString() & ", ") 'Environment.NewLine
      pdfFormFields.SetField(de.Key.ToString(), de.Key.ToString() & "_")
    Next

    'A, B, 1a, 1bL,
    'pdfFormFields.SetField("13", sb.ToString)



    '// Write the string builder's content to the form's textbox
    'textBox1.Text = sb.ToString()
    'textBox1.SelectionStart = 0
    'Response.Write(sb.ToString)
    '// flatten the form to remove editting options, set it to false
    '// to leave the form open to subsequent manual edits
    pdfStamper.FormFlattening = True

    '// close the pdf
    pdfStamper.Close()

    Dim arrByte() As Byte = memStream.ToArray()
    Response.Expires = -1000
    'Dim theData As Byte() = theDoc.GetData()
    Response.ContentType = "application/pdf"
    Response.AddHeader("content-length", arrByte.Length.ToString())
    Response.AddHeader("content-disposition", "inline; filename=TEST.PDF")
    Response.BinaryWrite(arrByte)
  End Sub
End Class
