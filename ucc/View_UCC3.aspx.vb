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

    Dim sID As String
    sID = Request.QueryString("id")

    Dim com_id As String
    If Session("admin") = "2" Then
      com_id = Request.QueryString("com")
    Else
      com_id = Session("company_rid")
    End If

    Dim arrByte() As Byte = Nothing
    arrByte = GetUCC3_PDF(sID, com_id, Session("has_sub_companies"))

    If Request.QueryString("view") = "all" Then
      Dim sAD_ID As String = "", sAP_ID As String
      sAP_ID = GetAD_AP_From_UCC3(sID, sAD_ID)

      Dim arrByteAD() As Byte = Nothing
      Dim arrByteAP() As Byte = Nothing

      If sAD_ID <> "" Or sAP_ID <> "" Then
        If sAD_ID <> "" Then arrByteAD = GetUCC3ad_PDF(sAD_ID, com_id, Session("has_sub_companies"))
        If sAP_ID <> "" Then arrByteAP = GetUCC3ap_PDF(sAP_ID, com_id, Session("has_sub_companies"))
				'arrByteAD = GetUCC3ad_PDF(sAD_ID, com_id, Session("has_sub_companies"))

				Dim combineMemStream As New System.IO.MemoryStream

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
        Response.AddHeader("content-disposition", "inline; filename=UCC3_All_" & sID & ".PDF")
        Response.BinaryWrite(arrByteAll)
      End If
    Else
      Response.Expires = -1000
      Response.ContentType = "application/pdf"
      Response.AddHeader("content-length", arrByte.Length.ToString())
      Response.AddHeader("content-disposition", "inline; filename=UCC3_" & sID & ".PDF")
      Response.BinaryWrite(arrByte)
    End If

    'Dim strSQL As String
    'Dim dtData As New DataTable

    'SQLstr = "Select iav.*, c.ADDRESS, c.CITY, c.STATE, c.ZIPCODE, c.PHONE, c.FAX " & _
    ' "From INVOICE_AR_VW iav inner join COMPANY c on iav.COMPANY_RID = c.RID " & _
    ' "Where COMPANY_RID = " & Session("LoginedCompanyRID") & " and iav.RID = " & Request.QueryString("ID")
    'strSQL = "Select ucc3.*, " & _
    '  "ud1.ud_id as ud1_id,ud1.ud_org_name as ud1_org_name,ud1.ud_ind_last_name as ud1_ind_last_name,ud1.ud_ind_first_name as ud1_ind_first_name,ud1.ud_ind_middle_name as ud1_ind_middle_name,ud1.ud_ind_suffix as ud1_ind_suffix,ud1.ud_mailing_address as ud1_mailing_address,ud1.ud_city as ud1_city,ud1.ud_state as ud1_state,ud1.ud_zipcode as ud1_zipcode,ud1.ud_country as ud1_country,ud1.ud_d1 as ud1_d1,ud1.ud_org_type as ud1_org_type,ud1.ud_org_jurisdiction as ud1_org_jurisdiction,ud1.ud_org_id as ud1_org_id,ud1.ud_org_id_none as ud1_org_id_none " & _
    '  "From ucc3 left outer join ucc_debtor as ud1 on ucc3.u3_new_debtor = ud1.ud_id " & _
    '  "Where u3_id = " & intRID

    'dtData = FillDataTable(strSQL)
    'If dtData.Rows.Count > 0 Then
    '  With dtData.Rows(0)
    '    Dim pdfTemplate As String = UCC3_PDF
    '    Dim memStream As New MemoryStream

    '    Dim pdfReader As New PdfReader(pdfTemplate)
    '    ' New FileStream(newFile, FileMode.Create)
    '    Dim pdfStamper = New PdfStamper(pdfReader, memStream)
    '    Dim pdfFormFields As AcroFields = pdfStamper.AcroFields

    '    'Dim iCount As Integer = 0
    '    '// set form pdfFormFields
    '    pdfFormFields.SetField("A", "Micah King, 217-753-4311")
    '    pdfFormFields.SetField("B", "Identi-Check, Inc." & Environment.NewLine & "3 North Old State Capitol Plaza" & Environment.NewLine & "Springfield, IL 62701")

    '    pdfFormFields.SetField("1a", .Item("u3_initial_file_no") & "")
    '    pdfFormFields.SetField("1b", IIf(.Item("u3_real_estate") & "" = "Y", "Yes", ""))

    '    pdfFormFields.SetField("2", IIf(.Item("u3_termination") & "" = "Y", "Yes", ""))
    '    pdfFormFields.SetField("9CB", IIf(.Item("u3_termination") & "" = "Y", "Yes", ""))

    '    pdfFormFields.SetField("3", IIf(.Item("u3_continuation") & "" = "Y", "Yes", ""))
    '    pdfFormFields.SetField("4", IIf(.Item("u3_assignment") & "" = "Y", "Yes", ""))

    '    If .Item("u3_amendment_affects") & "" = "D" Then
    '      pdfFormFields.SetField("5a", "1")
    '    ElseIf .Item("u3_amendment_affects") & "" = "S" Then
    '      pdfFormFields.SetField("5a", "2")
    '    End If

    '    If .Item("u3_amendment") & "" = "C" Then
    '      pdfFormFields.SetField("5b", "1")
    '    ElseIf .Item("u3_amendment") & "" = "D" Then
    '      pdfFormFields.SetField("5b", "2")
    '    ElseIf .Item("u3_amendment") & "" = "A" Then
    '      pdfFormFields.SetField("5b", "3")
    '    End If

    '    'orig debtor
    '    pdfFormFields.SetField("6a", .Item("u3_old_org_name") & "")
    '    pdfFormFields.SetField("6bL", .Item("u3_old_ind_last_name") & "")
    '    pdfFormFields.SetField("6bF", .Item("u3_old_ind_first_name") & "")
    '    pdfFormFields.SetField("6bM", .Item("u3_old_ind_middle_name") & "")
    '    pdfFormFields.SetField("6bS", .Item("u3_old_ind_suffix") & "")

    '    'new debtor
    '    pdfFormFields.SetField("7a", .Item("ud1_org_name") & "")
    '    pdfFormFields.SetField("7bL", .Item("ud1_ind_last_name") & "")
    '    pdfFormFields.SetField("7bF", .Item("ud1_ind_first_name") & "")
    '    pdfFormFields.SetField("7bM", .Item("ud1_ind_middle_name") & "")
    '    pdfFormFields.SetField("7bS", .Item("ud1_ind_suffix") & "")
    '    pdfFormFields.SetField("7cMA", .Item("ud1_mailing_address") & "")
    '    pdfFormFields.SetField("7cCty", .Item("ud1_city") & "")
    '    pdfFormFields.SetField("7cSt", .Item("ud1_state") & "")
    '    pdfFormFields.SetField("7cPC", .Item("ud1_zipcode") & "")
    '    pdfFormFields.SetField("7cCtry", .Item("ud1_country") & "")
    '    pdfFormFields.SetField("7d", .Item("ud1_d1") & "")
    '    pdfFormFields.SetField("7e", .Item("ud1_org_type") & "")
    '    pdfFormFields.SetField("7f", .Item("ud1_org_jurisdiction") & "")
    '    pdfFormFields.SetField("7g", .Item("ud1_org_id") & "")
    '    pdfFormFields.SetField("7gCB", IIf(.Item("ud1_org_id_none") & "" = "Y", "Yes", "0"))

    '    If .Item("u3_collateral_change") & "" = "D" Then
    '      pdfFormFields.SetField("8CB", "1")
    '    ElseIf .Item("u3_collateral_change") & "" = "A" Then
    '      pdfFormFields.SetField("8CB", "2")
    '    ElseIf .Item("u3_collateral_change") & "" = "R" Then
    '      pdfFormFields.SetField("8CB", "3")
    '    ElseIf .Item("u3_collateral_change") & "" = "S" Then
    '      pdfFormFields.SetField("8CB", "4")
    '    End If
    '    pdfFormFields.SetField("8", .Item("u3_collateral") & "")

    '    pdfFormFields.SetField("10", .Item("u3_reference_data") & "")

    '    'secured
    '    pdfFormFields.SetField("9a", .Item("u3_secured_org_name") & "")
    '    'pdfFormFields.SetField("9bL", .Item("ud1_ind_last_name") & "")
    '    'pdfFormFields.SetField("9bF", .Item("ud1_ind_first_name") & "")
    '    'pdfFormFields.SetField("9bM", .Item("ud1_ind_middle_name") & "")
    '    'pdfFormFields.SetField("9bS", .Item("ud1_ind_suffix") & "")
    '    'pdfFormFields.SetField("9c", .Item("u3_secured_mailing_address") & "")
    '    'pdfFormFields.SetField("9cc", .Item("u3_secured_city") & "")
    '    'pdfFormFields.SetField("9cs", .Item("u3_secured_state") & "")
    '    'pdfFormFields.SetField("9cpc", .Item("u3_secured_zipcode") & "")
    '    'pdfFormFields.SetField("9cc", .Item("u3_secured_country") & "")
    '    '4 - financing
    '    'pdfFormFields.SetField("4", .Item("uf_finance_statement") & "")
    '    'Dim sAltDes As String = .Item("uf_alt_designation") & ""
    '    'pdfFormFields.SetField("5a", IIf(sAltDes.Substring(0, 1) = "L", "Yes", "0"))
    '    'pdfFormFields.SetField("5b", IIf(sAltDes.Substring(1, 1) = "C", "Yes", "0"))
    '    'pdfFormFields.SetField("5c", IIf(sAltDes.Substring(2, 1) = "B", "Yes", "0"))
    '    'pdfFormFields.SetField("5d", IIf(sAltDes.Substring(3, 1) = "S", "Yes", "0"))
    '    'pdfFormFields.SetField("5e", IIf(sAltDes.Substring(4, 1) = "A", "Yes", "0"))
    '    'pdfFormFields.SetField("5f", IIf(sAltDes.Substring(5, 1) = "N", "Yes", "0"))

    '    'pdfFormFields.SetField("6a", IIf(.Item("uf_file_real_estate") & "" = "Y", "Yes", "0"))

    '    'pdfFormFields.SetField("7a", IIf(.Item("uf_request_search") & "" = "A", "Yes", "0"))
    '    'pdfFormFields.SetField("7b", IIf(.Item("uf_request_search") & "" = "1", "Yes", "0"))
    '    'pdfFormFields.SetField("7c", IIf(.Item("uf_request_search") & "" = "2", "Yes", "0"))

    '    'pdfFormFields.SetField("8", .Item("uf_reference_data") & "")

    '    'pdfFormFields.SetField("form1[0].#subform[0].Body[0].txtDescription[0]", "")
    '    'pdfFormFields.SetField("form1[0].#subform[0].Body[0].numQty[0]", "")
    '    'pdfFormFields.SetField("form1[0].#subform[0].Body[0].numUnitPrice[0]", "")
    '    'pdfFormFields.SetField("form1[0].#subform[0].Body[0].numAmount[0]", "")


    '    'form1[0].#subform[0].Body[0].numAmtReceived[0]", "")


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
    '    Response.AddHeader("content-disposition", "inline; filename=UCC3_" & .Item("u3_id") & ".PDF")
    '    Response.BinaryWrite(arrByte)
    '  End With
    'End If
  End Sub

  Private Sub ListFieldNames()

    Dim pdfTemplate As String = UCC3_PDF

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
		'For Each de As DictionaryEntry In PdfReader.AcroFields.Fields
		For Each de As KeyValuePair(Of String, iTextSharp.text.pdf.AcroFields.Item) In PdfReader.AcroFields.Fields
				sb.Append(de.Key.ToString() & ", ") 'Environment.NewLine
				pdfFormFields.SetField(de.Key.ToString(), de.Key.ToString() & "_")
			Next

			'A, B, 1a, 1bL,
			pdfFormFields.SetField("8", sb.ToString)



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
