<%@ Page Title="UCC - Admin Reports" Language="VB" MasterPageFile="~/Main.master" AutoEventWireup="false" CodeFile="admin_reports.aspx.vb" Inherits="admin_reports" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headA" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
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
        <table cellpadding="2" cellspacing="0" border="1" style="font-size: 8pt; width: 775px;">
            <tr>
                <td align="center">Charge Reporting -  Date From:
                    <telerik:RadDatePicker ID="rdpFromDate" runat="server"></telerik:RadDatePicker>
                    &nbsp;&nbsp;
          Date To:
                    <telerik:RadDatePicker ID="rdpToDate" runat="server"></telerik:RadDatePicker>
                    &nbsp;&nbsp;
          <asp:Button ID="btnSearch" runat="server" Text="Search" />
                    
                </td>
            </tr>
            <tr>
                <td align="center">Loan Type: <asp:DropDownList ID="ddlLoanType" runat="server">
                        <asp:ListItem Value="0">Select One</asp:ListItem>
                        <asp:ListItem Value="FSFL">Farm Storage Facility Loan</asp:ListItem>
                        <asp:ListItem Value="MAL">Market Assistance Loan</asp:ListItem>
                        <asp:ListItem Value="FLP">Farm Loan Program </asp:ListItem>
                    </asp:DropDownList></td>
            </tr>
            <tr>
                <td>
                    <telerik:RadGrid ID="rgCharge" runat="server" GridLines="None" AutoGenerateColumns="False" AllowSorting="True"
                        PageSize="20" AllowFilteringByColumn="true" EnableLinqExpressions="false" ShowFooter="True" DataSourceID="">
                        <ExportSettings IgnorePaging="true" ExportOnlyData="true" HideStructureColumns="true" OpenInNewWindow="true"></ExportSettings>
                        <PagerStyle Position="TopAndBottom" Mode="NumericPages"></PagerStyle>
                        <MasterTableView DataKeyNames="typ,company_id" AllowPaging="True" AllowFilteringByColumn="true" GridLines="None"
                            CommandItemDisplay="Top" Name="Main" ShowGroupFooter="true">
                            <PagerStyle Position="TopAndBottom" Mode="NumericPages"></PagerStyle>
                            <RowIndicatorColumn Visible="False">
                                <ItemStyle></ItemStyle>
                                <HeaderStyle Width="20px"></HeaderStyle>
                            </RowIndicatorColumn>
                            <HeaderStyle></HeaderStyle>
                            <EditFormSettings>
                                <EditColumn></EditColumn>
                            </EditFormSettings>
                            <DetailTables>
                                <telerik:GridTableView DataKeyNames="ID" Name="Charges" Width="100%" AllowFilteringByColumn="false">
                                    <Columns>
                                        <telerik:GridBoundColumn HeaderText="Submitted" DataFormatString="{0:d}"
                                            DataField="date_submitted" UniqueName="date_submitted" SortExpression="date_submitted" Aggregate="Count" FooterText="Count: ">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Name"
                                            DataField="name" UniqueName="name" SortExpression="name">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Charge" DataFormatString="{0:c}" DataField="charge"
                                            UniqueName="charge" SortExpression="charge" Aggregate="Sum" FooterText="Total: ">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Loan Type" DataField="loan"
                                            UniqueName="loan" SortExpression="loan">
                                        </telerik:GridBoundColumn>
                                    </Columns>
                                    <%--<DetailTables>
                                        <telerik:GridTableView DataKeyNames="ID" Name="Help" Width="100%" AllowFilteringByColumn="true">
                                            <Columns>
                                                  <telerik:GridBoundColumn HeaderText="Loan Type" DataField="loan"
                                            UniqueName="loan" SortExpression="loan">
                                        </telerik:GridBoundColumn>
                                            </Columns>
                                            
                                        </telerik:GridTableView>
                                    </DetailTables>--%>
                                </telerik:GridTableView>
                            </DetailTables>
                            <Columns>
                                <telerik:GridBoundColumn HeaderText="Type" DataField="typ" Aggregate="Count" FooterText="Count: "
                                    UniqueName="typ" SortExpression="typ">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Charge" DataFormatString="{0:c}" Aggregate="Sum" FooterText="Total: "
                                    DataField="charge" UniqueName="charge" SortExpression="charge">
                                </telerik:GridBoundColumn>
                            </Columns>
                            <GroupByExpressions>
                                <telerik:GridGroupByExpression>
                                    <GroupByFields>
                                        <telerik:GridGroupByField FieldName="company_id" />
                                    </GroupByFields>
                                    <SelectFields>
                                        <telerik:GridGroupByField FieldName="office_name" HeaderText="Office Name" />
                                    </SelectFields>

                                </telerik:GridGroupByExpression>
                            </GroupByExpressions>
                            <EditItemStyle Font-Bold="True"></EditItemStyle>
                            <CommandItemSettings ShowAddNewRecordButton="false" ShowExportToPdfButton="true"
                                ShowExportToExcelButton="true" ShowExportToWordButton="true" ShowRefreshButton="false"></CommandItemSettings>
                            <GroupHeaderItemStyle></GroupHeaderItemStyle>
                            <ExpandCollapseColumn Visible="False" Resizable="False">
                                <HeaderStyle Width="20px"></HeaderStyle>
                            </ExpandCollapseColumn>
                        </MasterTableView>
                        <ClientSettings EnableRowHoverStyle="true">
                            <Selecting AllowRowSelect="False" />
                        </ClientSettings>
                    </telerik:RadGrid>
                    <br />
                    <br />
                    <telerik:RadGrid ID="rgSum" runat="server" GridLines="None" AutoGenerateColumns="False" AllowSorting="True"
                        PageSize="20" AllowFilteringByColumn="true" EnableLinqExpressions="false" ShowFooter="True">
                        <ExportSettings IgnorePaging="true" ExportOnlyData="true" HideStructureColumns="true" OpenInNewWindow="true"></ExportSettings>
                        <PagerStyle Position="TopAndBottom" Mode="NumericPages"></PagerStyle>
                        <MasterTableView DataKeyNames="typ" AllowPaging="True" AllowFilteringByColumn="true" GridLines="None"
                            CommandItemDisplay="Top" Name="Main" ShowGroupFooter="true">
                            <PagerStyle Position="TopAndBottom" Mode="NumericPages"></PagerStyle>
                            <RowIndicatorColumn Visible="False">
                                <ItemStyle></ItemStyle>
                                <HeaderStyle Width="20px"></HeaderStyle>
                            </RowIndicatorColumn>
                            <HeaderStyle></HeaderStyle>
                            <EditFormSettings>
                                <EditColumn></EditColumn>
                            </EditFormSettings>
                            <Columns>
                                <telerik:GridBoundColumn HeaderText="Types" DataField="typ"
                                    UniqueName="typ" SortExpression="typ">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Charge" DataFormatString="{0:c}"
                                    DataField="charge" UniqueName="charge" SortExpression="charge">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Count"
                                    DataField="num" UniqueName="num" SortExpression="num">
                                </telerik:GridBoundColumn>
                            </Columns>
                            <EditItemStyle Font-Bold="True"></EditItemStyle>
                            <CommandItemSettings ShowAddNewRecordButton="false" ShowExportToPdfButton="true"
                                ShowExportToExcelButton="true" ShowExportToWordButton="true" ShowRefreshButton="false"></CommandItemSettings>
                            <GroupHeaderItemStyle></GroupHeaderItemStyle>
                            <ExpandCollapseColumn Visible="False" Resizable="False">
                                <HeaderStyle Width="20px"></HeaderStyle>
                            </ExpandCollapseColumn>
                        </MasterTableView>
                        <ClientSettings EnableRowHoverStyle="true">
                            <Selecting AllowRowSelect="False" />
                        </ClientSettings>
                    </telerik:RadGrid>
                </td>
            </tr>
        </table>
    </telerik:RadAjaxPanel>
</asp:Content>

