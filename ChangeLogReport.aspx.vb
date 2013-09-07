Imports Microsoft.Reporting.WebForms

Partial Class ChangeLogReport
    Inherits System.Web.UI.Page

    Private projectID As Integer = 0

    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init

        changeLog_rv.ServerReport.ReportServerUrl = New Uri(System.Configuration.ConfigurationManager.AppSettings("ReportURL"))

    End Sub


    Protected Sub list_lBtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles list_lBtn.Click
        Response.Redirect("ManageChangeLog.aspx")
    End Sub

    Protected Sub report_ddl_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles report_ddl.SelectedIndexChanged


        changeLog_rv.ServerReport.ReportPath = System.Configuration.ConfigurationManager.AppSettings("ReportPath") & report_ddl.SelectedValue

        Try
            If projectID <> Nothing Then
                Dim projectRP() As ReportParameter = {New ReportParameter("Project", projectID, True)}
                If Not IsPostBack Then
                    changeLog_rv.ServerReport.SetParameters(projectRP)
                End If
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

End Class
