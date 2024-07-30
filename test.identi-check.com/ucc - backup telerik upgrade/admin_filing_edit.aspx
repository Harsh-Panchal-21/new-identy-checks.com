<%@ Page Title="UCC - Admin Filing Edit" Language="VB" MasterPageFile="~/Main.master" AutoEventWireup="false" CodeFile="admin_filing_edit.aspx.vb" Inherits="admin_filing_edit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headA" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
  <table cellpadding="2" cellspacing="0" border="1" style="font-size: 8pt; width: 575px;">
      <tr>
        <td align="center">Admin Filing Edit - <asp:Label ID="lblType" runat="server"></asp:Label></td>
      </tr>
      <tr>
        <td>Primary Debtor: <asp:Label ID="lblDebtor" runat="server" Font-Bold="true"></asp:Label> - <asp:Label ID="lblViewPDF" runat="server"></asp:Label></td>
      </tr>
      <tr>
        <td>Filing Number: <asp:TextBox ID="txtFiling_Number" runat="server"></asp:TextBox></td>
      </tr>
      <tr>
        <td>Filing Date: <asp:TextBox ID="txtFiling_Date" runat="server"></asp:TextBox></td>
      </tr>
      <tr>
        <td>Status: <asp:DropDownList ID="lstStatus" runat="server"></asp:DropDownList></td>
      </tr>
      <tr>
        <td>Charge: <asp:TextBox ID="txtCharge" runat="server"></asp:TextBox></td>
      </tr>
      <tr>
        <td>
          XML Doc Receipt ID: <asp:label ID="lblDocReceiptID" runat="server"></asp:label>
          <asp:Button ID="btnSubmitXML" runat="server" Text="Submit via XML" />
          <asp:Button ID="btnCheckStatus" runat="server" Text="Check Status (download messed up filing pdf again)" Visible="false" />
          <asp:Label ID="lblCom" runat="server" Visible="false"></asp:Label>
          <asp:Label ID="lblError" runat="server"></asp:Label>
        </td>
      </tr>
      <tr>
        <td colspan="8" align="left">
          &nbsp;
          <asp:Label ID="lblViewAttach" runat="server"></asp:Label><br />
          Upload Filing Confirmation: <asp:FileUpload ID="UploadedFile" runat="server" />&nbsp;<br />
          <asp:Button ID="btnUpload" runat="server" Text="Upload and Update" />
          <asp:Button ID="btnAdd" runat="server" Text="Add and Upload" Visible="false" />
          <asp:Button ID="btnFinished" runat="server" Text="Finished" />
        </td>
      </tr>
    </table>
</asp:Content>

