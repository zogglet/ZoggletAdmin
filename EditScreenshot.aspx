<%@ Page Title="Zogglet.com - The domain of Maggy Maffia &raquo; Edit Screenshot" Language="VB" MasterPageFile="~/Master.master" AutoEventWireup="false" CodeFile="EditScreenshot.aspx.vb" Inherits="EditScreenshot" %>
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
                    
                    <asp:UpdatePanel ID="fv_updatePnl" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <asp:FormView ID="image_fv" runat="server" DataKeyNames="ID" DataSourceID="image_sds">
                                
                                <HeaderTemplate>
                                    <table class="FormviewTbl">
                                </HeaderTemplate>
                                
                                <EditItemTemplate>
                                        <tr>
                                            <td colspan="2">
                                                <table class="options_area">
                                                    <tr>
                                                        <td>
                                                            Category:
                                                            &nbsp;<asp:DropDownList ID="category_ddl" DataSourceID="category_sds" runat="server" DataTextField="CategoryTitle" DataValueField="ID" 
                                                                CssClass="InputStyle" SelectedValue='<%#Bind("CategoryID") %>' AutoPostBack="true" OnSelectedIndexChanged="setPostbackTriggers" />
                                                                
                                                            <asp:CompareValidator ID="category_cVal" runat="server" Operator="NotEqual" ValueToCompare="-1" Display="None" 
                                                                ControlToValidate="category_ddl" ErrorMessage="Select a freakin' category." />
                                                            <asp:ValidatorCalloutExtender ID="category_vcExt" runat="server" TargetControlID="category_cVal" WarningIconImageUrl="warningIcon.png"
                                                                CloseImageUrl="closeIcon.png" CssClass="ValidatorCalloutStyle" />
                                                        </td>
                                                        <td>
                                                            Project:
                                                            &nbsp;<asp:DropDownList ID="project_ddl" DataSourceID="project_sds" runat="server" DataTextField="ProjectName" DataValueField="ID"   
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
                                                Image Title:
                                                &nbsp;<asp:TextBox ID="imgTitle_txt" runat="server" Text='<%#Bind("ImageTitle") %>' Width="150px" CssClass="InputStyle" />
                                                
                                                <asp:RequiredFieldValidator ID="imgTitle_rVal" runat="server" ControlToValidate="imgTitle_txt" ErrorMessage="Image title is required." Display="None" />
                                                <asp:ValidatorCalloutExtender ID="imgTitle_vcExt" runat="server" TargetControlID="imgTitle_rVal" WarningIconImageUrl="warningIcon.png"
                                                      CloseImageUrl="closeIcon.png" CssClass="ValidatorCalloutStyle" />
                                            </td>
                                            <td>
                                                Caption:
                                                &nbsp;<asp:TextBox ID="caption_txt" runat="server" Text='<%#Bind("Caption") %>' CssClass="InputStyle" Width="275px" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <br />
                                                New Image:
                                                <asp:HiddenField ID="img_hField" runat="server" value='<%#Bind("ImageData") %>' />
                                                &nbsp;<asp:FileUpload ID="img_uploader" runat="server" CssClass="InputStyle" />
                                                
                                                <asp:HiddenField ID="mimeType_hField" runat="server" Value='<%#Bind("MIMEType") %>' />
                                            </td>
                                            <td>
                                                <br />
                                                <asp:Panel ID="resize_pnl" runat="server" Visible='<%#isResizeAvailable(eval("ID"), 600) %>'>
                                                    <p class="smallNote">The current image can be resized.</p>
                                                    <asp:CheckBox ID="resize_cbx" runat="server" Text="Resize &amp; Optimize" />
                                                </asp:Panel>  
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" style="text-align: center;">
                                                <br />
                                                <asp:Panel ID="previewImg_pnl" runat="server"></asp:Panel>
                                                <br /><asp:Literal ID="imageStats_lit" runat="server" text='<%#formatImageStats(eval("Resized")) %>' />
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
                                                <table class="options_area">
                                                    <tr>
                                                        <td>
                                                            Category:
                                                            &nbsp;<asp:DropDownList ID="insertCategory_ddl" DataSourceID="category_sds" runat="server" DataTextField="CategoryTitle" DataValueField="ID" 
                                                                CssClass="InputStyle" AutoPostBack="true" OnSelectedIndexChanged="setPostbackTriggers" />
                                                                
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
                                                Image Title:
                                                &nbsp;<asp:TextBox ID="imgTitle_txt" runat="server" Text='<%#Bind("ImageTitle") %>' Width="150px" CssClass="InputStyle" />
                                                
                                                <asp:RequiredFieldValidator ID="imgTitle_rVal" runat="server" ControlToValidate="imgTitle_txt" ErrorMessage="Image title is required." Display="None" />
                                                <asp:ValidatorCalloutExtender ID="imgTitle_vcExt" runat="server" TargetControlID="imgTitle_rVal" WarningIconImageUrl="warningIcon.png"
                                                      CloseImageUrl="closeIcon.png" CssClass="ValidatorCalloutStyle" />
                                            </td>
                                            <td>
                                                Caption:
                                                &nbsp;<asp:TextBox ID="caption_txt" runat="server" Text='<%#Bind("Caption") %>' CssClass="InputStyle" Width="275px" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <br />
                                                Image:
                                                &nbsp;<asp:FileUpload ID="img_uploader" runat="server" CssClass="InputStyle" />
                                            </td>
                                            <td>
                                                <br />
                                                <asp:Panel ID="resize_pnl" runat="server">
                                                    <p class="smallNote">If this box is checked, the image will be resized if either dimension is over 600px.</p>
                                                    <asp:CheckBox ID="resize_cbx" runat="server" Text="Resize &amp; Optimize" />
                                                </asp:Panel>
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
                                                Image Title:
                                                &nbsp;<asp:Label ID="imgData_lbl" runat="server" Text='<%#Bind("ImageTitle") %>' CssClass="FormviewLbl" />

                                            </td>
                                            <td>
                                                Caption:
                                                &nbsp;<asp:Label ID="caption_lbl" runat="server" text='<%#formatNullText(eval("Caption")) %>' CssClass="FormviewLbl" Font-Bold="false" Font-Italic="true" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" style="text-align: center;">
                                                <br />
                                                <asp:Panel ID="previewImg_pnl" runat="server"></asp:Panel>
                                                <br /><asp:Literal ID="imageStats_lit" runat="server" text='<%#formatImageStats(eval("Resized")) %>' />
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
                        </ContentTemplate>
                        <Triggers>

                        </Triggers>
                    </asp:UpdatePanel>
                        
                    
                
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
        SelectCommand="SELECT Screenshots.*, Projects.ProjectName, Projects.CategoryID FROM Projects INNER JOIN Screenshots ON Projects.ID = Screenshots.ProjectID WHERE Screenshots.ID = @ID"
        InsertCommand="INSERT INTO Screenshots (ImageData, ImageTitle, Caption, MIMEType, ProjectID, Resized) VALUES (@ImageData, @ImageTitle, @Caption, @MIMEType, @ProjectID, @Resized);SET @NewID = SCOPE_IDENTITY()"
        UpdateCommand="UPDATE Screenshots SET ImageData = @ImageData, ImageTitle = @ImageTitle, Caption = @Caption, MIMEType = @MIMEType, ProjectID = @ProjectID, Resized = @Resized WHERE ID = @ID"
        DeleteCommand="DELETE FROM Screenshots WHERE ID = @ID"
        >
        
        <SelectParameters>
            <asp:SessionParameter Name="ID" SessionField="SelectedImage" Type="Int32" />
        </SelectParameters>
        
        <DeleteParameters>
            <asp:Parameter Name="ID" Type="Int32" />
        </DeleteParameters>
        
        <InsertParameters>
            <asp:Parameter Name="ImageData" />
            <asp:Parameter Name="ImageTitle" Type="String" />
            <asp:Parameter Name="Caption" Type="String" />
            <asp:Parameter Name="MIMEType" Type="String" />
            <asp:Parameter Name="ProjectID" Type="Int32" />
            <asp:Parameter Name="Resized" Type="Boolean" />
            <asp:Parameter Name="NewID" Type="Int32" Size="4" Direction="Output" />
        </InsertParameters>
            
        <UpdateParameters>
            <asp:Parameter Name="ID" Type="Int32" />
            <asp:Parameter Name="ImageData" />
            <asp:Parameter Name="ImageTitle" Type="String" />
            <asp:Parameter Name="Caption" Type="String" />
            <asp:Parameter Name="MIMEType" Type="String" />
            <asp:Parameter Name="ProjectID" Type="Int32" />
            <asp:Parameter Name="Resized" Type="Boolean" />
        </UpdateParameters>

    </asp:SqlDataSource>
</asp:Content>

