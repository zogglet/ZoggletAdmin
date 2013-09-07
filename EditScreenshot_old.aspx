<%@ Page Title="Zogglet.com - The domain of Maggy Maffia &raquo; Edit Screenshot" Language="VB" MasterPageFile="~/Master.master" AutoEventWireup="false" CodeFile="EditScreenshot_old.aspx.vb" Inherits="EditScreenshot_old" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder_Main" Runat="Server">

    <h2>Edit Screenshot</h2>
    
    <span id="nav_table">
        <asp:LinkButton ID="list_lBtn" runat="server" Text="Return to Screenshot List" CausesValidation="false" />
    </span>
    
    <table id="admin_table">
        <tr>
            <td align="center">
            
                <h3>Add/Edit Screenshot</h3>
                    
                        <asp:FormView ID="image_fv" runat="server" DataKeyNames="ID" DataSourceID="image_sds">
                            
                            <HeaderTemplate>
                                <table class="FormviewTbl">
                            </HeaderTemplate>
                            
                            <EditItemTemplate>
                                    <tr>
                                        <td colspan="2">
                                            <asp:UpdatePanel ID="images_updatePnl" runat="server" UpdateMode="Conditional">
                                                <ContentTemplate>
                                            <table class="options_area">
                                                <tr>
                                                    <td>
                                                        Category:
                                                        <br />
                                                        <asp:DropDownList ID="category_ddl" DataSourceID="category_sds" runat="server" DataTextField="CategoryTitle" DataValueField="ID" 
                                                            CssClass="InputStyle" SelectedValue='<%#Bind("CategoryID") %>' AutoPostBack="true" />
                                                            
                                                        <asp:CompareValidator ID="category_cVal" runat="server" Operator="NotEqual" ValueToCompare="-1" Display="None" 
                                                            ControlToValidate="category_ddl" ErrorMessage="Select a freakin' category." />
                                                        <asp:ValidatorCalloutExtender ID="category_vcExt" runat="server" TargetControlID="category_cVal" WarningIconImageUrl="warningIcon.png"
                                                            CloseImageUrl="closeIcon.png" CssClass="ValidatorCalloutStyle" />
                                                    </td>
                                                    <td>
                                                        Project:
                                                        <br />
                                                        <asp:DropDownList ID="project_ddl" DataSourceID="project_sds" runat="server" DataTextField="ProjectName" DataValueField="ID"   
                                                            CssClass="InputStyle" OnLoad="onEditProjectDDLLoad" />
                                                        
                                                        <%--Need individual (not global) SDS' for projects in order to use the ControlParameter--%>
                                                        <asp:SqlDataSource ID="project_sds" runat="server" ConnectionString="<%$ ConnectionStrings:ProjectConnectionString %>" 
                                                            SelectCommand="SELECT ID, ProjectName, CategoryID FROM Projects WHERE CategoryID = @CategoryID UNION SELECT -1 AS ID, '-- Select Project --' AS ProjectName, -1 AS CategoryID ORDER BY ID">
                                                        
                                                            <SelectParameters>
                                                                <asp:ControlParameter ControlID="category_ddl" PropertyName="SelectedValue" Name="CategoryID" Type="Int32" DefaultValue="-1" />
                                                            </SelectParameters>
                                                        </asp:SqlDataSource>
                                                        
                                                        <asp:CompareValidator ID="project_cVal" runat="server" Operator="NotEqual" ValueToCompare="-1" Display="None" 
                                                            ControlToValidate="project_ddl" ErrorMessage="Select a freakin' project." />
                                                        <asp:ValidatorCalloutExtender ID="project_vcExt" runat="server" TargetControlID="project_cVal" WarningIconImageUrl="warningIcon.png"
                                                            CloseImageUrl="closeIcon.png" CssClass="ValidatorCalloutStyle" />

                                                    </td>
                                                </tr>
                                            </table>
                                        </ContentTemplate>
                                        
                                        <Triggers>
                                            <asp:AsyncPostBackTrigger ControlID="category_ddl" EventName="SelectedIndexChanged" />
                                        </Triggers>
                                    </asp:UpdatePanel>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <span class="InnerDivider">&nbsp;</span>
                                    <br />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Image:
                                    <asp:HiddenField ID="img_hField" runat="server" value='<%#Bind("Path") %>' />
                                    &nbsp;<asp:Label ID="imgData_lbl" runat="server" CssClass="FormviewLbl" Text='<%#formatImgText(eval("Path"), eval("Resized")) %>' />
                                    <br /><asp:FileUpload ID="img_uploader" runat="server" CssClass="InputStyle" />
                                    
                                    <asp:Panel ID="resize_pnl" runat="server" Visible='<%#isResizeAvailable(eval("Path"), 600) %>'>
                                        <p class="smallNote">The current image can be resized.</p>
                                        <asp:CheckBox ID="resize_cbx" runat="server" Text="Resize &amp; Optimize" />
                                    </asp:Panel>                               
                                </td>
                                <td>
                                    Caption:
                                    &nbsp;<asp:TextBox ID="caption_txt" runat="server" Text='<%#Bind("Caption") %>' CssClass="InputStyle" Width="275px" />
                                </td>
                            </tr>
                            <tr>
                                <td align="right" colspan="2">
                                    <span class="InnerDivider">&nbsp;</span>
                                    <br />
                                    
                                    <asp:Button ID="update_btn" runat="server" CausesValidation="true" CommandName="Update" Text="Update" CssClass="ButtonStyle" />
                                    &nbsp;<asp:Button ID="cancel_btn" runat="server" CausesValidation="false" CommandName="Cancel" Text="Cancel" CssClass="ButtonStyle" />
                                </td>
                            </tr>
                    </EditItemTemplate>
                    
                    <InsertItemTemplate>
                            <tr>
                                <td colspan="2">
                                    <asp:UpdatePanel ID="images_updatePnl" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <table class="options_area">
                                                <tr>
                                                    <td>
                                                        Category:
                                                        &nbsp;<asp:DropDownList ID="insertCategory_ddl" DataSourceID="category_sds" runat="server" DataTextField="CategoryTitle" DataValueField="ID" 
                                                            CssClass="InputStyle" AutoPostBack="true" />
                                                            
                                                        <asp:CompareValidator ID="insertCategory_cVal" runat="server" Operator="NotEqual" ValueToCompare="-1" Display="None" 
                                                            ControlToValidate="insertCategory_ddl" ErrorMessage="Select a freakin' category." />
                                                        <asp:ValidatorCalloutExtender ID="insertCategory_vcExt" runat="server" TargetControlID="insertCategory_cVal" WarningIconImageUrl="warningIcon.png"
                                                            CloseImageUrl="closeIcon.png" CssClass="ValidatorCalloutStyle" />
                                                    </td>
                                                    <td>
                                                        Project:
                                                        &nbsp;<asp:DropDownList ID="insertProject_ddl" DataSourceID="insertProject_sds" runat="server" DataTextField="ProjectName" DataValueField="ID"   
                                                            CssClass="InputStyle" />
                                                        
                                                        <%--Need individual (not global) SDS' for projects in order to use the ControlParameter--%>
                                                        <asp:SqlDataSource ID="insertProject_sds" runat="server" ConnectionString="<%$ ConnectionStrings:ProjectConnectionString %>" 
                                                            SelectCommand="SELECT ID, ProjectName, CategoryID FROM Projects WHERE CategoryID = @CategoryID UNION SELECT -1 AS ID, '-- Select Project --' AS ProjectName, -1 AS CategoryID ORDER BY ID">
                                                        
                                                            <SelectParameters>
                                                                <asp:ControlParameter ControlID="insertCategory_ddl" PropertyName="SelectedValue" Name="CategoryID" Type="Int32" DefaultValue="-1" />
                                                            </SelectParameters>
                                                        </asp:SqlDataSource>
                                                        
                                                        <asp:CompareValidator ID="insertProject_cVal" runat="server" Operator="NotEqual" ValueToCompare="-1" Display="None" 
                                                            ControlToValidate="insertProject_ddl" ErrorMessage="Select a freakin' project." />
                                                        <asp:ValidatorCalloutExtender ID="insertProject_vcExt" runat="server" TargetControlID="insertProject_cVal" WarningIconImageUrl="warningIcon.png"
                                                            CloseImageUrl="closeIcon.png" CssClass="ValidatorCalloutStyle" />

                                                    </td>
                                                </tr>
                                            </table>
                                        </ContentTemplate>
                                        
                                        <Triggers>
                                            <asp:AsyncPostBackTrigger ControlID="insertCategory_ddl" EventName="SelectedIndexChanged" />
                                        </Triggers>
                                    </asp:UpdatePanel>

                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <span class="InnerDivider">&nbsp;</span>
                                    <br />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Image:
                                    <asp:HiddenField ID="img_hField" runat="server" value='<%#Bind("Path") %>' />
                                    &nbsp;<asp:FileUpload ID="img_uploader" runat="server" CssClass="InputStyle" />
                                    
                                    <asp:Panel ID="resize_pnl" runat="server" Visible='<%#isResizeAvailable(eval("Path"), 600) %>'>
                                        <p class="smallNote">If this box is checked, the image will be resized if either dimension is over 600px.</p>
                                        <asp:CheckBox ID="resize_cbx" runat="server" Text="Resize &amp; Optimize" />
                                    </asp:Panel>
                                </td>
                                <td>
                                    Caption:
                                    &nbsp;<asp:TextBox ID="caption_txt" runat="server" Text='<%#Bind("Caption") %>' CssClass="InputStyle" Width="275px" />
                                </td>
                            </tr>
                            <tr>
                                <td align="right" colspan="2">
                                    <span class="InnerDivider">&nbsp;</span>
                                    <br />
                                    
                                    <asp:Button ID="insert_btn" runat="server" CausesValidation="true" CommandName="Insert" Text="Add" CssClass="ButtonStyle" />
                                    &nbsp;<asp:Button ID="cancel_btn" runat="server" CausesValidation="false" CommandName="Cancel" Text="Cancel" CssClass="ButtonStyle" />
                                </td>
                            </tr>
                    </InsertItemTemplate>
                    
                    <ItemTemplate>
                            <tr>
                                <td colspan="2">
                                    <table class="options_area">
                                        <tr>
                                            <td>
                                                Project:
                                                &nbsp;<asp:Label ID="project_lbl" runat="server" Text='<%#eval("ProjectName") %>' CssClass="FormviewLbl" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <span class="InnerDivider">&nbsp;</span>
                                    <br />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Image:
                                    &nbsp;<asp:Label ID="imgData_lbl" runat="server" Text='<%#formatImgText(eval("Path"), eval("Resized")) %>' CssClass="FormviewLbl" />
                                    <br />
                                    <asp:LinkButton ID="showImg_lBtn" runat="server" Text="[View]" OnClick="showImg" />
                                    
                                    
                                    <asp:ModalPopupExtender ID="img_mpExt" runat="server" TargetControlID="dummy" PopupControlID="img_pnl" />
                                    
                                    <input type="button" id="dummy" runat="server" style="display: none;" />
                                    
                                    <asp:Panel ID="img_pnl" runat="server" CssClass="ModalStyle" Width="650px">
                                    
                                        <asp:UpdatePanel ID="img_updatePnl" runat="server" UpdateMode="Conditional">
                                            
                                            <ContentTemplate>
                                                <asp:Panel ID="imgInner_pnl" runat="server" style="overflow:auto;padding:10px;">
                                                    <p><asp:Image ID="screenshot_img" runat="server" ImageUrl='<%# "../screens/" & Eval("Path") %>' BorderColor="#393426" BorderStyle="Solid" BorderWidth="3px" /></p>
                                                </asp:Panel>
                                                
                                                <asp:Literal ID="img_lit" runat="server" />
                                            </ContentTemplate>
                                            
                                            <Triggers>
                                                <asp:AsyncPostBackTrigger ControlID="showImg_lBtn" EventName="click" />
                                                <asp:AsyncPostBackTrigger ControlID="close_lBtn" EventName="click" />
                                            </Triggers>
                                            
                                        </asp:UpdatePanel>
                        
                                        <span>
                                            <asp:LinkButton ID="close_lBtn" runat="server" Text="[Close]" OnClick="onCloseClick" />
                                        </span>
                                        
                                    </asp:Panel>
                                </td>
                                <td>
                                    Caption:
                                    &nbsp;<asp:Label ID="caption_lbl" runat="server" text='<%#formatNullText(eval("Caption")) %>' CssClass="FormviewLbl" Font-Bold="false" Font-Italic="true" />
                                </td>
                            </tr>
                            <tr>
                                <td align="right" colspan="2">
                                    <span class="InnerDivider">&nbsp;</span>
                                    <br />
                                    
                                    <asp:Button ID="edit_btn" runat="server" CausesValidation="False" CommandName="Edit" Text="Edit" CssClass="ButtonStyle" />
                                    &nbsp;
                                    <asp:Button ID="delete_btn" runat="server" CausesValidation="False" CommandName="Delete" Text="Delete"
                                        OnClientClick="return confirm('Are you sure you want to delete this screenshot?');" CssClass="ButtonStyle" />
                                    &nbsp;
                                    <asp:Button ID="new_btn" runat="server" CausesValidation="false" CommandName="New" Text="Add New Screenshot" CssClass="ButtonStyle" />
                                </td>
                            </tr>
                    </ItemTemplate>
                    
                    <FooterTemplate>
                        </table>
                    </FooterTemplate>
                    
                </asp:FormView>
                    
                
                <asp:ModalPopupExtender ID="changed_mpExt" runat="server" TargetControlID="dummy" PopupControlID="changed_pnl" />
                <input type="button" id="dummy" runat="server" style="display: none;" />
                        
                <asp:Panel ID="changed_pnl" runat="server" CssClass="ModalStyle" Width="375px">
                
                    <asp:UpdatePanel ID="changed_updatePnl" runat="server" UpdateMode="Conditional">
                        
                        <ContentTemplate>
                            <asp:Literal ID="changed_lit" runat="server" />
                        </ContentTemplate>
                        
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="ok_lBtn" EventName="click" />
                        </Triggers>
                        
                    </asp:UpdatePanel>
    
                    <asp:LinkButton ID="ok_lBtn" runat="server" Text="Ok" CausesValidation="false" OnClick="onOkClick" /> 
                </asp:Panel>
            
            </td>
        </tr>
    </table>
    
    <asp:SqlDataSource ID="category_sds" runat="server" ConnectionString="<%$ConnectionStrings:ProjectConnectionString %>" 
        SelectCommand="SELECT ID, CategoryTitle FROM Categories UNION SELECT -1 AS ID, '-- Select Category --' AS CategoryTitle ORDER BY ID" />
        
    <asp:SqlDataSource ID="image_sds" runat="server" ConnectionString="<%$ConnectionStrings:ProjectConnectionString %>"
        SelectCommand="SELECT Images.*, Projects.ProjectName, Projects.CategoryID FROM Projects INNER JOIN Images ON Projects.ID = Images.ProjectID WHERE Images.ID = @ID"
        InsertCommand="INSERT INTO Images (Path, Caption, ProjectID, Resized) VALUES (@Path, @Caption, @ProjectID, @Resized);SET @NewID = SCOPE_IDENTITY()"
        UpdateCommand="UPDATE Images SET Path = @Path, Caption = @Caption, ProjectID = @ProjectID, Resized = @Resized WHERE ID = @ID"
        DeleteCommand="DELETE FROM Images WHERE ID = @ID"
        >
        
        <SelectParameters>
            <asp:SessionParameter Name="ID" SessionField="SelectedImage" Type="Int32" />
        </SelectParameters>
        
        <DeleteParameters>
            <asp:Parameter Name="ID" Type="Int32" />
        </DeleteParameters>
        
        <InsertParameters>
            <asp:Parameter Name="Path" Type="String" />
            <asp:Parameter Name="Caption" Type="String" />
            <asp:Parameter Name="ProjectID" Type="Int32" />
            <asp:Parameter Name="Resized" Type="Boolean" />
            <asp:Parameter Name="NewID" Type="Int32" Size="4" Direction="Output" />
        </InsertParameters>
            
        <UpdateParameters>
            <asp:Parameter Name="ID" Type="Int32" />
            <asp:Parameter Name="Caption" Type="String" />
            <asp:Parameter Name="ProjectID" Type="Int32" />
            <asp:Parameter Name="Path" Type="String" />
            <asp:Parameter Name="Resized" Type="Boolean" />
        </UpdateParameters>

    </asp:SqlDataSource>
</asp:Content>

