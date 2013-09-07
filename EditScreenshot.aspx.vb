Imports System.IO
Imports AjaxControlToolkit
Imports System.Drawing
Imports System.Data
Imports System.Data.SqlClient

Partial Class EditScreenshot
    Inherits System.Web.UI.Page

    Dim oConn As New SqlConnection(ConfigurationManager.ConnectionStrings("ProjectConnectionString").ConnectionString)
    Dim oCmd As New SqlCommand
    Dim strSQL As String = ""
    Dim oParam As New SqlParameter

    Private msgScript As String
    Private wasResized As Boolean = False

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then

            If Session("SelectedImage") = 0 Then
                image_fv.ChangeMode(FormViewMode.Insert)
            End If

            If image_fv.CurrentMode = FormViewMode.ReadOnly Then
                Session("TheProject") = CType(image_fv.FindControl("project_lbl"), Label).Text
                Session("ImageTitle") = getImageTitle(Session("SelectedImage"))
            Else
                Session("TheProject") = Nothing
                Session("ThePath") = Nothing
            End If
        Else
            generatePreviewImg(Session("SelectedImage"))

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

    Protected Sub image_fv_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles image_fv.DataBound
        setPostbackTriggers()

        generatePreviewImg(Session("SelectedImage"))
    End Sub


    Private Sub generatePreviewImg(ByVal id As Integer)
        If image_fv.CurrentMode <> FormViewMode.Insert Then
            Dim pnl As Panel = CType(image_fv.FindControl("previewImg_pnl"), Panel)
            Dim newDims As Size = getResizedDimensions(getImageFromBytes(getBinaryImage(Session("SelectedImage"))), 400)

            Dim imgStr As String = "<a href='DisplayImage.aspx?ID=" & id & "' target='_blank'><img src='DisplayImage.aspx?ID=" & Session("SelectedImage") & "' class='ImageStyle' width='" & newDims.Width & "' height='" & newDims.Height & "' /></a>"

            pnl.Controls.Add(New LiteralControl(imgStr))
        End If

    End Sub
    Protected Sub image_fv_ItemCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewCommandEventArgs) Handles image_fv.ItemCommand
        If e.CommandName = "Cancel" Then
            Response.Redirect("ManageScreenshots.aspx")
        End If
    End Sub


    Protected Sub image_fv_ItemDeleted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewDeletedEventArgs) Handles image_fv.ItemDeleted
        Session("RecentImage") = New String() {Session("ImageTitle"), Session("TheProject")}
        Session("FromDeleted") = True

        Response.Redirect("ManageScreenshots.aspx")
    End Sub

    Protected Sub image_fv_ItemInserted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewInsertedEventArgs) Handles image_fv.ItemInserted
        Session("FromInserted") = True
        Session("RecentImage") = New String() {e.Values("ImageTitle"), Session("TheProject")}
        image_fv.ChangeMode(FormViewMode.ReadOnly)
    End Sub

    Protected Sub image_fv_ItemUpdated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewUpdatedEventArgs) Handles image_fv.ItemUpdated
        Session("FromUpdated") = True
        Session("RecentImage") = New String() {e.NewValues("ImageTitle"), Session("TheProject")}

        image_fv.ChangeMode(FormViewMode.ReadOnly)
    End Sub

    Protected Sub image_fv_ItemInserting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewInsertEventArgs) Handles image_fv.ItemInserting

        Dim imgUploader As FileUpload = CType(image_fv.FindControl("img_uploader"), FileUpload)
        Dim resize_cbx As CheckBox = CType(image_fv.FindControl("resize_cbx"), CheckBox)
        Dim project_ddl As DropDownList = CType(image_fv.FindControl("insertProject_ddl"), DropDownList)
        Dim MIMEType As String = ""

        Try
            If imgUploader.HasFile Then

                Dim ext As String = Path.GetExtension(imgUploader.PostedFile.FileName).ToLower()

                If imgUploader.PostedFile.ContentLength > 2097152 Then
                    Throw New ArgumentException("The image must be under 2 MB in size.")
                End If

                Select Case ext
                    Case ".gif"
                        MIMEType = "image/gif"
                    Case ".jpg"
                        MIMEType = "image/jpeg"
                    Case ".png"
                        MIMEType = "image/png"
                    Case Else
                        Throw New ArgumentException("Image must be in either GIF, JPG or PNG format.")
                End Select

                Dim imageBytes(imgUploader.PostedFile.InputStream.Length) As Byte
                imgUploader.PostedFile.InputStream.Read(imageBytes, 0, imageBytes.Length)

                If resize_cbx.Checked Then
                    e.Values("ImageData") = resizeImage(imageBytes, MIMEType, 600)
                Else
                    e.Values("ImageData") = imageBytes
                End If

                e.Values("MIMEType") = MIMEType
                e.Values("Resized") = wasResized
                e.Values("ProjectID") = project_ddl.SelectedValue
                Session("TheProject") = getProjectForImage(e.Values("ProjectID"))
                Session("ImageTitle") = e.Values("ImageTitle")

            Else
                Throw New ArgumentException("Please choose an image to upload.")
            End If
        Catch ex As ArgumentException
            msgScript = "<script language='javascript'>" & _
                       "alert('Error inserting record:\n\n" & ex.Message & "');" & _
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
        Dim resize_cbx As CheckBox = CType(image_fv.FindControl("resize_cbx"), CheckBox)
        Dim MIMEType As String = ""

        Try

            If imgUploader.HasFile Then

                If imgUploader.PostedFile.ContentLength > 2097152 Then
                    Throw New ArgumentException("The image must be under 2 MB in size.")
                End If

                Dim ext As String = Path.GetExtension(imgUploader.PostedFile.FileName).ToLower()

                Select Case ext
                    Case ".gif"
                        MIMEType = "image/gif"
                    Case ".jpg"
                        MIMEType = "image/jpeg"
                    Case ".png"
                        MIMEType = "image/png"
                    Case Else
                        Throw New ArgumentException("Image must be in either GIF, JPG or PNG format.")
                End Select


                Dim imageBytes(imgUploader.PostedFile.InputStream.Length) As Byte
                imgUploader.PostedFile.InputStream.Read(imageBytes, 0, imageBytes.Length)

                If resize_cbx.Checked Then
                    e.NewValues("ImageData") = resizeImage(imageBytes, MIMEType, 600)
                Else
                    e.NewValues("ImageData") = imageBytes
                End If
                e.NewValues("MIMEType") = MIMEType

            Else
                If resize_cbx.Checked Then
                    e.NewValues("ImageData") = resizeImage(getBinaryImage(Session("SelectedImage")), e.OldValues("MIMEType"), 600)
                Else
                    e.NewValues("ImageData") = getBinaryImage(Session("SelectedImage"))
                End If

                e.NewValues("MIMEType") = e.OldValues("MIMEType")

            End If

            e.NewValues("Resized") = wasResized
            e.NewValues("ProjectID") = project_ddl.SelectedValue
            Session("TheProject") = getProjectForImage(e.NewValues("ProjectID"))
            Session("ImageTitle") = e.NewValues("ImageTitle")

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

    

    Protected Function getImageTitle(ByVal id As Integer) As String
        Try
            oCmd.Connection = oConn
            oCmd.CommandType = CommandType.Text

            strSQL = "SELECT ImageTitle FROM Screenshots WHERE ID = @ID"

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
        End Try

    End Function

    Protected Sub onEditProjectDDLLoad(ByVal sender As Object, ByVal e As System.EventArgs)
        setPostbackTriggers()

        If Session("FirstLoad") Then
            Try
                oCmd.Connection = oConn
                oCmd.CommandType = CommandType.Text

                strSQL = "SELECT ProjectID FROM Screenshots WHERE ID = @ID"

                oCmd.Parameters.Clear()

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
            End Try


        End If
    End Sub


    Private Function resizeImage(ByVal bytes As Byte(), ByVal mimeType As String, ByVal maxDim As Integer) As Byte()
        Dim img As Image = getImageFromBytes(bytes)

        'This check ensures that the resizing will only be done if the width is greater than the max dimension, and
        'that the resized field only gets set if the resize takes place
        If img.Width > maxDim Then

            Dim newSize As Size = getResizedDimensions(img, maxDim)

            Dim newImgRect As Rectangle = New Rectangle(0, 0, newSize.Width, newSize.Height)
            Dim newImgBMP As Bitmap = New Bitmap(newSize.Width, newSize.Height)
            Dim newImgGraphics As Graphics = Graphics.FromImage(newImgBMP)

            newImgGraphics.CompositingQuality = Drawing2D.CompositingQuality.HighQuality
            newImgGraphics.SmoothingMode = Drawing2D.SmoothingMode.HighQuality
            newImgGraphics.InterpolationMode = Drawing2D.InterpolationMode.HighQualityBicubic

            newImgGraphics.DrawImage(img, newImgRect)

            Dim ms As MemoryStream = New MemoryStream()

            Dim saveFormat As Drawing.Imaging.ImageFormat
            Select Case mimeType
                Case "image/gif"
                    saveFormat = Drawing.Imaging.ImageFormat.Gif
                Case "image/jpeg"
                    saveFormat = Drawing.Imaging.ImageFormat.Jpeg
                Case "image/png"
                    saveFormat = Drawing.Imaging.ImageFormat.Png
            End Select

            newImgBMP.Save(ms, saveFormat)


            Dim newBytes(ms.Length) As Byte
            ms.Position = 0
            ms.Read(newBytes, 0, ms.Length)

            newImgBMP.Dispose()
            newImgGraphics.Dispose()
            img.Dispose()

            Session("Resized") = True
            wasResized = True

            Return newBytes

        End If

        Return bytes

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

    Public Function isResizeAvailable(ByVal id As Object, ByVal maxDim As Integer) As Boolean
        Dim img As Image = getImageFromBytes(getBinaryImage(id))
        Return (img.Width > maxDim)
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
        End Try
    End Function

    Private Sub showChangedResult(ByVal inserted As Boolean)
        Dim recentArr() As String = Session("RecentImage")
        changed_lit.Text = "<h3>Successful " & IIf(inserted, "Addition", "Update") & "</h3><p class='ResultStyle'>The screenshot, <b>" & recentArr(0) & "</b>, for <b>" & recentArr(1) & "</b> has been successfully " & IIf(inserted, "added", "modified") & ".</p>" & IIf(Session("Resized"), "<p>The image has been resized.</p>", "")
        changed_updatePnl.Update()
        changed_mpExt.Show()
    End Sub

    Protected Sub setPostbackTriggers()
        Dim insert_btn As Button
        Dim update_btn As Button
        If image_fv.CurrentMode = FormViewMode.Edit Then
            update_btn = CType(image_fv.FindControl("update_btn"), Button)
            ScriptManager.GetCurrent(Page).RegisterPostBackControl(update_btn)
        End If

        If image_fv.CurrentMode = FormViewMode.Insert Then
            insert_btn = CType(image_fv.FindControl("insert_btn"), Button)
            ScriptManager.GetCurrent(Page).RegisterPostBackControl(insert_btn)
        End If
    End Sub

    Public Function formatNullText(ByVal f As Object) As String
        Return IIf(f Is DBNull.Value, "<i>Not specified.</i>", f)
    End Function

    Public Function formatImageStats(ByVal resized As Boolean) As String
        Dim imageBytes() As Byte = getBinaryImage(Session("SelectedImage"))
        Dim img As Image = getImageFromBytes(imageBytes)

        Return IIf(resized, "<b>[Resized]</b><br />", "") & "Size in database: <b>" & IIf(imageBytes.Length >= 1048576, Math.Round(imageBytes.Length) & "MB", Math.Round(imageBytes.Length / 1024, 2) & "KB") & "</b><br />Dimensions: <b>" & img.Width & " x " & img.Height & "</b>"
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
