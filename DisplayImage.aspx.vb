﻿Imports System.Data
Imports System.Data.SqlClient

Partial Class Admin_DisplayImage
    Inherits System.Web.UI.Page

    Dim oConn As New SqlConnection(ConfigurationManager.ConnectionStrings("ProjectConnectionString").ConnectionString)
    Dim oCmd As New SqlCommand
    Dim reader As SqlDataReader
    Dim oParam As SqlParameter
    Dim strSQL As String = ""

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Try
            oCmd.Connection = oConn
            oCmd.CommandType = CommandType.Text

            strSQL = "SELECT MIMEType, ImageData FROM Screenshots WHERE ID = @ID"

            oParam = New SqlParameter
            oParam.ParameterName = "ID"
            oParam.SqlDbType = SqlDbType.Int
            oParam.Value = Convert.ToInt32(Request.QueryString("ID"))
            oCmd.Parameters.Add(oParam)

            oCmd.CommandText = strSQL
            oCmd.Connection.Open()

            reader = oCmd.ExecuteReader()

            If reader.Read() Then
                Response.ContentType = reader("MIMEType").ToString()
                Response.BinaryWrite(reader("ImageData"))
            End If

        Catch ex As Exception
            Throw ex
        Finally
            If oConn.State = ConnectionState.Open Then
                oConn.Close()
                reader.Close()
            End If

            oCmd.Dispose()
        End Try

    End Sub


End Class
