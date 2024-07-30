<%@ Page Title="UCC - Admin Results List" Language="VB" MasterPageFile="~/Main.master" AutoEventWireup="false" CodeFile="admin_results_list.aspx.vb" Inherits="admin_results_list" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headA" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
  <script type="text/javascript">
    function onRequestStart(sender, args) {
      if (args.get_eventTarget().indexOf("ExportToExcelButton") >= 0 ||
        args.get_eventTarget().indexOf("ExportToWordButton") >= 0 ||
        args.get_eventTarget().indexOf("ExportToPdfButton") >= 0 ||
        args.get_eventTarget().indexOf("ExportToCsvButton") >= 0) {

        args.set_enableAjax(false);
      }
    }
  </script>
  <telerik:RadAjaxLoadingPanel runat="server" ID="RadAjaxLoadingPanel1" />
  <telerik:RadAjaxPanel ID="rapOne" runat="server" LoadingPanelID="RadAjaxLoadingPanel1" ClientEvents-OnRequestStart="onRequestStart">
  <table cellpadding="2" cellspacing="0" border="1" style="font-size: 8pt; width: 575px;">
    <tr>
      <td align="center">Search Results - <asp:Label ID="lblAddNew" runat="server"></asp:Label> - <asp:Button ID="btnFinished" runat="server" Text="Finished" /><asp:Label ID="lblMsg" runat="server"></asp:Label></td>
    </tr>
    <tr>
      <td align="center">
        <asp:Label ID="lblHdr" runat="server" Visible="false"></asp:Label>
      </td>
    </tr>
    <tr>
      <td>
        <telerik:radgrid id="rgSR" runat="server" GridLines="None" AutoGenerateColumns="False" AllowSorting="True"
					PageSize="20"  AllowFilteringByColumn="False">
          <ExportSettings IgnorePaging="true" ExportOnlyData="true" HideStructureColumns="true" OpenInNewWindow="true"></ExportSettings>
					<PagerStyle  Position="TopAndBottom" Mode="NumericPages"></PagerStyle>
					<MasterTableView DataKeyNames="ur_id" AllowPaging="True" AllowFilteringByColumn="False" GridLines="None" CommandItemDisplay="Top">
						<PagerStyle  Position="TopAndBottom" Mode="NumericPages"></PagerStyle>
						<RowIndicatorColumn Visible="False">
							<ItemStyle ></ItemStyle>
							<HeaderStyle Width="20px" ></HeaderStyle>
						</RowIndicatorColumn>
						<HeaderStyle ></HeaderStyle>
						<EditFormSettings>
							<EditColumn></EditColumn>
						</EditFormSettings>
						<Columns>
              <telerik:GridHyperLinkColumn HeaderText="Filing Number" DataTextField="ur_filing_number" DataNavigateUrlFields="ur_id,ur_us_id"
                UniqueName="ur_filing_number" SortExpression="ur_filing_number" DataNavigateUrlFormatString="admin_search_results.aspx?id={0}&us={1}">
              </telerik:GridHyperLinkColumn>
              <telerik:GridBoundColumn HeaderText="Filing Date" DataFormatString="{0:d}"
								DataField="ur_filing_date" UniqueName="ur_filing_date" SortExpression="ur_filing_date"></telerik:GridBoundColumn>
              <telerik:GridBoundColumn HeaderText="Name/Address" 
								DataField="ur_name_address" UniqueName="ur_name_address" SortExpression="ur_name_address"></telerik:GridBoundColumn>
							<telerik:GridBoundColumn HeaderText="Secured Party" DataField="ur_secured_party"  
								UniqueName="ur_secured_party" SortExpression="ur_secured_party"></telerik:GridBoundColumn>
              <telerik:GridTemplateColumn HeaderText="View PDF">
                <ItemTemplate>
                  <%# GetPDFLink(Eval("ur_id"),Eval("us_company_id"),Eval("FileReady"))%>
                </ItemTemplate>
              </telerik:GridTemplateColumn>
              <telerik:GridButtonColumn CommandName="Delete" ConfirmText="Are you sure you want to delete this result?" UniqueName="DeleteCol" Text="Delete"></telerik:GridButtonColumn>
						</Columns>
						<EditItemStyle Font-Bold="True" ></EditItemStyle>
						<CommandItemSettings ShowAddNewRecordButton="false" ShowExportToPdfButton="true"
                  ShowExportToExcelButton="true" ShowExportToWordButton="true" ShowRefreshButton="false" ></CommandItemSettings>
						<GroupHeaderItemStyle ></GroupHeaderItemStyle>
						<ExpandCollapseColumn Visible="False" Resizable="False">
							<HeaderStyle Width="20px"></HeaderStyle>
						</ExpandCollapseColumn>
					</MasterTableView>
					<ClientSettings EnableRowHoverStyle="true">
            <Selecting AllowRowSelect="False" />
          </ClientSettings>
				</telerik:radgrid>
      </td>
    </tr>
  </table>
  </telerik:RadAjaxPanel>
</asp:Content>

