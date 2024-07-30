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
    arrByte = GetUCC1ap_PDF(sID, com_id, Session("has_sub_companies"))

    Response.Expires = -1000
    Response.ContentType = "application/pdf"
    Response.AddHeader("content-length", arrByte.Length.ToString())
    Response.AddHeader("content-disposition", "inline; filename=UCC1ap_" & sID & ".PDF")
    Response.BinaryWrite(arrByte)

    'Dim strSQL As String
    'Dim dtData As New DataTable

    'SQLstr = "Select iav.*, c.ADDRESS, c.CITY, c.STATE, c.ZIPCODE, c.PHONE, c.FAX " & _
    ' "From INVOICE_AR_VW iav inner join COMPANY c on iav.COMPANY_RID = c.RID " & _
    ' "Where COMPANY_RID = " & Session("LoginedCompanyRID") & " and iav.RID = " & Request.QueryString("ID")
    'strSQL = "Select ufap.*, " & _
    '  "ud1.ud_id as ud1_id,ud1.ud_org_name as ud1_org_name,ud1.ud_ind_last_name as ud1_ind_last_name,ud1.ud_ind_first_name as ud1_ind_first_name,ud1.ud_ind_middle_name as ud1_ind_middle_name,ud1.ud_ind_suffix as ud1_ind_suffix,ud1.ud_mailing_address as ud1_mailing_address,ud1.ud_city as ud1_city,ud1.ud_state as ud1_state,ud1.ud_zipcode as ud1_zipcode,ud1.ud_country as ud1_country,ud1.ud_d1 as ud1_d1,ud1.ud_org_type as ud1_org_type,ud1.ud_org_jurisdiction as ud1_org_jurisdiction,ud1.ud_org_id as ud1_org_id,ud1.ud_org_id_none as ud1_org_id_none, " & _
    '  "ud2.ud_id as ud2_id,ud2.ud_org_name as ud2_org_name,ud2.ud_ind_last_name as ud2_ind_last_name,ud2.ud_ind_first_name as ud2_ind_first_name,ud2.ud_ind_middle_name as ud2_ind_middle_name,ud2.ud_ind_suffix as ud2_ind_suffix,ud2.ud_mailing_address as ud2_mailing_address,ud2.ud_city as ud2_city,ud2.ud_state as ud2_state,ud2.ud_zipcode as ud2_zipcode,ud2.ud_country as ud2_country,ud2.ud_d1 as ud2_d1,ud2.ud_org_type as ud2_org_type,ud2.ud_org_jurisdiction as ud2_org_jurisdiction,ud2.ud_org_id as ud2_org_id,ud2.ud_org_id_none as ud2_org_id_none, " & _
    '  "ud3.ud_id as ud3_id,ud3.ud_org_name as ud3_org_name,ud3.ud_ind_last_name as ud3_ind_last_name,ud3.ud_ind_first_name as ud3_ind_first_name,ud3.ud_ind_middle_name as ud3_ind_middle_name,ud3.ud_ind_suffix as ud3_ind_suffix,ud3.ud_mailing_address as ud3_mailing_address,ud3.ud_city as ud3_city,ud3.ud_state as ud3_state,ud3.ud_zipcode as ud3_zipcode,ud3.ud_country as ud3_country,ud3.ud_d1 as ud3_d1,ud3.ud_org_type as ud3_org_type,ud3.ud_org_jurisdiction as ud3_org_jurisdiction,ud3.ud_org_id as ud3_org_id,ud3.ud_org_id_none as ud3_org_id_none, " & _
    '  "ud4.ud_id as ud4_id,ud4.ud_org_name as ud4_org_name,ud4.ud_ind_last_name as ud4_ind_last_name,ud4.ud_ind_first_name as ud4_ind_first_name,ud4.ud_ind_middle_name as ud4_ind_middle_name,ud4.ud_ind_suffix as ud4_ind_suffix,ud4.ud_mailing_address as ud4_mailing_address,ud4.ud_city as ud4_city,ud4.ud_state as ud4_state,ud4.ud_zipcode as ud4_zipcode,ud4.ud_country as ud4_country,ud4.ud_d1 as ud4_d1,ud4.ud_org_type as ud4_org_type,ud4.ud_org_jurisdiction as ud4_org_jurisdiction,ud4.ud_org_id as ud4_org_id,ud4.ud_org_id_none as ud4_org_id_none " & _
    '  "From ucc_financing_ap as ufap inner join ucc_financing as uf on ufap_uf_id = uf.uf_id " & _
    '  "left outer join ucc_debtor as ud1 on uf.uf_debtor1 = ud1.ud_id " & _
    '  "left outer join ucc_debtor as ud2 on ufap.ufap_debtor4 = ud2.ud_id " & _
    '  "left outer join ucc_debtor as ud3 on ufap.ufap_debtor5 = ud3.ud_id " & _
    '  "left outer join ucc_debtor as ud4 on ufap.ufap_debtor6 = ud4.ud_id " & _
    '  "Where ufap_id = " & intRID

    'dtData = FillDataTable(strSQL)
    'If dtData.Rows.Count > 0 Then
    '  With dtData.Rows(0)
    '    Dim pdfTemplate As String = UCC1ap_PDF
    '    Dim memStream As New MemoryStream

    '    Dim pdfReader As New PdfReader(pdfTemplate)
    '    ' New FileStream(newFile, FileMode.Create)
    '    Dim pdfStamper = New PdfStamper(pdfReader, memStream)
    '    Dim pdfFormFields As AcroFields = pdfStamper.AcroFields

    '    'Dim iCount As Integer = 0
    '    '// set form pdfFormFields
    '    'pdfFormFields.SetField("A", "Micah King, 217-753-4311")
    '    'pdfFormFields.SetField("B", "Identi-Check, Inc." & Environment.NewLine & "3 North Old State Capitol Plaza" & Environment.NewLine & "Springfield, IL 62701")
    '    'debtor from ucc1
    '    pdfFormFields.SetField("19a", .Item("ud1_org_name") & "")
    '    pdfFormFields.SetField("19bL", .Item("ud1_ind_last_name") & "")
    '    pdfFormFields.SetField("19bF", .Item("ud1_ind_first_name") & "")
    '    pdfFormFields.SetField("19bMS", .Item("ud1_ind_middle_name") & ", " & .Item("ud1_ind_suffix") & "")

    '    pdfFormFields.SetField("20", .Item("ufap_misc") & "")

    '    'first debtor
    '    pdfFormFields.SetField("21a", .Item("ud2_org_name") & "")
    '    pdfFormFields.SetField("21bL", .Item("ud2_ind_last_name") & "")
    '    pdfFormFields.SetField("21bF", .Item("ud2_ind_first_name") & "")
    '    pdfFormFields.SetField("21bM", .Item("ud2_ind_middle_name") & "")
    '    pdfFormFields.SetField("21bS", .Item("ud2_ind_suffix") & "")
    '    pdfFormFields.SetField("21cMA", .Item("ud2_mailing_address") & "")
    '    pdfFormFields.SetField("21cCty", .Item("ud2_city") & "")
    '    pdfFormFields.SetField("21cSt", .Item("ud2_state") & "")
    '    pdfFormFields.SetField("21cPC", .Item("ud2_zipcode") & "")
    '    pdfFormFields.SetField("21cCtry", .Item("ud2_country") & "")
    '    pdfFormFields.SetField("21d", .Item("ud2_d1") & "")
    '    pdfFormFields.SetField("21e", .Item("ud2_org_type") & "")
    '    pdfFormFields.SetField("21f", .Item("ud2_org_jurisdiction") & "")
    '    pdfFormFields.SetField("21g", .Item("ud2_org_id") & "")
    '    pdfFormFields.SetField("21gCB", IIf(.Item("ud2_org_id_none") & "" = "Y", "Yes", "0"))
    '    'second debtor
    '    pdfFormFields.SetField("22a", .Item("ud3_org_name") & "")
    '    pdfFormFields.SetField("22bL", .Item("ud3_ind_last_name") & "")
    '    pdfFormFields.SetField("22bF", .Item("ud3_ind_first_name") & "")
    '    pdfFormFields.SetField("22bM", .Item("ud3_ind_middle_name") & "")
    '    pdfFormFields.SetField("22bS", .Item("ud3_ind_suffix") & "")
    '    pdfFormFields.SetField("22cMA", .Item("ud3_mailing_address") & "")
    '    pdfFormFields.SetField("22cCty", .Item("ud3_city") & "")
    '    pdfFormFields.SetField("22cSt", .Item("ud3_state") & "")
    '    pdfFormFields.SetField("22cPC", .Item("ud3_zipcode") & "")
    '    pdfFormFields.SetField("22cCtry", .Item("ud3_country") & "")
    '    pdfFormFields.SetField("22d", .Item("ud3_d1") & "")
    '    pdfFormFields.SetField("22e", .Item("ud3_org_type") & "")
    '    pdfFormFields.SetField("22f", .Item("ud3_org_jurisdiction") & "")
    '    pdfFormFields.SetField("22g", .Item("ud3_org_id") & "")
    '    pdfFormFields.SetField("22gCB", IIf(.Item("ud3_org_id_none") & "" = "Y", "Yes", "0"))
    '    'third debtor
    '    pdfFormFields.SetField("23a", .Item("ud4_org_name") & "")
    '    pdfFormFields.SetField("23bL", .Item("ud4_ind_last_name") & "")
    '    pdfFormFields.SetField("23bF", .Item("ud4_ind_first_name") & "")
    '    pdfFormFields.SetField("23bM", .Item("ud4_ind_middle_name") & "")
    '    pdfFormFields.SetField("23bS", .Item("ud4_ind_suffix") & "")
    '    pdfFormFields.SetField("23cMA", .Item("ud4_mailing_address") & "")
    '    pdfFormFields.SetField("23cCty", .Item("ud4_city") & "")
    '    pdfFormFields.SetField("23cSt", .Item("ud4_state") & "")
    '    pdfFormFields.SetField("23cPC", .Item("ud4_zipcode") & "")
    '    pdfFormFields.SetField("23cCtry", .Item("ud4_country") & "")
    '    pdfFormFields.SetField("23d", .Item("ud4_d1") & "")
    '    pdfFormFields.SetField("23e", .Item("ud4_org_type") & "")
    '    pdfFormFields.SetField("23f", .Item("ud4_org_jurisdiction") & "")
    '    pdfFormFields.SetField("23g", .Item("ud4_org_id") & "")
    '    pdfFormFields.SetField("23gCB", IIf(.Item("ud4_org_id_none") & "" = "Y", "Yes", "0"))

    '    'secured
    '    'pdfFormFields.SetField("1a3", .Item("ud1_org_name") & "")
    '    'pdfFormFields.SetField("1bL3", .Item("ud1_ind_last_name") & "")
    '    'pdfFormFields.SetField("1bF3", .Item("ud1_ind_first_name") & "")
    '    'pdfFormFields.SetField("1bM3", .Item("ud1_ind_middle_name") & "")
    '    'pdfFormFields.SetField("1bS3", .Item("ud1_ind_suffix") & "")
    '    'pdfFormFields.SetField("1c3", .Item("ud1_mailing_address") & "")
    '    'pdfFormFields.SetField("1cc3", .Item("ud1_city") & "")
    '    'pdfFormFields.SetField("1cs3", .Item("ud1_state") & "")
    '    'pdfFormFields.SetField("1cpc", .Item("ud1_zipcode") & "")
    '    'pdfFormFields.SetField("1cc3", .Item("ud1_country") & "")
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
    '    Response.AddHeader("content-disposition", "inline; filename=UCC1ap_" & .Item("ufap_id") & ".PDF")
    '    Response.BinaryWrite(arrByte)
    '  End With
    'End If
  End Sub

  Private Sub ListFieldNames()

    Dim pdfTemplate As String = UCC1ap_PDF

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
    pdfFormFields.SetField("20", sb.ToString)



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
