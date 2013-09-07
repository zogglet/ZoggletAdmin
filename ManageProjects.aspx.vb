Imports System.Data
Imports System.Data.SqlClient

Partial Class ManageProjects
    Inherits System.Web.UI.Page

    Dim oConn As New SqlConnection(ConfigurationManager.ConnectionStrings("ProjectConnectionString").ConnectionString)
    Dim oCmd As New SqlCommand
    Dim oParam As SqlParameter
    Dim oDA As New SqlDataAdapter
    Dim oDTbl As New DataTable
    Dim strSQL As String = ""

    Dim dv As DataView
    Private Const ASCENDING As String = " ASC"
    Private Const DESCENDING As String = " DESC"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then

            If Session("Category") IsNot Nothing Then
                category_ddl.SelectedValue = Session("Category")
            End If

            bindGridview(True)
        Else
            Session("Category") = Nothing
        End If

        If Session("FromDeleted") Then
            deleted_lit.Text = "<h3>Successful Deletion</h3><p class='ResultStyle'>The project, <b>" & Session("RecentProject") & "</b>, has been successfully deleted.</p>"
            deleted_mpExt.show()
            Session("FromDeleted") = Nothing
        End If
    End Sub

    Protected Sub bindGridview(ByVal all As Boolean)
        Try

            oCmd.Connection = oConn
            oCmd.CommandType = CommandType.Text

            strSQL = "SELECT *, CategoryTitle FROM Projects INNER JOIN Categories on Projects.CategoryID = Categories.ID"

            If Not all Then
                If Session("Category") IsNot Nothing Then

                    strSQL &= " WHERE Projects.CategoryID = @Category"

                    oParam = New SqlParameter()
                    oParam.ParameterName = "Category"
                    oParam.SqlDbType = SqlDbType.Int
                    oParam.Value = Session("Category")
                    oCmd.Parameters.Add(oParam)
                End If

            End If

            strSQL &= " ORDER BY CategoryID"

            oCmd.CommandText = strSQL
            oDA.SelectCommand = oCmd

            oDA.Fill(oDTbl)


            If oDTbl.Rows.Count = 0 Then
                noData_lit.Text = "<span class='NoDataStyle'>There are no current projects for that selection.</span>"
            Else
                noData_lit.Text = ""
            End If

            projects_gv.DataSource = oDTbl
            projects_gv.DataBind()

            Session("ItemList") = oDTbl

        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Protected Sub category_ddl_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles category_ddl.SelectedIndexChanged
        Session("Category") = IIf(category_ddl.SelectedValue = -1, Nothing, category_ddl.SelectedValue)
        bindGridview(False)
    End Sub

    Public Function formatDescription(ByVal desc As Object) As String
        Dim str As String = ""
        If desc IsNot DBNull.Value Then
            str = "<b>Description:</b><br /><i>" & truncateStr(desc, 100) & "</i>"
        Else
            str = "<i>No description</i>"
        End If
        Return str
    End Function

    Protected Function truncateStr(ByVal str As String, ByVal maxLength As Integer) As String
        If str.Length > maxLength Then
            str = str.Substring(0, maxLength) & " [...]"
        End If

        Return str
    End Function

    Public Property gvSortDirection() As SortDirection
        Get
            If ViewState("sortDirection") Is DBNull.Value Then
                ViewState("sortDirection") = SortDirection.Ascending
                Return CType(ViewState("sortDirection"), SortDirection)
            End If
        End Get
        Set(ByVal value As SortDirection)
            ViewState("sortDirection") = value
        End Set
    End Property

    Private Sub sortGV(ByVal se As String, ByVal dir As String)
        dv = New DataView(CType(Session("ItemList"), DataTable))
        dv.Sort = se & dir
        projects_gv.DataSource = dv
        projects_gv.DataBind()
    End Sub

    Protected Sub onSorting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSortEventArgs) Handles projects_gv.Sorting

        Dim sortExp As String = e.SortExpression

        If (gvSortDirection() = SortDirection.Ascending) Then
            gvSortDirection() = SortDirection.Descending
            sortGV(sortExp, DESCENDING)
        Else
            gvSortDirection() = SortDirection.Ascending
            sortGV(sortExp, ASCENDING)
        End If

    End Sub

    Protected Sub projects_gv_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles projects_gv.SelectedIndexChanged
        Session("SelectedProject") = projects_gv.SelectedValue
        Response.Redirect("EditProject.aspx")
    End Sub

    Protected Sub add_btn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles add_btn.Click
        Session("SelectedProject") = 0
        Response.Redirect("EditProject.aspx")
    End Sub

    Protected Sub onOkClick(ByVal sender As Object, ByVal e As System.EventArgs)
        deleted_mpExt.hide()
    End Sub

End Class
