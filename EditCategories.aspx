<%@ Page Title="Zogglet.com - The domain of Maggy Maffia &raquo; Edit Project Categories" Language="VB" MasterPageFile="~/Master.master" AutoEventWireup="false" CodeFile="EditCategories.aspx.vb" Inherits="Default2" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder_Main" Runat="Server">

    <h2>Edit Project Categories</h2>
    
    <table id="admin_table">
        <tr>
            <td align="center">
                
                <h3>Add/Edit Project Categories</h3>
                
                <asp:UpdatePanel ID="formview_updatePnl" runat="server" UpdateMode="Conditional">
                
                    <ContentTemplate>
                    
                        <table class="options_area">
                            <tr>
                                <td>
                                    <asp:DropDownList ID="categories_ddl" runat="server" datatextfield="CategoryTitle" DataValueField="ID" AutoPostBack="true" CssClass="InputStyle" />
                                </td>
                                <td>
                                     <asp:Literal ID="prompt_lit" runat="server" />
                                </td>
                            </tr>
                        </table>
                        
                        <asp:FormView ID="categories_formView" runat="server" DataKeyNames="ID" DataSourceID="categories_sds" Width="100%">
                        
                            <HeaderTemplate>
                                <table class="FullFVTbl">
                                    <tr>
                                        <td>
                                            <span class="InnerDivider">&nbsp;</span>
                                        </td>
                                    </tr>
                            </HeaderTemplate>
                            
                            <EditItemTemplate>
                                <tr>
                                    <td>
                                        Category Title:
                                        <br />
                                        <asp:TextBox ID="catTitle_txt" runat="server" Text='<%#Bind("CategoryTitle") %>' CssClass="InputStyle" />
                                        
                                        <asp:RequiredFieldValidator ID="catTitle_rVal" runat="server" ControlToValidate="catTitle_txt" ErrorMessage="Category title is required." Display="None" />
                                        <asp:ValidatorCalloutExtender ID="catTitle_vcExt" runat="server" TargetControlID="catTitle_rVal" WarningIconImageUrl="warningIcon.png"
                                              CloseImageUrl="closeIcon.png" CssClass="ValidatorCalloutStyle" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Description:
                                        <br /><asp:Textbox ID="description_txt" runat="server" Text='<%#Bind("Description") %>' Width="325px" Height="125px" TextMode="MultiLine" Wrap="true" CssClass="InputStyle" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <span class="InnerDivider">&nbsp;</span>
                                        <br />
                                        
                                        <asp:Button ID="update_btn" runat="server" CausesValidation="true" CommandName="Update" Text="Update" CssClass="ButtonStyle" />
                                        &nbsp;&nbsp;
                                        <asp:Button ID="cancel_btn" runat="server" CausesValidation="false" CommandName="Cancel" Text="Cancel" CssClass="ButtonStyle" />
                                    </td>
                                </tr>
                            </EditItemTemplate>
                            
                            <InsertItemTemplate>
                                <tr>
                                    <td>
                                        Category Title:
                                        <br />
                                        <asp:TextBox ID="catTitle_txt" runat="server" Text='<%#Bind("CategoryTitle") %>' CssClass="InputStyle" />
                                        
                                        <asp:RequiredFieldValidator ID="catTitle_rVal" runat="server" ControlToValidate="catTitle_txt" ErrorMessage="Category title is required." Display="None" />
                                        <asp:ValidatorCalloutExtender ID="catTitle_vcExt" runat="server" TargetControlID="catTitle_rVal" WarningIconImageUrl="warningIcon.png"
                                              CloseImageUrl="closeIcon.png" CssClass="ValidatorCalloutStyle" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Description:
                                        <br /><asp:Textbox ID="description_txt" runat="server" Text='<%#Bind("Description") %>' Width="325px" Height="125px" TextMode="MultiLine" Wrap="true" CssClass="InputStyle" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <span class="InnerDivider">&nbsp</span>
                                        <br />
                                        
                                        <asp:Button ID="insert_btn" runat="server" CausesValidation="true" CommandName="Insert" Text="Add" CssClass="ButtonStyle" />
                                        &nbsp;&nbsp;
                                        <asp:Button ID="cancel_btn" runat="server" CausesValidation="false" CommandName="Cancel" Text="Cancel" CssClass="ButtonStyle" />
                                    </td>
                                </tr>
                            </InsertItemTemplate>
                            
                            <ItemTemplate>
                                <tr>
                                    <td>
                                        Category Title:
                                        <br />
                                        <asp:Label ID="category_lbl" runat="server" Text='<%#Bind("CategoryTitle") %>' CssClass="FormviewLbl" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Description:
                                        <br /><asp:Label ID="description_lbl" runat="server" Text='<%#formatDescTxt(eval("Description")) %>' CssClass="FormviewLbl" Font-Bold="false" Font-Italic="true" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <span class="InnerDivider">&nbsp</span>
                                        <br />
                                        
                                        <asp:Button ID="edit_btn" runat="server" CausesValidation="true" CommandName="Edit" Text="Edit" CssClass="ButtonStyle" />
                                        &nbsp;&nbsp;
                                        <asp:Button ID="delete_btn" runat="server" CausesValidation="false" CommandName="Delete" Text="Delete" CssClass="ButtonStyle"
                                            OnClientClick="return confirm('Are you sure you want to delete this category?');" />
                                    </td>
                                </tr>
                            </ItemTemplate>
                        </asp:FormView>
                    
                    </ContentTemplate>
                    
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="categories_formView" EventName="ItemCommand" />
                        <asp:AsyncPostBackTrigger ControlID="categories_formView" EventName="ItemInserted" />
                        <asp:AsyncPostBackTrigger ControlID="categories_formView" EventName="ItemDeleted" />
                        <asp:AsyncPostBackTrigger ControlID="categories_formView" EventName="ItemUpdated" />
                        <asp:AsyncPostBackTrigger ControlID="categories_formView" EventName="ModeChanged" />
                        <asp:AsyncPostBackTrigger ControlID="categories_ddl" EventName="SelectedIndexChanged" />
                    </Triggers>
                </asp:UpdatePanel>
                
            </td>
        </tr>
    </table>
    
    <%--General Modal Popup--%>
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
            <asp:LinkButton ID="ok_lBtn" runat="server" Text="Ok" OnClick="onOkClick" CausesValidation="false" />
        </asp:Panel>
                
    
     <asp:SqlDataSource ID="categories_sds" runat="server" ConnectionSTring="<%$ ConnectionStrings:ProjectConnectionString %>"   
        SelectCommand="SELECT ID, CategoryTitle, Description FROM Categories WHERE ID = @ID"
        InsertCommand="INSERT INTO Categories (CategoryTitle, Description) VALUES (@CategoryTitle, @Description);SET @NewID = SCOPE_IDENTITY()"
        DeleteCommand="DELETE FROM Categories WHERE ID = @ID"
        UpdateCommand="UPDATE Categories SET CategoryTitle = @CategoryTitle, Description = @Description WHERE ID = @ID"
        >
        
        <SelectParameters>
            <asp:SessionParameter Name="ID" SessionField="SelectedCategory" Type="Int32" />
        </SelectParameters>    
        
        <DeleteParameters>
            <asp:Parameter Name="ID" Type="Int32" />
        </DeleteParameters>
        
        <UpdateParameters>
            <asp:Parameter Name="CategoryTitle" Type="String" />
            <asp:Parameter Name="Description" Type="String" />
            <asp:Parameter Name="ID" Type="Int32" />
        </UpdateParameters>
        
        <InsertParameters>
            <asp:Parameter Name="CategoryTitle" Type="String" />
            <asp:Parameter Name="Description" Type="String" />
            <asp:Parameter Name="NewID" Direction="Output" Size="4" Type="Int32" />
        </InsertParameters>
        
    </asp:SqlDataSource>

</asp:Content>

