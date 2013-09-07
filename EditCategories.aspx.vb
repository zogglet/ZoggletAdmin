Imports System.Data
Imports System.Data.SqlClient

Partial Class Default2
    Inherits System.Web.UI.Page

    Dim oConn As New SqlConnection(ConfigurationManager.ConnectionStrings("ProjectConnectionString").ConnectionString)
    Dim oCmd As New SqlCommand
    Dim oParam As SqlParameter
    Dim oDA As New SqlDataAdapter
    Dim oDTbl As New DataTable
    Dim strSQL As String = ""
    Dim msgScript As String = ""

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then

            bindDDL()

            prompt_lit.Text = "<i>Select a category to edit, or add a new one.</i>"
            configElements(True)

        End If

        Session("FromInserted") = Nothing
        Session("FromUpdated") = Nothing
        Session("FromDeleted") = Nothing
        Session("RecentItem") = Nothing


    End Sub

    Protected Sub bindDDL(Optional ByVal value As Integer = -2)

        Try
            oCmd.Connection = oConn
            oCmd.CommandType = CommandType.Text

            strSQL = "SELECT ID, CategoryTitle FROM Categories UNION SELECT -2 AS ID, '--Select Category--' AS CategoryTitle UNION SELECT -1 AS ID, 'ADD NEW' AS CategoryTitle ORDER BY ID"

            oCmd.CommandText = strSQL
            oDA.SelectCommand = oCmd

            oDA.Fill(oDTbl)

            categories_ddl.DataSource = oDTbl
            categories_ddl.DataBind()

            categories_ddl.SelectedValue = value

        Catch ex As Exception
            Throw ex
        Finally
            If oConn.State = ConnectionState.Open Then
                oConn.Close()
            End If
            oCmd.Dispose()
        End Try
    End Sub

    Protected Sub configElements(ByVal showPrompt As Boolean)
        prompt_lit.Visible = showPrompt
        categories_formView.Visible = Not showPrompt
    End Sub


    Protected Sub categories_formView_ItemCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewCommandEventArgs) Handles categories_formView.ItemCommand
        If e.CommandName = "Cancel" Then
            configElements(True)
            bindDDL()
        End If
    End Sub


    Protected Sub categories_formView_ItemDeleted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewDeletedEventArgs) Handles categories_formView.ItemDeleted
        Session("FromDeleted") = True
        Session("RecentItem") = e.Values("CategoryTitle")

        configElements(True)

        Session("SelectedCategory") = Nothing

        bindDDL()

        showChangedResult("deleted")
    End Sub


    Protected Sub categories_ddl_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles categories_ddl.SelectedIndexChanged
        Select Case categories_ddl.SelectedValue
            Case -1
                categories_formView.ChangeMode(FormViewMode.Insert)
            Case -2
                Session("SelectedCategory") = Nothing
            Case Else
                Session("SelectedCategory") = categories_ddl.SelectedValue
                categories_formView.ChangeMode(FormViewMode.ReadOnly)
        End Select
        categories_formView.Visible = (categories_ddl.SelectedValue <> -2)
        prompt_lit.Visible = (categories_ddl.SelectedValue = -2)
    End Sub

    Protected Sub categories_formView_ItemInserted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewInsertedEventArgs) Handles categories_formView.ItemInserted
        Session("FromInserted") = True
        Session("RecentItem") = e.Values("CategoryTitle")

        categories_formView.ChangeMode(FormViewMode.ReadOnly)

        bindDDL(Session("SelectedCategory"))
    End Sub

    Protected Sub categories_formView_ItemUpdated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewUpdatedEventArgs) Handles categories_formView.ItemUpdated
        Session("FromUpdated") = True
        Session("RecentItem") = e.NewValues("CategoryTitle")

        categories_formView.ChangeMode(FormViewMode.ReadOnly)

        bindDDL(Session("SelectedCategory"))

    End Sub


    Protected Sub categories_sds_Inserted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.SqlDataSourceStatusEventArgs) Handles categories_sds.Inserted
        Session("SelectedCategory") = CType(e.Command.Parameters("@NewID").Value, Integer)
    End Sub

    Protected Sub categories_formView_ModeChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles categories_formView.ModeChanged
        If categories_formView.DefaultMode = FormViewMode.ReadOnly Then
            If Session("FromUpdated") Then
                showChangedResult("updated")
                Session("FromUpdated") = Nothing
            ElseIf Session("FromInserted") Then
                showChangedResult("inserted")
                Session("FromInserted") = Nothing
            End If
        End If
    End Sub

    Protected Sub showChangedResult(ByVal change As String)
        changed_lit.Text = "<h3>Success</h3><p class='ResultStyle'>You've successfully " & change & " the category, <b>" & Session("RecentItem") & "</b>.</p>"
        changed_updatePnl.Update()
        changed_mpExt.Show()
    End Sub

    Protected Sub onOkClick()
        changed_mpExt.Hide()
    End Sub

    Public Function formatDescTxt(ByVal desc As Object) As String
        Return IIf(desc IsNot DBNull.Value, desc, "<i>No description specified.</i>")
    End Function
End Class
