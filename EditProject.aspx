<%@ Page Title="Zogglet.com - The domain of Maggy Maffia &raquo; Edit Project Details" ValidateRequest="false" Language="VB" MasterPageFile="~/Master.master" AutoEventWireup="false" CodeFile="EditProject.aspx.vb" Inherits="Default4" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder_Main" Runat="Server">

    <h2>Edit Project Details</h2>
    
    <span id="nav_table">
        <asp:LinkButton ID="list_lBtn" runat="server" Text="Return to Project List" CausesValidation="false" />
    </span>
    
    <table id="admin_table">
        <tr>
            <td align="center">
                
                <h3>Add/Edit Project</h3>
                
                <asp:UpdatePanel ID="formview_updatePnl" runat="server" UpdateMode="Conditional">
                    
                    <ContentTemplate>
                        <asp:FormView ID="project_formView" runat="server" DataKeyNames="ID" DataSourceID="projects_sds">
                            <HeaderTemplate>
                                <table class="FormviewTbl">
                            </HeaderTemplate>
                            
                            <EditItemTemplate>
                                <tr>
                                    <td>
                                        <table class="options_area">
                                            <tr>
                                                <td>
                                                    Project Name: 
                                                    <br /><asp:TextBox ID="projectName_txt" runat="server" Text='<%#Bind("ProjectName") %>' CssClass="InputStyle" />
                                                    <asp:RequiredFieldValidator ID="projectName_rVal" runat="server" ControlToValidate="projectName_txt" ErrorMessage="Project name is required." Display="None" />
                                                    <asp:ValidatorCalloutExtender ID="projectName_vcExt" runat="server" TargetControlID="projectName_rVal" WarningIconImageUrl="warningIcon.png"
                                                          CloseImageUrl="closeIcon.png" CssClass="ValidatorCalloutStyle" />
                                                    
                                                </td>
                                                <td>
                                                    Category:
                                                    <br /><asp:DropDownList ID="category_ddl" runat="server" DataSourceID="category_sds" DataTextField="CategoryTitle" DataValueField="ID" SelectedValue='<%#Bind("CategoryID") %>' CssClass="InputStyle" />

                                                    <asp:CompareValidator ID="category_cVal" runat="server" Operator="NotEqual" ValueToCompare="-1" Display="None" 
                                                        ControlToValidate="category_ddl" ErrorMessage="Select a freakin' category." />
                                                    <asp:ValidatorCalloutExtender ID="category_vcExt" runat="server" TargetControlID="category_cVal" WarningIconImageUrl="warningIcon.png"
                                                        CloseImageUrl="closeIcon.png" CssClass="ValidatorCalloutStyle" />
                                                </td>
                                                <td>
                                                    Link: 
                                                    <br /><asp:TextBox ID="link_txt" runat="server" Text='<%#Bind("Link") %>' CssClass="InputStyle" Width="200px" />
                                                    
                                                    <asp:RequiredFieldValidator ID="link_rVal" runat="server" ControlToValidate="link_txt" ErrorMessage="Link is required." Display="None" />
                                                    <asp:ValidatorCalloutExtender ID="link_vcExt" runat="server" TargetControlID="link_rVal" WarningIconImageUrl="warningIcon.png"
                                                          CloseImageUrl="closeIcon.png" CssClass="ValidatorCalloutStyle" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Language:
                                                    <br /><asp:Textbox ID="language_txt" runat="server" Text='<%#Bind("Language") %>' CssClass="InputStyle" />
                                                    <asp:RequiredFieldValidator ID="language_rVal" runat="server" ControlToValidate="language_txt" ErrorMessage="Language is required." Display="None" />
                                                    <asp:ValidatorCalloutExtender ID="language_vcExt" runat="server" TargetControlID="language_rVal" WarningIconImageUrl="warningIcon.png"
                                                          CloseImageUrl="closeIcon.png" CssClass="ValidatorCalloutStyle" />
                                                </td>
                                                <td colspan="2">
                                                    Other Technologies Used: 
                                                    <br /><asp:TextBox ID="otherTech_txt" runat="server" Text='<%#Bind("OtherTechnologies") %>' CssClass="InputStyle" Width="200px" />
                                                </td>
                                            </tr>
                                         </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <span class="InnerDivider">&nbsp;</span>
                                        <br />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Description:
                                        <br /><asp:TextBox id="description_txt" runat="server" Text='<%#Bind("Description") %>' Width="325px" Height="125px" TextMode="MultiLine" Wrap="true" CssClass="InputStyle" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">
                                        <span class="InnerDivider">&nbsp;</span>
                                        <br />
                                        
                                        <asp:Button ID="update_btn" runat="server" CausesValidation="true" CommandName="Update" Text="Update" CssClass="ButtonStyle" />
                                        &nbsp;<asp:Button ID="cancel_btn" runat="server" CausesValidation="false" CommandName="Cancel" Text="Cancel" CssClass="ButtonStyle" />
                                    </td>
                                </tr>
                            </EditItemTemplate>
                            <InsertItemTemplate>
                                 <tr>
                                    <td>
                                        <table class="options_area">
                                            <tr>
                                                <td>
                                                    Project Name: 
                                                    <br /><asp:TextBox ID="projectName_txt" runat="server" Text='<%#Bind("ProjectName") %>' CssClass="InputStyle" />
                                                    <asp:RequiredFieldValidator ID="projectName_rVal" runat="server" ControlToValidate="projectName_txt" ErrorMessage="Project name is required." Display="None" />
                                                    <asp:ValidatorCalloutExtender ID="projectName_vcExt" runat="server" TargetControlID="projectName_rVal" WarningIconImageUrl="warningIcon.png"
                                                          CloseImageUrl="closeIcon.png" CssClass="ValidatorCalloutStyle" />
                                                    
                                                </td>
                                                <td>
                                                    Category:
                                                    <br /><asp:DropDownList ID="category_ddl" runat="server" DataSourceID="category_sds" DataTextField="CategoryTitle" DataValueField="ID" SelectedValue='<%#Bind("CategoryID") %>' CssClass="InputStyle" />

                                                    <asp:CompareValidator ID="category_cVal" runat="server" Operator="NotEqual" ValueToCompare="-1" Display="None" 
                                                        ControlToValidate="category_ddl" ErrorMessage="Select a freakin' category." />
                                                    <asp:ValidatorCalloutExtender ID="category_vcExt" runat="server" TargetControlID="category_cVal" WarningIconImageUrl="warningIcon.png"
                                                        CloseImageUrl="closeIcon.png" CssClass="ValidatorCalloutStyle" />
                                                </td>
                                                <td>
                                                    Link: 
                                                    <br /><asp:TextBox ID="link_txt" runat="server" Text='<%#Bind("Link") %>' CssClass="InputStyle" Width="200px" />
                                                    
                                                    <asp:RequiredFieldValidator ID="link_rVal" runat="server" ControlToValidate="link_txt" ErrorMessage="Link is required." Display="None" />
                                                    <asp:ValidatorCalloutExtender ID="link_vcExt" runat="server" TargetControlID="link_rVal" WarningIconImageUrl="warningIcon.png"
                                                          CloseImageUrl="closeIcon.png" CssClass="ValidatorCalloutStyle" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Language:
                                                    <br /><asp:Textbox ID="language_txt" runat="server" Text='<%#Bind("Language") %>' CssClass="InputStyle" />
                                                    <asp:RequiredFieldValidator ID="language_rVal" runat="server" ControlToValidate="language_txt" ErrorMessage="Language is required." Display="None" />
                                                    <asp:ValidatorCalloutExtender ID="language_vcExt" runat="server" TargetControlID="language_rVal" WarningIconImageUrl="warningIcon.png"
                                                          CloseImageUrl="closeIcon.png" CssClass="ValidatorCalloutStyle" />
                                                </td>
                                                <td>
                                                    Other Technologies Used: 
                                                    <br /><asp:TextBox ID="otherTech_txt" runat="server" Text='<%#Bind("OtherTechnologies") %>' CssClass="InputStyle" />
                                                </td>
                                            </tr>
                                         </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <span class="InnerDivider">&nbsp;</span>
                                        <br />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Description:
                                        <br /><asp:TextBox id="description_txt" runat="server" Text='<%#Bind("Description") %>' Width="325px" Height="125px" TextMode="MultiLine" Wrap="true" CssClass="InputStyle" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">
                                        <span class="InnerDivider">&nbsp;</span>
                                        <br />
                                        
                                        <asp:Button ID="insert_btn" runat="server" CausesValidation="true" Text="Add" CommandName="Insert" CssClass="ButtonStyle" />
                                        &nbsp;<asp:Button ID="cancel_btn" runat="server" CausesValidation="false" CommandName="Cancel" Text="Cancel" CssClass="ButtonStyle" />
                                    </td>
                                </tr>
                            </InsertItemTemplate>
                            <ItemTemplate>
                                <tr>
                                    <td>
                                        <table class="options_area">
                                            <tr>
                                                <td>
                                                    Project Name:
                                                    <br /><asp:Label ID="projectName_lbl" runat="server" Text='<%#Bind("ProjectName") %>' cssClass="FormviewLbl" />
                                                </td>
                                                <td>
                                                    Category: 
                                                    <br /><asp:Label ID="category_lbl" runat="server" Text='<%#Bind("CategoryTitle") %>' CssClass="FormviewLbl" />
                                                </td>
                                                <td>
                                                    Link:
                                                    <br /><asp:HyperLink ID="link_hLink" runat="server" Text='<%#Bind("Link") %>' NavigateUrl='<%#formatLink(eval("Link")) %>' Target="_blank" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Language: 
                                                    <br /><asp:Label ID="language_lbl" runat="server" Text='<%#Bind("Language") %>' CssClass="FormviewLbl" />
                                                </td>
                                                <td>
                                                    Other Technologies Used:
                                                    <br /><asp:Label id="otherTech_lbl" runat="server" Text='<%#formatNullText(eval("OtherTechnologies")) %>' CssClass="FormviewLbl" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <span class="InnerDivider">&nbsp;</span>
                                        <br />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Description: 
                                        <br /><asp:Label ID="description_txt" runat="server" Text='<%#formatNullText(eval("Description")) %>' TextMode="Multiline" Wrap="True" CssClass="FormviewLbl" Font-Bold="false" Font-Italic="true" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">
                                        <span class="InnerDivider">&nbsp;</span>
                                        <br />
                                        
                                        <asp:Button ID="edit_btn" runat="server" CausesValidation="False" CommandName="Edit" Text="Edit" CssClass="ButtonStyle" />
                                        &nbsp;<asp:Button ID="delete_btn" runat="server" CausesValidation="False" CommandName="Delete" Text="Delete"
                                            OnClientClick="return confirm('Are you sure you want to delete this project?');" CssClass="ButtonStyle" />
                                        &nbsp;<asp:Button ID="new_btn" runat="server" CausesValidation="false" CommandName="New" Text="Add New Project" CssClass="ButtonStyle" />
                                    </td>
                                </tr>
                            </ItemTemplate>
                            
                            <FooterTemplate>
                                </table>
                            </FooterTemplate>
                        </asp:FormView>
                    </ContentTemplate>
                    
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="project_formView" EventName="ItemInserted" />
                        <asp:AsyncPostBackTrigger ControlID="project_formView" EventName="ItemUpdated" />
                        <asp:AsyncPostBackTrigger ControlID="project_formView" EventName="ModeChanged" />
                        <asp:AsyncPostBackTrigger ControlID="project_formView" EventName="ItemCommand" />
                    </Triggers>
                    
                </asp:UpdatePanel>
                
                <asp:ModalPopupExtender ID="changed_mpExt" runat="server" TargetControlID="dummy" PopupControlID="changed_pnl" />
                <input type="button" id="dummy" runat="server" style="display: none;" />
                        
                <%-- The content displayed as the Modal Popup--%>
                <asp:Panel ID="changed_pnl" runat="server" CssClass="ModalStyle" Width="375px">
                
                    <asp:UpdatePanel ID="changed_updatePnl" runat="server" UpdateMode="Conditional">
                        
                        <ContentTemplate>
                            <asp:Literal ID="changed_lit" runat="server" />
                        </ContentTemplate>
                        
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="ok_lBtn" EventName="click" />
                        </Triggers>
                        
                    </asp:UpdatePanel>
    
                    <br />
                    <asp:LinkButton ID="ok_lBtn" runat="server" Text="Ok" CausesValidation="false" OnClick="onOkClick" /> 
                </asp:Panel>
                
            </td>
        </tr>
    </table>
    
    <asp:SqlDataSource ID="category_sds" runat="server" ConnectionString="<%$ ConnectionStrings:ProjectConnectionString %>" 
        SelectCommand="SELECT ID, CategoryTitle FROM Categories UNION SELECT -1 AS ID, '-- Select Category --' AS CategoryTitle ORDER BY ID" />
    
    <asp:SQLDataSource ID="projects_sds" runat="server" ConnectionString="<%$ ConnectionStrings:ProjectConnectionString %>"
        SelectCommand="SELECT Projects.ID, ProjectName, Projects.CategoryID, Projects.Description, Language, OtherTechnologies, Link, Categories.CategoryTitle FROM Projects INNER JOIN Categories on Projects.CategoryID = Categories.ID WHERE Projects.ID = @ID"
        InsertCommand="INSERT INTO Projects (ProjectName, CategoryID, Description, Language, OtherTechnologies, Link) VALUES (@ProjectName, @CategoryID, @Description, @Language, @OtherTechnologies, @Link);SET @NewID = SCOPE_IDENTITY()" 
        UpdateCommand="UPDATE Projects SET ProjectName = @ProjectName, CategoryID = @CategoryID, Description = @Description, Language = @Language, OtherTechnologies = @OtherTechnologies, Link = @Link WHERE ID = @ID"
        DeleteCommand="DELETE FROM Projects WHERE ID = @ID"
        >
        
        <SelectParameters>
            <asp:SessionParameter Name="ID" SessionField="SelectedProject" Type="Int32" />
        </SelectParameters>
        
        <DeleteParameters>
            <asp:Parameter Name="ID" Type="Int32" />
        </DeleteParameters>
        
        <InsertParameters>
            <asp:Parameter Name="ProjectName" Type="String" />
            <asp:Parameter Name="CategoryID" Type="Int32" />
            <asp:Parameter Name="Description" Type="String" />
            <asp:Parameter Name="Language" Type="String" />
            <asp:Parameter Name="OtherTechnologies" Type="String" />
            <asp:Parameter Name="Link" Type="String" />
            <asp:Parameter Name="NewID" Type="Int32" Size="4" Direction="Output" />
        </InsertParameters>
        
        <UpdateParameters>
            <asp:Parameter Name="ID" Type="Int32" />
            <asp:Parameter Name="ProjectName" Type="String" />
            <asp:Parameter Name="CategoryID" Type="Int32" />
            <asp:Parameter Name="Description" Type="String" />
            <asp:Parameter Name="Language" Type="String" />
            <asp:Parameter Name="OtherTechnologies" Type="String" />
            <asp:Parameter Name="Link" Type="String" />
        </UpdateParameters>
        
        
        
        </asp:SQLDataSource>
    
</asp:Content>

