<%@ Page Title="UCC - Admin Main" Language="VB" MasterPageFile="~/Main.master" AutoEventWireup="false" CodeFile="ucc_admin.aspx.vb" Inherits="ucc_admin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head19" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
  <telerik:RadAjaxLoadingPanel runat="server" ID="RadAjaxLoadingPanel1" />
  <telerik:RadAjaxPanel ID="rapOne" runat="server" LoadingPanelID="RadAjaxLoadingPanel1">
    <table cellpadding="2" cellspacing="0" border="1" style="font-size: 8pt; width: 775px;">
      <tr>
        <td align="center">Filings / Searches<asp:Label ID="lblMsg" runat="server"></asp:Label></td>
      </tr>
      <tr>
        <td>
          <telerik:radgrid id="rgFS" runat="server" GridLines="None" AutoGenerateColumns="False" AllowSorting="True"
					    PageSize="20"  AllowFilteringByColumn="true" EnableLinqExpressions="false">
					    <PagerStyle  Position="TopAndBottom" Mode="NumericPages"></PagerStyle>
					    <MasterTableView DataKeyNames="Doc,id" AllowPaging="True" AllowFilteringByColumn="true" GridLines="None">
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
                  <telerik:GridBoundColumn HeaderText="Submitted" 
								    DataField="date_submitted" UniqueName="date_submitted" SortExpression="date_submitted"></telerik:GridBoundColumn>
							    <telerik:GridBoundColumn HeaderText="Type" 
								    DataField="Doc" UniqueName="Doc" SortExpression="Doc"></telerik:GridBoundColumn>
							    <telerik:GridBoundColumn HeaderText="Org Name/Ind Name" DataField="Name"  
								    UniqueName="Name" SortExpression="Name"></telerik:GridBoundColumn>
                  <telerik:GridTemplateColumn HeaderText="View PDF">
                    <ItemTemplate>
                      <%# GetPDFLink(Eval("Doc"), Eval("id"), Eval("company_id"), Eval("ad_id"), Eval("ap_id"))%>
                    </ItemTemplate>
                  </telerik:GridTemplateColumn>
                  <telerik:GridTemplateColumn HeaderText="Results/Confirmation">
                    <ItemTemplate>
                      <%# BuildResults(Eval("Doc"), Eval("id"), Eval("ad_id"), Eval("ap_id"))%>
                    </ItemTemplate>
                  </telerik:GridTemplateColumn>
                  <telerik:GridTemplateColumn HeaderText="Start" Visible="false">
                    <ItemTemplate>
                      <%# GetStartLink(Eval("Doc"), Eval("id"), Eval("ad_id"), Eval("ap_id"))%>
                    </ItemTemplate>
                  </telerik:GridTemplateColumn>
                  <telerik:GridBoundColumn HeaderText="Status" DataField="status"  
								    UniqueName="status" SortExpression="status"></telerik:GridBoundColumn>
                    <telerik:GridButtonColumn CommandName="Delete" Text="Delete" UniqueName="Delete" ConfirmText="Are you sure you want to delete?"></telerik:GridButtonColumn>
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
    <asp:Panel ID="Panel1" runat="server">
        <asp:Timer ID="Timer1" runat="server" Interval="300000" OnTick="Timer1_Tick">
        </asp:Timer>
    </asp:Panel>
  </telerik:RadAjaxPanel>
</asp:Content>

