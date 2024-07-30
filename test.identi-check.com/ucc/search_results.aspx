<%@ Page Title="UCC- Search Results" Language="VB" MasterPageFile="~/Main.master" AutoEventWireup="false" CodeFile="search_results.aspx.vb" Inherits="search_results" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headA" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
  <table cellpadding="2" cellspacing="0" border="1" style="font-size: 8pt; width: 575px;">
    <tr>
      <td align="center">Search Results</td>
    </tr>
    <tr>
      <td>
        <telerik:radgrid id="rgSR" runat="server" GridLines="None" AutoGenerateColumns="False" AllowSorting="True"
					PageSize="20"  AllowFilteringByColumn="False">
					<PagerStyle  Position="TopAndBottom" Mode="NumericPages"></PagerStyle>
					<MasterTableView DataKeyNames="ur_id" AllowPaging="True" AllowFilteringByColumn="False" GridLines="None">
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
              <telerik:GridBoundColumn HeaderText="Filing Number"
								DataField="ur_filing_number" UniqueName="ur_filing_number" SortExpression="ur_filing_number"></telerik:GridBoundColumn>
              <telerik:GridBoundColumn HeaderText="Filing Date"
								DataField="ur_filing_date" UniqueName="ur_filing_date" SortExpression="ur_filing_date" DataFormatString="{0:d}"></telerik:GridBoundColumn>
							<telerik:GridBoundColumn HeaderText="Name/Address" 
								DataField="ur_name_address" UniqueName="ur_name_address" SortExpression="ur_name_address"></telerik:GridBoundColumn>
							<telerik:GridBoundColumn HeaderText="Secured Party" DataField="ur_secured_party"  
								UniqueName="ur_secured_party" SortExpression="ur_secured_party"></telerik:GridBoundColumn>
              <telerik:GridTemplateColumn HeaderText="View PDF">
                <ItemTemplate>
                  <%# GetPDFLink(Eval("ur_id"),Eval("FileReady"))%>
                </ItemTemplate>
              </telerik:GridTemplateColumn>
              <telerik:GridBoundColumn HeaderText="Date Entered" DataField="ur_date_entered"
								UniqueName="ur_date_entered" SortExpression="ur_date_entered"></telerik:GridBoundColumn>
						</Columns>
						<EditItemStyle Font-Bold="True" ></EditItemStyle>
						<CommandItemSettings ></CommandItemSettings>
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
</asp:Content>

