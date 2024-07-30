<%@ Page Title="UCC - Admin Filing" Language="VB" MasterPageFile="~/Main.master" AutoEventWireup="false" CodeFile="admin_filing.aspx.vb" Inherits="admin_filing" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headA" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <table cellpadding="2" cellspacing="0" border="1" style="font-size: 8pt; width: 575px;">
      <tr>
        <td align="center" colspan="8">Admin - Filing View</td>
      </tr>
      <tr>
        <td colspan="8" align="left">
	      1. Debtor's Exact Full Legal Name - insert only <u>one</u> debtor name (1a or 1b) - do not abbreviate or combine names
        </td>
      </tr>
      <tr>
        <td colspan="1" rowspan="2" valign="middle" style="width: 25px;">OR</td>
        <td colspan="7" align="left">1a. Organization's Name<br /><asp:Label ID="txtDebtor1_Org_Name" runat="server" Font-Bold="true"></asp:Label></td>
      </tr>
      <tr>
        <td colspan="3" align="left">1b. Individual's Last Name<br /><asp:Label ID="txtDebtor1_Ind_Last_Name" runat="server" Font-Bold="true"></asp:Label></td>
        <td align="left">First Name<br /><asp:Label ID="txtDebtor1_Ind_First_Name" runat="server" Font-Bold="true"></asp:Label></td>
        <td colspan="2" align="left">Middle Name<br /><asp:Label ID="txtDebtor1_Ind_Middle_Name" runat="server" Font-Bold="true"></asp:Label></td>
        <td align="left">Suffix<br /><asp:Label ID="txtDebtor1_Ind_Suffix" runat="server" Font-Bold="true"></asp:Label></td>
      </tr>
      <tr>
        <td colspan="4" align="left">1c. Mailing Address<br /><asp:Label ID="txtDebtor1_Mailing_Address" runat="server" Font-Bold="true"></asp:Label></td>
        <td align="left">City<br /><asp:Label ID="txtDebtor1_City" runat="server" Font-Bold="true"></asp:Label></td>
        <td align="left">State<br /><asp:Label ID="lstDebtor1_State" runat="server" Font-Bold="true"></asp:Label></td>
        <td align="left">Postal Code<br /><asp:Label ID="txtDebtor1_Zip" runat="server" Font-Bold="true"></asp:Label></td>
        <td align="left">Country<br /><asp:Label ID="txtDebtor1_Country" runat="server" Font-Bold="true"></asp:Label></td>
      </tr>
      <tr>
        <td colspan="2" align="left">1d. See Instructions<br /><asp:Label ID="txtDebtor1_d1" runat="server" Font-Bold="true"></asp:Label></td>
        <td>Addl Info Re Org Debtor</td>
        <td align="left">1e. Type of Organization<br /><asp:Label ID="txtDebtor1_Org_Type" runat="server" Font-Bold="true"></asp:Label></td>
        <td align="left">1f. Jurisdiction Organization<br /><asp:Label ID="txtDebtor1_Org_Jurisdiction" runat="server" Font-Bold="true"></asp:Label></td>
        <td colspan="3" align="left">
	      1g. Organization ID #, if any<br />
	      <asp:Label ID="txtDebtor1_Org_ID" runat="server" Font-Bold="true"></asp:Label>&nbsp;
	      <asp:Label ID="chkDebtor1_Org_ID_None" runat="server" Text="None" Font-Bold="true" />
        </td>
      </tr>
      </table>
      <table cellpadding="2" cellspacing="0" border="1" style="font-size: 8pt; width: 575px;">
      <tr>
        <td colspan="8" align="left">
	      2. Debtor's Exact Full Legal Name - insert only <u>one</u> debtor name (2a or 2b) - do not abbreviate or combine names
        </td>
      </tr>
      <tr>
        <td colspan="1" rowspan="2" valign="middle" style="width: 25px;">OR</td>
        <td colspan="7" align="left">2a. Organization's Name<br /><asp:Label ID="txtDebtor2_Org_Name" runat="server" Font-Bold="true"></asp:Label></td>
      </tr>
      <tr>
        <td colspan="3" align="left">2b. Individual's Last Name<br /><asp:Label ID="txtDebtor2_Ind_Last_Name" runat="server" Font-Bold="true"></asp:Label></td>
        <td align="left">First Name<br /><asp:Label ID="txtDebtor2_Ind_First_Name" runat="server" Font-Bold="true"></asp:Label></td>
        <td colspan="2" align="left">Middle Name<br /><asp:Label ID="txtDebtor2_Ind_Middle_Name" runat="server" Font-Bold="true"></asp:Label></td>
        <td align="left">Suffix<br /><asp:Label ID="txtDebtor2_Ind_Suffix" runat="server" Font-Bold="true"></asp:Label></td>
      </tr>
      <tr>
        <td colspan="4" align="left">2c. Mailing Address<br /><asp:Label ID="txtDebtor2_Mailing_Address" runat="server" Font-Bold="true"></asp:Label></td>
        <td align="left">City<br /><asp:Label ID="txtDebtor2_City" runat="server" Font-Bold="true"></asp:Label></td>
        <td align="left">State<br /><asp:Label ID="lstDebtor2_State" runat="server" Font-Bold="true"></asp:Label></td>
        <td align="left">Postal Code<br /><asp:Label ID="txtDebtor2_Zip" runat="server" Font-Bold="true"></asp:Label></td>
        <td align="left">Country<br /><asp:Label ID="txtDebtor2_Country" runat="server" Font-Bold="true"></asp:Label></td>
      </tr>
      <tr>
        <td colspan="2" align="left">2d. See Instructions<br /><asp:Label ID="txtDebtor2_d1" runat="server" Font-Bold="true"></asp:Label></td>
        <td>Addl Info Re Org Debtor</td>
        <td align="left">2e. Type of Organization<br /><asp:Label ID="txtDebtor2_Org_Type" runat="server" Font-Bold="true"></asp:Label></td>
        <td align="left">2f. Jurisdiction Organization<br /><asp:Label ID="txtDebtor2_Org_Jurisdiction" runat="server" Font-Bold="true"></asp:Label></td>
        <td colspan="3" align="left">
	      2g. Organization ID #, if any<br />
	      <asp:Label ID="txtDebtor2_Org_ID" runat="server" Font-Bold="true"></asp:Label>&nbsp;
	      <asp:CheckBox ID="chkDebtor2_Org_ID_None" runat="server" Font-Bold="true" />
        </td>
      </tr>
      </table>
      <table cellpadding="2" cellspacing="0" border="1" style="font-size: 8pt; width: 575px;">
      <tr>
        <td colspan="8" align="left">3. Secured Party's Name (or Name of Total Assignee or Assignor S/P) - insert only <u>one</u> secured party name (3a or 3b)</td>
      </tr>
      <tr>
        <td colspan="1" rowspan="1" valign="middle">&nbsp;</td>
        <td colspan="7" align="left">3a. Organization's Name<br />
        <asp:label ID="lstSecured_Org_Name" runat="server" Font-Bold="true"></asp:label></td>
      </tr>
      <tr id="Tr1" runat="server" visible = "false">
        <td colspan="3" align="left">3b. Individual's Last Name<br /><asp:Label ID="txtSecured_Ind_Last_Name" runat="server" Font-Bold="true"></asp:Label></td>
        <td align="left">First Name<br /><asp:Label ID="txtSecured_Ind_First_Name" runat="server" Font-Bold="true"></asp:Label></td>
        <td colspan="2" align="left">Middle Name<br /><asp:Label ID="txtSecured_Ind_Middle_Name" runat="server" Font-Bold="true"></asp:Label></td>
        <td align="left">Suffix<br /><asp:Label ID="txtSecured_Ind_Suffix" runat="server" Font-Bold="true"></asp:Label></td>
      </tr>
      <tr>
        <td colspan="4" align="left">3c. Mailing Address<br /><asp:Label ID="txtSecured_Mailing_Address" runat="server" Font-Bold="true"></asp:Label></td>
        <td align="left">City<br /><asp:Label ID="txtSecured_City" runat="server" Font-Bold="true"></asp:Label></td>
        <td align="left">State<br /><asp:Label ID="lstSecured_State" runat="server" Font-Bold="true"></asp:Label></td>
        <td align="left">Postal Code<br /><asp:Label ID="txtSecured_Zip" runat="server" Font-Bold="true"></asp:Label></td>
        <td align="left">Country<br /><asp:Label ID="txtSecured_Country" runat="server" Font-Bold="true"></asp:Label></td>
      </tr>
      </table>
      <table cellpadding="2" cellspacing="0" border="1" style="font-size: 8pt; width: 575px;">
      <tr>
	      <td colspan="8" align="left">
		      4. This Financing Statement covers the following collateral (1200 characters max - use Addendum for additional space)<br />
		      <asp:Label id="txtCollateral" runat="server" Font-Bold="true" />
  	      </td>
      </tr>
      <tr>
        <td colspan="8" align="left">
          Filing Number: <asp:TextBox ID="txtFile_No" runat="server"></asp:TextBox>&nbsp;
          <asp:Label ID="lblViewAttach" runat="server"></asp:Label><br />
          Upload Filing Confirmation: <asp:FileUpload ID="UploadedFile" runat="server" />&nbsp;<br />
          <asp:Button ID="btnUpload" runat="server" Text="Upload and Update" />
        </td>
      </tr>
    </table>
</asp:Content>

