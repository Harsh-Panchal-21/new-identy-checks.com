<%@ Page Title="IL FSA - UCC1 Submit" Language="VB" MasterPageFile="~/Main.master" AutoEventWireup="false" CodeFile="ucc1.aspx.vb" Inherits="ucc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headA" runat="Server">
    <script type="text/javascript">
        function textboxMultilineMaxNumber(txt, maxLen) {
            try {
                if (txt.value.length > (maxLen))   //maxLen - 1
                    txt.value = txt.value.substring(0, maxLen);  //return false;
            } catch (e) {
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <telerik:RadAjaxLoadingPanel runat="server" ID="RadAjaxLoadingPanel1" />
    <telerik:RadAjaxPanel ID="rapOne" runat="server" LoadingPanelID="RadAjaxLoadingPanel1">

        <table cellpadding="2" cellspacing="0" border="1" style="font-size: 8pt; width: 775px;">
            <tr>
                <td colspan="8" align="center">UCC FINANCING STATEMENT
                </td>
            </tr>
            <%--new ucc loan type--%>
            <tr>
                <td colspan="4">Loan Service Type<br />
                    Type:
                    <asp:DropDownList ID="ddlLoanType" runat="server">
                        <asp:ListItem Value="0">Select One</asp:ListItem>
                        <asp:ListItem Value="FSFL">Farm Storage Facility Loan</asp:ListItem>
                        <asp:ListItem Value="MAL">Market Assistance Loan</asp:ListItem>
                        <asp:ListItem Value="FLP">Farm Loan Program</asp:ListItem>
                    </asp:DropDownList><asp:RequiredFieldValidator runat="server" ErrorMessage="You must select a loan type." ControlToValidate="ddlLoanType" InitialValue="0" ForeColor="red"></asp:RequiredFieldValidator>
                </td>
                <td colspan="4">
                  Fiscal Year (FSFL only):<br />
                  <asp:DropDownList ID="ddlFY" runat="server">
                    <asp:ListItem Value="0">Select One</asp:ListItem>
                      <asp:ListItem Value="2010">2010</asp:ListItem>
                      <asp:ListItem Value="2011">2011</asp:ListItem>
                      <asp:ListItem Value="2012">2012</asp:ListItem>
                      <asp:ListItem Value="2013">2013</asp:ListItem>
                      <asp:ListItem Value="2014">2014</asp:ListItem>
                    <asp:ListItem Value="2015">2015</asp:ListItem>
                    <asp:ListItem Value="2016">2016</asp:ListItem>
                    <asp:ListItem Value="2017">2017</asp:ListItem>
                    <asp:ListItem Value="2018">2018</asp:ListItem>
					<asp:ListItem Value="2019">2019</asp:ListItem>
					<asp:ListItem Value="2020">2020</asp:ListItem>
					<asp:ListItem Value="2021">2021</asp:ListItem>
				  <asp:ListItem Value="2022">2022</asp:ListItem>
                      <asp:ListItem Value="2023">2023</asp:ListItem>
                    <asp:ListItem Value="2024">2023</asp:ListItem>
                  </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td colspan="8">What state was the corporation organized in?<br />
                    State:
                    <asp:DropDownList ID="lstOrg_State" runat="server"></asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td colspan="8" align="left">
                    <telerik:RadComboBox ID="rcbDebtor1" runat="server" EmptyMessage="Lookup Debtor." Visible="true" DataTextField="disp_name" DataValueField="key_name"
                        EnableLoadOnDemand="True" ShowMoreResultsBox="true" EnableVirtualScrolling="true" Width="300px" OnItemsRequested="rcbDebtor1_ItemsRequested" AutoPostBack="true">
                    </telerik:RadComboBox>
                    <!--
        <a href="View_UCC1.aspx?id=1" target="_blank">UCC1</a>
        <a href="View_UCC1ad.aspx?id=1" target="_blank">UCC1ad</a>
        <a href="View_UCC1ap.aspx?id=1" target="_blank">UCC1ap</a>
        <a href="View_UCC3.aspx?id=2" target="_blank">UCC3</a>
        <a href="View_UCC3ad.aspx?id=1" target="_blank">UCC3ad</a>
        <a href="View_UCC11.aspx?id=1" target="_blank">UCC11</a>
        -->
                </td>
            </tr>
            <tr>
                <td colspan="8" align="left">1. Debtor's Exact Full Legal Name - insert only <u>one</u> debtor name (1a or 1b) - do not abbreviate or combine names<br />
                    <asp:CheckBox ID="chkDebtor1_RunSearch" runat="server" Text="Run Search for this Debtor" AutoPostBack="true" />
                </td>
            </tr>
            <tr runat="server" id="trSearch1" visible="false">
                <td colspan="1" valign="middle" style="width: 25px;">&nbsp;</td>
                <td colspan="7" align="left">Search Info:<br />
                    Search Response:
                    <asp:CheckBox ID="chkSR1_All" runat="server" Checked="true" Text="All" AutoPostBack="true" />&nbsp;<asp:CheckBox ID="chkSR1_Unlapsed" runat="server" Text="Unlapsed" AutoPostBack="true" /><br />
                    Copy Request:
                    <asp:CheckBox ID="chkCR1_All" runat="server" Text="All" AutoPostBack="true" />&nbsp;<asp:CheckBox ID="chkCR1_Unlapsed" runat="server" Checked="true" Text="Unlapsed" AutoPostBack="true" /><br />
                    Search After Date
                    <asp:TextBox ID="txtMoreDate1" runat="server" Style="width: 75px;" MaxLength="10"></asp:TextBox>&nbsp;
        City, State
                    <asp:TextBox ID="txtMoreAddress1" runat="server" Style="width: 175px;" MaxLength="200"></asp:TextBox>&nbsp;<br />
                    Name Variations
                    <asp:TextBox ID="txtMoreName1" runat="server" Style="width: 175px;" MaxLength="200"></asp:TextBox>&nbsp;
        Other
                    <asp:TextBox ID="txtMoreOther1" runat="server" Style="width: 175px;" MaxLength="200"></asp:TextBox><br />
                    <!--Additional Services -->
                    <asp:TextBox Visible="false" ID="txtAdditional1" runat="server" Style="width: 250px;" />
                </td>
            </tr>
            <tr>
                <td colspan="1" rowspan="2" valign="middle" style="width: 25px;">OR</td>
                <td colspan="7" align="left">1a. Organization's Name<br />
                    <asp:TextBox ID="txtDebtor1_Org_Name" MaxLength="200" runat="server" Style="width: 500px;"></asp:TextBox></td>
            </tr>
            <tr>
                <td colspan="3" align="left">1b. Individual's Last Name<br />
                    <asp:TextBox ID="txtDebtor1_Ind_Last_Name" MaxLength="30" runat="server" Style="width: 200px;"></asp:TextBox></td>
                <td align="left">First Name<br />
                    <asp:TextBox ID="txtDebtor1_Ind_First_Name" runat="server" MaxLength="20" Style="width: 100px;"></asp:TextBox></td>
                <td colspan="2" align="left">Additional Name(s)/Initial(s)<br />
                    <asp:TextBox ID="txtDebtor1_Ind_Middle_Name" MaxLength="20" runat="server" Style="width: 75px;"></asp:TextBox></td>
                <td align="left">Suffix<br />
                    <asp:TextBox ID="txtDebtor1_Ind_Suffix" MaxLength="15" runat="server" Style="width: 50px;"></asp:TextBox></td>
            </tr>
            <tr>
                <td colspan="4" align="left">1c. Mailing Address<br />
                    <asp:TextBox ID="txtDebtor1_Mailing_Address" runat="server" MaxLength="32" Style="width: 210px;"></asp:TextBox></td>
                <td align="left">City<br />
                    <asp:TextBox ID="txtDebtor1_City" runat="server" MaxLength="18" Style="width: 100px;"></asp:TextBox></td>
                <td align="left">State<br />
                    <asp:DropDownList ID="lstDebtor1_State" runat="server"></asp:DropDownList></td>
                <td align="left">Postal Code<br />
                    <asp:TextBox ID="txtDebtor1_Zip" runat="server" MaxLength="9" Style="width: 75px;"></asp:TextBox></td>
                <td align="left">Country<br />
                    <asp:TextBox ID="txtDebtor1_Country" runat="server" Style="width: 50px;"></asp:TextBox></td>
            </tr>
            <tr runat="server" visible="false">
                <td colspan="2" align="left">1d. See Instructions<br />
                    <asp:TextBox ID="txtDebtor1_d1" runat="server" Style="width: 75px;"></asp:TextBox></td>
                <td>Addl Info Re Org Debtor</td>
                <td align="left">1e. Type of Organization<br />
                    <asp:DropDownList ID="lstDebtor1_Org_Type" runat="server"></asp:DropDownList>
                </td>
                <td align="left">1f. Jurisdiction Organization<br />
                    <asp:DropDownList ID="lstDebtor1_Org_Jurisdiction" runat="server"></asp:DropDownList>
                </td>
                <td colspan="3" align="left">1g. Organization ID #, if any<br />
                    <asp:TextBox ID="txtDebtor1_Org_ID" runat="server" MaxLength="35" Style="width: 75px;"></asp:TextBox>&nbsp;
        <asp:CheckBox ID="chkDebtor1_Org_ID_None" runat="server" Text="None" />
                </td>
            </tr>
        </table>
        <table cellpadding="2" cellspacing="0" border="1" style="font-size: 8pt; width: 775px;">
            <tr>
                <td colspan="8" align="left">
                    <telerik:RadComboBox ID="rcbDebtor2" runat="server" EmptyMessage="Lookup Second Debtor." Visible="true" DataTextField="disp_name" DataValueField="key_name"
                        EnableLoadOnDemand="True" ShowMoreResultsBox="true" EnableVirtualScrolling="true" Width="300px" OnItemsRequested="rcbDebtor2_ItemsRequested" AutoPostBack="true">
                    </telerik:RadComboBox>
                </td>
            </tr>
            <tr>
                <td colspan="8" align="left">2. Debtor's Exact Full Legal Name - insert only <u>one</u> debtor name (2a or 2b) - do not abbreviate or combine names<br />
                    <asp:CheckBox ID="chkDebtor2_RunSearch" runat="server" Text="Run Search for this Debtor" AutoPostBack="true" />
                </td>
            </tr>
            <tr runat="server" id="trSearch2" visible="false">
                <td colspan="1" valign="middle" style="width: 25px;">&nbsp;</td>
                <td colspan="7" align="left">Search Info:<br />
                    Search Response:
                    <asp:CheckBox ID="chkSR2_All" runat="server" Checked="true" Text="All" AutoPostBack="true" />&nbsp;<asp:CheckBox ID="chkSR2_Unlapsed" runat="server" Text="Unlapsed" AutoPostBack="true" /><br />
                    Copy Request:
                    <asp:CheckBox ID="chkCR2_All" runat="server" Text="All" AutoPostBack="true" />&nbsp;<asp:CheckBox ID="chkCR2_Unlapsed" runat="server" Checked="true" Text="Unlapsed" AutoPostBack="true" /><br />
                    Search After Date
                    <asp:TextBox ID="txtMoreDate2" runat="server" Style="width: 75px;" MaxLength="10"></asp:TextBox>&nbsp;
        City, State
                    <asp:TextBox ID="txtMoreAddress2" runat="server" Style="width: 175px;" MaxLength="200"></asp:TextBox>&nbsp;<br />
                    Name Variations
                    <asp:TextBox ID="txtMoreName2" runat="server" Style="width: 175px;" MaxLength="200"></asp:TextBox>&nbsp;
        Other
                    <asp:TextBox ID="txtMoreOther2" runat="server" Style="width: 175px;" MaxLength="200"></asp:TextBox><br />
                    <!--Additional Services -->
                    <asp:TextBox Visible="false" ID="txtAdditional2" runat="server" Style="width: 250px;" />
                </td>
            </tr>
            <tr>
                <td colspan="1" rowspan="2" valign="middle" style="width: 25px;">OR</td>
                <td colspan="7" align="left">2a. Organization's Name<br />
                    <asp:TextBox ID="txtDebtor2_Org_Name" runat="server" Style="width: 500px;"></asp:TextBox></td>
            </tr>
            <tr>
                <td colspan="3" align="left">2b. Individual's Last Name<br />
                    <asp:TextBox ID="txtDebtor2_Ind_Last_Name" runat="server" Style="width: 200px;"></asp:TextBox></td>
                <td align="left">First Name<br />
                    <asp:TextBox ID="txtDebtor2_Ind_First_Name" runat="server" Style="width: 100px;"></asp:TextBox></td>
                <td colspan="2" align="left">Additional Name(s)/Initial(s)<br />
                    <asp:TextBox ID="txtDebtor2_Ind_Middle_Name" runat="server" Style="width: 75px;"></asp:TextBox></td>
                <td align="left">Suffix<br />
                    <asp:TextBox ID="txtDebtor2_Ind_Suffix" runat="server" Style="width: 50px;"></asp:TextBox></td>
            </tr>
            <tr>
                <td colspan="4" align="left">2c. Mailing Address<br />
                    <asp:TextBox ID="txtDebtor2_Mailing_Address" runat="server" Style="width: 210px;"></asp:TextBox></td>
                <td align="left">City<br />
                    <asp:TextBox ID="txtDebtor2_City" runat="server" Style="width: 100px;"></asp:TextBox></td>
                <td align="left">State<br />
                    <asp:DropDownList ID="lstDebtor2_State" runat="server"></asp:DropDownList></td>
                <td align="left">Postal Code<br />
                    <asp:TextBox ID="txtDebtor2_Zip" runat="server" Style="width: 75px;"></asp:TextBox></td>
                <td align="left">Country<br />
                    <asp:TextBox ID="txtDebtor2_Country" runat="server" Style="width: 50px;"></asp:TextBox></td>
            </tr>
            <tr runat="server" visible="false">
                <td colspan="2" align="left">2d. See Instructions<br />
                    <asp:TextBox ID="txtDebtor2_d1" runat="server" Style="width: 75px;"></asp:TextBox></td>
                <td>Addl Info Re Org Debtor</td>
                <td align="left">2e. Type of Organization<br />
                    <asp:DropDownList ID="lstDebtor2_Org_Type" runat="server"></asp:DropDownList></td>
                <td align="left">2f. Jurisdiction Organization<br />
                    <asp:DropDownList ID="lstDebtor2_Org_Jurisdiction" runat="server"></asp:DropDownList></td>
                <td colspan="3" align="left">2g. Organization ID #, if any<br />
                    <asp:TextBox ID="txtDebtor2_Org_ID" runat="server" Style="width: 75px;"></asp:TextBox>&nbsp;
        <asp:CheckBox ID="chkDebtor2_Org_ID_None" runat="server" Text="None" />
                </td>
            </tr>
        </table>
        <table cellpadding="2" cellspacing="0" border="1" style="font-size: 8pt; width: 775px;">
            <tr>
                <td colspan="8" align="left">3. Secured Party's Name (or Name of Total Assignee or Assignor S/P) - insert only <u>one</u> secured party name (3a or 3b)</td>
            </tr>
            <tr>
                <td colspan="1" rowspan="1" valign="middle" style="width: 25px;">&nbsp;</td>
                <td colspan="7" align="left">3a. Organization's Name<br />
                    <asp:DropDownList ID="lstSecured_Org_Name" runat="server"></asp:DropDownList></td>
            </tr>
            <tr runat="server" visible="false">
                <td colspan="3" align="left">3b. Individual's Last Name<br />
                    <asp:TextBox ID="txtSecured_Ind_Last_Name" runat="server" Style="width: 200px;"></asp:TextBox></td>
                <td align="left">First Name<br />
                    <asp:TextBox ID="txtSecured_Ind_First_Name" runat="server" Style="width: 100px;"></asp:TextBox></td>
                <td colspan="2" align="left">Additional Name(s)/Initial(s)<br />
                    <asp:TextBox ID="txtSecured_Ind_Middle_Name" runat="server" Style="width: 75px;"></asp:TextBox></td>
                <td align="left">Suffix<br />
                    <asp:TextBox ID="txtSecured_Ind_Suffix" runat="server" Style="width: 50px;"></asp:TextBox></td>
            </tr>
            <tr>
                <td colspan="4" align="left">3c. Mailing Address<br />
                    <asp:TextBox ID="txtSecured_Mailing_Address" runat="server" Style="width: 210px;"></asp:TextBox></td>
                <td align="left">City<br />
                    <asp:TextBox ID="txtSecured_City" runat="server" Style="width: 100px;"></asp:TextBox></td>
                <td align="left">State<br />
                    <asp:DropDownList ID="lstSecured_State" runat="server"></asp:DropDownList></td>
                <td align="left">Postal Code<br />
                    <asp:TextBox ID="txtSecured_Zip" runat="server" Style="width: 75px;"></asp:TextBox></td>
                <td align="left">Country<br />
                    <asp:TextBox ID="txtSecured_Country" runat="server" Style="width: 50px;"></asp:TextBox></td>
            </tr>
        </table>
        <table cellpadding="2" cellspacing="0" border="1" style="font-size: 8pt; width: 775px;">
            <tr>
                <td colspan="8" align="left">4. This Financing Statement covers the following collateral (1200 characters max - use Addendum for additional space)<br />
                    <asp:DropDownList ID="lstCollateral" runat="server" AutoPostBack="true"></asp:DropDownList><br />
                    <asp:TextBox ID="txtCollateral" runat="server" TextMode="Multiline" Rows="10" Columns="80" MaxLength="1200" />
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtCollateral"
                        Display="Dynamic" ErrorMessage="Please limit to 1200 characters or less. Use Addendum for additional space."
                        ValidationExpression="[\s\S]{1,1200}"></asp:RegularExpressionValidator>
                </td>
            </tr>
            <tr runat="server" visible="false">
                <td colspan="8" align="left">5. Alternate Designation [if applicable]
			<asp:CheckBox ID="chkAlt_DesignationL" runat="server" Text="Lessee/Lessor" />
                    <asp:CheckBox ID="chkAlt_DesignationC" runat="server" Text="Consignee/Consignor" />
                    <asp:CheckBox ID="chkAlt_DesignationB" runat="server" Text="Bailee/Bailor" />
                    <asp:CheckBox ID="chkAlt_DesignationS" runat="server" Text="Seller/Buyer" />
                    <asp:CheckBox ID="chkAlt_DesignationA" runat="server" Text="AG Lien" />
                    <asp:CheckBox ID="chkAlt_DesignationN" runat="server" Text="Non-UCC Filing" />
                </td>
            </tr>
            <tr runat="server" visible="false">
                <td align="left" colspan="8">5. Check <u>only</u> if applicable and check <u>only</u> one box<br />
                    Debtor is a
                    <asp:CheckBox ID="chkAD_Trust" runat="server" Text="Trust" />
                    or
                    <asp:CheckBox ID="chkAD_Trustee" runat="server" Text="Trustee acting with respect to property held in trust" />
                    or
      <asp:CheckBox ID="chkAD_Decendant" runat="server" Text="Decendent's Estate" />
                </td>
            </tr>
            <tr runat="server" visible="false">
                <td align="left" colspan="8">6a. Check <u>only</u> if applicable and check <u>only</u> one box<br />
                    <asp:CheckBox ID="chkAD_Transmitting_Utility" runat="server" Text="Debtor is a Transmitting Utility" /><br />
                    <asp:CheckBox ID="chkAD_Manufactured_Home" runat="server" Text="Filed in connection with a Manufactured-Home Transaction - effective 30 years" /><br />
                    <asp:CheckBox ID="chkAD_Public_Finance" runat="server" Text="Filed in connection with a Public-Finance Transaction - effective 30 years" /><br />
                </td>
            </tr>

            <tr runat="server" visible="false">
                <td colspan="4" align="left">
                    <!-- old realestate -->
                </td>
                <td colspan="4" align="left">7. Check to Tequest Search Report(s) on Debtor(s) [Additional Fee]    [optional]
			<asp:CheckBox ID="chkReq_SearchA" runat="server" Text="All Debtors" />
                    <asp:CheckBox ID="chkReq_Search1" runat="server" Text="Debtor 1" />
                    <asp:CheckBox ID="chkReq_Search2" runat="server" Text="Debtor 2" />
                </td>
            </tr>
            <tr runat="server" visible="false">
                <td colspan="8" align="left">8. Optional Filer Reference Data<br />
                    <asp:TextBox ID="txtReference_Data" runat="server" TextMode="Multiline" Rows="2" Columns="65" />
                </td>
            </tr>
        </table>
        <table cellpadding="2" cellspacing="0" border="1" style="font-size: 8pt; width: 775px;">
            <tr>
                <td colspan="8" align="left">
                    <asp:CheckBox ID="chkShowUCC1ad" runat="server" Text="Show / Hide Addendum" AutoPostBack="true" /></td>
            </tr>
        </table>
        <asp:Panel runat="server" ID="pnlUCC1ad" Visible="false">
            <table cellpadding="2" cellspacing="0" border="1" style="font-size: 8pt; width: 775px;">
                <tr>
                    <td colspan="8" align="left">
                        <telerik:RadComboBox ID="rcbDebtor3" runat="server" EmptyMessage="Lookup Additional Debtor." Visible="true" DataTextField="disp_name" DataValueField="key_name"
                            EnableLoadOnDemand="True" ShowMoreResultsBox="true" EnableVirtualScrolling="true" Width="300px" OnItemsRequested="rcbDebtor3_ItemsRequested" AutoPostBack="true">
                        </telerik:RadComboBox>
                    </td>
                </tr>
                <tr>
                    <td colspan="8" align="left">10. Additional Debtor's Exact Full Legal Name - insert only <u>one</u> debtor name (10a or 10b) - do not abbreviate or combine names<br />
                        <asp:CheckBox ID="chkDebtor3_RunSearch" runat="server" Text="Run Search for this Debtor" AutoPostBack="true" />
                    </td>
                </tr>
                <tr runat="server" id="trSearch3" visible="false">
                    <td colspan="1" valign="middle" style="width: 25px;">&nbsp;</td>
                    <td colspan="7" align="left">Search Info:<br />
                        Search Response:
                        <asp:CheckBox ID="chkSR3_All" runat="server" Checked="true" Text="All" AutoPostBack="true" />&nbsp;<asp:CheckBox ID="chkSR3_Unlapsed" runat="server" Text="Unlapsed" AutoPostBack="true" /><br />
                        Copy Request:
                        <asp:CheckBox ID="chkCR3_All" runat="server" Text="All" AutoPostBack="true" />&nbsp;<asp:CheckBox ID="chkCR3_Unlapsed" runat="server" Checked="true" Text="Unlapsed" AutoPostBack="true" /><br />
                        Search After Date
                        <asp:TextBox ID="txtMoreDate3" runat="server" Style="width: 75px;" MaxLength="10"></asp:TextBox>&nbsp;
          City, State
                        <asp:TextBox ID="txtMoreAddress3" runat="server" Style="width: 175px;" MaxLength="200"></asp:TextBox>&nbsp;<br />
                        Name Variations
                        <asp:TextBox ID="txtMoreName3" runat="server" Style="width: 175px;" MaxLength="200"></asp:TextBox>&nbsp;
          Other
                        <asp:TextBox ID="txtMoreOther3" runat="server" Style="width: 175px;" MaxLength="200"></asp:TextBox><br />
                        <!--Additional Services -->
                        <asp:TextBox Visible="false" ID="txtAdditional3" runat="server" Style="width: 250px;" />
                    </td>
                </tr>
                <tr>
                    <td colspan="1" rowspan="2" valign="middle" style="width: 25px;">OR</td>
                    <td colspan="7" align="left">10a. Organization's Name<br />
                        <asp:TextBox ID="txtDebtor3_Org_Name" runat="server" Style="width: 500px;"></asp:TextBox></td>
                </tr>
                <tr>
                    <td colspan="3" align="left">10b. Individual's Last Name<br />
                        <asp:TextBox ID="txtDebtor3_Ind_Last_Name" runat="server" Style="width: 200px;"></asp:TextBox></td>
                    <td align="left">First Name<br />
                        <asp:TextBox ID="txtDebtor3_Ind_First_Name" runat="server" Style="width: 100px;"></asp:TextBox></td>
                    <td colspan="2" align="left">Additional Name(s)/Initial(s)<br />
                        <asp:TextBox ID="txtDebtor3_Ind_Middle_Name" runat="server" Style="width: 75px;"></asp:TextBox></td>
                    <td align="left">Suffix<br />
                        <asp:TextBox ID="txtDebtor3_Ind_Suffix" runat="server" Style="width: 50px;"></asp:TextBox></td>
                </tr>
                <tr>
                    <td colspan="4" align="left">10c. Mailing Address<br />
                        <asp:TextBox ID="txtDebtor3_Mailing_Address" runat="server" Style="width: 210px;"></asp:TextBox></td>
                    <td align="left">City<br />
                        <asp:TextBox ID="txtDebtor3_City" runat="server" Style="width: 100px;"></asp:TextBox></td>
                    <td align="left">State<br />
                        <asp:DropDownList ID="lstDebtor3_State" runat="server"></asp:DropDownList></td>
                    <td align="left">Postal Code<br />
                        <asp:TextBox ID="txtDebtor3_Zip" runat="server" Style="width: 75px;"></asp:TextBox></td>
                    <td align="left">Country<br />
                        <asp:TextBox ID="txtDebtor3_Country" runat="server" Style="width: 50px;"></asp:TextBox></td>
                </tr>
                <tr runat="server" visible="false">
                    <td colspan="2" align="left">11d. See Instructions<br />
                        <asp:TextBox ID="txtDebtor3_d1" runat="server" Style="width: 75px;"></asp:TextBox></td>
                    <td>Addl Info Re Org Debtor</td>
                    <td align="left">11e. Type of Organization<br />
                        <asp:DropDownList ID="lstDebtor3_Org_Type" runat="server"></asp:DropDownList></td>
                    <td align="left">11f. Jurisdiction Organization<br />
                        <asp:DropDownList ID="lstDebtor3_Org_Jurisdiction" runat="server"></asp:DropDownList></td>
                    <td colspan="3" align="left">11g. Organization ID #, if any<br />
                        <asp:TextBox ID="txtDebtor3_Org_ID" runat="server" Style="width: 75px;"></asp:TextBox>&nbsp;
          <asp:CheckBox ID="chkDebtor3_Org_ID_None" runat="server" Text="None" />
                    </td>
                </tr>
            </table>
            <table cellpadding="2" cellspacing="0" border="1" style="font-size: 8pt; width: 775px;">
                <tr>
                    <td colspan="8" align="left">11. 
				  <asp:CheckBox ID="chkSecured2_Party" runat="server" Text="Additional Secured Party's" />
                        <u>or</u>
                        <asp:CheckBox ID="chkSecured2_Assignor" runat="server" Text="Assignor S/P's" />
                        Name - insert only <u>one</u> name (11a or 11b)
                    </td>
                </tr>
                <tr>
                    <td colspan="1" rowspan="1" valign="middle" style="width: 25px;">&nbsp;</td>
                    <td colspan="7" align="left">11a. Organization's Name<br />
                        <asp:DropDownList ID="lstSecured2_Org_Name" runat="server"></asp:DropDownList></td>
                </tr>
                <tr id="Tr1" runat="server" visible="false">
                    <td colspan="3" align="left">11b. Individual's Last Name<br />
                        <asp:TextBox ID="txtSecured2_Ind_Last_Name" runat="server" Style="width: 200px;"></asp:TextBox></td>
                    <td align="left">First Name<br />
                        <asp:TextBox ID="txtSecured2_Ind_First_Name" runat="server" Style="width: 100px;"></asp:TextBox></td>
                    <td colspan="2" align="left">Additional Name(s)/Initial(s)<br />
                        <asp:TextBox ID="txtSecured2_Ind_Middle_Name" runat="server" Style="width: 75px;"></asp:TextBox></td>
                    <td align="left">Suffix<br />
                        <asp:TextBox ID="txtSecured2_Ind_Suffix" runat="server" Style="width: 50px;"></asp:TextBox></td>
                </tr>
                <tr>
                    <td colspan="4" align="left">11c. Mailing Address<br />
                        <asp:TextBox ID="txtSecured2_Mailing_Address" runat="server" Style="width: 210px;"></asp:TextBox></td>
                    <td align="left">City<br />
                        <asp:TextBox ID="txtSecured2_City" runat="server" Style="width: 100px;"></asp:TextBox></td>
                    <td align="left">State<br />
                        <asp:DropDownList ID="lstSecured2_State" runat="server"></asp:DropDownList></td>
                    <td align="left">Postal Code<br />
                        <asp:TextBox ID="txtSecured2_Zip" runat="server" Style="width: 75px;"></asp:TextBox></td>
                    <td align="left">Country<br />
                        <asp:TextBox ID="txtSecured2_Country" runat="server" Style="width: 50px;"></asp:TextBox></td>
                </tr>
            </table>
            <table cellpadding="2" cellspacing="0" border="1" style="font-size: 8pt; width: 775px;">
                <tr>
                    <td colspan="8" align="left">12. Additional Space for Item 4 (Collateral)<br />
                        <asp:TextBox ID="txtAD_Collateral" runat="server" TextMode="Multiline" Rows="2" Columns="65" />
                    </td>
                </tr>
            </table>
            <table cellpadding="2" cellspacing="0" border="1" style="font-size: 8pt; width: 775px;">
                <tr>
                    <td valign="top" align="left">13.
                        <asp:CheckBox ID="chkReal_Estate" runat="server" Text="" />This Financing Statement is to be filed [for record] (or recorded) in the Real Estate Records (if applicable)
                    </td>
                    <td valign="top" align="left">14. This Financing Statement covers
                        <asp:CheckBox ID="chkAD_Timber" runat="server" Text="timber to be cut or" />
                        <asp:CheckBox ID="chkAD_AsExtracted" runat="server" Text="as-extracted collateral" />, or is filed as a 
          <asp:CheckBox ID="chkAD_Fixture_Filing" runat="server" Text="fixture filing" />
                    </td>
                </tr>
                <tr>
                    <td valign="top" align="left">15. Name and address of a Record Owner of above-described real estate (If Debtor does not have a record interest)<br />
                        <asp:TextBox ID="txtAD_Record_Owner" runat="server" TextMode="Multiline" Rows="5" Columns="40" /><br />
                    </td>
                    <td valign="top" align="left">16. Description of real estate:<br />
                        <asp:TextBox ID="txtAD_Real_Estate" runat="server" TextMode="Multiline" Rows="12" Columns="40" /><br />
                    </td>
                </tr>
            </table>
            <table cellpadding="2" cellspacing="0" border="1" style="font-size: 8pt; width: 775px;">
                <tr>
                    <td colspan="8" align="left">17. Miscellaneous<br />
                        <asp:TextBox ID="txtAD_Misc" runat="server" TextMode="Multiline" Rows="2" Columns="65" />
                    </td>
                </tr>
            </table>
        </asp:Panel>
        <table cellpadding="2" cellspacing="0" border="1" style="font-size: 8pt; width: 775px;">
            <tr>
                <td colspan="8" align="left">
                    <asp:CheckBox ID="chkShowUCC1ap" runat="server" Text="Show / Hide Additional Parties" AutoPostBack="true" /></td>
            </tr>
        </table>
        <asp:Panel runat="server" ID="pnlUCC1ap" Visible="false">
            <table cellpadding="2" cellspacing="0" border="1" style="font-size: 8pt; width: 775px;">
                <tr>
                    <td colspan="8" align="left">
                        <telerik:RadComboBox ID="rcbDebtor4" runat="server" EmptyMessage="Lookup Additional Debtor." Visible="true" DataTextField="disp_name" DataValueField="key_name"
                            EnableLoadOnDemand="True" ShowMoreResultsBox="true" EnableVirtualScrolling="true" Width="300px" OnItemsRequested="rcbDebtor4_ItemsRequested" AutoPostBack="true">
                        </telerik:RadComboBox>
                    </td>
                </tr>
                <tr>
                    <td colspan="8" align="left">19. Additional Debtor's Exact Full Legal Name - insert only <u>one</u> debtor name (19a or 19b) - do not abbreviate or combine names<br />
                        <asp:CheckBox ID="chkDebtor4_RunSearch" runat="server" Text="Run Search for this Debtor" AutoPostBack="true" />
                    </td>
                </tr>
                <tr runat="server" id="trSearch4" visible="false">
                    <td colspan="1" valign="middle" style="width: 25px;">&nbsp;</td>
                    <td colspan="7" align="left">Search Info:<br />
                        Search Response:
                        <asp:CheckBox ID="chkSR4_All" runat="server" Checked="true" Text="All" AutoPostBack="true" />&nbsp;<asp:CheckBox ID="chkSR4_Unlapsed" runat="server" Text="Unlapsed" AutoPostBack="true" /><br />
                        Copy Request:
                        <asp:CheckBox ID="chkCR4_All" runat="server" Text="All" AutoPostBack="true" />&nbsp;<asp:CheckBox ID="chkCR4_Unlapsed" runat="server" Checked="true" Text="Unlapsed" AutoPostBack="true" /><br />
                        Search After Date
                        <asp:TextBox ID="txtMoreDate4" runat="server" Style="width: 75px;" MaxLength="10"></asp:TextBox>&nbsp;
            City, State
                        <asp:TextBox ID="txtMoreAddress4" runat="server" Style="width: 175px;" MaxLength="200"></asp:TextBox>&nbsp;<br />
                        Name Variations
                        <asp:TextBox ID="txtMoreName4" runat="server" Style="width: 175px;" MaxLength="200"></asp:TextBox>&nbsp;
            Other
                        <asp:TextBox ID="txtMoreOther4" runat="server" Style="width: 175px;" MaxLength="200"></asp:TextBox><br />
                        <!--Additional Services -->
                        <asp:TextBox Visible="false" ID="txtAdditional4" runat="server" Style="width: 250px;" />
                    </td>
                </tr>
                <tr>
                    <td colspan="1" rowspan="2" valign="middle" style="width: 25px;">OR</td>
                    <td colspan="7" align="left">19a. Organization's Name<br />
                        <asp:TextBox ID="txtDebtor4_Org_Name" runat="server" Style="width: 500px;"></asp:TextBox></td>
                </tr>
                <tr>
                    <td colspan="3" align="left">19b. Individual's Last Name<br />
                        <asp:TextBox ID="txtDebtor4_Ind_Last_Name" runat="server" Style="width: 200px;"></asp:TextBox></td>
                    <td align="left">First Name<br />
                        <asp:TextBox ID="txtDebtor4_Ind_First_Name" runat="server" Style="width: 100px;"></asp:TextBox></td>
                    <td colspan="2" align="left">Additional Name(s)/Initial(s)<br />
                        <asp:TextBox ID="txtDebtor4_Ind_Middle_Name" runat="server" Style="width: 75px;"></asp:TextBox></td>
                    <td align="left">Suffix<br />
                        <asp:TextBox ID="txtDebtor4_Ind_Suffix" runat="server" Style="width: 50px;"></asp:TextBox></td>
                </tr>
                <tr>
                    <td colspan="4" align="left">19c. Mailing Address<br />
                        <asp:TextBox ID="txtDebtor4_Mailing_Address" runat="server" Style="width: 210px;"></asp:TextBox></td>
                    <td align="left">City<br />
                        <asp:TextBox ID="txtDebtor4_City" runat="server" Style="width: 100px;"></asp:TextBox></td>
                    <td align="left">State<br />
                        <asp:DropDownList ID="lstDebtor4_State" runat="server"></asp:DropDownList></td>
                    <td align="left">Postal Code<br />
                        <asp:TextBox ID="txtDebtor4_Zip" runat="server" Style="width: 75px;"></asp:TextBox></td>
                    <td align="left">Country<br />
                        <asp:TextBox ID="txtDebtor4_Country" runat="server" Style="width: 50px;"></asp:TextBox></td>
                </tr>
                <tr runat="server" visible="false">
                    <td colspan="2" align="left">21d. See Instructions<br />
                        <asp:TextBox ID="txtDebtor4_d1" runat="server" Style="width: 75px;"></asp:TextBox></td>
                    <td>Addl Info Re Org Debtor</td>
                    <td align="left">21e. Type of Organization<br />
                        <asp:DropDownList ID="lstDebtor4_Org_Type" runat="server"></asp:DropDownList></td>
                    <td align="left">21f. Jurisdiction Organization<br />
                        <asp:DropDownList ID="lstDebtor4_Org_Jurisdiction" runat="server"></asp:DropDownList></td>
                    <td colspan="3" align="left">21g. Organization ID #, if any<br />
                        <asp:TextBox ID="txtDebtor4_Org_ID" runat="server" Style="width: 75px;"></asp:TextBox>&nbsp;
            <asp:CheckBox ID="chkDebtor4_Org_ID_None" runat="server" Text="None" />
                    </td>
                </tr>
            </table>
            <table cellpadding="2" cellspacing="0" border="1" style="font-size: 8pt; width: 775px;">
                <tr>
                    <td colspan="8" align="left">
                        <telerik:RadComboBox ID="rcbDebtor5" runat="server" EmptyMessage="Lookup Additional Debtor." Visible="true" DataTextField="disp_name" DataValueField="key_name"
                            EnableLoadOnDemand="True" ShowMoreResultsBox="true" EnableVirtualScrolling="true" Width="300px" OnItemsRequested="rcbDebtor5_ItemsRequested" AutoPostBack="true">
                        </telerik:RadComboBox>
                    </td>
                </tr>
                <tr>
                    <td colspan="8" align="left">20. Additional Debtor's Exact Full Legal Name - insert only <u>one</u> debtor name (22a or 22b) - do not abbreviate or combine names<br />
                        <asp:CheckBox ID="chkDebtor5_RunSearch" runat="server" Text="Run Search for this Debtor" AutoPostBack="true" />
                    </td>
                </tr>
                <tr runat="server" id="trSearch5" visible="false">
                    <td colspan="1" valign="middle" style="width: 25px;">&nbsp;</td>
                    <td colspan="7" align="left">Search Info:<br />
                        Search Response:
                        <asp:CheckBox ID="chkSR5_All" runat="server" Checked="true" Text="All" AutoPostBack="true" />&nbsp;<asp:CheckBox ID="chkSR5_Unlapsed" runat="server" Text="Unlapsed" AutoPostBack="true" /><br />
                        Copy Request:
                        <asp:CheckBox ID="chkCR5_All" runat="server" Text="All" AutoPostBack="true" />&nbsp;<asp:CheckBox ID="chkCR5_Unlapsed" runat="server" Checked="true" Text="Unlapsed" AutoPostBack="true" /><br />
                        Search After Date
                        <asp:TextBox ID="txtMoreDate5" runat="server" Style="width: 75px;" MaxLength="10"></asp:TextBox>&nbsp;
            City, State
                        <asp:TextBox ID="txtMoreAddress5" runat="server" Style="width: 175px;" MaxLength="200"></asp:TextBox>&nbsp;<br />
                        Name Variations
                        <asp:TextBox ID="txtMoreName5" runat="server" Style="width: 175px;" MaxLength="200"></asp:TextBox>&nbsp;
            Other
                        <asp:TextBox ID="txtMoreOther5" runat="server" Style="width: 175px;" MaxLength="200"></asp:TextBox><br />
                        <!--Additional Services -->
                        <asp:TextBox Visible="false" ID="txtAdditional5" runat="server" Style="width: 250px;" />
                    </td>
                </tr>
                <tr>
                    <td colspan="1" rowspan="2" valign="middle" style="width: 25px;">OR</td>
                    <td colspan="7" align="left">20a. Organization's Name<br />
                        <asp:TextBox ID="txtDebtor5_Org_Name" runat="server" Style="width: 500px;"></asp:TextBox></td>
                </tr>
                <tr>
                    <td colspan="3" align="left">20b. Individual's Last Name<br />
                        <asp:TextBox ID="txtDebtor5_Ind_Last_Name" runat="server" Style="width: 200px;"></asp:TextBox></td>
                    <td align="left">First Name<br />
                        <asp:TextBox ID="txtDebtor5_Ind_First_Name" runat="server" Style="width: 100px;"></asp:TextBox></td>
                    <td colspan="2" align="left">Additional Name(s)/Initial(s)<br />
                        <asp:TextBox ID="txtDebtor5_Ind_Middle_Name" runat="server" Style="width: 75px;"></asp:TextBox></td>
                    <td align="left">Suffix<br />
                        <asp:TextBox ID="txtDebtor5_Ind_Suffix" runat="server" Style="width: 50px;"></asp:TextBox></td>
                </tr>
                <tr>
                    <td colspan="4" align="left">20c. Mailing Address<br />
                        <asp:TextBox ID="txtDebtor5_Mailing_Address" runat="server" Style="width: 210px;"></asp:TextBox></td>
                    <td align="left">City<br />
                        <asp:TextBox ID="txtDebtor5_City" runat="server" Style="width: 100px;"></asp:TextBox></td>
                    <td align="left">State<br />
                        <asp:DropDownList ID="lstDebtor5_State" runat="server"></asp:DropDownList></td>
                    <td align="left">Postal Code<br />
                        <asp:TextBox ID="txtDebtor5_Zip" runat="server" Style="width: 75px;"></asp:TextBox></td>
                    <td align="left">Country<br />
                        <asp:TextBox ID="txtDebtor5_Country" runat="server" Style="width: 50px;"></asp:TextBox></td>
                </tr>
                <tr runat="server" visible="false">
                    <td colspan="2" align="left">22d. See Instructions<br />
                        <asp:TextBox ID="txtDebtor5_d1" runat="server" Style="width: 75px;"></asp:TextBox></td>
                    <td>Addl Info Re Org Debtor</td>
                    <td align="left">22e. Type of Organization<br />
                        <asp:DropDownList ID="lstDebtor5_Org_Type" runat="server"></asp:DropDownList></td>
                    <td align="left">22f. Jurisdiction Organization<br />
                        <asp:DropDownList ID="lstDebtor5_Org_Jurisdiction" runat="server"></asp:DropDownList></td>
                    <td colspan="3" align="left">22g. Organization ID #, if any<br />
                        <asp:TextBox ID="txtDebtor5_Org_ID" runat="server" Style="width: 75px;"></asp:TextBox>&nbsp;
            <asp:CheckBox ID="chkDebtor5_Org_ID_None" runat="server" Text="None" />
                    </td>
                </tr>
            </table>
            <table cellpadding="2" cellspacing="0" border="1" style="font-size: 8pt; width: 775px;">
                <tr>
                    <td colspan="8" align="left">
                        <telerik:RadComboBox ID="rcbDebtor6" runat="server" EmptyMessage="Lookup Additional Debtor." Visible="true" DataTextField="disp_name" DataValueField="key_name"
                            EnableLoadOnDemand="True" ShowMoreResultsBox="true" EnableVirtualScrolling="true" Width="300px" OnItemsRequested="rcbDebtor6_ItemsRequested" AutoPostBack="true">
                        </telerik:RadComboBox>
                    </td>
                </tr>
                <tr>
                    <td colspan="8" align="left">21. Additional Debtor's Exact Full Legal Name - insert only <u>one</u> debtor name (23a or 23b) - do not abbreviate or combine names<br />
                        <asp:CheckBox ID="chkDebtor6_RunSearch" runat="server" Text="Run Search for this Debtor" AutoPostBack="true" />
                    </td>
                </tr>
                <tr runat="server" id="trSearch6" visible="false">
                    <td colspan="1" valign="middle" style="width: 25px;">&nbsp;</td>
                    <td colspan="7" align="left">Search Info:<br />
                        Search Response:
                        <asp:CheckBox ID="chkSR6_All" runat="server" Checked="true" Text="All" AutoPostBack="true" />&nbsp;<asp:CheckBox ID="chkSR6_Unlapsed" runat="server" Text="Unlapsed" AutoPostBack="true" /><br />
                        Copy Request:
                        <asp:CheckBox ID="chkCR6_All" runat="server" Text="All" AutoPostBack="true" />&nbsp;<asp:CheckBox ID="chkCR6_Unlapsed" runat="server" Checked="true" Text="Unlapsed" AutoPostBack="true" /><br />
                        Search After Date
                        <asp:TextBox ID="txtMoreDate6" runat="server" Style="width: 75px;" MaxLength="10"></asp:TextBox>&nbsp;
            City, State
                        <asp:TextBox ID="txtMoreAddress6" runat="server" Style="width: 175px;" MaxLength="200"></asp:TextBox>&nbsp;<br />
                        Name Variations
                        <asp:TextBox ID="txtMoreName6" runat="server" Style="width: 175px;" MaxLength="200"></asp:TextBox>&nbsp;
            Other
                        <asp:TextBox ID="txtMoreOther6" runat="server" Style="width: 175px;" MaxLength="200"></asp:TextBox><br />
                        <!--Additional Services -->
                        <asp:TextBox Visible="false" ID="txtAdditional6" runat="server" Style="width: 250px;" />
                    </td>
                </tr>
                <tr>
                    <td colspan="1" rowspan="2" valign="middle" style="width: 25px;">OR</td>
                    <td colspan="7" align="left">21a. Organization's Name<br />
                        <asp:TextBox ID="txtDebtor6_Org_Name" runat="server" Style="width: 500px;"></asp:TextBox></td>
                </tr>
                <tr>
                    <td colspan="3" align="left">21b. Individual's Last Name<br />
                        <asp:TextBox ID="txtDebtor6_Ind_Last_Name" runat="server" Style="width: 200px;"></asp:TextBox></td>
                    <td align="left">First Name<br />
                        <asp:TextBox ID="txtDebtor6_Ind_First_Name" runat="server" Style="width: 100px;"></asp:TextBox></td>
                    <td colspan="2" align="left">Additional Name(s)/Initial(s)<br />
                        <asp:TextBox ID="txtDebtor6_Ind_Middle_Name" runat="server" Style="width: 75px;"></asp:TextBox></td>
                    <td align="left">Suffix<br />
                        <asp:TextBox ID="txtDebtor6_Ind_Suffix" runat="server" Style="width: 50px;"></asp:TextBox></td>
                </tr>
                <tr>
                    <td colspan="4" align="left">21c. Mailing Address<br />
                        <asp:TextBox ID="txtDebtor6_Mailing_Address" runat="server" Style="width: 210px;"></asp:TextBox></td>
                    <td align="left">City<br />
                        <asp:TextBox ID="txtDebtor6_City" runat="server" Style="width: 100px;"></asp:TextBox></td>
                    <td align="left">State<br />
                        <asp:DropDownList ID="lstDebtor6_State" runat="server"></asp:DropDownList></td>
                    <td align="left">Postal Code<br />
                        <asp:TextBox ID="txtDebtor6_Zip" runat="server" Style="width: 75px;"></asp:TextBox></td>
                    <td align="left">Country<br />
                        <asp:TextBox ID="txtDebtor6_Country" runat="server" Style="width: 50px;"></asp:TextBox></td>
                </tr>
                <tr runat="server" visible="false">
                    <td colspan="2" align="left">23d. See Instructions<br />
                        <asp:TextBox ID="txtDebtor6_d1" runat="server" Style="width: 75px;"></asp:TextBox></td>
                    <td>Addl Info Re Org Debtor</td>
                    <td align="left">23e. Type of Organization<br />
                        <asp:DropDownList ID="lstDebtor6_Org_Type" runat="server"></asp:DropDownList></td>
                    <td align="left">23f. Jurisdiction Organization<br />
                        <asp:DropDownList ID="lstDebtor6_Org_Jurisdiction" runat="server"></asp:DropDownList></td>
                    <td colspan="3" align="left">23g. Organization ID #, if any<br />
                        <asp:TextBox ID="txtDebtor6_Org_ID" runat="server" Style="width: 75px;"></asp:TextBox>&nbsp;
            <asp:CheckBox ID="chkDebtor6_Org_ID_None" runat="server" Text="None" />
                    </td>
                </tr>
            </table>
            <table cellpadding="2" cellspacing="0" border="1" style="font-size: 8pt; width: 775px;">
                <tr>
                    <td colspan="8" align="left">22. Secured Party's Name (or Name of Total Assignee or Assignor S/P) - insert only <u>one</u> secured party name (24a or 24b)
                    </td>
                </tr>
                <tr>
                    <td colspan="1" rowspan="1" valign="middle" style="width: 25px;">&nbsp;</td>
                    <td colspan="7" align="left">22a. Organization's Name<br />
                        <asp:DropDownList ID="lstSecured3_Org_Name" runat="server"></asp:DropDownList></td>
                </tr>
                <tr id="Tr2" runat="server" visible="false">
                    <td colspan="3" align="left">22b. Individual's Last Name<br />
                        <asp:TextBox ID="txtSecured3_Ind_Last_Name" runat="server" Style="width: 200px;"></asp:TextBox></td>
                    <td align="left">First Name<br />
                        <asp:TextBox ID="txtSecured3_Ind_First_Name" runat="server" Style="width: 100px;"></asp:TextBox></td>
                    <td colspan="2" align="left">Additional Name(s)/Initial(s)<br />
                        <asp:TextBox ID="txtSecured3_Ind_Middle_Name" runat="server" Style="width: 75px;"></asp:TextBox></td>
                    <td align="left">Suffix<br />
                        <asp:TextBox ID="txtSecured3_Ind_Suffix" runat="server" Style="width: 50px;"></asp:TextBox></td>
                </tr>
                <tr>
                    <td colspan="4" align="left">22c. Mailing Address<br />
                        <asp:TextBox ID="txtSecured3_Mailing_Address" runat="server" Style="width: 210px;"></asp:TextBox></td>
                    <td align="left">City<br />
                        <asp:TextBox ID="txtSecured3_City" runat="server" Style="width: 100px;"></asp:TextBox></td>
                    <td align="left">State<br />
                        <asp:DropDownList ID="lstSecured3_State" runat="server"></asp:DropDownList></td>
                    <td align="left">Postal Code<br />
                        <asp:TextBox ID="txtSecured3_Zip" runat="server" Style="width: 75px;"></asp:TextBox></td>
                    <td align="left">Country<br />
                        <asp:TextBox ID="txtSecured3_Country" runat="server" Style="width: 50px;"></asp:TextBox></td>
                </tr>
            </table>
            <table cellpadding="2" cellspacing="0" border="1" style="font-size: 8pt; width: 775px;">
                <tr>
                    <td colspan="8" align="left">23. Secured Party's Name (or Name of Total Assignee or Assignor S/P) - insert only <u>one</u> secured party name (25a or 25b)
                    </td>
                </tr>
                <tr>
                    <td colspan="1" rowspan="1" valign="middle" style="width: 25px;">&nbsp;</td>
                    <td colspan="7" align="left">23a. Organization's Name<br />
                        <asp:DropDownList ID="lstSecured4_Org_Name" runat="server"></asp:DropDownList></td>
                </tr>
                <tr id="Tr3" runat="server" visible="false">
                    <td colspan="3" align="left">23b. Individual's Last Name<br />
                        <asp:TextBox ID="txtSecured4_Ind_Last_Name" runat="server" Style="width: 200px;"></asp:TextBox></td>
                    <td align="left">First Name<br />
                        <asp:TextBox ID="txtSecured4_Ind_First_Name" runat="server" Style="width: 100px;"></asp:TextBox></td>
                    <td colspan="2" align="left">Additional Name(s)/Initial(s)<br />
                        <asp:TextBox ID="txtSecured4_Ind_Middle_Name" runat="server" Style="width: 75px;"></asp:TextBox></td>
                    <td align="left">Suffix<br />
                        <asp:TextBox ID="txtSecured4_Ind_Suffix" runat="server" Style="width: 50px;"></asp:TextBox></td>
                </tr>
                <tr>
                    <td colspan="4" align="left">23c. Mailing Address<br />
                        <asp:TextBox ID="txtSecured4_Mailing_Address" runat="server" Style="width: 210px;"></asp:TextBox></td>
                    <td align="left">City<br />
                        <asp:TextBox ID="txtSecured4_City" runat="server" Style="width: 100px;"></asp:TextBox></td>
                    <td align="left">State<br />
                        <asp:DropDownList ID="lstSecured4_State" runat="server"></asp:DropDownList></td>
                    <td align="left">Postal Code<br />
                        <asp:TextBox ID="txtSecured4_Zip" runat="server" Style="width: 75px;"></asp:TextBox></td>
                    <td align="left">Country<br />
                        <asp:TextBox ID="txtSecured4_Country" runat="server" Style="width: 50px;"></asp:TextBox></td>
                </tr>
            </table>
            <table cellpadding="2" cellspacing="0" border="1" style="font-size: 8pt; width: 775px;">
                <tr>
                    <td colspan="8" align="left">24. Miscellaneous<br />
                        <asp:TextBox ID="txtAP_Misc" runat="server" TextMode="Multiline" Rows="2" Columns="65" />
                    </td>
                </tr>
            </table>
        </asp:Panel>
        <table cellpadding="2" cellspacing="0" border="1" style="font-size: 8pt; width: 775px;">
            <tr>
                <td colspan="8" align="left">
                    <asp:Button ID="btnSubmit" runat="server" Text="Submit Filing" />
                    <asp:Label ID="lblMsg" runat="server" ForeColor="red"></asp:Label>
                </td>
            </tr>
        </table>

    </telerik:RadAjaxPanel>
</asp:Content>

