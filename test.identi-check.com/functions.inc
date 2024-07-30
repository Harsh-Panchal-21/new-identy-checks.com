<%
Function Lookup_Status(strStatus)
	Dim strRtn
	Select Case strStatus
		Case "N"
			strRtn = "New"
		Case "P"
			strRtn = "Pending"
		Case "C"
			strRtn = "Completed"
		Case Else
			strRtn = ""
	End Select
	Lookup_Status = strRtn
End Function

function iif(eval, true_part, false_part)
	dim rtn
	if (eval) then
		rtn = true_part
	else
		rtn = false_part
	end if
	iif = rtn
end function

Function Write_State_Select(strName,strSelected)
	dim sql, conn, rsState, strRtn, strSel
	Set conn = GetSQLServerConnection( db_machine, db_userid, db_password, db_database )
	sql = "Select STATE_ABBR,STATE_NAME From STATE_LIST Order By STATE_NAME"
	Set rsState = GetSQLServerRecordset( conn, sql)
	if not rsState.eof then
		strRtn = "<select name='" & strName & "'>" & vbCrLf
		strRtn = strRtn & "<option value=''>Select State</option>" & vbcrLf
		do while not rsState.eof
			if rsState("STATE_ABBR") = strSelected Then
				strSel = " SELECTED"
			else
				strSel = ""
			end if
			strRtn = strRtn & "<option value='" & rsState("STATE_ABBR") & "'" & strSel & ">" & rsState("STATE_NAME") & "</option>" & vbcrLf
			rsState.movenext
		loop
		strRtn = strRtn & "</select>" & vbcrLf
	end if
	rsState.close
	set rsState = nothing
	conn.close
	Set conn = nothing
	Write_State_Select = strRtn
End Function

Function Write_Everify(strName,strSelected)
	dim sql, conn, rsStatus, strRtn, strSel
	Set conn = GetSQLServerConnection( db_machine, db_userid, db_password, db_database )
	sql = "Select everifyStatusName From everifyStatusNames"
	Set rsStatus = GetSQLServerRecordset( conn, sql)
	if not rsStatus.eof then
		strRtn = "<select name='" & strName & "'>" & vbCrLf
		strRtn = strRtn & "<option value=''>Choose One ...</option>" & vbcrLf
		do while not rsStatus.eof
			if rsStatus("everifyStatusName") = strSelected Then
				strSel = " SELECTED"
			else
				strSel = ""
			end if
			strRtn = strRtn & "<option value='" & rsStatus("everifyStatusName") & "'" & strSel & ">" & rsStatus("everifyStatusName") & "</option>" & vbcrLf
			rsStatus.movenext
		loop
		
	end if
	rsStatus.close
	set rsStatus = nothing
	conn.close
	Set conn = nothing
	Write_Everify = strRtn
End Function

Function CreateGUID
  Dim TypeLib
  Set TypeLib = CreateObject("Scriptlet.TypeLib")
  CreateGUID = Replace(Mid(TypeLib.Guid, 2, 36),"-","")
	'returns like "47BC69BD-06A5-4617-B730-B644DBCD40A9"
	'to return full use CreateGUID = Left(TypeLib.Guid, 38) '{47BC69BD-06A5-4617-B730-B644DBCD40A9}'
End Function

