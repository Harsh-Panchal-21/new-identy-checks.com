<%@ Page Title="" Language="VB" MasterPageFile="~/Main.master" AutoEventWireup="false" CodeFile="ucc3.aspx.vb" Inherits="ucc3" %>

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
                <td colspan="8" align="center">UCC FINANCING STATEMENT AMENDMENT
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
                        <asp:ListItem Value="FLP">Farm Loan Program </asp:ListItem>
                    </asp:DropDownList><asp:RequiredFieldValidator runat="server" ErrorMessage="You must select a loan type." ControlToValidate="ddlLoanType" InitialValue="0" ForeColor="red"></asp:RequiredFieldValidator>
                </td>
              <td colspan="2">
                Debtor's Name: <br />
                <asp:TextBox ID="txtInitialName" runat="server"></asp:TextBox>
                <asp:RequiredFieldValidator runat="server" ErrorMessage="You must provide the initial organization/individual name." ControlToValidate="txtInitialName" InitialValue="" ForeColor="red"></asp:RequiredFieldValidator>
              </td>
              <td colspan="2" valign="top">
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
                <td colspan="5" align="left">1a. Initial Financing Statement File #<br />
                    <asp:TextBox ID="txtInitial_file_No" runat="server"></asp:TextBox>
                </td>
                <td colspan="3">1b.
                    <asp:CheckBox ID="chkReal_Estate" runat="server" Text="This Financing Statement Amendment is to be filed [for record] (or recorded) in the Real Estate Records" />
                </td>
            </tr>
            <tr>
                <td colspan="8" align="left">2.
                    <asp:CheckBox ID="chkTermination" runat="server" Text="TERMINATION:" />
                    Effectiveness of the Financing Statement identified above is terminated with respect to security interest(s) of the Secured Party authorizing thie Termination statement.
                </td>
            </tr>
            <tr>
                <td colspan="8" align="left">3.
                    <asp:CheckBox ID="chkAssignment" runat="server" Text="ASSIGNMENT:" />
                    (full or partial): Give name of assignee in item 7a or 7b and address of assignee in item 7c; and also give name of assignor in item 9..
                </td>
            </tr>
            <tr>
                <td colspan="8" align="left">4.
                    <asp:CheckBox ID="chkContinuation" runat="server" Text="CONTINUATION:" />
                    Effectiveness of the Financing Statement identified above is with respect to security interest(s) of the Secured Party authorizing this Continuation Statement is continued for the additional period provided by law.
                </td>
            </tr>
            <tr>
                <td colspan="8" align="left">5.
                    <asp:CheckBox ID="chkPartyChange" runat="server" Text="PARTY INFORMATION CHANGE:" />
                    This Amendment affects
                    <asp:CheckBox ID="chkAmend_Debtor" runat="server" Text="Debtor" />
                    <u>or</u>
                    <asp:CheckBox ID="chkAmend_Secured_Party" runat="server" Text="Secured Party" />
                    of record. Check only <u>one</u> of these two boxes.<br />
                    Also check <u>one</u> of the following three boxes <u>and</u> provide appropriate information in items 6 and/or 7.
                </td>
            </tr>
            <tr>
                <td colspan="4" align="left" valign="top">
                    <asp:CheckBox ID="chkAmend_Change" runat="server" Text="CHANGE name and/or address: Please refer to the detailed instructions in regards to changing the name/address of a party." />
                </td>
                <td colspan="1" align="left" valign="top">
                    <asp:CheckBox ID="chkAmend_Delete" runat="server" Text="DELETE name: Give record name to be deleted in item 6a or 6b." />
                </td>
                <td colspan="3" align="left" valign="top">
                    <asp:CheckBox ID="chkAmend_Add" runat="server" Text="ADD name: Complete item 7a or 7b, and also 7c; also complete items 7e-7g (if applicable)." />
                </td>
            </tr>
            <tr>
                <td colspan="1" rowspan="2" valign="middle" style="width: 25px;">OR</td>
                <td colspan="7" align="left">6. Organization's Name<br />
                    <asp:TextBox ID="txtOrig_Org_Name" runat="server" Style="width: 500px;"></asp:TextBox></td>
            </tr>
            <tr>
                <td colspan="3" align="left">6b. Individual's Last Name<br />
                    <asp:TextBox ID="txtOrig_Ind_Last_Name" runat="server" Style="width: 200px;"></asp:TextBox></td>
                <td align="left">First Name<br />
                    <asp:TextBox ID="txtOrig_Ind_First_Name" runat="server" Style="width: 100px;"></asp:TextBox></td>
                <td colspan="2" align="left">Additional Name(s)/Initial(s)<br />
                    <asp:TextBox ID="txtOrig_Ind_Middle_Name" runat="server" Style="width: 75px;"></asp:TextBox></td>
                <td align="left">Suffix<br />
                    <asp:TextBox ID="txtOrig_Ind_Suffix" runat="server" Style="width: 50px;"></asp:TextBox></td>
            </tr>
            <tr>
                <td colspan="8" align="left">
                    <telerik:RadComboBox ID="rcbNew_Debtor" runat="server" EmptyMessage="Lookup Debtor." Visible="true" DataTextField="disp_name" DataValueField="key_name"
                        EnableLoadOnDemand="True" ShowMoreResultsBox="true" EnableVirtualScrolling="true" Width="300px" OnItemsRequested="rcbNewDebtor_ItemsRequested" AutoPostBack="true">
                    </telerik:RadComboBox>
                </td>
            </tr>
            <tr>
                <td colspan="8" align="left">7. Changed (New) or Added Information
                </td>
            </tr>
            <tr>
                <td colspan="1" rowspan="2" valign="middle" style="width: 25px;">OR</td>
                <td colspan="7" align="left">7a. Organization's Name<br />
                    <asp:TextBox ID="txtDebtor1_Org_Name" runat="server" Style="width: 500px;"></asp:TextBox></td>
            </tr>
            <tr>
                <td colspan="3" align="left">7b. Individual's Last Name<br />
                    <asp:TextBox ID="txtDebtor1_Ind_Last_Name" runat="server" Style="width: 200px;"></asp:TextBox></td>
                <td align="left">First Name<br />
                    <asp:TextBox ID="txtDebtor1_Ind_First_Name" runat="server" Style="width: 100px;"></asp:TextBox></td>
                <td colspan="2" align="left">Additional Name(s)/Initial(s)<br />
                    <asp:TextBox ID="txtDebtor1_Ind_Middle_Name" runat="server" Style="width: 75px;"></asp:TextBox></td>
                <td align="left">Suffix<br />
                    <asp:TextBox ID="txtDebtor1_Ind_Suffix" runat="server" Style="width: 50px;"></asp:TextBox></td>
            </tr>
            <tr>
                <td colspan="4" align="left">7c. Mailing Address<br />
                    <asp:TextBox ID="txtDebtor1_Mailing_Address" runat="server" Style="width: 210px;"></asp:TextBox></td>
                <td align="left">City<br />
                    <asp:TextBox ID="txtDebtor1_City" runat="server" Style="width: 100px;"></asp:TextBox></td>
                <td align="left">State<br />
                    <asp:DropDownList ID="lstDebtor1_State" runat="server"></asp:DropDownList></td>
                <td align="left">Postal Code<br />
                    <asp:TextBox ID="txtDebtor1_Zip" runat="server" Style="width: 75px;"></asp:TextBox></td>
                <td align="left">Country<br />
                    <asp:TextBox ID="txtDebtor1_Country" runat="server" Style="width: 50px;"></asp:TextBox></td>
            </tr>
            <tr runat="server" visible="false">
                <td colspan="2" align="left">7d. See Instructions<br />
                    <asp:TextBox ID="txtDebtor1_d1" runat="server" Style="width: 75px;"></asp:TextBox></td>
                <td>Addl Info Re Org Debtor</td>
                <td align="left">7e. Type of Organization<br />
                    <asp:DropDownList ID="lstDebtor1_Org_Type" runat="server"></asp:DropDownList></td>
                <td align="left">7f. Jurisdiction Organization<br />
                    <asp:DropDownList ID="lstDebtor1_Org_Jurisdiction" runat="server"></asp:DropDownList></td>
                <td colspan="3" align="left">7g. Organization ID #, if any<br />
                    <asp:TextBox ID="txtDebtor1_Org_ID" runat="server" Style="width: 75px;"></asp:TextBox>&nbsp;
          <asp:CheckBox ID="chkDebtor1_Org_ID_None" runat="server" Text="None" />
                </td>
            </tr>
            <tr>
                <td colspan="8" align="left">8.
                    <asp:CheckBox ID="chkCollateralChange" runat="server" Text="COLLATERAL CHANGE:" />
                    check only <u>one</u> box.<br />
                    Describe collateral
                    <asp:CheckBox ID="chkCollateral_Deleted" runat="server" Text="deleted" />
                    or 
          <asp:CheckBox ID="chkCollateral_Added" runat="server" Text="added" />, or give entire
          <asp:CheckBox ID="chkCollateral_Restated" runat="server" Text="restated collateral description" />,
                    <br />
                    or describe collateral
                    <asp:CheckBox ID="chkCollateral_Assigned" runat="server" Text="assigned" />.<br />
                    <asp:TextBox ID="txtCollateral" runat="server" TextMode="Multiline" Rows="9" Columns="80" />
                </td>
            </tr>
            <tr>
                <td colspan="8" align="left">9. Name of Secured Party of Record Authorizing This Amendment (name of assignor, if this is an Assignment). If this is an Amendment authorized by a Debtor which adds collateral or adds the authorizing debtor, or if this is a Termination authorized by a Debtor, check here
                    <asp:CheckBox ID="chkSecured_Termination" runat="server" />
                    and enter name of Debtor authorizing Amendment.</td>
            </tr>
            <tr>
                <td colspan="1" rowspan="1" valign="middle" style="width: 25px;">&nbsp;</td>
                <td colspan="7" align="left">9a. Organization's Name<br />
                    <asp:DropDownList ID="lstSecured_Org_Name" runat="server"></asp:DropDownList></td>
            </tr>
            <tr id="Tr2" runat="server" visible="false">
                <td colspan="3" align="left">9b. Individual's Last Name<br />
                    <asp:TextBox ID="txtSecured_Ind_Last_Name" runat="server" Style="width: 200px;"></asp:TextBox></td>
                <td align="left">First Name<br />
                    <asp:TextBox ID="txtSecured_Ind_First_Name" runat="server" Style="width: 100px;"></asp:TextBox></td>
                <td colspan="2" align="left">Additional Name(s)/Initial(s)<br />
                    <asp:TextBox ID="txtSecured_Ind_Middle_Name" runat="server" Style="width: 75px;"></asp:TextBox></td>
                <td align="left">Suffix<br />
                    <asp:TextBox ID="txtSecured_Ind_Suffix" runat="server" Style="width: 50px;"></asp:TextBox></td>
            </tr>
            <tr id="Tr1" runat="server" visible="true">
                <td colspan="8" align="left">10. Optional Filer Reference Data<br />
                    <asp:TextBox ID="txtReference_Data" runat="server" TextMode="Multiline" Rows="2" Columns="65" />
                </td>
            </tr>
        </table>
        <table cellpadding="2" cellspacing="0" border="1" style="font-size: 8pt; width: 775px;">
            <tr>
                <td colspan="8" align="left">
                    <asp:CheckBox ID="chkShowUCC3ad" runat="server" Text="Show / Hide Addendum" AutoPostBack="true" /></td>
            </tr>
        </table>
        <asp:Panel runat="server" ID="pnlUCC3ad" Visible="false">
            <table cellpadding="2" cellspacing="0" border="1" style="font-size: 8pt; width: 775px;">
                <tr>
                    <td colspan="8" align="left">14. Additional Space for Item 8 (Collateral)<br />
                        <asp:TextBox ID="txtAD_Additional" runat="server" TextMode="Multiline" Rows="15" Columns="80" />
                    </td>
                </tr>
            </table>
            <table cellpadding="2" cellspacing="0" border="1" style="font-size: 8pt; width: 775px;">
                <tr>
                    <td valign="top" align="left">15. This Financing Statement Amendment
                        <asp:CheckBox ID="chkAD_Timber" runat="server" Text="covers timber to be cut or" />
                        <asp:CheckBox ID="chkAD_AsExtracted" runat="server" Text="covers as-extracted collateral" />, or is filed as a 
            <asp:CheckBox ID="chkAD_Fixture_Filing" runat="server" Text="is filed as a fixture filing" />
                    </td>
                    <td valign="top" align="left" rowspan="2">17. Description of real estate:<br />
                        <asp:TextBox ID="txtAD_Real_Estate" runat="server" TextMode="Multiline" Rows="12" Columns="40" /><br />
                    </td>
                </tr>
                <tr>
                    <td valign="top" align="left">16. Name and address of a Record Owner of above-described real estate (If Debtor does not have a record interest)<br />
                        <asp:TextBox ID="txtAD_Record_Owner" runat="server" TextMode="Multiline" Rows="5" Columns="40" /><br />
                    </td>
                </tr>
            </table>
            <table cellpadding="2" cellspacing="0" border="1" style="font-size: 8pt; width: 775px;">
                <tr>
                    <td colspan="8" align="left">18. Miscellaneous<br />
                        <asp:TextBox ID="txtAD_Misc" runat="server" TextMode="Multiline" Rows="2" Columns="65" />
                    </td>
                </tr>
            </table>
        </asp:Panel>
        <table cellpadding="2" cellspacing="0" border="1" style="font-size: 8pt; width: 775px;">
            <tr>
                <td colspan="8" align="left">
                    <asp:CheckBox ID="chkShowUCC3ap" runat="server" Text="Show / Hide Additional Parties" AutoPostBack="true" /></td>
            </tr>
        </table>
        <asp:Panel runat="server" ID="pnlUCC3ap" Visible="false">
            <table cellpadding="2" cellspacing="0" border="1" style="font-size: 8pt; width: 775px;">
                <tr>
                    <td colspan="8" align="left">
                        <telerik:RadComboBox ID="rcbDebtor2" runat="server" EmptyMessage="Lookup Additional Debtor." Visible="true" DataTextField="disp_name" DataValueField="key_name"
                            EnableLoadOnDemand="True" ShowMoreResultsBox="true" EnableVirtualScrolling="true" Width="300px" OnItemsRequested="rcbDebtor2_ItemsRequested" AutoPostBack="true">
                        </telerik:RadComboBox>
                    </td>
                </tr>
                <tr>
                    <td colspan="8" align="left">21. Additional Debtor's Exact Full Legal Name - insert only <u>one</u> debtor name (21a or 21b) - do not abbreviate or combine names<br />
                        <asp:CheckBox ID="chkDebtor2_RunSearch" runat="server" Text="Run Search for this Debtor" Visible="false" AutoPostBack="true" />
                    </td>
                </tr>
                <tr runat="server" id="trSearch4" visible="false">
                    <td colspan="1" valign="middle" style="width: 21px;">&nbsp;</td>
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
                        <asp:TextBox Visible="false" ID="txtAdditional2" runat="server" Style="width: 210px;" />
                    </td>
                </tr>
                <tr>
                    <td colspan="1" rowspan="2" valign="middle" style="width: 21px;">OR</td>
                    <td colspan="7" align="left">21a. Organization's Name<br />
                        <asp:TextBox ID="txtDebtor2_Org_Name" runat="server" Style="width: 500px;"></asp:TextBox></td>
                </tr>
                <tr>
                    <td colspan="3" align="left">21b. Individual's Last Name<br />
                        <asp:TextBox ID="txtDebtor2_Ind_Last_Name" runat="server" Style="width: 200px;"></asp:TextBox></td>
                    <td align="left">First Name<br />
                        <asp:TextBox ID="txtDebtor2_Ind_First_Name" runat="server" Style="width: 100px;"></asp:TextBox></td>
                    <td colspan="2" align="left">Additional Name(s)/Initial(s)<br />
                        <asp:TextBox ID="txtDebtor2_Ind_Middle_Name" runat="server" Style="width: 75px;"></asp:TextBox></td>
                    <td align="left">Suffix<br />
                        <asp:TextBox ID="txtDebtor2_Ind_Suffix" runat="server" Style="width: 50px;"></asp:TextBox></td>
                </tr>
                <tr>
                    <td colspan="4" align="left">21c. Mailing Address<br />
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
                    <td colspan="2" align="left">17d. See Instructions<br />
                        <asp:TextBox ID="txtDebtor2_d1" runat="server" Style="width: 75px;"></asp:TextBox></td>
                    <td>Addl Info Re Org Debtor</td>
                    <td align="left">17e. Type of Organization<br />
                        <asp:DropDownList ID="lstDebtor2_Org_Type" runat="server"></asp:DropDownList></td>
                    <td align="left">17f. Jurisdiction Organization<br />
                        <asp:DropDownList ID="lstDebtor2_Org_Jurisdiction" runat="server"></asp:DropDownList></td>
                    <td colspan="3" align="left">17g. Organization ID #, if any<br />
                        <asp:TextBox ID="txtDebtor2_Org_ID" runat="server" Style="width: 75px;"></asp:TextBox>&nbsp;
              <asp:CheckBox ID="chkDebtor2_Org_ID_None" runat="server" Text="None" />
                    </td>
                </tr>
            </table>
            <table cellpadding="2" cellspacing="0" border="1" style="font-size: 8pt; width: 775px;">
                <tr>
                    <td colspan="8" align="left">
                        <telerik:RadComboBox ID="rcbDebtor3" runat="server" EmptyMessage="Lookup Additional Debtor." Visible="true" DataTextField="disp_name" DataValueField="key_name"
                            EnableLoadOnDemand="True" ShowMoreResultsBox="true" EnableVirtualScrolling="true" Width="300px" OnItemsRequested="rcbDebtor3_ItemsRequested" AutoPostBack="true">
                        </telerik:RadComboBox>
                    </td>
                </tr>
                <tr>
                    <td colspan="8" align="left">22. Additional Debtor's Exact Full Legal Name - insert only <u>one</u> debtor name (22a or 22b) - do not abbreviate or combine names<br />
                        <asp:CheckBox ID="chkDebtor3_RunSearch" runat="server" Text="Run Search for this Debtor" Visible="false" AutoPostBack="true" />
                    </td>
                </tr>
                <tr runat="server" id="trSearch5" visible="false">
                    <td colspan="1" valign="middle" style="width: 21px;">&nbsp;</td>
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
                        <asp:TextBox Visible="false" ID="txtAdditional3" runat="server" Style="width: 210px;" />
                    </td>
                </tr>
                <tr>
                    <td colspan="1" rowspan="2" valign="middle" style="width: 21px;">OR</td>
                    <td colspan="7" align="left">22a. Organization's Name<br />
                        <asp:TextBox ID="txtDebtor3_Org_Name" runat="server" Style="width: 500px;"></asp:TextBox></td>
                </tr>
                <tr>
                    <td colspan="3" align="left">22b. Individual's Last Name<br />
                        <asp:TextBox ID="txtDebtor3_Ind_Last_Name" runat="server" Style="width: 200px;"></asp:TextBox></td>
                    <td align="left">First Name<br />
                        <asp:TextBox ID="txtDebtor3_Ind_First_Name" runat="server" Style="width: 100px;"></asp:TextBox></td>
                    <td colspan="2" align="left">Additional Name(s)/Initial(s)<br />
                        <asp:TextBox ID="txtDebtor3_Ind_Middle_Name" runat="server" Style="width: 75px;"></asp:TextBox></td>
                    <td align="left">Suffix<br />
                        <asp:TextBox ID="txtDebtor3_Ind_Suffix" runat="server" Style="width: 50px;"></asp:TextBox></td>
                </tr>
                <tr>
                    <td colspan="4" align="left">22c. Mailing Address<br />
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
                    <td colspan="2" align="left">18d. See Instructions<br />
                        <asp:TextBox ID="txtDebtor3_d1" runat="server" Style="width: 75px;"></asp:TextBox></td>
                    <td>Addl Info Re Org Debtor</td>
                    <td align="left">18e. Type of Organization<br />
                        <asp:DropDownList ID="lstDebtor3_Org_Type" runat="server"></asp:DropDownList></td>
                    <td align="left">18f. Jurisdiction Organization<br />
                        <asp:DropDownList ID="lstDebtor3_Org_Jurisdiction" runat="server"></asp:DropDownList></td>
                    <td colspan="3" align="left">18g. Organization ID #, if any<br />
                        <asp:TextBox ID="txtDebtor3_Org_ID" runat="server" Style="width: 75px;"></asp:TextBox>&nbsp;
              <asp:CheckBox ID="chkDebtor3_Org_ID_None" runat="server" Text="None" />
                    </td>
                </tr>
            </table>
            <table cellpadding="2" cellspacing="0" border="1" style="font-size: 8pt; width: 775px;">
                <tr>
                    <td colspan="8" align="left">
                        <telerik:RadComboBox ID="rcbDebtor4" runat="server" EmptyMessage="Lookup Additional Debtor." Visible="true" DataTextField="disp_name" DataValueField="key_name"
                            EnableLoadOnDemand="True" ShowMoreResultsBox="true" EnableVirtualScrolling="true" Width="300px" OnItemsRequested="rcbDebtor4_ItemsRequested" AutoPostBack="true">
                        </telerik:RadComboBox>
                    </td>
                </tr>
                <tr>
                    <td colspan="8" align="left">23. Additional Debtor's Exact Full Legal Name - insert only <u>one</u> debtor name (23a or 23b) - do not abbreviate or combine names<br />
                        <asp:CheckBox ID="chkDebtor4_RunSearch" runat="server" Text="Run Search for this Debtor" Visible="false" AutoPostBack="true" />
                    </td>
                </tr>
                <tr runat="server" id="trSearch6" visible="false">
                    <td colspan="1" valign="middle" style="width: 21px;">&nbsp;</td>
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
                        <asp:TextBox Visible="false" ID="txtAdditional4" runat="server" Style="width: 210px;" />
                    </td>
                </tr>
                <tr>
                    <td colspan="1" rowspan="2" valign="middle" style="width: 21px;">OR</td>
                    <td colspan="7" align="left">23a. Organization's Name<br />
                        <asp:TextBox ID="txtDebtor4_Org_Name" runat="server" Style="width: 500px;"></asp:TextBox></td>
                </tr>
                <tr>
                    <td colspan="3" align="left">23b. Individual's Last Name<br />
                        <asp:TextBox ID="txtDebtor4_Ind_Last_Name" runat="server" Style="width: 200px;"></asp:TextBox></td>
                    <td align="left">First Name<br />
                        <asp:TextBox ID="txtDebtor4_Ind_First_Name" runat="server" Style="width: 100px;"></asp:TextBox></td>
                    <td colspan="2" align="left">Additional Name(s)/Initial(s)<br />
                        <asp:TextBox ID="txtDebtor4_Ind_Middle_Name" runat="server" Style="width: 75px;"></asp:TextBox></td>
                    <td align="left">Suffix<br />
                        <asp:TextBox ID="txtDebtor4_Ind_Suffix" runat="server" Style="width: 50px;"></asp:TextBox></td>
                </tr>
                <tr>
                    <td colspan="4" align="left">23c. Mailing Address<br />
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
                    <td colspan="2" align="left">19d. See Instructions<br />
                        <asp:TextBox ID="txtDebtor4_d1" runat="server" Style="width: 75px;"></asp:TextBox></td>
                    <td>Addl Info Re Org Debtor</td>
                    <td align="left">19e. Type of Organization<br />
                        <asp:DropDownList ID="lstDebtor4_Org_Type" runat="server"></asp:DropDownList></td>
                    <td align="left">19f. Jurisdiction Organization<br />
                        <asp:DropDownList ID="lstDebtor4_Org_Jurisdiction" runat="server"></asp:DropDownList></td>
                    <td colspan="3" align="left">19g. Organization ID #, if any<br />
                        <asp:TextBox ID="txtDebtor4_Org_ID" runat="server" Style="width: 75px;"></asp:TextBox>&nbsp;
              <asp:CheckBox ID="chkDebtor4_Org_ID_None" runat="server" Text="None" />
                    </td>
                </tr>
            </table>
            <table cellpadding="2" cellspacing="0" border="1" style="font-size: 8pt; width: 775px;">
                <tr>
                    <td colspan="8" align="left">24. Secured Party's Name (or Name of Total Assignee or Assignor S/P) - insert only <u>one</u> secured party name (24a or 24b)
                    </td>
                </tr>
                <tr>
                    <td colspan="1" rowspan="1" valign="middle" style="width: 21px;">&nbsp;</td>
                    <td colspan="7" align="left">24a. Organization's Name<br />
                        <asp:DropDownList ID="lstSecured2_Org_Name" runat="server"></asp:DropDownList></td>
                </tr>
                <tr id="Tr3" runat="server" visible="false">
                    <td colspan="3" align="left">24b. Individual's Last Name<br />
                        <asp:TextBox ID="txtSecured2_Ind_Last_Name" runat="server" Style="width: 200px;"></asp:TextBox></td>
                    <td align="left">First Name<br />
                        <asp:TextBox ID="txtSecured2_Ind_First_Name" runat="server" Style="width: 100px;"></asp:TextBox></td>
                    <td colspan="2" align="left">Additional Name(s)/Initial(s)<br />
                        <asp:TextBox ID="txtSecured2_Ind_Middle_Name" runat="server" Style="width: 75px;"></asp:TextBox></td>
                    <td align="left">Suffix<br />
                        <asp:TextBox ID="txtSecured2_Ind_Suffix" runat="server" Style="width: 50px;"></asp:TextBox></td>
                </tr>
                <tr>
                    <td colspan="4" align="left">24c. Mailing Address<br />
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
                    <td colspan="8" align="left">25. Secured Party's Name (or Name of Total Assignee or Assignor S/P) - insert only <u>one</u> secured party name (25a or 25b)
                    </td>
                </tr>
                <tr>
                    <td colspan="1" rowspan="1" valign="middle" style="width: 21px;">&nbsp;</td>
                    <td colspan="7" align="left">25a. Organization's Name<br />
                        <asp:DropDownList ID="lstSecured3_Org_Name" runat="server"></asp:DropDownList></td>
                </tr>
                <tr id="Tr4" runat="server" visible="false">
                    <td colspan="3" align="left">25b. Individual's Last Name<br />
                        <asp:TextBox ID="txtSecured3_Ind_Last_Name" runat="server" Style="width: 200px;"></asp:TextBox></td>
                    <td align="left">First Name<br />
                        <asp:TextBox ID="txtSecured3_Ind_First_Name" runat="server" Style="width: 100px;"></asp:TextBox></td>
                    <td colspan="2" align="left">Additional Name(s)/Initial(s)<br />
                        <asp:TextBox ID="txtSecured3_Ind_Middle_Name" runat="server" Style="width: 75px;"></asp:TextBox></td>
                    <td align="left">Suffix<br />
                        <asp:TextBox ID="txtSecured3_Ind_Suffix" runat="server" Style="width: 50px;"></asp:TextBox></td>
                </tr>
                <tr>
                    <td colspan="4" align="left">25c. Mailing Address<br />
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
                    <td colspan="8" align="left">26. Miscellaneous<br />
                        <asp:TextBox ID="txtAP_Misc" runat="server" TextMode="Multiline" Rows="2" Columns="65" />
                    </td>
                </tr>
            </table>
        </asp:Panel>
        <table cellpadding="2" cellspacing="0" border="1" style="font-size: 8pt; width: 775px;">
            <tr>
                <td colspan="8" align="left">
                    <asp:Button ID="btnSubmit" runat="server" Text="Submit Filing" />
                    <asp:Label ID="lblMsg" runat="server" ForeColor="red" Font-Size="10pt"></asp:Label>
                </td>
            </tr>
        </table>
    </telerik:RadAjaxPanel>
</asp:Content>

