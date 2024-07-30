Imports Microsoft.VisualBasic

Public Class rc4encrypt
  Protected sbox As Integer() = New Integer(255) {}
  Protected key As Integer() = New Integer(255) {}

  Protected m_plaintext As String, m_password As String

  Public Property PlainText() As String
    Get
      Return m_plaintext
    End Get
    Set(value As String)
      m_plaintext = value
    End Set
  End Property

  Public Property Password() As String
    Get
      Return m_password
    End Get
    Set(value As String)
      m_password = value
    End Set
  End Property

  Private Sub RC4Initialize(strPwd As String)
    ' Get the length of the password
    ' Instead of Len(), we need to use the Length property
    ' of the string
    Dim intLength As Integer = strPwd.Length

    ' Set up our for loop.  In C#, we need to change our syntax.

    ' The first argument is the initializer.  Here we declare a
    ' as an integer and set it equal to zero.

    ' The second argument is expression that is used to test
    ' for the loop termination.  Since our arrays have 256
    ' elements and are always zero based, we need to loop as long
    ' as a is less than or equal to 255.

    ' The third argument is an iterator used to increment the
    ' value of a by one each time through the loop.  Note that
    ' we can use the ++ increment notation instead of a = a + 1
    For a As Integer = 0 To 255
      ' Since we don't have Mid()  in C#, we use the C#
      ' equivalent of Mid(), String.Substring, to get a
      ' single character from strPwd.  We declare a character
      ' variable, ctmp, to hold this value.

      ' A couple things to note.  First, the Mod keyword we
      ' used in VB need to be replaced with the %
      ' operator C# uses.  Next, since the return type of
      ' String.Substring is a string, we need to convert it to
      ' a char using String.ToCharArray() and specifying that
      ' we want the first value in the array, [0].

      Dim ctmp As Char = (strPwd.Substring((a Mod intLength), 1).ToCharArray()(0))

      ' We now have our character and need to get the ASCII
      ' code for it.  C# doesn't have the  VB Asc(), but that
      ' doesn't mean we can't use it.  In the beginning of our
      ' code, we imported the Microsoft.VisualBasic namespace.
      ' This allows us to use many of the native VB functions
      ' in C#

      ' Note that we need to use [] instead of () for our
      ' array members.
      key(a) = Microsoft.VisualBasic.Strings.Asc(ctmp)
      sbox(a) = a
    Next

    ' Declare an integer x and initialize it to zero.
    Dim x As Integer = 0

    ' Again, create a for loop like the one above.  Note that we
    ' need to use a different variable since we've already
    ' declared a above.
    For b As Integer = 0 To 255
      x = (x + sbox(b) + key(b)) Mod 256
      Dim tempSwap As Integer = sbox(b)
      sbox(b) = sbox(x)
      sbox(x) = tempSwap
    Next
  End Sub

  Public Function EnDeCrypt() As String
    Dim i As Integer = 0
    Dim j As Integer = 0
    Dim cipher As String = ""

    ' Call our method to initialize the arrays used here.
    RC4Initialize(m_password)

    ' Set up a for loop.  Again, we use the Length property
    ' of our String instead of the Len() function

    For a As Integer = 1 To m_plaintext.Length
      ' Initialize an integer variable we will use in this loop
      Dim itmp As Integer = 0


      ' Like the RC4Initialize method, we need to use the %
      ' in place of Mod
      i = (i + 1) Mod 256
      j = (j + sbox(i)) Mod 256
      itmp = sbox(i)
      sbox(i) = sbox(j)
      sbox(j) = itmp

      Dim k As Integer = sbox((sbox(i) + sbox(j)) Mod 256)

      ' Again, since the return type of String.Substring is a
      ' string, we need to convert it to a char using
      ' String.ToCharArray() and specifying that we want the
      ' first value, [0].

      Dim ctmp As Char = m_plaintext.Substring(a - 1, 1).ToCharArray()(0)

      ' Use Asc() from the Microsoft.VisualBasic namespace
      itmp = Microsoft.VisualBasic.Strings.Asc(ctmp)

      ' Here we need to use ^ operator that C# uses for Xor
      Dim cipherby As Integer = itmp Xor k

      ' Use Chr() from the Microsoft.VisualBasic namespace                
      cipher += Microsoft.VisualBasic.Strings.Chr(cipherby)
    Next

    ' Return the value of cipher as the return value of our
    ' method
    Return cipher
  End Function

End Class
