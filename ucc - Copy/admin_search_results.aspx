<%@ Page Title="UCC - Admin Search Reults" Language="VB" MasterPageFile="~/Main.master" AutoEventWireup="false" CodeFile="admin_search_results.aspx.vb" Inherits="admin_search_results" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headA" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <table cellpadding="2" cellspacing="0" border="1" style="font-size: 8pt; width: 575px;">
      <tr>
        <td align="center">Admin Search Results Entry - <a href='admin_results_list.aspx?id=<%=Request.QueryString("us")%>'>Back to Results List</a></td>
      </tr>
      <tr>
        <td>Filing Number: <asp:TextBox ID="txtFiling_Number" runat="server"></asp:TextBox></td>
      </tr>
      <tr>
        <td>Filing Date: <asp:TextBox ID="txtFiling_Date" runat="server"></asp:TextBox></td>
      </tr>
      <tr>
        <td>Name / Address:<br /><asp:TextBox ID="txtName_Address" runat="server" TextMode="MultiLine" Rows="5" Columns="50"></asp:TextBox></td>
      </tr>
      <tr>
        <td>secured Party:<br /><asp:TextBox ID="txtSecured_Party" runat="server" TextMode="MultiLine" Rows="5" Columns="50"></asp:TextBox></td>
      </tr>
      <tr>
        <td>Charge: <asp:TextBox ID="txtCharge" runat="server"></asp:TextBox> ($1 per page)</td>
      </tr>
      <tr>
        <td>Date Entered: <asp:Label ID="lblDateEntered" runat="server"></asp:Label></td>
      </tr>
      <tr>
        <td colspan="8" align="left">
          &nbsp;
          <asp:Label ID="lblViewAttach" runat="server"></asp:Label><br />
          Upload Filing Confirmation: <asp:FileUpload ID="UploadedFile" runat="server" />&nbsp;<br />
          <asp:Button ID="btnUpload" runat="server" Text="Upload and Update" />
          <asp:Button ID="btnAdd" runat="server" Text="Add and Upload" Visible="false" />
        </td>
      </tr>
    </table>
</asp:Content>

