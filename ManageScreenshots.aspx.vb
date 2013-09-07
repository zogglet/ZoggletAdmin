Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.IO


Partial Class ManageScreenshots
    Inherits System.Web.UI.Page

    Dim oConn As New SqlConnection(ConfigurationManager.ConnectionStrings("ProjectConnectionString").ConnectionString)
    Dim oCmd As New SqlCommand
    Dim oParam As SqlParameter
    Dim oDA As New SqlDataAdapter
    Dim oDTbl As New DataTable
    Dim strSQL As String

    Dim dv As DataView
    Private Const ASCENDING As String = " ASC"
    Private Const DESCENDING As String = " DESC"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then

            If Session("Category") IsNot Nothing Then
                category_ddl.SelectedValue = Session("Category")
            End If
            If Session("Project") IsNot Nothing Then
                project_ddl.SelectedValue = Session("Project")
            End If

            bindProjects(True)

        Else
            Session("Category") = IIf(category_ddl.SelectedValue = -1, Nothing, category_ddl.SelectedValue)
            Session("Project") = IIf(project_ddl.SelectedValue = -1, Nothing, project_ddl.SelectedValue)
        End If

        If Session("FromDeleted") Then
            Dim recentArr() As String = Session("RecentImage")
            deleted_lit.Text = "<h3>Successful Deletion</h3><p class='ResultStyle'>The screenshot, <b>" & recentArr(0) & "</b>, for <b>" & recentArr(1) & "</b> has been successfully deleted.</p>"
            deleted_updatePnl.Update()
            deleted_mpExt.Show()
            Session("FromDeleted") = Nothing
        End If

    End Sub

    Protected Sub bindProjects(ByVal all As Boolean)

        Try

            oCmd.Connection = oConn
            oCmd.CommandType = CommandType.Text

            strSQL = "SELECT -1 AS ID, '-- All --' AS ProjectName, -1 as CategoryID UNION SELECT ID, ProjectName, CategoryID FROM Projects"

            oCmd.Parameters.Clear()
            oDTbl.Clear()

            If Not all Then

                If Session("Category") IsNot Nothing Then
                    strSQL &= " WHERE CategoryID = @Category"

                    oParam = New SqlParameter
                    oParam.ParameterName = "Category"
                    oParam.SqlDbType = SqlDbType.Int
                    oParam.Value = Session("Category")
                    oCmd.Parameters.Add(oParam)
                End If

            End If

            strSQL &= " ORDER BY ID"

            oCmd.CommandText = strSQL
            oDA.SelectCommand = oCmd
            oDA.Fill(oDTbl)

            project_ddl.DataSource = oDTbl
            project_ddl.DataBind()

            bindGridview(all)

        Catch ex As Exception
            Throw ex
        End Try

    End Sub

    Protected Sub bindGridview(ByVal all As Boolean)

        Try

            oCmd.Connection = oConn
            oCmd.CommandType = CommandType.Text

            strSQL = "SELECT Screenshots.*, Projects.ProjectName FROM Projects INNER JOIN Screenshots ON Projects.ID = Screenshots.ProjectID"

            oCmd.Parameters.Clear()
            oDTbl.Clear()

            If Not all Then

                If Session("Category") IsNot Nothing Then
                    strSQL &= " WHERE Projects.CategoryID = @CategoryID"

                    oParam = New SqlParameter
                    oParam.ParameterName = "CategoryID"
                    oParam.SqlDbType = SqlDbType.Int
                    oParam.Value = Session("Category")
                    oCmd.Parameters.Add(oParam)
                End If

                If Session("Project") IsNot Nothing Then
                    strSQL &= andOrWhere(strSQL)
                    strSQL &= " Screenshots.ProjectID = @ProjectID"

                    oParam = New SqlParameter
                    oParam.ParameterName = "ProjectID"
                    oParam.SqlDbType = SqlDbType.Int
                    oParam.Value = Session("Project")
                    oCmd.Parameters.Add(oParam)
                End If

            End If

            strSQL &= " ORDER BY ProjectName"

            oCmd.CommandText = strSQL
            oDA.SelectCommand = oCmd
            oDA.Fill(oDTbl)

            Session("ImageList") = oDTbl

            images_gv.DataSource = oDTbl
            images_gv.DataBind()

            noData_lit.Text = IIf(oDTbl.Rows.Count = 0, "<span class='NoDataStyle'>There are no current images for that selection.</span>", "<span class='UnderGVStyle'>Items marked with <span class='ResizableStyle'>[*]</span> can be resized.</span>")

        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Protected Sub sortGV(ByVal se As String, ByVal dir As String)
        dv = New DataView(CType(Session("ImageList"), DataTable))
        dv.Sort = se & dir
        images_gv.DataSource = dv
        images_gv.DataBind()
    End Sub

    Protected Function andOrWhere(ByVal str As String) As String
        Return IIf(InStr(str, "WHERE"), " AND", " WHERE")
    End Function


    Protected Function truncateStr(ByVal str As Object) As String
        If str.Length > 50 Then
            str = str.Substring(0, 44) & " [...]"
        End If
        Return str
    End Function

    Protected Sub category_ddl_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles category_ddl.SelectedIndexChanged
        Dim ddl As DropDownList = CType(sender, DropDownList)
        Session("Category") = IIf(ddl.SelectedValue = -1, Nothing, ddl.SelectedValue)
        bindProjects(False)
    End Sub


    Protected Sub project_ddl_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles project_ddl.SelectedIndexChanged
        Dim ddl As DropDownList = CType(sender, DropDownList)
        Session("Project") = IIf(ddl.SelectedValue = -1, Nothing, ddl.SelectedValue)
        bindGridview(False)
    End Sub

    Public Function formatCaption(ByVal caption As Object) As String
        Dim str As String = ""
        If caption IsNot DBNull.Value Then
            str = "<i>" & truncateStr(caption) & "</i>"
        Else
            str = "<i>(No caption)</i>"
        End If
        Return str
    End Function

    Public Function formatTooltipText(ByVal proj As Object, ByVal caption As Object) As String
        Return "<b>" & proj & ":</b>" & IIf(caption IsNot DBNull.Value, "<br />" & caption, "")
    End Function

    Public Function formatImage(ByVal id As Object, ByVal title As Object, ByVal resized As Object) As String
        Dim image As Image = getImageFromBytes(getBinaryImage(id))
        Dim returnStr As String = ""

        If resized Then
            returnStr = title & " <span style='color: #9c9172;'>[Resized]</span>"
        ElseIf image.Width > 600 Then
            returnStr = title & " <span class='ResizableStyle'>[*]</span>"
        Else
            returnStr = title
        End If
        Return returnStr
    End Function


    Private Function getBinaryImage(ByVal id As Integer) As Byte()

        Try
            oCmd.Connection = oConn
            oCmd.CommandType = CommandType.Text

            strSQL = "SELECT ImageData FROM Screenshots WHERE ID = @ID"

            oCmd.Parameters.Clear()

            oParam = New SqlParameter
            oParam.ParameterName = "ID"
            oParam.SqlDbType = SqlDbType.Int
            oParam.Value = id
            oCmd.Parameters.Add(oParam)

            oCmd.CommandText = strSQL

            oCmd.Connection.Open()
            Dim reader As SqlDataReader = oCmd.ExecuteReader()
            reader.Read()

            Return CType(reader("ImageData"), Byte())

        Catch ex As Exception
            Throw ex
        Finally
            If oConn.State = ConnectionState.Open Then
                oConn.Close()
            End If

            oCmd.Dispose()
        End Try

    End Function

    Private Function getImageFromBytes(ByVal bytes As Byte()) As Image
        Dim ms As MemoryStream = New MemoryStream(bytes, 0, bytes.Length)
        ms.Write(bytes, 0, bytes.Length)

        Return Image.FromStream(ms)

    End Function

    Public Function isTooltipVisible(ByVal caption As Object) As String
        'Separating each check, since a null value doesn't have a Length property
        If caption Is DBNull.Value Then
            Return False
        ElseIf caption.ToString.Length > 50 Then
            Return True
        End If
        Return False
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

    Protected Sub images_gv_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles images_gv.PageIndexChanging
        images_gv.PageIndex = e.NewPageIndex
        bindGridview(False)
    End Sub

    Protected Sub images_gv_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles images_gv.SelectedIndexChanged
        Session("SelectedImage") = images_gv.SelectedValue
        Session("FirstLoad") = True
        Response.Redirect("EditScreenshot.aspx")
    End Sub

    Protected Sub images_gv_Sorting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSortEventArgs) Handles images_gv.Sorting
        Dim sortExp As String = e.SortExpression

        If gvSortDirection() = SortDirection.Ascending Then
            gvSortDirection() = SortDirection.Descending
            sortGV(sortExp, DESCENDING)
        Else
            gvSortDirection() = SortDirection.Ascending
            sortGV(sortExp, ASCENDING)
        End If
    End Sub

    Protected Sub add_btn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles add_btn.Click
        Session("SelectedImage") = 0
        Response.Redirect("EditScreenshot.aspx")
    End Sub

    Protected Sub onOkClick(ByVal sender As Object, ByVal e As System.EventArgs)
        deleted_mpExt.Hide()
    End Sub
End Class
