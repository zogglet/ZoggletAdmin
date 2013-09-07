Imports System.Data
Imports System.Data.SqlClient


Partial Class ManageChangeLog
    Inherits System.Web.UI.Page

    Dim oConn As New SqlConnection(ConfigurationManager.ConnectionStrings("ProjectConnectionString").ConnectionString)
    Dim oCmd As New SqlCommand
    Dim oParam As SqlParameter
    Dim oDA As New SqlDataAdapter
    Dim oDTbl As New DataTable
    Dim inner_dTbl As New DataTable
    Dim lbl_dTbl As New DataTable
    Dim strSQL As String = ""

    Dim dv As DataView
    Dim innerDv As DataView
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

            Session("SortDir") = SortDirection.Descending

            Session("ItemSortDir") = SortDirection.Descending


            bindProjects(True)

        Else
            Session("Category") = IIf(category_ddl.SelectedValue = -1, Nothing, category_ddl.SelectedValue)
            Session("Project") = IIf(project_ddl.SelectedValue = -1, Nothing, project_ddl.SelectedValue)
        End If

        If Session("FromDeleted") Then
            deleted_lit.Text = "<h3>Successful Deletion</h3><p class='ResultStyle'><b>" & Session("RecentItem") & "</b> has been successfully deleted.</p>"
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

    Protected Sub category_ddl_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles category_ddl.SelectedIndexChanged
        Session("Category") = IIf(category_ddl.SelectedValue = -1, Nothing, category_ddl.SelectedValue)
        bindProjects(False)
    End Sub

    Protected Sub project_ddl_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles project_ddl.SelectedIndexChanged
        Session("Project") = IIf(project_ddl.SelectedValue = -1, Nothing, project_ddl.SelectedValue)
        bindGridview(False)
    End Sub

    Protected Sub bindGridview(ByVal all As Boolean, Optional ByVal order As String = "DESC")

        Try

            oCmd.Connection = oConn
            oCmd.CommandType = CommandType.Text

            'strSQL = "SELECT DISTINCT CONVERT(varchar(10), TheDate, 101) AS TheDate FROM ChangeLogItems"
            'This ensures it is still a DateTime object:
            strSQL = "SELECT DISTINCT DATEADD(day, DATEDIFF(day, 0, TheDate), 0) AS TheDate FROM ChangeLogItems"

            oCmd.Parameters.Clear()
            oDTbl.Clear()

            If Not all Then
                addParams()
            End If

            strSQL &= " ORDER BY TheDate " & order

            oCmd.CommandText = strSQL
            oDA.SelectCommand = oCmd

            oDA.Fill(oDTbl)

            items_gv.DataSource = oDTbl
            items_gv.DataBind()


            If oDTbl.Rows.Count > 0 Then
                noData_lit.Text = ""

                For i As Integer = 0 To oDTbl.Rows.Count - 1

                    If i < items_gv.Rows.Count Then

                        oCmd.Parameters.Clear()
                        inner_dTbl.Clear()

                        strSQL = "SELECT *, ProjectName, CategoryTitle FROM ChangeLogItems INNER JOIN Projects ON ChangeLogItems.ProjectID = Projects.ID INNER JOIN Categories ON ChangeLogItems.CategoryID = Categories.ID " & _
                                "WHERE TheDate BETWEEN DATEADD(day, DATEDIFF(day, 0, @TheDate), 0) AND DateAdd(ss, -1, DateAdd(dd, 1, DATEADD(day, DATEDIFF(day, 0, @TheDate), 0)))"

                        'Accommodate for the proper page index (current page, subsequent pages, last page)
                        oParam = New SqlParameter
                        oParam.ParameterName = "TheDate"
                        oParam.SqlDbType = SqlDbType.DateTime

                        Select Case items_gv.PageIndex
                            Case 0
                                oParam.Value = oDTbl.Rows(i)("TheDate")
                            Case 1 To items_gv.PageCount - 2
                                oParam.Value = oDTbl.Rows(items_gv.Rows.Count + i)("TheDate")
                            Case items_gv.PageCount - 1
                                oParam.Value = oDTbl.Rows(oDTbl.Rows.Count - (oDTbl.Rows.Count Mod items_gv.PageSize) + i)("TheDate")
                        End Select
                        oCmd.Parameters.Add(oParam)

                        If Not all Then
                            addParams()
                        End If

                        strSQL &= " ORDER BY TheDate " & order

                        oCmd.CommandText = strSQL
                        oDA.SelectCommand = oCmd

                        oDA.Fill(inner_dTbl)

                        Dim inner_gv As GridView = CType(items_gv.Rows(i).FindControl("itemsInner_gv"), GridView)
                        inner_gv.DataSource = inner_dTbl
                        inner_gv.DataBind()

                    Else
                        Exit For
                    End If

                Next

            Else
                noData_lit.Text = "<span class='NoDataStyle'>There are no current change log items for that selection.</span>"
            End If

            Session("ItemList") = oDTbl

        Catch ex As Exception
            Throw ex
        End Try

    End Sub

    'Including the LinkButton and full order by clause to accommodate for future use for other items 
    Private Sub bindItems(ByVal sender As Object, ByVal linkButtonID As String, Optional ByVal orderBy As String = "TheDate DESC")
        Dim innerGV As GridView
        Dim theDate As DateTime

        For i As Integer = 0 To items_gv.Rows.Count - 1
            innerGV = CType(items_gv.Rows(i).FindControl("itemsInner_gv"), GridView)

            If innerGV.HeaderRow IsNot Nothing Then
                If sender Is innerGV.HeaderRow.FindControl(linkButtonID) Then

                    theDate = items_gv.DataKeys(i).Values("TheDate")

                    oCmd.Connection = oConn
                    oCmd.CommandType = CommandType.Text

                    oCmd.Parameters.Clear()
                    inner_dTbl.Clear()

                    strSQL = "SELECT *, ProjectName, CategoryTitle FROM ChangeLogItems INNER JOIN Projects ON ChangeLogItems.ProjectID = Projects.ID INNER JOIN Categories ON ChangeLogItems.CategoryID = Categories.ID " & _
                            "WHERE TheDate BETWEEN DATEADD(day, DATEDIFF(day, 0, @TheDate), 0) AND DateAdd(ss, -1, DateAdd(dd, 1, DATEADD(day, DATEDIFF(day, 0, @TheDate), 0)))"

                    oParam = New SqlParameter
                    oParam.ParameterName = "TheDate"
                    oParam.SqlDbType = SqlDbType.DateTime
                    oParam.Value = theDate
                    oCmd.Parameters.Add(oParam)

                    addParams()

                    strSQL &= " ORDER BY " & orderBy

                    oCmd.CommandText = strSQL
                    oDA.SelectCommand = oCmd

                    oDA.Fill(inner_dTbl)

                    innerGV.DataSource = inner_dTbl
                    innerGV.DataBind()


                    Exit For


                End If
            End If
        Next
    End Sub


    Protected Sub addParams(Optional ByVal num As String = "")
        If Session("Category") IsNot Nothing Then
            strSQL &= andOrWhere()
            strSQL &= " ChangeLogItems.CategoryID = @Category" & num

            oParam = New SqlParameter()
            oParam.ParameterName = ("Category" & num).ToString
            oParam.SqlDbType = SqlDbType.Int
            oParam.Value = Session("Category")
            oCmd.Parameters.Add(oParam)
        End If

        If Session("Project") IsNot Nothing Then
            strSQL &= andOrWhere()
            strSQL &= " ChangeLogItems.ProjectID = @Project" & num

            oParam = New SqlParameter()
            oParam.ParameterName = ("Project" & num).ToString
            oParam.SqlDbType = SqlDbType.Int
            oParam.Value = Session("Project")
            oCmd.Parameters.Add(oParam)
        End If

    End Sub

    Protected Function getNumStats(ByVal theDate As Object, ByVal collapsed As Boolean) As String
        Dim numProjects As Integer = 0
        Dim numChanges As Integer = 0

        Try

            oCmd.CommandType = CommandType.Text
            oCmd.Connection = oConn

            strSQL = "SELECT COUNT(*) FROM ChangeLogItems WHERE TheDate BETWEEN Convert(varchar(10), @TheDate2, 101) AND DateAdd(ss, -1, DateAdd(dd, 1, Convert(varchar(10), @TheDate2, 101)))"

            oCmd.Parameters.Clear()
            lbl_dTbl.Clear()

            oParam = New SqlParameter()
            oParam.ParameterName = "TheDate2"
            oParam.SqlDbType = SqlDbType.DateTime
            oParam.Value = CType(theDate, DateTime)
            oCmd.Parameters.Add(oParam)

            addParams("2")

            oCmd.CommandText = strSQL

            oCmd.Connection.Open()
            numChanges = oCmd.ExecuteScalar()

            strSQL = "SELECT DISTINCT ProjectID FROM ChangeLogItems WHERE TheDate BETWEEN Convert(varchar(10), @TheDate3, 101) AND DateAdd(ss, -1, DateAdd(dd, 1, Convert(varchar(10), @TheDate3, 101)))"

            oParam = New SqlParameter()
            oParam.ParameterName = "TheDate3"
            oParam.SqlDbType = SqlDbType.DateTime
            oParam.Value = CType(theDate, DateTime)
            oCmd.Parameters.Add(oParam)

            addParams("3")

            oCmd.CommandText = strSQL

            oDA.SelectCommand = oCmd

            oDA.Fill(lbl_dTbl)

            numProjects = lbl_dTbl.Rows.Count

            Return IIf(collapsed, "View ", "Hide ") & numChanges & " Changes in " & numProjects & " Projects"

        Catch ex As Exception
            Throw ex
        Finally
            If oConn.State = ConnectionState.Open Then
                oConn.Close()
            End If
            oCmd.Dispose()
        End Try

    End Function

    Protected Function andOrWhere() As String
        Return IIf(InStr(strSQL, "WHERE"), " AND", " WHERE")
    End Function

    Public Function formatDateText(ByVal d As DateTime) As String

        Dim startOfWeek As DateTime = DateTime.Today.AddDays(-7)
        Return IIf(d <= DateTime.Now And d > startOfWeek, "<span class='RecentStyle'>" & d.ToShortDateString & "</span>", d.ToShortDateString)

    End Function

    Public Function formatItemContent(ByVal c As String) As String
        Return "<i>" & truncateStr(c) & "</i>"
    End Function

    Protected Function truncateStr(ByVal str As String) As String
        If str.Length > 100 Then
            str = str.Substring(0, 94) & " [...]"
        End If
        Return str
    End Function

    Public Function formatTooltipText(ByVal d As DateTime, ByVal desc As String) As String
        Return "<b>" & d.ToShortDateString & ", " & d.ToShortTimeString & ":</b><br />" & desc
    End Function

    Public Function isTooltipVisible(ByVal desc As String) As Boolean
        Return IIf(desc.Length > 100, True, False)
    End Function


    Protected Sub dateSort_click(ByVal sender As Object, ByVal e As System.EventArgs)

        If Session("SortDir") = SortDirection.Descending Then
            Session("SortDir") = SortDirection.Ascending
            bindGridview(False, "ASC")
        ElseIf Session("SortDir") = SortDirection.Ascending Then
            Session("SortDir") = SortDirection.Descending
            bindGridview(False, "DESC")
        End If

        items_updatePnl.Update()

    End Sub

    Protected Sub projectSort_click(ByVal sender As Object, ByVal e As System.EventArgs)
        If Session("ItemSortDir") = SortDirection.Descending Then
            Session("ItemSortDir") = SortDirection.Ascending
            bindItems(sender, "projSort_lBtn", "ProjectID ASC")
        ElseIf Session("ItemSortDir") = SortDirection.Ascending Then
            Session("ItemSortDir") = SortDirection.Descending
            bindItems(sender, "projSort_lBtn", "ProjectID DESC")
        End If

        items_updatePnl.Update()
    End Sub

    Protected Sub items_gv_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles items_gv.PageIndexChanging
        items_gv.PageIndex = e.NewPageIndex
        bindGridview(False)
    End Sub


    Protected Sub innerGVSelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Session("SelectedItem") = CType(sender, GridView).SelectedValue
        Session("FirstLoad") = True
        Response.Redirect("EditChangeLog.aspx")
    End Sub

    Protected Sub add_btn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles add_btn.Click
        Session("SelectedItem") = 0
        Response.Redirect("EditChangeLog.aspx")
    End Sub

    Protected Sub onOkClick(ByVal sender As Object, ByVal e As System.EventArgs)
        deleted_mpExt.Hide()
    End Sub

End Class
