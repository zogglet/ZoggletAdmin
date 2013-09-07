Imports System.Data
Imports System.Data.SqlClient

Partial Class EditChangeLog
    Inherits System.Web.UI.Page

    Dim oConn As New SqlConnection(ConfigurationManager.ConnectionStrings("ProjectConnectionString").ConnectionString)
    Dim oCmd As New SqlCommand
    Dim oParam As SqlParameter
    Dim oDA As New SqlDataAdapter
    Dim oDTbl As New DataTable
    Dim strSQL As String = ""
    Dim dateTxt As New TextBox

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Session("RecentItem") = Nothing

        If Not IsPostBack Then

            If Session("SelectedItem") = 0 Then
                item_fv.DefaultMode = FormViewMode.Insert
            End If

            If item_fv.DefaultMode = FormViewMode.ReadOnly Then
                Session("Date") = CType(item_fv.FindControl("date_lbl"), Label).Text
            Else
                Session("Date") = Nothing
            End If
        End If

    End Sub

    Public Function formatDateText(ByVal d As DateTime) As String
        Return IIf(d.ToShortDateString = "1/1/0001", "", d)
    End Function

    Public Function formatDateDisplay(ByVal d As DateTime) As String
        Return d.ToShortDateString & ", " & d.ToShortTimeString
    End Function

    Protected Sub item_fv_ItemCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewCommandEventArgs) Handles item_fv.ItemCommand
        If e.CommandName = "Cancel" Then
            Response.Redirect("ManageChangeLog.aspx")
        End If
    End Sub

    Protected Sub item_fv_ItemDeleting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewDeleteEventArgs) Handles item_fv.ItemDeleting
        Session("FromDeleted") = True
        Session("RecentItem") = getRecentItemStr(Session("Date"))

    End Sub

    Protected Sub item_fv_ItemDeleted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewDeletedEventArgs) Handles item_fv.ItemDeleted
        Response.Redirect("ManageChangeLog.aspx")

    End Sub

    Protected Function getRecentItemStr(ByVal theDate As Object) As String

        Dim numForDate As Integer
        Dim projName As String = ""

        Try

            oCmd.CommandType = CommandType.Text
            oCmd.Connection = oConn

            'strSQL = "SELECT *, ProjectName FROM ChangeLogItems INNER JOIN Projects ON ChangeLogItems.ProjectID = Projects.ID WHERE ChangeLogItems.TheDate = @TheDate"

            strSQL = "SELECT *, ProjectName FROM ChangeLogItems INNER JOIN Projects ON ChangeLogItems.ProjectID = Projects.ID WHERE ChangeLogItems.TheDate BETWEEN Convert(varchar(10), @TheDate, 101) AND DateAdd(ss, -1, DateAdd(dd, 1, Convert(varchar(10), @TheDate, 101)))"

            oParam = New SqlParameter()
            oParam.ParameterName = "TheDate"
            oParam.SqlDbType = SqlDbType.DateTime
            oParam.Value = CType(theDate, DateTime)
            oCmd.Parameters.Add(oParam)

            oCmd.CommandText = strSQL
            oDA.SelectCommand = oCmd

            oDA.Fill(oDTbl)

            For i As Integer = 0 To oDTbl.Rows.Count - 1
                If oDTbl.Rows(i)("ID") = Session("SelectedItem") Then
                    numForDate = i + 1
                    projName = oDTbl.Rows(i)("ProjectName")
                    Exit For
                End If
            Next

            Return "Item #" & numForDate & " for " & CType(theDate, DateTime).ToShortDateString & " (" & projName & ")"

        Catch ex As Exception
            Throw ex
        End Try

    End Function

    Protected Sub item_fv_ItemInserted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewInsertedEventArgs) Handles item_fv.ItemInserted
        Session("RecentItem") = getRecentItemStr(Session("Date"))
        Session("FromInserted") = True

        item_fv.DefaultMode = FormViewMode.ReadOnly
    End Sub

    Protected Sub item_fv_ItemInserting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewInsertEventArgs) Handles item_fv.ItemInserting
        e.Values("TheDate") = insertDate_txt.Text
        e.Values("ProjectID") = project_ddl.SelectedValue
        e.Values("CategoryID") = category_ddl.SelectedValue

        Session("Date") = insertDate_txt.Text

    End Sub

    Protected Sub item_fv_ItemUpdated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewUpdatedEventArgs) Handles item_fv.ItemUpdated
        Session("RecentItem") = getRecentItemStr(Session("Date"))
        Session("FromUpdated") = True

        item_fv.DefaultMode = FormViewMode.ReadOnly
    End Sub

    Protected Sub item_fv_ItemUpdating(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewUpdateEventArgs) Handles item_fv.ItemUpdating
        e.NewValues("TheDate") = editDate_txt.Text
        e.NewValues("ProjectID") = editProject_ddl.SelectedValue
        e.NewValues("CategoryID") = editCategory_ddl.SelectedValue

        Session("Date") = editDate_txt.Text
    End Sub

    Protected Sub list_lBtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles list_lBtn.Click
        Response.Redirect("ManageChangeLog.aspx")
    End Sub

    Protected Sub bindEditProjectDDL()

        Try
            oCmd.Connection = oConn
            oCmd.CommandType = CommandType.Text

            strSQL = "SELECT ProjectID FROM ChangeLogItems WHERE ID = @ID"

            oParam = New SqlParameter()
            oParam.ParameterName = "ID"
            oParam.SqlDbType = SqlDbType.Int
            oParam.Value = Session("SelectedItem")
            oCmd.Parameters.Add(oParam)

            oCmd.CommandText = strSQL

            oCmd.Connection.Open()

            editProject_ddl.SelectedValue = oCmd.ExecuteScalar()

        Catch ex As Exception
            Throw ex
        End Try

    End Sub

    Protected Sub editProject_ddl_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles editProject_ddl.Load
        If Session("FirstLoad") Then
            bindEditProjectDDL()
            Session("FirstLoad") = Nothing
        End If

    End Sub

    Protected Sub items_sds_Inserted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.SqlDataSourceStatusEventArgs) Handles items_sds.Inserted
        Session("SelectedItem") = CType(e.Command.Parameters("@NewID").Value, Integer)
    End Sub

    Protected Sub insertNowChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        If insertNow_cbx.Checked Then
            If insertDate_txt.Text.Trim.Length > 0 Then
                Session("Date") = insertDate_txt.Text.Trim
            End If
            insertDate_txt.Text = DateTime.Now.ToString
        Else
            If Session("Date") <> Nothing Then
                insertDate_txt.Text = Session("Date")
                Session("Date") = Nothing
            Else
                insertDate_txt.Text = ""
            End If
        End If

    End Sub

    Protected Sub editNowChanged(ByVal sender As Object, ByVal e As System.EventArgs)

        If editNow_cbx.Checked Then
            If editDate_txt.Text.Trim.Length > 0 Then
                Session("Date") = editDate_txt.Text.Trim
            End If
            editDate_txt.Text = DateTime.Now.ToString
        Else
            If Session("Date") <> Nothing Then
                editDate_txt.Text = Session("Date")
                Session("Date") = Nothing
            Else
                editDate_txt.Text = ""
            End If
        End If
    End Sub

    Public Function isNowChecked(ByVal theDate As DateTime) As Boolean
        Return IIf(theDate = DateTime.Now, True, False)
    End Function

    Protected Sub onOkClick(ByVal sender As Object, ByVal e As System.EventArgs)
        changed_mpExt.Hide()
    End Sub

    Protected Sub showChangedResult(ByVal inserted As Boolean)
        changed_lit.Text = "<h3>Successful " & IIf(inserted, "Addition", "Update") & "</h3><p class='ResultStyle'><b>" & Session("RecentItem") & "</b> has been successfully " & IIf(inserted, "added", "modified") & ".</p>"
        changed_updatePnl.Update()
        changed_mpExt.Show()
    End Sub

    Protected Sub item_fv_ModeChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles item_fv.ModeChanged
        If item_fv.DefaultMode = FormViewMode.ReadOnly Then
            If Session("FromUpdated") Then
                showChangedResult(False)
                Session("FromUpdated") = Nothing
            ElseIf Session("FromInserted") Then
                showChangedResult(True)
                Session("FromInserted") = Nothing
            Else
                Session("FirstLoad") = True
            End If
        End If
    End Sub

    Public Sub validateDate(ByVal sender As Object, ByVal args As ServerValidateEventArgs)
        Dim dt As DateTime
        args.IsValid = DateTime.TryParse(args.Value, dt)
    End Sub

End Class
