'***************************************************************
' ConstantsManager
' Description: Manages the constants that live in the 
'          applicationConstants.config file.  These get stored
'          in memory and when the file changes, the file is 
'          removed from memory and re-read back into memory
'
' NOTE: Constants file must live in the webroot
'  on the web server for the web application to run.
'
' Author: Rachael Schoenbaum
' Create date: 12/4/2002
'***************************************************************
Imports System, System.Web.Caching, System.Xml, Microsoft.VisualBasic, System.Web

Public Class ConstantsManager
  'Dim Server As HttpServerUtility
  'Dim strPath As String = Server.MapPath("\")
  ' Cache object that will be used to store and retrieve items from
  ' the cache and constants used within this object
  Protected Friend Shared myCache As System.Web.Caching.Cache = System.Web.HttpRuntime.Cache()
  Private Shared applicationConstantsFile As String = "ApplicationConstantsFile"
  Public Shared applicationConstantsFileName As String = _
       Replace(System.AppDomain.CurrentDomain.BaseDirectory, "/", "\") & _
       "applicationConstants.config"
  'System.AppDomain.CurrentDomain.BaseDirectory
  'Server.MapPath("\")
  'ConstantsManager.applicationConstantsFileName = Server.MapPath("/") & "applicationConstants.config"
  Private Shared xmlFile As New XmlDocument()
  Private Shared constantIdentifier As String = "constant"
  Private Shared constantKey As String = "cacheDependencyKey"

  Public Shared Function getConstant(ByRef key As String) As Object
    Dim tmpObj As Object
    If Not (myCache(constantIdentifier & key) Is Nothing) Then
      tmpObj = CType(myCache(constantIdentifier & key), Object)
    Else
      tmpObj = pullConstantFromFile(key)

      'Create the cache dependencies and insert the object into the cache
      If Not IsNothing(tmpObj) Then
        If myCache(constantKey) Is Nothing Then
          myCache.Insert(constantKey, Now)
        End If
        myCache.Insert(constantIdentifier & key, tmpObj, _
                    New CacheDependency(applicationConstantsFileName))
      End If
    End If
    Return tmpObj
  End Function

  Private Shared Function pullConstantFromFile(ByRef key As String) As Object
    Dim obj As Object = 0
    If myCache(applicationConstantsFile) Is Nothing Then
      PopulateCache()
    End If

    'Attempt to find the element given the "key" for that tag
    Dim elementList As XmlNodeList = xmlFile.GetElementsByTagName(key)

    'If the key is found, the element list will have a count greater than
    'zero and we retrieve the value of the tag...
    If elementList.Count > 0 Then

      'Gets the node for the first element in the list of elements with
      'this tag name.  There should only be 1 so we return the first and
      'ignore the others.  If the node has a value, we retrieve the text        
      Dim node As XmlNode = elementList.Item(0)
      If Not (node Is Nothing) Then
        obj = node.InnerText()
      End If

      'If the value is a numeric, convert it to a number; otherwise
      'convert it to a string (we don't store values other than strings
      'and numbers).
      If IsNumeric(obj) Then
        obj = CType(obj, Integer)
      Else
        obj = CType(obj, String)
      End If
    End If
    Return obj
  End Function

  Private Shared Sub PopulateCache()
    'With a try around the entire event, the object attempts to load the XML
    'file and store it in the cache with a dependency on the XML file itself.
    'This means that any time the XML file changes, it is removed from the 
    'cache.  When the "getConstant" method is called again, the XML file won't
    'exist in memory and the PopulateCache will be re-called.
    Try
      xmlFile.Load(applicationConstantsFileName)
      myCache.Insert(applicationConstantsFile, xmlFile, _
                      New CacheDependency(applicationConstantsFileName))
    Catch e As Exception
      System.Diagnostics.Debug.WriteLine("Error: " & e.Message)
    End Try
  End Sub

End Class



