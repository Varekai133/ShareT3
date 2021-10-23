using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Drawing;
using System.IO;
using System.Web.Services;
using AForge.Video;
using AForge.Video.DirectShow;

namespace AltTest
{
    public partial class index : System.Web.UI.Page
    {
        Bitmap _current;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["filepath"] != null)
            {
                UploadedImage.ImageUrl = Session["filepath"].ToString();
                _current = (Bitmap)Bitmap.FromFile(Server.MapPath(Session["filepath"].ToString()));
            }
        }

        protected void DispButton_Click(object sender, EventArgs e)
        {
            if (FileUpload.HasFile)
            {
                string filePath = Server.MapPath("Images/" + FileUpload.FileName);
                FileUpload.SaveAs(filePath);
                UploadedImage.ImageUrl = "Images/" + FileUpload.FileName;
                Session["filepath"] = "Images/" + FileUpload.FileName;
            }
            else
            {
                Response.Write("Please select file");
            }
        }

        protected void ConvertButton_Click(object sender, EventArgs e)
        {
            if (Session["filepath"] != null)
            {
                Bitmap temp = (Bitmap)Bitmap.FromFile(Server.MapPath(Session["filepath"].ToString()));
                Bitmap bmap = (Bitmap)temp.Clone();
                Color color;
                if (OptionsDropDownList.SelectedIndex == 0)
                {
                    for (int x = 0; x < bmap.Width; x++)
                    {
                        for (int y = 0; y < bmap.Height; y++)
                        {
                            color = bmap.GetPixel(x, y);
                            byte gray = (byte)(.299 * color.R + .587 * color.G + .114 * color.B);
                            bmap.SetPixel(x, y, Color.FromArgb(gray, gray, gray));
                        }
                    }
                }
                else
                {
                    for (int x = 0; x < bmap.Width; x++)
                    {
                        for (int y = 0; y < bmap.Height; y++)
                        {
                            color = bmap.GetPixel(x, y);
                            bmap.SetPixel(x, y, Color.FromArgb(color.R, color.B, color.G));
                        }
                    }
                }
                _current = (Bitmap)bmap.Clone();
                string fileName = DateTime.Now.ToString("dd-MM-yy hh-mm-ss");
                _current.Save(Server.MapPath("Images/" + fileName + ".png"));
                ConvertedImage.ImageUrl = "Images/" + fileName + ".png";
            }
        }

        [WebMethod()]
        public static bool SaveCapturedImage(string data)
        {
            string fileName = DateTime.Now.ToString("dd-MM-yy hh-mm-ss");
            
            byte[] imageBytes = Convert.FromBase64String(data.Split(',')[1]);
            string filePath = HttpContext.Current.Server.MapPath(string.Format("~/Images/{0}.jpg", fileName));
            File.WriteAllBytes(filePath, imageBytes);
            return true;
        }
    }
}