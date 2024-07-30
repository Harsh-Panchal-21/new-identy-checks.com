<%@ Page Title="" Language="VB" MasterPageFile="~/Main.master" AutoEventWireup="false" CodeFile="test.aspx.vb" Inherits="test" ValidateRequest="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headA" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
  <table>
    <tr>
      <td valign="top">
        UF ID: <asp:TextBox ID="txtUF_ID" runat="server" style="width: 50px;">9</asp:TextBox><br />
        <asp:Button ID="btnShowXML" runat="server" Text="Show XML" /><br />
        <asp:Button ID="btnDoSubmit" runat="server" Text="Submit to SOS" /><br /><br />
        U3 ID: <asp:TextBox ID="txtU3_ID" runat="server" style="width: 50px;">3</asp:TextBox><br />
        <asp:Button ID="btnSubmitAmend" runat="server" Text="Submit Amendment" /><br />
        <asp:Button ID="btnShowXMLAmend" runat="server" Text="Show XML Amendment" /><br /><br />
        Doc Ref Num: <asp:TextBox ID="txtDocRefNum" runat="server"></asp:TextBox><br />
        <asp:Button ID="btnCheckStatus" runat="server" Text="Check Status" /><br />
        <asp:Button ID="btnCheckStatusProd" runat="server" Text="Check Status Prod" /><br />
        <asp:Button ID="btnGetPDF" runat="server" Text="Get Document" /><br /><br />
        <asp:Button ID="btnGetFileProd" runat="server" Text="Get Doc Prod" /><br />
        File Num: <asp:TextBox ID="txtFileNumber" runat="server"></asp:TextBox><br />
        <asp:Button ID="btnGetFile" runat="server" Text="Get File" /><br />
        <asp:Button ID="btnTestSOSReturn" runat="server" Text="Test SOS Return" /><br /><br />
        Trans Type: <asp:TextBox ID="txtProdTransType" runat="server" style="width: 75px;"></asp:TextBox> (Intial or Amendment)<br />
        PacketNum: <asp:TextBox ID="txtProdTicketNum" runat="server"></asp:TextBox><br />
        File Status: <asp:TextBox ID="txtProdStatus" runat="server" style="width: 75px;"></asp:TextBox> (Accepted or Rejected)<br />
        File Number: <asp:TextBox ID="txtProdFileNo" runat="server" style="width: 75px;"></asp:TextBox><br />
        File Date: <asp:TextBox ID="txtProdFileDate" runat="server" style="width: 75px;"></asp:TextBox> (CCYYMMDD)<br />
        File Time: <asp:TextBox ID="txtProdFileTime" runat="server" style="width: 75px;"></asp:TextBox> (HHMM)<br />
        <asp:Button ID="btnTestSOSReturnProd" runat="server" Text="Test SOS Return Prod" />
      </td>
      <td>
        <asp:Button ID="btnTestTifToPDF" runat="server" Text="Test TIF to PDF" /><br />
        <asp:Button ID="btnTestOCR" runat="server" Text="Test OCR" />
        <asp:TextBox ID="txtResult" runat="server" TextMode="MultiLine" Rows="25" Columns="60"></asp:TextBox>
      </td>
    </tr>
  </table>
  
</asp:Content>

