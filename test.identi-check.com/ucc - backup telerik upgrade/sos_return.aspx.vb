Imports System.Xml
Imports System.Data.SqlClient

Partial Class sos_return
  Inherits System.Web.UI.Page

  Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
    Dim sbForm As New System.Text.StringBuilder
    Dim i As Integer
    Dim itemName As String
    Dim itemValue As String
    Dim sosxml As New SOS_XML

    'Request.Headers.
    'For i = 0 To Request.Headers.Count - 1
    '  itemName = Request.Headers.Keys(i)
    '  itemValue = Request.Headers.Item(i)
    '  'sbForm.Append(itemName & ":" & itemValue & "~")
    '  sbForm.Append(itemName & "=" & itemValue)
    'Next
    'Request.Form.ToString
    'RunCommand("Insert Into ucc_xml_result (umr_result) values ('" & _
    '                                  Server.UrlDecode(Request.Form.ToString).Replace("'", "''") & "'); Select Scope_Identity()")

    Dim sID As String = ExecuteScalar("Insert Into ucc_xml_result (umr_result) values ('" & _
                                      Server.UrlDecode(Request.Form.ToString).Replace("'", "''") & "'); Select Scope_Identity()")

    'For i = 0 To Request.Form.Count - 1
    '  itemName = Request.Form.Keys(i)
    '  itemValue = Request.Form.Item(i)
    '  'sbForm.Append(itemName & ":" & itemValue & "~")
    '  sbForm.Append(itemName & "=" & itemValue)
    'Next
    sbForm.Append(Server.UrlDecode(Request.Form.ToString))

    If Request.Form.ToString.IndexOf("Acknowledgement") > 0 Then
      Try
        'ExecuteScalar("Insert Into ucc_xml_result (umr_result) values ('Test inside Ack');")
        Dim retDoc As New XmlDocument, sSQL As String = ""
        retDoc.LoadXml(sbForm.ToString)
        Dim trans_type As XmlElement = retDoc.SelectSingleNode("//Document/Record/TransType")
        Dim packet_num As XmlElement = retDoc.SelectSingleNode("//Document/Header/PacketNum")
        Dim ack_filenumber As XmlElement = retDoc.SelectSingleNode("//Document/Record/Acknowledgement/FileNumber")
        Dim ack_filedate As XmlElement = retDoc.SelectSingleNode("//Document/Record/Acknowledgement/FileDate")
        Dim ack_filetime As XmlElement = retDoc.SelectSingleNode("//Document/Record/Acknowledgement/FileTime")
        Dim ack_filestatus As XmlElement = retDoc.SelectSingleNode("//Document/Record/Acknowledgement/FileStatus")
        'ExecuteScalar("Insert Into ucc_xml_result (umr_result) values ('After get elements');")
        Dim sPacketNum As String = packet_num.InnerText
        Dim sFileNo As String = ack_filenumber.InnerText
        Dim sFileDate As String = ack_filedate.InnerText
        Dim sFileTime As String = ack_filetime.InnerText
        Dim sFileStatus As String = ack_filestatus.Attributes("Status").Value
        'ExecuteScalar("Insert Into ucc_xml_result (umr_result) values ('after set variables');")
        Dim sFileDT As String = "1/1/1900"
        sFileDT = sFileDate.Substring(4, 2) & "/" & sFileDate.Substring(6, 2) & "/" & sFileDate.Substring(0, 4) & _
          " " & sFileTime.Substring(0, 2) & ":" & sFileTime.Substring(2, 2)

        If trans_type.Attributes("Type").Value = "Initial" Then
          If sFileStatus = "Accepted" Then
            'ExecuteScalar("Insert Into ucc_xml_result (umr_result) values ('Initial and Accepted');")
            sSQL = "update ucc_financing set uf_file_no = '" & sFileNo & "', " & _
            "uf_filing_date = '" & sFileDT & "', uf_status = 'F' " & _
            "where uf_packet_num = '" & sPacketNum & "'"
            RunCommand(sSQL)
            'RetrieveDocument using doc_receipt_id
            Dim sDocID As String = ExecuteScalar("Select uf_doc_receipt_id from ucc_financing where uf_packet_num = '" & sPacketNum & "'")
            'RunCommand("Insert Into ucc_xml_result (umr_result) values ('SQL: " & sSQL.Replace("'", "''") & "')")
            'RetrieveDocument using doc_receipt_id
            Dim byteTemp As Byte() = Nothing
            Dim sResult As String = sosxml.RetrieveDocument(sDocID, byteTemp)
            If sResult = "OK" Then
              Using myConnection As New SqlConnection(CNNStr)
                Dim SQL As String = ""
                Dim myCommand As SqlCommand
                SQL = "Update ucc_financing set uf_file_attach = @ImageData Where uf_packet_num = '" & sPacketNum & "'"
                myCommand = New SqlCommand(SQL, myConnection)
                myCommand.Parameters.AddWithValue("@ImageData", byteTemp)
                'RunCommand("Insert Into ucc_xml_result (umr_result) values ('SQL: " & SQL.Replace("'", "''") & "')")

                myConnection.Open()
                myCommand.ExecuteNonQuery()
                myConnection.Close()
              End Using
            Else
              RunCommand("Insert Into ucc_xml_result (umr_result) values ('DocID: " & sDocID & " - Result: " & sResult & "')")
            End If
          ElseIf sFileStatus = "Rejected" Then
            'ExecuteScalar("Insert Into ucc_xml_result (umr_result) values ('Initial and Rejected');")
            Dim ack_errortext As XmlElement = retDoc.SelectSingleNode("//Document/Record/Acknowledgement/Errors/ErrorText")
            Dim sError As String = ack_errortext.InnerText
            sSQL = "update ucc_financing set uf_file_no = null, " & _
              "uf_filing_date = null, uf_status = 'R', uf_status_reason = '" & sError.Trim.Replace("'", "''") & "' " & _
              "where uf_packet_num = '" & sPacketNum & "'"
            RunCommand(sSQL)
          Else
            'error
            RunCommand("Insert Into ucc_xml_result (umr_result) values ('PacketNum: " & sPacketNum & " - Status: " & sFileStatus & "')")
          End If
          RunCommand("update ucc_xml_result set umr_processed = 1 where umr_id = " & sID)
        ElseIf trans_type.Attributes("Type").Value = "Amendment" Then
          'ExecuteScalar("Insert Into ucc_xml_result (umr_result) values ('Amendment');")
          If sFileStatus = "Accepted" Then
            'ExecuteScalar("Insert Into ucc_xml_result (umr_result) values ('Amendment and Accepted');")
            sSQL = "update ucc3 set u3_validation_number = '" & sFileNo & "', " & _
            "u3_filing_date = '" & sFileDT & "', u3_status = 'F' " & _
            "where u3_packet_num = '" & sPacketNum & "'"
            RunCommand(sSQL)
            Dim sDocID As String = ExecuteScalar("Select u3_doc_receipt_id from ucc3 where u3_packet_num = '" & sPacketNum & "'")
            'RunCommand("Insert Into ucc_xml_result (umr_result) values ('SQL: " & sSQL.Replace("'", "''") & "')")
            'RetrieveDocument using doc_receipt_id
            Dim byteTemp As Byte() = Nothing
            Dim sResult As String = sosxml.RetrieveDocument(sDocID, byteTemp)
            If sResult = "OK" Then
              Using myConnection As New SqlConnection(CNNStr)
                Dim SQL As String = ""
                Dim myCommand As SqlCommand
                SQL = "Update ucc3 set u3_file_attach = @ImageData Where u3_packet_num = '" & sPacketNum & "'"
                myCommand = New SqlCommand(SQL, myConnection)
                myCommand.Parameters.AddWithValue("@ImageData", byteTemp)

                myConnection.Open()
                myCommand.ExecuteNonQuery()
                myConnection.Close()
              End Using
            Else
              RunCommand("Insert Into ucc_xml_result (umr_result) values ('DocID: " & sDocID & " - Result: " & sResult & "')")
            End If

          ElseIf sFileStatus = "Rejected" Then
            'ExecuteScalar("Insert Into ucc_xml_result (umr_result) values ('Amendment and Rejected');")
            Dim ack_errortext As XmlElement = retDoc.SelectSingleNode("//Document/Record/Acknowledgement/Errors/ErrorText")
            Dim sError As String = ack_errortext.InnerText
            sSQL = "update ucc3 set u3_validation_number = null, " & _
              "u3_filing_date = null, u3_status = 'R', u3_status_reason = '" & sError.Trim.Replace("'", "''") & "' " & _
              "where u3_packet_num = '" & sPacketNum & "'"
            RunCommand(sSQL)
          Else
            'error
            RunCommand("Insert Into ucc_xml_result (umr_result) values ('PacketNum: " & sPacketNum & " - Status: " & sFileStatus & "')")
          End If

          RunCommand("update ucc_xml_result set umr_processed = 1 where umr_id = " & sID)
        Else
          RunCommand("Insert Into ucc_xml_result (umr_result) values ('" & trans_type.Attributes("Type").Value & "')")
        End If
        'RunCommand("Insert Into ucc_xml_result (umr_result) values ('SQL: " & sSQL.Replace("'", "''") & "')")
      Catch ex As Exception
        RunCommand("Insert Into ucc_xml_result (umr_result) values ('" & ex.ToString.Replace("'", "''") & "')")
      End Try

      'ack.Item("Errors")
    Else
      'error, return details
      'sRtn = sbForm.ToString
      ExecuteScalar("Insert Into ucc_xml_result (umr_result) values ('Form does not have acknoledgement?');")
    End If


  End Sub
End Class
