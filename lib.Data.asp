<%
Class Database_Class
  Private m_connection
  Private m_connection_string
  
  '---------------------------------------------------------------------------------------------------------------------
  Public Sub Initialize(connection_string)
    m_connection_string = connection_string
    'force a reconnect using the new connection string on the next call
    set m_connection = Nothing
  End Sub
  
  Public Property Get ConnectionString
    ConnectionString = m_connection_string
  End Property

  '---------------------------------------------------------------------------------------------------------------------
  Public Function Query(sql, params)
    dim cmd : set cmd = server.createobject("adodb.command")
    set cmd.ActiveConnection = Connection()
    cmd.CommandText = sql
    
    dim rs
    
    If IsArray(params) then
      set rs = cmd.Execute(, params)
    ElseIf Not IsEmpty(params) then  ' one parameter
      set rs = cmd.Execute(, Array(params))
    Else
      set rs = cmd.Execute()
    End If
    
    set Query = rs
  End Function
  
  '---------------------------------------------------------------------------------------------------------------------
  Public Function PagedQuery(sql, params, per_page, page_num, ByRef page_count, ByRef record_count)
    dim cmd : set cmd = server.createobject("adodb.command")
    set cmd.ActiveConnection = Connection
    cmd.CommandText = sql
    
    cmd.CommandType = 1                                   'adCmdText
    cmd.ActiveConnection.CursorLocation = 3               'adUseClient
    
    dim rs
    
    If IsArray(params) then
      set rs = cmd.Execute(, params)
    ElseIf Not IsEmpty(params) then  ' one parameter
      set rs = cmd.Execute(, Array(params))
    Else
      set rs = cmd.Execute()
    End If
    
    If Not rs.EOF and Not (IsEmpty(per_page) and IsEmpty(page_num) and IsEmpty(page_count) and IsEmpty(record_count)) then
      
      'make paged query
      rs.MoveFirst
      rs.PageSize     = per_page
      rs.AbsolutePage = page_num
      page_count      = rs.PageCount
      record_count    = rs.RecordCount
      
    Else
      per_page      = rs.RecordCount
      record_count  = rs.RecordCount
    End If
    
    set PagedQuery = rs
  End Function
  
  '---------------------------------------------------------------------------------------------------------------------
  Public Sub [Execute](sql, params)
    me.query sql, params
  End Sub
  
  '---------------------------------------------------------------------------------------------------------------------
  Public Sub BeginTransaction
    Connection.BeginTrans
  End Sub
  
  Public Sub RollbackTransaction
    Connection.RollbackTrans
  End Sub
  
  Public Sub CommitTransaction
    Connection.CommitTrans
  End Sub
  
  '---------------------------------------------------------------------------------------------------------------------
  ' Private Methods
  '---------------------------------------------------------------------------------------------------------------------
  Private Sub Class_terminate
    Destroy m_connection
  End Sub
  
  Private Sub Destroy(obj)
    On Error Resume Next
      obj.Close
    On Error Goto 0
    Set obj = Nothing
  End Sub
  
  Private Function Connection
    If IsEmpty(m_connection) then
      If IsEmpty(m_connection_string) then Err.Raise 1, "lib.Data:Connection", "empty connection string"
      set m_connection = Server.CreateObject("adodb.connection")
      m_connection.open m_connection_string
    ElseIf IsObject(m_connection) then
      If m_connection is Nothing then
        set m_connection = Server.CreateObject("adodb.connection")
        m_connection.open m_connection_string
      End If
    Else
    End If
    set Connection = m_connection
  End Function
end Class
%>
