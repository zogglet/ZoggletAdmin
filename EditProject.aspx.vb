
Partial Class Default4
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack And Session("SelectedProject") = 0 Then
            project_formView.DefaultMode = FormViewMode.Insert

        End If
    End Sub

    Protected Sub list_lBtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles list_lBtn.Click
        Response.Redirect("ManageProjects.aspx")
    End Sub

    Public Function formatNullText(ByVal f As Object) As String
        Return IIf(f IsNot DBNull.Value, f, "<i>Not specified.</i>")
    End Function

    Public Function formatLink(ByVal link As Object) As String
        Return "../" & link
    End Function

    Protected Sub project_formView_ItemCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewCommandEventArgs) Handles project_formView.ItemCommand
        If e.CommandName = "Cancel" Then
            Response.Redirect("ManageProjects.aspx")
        End If
    End Sub


    Protected Sub project_formView_ItemDeleted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewDeletedEventArgs) Handles project_formView.ItemDeleted
        Session("RecentProject") = e.Values("ProjectName")
        Session("FromDeleted") = True
        Response.Redirect("ManageProjects.aspx")
    End Sub

    Protected Sub project_formView_ItemInserted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewInsertedEventArgs) Handles project_formView.ItemInserted
        Session("RecentProject") = e.Values("ProjectName")
        Session("FromInserted") = True

        project_formView.DefaultMode = FormViewMode.ReadOnly
    End Sub

    Protected Sub project_formView_ItemUpdated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewUpdatedEventArgs) Handles project_formView.ItemUpdated
        Session("RecentProject") = e.NewValues("ProjectName")
        Session("FromUpdated") = True

        project_formView.DefaultMode = FormViewMode.ReadOnly
    End Sub

    Protected Sub projects_sds_Inserted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.SqlDataSourceStatusEventArgs) Handles projects_sds.Inserted
        Session("SelectedProject") = CType(e.Command.Parameters("@NewID").Value, Integer)
    End Sub

    Protected Sub showChangedResult(ByVal inserted As Boolean)
        changed_lit.Text = "<h3>Successful " & IIf(inserted, "Addition", "Update") & "</h4><p class='ResultStyle'>The project, <b>" & Session("RecentProject") & "</b>, has been successfully " & IIf(inserted, "added", "modified") & ".</p>"
        changed_updatePnl.Update()
        changed_mpExt.Show()
    End Sub

    Protected Sub project_formView_ModeChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles project_formView.ModeChanged
        If project_formView.DefaultMode = FormViewMode.ReadOnly Then
            If Session("FromUpdated") Then
                showChangedResult(False)
                Session("FromUpdated") = Nothing
            ElseIf Session("FromInserted") Then
                showChangedResult(True)
                Session("FromInserted") = Nothing
            End If
        End If
    End Sub

    Protected Sub onOkClick(ByVal sender As Object, ByVal e As System.EventArgs)
        changed_mpExt.Hide()
    End Sub
End Class
