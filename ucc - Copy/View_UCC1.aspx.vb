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
    arrByte = GetUCC1_PDF(sID, com_id, Session("has_sub_companies"))

    If Request.QueryString("view") = "all" Then
      Dim sAD_ID As String = "", sAP_ID As String = ""
      sAP_ID = GetAD_AP_From_UCC1(sID, sAD_ID)

      Dim arrByteAD() As Byte = Nothing
      Dim arrByteAP() As Byte = Nothing

      If sAD_ID <> "" Or sAP_ID <> "" Then
        If sAD_ID <> "" Then arrByteAD = GetUCC1ad_PDF(sAD_ID, com_id, Session("has_sub_companies"))
        If sAP_ID <> "" Then arrByteAP = GetUCC1ap_PDF(sAP_ID, com_id, Session("has_sub_companies"))

        Dim combineMemStream As New IO.MemoryStream

        Dim document As New Document
        Dim copy As New PdfSmartCopy(document, combineMemStream)
        document.Open()
        'For i As Integer = 0 To 1
        Dim reader As New PdfReader(arrByte)
        copy.AddPage(copy.GetImportedPage(reader, 1))

        If sAD_ID <> "" Then
          Dim readerAD As New PdfReader(arrByteAD)
          copy.AddPage(copy.GetImportedPage(readerAD, 1))
        End If
        
        If sAP_ID <> "" Then
          Dim readerAP As New PdfReader(arrByteAP)
          copy.AddPage(copy.GetImportedPage(readerAP, 1))
        End If

        Dim blnClose As Boolean = copy.CloseStream()
        copy.Close()

        Dim arrByteAll() As Byte = combineMemStream.ToArray()

        Response.Expires = -1000
        Response.ContentType = "application/pdf"
        Response.AddHeader("content-length", arrByteAll.Length.ToString())
        Response.AddHeader("content-disposition", "inline; filename=UCC1_All_" & sID & ".PDF")
        Response.BinaryWrite(arrByteAll)
      End If
    Else
      Response.Expires = -1000
      Response.ContentType = "application/pdf"
      Response.AddHeader("content-length", arrByte.Length.ToString())
      Response.AddHeader("content-disposition", "inline; filename=UCC1_" & sID & ".PDF")
      Response.BinaryWrite(arrByte)
    End If


    'Dim strSQL As String
    'Dim dtData As New DataTable

    'strSQL = "Select uf.*, " & _
    '  "ud1.ud_id as ud1_id,ud1.ud_org_name as ud1_org_name,ud1.ud_ind_last_name as ud1_ind_last_name,ud1.ud_ind_first_name as ud1_ind_first_name,ud1.ud_ind_middle_name as ud1_ind_middle_name,ud1.ud_ind_suffix as ud1_ind_suffix,ud1.ud_mailing_address as ud1_mailing_address,ud1.ud_city as ud1_city,ud1.ud_state as ud1_state,ud1.ud_zipcode as ud1_zipcode,ud1.ud_country as ud1_country,ud1.ud_d1 as ud1_d1,ud1.ud_org_type as ud1_org_type,ud1.ud_org_jurisdiction as ud1_org_jurisdiction,ud1.ud_org_id as ud1_org_id,ud1.ud_org_id_none as ud1_org_id_none, " & _
    '  "ud2.ud_id as ud2_id,ud2.ud_org_name as ud2_org_name,ud2.ud_ind_last_name as ud2_ind_last_name,ud2.ud_ind_first_name as ud2_ind_first_name,ud2.ud_ind_middle_name as ud2_ind_middle_name,ud2.ud_ind_suffix as ud2_ind_suffix,ud2.ud_mailing_address as ud2_mailing_address,ud2.ud_city as ud2_city,ud2.ud_state as ud2_state,ud2.ud_zipcode as ud2_zipcode,ud2.ud_country as ud2_country,ud2.ud_d1 as ud2_d1,ud2.ud_org_type as ud2_org_type,ud2.ud_org_jurisdiction as ud2_org_jurisdiction,ud2.ud_org_id as ud2_org_id,ud2.ud_org_id_none as ud2_org_id_none " & _
    '  "From ucc_financing as uf left outer join ucc_debtor as ud1 on uf.uf_debtor1 = ud1.ud_id " & _
    '  "left outer join ucc_debtor as ud2 on uf.uf_debtor2 = ud2.ud_id " & _
    '  "Where uf_id = " & intRID

    'dtData = FillDataTable(strSQL)
    'If dtData.Rows.Count > 0 Then
    '  With dtData.Rows(0)
    '    Dim pdfTemplate As String = UCC1_PDF
    '    Dim memStream As New MemoryStream

    '    Dim pdfReader As New PdfReader(pdfTemplate)
    '    ' New FileStream(newFile, FileMode.Create)
    '    Dim pdfStamper = New PdfStamper(pdfReader, memStream)
    '    Dim pdfFormFields As AcroFields = pdfStamper.AcroFields

    '    'Dim iCount As Integer = 0
    '    '// set form pdfFormFields
    '    pdfFormFields.SetField("A", "Micah King, 217-753-4311")
    '    pdfFormFields.SetField("B", "Identi-Check, Inc." & Environment.NewLine & "3 North Old State Capitol Plaza" & Environment.NewLine & "Springfield, IL 62701")
    '    'first debtor
    '    pdfFormFields.SetField("1a", .Item("ud1_org_name") & "")
    '    pdfFormFields.SetField("1bL", .Item("ud1_ind_last_name") & "")
    '    pdfFormFields.SetField("1bF", .Item("ud1_ind_first_name") & "")
    '    pdfFormFields.SetField("1bM", .Item("ud1_ind_middle_name") & "")
    '    pdfFormFields.SetField("1bS", .Item("ud1_ind_suffix") & "")
    '    pdfFormFields.SetField("1c", .Item("ud1_mailing_address") & "")
    '    pdfFormFields.SetField("1cc", .Item("ud1_city") & "")
    '    pdfFormFields.SetField("1cs", .Item("ud1_state") & "")
    '    pdfFormFields.SetField("1cpc", .Item("ud1_zipcode") & "")
    '    pdfFormFields.SetField("1ccc", .Item("ud1_country") & "")
    '    pdfFormFields.SetField("1dsi", .Item("ud1_d1") & "")
    '    pdfFormFields.SetField("1e", .Item("ud1_org_type") & "")
    '    pdfFormFields.SetField("1f", .Item("ud1_org_jurisdiction") & "")
    '    pdfFormFields.SetField("1g", .Item("ud1_org_id") & "")
    '    pdfFormFields.SetField("none", IIf(.Item("ud1_org_id_none") & "" = "Y", "Yes", "0"))
    '    'second debtor
    '    pdfFormFields.SetField("1a2", .Item("ud2_org_name") & "")
    '    pdfFormFields.SetField("1bL2", .Item("ud2_ind_last_name") & "")
    '    pdfFormFields.SetField("1bF2", .Item("ud2_ind_first_name") & "")
    '    pdfFormFields.SetField("1bM2", .Item("ud2_ind_middle_name") & "")
    '    pdfFormFields.SetField("1bS2", .Item("ud2_ind_suffix") & "")
    '    pdfFormFields.SetField("1c2", .Item("ud2_mailing_address") & "")
    '    pdfFormFields.SetField("1cc2", .Item("ud2_city") & "")
    '    pdfFormFields.SetField("1cs2", .Item("ud2_state") & "")
    '    pdfFormFields.SetField("1cpc2", .Item("ud2_zipcode") & "")
    '    pdfFormFields.SetField("1cc2", .Item("ud2_country") & "")
    '    pdfFormFields.SetField("1dsi2", .Item("ud2_d1") & "")
    '    pdfFormFields.SetField("1e2", .Item("ud2_org_type") & "")
    '    pdfFormFields.SetField("1f2", .Item("ud2_org_jurisdiction") & "")
    '    pdfFormFields.SetField("1g2", .Item("ud2_org_id") & "")
    '    pdfFormFields.SetField("none2", IIf(.Item("ud2_org_id_none") & "" = "Y", "Yes", "0"))
    '    'secured
    '    pdfFormFields.SetField("1a3", .Item("uf_secured_org_name") & "")
    '    'pdfFormFields.SetField("1bL3", .Item("ud1_ind_last_name") & "")
    '    'pdfFormFields.SetField("1bF3", .Item("ud1_ind_first_name") & "")
    '    'pdfFormFields.SetField("1bM3", .Item("ud1_ind_middle_name") & "")
    '    'pdfFormFields.SetField("1bS3", .Item("ud1_ind_suffix") & "")
    '    pdfFormFields.SetField("1c3", .Item("uf_secured_mailing_address") & "")
    '    pdfFormFields.SetField("1cc3", .Item("uf_secured_city") & "")
    '    pdfFormFields.SetField("1cs3", .Item("uf_secured_state") & "")
    '    pdfFormFields.SetField("1cpc3", .Item("uf_secured_zipcode") & "")
    '    pdfFormFields.SetField("1cc23", .Item("uf_secured_country") & "")
    '    '4 - financing
    '    'approx max size is 1200 ~ 1274
    '    pdfFormFields.SetField("4", .Item("uf_finance_statement") & "")
    '    'test max length of field
    '    'Dim sbText As New System.Text.StringBuilder
    '    'For i As Integer = 0 To 1000
    '    '  sbText.Append("thethehtdssdhhsdfeeryeryerzbna sadhas asd fasdgf asdg agsdfag fa f")
    '    'Next
    '    'pdfFormFields.SetField("4", sbText.ToString)

    '    Dim sAltDes As String = .Item("uf_alt_designation") & ""
    '    pdfFormFields.SetField("5a", IIf(sAltDes.Substring(0, 1) = "L", "Yes", "0"))
    '    pdfFormFields.SetField("5b", IIf(sAltDes.Substring(1, 1) = "C", "Yes", "0"))
    '    pdfFormFields.SetField("5c", IIf(sAltDes.Substring(2, 1) = "B", "Yes", "0"))
    '    pdfFormFields.SetField("5d", IIf(sAltDes.Substring(3, 1) = "S", "Yes", "0"))
    '    pdfFormFields.SetField("5e", IIf(sAltDes.Substring(4, 1) = "A", "Yes", "0"))
    '    pdfFormFields.SetField("5f", IIf(sAltDes.Substring(5, 1) = "N", "Yes", "0"))

    '    pdfFormFields.SetField("6a", IIf(.Item("uf_file_real_estate") & "" = "Y", "Yes", "0"))

    '    pdfFormFields.SetField("7a", IIf(.Item("uf_request_search") & "" = "A", "Yes", "0"))
    '    pdfFormFields.SetField("7b", IIf(.Item("uf_request_search") & "" = "1", "Yes", "0"))
    '    pdfFormFields.SetField("7c", IIf(.Item("uf_request_search") & "" = "2", "Yes", "0"))

    '    pdfFormFields.SetField("8", .Item("uf_reference_data") & "")

    '    '// flatten the form to remove editting options, set it to false
    '    '// to leave the form open to subsequent manual edits
    '    pdfStamper.FormFlattening = True

    '    '// close the pdf
    '    pdfStamper.Close()

    '    Dim arrByte() As Byte = memStream.ToArray()

    '    If False Then
    '      Dim combineMemStream As New IO.MemoryStream

    '      Dim document As New Document
    '      Dim copy As New PdfSmartCopy(document, combineMemStream)
    '      document.Open()
    '      'For i As Integer = 0 To 1
    '      Dim reader As New PdfReader(arrByte)
    '      copy.AddPage(copy.GetImportedPage(reader, 1))
    '      'Next
    '    End If

    '    Response.Expires = -1000
    '    'Dim theData As Byte() = theDoc.GetData()
    '    Response.ContentType = "application/pdf"
    '    Response.AddHeader("content-length", arrByte.Length.ToString())
    '    Response.AddHeader("content-disposition", "inline; filename=UCC1_" & .Item("uf_id") & ".PDF")
    '    Response.BinaryWrite(arrByte)
    '  End With
    'End If
  End Sub

  Private Sub ListFieldNames()

    Dim pdfTemplate As String = UCC1_PDF

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
    pdfFormFields.SetField("4", sb.ToString)



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