Function ComplexPassword(strNewPassword,strUserID,strName) 
	dim blnDebug
		blnDebug = False
    'Desc: checks to see if strNewPassword is complex 
      On Error Resume Next  
      Dim intCount: intCount = 0 
      if len(strNewPassword) >= 6 and len(strNewPassword) <= 20 Then 
            intCount = intCount + 1 
						if blnDebug then response.write "--------------has length" & "<br />"
      End if 
      Dim objRegExp: Set objRegExp = New RegExp        
      objRegExp.IgnoreCase = False   
      'lower check 
      objRegExp.Pattern = "[a-z]"
      Dim strTestReturn: strTestReturn = objRegExp.Test(strNewPassword)     
      If strTestReturn Then  
            intCount = intCount + 1 
						if blnDebug then response.write "--------------has lower" & "<br />"
      End if 
      'Upper Check 
      objRegExp.Pattern = "[A-Z]"        
      strTestReturn = objRegExp.Test(strNewPassword)     
      If strTestReturn Then  
            intCount = intCount + 1 
						if blnDebug then response.write "--------------has upper" & "<br />"
      End if 
      'Number Check 
      objRegExp.Pattern = "[0-9]"        
      strTestReturn = objRegExp.Test(strNewPassword)     
      If strTestReturn Then  
            intCount = intCount + 1 
						if blnDebug then response.write "--------------has number" & "<br />"
      End if 
      'Special Chareter check 
      objRegExp.Pattern = "\W"        
      strTestReturn = objRegExp.Test(strNewPassword)     
      If strTestReturn Then  
            intCount = intCount + 1 
						if blnDebug then response.write "--------------has special" & "<br />"
      End if 

			dim badPass : badPass = 0
			'check for userid in password
			if instr(ucase(strNewPassword), uCase(strUserID)) <> 0 then
				badPass = badPass + 1
				if blnDebug then response.write "--------------userid<br />"
			end if

			dim names, fname, lname, mname
			fname = "" : mname = "" : lname = ""
			names = split(strName)
			if ubound(names) = 3 then
				if blnDebug then response.write "--------------3" & "<br />"
				fname = names(0)
				mname = names(1)
				lname = names(2)
				if blnDebug then response.write "--------------" & fname & "<br />"
				if blnDebug then response.write "--------------" & mname & "<br />"
				if blnDebug then response.write "--------------" & lname & "<br />"
				'check for first name
				if instr(ucase(strNewPassword), uCase(fname)) <> 0 then
					badPass = badPass + 1
				end if
				if instr(ucase(strNewPassword), uCase(mname)) <> 0 then
					badPass = badPass + 1
				end if
				if instr(ucase(strNewPassword), uCase(lname)) <> 0 then
					badPass = badPass + 1
				end if
			elseif ubound(names) = 2 then
				if blnDebug then response.write "--------------2"
				fname = names(0)
				mname = names(1)
				lname = names(2)
				if blnDebug then response.write "--------------" & fname & "<br />"
				if blnDebug then response.write "--------------" & mname & "<br />"
				if blnDebug then response.write "--------------" & lname & "<br />"
				'check for first name
				if instr(ucase(strNewPassword), uCase(fname)) <> 0 then
					badPass = badPass + 1
				end if
				if instr(ucase(strNewPassword), uCase(mname)) <> 0 then
					badPass = badPass + 1
				end if
				if instr(ucase(strNewPassword), uCase(lname)) <> 0 then
					badPass = badPass + 1
				end if
			elseif ubound(names) = 1 then
				if blnDebug then response.write "--------------1" & "<br />"
				fname = names(0)
				lname = names(1)
				if blnDebug then response.write "--------------" & fname & "<br />"
				if blnDebug then response.write "--------------" & lname & "<br />"
				'check for first name
				if instr(ucase(strNewPassword), uCase(fname)) <> 0 then
					badPass = badPass + 1
					'response.write "--------------fname<br />"
				end if
				if instr(ucase(strNewPassword), uCase(lname)) <> 0 then
					badPass = badPass + 1
					'response.write "--------------lname<br />"
				end if
			elseif ubound(names) > 3 then
				if blnDebug then response.write "-------------->3"
				fname = names(0)
				mname = names(1)
				lname = names(2)
				'check for first name
				if instr(ucase(strNewPassword), uCase(fname)) <> 0 then
					badPass = badPass + 1
				end if
				if instr(ucase(strNewPassword), uCase(mname)) <> 0 then
					badPass = badPass + 1
				end if
				if instr(ucase(strNewPassword), uCase(lname)) <> 0 then
					badPass = badPass + 1
				end if
			end if
			

      'Tally 
      if intCount >= 4 and badPass = 0 Then 
            ComplexPassword = vbTrue 
      Else 
            ComplexPassword = vbFalse 
      End if 
      Set objRegExp = Nothing 
End Function 
%>