<%@ Page Title="Zogglet.com - The domain of Maggy Maffia &raquo; Manage Change Log" Language="VB" MasterPageFile="~/Master.master" AutoEventWireup="false" CodeFile="ManageChangeLog.aspx.vb" Inherits="ManageChangeLog" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder_Main" Runat="Server">

<h2>Manage Change Log Entries</h2>
                
    <span id="nav_table">
        <asp:Button ID="add_btn" runat="server" Text="Add New Item" CssClass="ButtonStyle" />
    </span>
                
    <table id="admin_table">
        
        <tr>
            <td align="center">
                <h3>Drilldown Options</h3>
                
                <asp:UpdatePanel id="options_updatePnl" runat="server" UpdateMode="Conditional">
                
                    <ContentTemplate>
                        <table class="options_area">
                            <tr>
                                <td>
                                    Category:
                                    <asp:DropDownList ID="category_ddl" runat="server" DataSourceID="category_sds" DataTextField="CategoryTitle" DataValueField="ID" CssClass="InputStyle" AutoPostBack="true" />
                                
                                    <asp:SqlDataSource ID="category_sds" runat="server" ConnectionString="<%$ ConnectionStrings:ProjectConnectionString %>" 
                                        SelectCommand="SELECT ID, CategoryTitle FROM Categories UNION SELECT -1 AS ID, '-- All --' AS CategoryTitle ORDER BY ID" />
                                </td>
                                <td>
                                    Project: 
                                    <asp:DropDownList ID="project_ddl" runat="server" DataTextField="ProjectName" DataValueField="ID" CssClass="InputStyle" AutoPostBack="true" />
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
            <td align="center">
                
                <asp:UpdatePanel ID="items_updatePnl" runat="server" UpdateMode="Conditional">
                
                    <ContentTemplate>

                        <asp:GridView ID="items_gv" runat="server" DataKeyNames="ID, TheDate" AutogenerateColumns="false" GridLines="None" Width="675px"
                            AllowSorting="false" AllowPaging="true" Pagesize="15" HeaderStyle-CssClass="GVHeaderStyle" CssClass="GVStyle">
                            <Columns>
                            
                                <asp:TemplateField ItemStyle-CssClass="GVDateStyle">
                                
                                    <HeaderTemplate>
                                        <asp:LinkButton ID="dateSort_lBtn" runat="server" Text="Date" OnClick="dateSort_click"/>
                                    </HeaderTemplate>
                                    
                                    <ItemTemplate>
                                        <asp:Literal ID="date_lit" runat="server" text='<%#formatDateText(eval("TheDate")) %>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                
                                <asp:TemplateField HeaderText="Project/Changes Made">
                                    <ItemTemplate>
                                    
                                        <asp:CollapsiblePanelExtender ID="projects_cpExt" runat="server" TargetControlID="projectsGV_pnl" CollapsedSize="0" 
                                            Collapsed="true" CollapsedImage="collapsed.png" ExpandedImage="expanded.png" ExpandControlID="cpControl_pnl" 
                                            CollapseControlID="cpControl_pnl" TextLabelID="cpControl_lbl" ImageControlID="cpControl_img" CollapsedText='<%#getNumStats(eval("TheDate"), True) %>' 
                                            ExpandedText='<%#getNumStats(eval("TheDate"), False) %>' />
                                            
                                        <asp:Panel ID="cpControl_pnl" runat="server" CssClass="GVExpandPanelStyle">
                                            <asp:Image ID="cpControl_img" runat="server" ImageUrl="collapsed.png" />
                                            <asp:Label ID="cpControl_lbl" runat="server" Text='<%#getNumStats(eval("TheDate"), True) %>' CssClass="CollapsePanelText" />
                                        </asp:Panel>
                                    
                                        <asp:Panel ID="projectsGV_pnl" runat="server">
                                            <asp:GridView ID="itemsInner_gv" runat="server" Width="575px" DataKeyNames="ID" RowStyle-CssClass="GVInnerItemStyle" GridLines="None" AutoGenerateColumns="false"
                                                HeaderStyle-CssClass="GVInnerHeaderStyle" AllowPaging="false" OnSelectedIndexChanged="innerGVSelectedIndexChanged">
                                                <Columns>
                                                
                                                    <asp:TemplateField ItemStyle-CssClass="GVInnerButtonItemStyle">
                                                    
                                                        <HeaderTemplate>
                                                            <asp:LinkButton ID="projSort_lBtn" runat="server" Text="Project" OnClick="projectSort_click" />
                                                        </HeaderTemplate>
                                                        
                                                        <ItemTemplate>
                                                            <asp:LinkButton id="innerProj_lBtn" runat="server" text='<%#Eval("ProjectName") %>' CommandName="Select" />
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                             
                                                    <asp:TemplateField HeaderText="Changes Made">
                                                        <ItemTemplate>
                                                            <asp:Label ID="itemContent_lbl" runat="server" Text='<%#formatItemContent(eval("ItemContent")) %>' />
                                                            
                                                            <asp:HoverMenuExtender ID="content_hmExt" runat="server" TargetControlID="itemContent_lbl" PopupControlID="tooltip_pnl" 
                                                                PopupPosition="Right" OffsetX="-100" OffsetY="1" HoverDelay="0" />
                                                                
                                                            <asp:Panel ID="tooltip_pnl" runat="server" CssClass="InnerTooltipStyle" Visible='<%#isTooltipVisible(eval("ItemContent")) %>' >
                                                                <asp:Literal ID="tooltip_lit" runat="server" Text='<%#formatTooltipText(eval("TheDate"), eval("ItemContent"))%>' />
                                                            </asp:Panel>
                                                            
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                </Columns>
                                            </asp:GridView>
                                            
                                        </asp:Panel>
                                        
                                    
                                    </ItemTemplate>
                                </asp:TemplateField>
                                
                                

                            </Columns>
                                
                        </asp:GridView>
                        
                        <asp:Literal ID="noData_lit" runat="server" />
                    </ContentTemplate>
                    
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="category_ddl" EventName="SelectedIndexChanged" />
                        <asp:AsyncPostBackTrigger ControlID="project_ddl" EventName="SelectedIndexChanged" />
                        <asp:AsyncPostBackTrigger ControlID="items_gv" EventName="Sorted" />
                        <asp:AsyncPostBackTrigger ControlID="items_gv" EventName="Sorting" />
                        <asp:AsyncPostBackTrigger ControlID="items_gv" EventName="PageIndexChanging" />
                        <asp:AsyncPostBackTrigger ControlID="items_gv" EventName="PageIndexChanged" />
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

