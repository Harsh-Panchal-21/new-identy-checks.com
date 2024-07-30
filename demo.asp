<%
Option Explicit
%>

<!--#include file="lib.Data.asp"-->

<%
Sub main
  dim DB : set DB = new Database_Class
  DB.Initialize YOUR_CONNECTION_STRING_HERE
    
  dim rs
  
  put "<h1>Standard</h1>"
  
  put "<p><strong>No parameters: All tables and columns</strong></p>"
  set rs = DB.Query("select table_name, column_name, is_nullable from master.information_schema.columns", empty)
  put rs
  
  put "<p><strong>One parameter: All tables containing columns beginning with 'x'</strong></p>"
  set rs = DB.Query("select table_name, column_name, is_nullable from master.information_schema.columns where column_name like ?", "x%")
  put rs
  
  
  put "<p><strong>Array containing two parameters: All tables containing columns beginning with 'x' that are nullable</strong></p>"
  set rs = DB.Query("select table_name, column_name, is_nullable from master.information_schema.columns where column_name like ? and is_nullable = ?", Array("x%", "YES"))
  put rs
  
  put "<p><strong>Array containing three parameters: All tables not starting with 'spt_' that contain columns that are nullable ints</strong></p>"
  set rs = DB.Query("select table_name, column_name, is_nullable, data_type from master.information_schema.columns where table_name not like ? and is_nullable = ? and data_type = ?", Array("spt_%", "YES", "int"))
  put rs
  
  put "<h1>Paging</h1>"
  
  dim per_page : per_page = 5
  dim page_num, page_count, record_count
  
  put "<p><strong>All columns beginning with 'x', showing 5 records per page</strong></p>"
  put "Page 1"
  page_num = 1
  set rs = DB.PagedQuery("select table_name, column_name from master.information_schema.columns where column_name like ?", "x%", per_page, page_num, page_count, record_count)
  putpaged rs, per_page
  
  put "Page 2"
  page_num = 2
  set rs = DB.PagedQuery("select table_name, column_name from master.information_schema.columns where column_name like ?", "x%", per_page, page_num, page_count, record_count)
  putpaged rs, per_page
  
  put "Page 3"
  page_num = 3
  set rs = DB.PagedQuery("select table_name, column_name from master.information_schema.columns where column_name like ?", "x%", per_page, page_num, page_count, record_count)
  putpaged rs, per_page
  
End Sub


Sub put(v)
  If typename(v) = "Recordset" then
    putrs v
  Else
    response.write v
  End If
End Sub

Sub putrs(rs)
  put "<table border='1' cellpadding='5'>"
    put "<tr>"
      dim field
      For Each field in rs.Fields
        put "<th>" & field.Name & "</th>"
      Next
    put "</tr>"
    Do Until rs.EOF
      put "<tr>"
        For Each field in rs.Fields
          put "<td>" & rs(field.Name) & "</td>"
        Next
      put "</tr>"
      rs.MoveNext
    Loop
    
  put "</table>"
End Sub

Sub putpaged(rs, per_page)
  put "<table border='1' cellpadding='5'>"
    put "<tr>"
      dim field
      For Each field in rs.Fields
        put "<th>" & field.Name & "</th>"
      Next
    put "</tr>"
    
    dim x : x = 0
    Do While x < per_page and Not rs.EOF
      put "<tr>"
        For Each field in rs.Fields
          put "<td>" & rs(field.Name) & "</td>"
        Next
      put "</tr>"
      x = x + 1
      rs.MoveNext
    Loop
    
  put "</table>"
End Sub


Call main
%>
