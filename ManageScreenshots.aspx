<%@ Page Title="Zogglet.com - The domain of Maggy Maffia &raquo; Manage Screenshots" Language="VB" MasterPageFile="~/Master.master" AutoEventWireup="false" CodeFile="ManageScreenshots.aspx.vb" Inherits="ManageScreenshots" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder_Main" Runat="Server">

    <h2>Manage Screenshots</h2>
    
    <span id="nav_table">
        <asp:Button ID="add_btn" runat="server" Text="Add New Screenshot" CssClass="ButtonStyle" />
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
                                    
                                    <asp:SqlDataSource ID="category_sds" runat="server" ConnectionString="<%$Connectionstrings:ProjectConnectionString %>"
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
                
                <asp:UpdatePanel ID="images_updatePnl" runat="server" UpdateMode="Conditional">
                    
                    <ContentTemplate>
                    
                        <asp:GridView ID="images_gv" runat="server" AutogenerateColumns="false" GridLines="None" Width="675px" DataKeyNames="ID"
                            AllowSorting="true" AllowPaging="true" Pagesize="15" HeaderStyle-CssClass="GVHeaderStyle" CssClass="GVStyle">
                            <Columns>
                                <asp:TemplateField HeaderText="Image" SortExpression="ImageTitle" ItemStyle-CssClass="GVButtonItemStyle">
                                    <ItemTemplate>
                                        <asp:LinkButton id="image_lBtn" runat="server" CommandName="Select" Text='<%#formatImage(eval("ID"), eval("ImageTitle"), eval("Resized"))%>' />

                                        <asp:HoverMenuExtender ID="img_hmExt" runat="server" TargetControlID="image_lBtn" PopupControlID="img_pnl" PopupPosition="Right" 
                                            OffsetX="-7" OffsetY="-3" HoverDelay="0" />
                                        
                                        <asp:Panel ID="img_pnl" runat="server" CssClass="ImageStyle" >
                                            <asp:Image ID="gv_img" runat="server" ImageUrl='<%# Eval("ID", "DisplayImage.aspx?ID={0}") %>' Width="150px" />
                                        </asp:Panel>
                                        
                                    </ItemTemplate>
                                </asp:TemplateField>
                                
                                <asp:TemplateField HeaderText="Caption">
                                    <ItemTemplate>
                                        <asp:Label ID="caption_lbl" runat="server" Text='<%#formatCaption(eval("Caption")) %>' CssClass="GVCaptionStyle" />

                                        <asp:HoverMenuExtender ID="content_hmExt" runat="server" TargetControlID="caption_lbl" PopupControlID="tooltip_pnl" 
                                            PopupPosition="Right" OffsetX="-100" OffsetY="1" HoverDelay="0" />
                                            
                                        <asp:Panel ID="tooltip_pnl" runat="server" CssClass="InnerTooltipStyle" Visible='<%#isTooltipVisible(eval("Caption")) %>' >
                                            <asp:Literal ID="tooltip_lit" runat="server" Text='<%#formatTooltipText(eval("ProjectName"), eval("Caption"))%>' />
                                        </asp:Panel>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                
                                <asp:BoundField DataField="ProjectName" HeaderText="Project" SortExpression="ProjectName" />
                            </Columns>
                        </asp:GridView>
                        
                        <asp:Literal ID="noData_lit" runat="server" />
                        
                    </ContentTemplate>
                    
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="category_ddl" EventName="SelectedIndexChanged" />
                        <asp:AsyncPostBackTrigger ControlID="project_ddl" EventName="SelectedIndexChanged" />
                        <asp:AsyncPostBackTrigger ControlID="images_gv" EventName="Sorted" />
                        <asp:AsyncPostBackTrigger ControlID="images_gv" EventName="PageIndexChanging" />
                        <asp:AsyncPostBackTrigger ControlID="images_gv" EventName="PageIndexChanged" />
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
                    
                    <asp:LinkButton ID="ok_lBtn" runat="server" Text="Ok" OnClick="onOkClick" />
                </asp:Panel>
                
            </td>
        </tr>

    </table>

</asp:Content>

