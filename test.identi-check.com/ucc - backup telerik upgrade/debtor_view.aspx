<%@ Page Title="UCC - View Debtor" Language="VB" MasterPageFile="~/Main.master" AutoEventWireup="false" CodeFile="debtor_view.aspx.vb" Inherits="debtor_view" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headA" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
  <telerik:RadAjaxLoadingPanel runat="server" ID="RadAjaxLoadingPanel1" />
  <telerik:RadAjaxPanel ID="rapOne" runat="server" LoadingPanelID="RadAjaxLoadingPanel1">
    
  </telerik:RadAjaxPanel>
</asp:Content>

