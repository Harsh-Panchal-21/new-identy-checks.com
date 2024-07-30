<%@ Page Title="" Language="VB" MasterPageFile="~/AdminMaster.master" AutoEventWireup="false" CodeFile="Admin.aspx.vb" Inherits="Admin" %>
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
				<telerik:GridBoundColumn HeaderText="Comp Num" DataField="company_id" SortExpression="company_id" UniqueName="company_id" FilterControlWidth="15px"></telerik:GridBoundColumn>
        <telerik:GridBoundColumn HeaderText="Date" DataField="date1" SortExpression="date1" UniqueName="date1"></telerik:GridBoundColumn>
        <telerik:GridBoundColumn HeaderText="Name" DataField="name" SortExpression="name" UniqueName="name" FilterControlWidth="75px"></telerik:GridBoundColumn>
        <telerik:GridBoundColumn HeaderText="Division" DataField="division" SortExpression="division" UniqueName="division"></telerik:GridBoundColumn>
        <telerik:GridBoundColumn HeaderText="City, ST Zip" DataField="citystatezip" SortExpression="citystatezip" UniqueName="citystatezip"></telerik:GridBoundColumn>
        <telerik:GridBoundColumn HeaderText="Contact" DataField="contact_name" SortExpression="contact_name" UniqueName="contact_name"></telerik:GridBoundColumn>
        <telerik:GridBoundColumn HeaderText="Phone" DataField="phone" SortExpression="phone" UniqueName="phone"></telerik:GridBoundColumn>
        <telerik:GridHyperLinkColumn HeaderText="Login" Text="Login"  DataNavigateUrlFormatString="admin_company_logins.aspx?company_id={0}"
					 UniqueName="Login" SortExpression="applicant_name"	DataNavigateUrlFields="company_id" AllowFiltering="false"></telerik:GridHyperLinkColumn>
        <telerik:GridHyperLinkColumn HeaderText="Detail" Text="Detail"  DataNavigateUrlFormatString="admin_detail.aspx?company_id={0}"
					 UniqueName="Detail" SortExpression="applicant_name"	DataNavigateUrlFields="company_id" AllowFiltering="false"></telerik:GridHyperLinkColumn>
        <telerik:GridHyperLinkColumn HeaderText="Candidate" Text="Candidate"  DataNavigateUrlFormatString="main.aspx?company_id={0}"
					 UniqueName="Candidate" SortExpression="applicant_name"	DataNavigateUrlFields="company_id" AllowFiltering="false"></telerik:GridHyperLinkColumn>
        <telerik:GridHyperLinkColumn HeaderText="Pricing" Text="Pricing"  DataNavigateUrlFormatString="pricing.aspx?company_id={0}"
					 UniqueName="Pricing" SortExpression="applicant_name"	DataNavigateUrlFields="company_id" AllowFiltering="false"></telerik:GridHyperLinkColumn>
        <telerik:GridHyperLinkColumn HeaderText="Delete" Text="Delete" DataNavigateUrlFormatString="delete.aspx?company_id={0}"
					 UniqueName="Delete" SortExpression="applicant_name"	DataNavigateUrlFields="company_id" AllowFiltering="false"></telerik:GridHyperLinkColumn>
			</Columns>
			<CommandItemSettings></CommandItemSettings>
			<ExpandCollapseColumn Visible="False" Resizable="False">
				<HeaderStyle Width="20px"></HeaderStyle>
			</ExpandCollapseColumn>
		</MasterTableView>
	</telerik:radgrid>
</asp:Content>

