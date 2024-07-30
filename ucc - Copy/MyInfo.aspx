<%@ Page Title="UCC - My Info" Language="VB" MasterPageFile="~/Main.master" AutoEventWireup="false" CodeFile="MyInfo.aspx.vb" Inherits="MyInfo" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headA" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <table cellpadding="2" cellspacing="0" border="1" style="font-size: 8pt; width: 575px;">
      <tr>
        <td align="center">My Info</td>
      </tr>
      <tr>
        <td>UserID: <asp:Label ID="lblUserID" runat="server"></asp:Label></td>
      </tr>
      <tr>
        <td>Name: <asp:TextBox ID="txtName" runat="server"></asp:TextBox></td>
      </tr>
      <tr>
        <td>Email: <asp:TextBox ID="txtEmail" runat="server"></asp:TextBox></td>
      </tr>
      <tr>
        <td>Password: <asp:TextBox ID="txtPass1" TextMode="Password" runat="server"></asp:TextBox></td>
      </tr>
      <tr>
        <td>Comfirm Password: <asp:TextBox ID="txtPass2" TextMode="Password" runat="server"></asp:TextBox></td>
      </tr>
      <tr>
        <td colspan="1" align="left">
          <asp:Label ID="lblMsg" runat="server" ForeColor="Red"></asp:Label>
          <asp:Button ID="btnSave" runat="server" Text="Update" />
        </td>
      </tr>
    </table>
</asp:Content>

