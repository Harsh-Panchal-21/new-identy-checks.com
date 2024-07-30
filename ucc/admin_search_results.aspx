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
        <td>Charge: <asp:TextBox ID="txtCharge" runat="server"></asp:TextBox> ($1.75 per page)</td>
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
      <tr><td colspan="8">&nbsp;<br /></td></tr>
      <tr>
        <td colspan="8">
          Search for Filing Number in our files:<br />
          <asp:DropDownList ID="lstFilingType" runat="server">
            <asp:ListItem Text="UCC1" Value="UCC1"></asp:ListItem>
            <asp:ListItem Text="UCC3" Value="UCC3"></asp:ListItem>
          </asp:DropDownList>&nbsp;&nbsp;
          Filing No: <asp:TextBox ID="txtFilingNo" runat="server"></asp:TextBox><br />
          <asp:Button ID="btnSearch" runat="server" Text="Search" />
          <asp:DataGrid ID="dgFiling" runat="server" AutoGenerateColumns="false" DataKeyField="ur_id" CellPadding="2" CellSpacing="2">
            <Columns>
              <asp:TemplateColumn HeaderText="View File"> 
	              <ItemTemplate> 
		              <asp:Hyperlink runat="server" Text="View File" NavigateUrl='<%# "View_File.aspx?type=UCC11_results&id=" & Server.UrlEncode(Container.DataItem("ur_id")) & "&com=" & Server.UrlEncode(Container.DataItem("us_company_id"))%>' ID="Hyperlink1" NAME="Hyperlink1" Target="_blank" /> 
	              </ItemTemplate> 
              </asp:TemplateColumn> 
              <asp:BoundColumn DataField="ur_filing_date" headertext="Filing Date" DataFormatString="{0:d}"></asp:BoundColumn>
              <asp:BoundColumn DataField="ur_name_address" headertext="Name-Address"></asp:BoundColumn>
              <asp:BoundColumn DataField="ur_secured_party" headertext="Secured Party"></asp:BoundColumn>
              <asp:ButtonColumn HeaderText="" ButtonType="PushButton" Text="Select" CommandName="Select"></asp:ButtonColumn>
            </Columns>
          </asp:DataGrid>
        </td>
      </tr>
    </table>
</asp:Content>

