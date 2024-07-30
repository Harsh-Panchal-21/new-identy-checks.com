Imports iTextSharp
Imports iTextSharp.text
Imports iTextSharp.text.pdf
Imports iTextSharp.text.xml
Imports System.IO
Imports System.Text

Partial Class View_UCC1
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

    Dim sID As String
    sID = Request.QueryString("id")

    Dim arrByte() As Byte = Nothing
    arrByte = GetUCC3ad_PDF(sID, com_id, Session("has_sub_companies"))

    Response.Expires = -1000
    Response.ContentType = "application/pdf"
    Response.AddHeader("content-length", arrByte.Length.ToString())
    Response.AddHeader("content-disposition", "inline; filename=UCC3ad_" & sID & ".PDF")
    Response.BinaryWrite(arrByte)

    'Dim strSQL As String
    'Dim dtData As New DataTable

    'SQLstr = "Select iav.*, c.ADDRESS, c.CITY, c.STATE, c.ZIPCODE, c.PHONE, c.FAX " & _
    ' "From INVOICE_AR_VW iav inner join COMPANY c on iav.COMPANY_RID = c.RID " & _
    ' "Where COMPANY_RID = " & Session("LoginedCompanyRID") & " and iav.RID = " & Request.QueryString("ID")
    'strSQL = "Select * " & _
    '  "From ucc3_ad as u3ad inner join ucc3 as u3 on u3ad.u3ad_u3_id = u3.u3_id " & _
    '  "Where u3ad_id = " & intRID

    'dtData = FillDataTable(strSQL)
    'If dtData.Rows.Count > 0 Then
    '  With dtData.Rows(0)
    '    Dim pdfTemplate As String = UCC3ad_PDF
    '    Dim memStream As New MemoryStream

    '    Dim pdfReader As New PdfReader(pdfTemplate)
    '    ' New FileStream(newFile, FileMode.Create)
    '    Dim pdfStamper = New PdfStamper(pdfReader, memStream)
    '    Dim pdfFormFields As AcroFields = pdfStamper.AcroFields

    '    'Dim iCount As Integer = 0
    '    '// set form pdfFormFields
    '    'pdfFormFields.SetField("A", "Micah King, 217-753-4311")
    '    'pdfFormFields.SetField("B", "Identi-Check, Inc." & Environment.NewLine & "3 North Old State Capitol Plaza" & Environment.NewLine & "Springfield, IL 62701")

    '    pdfFormFields.SetField("11", .Item("u3_initial_file_no") & "")
    '    pdfFormFields.SetField("12a", .Item("u3_secured_org_name") & "")
    '    'pdfFormFields.SetField("12bL", .Item("u3_secured_ind_last_name") & "")
    '    'pdfFormFields.SetField("12bF", .Item("u3_secured_ind_first_name") & "")
    '    'pdfFormFields.SetField("12bM", .Item("u3_secured_ind_middle_name") & "")
    '    'pdfFormFields.SetField("12bS", .Item("u3_secured_ind_suffix") & "")

    '    pdfFormFields.SetField("13", .Item("u3ad_info") & "")


    '    '// The form's checkboxes
    '    'pdfFormFields.SetField("c1_01(0)", "0")
    '    'pdfFormFields.SetField("c1_02(0)", "Yes")
    '    'pdfFormFields.SetField("c1_03(0)", "0")
    '    'pdfFormFields.SetField("c1_04(0)", "Yes")

    '    '// report by reading values from completed PDF
    '    'Dim sTmp As String = "W-4 Completed for " + pdfFormFields.GetField("f1_09(0)") + " " + pdfFormFields.GetField("f1_10(0)")
    '    'MessageBox.Show(sTmp, "Finished")

    '    '// flatten the form to remove editting options, set it to false
    '    '// to leave the form open to subsequent manual edits
    '    pdfStamper.FormFlattening = True

    '    '// close the pdf
    '    pdfStamper.Close()

    '    Dim arrByte() As Byte = memStream.ToArray()
    '    Response.Expires = -1000
    '    'Dim theData As Byte() = theDoc.GetData()
    '    Response.ContentType = "application/pdf"
    '    Response.AddHeader("content-length", arrByte.Length.ToString())
    '    Response.AddHeader("content-disposition", "inline; filename=UCC3ad_" & .Item("u3ad_id") & ".PDF")
    '    Response.BinaryWrite(arrByte)
    '  End With
    'End If
  End Sub

  Private Sub ListFieldNames()

    Dim pdfTemplate As String = UCC3ad_PDF

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
		For Each de As KeyValuePair(Of String, iTextSharp.text.pdf.AcroFields.Item) In PdfReader.AcroFields.Fields
			sb.Append(de.Key.ToString() & ", ") 'Environment.NewLine
			pdfFormFields.SetField(de.Key.ToString(), de.Key.ToString() & "_")
		Next

		'A, B, 1a, 1bL,
		pdfFormFields.SetField("13", sb.ToString)



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
