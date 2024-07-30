<%@ Page Title="UCC - Admin Amendment" Language="VB" MasterPageFile="~/Main.master" AutoEventWireup="false" CodeFile="admin_amendment.aspx.vb" Inherits="admin_amendment" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headA" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
  <table cellpadding="2" cellspacing="0" border="1" style="font-size: 8pt; width: 575px;">
    <tr>
      <td align="center" colspan="8">Admin - Amendment View</td>
    </tr>
    <tr>
      <td colspan="8" align="left">
        Validation Number: <asp:TextBox ID="txtFile_No" runat="server"></asp:TextBox>&nbsp;
        <asp:Label ID="lblViewAttach" runat="server"></asp:Label><br />
        Upload Filing Confirmation: <asp:FileUpload ID="UploadedFile" runat="server" />&nbsp;<br />
        <asp:Button ID="btnUpload" runat="server" Text="Upload and Update" />
      </td>
    </tr>
  </table>
</asp:Content>

