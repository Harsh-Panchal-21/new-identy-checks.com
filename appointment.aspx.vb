Imports System.Net
Imports System.Net.Mail

Partial Class AppointmentHandler
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If IsPostBack Then
            Try
                Dim appointmentDate As String = Request.Form("AppointmentDate")
                Dim firstName As String = Request.Form("FirstName")
                Dim lastName As String = Request.Form("LastName")
                Dim contactNumber As String = Request.Form("ContactNumber")
                Dim email As String = Request.Form("Email")
                Dim alternativeDateTime As String = Request.Form("AlternativeDateTime")
                Dim servicesArray As String() = Request.Form.GetValues("Services")
                If servicesArray Is Nothing Then
                    servicesArray = New String() {}
                End If
                Dim services As String = String.Join(", ", servicesArray)
                Dim additionalInfo As String = Request.Form("AdditionalInfo")

                Dim subject As String = "Appointment Confirmation"
                Dim body As String = GenerateEmailBody(appointmentDate, firstName, lastName, email, services)

                Dim emailSent As Boolean = SendEmail(email, subject, body)

                If emailSent Then
                    lblMessage.Text = "Confirmation email sent successfully."
                Else
                    lblMessage.Text = "Failed to send confirmation email."
                    lblMessage.ForeColor = System.Drawing.Color.Red
                End If
            Catch ex As Exception
                lblMessage.Text = "An error occurred: " & ex.Message
                lblMessage.ForeColor = System.Drawing.Color.Red
            End Try
        End If
    End Sub

    Private Function GenerateEmailBody(ByVal appointmentDate As String, ByVal firstName As String, ByVal lastName As String, ByVal email As String, ByVal services As String) As String
        Return String.Format("<html><head><title>Appointment Confirmation</title></head><body><div style='max-width: 600px; margin: auto; padding: 20px; border: 1px solid #ddd; border-radius: 5px; background-color: #f5f5f5;'><div style='text-align: center; padding-bottom: 20px;'><img src='https://yourdomain.com/path/to/header/image.png' alt='Appointment Confirmation' style='width: 100%; height: auto;'></div><div style='text-align: left;'><h2>Your appointment on {0} is confirmed.</h2><p>Thanks for scheduling an appointment with Identi-Check! We're looking forward to seeing you soon.</p><p>Do you need to make changes to this appointment?</p><p><a href='https://yourdomain.com/reschedule?email={1}' style='color: #007bff;'>Reschedule appointment</a><br><a href='https://yourdomain.com/cancel?email={1}' style='color: #007bff;'>Cancel appointment</a></p><p>Please do not reply to this email. It was sent from a notification-only email address that cannot accept incoming email.</p></div><div style='text-align: center; color: #777; font-size: 12px; margin-top: 20px;'><p>&copy; 2024 Identi-Check, Inc. All rights reserved.</p></div></div></body></html>", appointmentDate, email)
    End Function

    Private Function SendEmail(ByVal toEmail As String, ByVal subject As String, ByVal body As String) As Boolean
        Try
            Dim mail As New MailMessage()
            mail.From = New MailAddress("hpanchal@kingtech.net")
            mail.To.Add(toEmail)
            mail.Subject = subject
            mail.Body = body
            mail.IsBodyHtml = True

            Dim smtpClient As New SmtpClient("identicheck-com01e.mail.protection.outlook.com")
            smtpClient.Port = 25 ' or your SMTP port
            'smtpClient.Credentials = New NetworkCredential("yourusername", "yourpassword")
            smtpClient.EnableSsl = True
            smtpClient.Send(mail)

            Return True
        Catch ex As Exception
            ' Log the exception (ex) as needed
            lblMessage.Text = "Error: " & ex.Message
            lblMessage.ForeColor = System.Drawing.Color.Red
            Return False
        End Try
    End Function
End Class
