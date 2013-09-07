Imports System.IO
Imports AjaxControlToolkit
Imports System.Drawing
Imports System.Data
Imports System.Data.SqlClient

Partial Class EditScreenshot_old
    Inherits System.Web.UI.Page

    Dim oConn As New SqlConnection(ConfigurationManager.ConnectionStrings.Item("ProjectConnectionString").ConnectionString)
    Dim oCmd As New SqlCommand
    Dim strSQL As String = ""
    Dim oParam As New SqlParameter

    Private screensDir As String
    Private msgScript As String
    Private wasResized As Boolean = False

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        screensDir = Page.MapPath("..") & "\screens\"

        If Not IsPostBack Then

            If Session("SelectedImage") = 0 Then
                image_fv.DefaultMode = FormViewMode.Insert
            End If

            If image_fv.DefaultMode = FormViewMode.ReadOnly Then
                Session("TheProject") = CType(image_fv.FindControl("project_lbl"), Label).Text
                Session("ThePath") = getImagePath(Session("SelectedImage"))
            Else
                Session("TheProject") = Nothing
                Session("ThePath") = Nothing
            End If

        End If

        Session("FromInserted") = Nothing
        Session("FromUpdated") = Nothing
        Session("FromDeleted") = Nothing
        Session("RecentImage") = Nothing

        Session("Resized") = Nothing

    End Sub

    Protected Sub list_lBtn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles list_lBtn.Click
        Response.Redirect("ManageScreenshots.aspx")
    End Sub

    Protected Sub image_fv_ItemCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewCommandEventArgs) Handles image_fv.ItemCommand
        If e.CommandName = "Cancel" Then
            Response.Redirect("ManageScreenshots.aspx")
        End If
    End Sub


    Protected Sub image_fv_ItemDeleted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewDeletedEventArgs) Handles image_fv.ItemDeleted
        Session("RecentImage") = New String() {Session("ThePath"), Session("TheProject")}
        Session("FromDeleted") = True

        Response.Redirect("ManageScreenshots.aspx")
    End Sub


    Protected Sub image_fv_ItemDeleting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewDeleteEventArgs) Handles image_fv.ItemDeleting
        If File.Exists(screensDir & Session("ThePath")) Then
            File.Delete(screensDir & Session("ThePath"))
        End If
    End Sub

    Protected Sub image_fv_ItemInserted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewInsertedEventArgs) Handles image_fv.ItemInserted
        Session("FromInserted") = True
        Session("RecentImage") = New String() {e.Values("Path"), Session("TheProject")}
        image_fv.DefaultMode = FormViewMode.ReadOnly
    End Sub

    Protected Sub image_fv_ItemUpdated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewUpdatedEventArgs) Handles image_fv.ItemUpdated
        Session("FromUpdated") = True
        Session("RecentImage") = New String() {e.NewValues("Path"), Session("TheProject")}

        image_fv.DefaultMode = FormViewMode.ReadOnly
    End Sub

    Protected Sub image_fv_ItemInserting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewInsertEventArgs) Handles image_fv.ItemInserting

        Dim fileCounter As Integer = 1
        Dim imgUploader As FileUpload = CType(image_fv.FindControl("img_uploader"), FileUpload)


        Try
            If imgUploader.HasFile Then

                Dim ext As String = System.IO.Path.GetExtension(imgUploader.FileName)
                Dim newName As String = stripBadChars(System.IO.Path.GetFileNameWithoutExtension(imgUploader.FileName)) & ext

                If imgUploader.PostedFile.ContentLength > 2097152 Then
                    Throw New ArgumentException("The image must be under 2 MB in size.")
                End If

                If ext <> ".jpg" And ext <> ".gif" And ext <> ".png" Then
                    Throw New ArgumentException("The image must be in either JPG, GIF, or PNG format.")
                End If

                While File.Exists(screensDir & newName)
                    newName = stripBadChars(System.IO.Path.GetFileNameWithoutExtension(imgUploader.FileName)) & "_" & fileCounter.ToString & ext
                    fileCounter += 1
                End While

                imgUploader.SaveAs(screensDir & newName)

                Dim pendingImg As Image = getImage(screensDir & newName)
                If pendingImg.Width < 600 Then
                    File.Delete(screensDir & newName)
                    Throw New ArgumentException("Image must be at least 600px wide.")
                End If

                If CType(image_fv.FindControl("resize_cbx"), CheckBox).Checked Then
                    resizeImage(screensDir & newName, 600)
                End If

                e.Values("Path") = newName
                e.Values("Resized") = wasResized
                e.Values("ProjectID") = insertProject_ddl.SelectedValue
                Session("TheProject") = getProjectForImage(e.Values("ProjectID"))
                Session("ThePath") = e.Values("Path")

            Else
                Throw New ArgumentException("Please choose an image to upload.")
            End If
        Catch ex As ArgumentException
            msgScript = "<script language='javascript'>" & _
                                           "alert('Error updating record:\n\n" & ex.Message & "');" & _
                                           "</script>"
            Page.ClientScript.RegisterStartupScript(Me.GetType(), "msgScript", msgScript)
            e.Cancel = True

        Catch ex As Exception
            msgScript = "<script language='javascript'>" & _
                        "alert('Uh oh. Error updating record.');" & _
                        "</script>"

            Page.ClientScript.RegisterStartupScript(Me.GetType(), "msgScript", msgScript)
            e.Cancel = True
        End Try

    End Sub


    Protected Sub image_fv_ItemUpdating(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewUpdateEventArgs) Handles image_fv.ItemUpdating

        Dim imgUploader As FileUpload = CType(image_fv.FindControl("img_uploader"), FileUpload)
        Dim project_ddl As DropDownList = CType(image_fv.FindControl("project_ddl"), DropDownList)
        Dim fileCounter As Integer = 0

        Try

            If imgUploader.HasFile Then
                Dim ext As String = System.IO.Path.GetExtension(imgUploader.FileName)
                Dim newName As String = stripBadChars(System.IO.Path.GetFileNameWithoutExtension(imgUploader.FileName)) & ext

                If File.Exists(screensDir & e.OldValues("Path")) Then
                    File.Delete(screensDir & e.OldValues("Path"))
                End If

                If imgUploader.PostedFile.ContentLength > 2097152 Then
                    Throw New ArgumentException("The image must be under 2 MB in size.")
                End If

                If ext <> ".jpg" And ext <> ".gif" And ext <> ".png" Then
                    Throw New ArgumentException("The image must be in either JPG, GIF, or PNG format.")
                End If

                While File.Exists(screensDir & newName)
                    newName = stripBadChars(imgUploader.FileName) & "_" & fileCounter.ToString & ext
                    fileCounter += 1
                End While

                imgUploader.SaveAs(screensDir & newName)

                Dim pendingImg As Image = getImage(screensDir & newName)
                If pendingImg.Width < 600 Then
                    File.Delete(screensDir & newName)
                    Throw New ArgumentException("Image must be at least 600px wide.")
                End If

                If CType(image_fv.FindControl("resize_cbx"), CheckBox).Checked Then
                    resizeImage(screensDir & newName, 600)
                End If

                e.NewValues("Path") = newName

            Else
                e.NewValues("Path") = e.OldValues("Path")

                If CType(image_fv.FindControl("resize_cbx"), CheckBox).Checked Then
                    resizeImage(screensDir & e.NewValues("Path"), 600)
                End If

            End If

            e.NewValues("Resized") = wasResized
            e.NewValues("ProjectID") = project_ddl.SelectedValue
            Session("TheProject") = getProjectForImage(e.NewValues("ProjectID"))
            Session("ThePath") = e.NewValues("Path")

        Catch ex As ArgumentException
            msgScript = "<script language='javascript'>" & _
                                           "alert('Error updating record:\n\n" & ex.Message & "');" & _
                                           "</script>"
            Page.ClientScript.RegisterStartupScript(Me.GetType(), "msgScript", msgScript)
            e.Cancel = True

        Catch ex As Exception
            msgScript = "<script language='javascript'>" & _
                        "alert('Uh oh. Error updating record.');" & _
                        "</script>"

            Page.ClientScript.RegisterStartupScript(Me.GetType(), "msgScript", msgScript)
            e.Cancel = True
        End Try

    End Sub

    Protected Sub onCloseClick(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim mpExt As ModalPopupExtender = CType(image_fv.FindControl("img_mpExt"), ModalPopupExtender)
        mpExt.Hide()
    End Sub

    Protected Sub showImg(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim mpExt As ModalPopupExtender = CType(image_fv.FindControl("img_mpExt"), ModalPopupExtender)
        Dim theImage As String
        Dim img As Image = Nothing
        Dim sizeStr As String
        Dim newDims As Size
        Dim imgInfo As FileInfo

        theImage = getImagePath(Session("SelectedImage"))

        img = getImage(screensDir & theImage)
        newDims = getResizedDimensions(img, 600)

        screenshot_img.Height = newDims.Height
        screenshot_img.Width = newDims.Width

        imgInfo = New FileInfo(screensDir & theImage)
        sizeStr = IIf(imgInfo.Length >= 1048576, Math.Round(imgInfo.Length / 1024, 2) & "MB", Math.Round(imgInfo.Length / 1024, 2) & "KB")

        img_lit.Text = "<p>File Name: <b>" & theImage & "</b><br />File Size: <b>" & sizeStr & "</b><br />Dimensions: <b>" & img.Width & " x " & img.Height & "</b></p>"

        mpExt.Show()

    End Sub

    Protected Function getImagePath(ByVal id As Integer) As String
        Try
            oCmd.Connection = oConn
            oCmd.CommandType = CommandType.Text

            strSQL = "SELECT Path FROM Images WHERE ID = @ID"

            oCmd.Parameters.Clear()

            oParam = New SqlParameter
            oParam.ParameterName = "ID"
            oParam.SqlDbType = SqlDbType.Int
            oParam.Value = id
            oCmd.Parameters.Add(oParam)

            oCmd.CommandText = strSQL
            oCmd.Connection.Open()

            Return oCmd.ExecuteScalar()

        Catch ex As Exception
            Throw ex
        Finally
            If oConn.State = ConnectionState.Open Then
                oConn.Close()
            End If
            oCmd.Dispose()
            oConn.Dispose()
        End Try

    End Function

    Protected Sub onEditProjectDDLLoad(ByVal sender As Object, ByVal e As System.EventArgs)
        If Session("FirstLoad") Then
            Try
                oCmd.Connection = oConn
                oCmd.CommandType = CommandType.Text

                strSQL = "SELECT ProjectID FROM Images WHERE ID = @ID"

                oParam = New SqlParameter()
                oParam.ParameterName = "ID"
                oParam.SqlDbType = SqlDbType.Int
                oParam.Value = Session("SelectedImage")
                oCmd.Parameters.Add(oParam)

                oCmd.CommandText = strSQL

                oCmd.Connection.Open()

                CType(sender, DropDownList).SelectedValue = oCmd.ExecuteScalar()

                Session("FirstLoad") = Nothing

            Catch ex As Exception
                Throw ex
            Finally
                If oConn.State = ConnectionState.Open Then
                    oConn.Close()
                End If
                oCmd.Dispose()
                oConn.Dispose()
            End Try


        End If
    End Sub


    Private Sub resizeImage(ByVal img As String, ByVal maxDim As Integer)
        Dim image As Image = getImage(img)

        'This check ensures that the resizing will only be done if the width is greater than the max dimension, and
        'that the resized field only gets set if the resize takes place
        If image.Width > maxDim Then

            Dim newSize As Size = getResizedDimensions(image, maxDim)

            Dim newImgRect As Rectangle = New Rectangle(0, 0, newSize.Width, newSize.Height)
            Dim newImgBMP As Bitmap = New Bitmap(newSize.Width, newSize.Height)
            Dim newImgGraphics As Graphics = Graphics.FromImage(newImgBMP)

            newImgGraphics.CompositingQuality = Drawing2D.CompositingQuality.HighQuality
            newImgGraphics.SmoothingMode = Drawing2D.SmoothingMode.HighQuality
            newImgGraphics.InterpolationMode = Drawing2D.InterpolationMode.HighQualityBicubic

            newImgGraphics.DrawImage(image, newImgRect)

            Dim toFS As FileStream = New FileStream(img, FileMode.Create)

            newImgBMP.Save(toFS, image.RawFormat)

            toFS.Close()

            newImgBMP.Dispose()
            newImgGraphics.Dispose()
            image.Dispose()

            wasResized = True
            Session("Resized") = True

        End If

    End Sub


    Private Function getImage(ByVal imgStr As String) As Image
        Dim fs As FileStream = New FileStream(imgStr, FileMode.Open)
        Dim img As Image = Image.FromStream(fs)
        fs.Close()
        Return img
    End Function

    Private Function getResizedDimensions(ByVal img As Image, ByVal maxDim As Integer) As Size
        Dim newDims As Size

        'Originally set to initial dimensions
        newDims.Height = img.Height
        newDims.Width = img.Width

        If (img.Width > maxDim) Then
            newDims.Width = maxDim
            newDims.Height = img.Height / img.Width * newDims.Width
        ElseIf img.Width > maxDim And img.Height > maxDim And img.Width = img.Height Then
            newDims.Width = maxDim
            newDims.Height = maxDim
        End If

        Return newDims
    End Function

    Public Function isResizeAvailable(ByVal img As Object, ByVal maxDim As Integer) As Boolean
        If Not File.Exists(screensDir & img) Then
            ' Allow for an immediate resize if an image hadn't been uploaded yet
            Return True
        Else
            'If an image has been uploaded, allow resize if the image is beyond the max dimensions
            Dim image As Image = image.FromFile(screensDir & img)
            Return (image.Width > maxDim)
        End If
    End Function

    Private Function stripBadChars(ByVal str As String) As String
        Dim badChars() As Char = {":", "/", "\", """", "*", "?", "<", ">", " ", "."}

        For i As Integer = 0 To badChars.Length - 1
            If str.Contains(badChars(i)) Then
                str = str.Replace(badChars(i), "_")
            End If
        Next
        Return str
    End Function


    Private Function getProjectForImage(ByVal id As Integer) As String

        Try
            oCmd.Connection = oConn
            oCmd.CommandType = CommandType.Text

            strSQL = "SELECT ProjectName FROM Projects WHERE ID = @ID"

            oCmd.Parameters.Clear()

            oParam = New SqlParameter()
            oParam.ParameterName = "ID"
            oParam.SqlDbType = SqlDbType.Int
            oParam.Value = id
            oCmd.Parameters.Add(oParam)

            oCmd.CommandText = strSQL
            oCmd.Connection.Open()
            Return oCmd.ExecuteScalar()

        Catch ex As Exception
            Throw ex
        Finally
            If oConn.State = ConnectionState.Open Then
                oConn.Close()
            End If
            oCmd.Dispose()
            oConn.Dispose()
        End Try
    End Function

    Private Sub showChangedResult(ByVal inserted As Boolean)
        Dim recentArr() As String = Session("RecentImage")
        changed_lit.Text = "<h3>Successful " & IIf(inserted, "Addition", "Update") & "</h3><p class='ResultStyle'>The screenshot, <b>" & recentArr(0) & "</b>, for <b>" & recentArr(1) & "</b> has been successfully " & IIf(inserted, "added", "modified") & ".</p>" & IIf(Session("Resized"), "<p>The image has been resized.</p>", "")
        changed_updatePnl.Update()
        changed_mpExt.Show()
    End Sub


    Public Function formatNullText(ByVal f As Object) As String
        Return IIf(f Is DBNull.Value, "<i>Not specified.</i>", f)
    End Function

    Public Function formatImgText(ByVal img As Object, ByVal resized As Object) As String
        Return img & IIf(resized, " <span style='color: #9c9172; font-style:italic;'>[Resized]</span>", "")
    End Function

    Public Function formatResizeText(ByVal img As Object) As String
        Return "<p class='smallNote'>" & IIf(img IsNot DBNull.Value, "The current image can be resized.", "If this box is checked, the image will be resized if its width is over 600px.") & "</p>"
    End Function

    Protected Sub image_sds_Inserted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.SqlDataSourceStatusEventArgs) Handles image_sds.Inserted
        Session("SelectedImage") = CType(e.Command.Parameters("@NewID").Value, Integer)
    End Sub

    Protected Sub image_fv_ModeChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles image_fv.ModeChanged
        If image_fv.DefaultMode = FormViewMode.ReadOnly Then
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

    Protected Sub onOkClick(ByVal sender As Object, ByVal e As System.EventArgs)
        changed_mpExt.Hide()
    End Sub

End Class
