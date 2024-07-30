<%@ Page Title="" Language="VB" MasterPageFile="~/Main.master" AutoEventWireup="false" CodeFile="ucc11.aspx.vb" Inherits="ucc11" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headA" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
  <telerik:RadAjaxLoadingPanel runat="server" ID="RadAjaxLoadingPanel1" />
  <telerik:RadAjaxPanel ID="rapOne" runat="server" LoadingPanelID="RadAjaxLoadingPanel1">
    <table cellpadding="2" cellspacing="0" border="1" style="font-size: 8pt; width: 800px;">

         <%--new ucc loan type--%>
            <tr>
                <td colspan="8">Loan Service Type<br />
                    Type:
                    <asp:DropDownList ID="ddlLoanType" runat="server">
                        <asp:ListItem Value="0">Select One</asp:ListItem>
                        <asp:ListItem Value="FSFL">Farm Storage Facility Loan</asp:ListItem>
                        <asp:ListItem Value="MAL">Market Assistance Loan</asp:ListItem>
                        <asp:ListItem Value="FLP">Farm Loan Program </asp:ListItem>
                    </asp:DropDownList><asp:RequiredFieldValidator runat="server" ErrorMessage="You must select a loan type." ControlToValidate="ddlLoanType" InitialValue="0" ForeColor="red"></asp:RequiredFieldValidator>
                </td>
            </tr>
      <tr>
      <td colspan="8">
      What state was the corporation organized in?<br />
      State: <asp:DropDownList ID="lstOrg_State" runat="server"></asp:DropDownList>
      </td>
      </tr>

      <tr>
        <td colspan="8" align="left">
          <telerik:RadComboBox ID="rcbDebtor1" runat="server" EmptyMessage="Lookup Debtor." Visible="true" DataTextField="disp_name" DataValueField="key_name"
            EnableLoadOnDemand="True" ShowMoreResultsBox="true" EnableVirtualScrolling="true" Width="300px" OnItemsRequested="rcbDebtor1_ItemsRequested" AutoPostBack="true" >
          </telerik:RadComboBox>
          <!--<a href="View_UCC11.aspx?id=1" target="_blank">UCC11</a>-->
        </td>
      </tr>
      <tr>
        <td colspan="8" align="left">
          1. Debtor Name to be searched - insert only <u>one</u> debtor name (1a or 1b) - do not abbreviate or combine names
        </td>
      </tr>
      <tr>
        <td colspan="1" rowspan="2" valign="middle" style="width: 25px;">OR</td>
        <td colspan="7" align="left">1a. Organization's Name<br /><asp:TextBox ID="txtDebtor1_Org_Name" runat="server" style="width: 500px;"></asp:TextBox></td>
      </tr>
      <tr>
        <td colspan="3" align="left">1b. Individual's Last Name<br /><asp:TextBox ID="txtDebtor1_Ind_Last_Name" runat="server" style="width: 200px;"></asp:TextBox></td>
        <td align="left">First Name<br /><asp:TextBox ID="txtDebtor1_Ind_First_Name" runat="server" style="width: 100px;"></asp:TextBox></td>
        <td colspan="2" align="left">Additional Name(s)/Initial(s)<br /><asp:TextBox ID="txtDebtor1_Ind_Middle_Name" runat="server" style="width: 75px;"></asp:TextBox></td>
        <td align="left">Suffix<br /><asp:TextBox ID="txtDebtor1_Ind_Suffix" runat="server" style="width: 50px;"></asp:TextBox></td>
      </tr>
    </table>
    <table cellpadding="2" cellspacing="0" border="1" style="font-size: 8pt; width: 800px;">
      <tr>
        <td colspan="3" align="left">
          2. Information Options relating to UCC filings and other notices on file in the filing office that include as a Debtor name the name identified in item 1.
        </td>
      </tr>
      <tr>
        <td rowspan="5" style="width: 25px;">&nbsp;</td>
        <td align="left" valign="top" colspan="2">
          2a. Search Response <asp:CheckBox ID="chkSR_Certified" runat="server" Text="Certified" Visible="false" />
        </td>
      </tr>
      <tr>
        <td style="width: 25px;">&nbsp;</td>
        <td align="left">
          Select <u>one</u> of the following two options: 
          <asp:CheckBox ID="chkSR_All" runat="server" Checked="true" Text="All (Check this box to request a response that is complete, including filings that have lapsed.)" />
          <asp:CheckBox ID="chkSR_Unlapsed" runat="server" Text="Unlapsed" />
        </td>
      </tr>
      <tr>
        <td align="left" valign="top" colspan="2">
          2b. Copy Request <asp:CheckBox ID="chkCR_Certified" runat="server" Text="Certified" Visible="false" />
        </td>
      </tr>
      <tr>
        <td style="width: 25px;">&nbsp;</td>
        <td align="left">
          Select <u>one</u> of the following two options: 
          <asp:CheckBox ID="chkCR_All" runat="server" Text="All" />
          <asp:CheckBox ID="chkCR_Unlapsed" runat="server"  Checked="true" Text="Unlapsed" />
        </td>
      </tr>
      <tr runat="server" visible="true">
        <td align="left" valign="top" colspan="2">
          <!--2c. Specified Copies Only --><asp:CheckBox ID="chkSCO_Certified" runat="server" Text="Certified" Visible="false" />
        </td>
      </tr>
      <tr>
        <td style="width: 25px;">&nbsp;</td>
        <td style="width: 25px;">&nbsp;</td>
        <td align="left" colspan="1">
          <table cellpadding="2" cellspacing="0" border="1" style="font-size: 8pt; width: 500px;">
            <tr>
              <td>Search After Date<!--Record Number--></td>
              <td>City, State<!--Date Record Filed (if required)--></td>
              <td>Name Variations<!--Type of Record and Additional Identifying Information (if required)--></td>
              <td>Notes</td>
            </tr>
            <tr>
              <td><asp:TextBox ID="txtMoreDate" runat="server" style="width: 75px;" maxlength="10"></asp:TextBox></td>
              <td><asp:TextBox ID="txtMoreAddress" runat="server" style="width: 175px;" maxlength="200"></asp:TextBox></td>
              <td><asp:TextBox ID="txtMoreName" runat="server" style="width: 175px;" maxlength="200"></asp:TextBox></td>
              <td><asp:TextBox ID="txtMoreOther" runat="server" style="width: 175px;" maxlength="200"></asp:TextBox></td>
            </tr>
            <tr runat="server" visible="false">
              <td><asp:TextBox ID="txtSCO_RN1" runat="server" style="width: 100px;"></asp:TextBox></td>
              <td><asp:TextBox ID="txtSCO_DRF1" runat="server" style="width: 100px;"></asp:TextBox></td>
              <td><asp:TextBox ID="txtSCO_Type1" runat="server" style="width: 250px;"></asp:TextBox></td>
            </tr>
            <tr runat="server" visible="false">
	            <td><asp:TextBox ID="txtSCO_RN2" runat="server" style="width: 100px;"></asp:TextBox></td>
	            <td><asp:TextBox ID="txtSCO_DRF2" runat="server" style="width: 100px;"></asp:TextBox></td>
	            <td><asp:TextBox ID="txtSCO_Type2" runat="server" style="width: 250px;"></asp:TextBox></td>
            </tr>
            <tr runat="server" visible="false">
	            <td><asp:TextBox ID="txtSCO_RN3" runat="server" style="width: 100px;"></asp:TextBox></td>
	            <td><asp:TextBox ID="txtSCO_DRF3" runat="server" style="width: 100px;"></asp:TextBox></td>
	            <td><asp:TextBox ID="txtSCO_Type3" runat="server" style="width: 250px;"></asp:TextBox></td>
            </tr>
            <tr runat="server" visible="false">
	            <td><asp:TextBox ID="txtSCO_RN4" runat="server" style="width: 100px;"></asp:TextBox></td>
	            <td><asp:TextBox ID="txtSCO_DRF4" runat="server" style="width: 100px;"></asp:TextBox></td>
	            <td><asp:TextBox ID="txtSCO_Type4" runat="server" style="width: 250px;"></asp:TextBox></td>
            </tr>
            <tr runat="server" visible="false">
	            <td><asp:TextBox ID="txtSCO_RN5" runat="server" style="width: 100px;"></asp:TextBox></td>
	            <td><asp:TextBox ID="txtSCO_DRF5" runat="server" style="width: 100px;"></asp:TextBox></td>
	            <td><asp:TextBox ID="txtSCO_Type5" runat="server" style="width: 250px;"></asp:TextBox></td>
            </tr>
            <tr runat="server" visible="false">
	            <td><asp:TextBox ID="txtSCO_RN6" runat="server" style="width: 100px;"></asp:TextBox></td>
	            <td><asp:TextBox ID="txtSCO_DRF6" runat="server" style="width: 100px;"></asp:TextBox></td>
	            <td><asp:TextBox ID="txtSCO_Type6" runat="server" style="width: 250px;"></asp:TextBox></td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
    <table cellpadding="2" cellspacing="0" border="1" style="font-size: 8pt; width: 800px;" runat="server" visible="false">
      <tr>
        <td colspan="2" align="left">
          3. Additional Services
        </td>
      </tr>
      <tr>
        <td style="width: 25px;">&nbsp;</td>
        <td align="left">
          <asp:textbox id="txtAdditional" runat="server" textmode="Multiline" rows="7" columns="80" />
        </td>
      </tr>
    </table>
    <table cellpadding="2" cellspacing="0" border="1" style="font-size: 8pt; width: 800px;">
      <tr>
        <td colspan="8" align="left">
          <asp:Button ID="btnSubmit" runat="server" Text="Submit Search" />
          <asp:Button ID="btnSubmitStay" runat="server" Text="Submit Search and Add Spouse" />
          <asp:Label ID="lblMsg" runat="server" ForeColor="red"></asp:Label>
        </td>
      </tr>
    </table>
  </telerik:RadAjaxPanel>
</asp:Content>

