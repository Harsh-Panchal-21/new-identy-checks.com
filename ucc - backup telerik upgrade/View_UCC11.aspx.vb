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

    Dim com_id As String, sWhereCom As String = ""
    If Session("admin") = "2" Then
      com_id = Request.QueryString("com")
      sWhereCom = " = " & com_id & " "
    Else
      com_id = Session("company_rid")
      If Session("has_sub_companies") = "Y" Then
        sWhereCom = " in (Select company_id from subscriber where parent_company_id = " & com_id & ") "
      Else
        sWhereCom = " = " & com_id & " "
      End If
    End If

    Dim intRID As Integer
    intRID = Request.QueryString("id")

    Dim strSQL As String
    Dim dtData As New DataTable

    'SQLstr = "Select iav.*, c.ADDRESS, c.CITY, c.STATE, c.ZIPCODE, c.PHONE, c.FAX " & _
    ' "From INVOICE_AR_VW iav inner join COMPANY c on iav.COMPANY_RID = c.RID " & _
    ' "Where COMPANY_RID = " & Session("LoginedCompanyRID") & " and iav.RID = " & Request.QueryString("ID")
    strSQL = "Select us.*, " & _
      "ud1.ud_id as ud1_id,ud1.ud_org_name as ud1_org_name,ud1.ud_ind_last_name as ud1_ind_last_name,ud1.ud_ind_first_name as ud1_ind_first_name,ud1.ud_ind_middle_name as ud1_ind_middle_name,ud1.ud_ind_suffix as ud1_ind_suffix,ud1.ud_mailing_address as ud1_mailing_address,ud1.ud_city as ud1_city,ud1.ud_state as ud1_state,ud1.ud_zipcode as ud1_zipcode,ud1.ud_country as ud1_country,ud1.ud_d1 as ud1_d1,ud1.ud_org_type as ud1_org_type,ud1.ud_org_jurisdiction as ud1_org_jurisdiction,ud1.ud_org_id as ud1_org_id,ud1.ud_org_id_none as ud1_org_id_none " & _
      "From ucc_search as us left outer join ucc_debtor as ud1 on us.us_debtor = ud1.ud_id " & _
      "Where us_id = " & intRID & " and us_company_id " & sWhereCom

    dtData = FillDataTable(strSQL)
    If dtData.Rows.Count > 0 Then
      With dtData.Rows(0)
        Dim pdfTemplate As String = UCC11_PDF
        Dim memStream As New MemoryStream

        Dim pdfReader As New PdfReader(pdfTemplate)
        ' New FileStream(newFile, FileMode.Create)
        Dim pdfStamper = New PdfStamper(pdfReader, memStream)
        Dim pdfFormFields As AcroFields = pdfStamper.AcroFields

        'Dim iCount As Integer = 0
        '// set form pdfFormFields
        pdfFormFields.SetField("A1", "Micah King, 217-753-4311")
        pdfFormFields.SetField("A2", Filing_Office_Acct_No)
        pdfFormFields.SetField("B", "info@identi-check.com")
        pdfFormFields.SetField("C", "Identi-Check, Inc." & Environment.NewLine & "3 North Old State Capitol Plaza" & Environment.NewLine & "Springfield, IL 62701")
        'first debtor
        pdfFormFields.SetField("1a", .Item("ud1_org_name") & "")
        pdfFormFields.SetField("1b", .Item("ud1_ind_last_name") & "")
        pdfFormFields.SetField("1bF", .Item("ud1_ind_first_name") & "")
        pdfFormFields.SetField("1bA", .Item("ud1_ind_middle_name") & "")
        pdfFormFields.SetField("1bSfx", .Item("ud1_ind_suffix") & "")

        'checkboxes
        pdfFormFields.SetField("2aA", IIf(.Item("us_sr_certified") & "" = "Y", "Yes", ""))
        pdfFormFields.SetField("2aB", IIf(.Item("us_sr") & "" = "A", "1", IIf(.Item("us_sr") & "" = "U", "2", "")))

        pdfFormFields.SetField("2bA", IIf(.Item("us_sr_certified") & "" = "Y", "Yes", ""))
        pdfFormFields.SetField("2bB", IIf(.Item("us_cr") & "" = "A", "1", IIf(.Item("us_cr") & "" = "U", "2", "")))

        pdfFormFields.SetField("2cA", IIf(.Item("us_sr_certified") & "" = "Y", "Yes", ""))
        
        pdfFormFields.SetField("2cRN#1", .Item("us_sco1_rec_no") & "")
        pdfFormFields.SetField("2cDRF#1", .Item("us_sco1_date") & "")
        pdfFormFields.SetField("2cTR#1", .Item("us_sco1_type") & "")
        pdfFormFields.SetField("2cRN#2", .Item("us_sco2_rec_no") & "")
        pdfFormFields.SetField("2cDRF#2", .Item("us_sco2_date") & "")
        pdfFormFields.SetField("2cTR#2", .Item("us_sco2_type") & "")
        pdfFormFields.SetField("2cRN#3", .Item("us_sco3_rec_no") & "")
        pdfFormFields.SetField("2cDRF#3", .Item("us_sco3_date") & "")
        pdfFormFields.SetField("2cTR#3", .Item("us_sco3_type") & "")
        pdfFormFields.SetField("2cRN#4", .Item("us_sco4_rec_no") & "")
        pdfFormFields.SetField("2cDRF#4", .Item("us_sco4_date") & "")
        pdfFormFields.SetField("2cTR#4", .Item("us_sco4_type") & "")
        pdfFormFields.SetField("2cRN#5", .Item("us_sco5_rec_no") & "")
        pdfFormFields.SetField("2cDRF#5", .Item("us_sco5_date") & "")
        pdfFormFields.SetField("2cTR#5", .Item("us_sco5_type") & "")
        pdfFormFields.SetField("2cRN#6", .Item("us_sco6_rec_no") & "")
        pdfFormFields.SetField("2cDRF#6", .Item("us_sco6_date") & "")
        pdfFormFields.SetField("2cTR#6", .Item("us_sco6_type") & "")
        
        '4 - financing
        'pdfFormFields.SetField("4", .Item("uf_finance_statement") & "")
        'Dim sAltDes As String = .Item("uf_alt_designation") & ""
        'pdfFormFields.SetField("5a", IIf(sAltDes.Substring(0, 1) = "L", "Yes", "0"))
        'pdfFormFields.SetField("5b", IIf(sAltDes.Substring(1, 1) = "C", "Yes", "0"))
        'pdfFormFields.SetField("5c", IIf(sAltDes.Substring(2, 1) = "B", "Yes", "0"))
        'pdfFormFields.SetField("5d", IIf(sAltDes.Substring(3, 1) = "S", "Yes", "0"))
        'pdfFormFields.SetField("5e", IIf(sAltDes.Substring(4, 1) = "A", "Yes", "0"))
        'pdfFormFields.SetField("5f", IIf(sAltDes.Substring(5, 1) = "N", "Yes", "0"))

        'pdfFormFields.SetField("6a", IIf(.Item("uf_file_real_estate") & "" = "Y", "Yes", "0"))

        'pdfFormFields.SetField("7a", IIf(.Item("uf_request_search") & "" = "A", "Yes", "0"))
        'pdfFormFields.SetField("7b", IIf(.Item("uf_request_search") & "" = "1", "Yes", "0"))
        'pdfFormFields.SetField("7c", IIf(.Item("uf_request_search") & "" = "2", "Yes", "0"))

        pdfFormFields.SetField("3", .Item("us_additional") & "")

        pdfFormFields.SetField("4", "1")
        '4b - other specify

        'pdfFormFields.SetField("form1[0].#subform[0].Body[0].txtDescription[0]", "")
        'pdfFormFields.SetField("form1[0].#subform[0].Body[0].numQty[0]", "")
        'pdfFormFields.SetField("form1[0].#subform[0].Body[0].numUnitPrice[0]", "")
        'pdfFormFields.SetField("form1[0].#subform[0].Body[0].numAmount[0]", "")


        'form1[0].#subform[0].Body[0].numAmtReceived[0]", "")


        '// The form's checkboxes
        'pdfFormFields.SetField("c1_01(0)", "0")
        'pdfFormFields.SetField("c1_02(0)", "Yes")
        'pdfFormFields.SetField("c1_03(0)", "0")
        'pdfFormFields.SetField("c1_04(0)", "Yes")

        '// report by reading values from completed PDF
        'Dim sTmp As String = "W-4 Completed for " + pdfFormFields.GetField("f1_09(0)") + " " + pdfFormFields.GetField("f1_10(0)")
        'MessageBox.Show(sTmp, "Finished")

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
        Response.AddHeader("content-disposition", "inline; filename=UCC11_" & .Item("us_id") & ".PDF")
        Response.BinaryWrite(arrByte)
      End With
    End If
  End Sub

  Private Sub ListFieldNames()

    'UCC1_PDF, UCC1ad_PDF, UCC1ap_PDF
    'UCC3_PDF, UCC3ad_PDF, UCC3ap_PDF
    'UCC11_PDF
    Dim pdfTemplate As String = UCC11_PDF

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
    'pdfFormFields.SetField("3", sb.ToString)



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
