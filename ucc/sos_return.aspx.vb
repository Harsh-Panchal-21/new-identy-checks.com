Imports System.Xml
Imports System.Data.SqlClient

Partial Class sos_return
  Inherits System.Web.UI.Page
	Private _log As log4net.ILog = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType)

	Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
    Dim sbForm As New System.Text.StringBuilder
    Dim i As Integer
    Dim itemName As String
    Dim itemValue As String
		Dim sosxml As New SOS_XML
		Dim sSQL As String = ""

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
		sbForm.Append(Replace(Server.UrlDecode(Request.Form.ToString), "content=<?xml", "<?xml"))

		If Request.Form.ToString.IndexOf("Acknowledgement") > 0 Then
			Try
				'ExecuteScalar("Insert Into ucc_xml_result (umr_result) values ('Test inside Ack');")
				Dim retDoc As New XmlDocument
				retDoc.LoadXml(sbForm.ToString)
				Dim trans_type As XmlElement = retDoc.SelectSingleNode("//Document/Record/TransType")
				Dim packet_num As XmlElement = retDoc.SelectSingleNode("//Document/Header/PacketNum")
				Dim ack_filenumber As XmlElement = retDoc.SelectSingleNode("//Document/Record/Acknowledgement/FileNumber")
				Dim ack_filedate As XmlElement = retDoc.SelectSingleNode("//Document/Record/Acknowledgement/FileDate")
				Dim ack_filetime As XmlElement = retDoc.SelectSingleNode("//Document/Record/Acknowledgement/FileTime")
				Dim ack_filestatus As XmlElement = retDoc.SelectSingleNode("//Document/Record/Acknowledgement/FileStatus")
				Dim ack_fileoffice As XmlElement = retDoc.SelectSingleNode("//Document/Record/Acknowledgement/FileOffice")
				Dim ack_fileamount As XmlElement = retDoc.SelectSingleNode("//Document/Record/Acknowledgement/FileAmount")
				'Dim rec_sec_secname_names_state As XmlElement = retDoc.SelectSingleNode("//Document/Record/Secured/SecuredName/Names/State")
				If ack_filenumber Is Nothing Then
					ack_filenumber = retDoc.SelectSingleNode("//Document/Acknowledgement/FileNumber")
				End If
				If ack_filedate Is Nothing Then
					ack_filedate = retDoc.SelectSingleNode("//Document/Acknowledgement/FileDate")
				End If
				If ack_filetime Is Nothing Then
					ack_filetime = retDoc.SelectSingleNode("//Document/Acknowledgement/FileTime")
				End If
				If ack_filestatus Is Nothing Then
					ack_filestatus = retDoc.SelectSingleNode("//Document/Acknowledgement/FileStatus")
				End If
				If ack_fileoffice Is Nothing Then
					ack_fileoffice = retDoc.SelectSingleNode("//Document/Acknowledgement/FileOffice")
				End If
				If ack_fileamount Is Nothing Then
					ack_fileamount = retDoc.SelectSingleNode("//Document/Acknowledgement/FileAmount")
				End If

				'ExecuteScalar("Insert Into ucc_xml_result (umr_result) values ('After get elements');")
				Dim sPacketNum As String = packet_num.InnerText
				Dim sFileNo As String = ack_filenumber.InnerText
				Dim sFileDate As String = ack_filedate.InnerText
				Dim sFileTime As String = ack_filetime.InnerText
				Dim sFileStatus As String = "", sFileOffice As String = "", sFileAmount As String = ""
				Dim sState As String = ""
				Dim sFileDT As String = "1/1/1900"
				Dim sErrorNodePath As String = "//Document/Record/Acknowledgement/Errors/ErrorText"
				If ack_filestatus.Attributes("Status") IsNot Nothing Then
					_log.Info("IL return call")
					sState = "IL"
					sFileStatus = ack_filestatus.Attributes("Status").Value
					sFileDT = sFileDate.Substring(4, 2) & "/" & sFileDate.Substring(6, 2) & "/" & sFileDate.Substring(0, 4) &
					" " & sFileTime.Substring(0, 2) & ":" & sFileTime.Substring(2, 2)
				Else
					_log.Info("WI return call")
					sState = "WI"
					sFileStatus = ack_filestatus.InnerText
					sFileDT = sFileDate.Substring(0, 2) & "/" & sFileDate.Substring(2, 2) & "/" & sFileDate.Substring(4, 4) &
					" " & sFileTime.Substring(0, 8)
					sErrorNodePath = "//Document/Acknowledgement/Errors/ErrorText"
				End If
				If ack_fileoffice IsNot Nothing Then
					sFileOffice = ack_fileoffice.InnerText
				End If
				If ack_fileamount IsNot Nothing Then
					sFileAmount = ack_fileamount.InnerText
				End If
				'If rec_sec_secname_names_state IsNot Nothing Then
				'	sState = rec_sec_secname_names_state.InnerText
				'End If

				'ExecuteScalar("Insert Into ucc_xml_result (umr_result) values ('after set variables');")
				If trans_type.Attributes("Type").Value = "Initial" Then
					If sFileStatus = "Accepted" Then
						'ExecuteScalar("Insert Into ucc_xml_result (umr_result) values ('Initial and Accepted');")
						sSQL = "update ucc_financing set uf_file_no = '" & sFileNo & "', " &
						"uf_filing_date = '" & sFileDT & "', uf_status = 'F' " &
						"where uf_packet_num = '" & sPacketNum & "'"
						RunCommand(sSQL)
						'RetrieveDocument using doc_receipt_id
						Dim sDocID As String = ExecuteScalar("Select uf_doc_receipt_id from ucc_financing where uf_packet_num = '" & sPacketNum & "'")
						'RunCommand("Insert Into ucc_xml_result (umr_result) values ('SQL: " & sSQL.Replace("'", "''") & "')")
						'RetrieveDocument using doc_receipt_id
						Dim byteTemp As Byte() = Nothing
						Dim sResult As String = ""
						If sState = "" Or sState = "IL" Then
							sResult = sosxml.RetrieveDocument(sDocID, byteTemp)
						ElseIf sState = "WI" Then
							_log.Info("Call RetrieveDocumentWI with " & sFileNo)
							sResult = sosxml.RetrieveDocumentWI(sFileNo, byteTemp)
						End If

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
						Dim ack_errortext As XmlElement = retDoc.SelectSingleNode(sErrorNodePath)
						Dim sError As String = ack_errortext.InnerText
						sSQL = "update ucc_financing set uf_file_no = null, " &
							"uf_filing_date = null, uf_status = 'R', uf_status_reason = '" & sError.Trim.Replace("'", "''") & "' " &
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
						sSQL = "update ucc3 set u3_validation_number = '" & sFileNo & "', " &
						"u3_filing_date = '" & sFileDT & "', u3_status = 'F' " &
						"where u3_packet_num = '" & sPacketNum & "'"
						RunCommand(sSQL)
						Dim sDocID As String = ExecuteScalar("Select u3_doc_receipt_id from ucc3 where u3_packet_num = '" & sPacketNum & "'")
						'RunCommand("Insert Into ucc_xml_result (umr_result) values ('SQL: " & sSQL.Replace("'", "''") & "')")
						'RetrieveDocument using doc_receipt_id
						Dim byteTemp As Byte() = Nothing
						Dim sResult As String = ""
						'Dim sResult As String = sosxml.RetrieveDocument(sDocID, byteTemp)
						If sState = "" Or sState = "IL" Then
							sResult = sosxml.RetrieveDocument(sDocID, byteTemp)
						ElseIf sState = "WI" Then
							_log.Info("Call RetrieveDocumentWI with " & sFileNo)
							sResult = sosxml.RetrieveDocumentWI(sFileNo, byteTemp)
						End If
						If sResult = "OK" Then
							Using myConnection As New SqlConnection(CNNStr)
								Dim myCommand As SqlCommand
								sSQL = "Update ucc3 set u3_file_attach = @ImageData Where u3_packet_num = '" & sPacketNum & "'"
								myCommand = New SqlCommand(sSQL, myConnection)
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
						Dim ack_errortext As XmlElement = retDoc.SelectSingleNode(sErrorNodePath)
						Dim sError As String = ack_errortext.InnerText
						sSQL = "update ucc3 set u3_validation_number = null, " &
							"u3_filing_date = null, u3_status = 'R', u3_status_reason = '" & sError.Trim.Replace("'", "''") & "' " &
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
			Catch sqlex As SqlException
				_log.Error("Error - sql: " & sSQL & " - " & sqlex.ToString)
			Catch ex As Exception
				_log.Error("Error - " & ex.ToString)
				'RunCommand("Insert Into ucc_xml_result (umr_result) values ('" & ex.ToString.Replace("'", "''") & "')")
			End Try

      'ack.Item("Errors")
    Else
			'error, return details
			'sRtn = sbForm.ToString
			ExecuteScalar("Insert Into ucc_xml_result (umr_result) values ('Form does not have acknowledgement?');")
		End If


  End Sub
End Class
