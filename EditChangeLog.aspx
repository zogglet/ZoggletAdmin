<%@ Page Title="Zogglet.com - The domain of Maggy Maffia &raquo; Edit Change Log" Language="VB" MasterPageFile="~/Master.master" AutoEventWireup="false" CodeFile="EditChangeLog.aspx.vb" Inherits="EditChangeLog" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder_Main" Runat="Server">

<h2>Edit Change Log</h2>
                

    <span id="nav_table">
        <asp:LinkButton ID="list_lBtn" runat="server" Text="Return to Change Log List" CausesValidation="false" />
    </span>
    
    <table id="admin_table">
        
        <tr>
            <td align="center">
            
                <h3>Add/Edit Change Log Item</h3>
                
                <asp:UpdatePanel ID="formview_updatePnl" runat="server" UpdateMode="Conditional">
                    
                    <ContentTemplate>
                        <asp:FormView ID="item_fv" runat="server" DataKeyNames="ID" DataSourceID="items_sds">
                        
                            <HeaderTemplate>
                                
                                <table class="FormviewTbl">
                            </HeaderTemplate>
                            
                            <EditItemTemplate>
                                <tr>
                                  <td>
                                    <table class="options_area">
                                        <tr>
                                            <td>
                                              <asp:UpdatePanel ID="project_updatePnl" runat="server" UpdateMode="Conditional">
                                                    <ContentTemplate>   
                                                        <table>
                                                            <tr>
                                                                <td>
                                                                    Category: 
                                                                    <br /><asp:DropDownList ID="editCategory_ddl" DataSourceID="editCategory_sds" runat="server" DataTextField="CategoryTitle" DataValueField="ID" CssClass="InputStyle" SelectedValue='<%#Bind("CategoryID") %>' AutoPostBack="true" />
                                                                    
                                                                    <asp:SqlDataSource ID="editCategory_sds" runat="server" ConnectionString="<%$ ConnectionStrings:ProjectConnectionString %>" 
                                                                        SelectCommand="SELECT ID, CategoryTitle FROM Categories UNION SELECT -1 AS ID, '-- Select Category --' AS CategoryTitle ORDER BY ID" />
                                                                        
                                                                    <asp:CompareValidator ID="editCategory_cVal" runat="server" Operator="NotEqual" ValueToCompare="-1" Display="None" 
                                                                        ControlToValidate="editCategory_ddl" ErrorMessage="Select a freakin' category." />
                                                                    <asp:ValidatorCalloutExtender ID="editCategory_vcExt" runat="server" TargetControlID="editCategory_cVal" WarningIconImageUrl="warningIcon.png"
                                                                        CloseImageUrl="closeIcon.png" CssClass="ValidatorCalloutStyle" />
                                                                </td>
                                                                <td>
                                                                    Project: 
                                                                    <br /><asp:DropDownList ID="editProject_ddl" DataSourceID="editProject_sds" runat="server" DataTextField="ProjectName" DataValueField="ID" CssClass="InputStyle"  />
                                                                    
                                                                    <asp:SqlDataSource ID="editProject_sds" runat="server" ConnectionString="<%$ ConnectionStrings:ProjectConnectionString %>" 
                                                                        SelectCommand="SELECT ID, ProjectName, CategoryID FROM Projects WHERE CategoryID = @CategoryID UNION SELECT -1 AS ID, '-- Select Project --' AS ProjectName, -1 AS CategoryID ORDER BY ID">
                                                                    
                                                                        <SelectParameters>
                                                                            <asp:ControlParameter ControlID="editCategory_ddl" PropertyName="SelectedValue" Name="CategoryID" Type="Int32" DefaultValue="-1" />
                                                                        </SelectParameters>
                                                                    </asp:SqlDataSource>
                                                                    
                                                                    <asp:CompareValidator ID="editProject_cVal" runat="server" Operator="NotEqual" ValueToCompare="-1" Display="None" 
                                                                        ControlToValidate="editProject_ddl" ErrorMessage="Select a freakin' project." />
                                                                    <asp:ValidatorCalloutExtender ID="editProject_vcExt" runat="server" TargetControlID="editProject_cVal" WarningIconImageUrl="warningIcon.png"
                                                                        CloseImageUrl="closeIcon.png" CssClass="ValidatorCalloutStyle" />
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    
                                                    </ContentTemplate>
                                                        
                                                    <Triggers>
                                                        <asp:AsyncPostBackTrigger ControlID="editCategory_ddl" EventName="SelectedIndexChanged" />
                                                    </Triggers>
                                                </asp:UpdatePanel>
                                            </td>
                                            <td>
                                                <asp:UpdatePanel id="date_updatePnl" runat="server" UpdateMode="Conditional">
                                                    <ContentTemplate>
                                                        Date: 
                                                        <br /><asp:TextBox ID="editDate_txt" runat="server" Text='<%#formatDateText(eval("TheDate"))%>' CssClass="InputStyle" />
                                                        <asp:CheckBox ID="editNow_cbx" runat="server" Text="Now" AutoPostBack="true" Checked='<%#isNowChecked(eval("TheDate")) %>' OnCheckedChanged="editNowChanged" />
                                                        <asp:CalendarExtender ID="editDate_calExt" runat="server" TargetControlID="editDate_txt" DefaultView="Days" />
                                                          
                                                        <asp:CustomValidator ID="editDate_custVal" runat="server" ControlToValidate="editDate_txt" ErrorMessage="Enter a valid freakin' date." Display="None"
                                                                OnServerValidate="validateDate" ValidateEmptyText="true" />
                                                            <asp:ValidatorCalloutExtender ID="editDate_rVal" runat="server" TargetControlID="editDate_custVal" WarningIconImageUrl="warningIcon.png"
                                                                CloseImageUrl="closeIcon.png" CssClass="ValidatorCalloutStyle" />
                                                    </ContentTemplate>
                                                    <Triggers>
                                                        <asp:AsyncPostBackTrigger ControlID="editNow_cbx" EventName="CheckedChanged" />
                                                    </Triggers>
                                                </asp:UpdatePanel>
                                                
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
                                        Changes Made: 
                                        <br /><asp:TextBox ID="itemContent_txt" runat="server" Text='<%#Bind("ItemContent") %>' Width="300px" Height="125px" TextMode="MultiLine" CssClass="InputStyle" />
                                        
                                        <asp:RequiredFieldValidator ID="itemContent_rVal" runat="server" ControlToValidate="itemContent_txt" Display="None" ErrorMessage="Enter the changes made." />
                                        <asp:ValidatorCalloutExtender ID="itemContent_vcExt" runat="server" TargetControlID="itemContent_rVal" WarningIconImageUrl="warningIcon.png"
                                            CloseImageUrl="closeIcon.png" CssClass="ValidatorCalloutStyle" />
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
                                                     <asp:UpdatePanel ID="project_updatePnl" runat="server" UpdateMode="Conditional">
                                                        <ContentTemplate>   
                                                            <table>
                                                                <tr>
                                                                    <td>
                                                                        Category: 
                                                                        <br /><asp:DropDownList ID="category_ddl" DataSourceID="category_sds" runat="server" DataTextField="CategoryTitle" DataValueField="ID" CssClass="InputStyle" SelectedValue='<%#Bind("CategoryID") %>' AutoPostBack="true" />
                                                                        
                                                                        <asp:SqlDataSource ID="category_sds" runat="server" ConnectionString="<%$ ConnectionStrings:ProjectConnectionString %>" 
                                                                            SelectCommand="SELECT ID, CategoryTitle FROM Categories UNION SELECT -1 AS ID, '-- Select Category --' AS CategoryTitle ORDER BY ID" />
                                                                            
                                                                        <asp:CompareValidator ID="category_cVal" runat="server" Operator="NotEqual" ValueToCompare="-1" Display="None" 
                                                                            ControlToValidate="category_ddl" ErrorMessage="Select a freakin' category." />
                                                                        <asp:ValidatorCalloutExtender ID="difficulty_vcExt" runat="server" TargetControlID="category_cVal" WarningIconImageUrl="warningIcon.png"
                                                                            CloseImageUrl="closeIcon.png" CssClass="ValidatorCalloutStyle" />
                                                                    </td>
                                                                    <td>
                                                                        Project: 
                                                                        <br /><asp:DropDownList ID="project_ddl" DataSourceID="project_sds" runat="server" DataTextField="ProjectName" DataValueField="ID" CssClass="InputStyle" />
                                                                        
                                                                        <asp:SqlDataSource ID="project_sds" runat="server" ConnectionString="<%$ ConnectionStrings:ProjectConnectionString %>" 
                                                                            SelectCommand="SELECT ID, ProjectName, CategoryID FROM Projects WHERE CategoryID = @CategoryID UNION SELECT -1 AS ID, '-- Select Project --' AS ProjectName, -1 as CategoryID ORDER BY ID">
                                                                        
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
                                                <td>
                                                   <asp:UpdatePanel id="insertDate_updatePnl" runat="server" UpdateMode="Conditional">
                                                        <ContentTemplate>
                                                            Date: 
                                                            <br /><asp:TextBox ID="insertDate_txt" runat="server" Text='<%#formatDateText(eval("TheDate"))%>' CssClass="InputStyle" />
                                                            <asp:CheckBox ID="insertNow_cbx" runat="server" Text="Now" AutoPostback="true" OnCheckedChanged="insertNowChanged" />
                                                            <asp:CalendarExtender ID="insertDate_calExt" runat="server" TargetControlID="insertDate_txt" DefaultView="Days" />

                                                            <asp:CustomValidator ID="insertDate_custVal" runat="server" ControlToValidate="insertDate_txt" ErrorMessage="Enter a valid freakin' date." Display="None"
                                                                OnServerValidate="validateDate" ValidateEmptyText="true" />
                                                            <asp:ValidatorCalloutExtender ID="insertDate_rVal" runat="server" TargetControlID="insertDate_custVal" WarningIconImageUrl="warningIcon.png"
                                                                CloseImageUrl="closeIcon.png" CssClass="ValidatorCalloutStyle" />
                                                        </ContentTemplate>
                                                        <Triggers>
                                                            <asp:AsyncPostBackTrigger ControlID="insertNow_cbx" EventName="CheckedChanged" />
                                                        </Triggers>
                                                    </asp:UpdatePanel>
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
                                        Changes Made: 
                                        <br /><asp:TextBox ID="itemContent_txt" runat="server" Text='<%#Bind("ItemContent") %>' Width="300px" Height="125px" TextMode="MultiLine" CssClass="InputStyle" />
                                        
                                        <asp:RequiredFieldValidator ID="itemContent_rVal" runat="server" ControlToValidate="itemContent_txt" Display="None" ErrorMessage="Enter the changes made." />
                                        <asp:ValidatorCalloutExtender ID="itemContent_vcExt" runat="server" TargetControlID="itemContent_rVal" WarningIconImageUrl="warningIcon.png"
                                            CloseImageUrl="closeIcon.png" CssClass="ValidatorCalloutStyle" />
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
                                                    Category: 
                                                    <br /><asp:Label ID="category_lbl" runat="server" Text='<%#Bind("CategoryTitle") %>' CssClass="FormviewLbl" />
                                                </td>
                                                <td>
                                                    Project: 
                                                    <br /><asp:Label ID="project_lbl" runat="server" Text='<%#Bind("ProjectName") %>' CssClass="FormviewLbl" />
                                                </td>
                                                <td>
                                                    Date: 
                                                    <br /><asp:Label ID="date_lbl" runat="server" Text='<%#formatDateDisplay(eval("TheDate")) %>' CssClass="FormviewLbl" />
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
                                        Changes Made: 
                                        <br /><asp:Label ID="itemContent_lbl" runat="server" Text='<%#Bind("ItemContent") %>' CssClass="FormviewLbl" Font-Italic="true" Font-Bold="false" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">
                                        <span class="InnerDivider">&nbsp;</span>
                                        <br />
                                        
                                        <asp:Button ID="edit_btn" runat="server" CausesValidation="False" CommandName="Edit" Text="Edit" CssClass="ButtonStyle" />
                                        &nbsp;<asp:Button ID="delete_btn" runat="server" CausesValidation="False" CommandName="Delete" Text="Delete"
                                            OnClientClick="return confirm('Are you sure you want to delete this item?');" CssClass="ButtonStyle" />
                                        &nbsp;<asp:Button ID="new_btn" runat="server" CausesValidation="false" CommandName="New" Text="Add New Item" CssClass="ButtonStyle" />
                                    </td>
                                </tr>
                            
                            </ItemTemplate>
                            
                            <FooterTemplate>
                                </table>
                            </FooterTemplate>
                        
                        </asp:FormView>
                    </ContentTemplate>
                
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="item_fv" EventName="ItemUpdated" />
                        <asp:AsyncPostBackTrigger ControlID="item_fv" EventName="ItemInserted" />
                        <asp:AsyncPostBackTrigger ControlID="item_fv" EventName="ModeChanged" />
                        <asp:AsyncPostBackTrigger ControlID="item_fv" EventName="ItemCommand" />
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
    
    <asp:SqlDataSource ID="items_sds" runat="server" ConnectionString="<%$ ConnectionStrings:ProjectConnectionString %>"
        SelectCommand="SELECT ChangeLogItems.ID, TheDate, Projects.ProjectName, Categories.CategoryTitle, ItemContent, ChangeLogItems.CategoryID, ChangeLogItems.ProjectID FROM ChangeLogItems INNER JOIN Categories ON ChangeLogItems.CategoryID = Categories.ID INNER JOIN Projects ON ChangeLogItems.ProjectID = Projects.ID WHERE ChangeLogItems.ID = @ID"
        InsertCommand="INSERT INTO ChangeLogItems (TheDate, ProjectID, CategoryID, ItemContent) VALUES (@TheDate, @ProjectID, @CategoryID, @ItemContent);SET @NewID = SCOPE_IDENTITY()"
        UpdateCommand="UPDATE ChangeLogItems SET TheDate = @TheDate, ProjectID = @ProjectID, CategoryID = @CategoryID, ItemContent = @ItemContent WHERE ID = @ID"
        DeleteCommand="DELETE FROM ChangeLogItems WHERE ID = @ID"
        >
        
        <SelectParameters>
            <asp:SessionParameter Name="ID" SessionField="SelectedItem" Type="Int32" />
        </SelectParameters>
        
        <DeleteParameters>
            <asp:Parameter Name="ID" Type="Int32" />
        </DeleteParameters>
        
        <InsertParameters>
            <asp:Parameter Name="TheDate" Type="DateTime" />
            <asp:Parameter Name="ProjectID" Type="Int32" />
            <asp:Parameter Name="CategoryID" Type="Int32" />
            <asp:Parameter Name="ItemContent" Type="String" />
            <asp:Parameter Name="NewID" Type="Int32" Size="4" Direction="Output" />
        </InsertParameters>
        
        <UpdateParameters>
            <asp:Parameter Name="ID" Type="Int32" />
            <asp:Parameter Name="TheDate" Type="DateTime" />
            <asp:Parameter Name="ProjectID" Type="Int32" />
            <asp:Parameter Name="CategoryID" Type="Int32" />
            <asp:Parameter Name="ItemContent" Type="String" />
        </UpdateParameters>
        
     </asp:SqlDataSource>


</asp:Content>

