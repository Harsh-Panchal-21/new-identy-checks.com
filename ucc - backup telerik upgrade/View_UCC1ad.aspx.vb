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
    arrByte = GetUCC1ad_PDF(sID, com_id, Session("has_sub_companies"))

    Response.Expires = -1000
    Response.ContentType = "application/pdf"
    Response.AddHeader("content-length", arrByte.Length.ToString())
    Response.AddHeader("content-disposition", "inline; filename=UCC1ad_" & sID & ".PDF")
    Response.BinaryWrite(arrByte)
    'Dim strSQL As String
    'Dim dtData As New DataTable

    'SQLstr = "Select iav.*, c.ADDRESS, c.CITY, c.STATE, c.ZIPCODE, c.PHONE, c.FAX " & _
    ' "From INVOICE_AR_VW iav inner join COMPANY c on iav.COMPANY_RID = c.RID " & _
    ' "Where COMPANY_RID = " & Session("LoginedCompanyRID") & " and iav.RID = " & Request.QueryString("ID")
    'strSQL = "Select ufad.*, " & _
    '  "ud1.ud_id as ud1_id,ud1.ud_org_name as ud1_org_name,ud1.ud_ind_last_name as ud1_ind_last_name,ud1.ud_ind_first_name as ud1_ind_first_name,ud1.ud_ind_middle_name as ud1_ind_middle_name,ud1.ud_ind_suffix as ud1_ind_suffix,ud1.ud_mailing_address as ud1_mailing_address,ud1.ud_city as ud1_city,ud1.ud_state as ud1_state,ud1.ud_zipcode as ud1_zipcode,ud1.ud_country as ud1_country,ud1.ud_d1 as ud1_d1,ud1.ud_org_type as ud1_org_type,ud1.ud_org_jurisdiction as ud1_org_jurisdiction,ud1.ud_org_id as ud1_org_id,ud1.ud_org_id_none as ud1_org_id_none, " & _
    '  "ud2.ud_id as ud2_id,ud2.ud_org_name as ud2_org_name,ud2.ud_ind_last_name as ud2_ind_last_name,ud2.ud_ind_first_name as ud2_ind_first_name,ud2.ud_ind_middle_name as ud2_ind_middle_name,ud2.ud_ind_suffix as ud2_ind_suffix,ud2.ud_mailing_address as ud2_mailing_address,ud2.ud_city as ud2_city,ud2.ud_state as ud2_state,ud2.ud_zipcode as ud2_zipcode,ud2.ud_country as ud2_country,ud2.ud_d1 as ud2_d1,ud2.ud_org_type as ud2_org_type,ud2.ud_org_jurisdiction as ud2_org_jurisdiction,ud2.ud_org_id as ud2_org_id,ud2.ud_org_id_none as ud2_org_id_none " & _
    '  "From ucc_financing_ad as ufad inner join ucc_financing as uf on ufad_uf_id = uf.uf_id " & _
    '  "left outer join ucc_debtor as ud1 on uf.uf_debtor1 = ud1.ud_id " & _
    '  "left outer join ucc_debtor as ud2 on ufad.ufad_debtor3 = ud2.ud_id " & _
    '  "Where ufad_id = " & intRID

    'dtData = FillDataTable(strSQL)
    'If dtData.Rows.Count > 0 Then
    '  With dtData.Rows(0)
    '    Dim pdfTemplate As String = UCC1ad_PDF
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
    '    pdfFormFields.SetField("9a", .Item("ud1_org_name") & "")
    '    pdfFormFields.SetField("9bL", .Item("ud1_ind_last_name") & "")
    '    pdfFormFields.SetField("9bF", .Item("ud1_ind_first_name") & "")
    '    pdfFormFields.SetField("9bMS", .Item("ud1_ind_middle_name") & ", " & .Item("ud1_ind_suffix") & "")

    '    'additional debtor
    '    pdfFormFields.SetField("11a", .Item("ud2_org_name") & "")
    '    pdfFormFields.SetField("11bL", .Item("ud2_ind_last_name") & "")
    '    pdfFormFields.SetField("11bF", .Item("ud2_ind_first_name") & "")
    '    pdfFormFields.SetField("11bM", .Item("ud2_ind_middle_name") & "")
    '    pdfFormFields.SetField("11bS", .Item("ud2_ind_suffix") & "")
    '    pdfFormFields.SetField("11cMA", .Item("ud2_mailing_address") & "")
    '    pdfFormFields.SetField("11cCty", .Item("ud2_city") & "")
    '    pdfFormFields.SetField("11cSt", .Item("ud2_state") & "")
    '    pdfFormFields.SetField("11cPC", .Item("ud2_zipcode") & "")
    '    pdfFormFields.SetField("11cCtry", .Item("ud2_country") & "")
    '    pdfFormFields.SetField("11d", .Item("ud2_d1") & "")
    '    pdfFormFields.SetField("11e", .Item("ud2_org_type") & "")
    '    pdfFormFields.SetField("11f", .Item("ud2_org_jurisdiction") & "")
    '    pdfFormFields.SetField("11g", .Item("ud2_org_id") & "")
    '    pdfFormFields.SetField("11gCB", IIf(.Item("ud2_org_id_none") & "" = "Y", "Yes", "0"))
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
    '    If .Item("ufad_covers") & "" = "T" Then
    '      pdfFormFields.SetField("13CB", "1")
    '    ElseIf .Item("ufad_covers") & "" = "A" Then
    '      pdfFormFields.SetField("13CB", "2")
    '    ElseIf .Item("ufad_covers") & "" = "F" Then
    '      pdfFormFields.SetField("13CB", "3")
    '    End If

    '    pdfFormFields.SetField("10", .Item("ufad_misc") & "")
    '    pdfFormFields.SetField("14", .Item("ufad_real_estate") & "")
    '    pdfFormFields.SetField("15", .Item("ufad_record_owner") & "")
    '    pdfFormFields.SetField("16", .Item("ufad_collateral") & "")

    '    If .Item("ufad_debtor_trust") & "" = "T" Then
    '      pdfFormFields.SetField("17CB", "1")
    '    ElseIf .Item("ufad_debtor_trust") & "" = "E" Then
    '      pdfFormFields.SetField("17CB", "2")
    '    ElseIf .Item("ufad_debtor_trust") & "" = "D" Then
    '      pdfFormFields.SetField("17CB", "3")
    '    End If

    '    If .Item("ufad_debtor_is") & "" = "T" Then
    '      pdfFormFields.SetField("18CB", "1")
    '    ElseIf .Item("ufad_debtor_is") & "" = "M" Then
    '      pdfFormFields.SetField("18CB", "2")
    '    ElseIf .Item("ufad_debtor_is") & "" = "P" Then
    '      pdfFormFields.SetField("18CB", "3")
    '    End If

    '    'Dim sCovers As String = .Item("ufad_covers") & ""
    '    'pdfFormFields.SetField("13CB", IIf(sAltDes.Substring(0, 1) = "L", "Yes", "0"))
    '    'pdfFormFields.SetField("5b", IIf(sAltDes.Substring(1, 1) = "C", "Yes", "0"))
    '    'pdfFormFields.SetField("5c", IIf(sAltDes.Substring(2, 1) = "B", "Yes", "0"))
    '    'pdfFormFields.SetField("5d", IIf(sAltDes.Substring(3, 1) = "S", "Yes", "0"))
    '    'pdfFormFields.SetField("5e", IIf(sAltDes.Substring(4, 1) = "A", "Yes", "0"))
    '    'pdfFormFields.SetField("5f", IIf(sAltDes.Substring(5, 1) = "N", "Yes", "0"))


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
    '    Response.AddHeader("content-disposition", "inline; filename=UCC1ad_" & .Item("ufad_id") & ".PDF")
    '    Response.BinaryWrite(arrByte)
    '  End With
    'End If
  End Sub

  Private Sub ListFieldNames()

    Dim pdfTemplate As String = UCC1ad_PDF

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
    pdfFormFields.SetField("10", sb.ToString)



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
