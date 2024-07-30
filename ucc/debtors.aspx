<%@ Page Title="UCC - Debtor Listing" Language="VB" MasterPageFile="~/Main.master" AutoEventWireup="false" CodeFile="debtors.aspx.vb" Inherits="debtors" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headA" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
  <telerik:RadAjaxLoadingPanel runat="server" ID="RadAjaxLoadingPanel1" />
  <telerik:RadAjaxPanel ID="rapOne" runat="server" LoadingPanelID="RadAjaxLoadingPanel1">
    <table cellpadding="2" cellspacing="0" border="1" style="font-size: 8pt; width: 775px;">
      <tr>
        <td align="center">Debtors&nbsp;<asp:Label ID="lblMsg" runat="server"></asp:Label></td>
      </tr>
      <tr>
        <td>
          <telerik:radgrid id="rgD" runat="server" GridLines="None" AutoGenerateColumns="False" AllowSorting="True"
					    PageSize="20"  AllowFilteringByColumn="true" EnableLinqExpressions="false">
					    <PagerStyle  Position="TopAndBottom" Mode="NumericPages"></PagerStyle>
					    <MasterTableView DataKeyNames="ud_id" AllowPaging="True" AllowFilteringByColumn="true" GridLines="None">
						    <PagerStyle  Position="TopAndBottom" Mode="NumericPages"></PagerStyle>
						    <RowIndicatorColumn Visible="False">
							    <ItemStyle ></ItemStyle>
							    <HeaderStyle Width="20px" ></HeaderStyle>
						    </RowIndicatorColumn>
						    <HeaderStyle ></HeaderStyle>
						    <EditFormSettings>
							    <EditColumn></EditColumn>
						    </EditFormSettings>
                <DetailTables>
                  <telerik:GridTableView DataKeyNames="Doc,ID" Name="FilingSearches" Width="100%" AllowFilteringByColumn="false">
                    <Columns>
                      <telerik:GridBoundColumn HeaderText="Submitted" DataFormatString="{0:d}"
								        DataField="date_submitted" UniqueName="date_submitted" SortExpression="date_submitted"></telerik:GridBoundColumn>
							        <telerik:GridBoundColumn HeaderText="Type" 
								        DataField="Doc" UniqueName="Doc" SortExpression="Doc"></telerik:GridBoundColumn>
							        <telerik:GridBoundColumn HeaderText="Org Name/Ind Name" DataField="Name"  
								        UniqueName="Name" SortExpression="Name"></telerik:GridBoundColumn>
                      <telerik:GridTemplateColumn HeaderText="View PDF">
                        <ItemTemplate>
                          <%# GetPDFLink(Eval("Doc"), Eval("id"), Eval("ad_id"), Eval("ap_id"))%>
                        </ItemTemplate>
                      </telerik:GridTemplateColumn>
                      <telerik:GridTemplateColumn HeaderText="Results/Confirmation">
                        <ItemTemplate>
                          <%# BuildResults(Eval("Doc"), Eval("id"), Eval("ad_id"), Eval("ap_id"))%>
                        </ItemTemplate>
                      </telerik:GridTemplateColumn>
                      <telerik:GridTemplateColumn HeaderText="Start">
                        <ItemTemplate>
                          <%# GetStartLink(Eval("Doc"), Eval("id"), Eval("ad_id"), Eval("ap_id"))%>
                        </ItemTemplate>
                      </telerik:GridTemplateColumn>
                    </Columns>
                  </telerik:GridTableView>
                </DetailTables>
						    <Columns>
                  <telerik:GridHyperLinkColumn HeaderText="Org Name/Ind Name" DataNavigateUrlFields="ud_id" 
                    DataNavigateUrlFormatString="debtor_view.aspx?id={0}" DataTextField="Name" 
                    UniqueName="Name" SortExpression="Name" Visible="false"></telerik:GridHyperLinkColumn>
                  <telerik:GridBoundColumn HeaderText="Org Name/Ind Name" DataField="Name" 
                    UniqueName="Name_disp" SortExpression="Name"></telerik:GridBoundColumn>
                  <telerik:GridBoundColumn HeaderText="Address" DataField="ud_mailing_address" 
                    UniqueName="ud_mailing_address" SortExpression="ud_mailing_address"></telerik:GridBoundColumn>
							    <telerik:GridBoundColumn HeaderText="City" 
								    DataField="ud_city" UniqueName="ud_city" SortExpression="ud_city"></telerik:GridBoundColumn>
							    <telerik:GridBoundColumn HeaderText="State" DataField="ud_state"  
								    UniqueName="ud_state" SortExpression="ud_state"></telerik:GridBoundColumn>
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
  </telerik:RadAjaxPanel>
</asp:Content>

