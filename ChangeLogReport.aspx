<%@ Page Title="Zogglet.com - The domain of Maggy Maffia &raquo; Change Log Report" Language="VB" MasterPageFile="~/Master.master" AutoEventWireup="false" Async="true" CodeFile="ChangeLogReport.aspx.vb" Inherits="ChangeLogReport" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=9.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="mag" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder_Main" Runat="Server">

    <h2>Generate Change Log Report</h2>
    
    <span id="nav_table">
        <asp:LinkButton ID="list_lBtn" runat="server" Text="Return to Change Log" CausesValidation="false" />
    </span>
    
    <table id="admin_table">
        <tr>
            <td align="center">
            
                <h3>Generate Report</h3>

                <div class="options_area">
                    View Report: 
                    <asp:DropDownList ID="report_ddl" runat="server" CssClass="InputStyle" AutoPostBack="true">
                        <asp:ListItem Text="&laquo; Select Report &raquo;" Value="-1" />
                        <asp:ListItem Text="Listed Changes by Week" Value="ChangesByWeek" />
                        <asp:ListItem Text="Total Changes by Week, by Category" Value="ChangesByWeekByCategory" />
                    </asp:DropDownList>
                    
                     <asp:CompareValidator ID="report_cVal" runat="server" Operator="NotEqual" ValueToCompare="-1" Display="None" 
                        ControlToValidate="report_ddl" ErrorMessage="Select a freakin' report." />
                    <asp:ValidatorCalloutExtender ID="report_vcExt" runat="server" TargetControlID="report_cVal" WarningIconImageUrl="warningIcon.png"
                        CloseImageUrl="closeIcon.png" CssClass="ValidatorCalloutStyle" />
                    
                </div>
                
                <span class="InnerDivider">&nbsp;</span>
                <br />
            
                <mag:ReportViewer ID="changeLog_rv" runat="server" Height="100%" BackColor="#2d291e" ForeColor="#9c9172"
                    SizeToReportContent="true" AsyncRendering="false" ProcessingMode="Remote" CssClass="ReportViewerStyle"  />

    
            </td>
        </tr>
    </table>

</asp:Content>

