<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="AltTest.index" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <script src="http://code.jquery.com/jquery-1.10.2.min.js" type="text/javascript"></script>
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
    <script src="WebCam.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(function () {
            Webcam.set({
                width: 320,
                height: 240,
                image_format: 'jpeg',
                jpeg_quality: 90
            });
            Webcam.attach('#WebCam');
            $("#CaptureButton").click(function () {
                Webcam.snap(function (data) {
                    $("#ImageCapture")[0].src = data;
                    $("#UploadButton").removeAttr("disabled");
                });
            });
            $("#UploadButton").click(function () {
                $.ajax({
                    type: "POST",
                    url: "index.aspx/SaveCapturedImage",
                    data: "{data: '" + $("#ImageCapture")[0].src + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (r) {
                    }
                });
            });
        });
    </script>

    <link href ="style.css" rel="stylesheet" />
</head>
<body>
    <h1>Image Processing</h1>
    <hr />
    <form id="mainform" runat="server">
        <div>
            <asp:ScriptManager ID="ScriptManager1" runat="server">
            </asp:ScriptManager>
            <table class ="center">
                <tr>
                    <td><asp:FileUpload ID="FileUpload" runat="server"/></td>
                    <td><asp:DropDownList ID="OptionsDropDownList" runat="server">
                    <asp:ListItem Value ="0">Gray</asp:ListItem>
                    <asp:ListItem Value ="1">Swap B and G</asp:ListItem>
                    </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <th align="center"><u>Original Image</u></th>
                    <th align="center"><u>Converted Image</u></th>
                </tr>
                <tr>
                    <td><asp:Image ID="UploadedImage" Height ="240px" Width ="320px" runat="server" /></td>
                    <td > 
                    <asp:UpdatePanel runat="server">
                        <ContentTemplate>
                            <asp:Image ID="ConvertedImage" Height ="240px" Width ="320px" runat="server" />
                        </ContentTemplate>
                    </asp:UpdatePanel>
                    </td>
                </tr>
               <tr>
                    <td align="center"> <asp:Button ID="DispButton" runat="server" Text="Upload" 
                        OnClick="DispButton_Click" /></td>
                    <td align="center">
                    <asp:UpdatePanel runat="server">
                        <ContentTemplate>
                            <asp:Button ID="ConvertButton" runat="server" Text="Convert" OnClick="ConvertButton_Click" />
                        </ContentTemplate>
                    </asp:UpdatePanel>
                    </td>
                </tr>
            </table>

            <br />
            <table class ="center">
            <tr>
                <th align="center"><u>Camera</u></th>
                <th align="center"><u>Captured Image</u></th>
            </tr>
            <tr>
                <td><div id="WebCam"></div></td>
                <td><img id="ImageCapture" height ="240px" width ="320px"/></td>
            </tr>
            <tr>
                <td align="center">
                <input type="button" id="CaptureButton" value="Capture"/>
                </td>
                <td align="center">
                    <input type="button" id="UploadButton" value="Save" disabled="disabled"/>
                </td>
            </tr>
            </table>
        </div>
    </form>
</body>
</html>
