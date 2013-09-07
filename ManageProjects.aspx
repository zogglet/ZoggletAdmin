<%@ Page Title="Zogglet.com - The domain of Maggy Maffia &raquo; Manage Projects" Language="VB" MasterPageFile="~/Master.master" AutoEventWireup="false" CodeFile="ManageProjects.aspx.vb" Inherits="ManageProjects" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder_Main" Runat="Server">

<h2>Manage Projects</h2>

    <span id="nav_table">
        <asp:Button ID="add_btn" runat="server" Text="Add New Project" CssClass="ButtonStyle" />
    </span>
    
    <table id="admin_table">
        <tr>
            <td align="center">
                <h3>Drilldown Options</h3>
                
                <asp:UpdatePanel ID="options_updatePnl" runat="server" UpdateMode="Conditional">
                    
                    <ContentTemplate>
                        <table class="options_area">
                            <tr>
                                <td>
                                    Category: 
                                    <asp:DropDownList ID="category_ddl" runat="server" DataSourceID="category_sds" DataTextField="CategoryTitle" DataValueField="ID" CssClass="InputStyle" AutoPostBack="true" />
                                
                                    <asp:SqlDataSource ID="category_sds" runat="server" ConnectionString="<%$ ConnectionStrings:ProjectConnectionString %>" 
                                        SelectCommand="SELECT ID, CategoryTitle FROM Categories UNION SELECT -1 AS ID, '-- All --' AS CategoryTitle ORDER BY ID" />
                                </td>
                            </tr>
                        </table>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="category_ddl" EventName="SelectedIndexChanged" />
                    </Triggers>    
                </asp:UpdatePanel>
                
                <span class="InnerDivider">&nbsp;</span>
                <br />
                
            </td>
        </tr>
        <tr>
            <td>
                <asp:UpdatePanel ID="projects_updatePnl" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                    
                        <asp:GridView  ID="projects_gv" runat="server" DataKeyNames="ID" AutoGenerateColumns="false" GridLines="None" Width="675px"
                            AllowSorting="true" AllowPaging="true" PageSize="20" RowStyle-CssClass="GVItemStyle" HeaderStyle-CssClass="GVHeaderStyle">
                            <Columns>
                                  <asp:TemplateField HeaderText="Project" SortExpression="ProjectName" ItemStyle-CssClass="GVButtonItemStyle">
                                    <ItemTemplate>
                                        <asp:Linkbutton id="project_lBtn" runat="server" CommandName="Select" Text='<%#eval("ProjectName") %>' />
                                        
                                        <asp:HoverMenuExtender ID="img_hmExt" runat="server" TargetControlID="project_lBtn" PopupControlID="tooltip_pnl" PopupPosition="Right" 
                                            OffsetX="-30" OffsetY="-3" HoverDelay="0" />
                                        
                                        <asp:Panel ID="tooltip_pnl" runat="server" CssClass="TooltipStyle">
                                            <asp:Literal ID="tooltip_lit" runat="server" Text='<%#formatDescription(eval("Description")) %>' />
                                        </asp:Panel>
                                    </ItemTemplate>
                                        
                                  </asp:TemplateField>
                                  
                                <asp:BoundField DataField="CategoryTitle" HeaderText="Category" SortExpression="CategoryTitle" />
                                <asp:BoundField DataField="Language" HeaderText="Language" SortExpression="Language" />
                            </Columns>
                        </asp:GridView>
                        
                        <asp:Literal ID="noData_lit" runat="server" />
                        
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="category_ddl" EventName="SelectedIndexChanged" />
                        <asp:AsyncPostBackTrigger ControlID="projects_gv" EventName="Sorted" />
                    </Triggers>
                </asp:UpdatePanel>
                
               <asp:ModalPopupExtender ID="deleted_mpExt" runat="server" TargetControlID="dummy" PopupControlID="deleted_pnl" />
               <input type="button" id="dummy" runat="server" style="display: none;" />
               
               <asp:Panel ID="deleted_pnl" runat="server" CssClass="ModalStyle" Width="375px">
                    <asp:UpdatePanel ID="deleted_updatePnl" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <asp:Literal ID="deleted_lit" runat="server" />
                        </ContentTemplate>
                        
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="ok_lBtn" EventName="click" />
                        </Triggers>
                    </asp:UpdatePanel>
                    
                    <br />
                    <asp:LinkButton ID="ok_lBtn" runat="server" Text="Ok" OnClick="onOkClick" />
               </asp:Panel>
               
            </td>
            
        </tr>
        
        
    </table>
</asp:Content>

