<%@ Page Title="" Language="VB" MasterPageFile="~/AdminMaster.master" AutoEventWireup="false" CodeFile="Admin1.aspx.vb" Inherits="Admin1" %>
<%@ Register assembly="Telerik.Web.UI" namespace="Telerik.Web.UI" tagprefix="telerik" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
  <telerik:radgrid id="rgCompany" runat="server" AutoGenerateColumns="False" AllowSorting="True" AllowFilteringByColumn="True"
		Skin="Office2010Silver" EnableAJAXLoadingTemplate="True" EnableAJAX="True" GridLines="None"  EnableLinqExpressions="false">
		<FilterItemStyle Font-Size="8pt"></FilterItemStyle>
		<MasterTableView AllowPaging="True"  PageSize="20" AllowFilteringByColumn="True" GridLines="None" ShowFooter="True">
			<PagerStyle  Position="TopAndBottom"></PagerStyle>
			<RowIndicatorColumn Visible="False">
				<ItemStyle ></ItemStyle>
				<HeaderStyle Width="20px" ></HeaderStyle>
			</RowIndicatorColumn>
			<Columns>
				<telerik:GridBoundColumn HeaderText="ID" DataField="id" SortExpression="id" UniqueName="id" FilterControlWidth="15px"></telerik:GridBoundColumn>
        <telerik:GridHyperLinkColumn HeaderText="" Text="."  DataNavigateUrlFormatString="input_result.aspx?id={0}&company_id={1}"
					 UniqueName="InputResult" DataNavigateUrlFields="id,company_id" AllowFiltering="false"></telerik:GridHyperLinkColumn>
        <telerik:GridBoundColumn HeaderText="Company" DataField="company" SortExpression="company" UniqueName="company" FilterControlWidth="75px"></telerik:GridBoundColumn>
        <telerik:GridBoundColumn HeaderText="FName" DataField="FName" SortExpression="FName" UniqueName="FName"></telerik:GridBoundColumn>
        <telerik:GridBoundColumn HeaderText="LName" DataField="LName" SortExpression="LName" UniqueName="LName"></telerik:GridBoundColumn>
        <telerik:GridBoundColumn HeaderText="Date" DataField="date1" SortExpression="date1" UniqueName="date1"></telerik:GridBoundColumn>
        
        
        <telerik:GridHyperLinkColumn HeaderText="Update" Text="Update"  DataNavigateUrlFormatString="candidate_update.aspx?company_id={0}&id={1}"
					 UniqueName="Update" SortExpression="applicant_name"	DataNavigateUrlFields="company_id,id" AllowFiltering="false"></telerik:GridHyperLinkColumn>
        <telerik:GridHyperLinkColumn HeaderText="Price" Text="Price"  DataNavigateUrlFormatString="show_price1.aspx?company_id={0}&id={1}"
					 UniqueName="Price" SortExpression="applicant_name"	DataNavigateUrlFields="company_id,id" AllowFiltering="false"></telerik:GridHyperLinkColumn>
        <telerik:GridHyperLinkColumn HeaderText="Result" Text="Result"  DataNavigateUrlFormatString="show_result.aspx?company_id={0}&id={1}"
					 UniqueName="Result" SortExpression="applicant_name"	DataNavigateUrlFields="company_id,id" AllowFiltering="false"></telerik:GridHyperLinkColumn>
        <telerik:GridHyperLinkColumn HeaderText="Delete" Text="Delete" DataNavigateUrlFormatString="delete_candidate.aspx?company_id={0}&id={1}"
					 UniqueName="Delete" SortExpression="applicant_name"	DataNavigateUrlFields="company_id,id" AllowFiltering="false"></telerik:GridHyperLinkColumn>
			</Columns>
			<CommandItemSettings></CommandItemSettings>
			<ExpandCollapseColumn Visible="False" Resizable="False">
				<HeaderStyle Width="20px"></HeaderStyle>
			</ExpandCollapseColumn>
		</MasterTableView>
	</telerik:radgrid>
</asp:Content>

