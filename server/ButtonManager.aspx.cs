using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Xml;
using System.Configuration;
using System.IO;

public partial class server_ButtonManager : System.Web.UI.Page
{
    public delegate void ButtonContentChangeEventHandler();
    public event ButtonContentChangeEventHandler buttonContentChangeEventHandler;
    private string week = string.Empty;
    string connStr = ConfigurationManager.ConnectionStrings["db_CountConnectionString"].ToString();
    protected void Page_Load(object sender, EventArgs e)
    {
        
        Label2.Text = System.Globalization.CultureInfo.CurrentCulture.DateTimeFormat.GetDayName(DateTime.Now.DayOfWeek);
        buttonContentChangeEventHandler += Server_ButtonManager_buttonContentChangeEventHandler;
        CheckWeekDay();
    }

    private void Server_ButtonManager_buttonContentChangeEventHandler()
    {

        //执行更新操作
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            using (SqlCommand cmd=new SqlCommand())
            {
                cmd.CommandText = "update dbo.tb_Record set flag=1";
                cmd.Connection = conn;
                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }
    }

    private void Bind()
    {
        this.GridView1.DataSourceID = this.SqlDataSource1.ID;
        this.GridView1.DataBind();
    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        if (string.IsNullOrEmpty(TextBox1.Text))
        {
            this.Label1.ForeColor = System.Drawing.Color.Red;
            this.Label1.Text = "请输入活动名称";
            return;
        }
        
        //DataTable dt = null;
        using (SqlConnection conn = new SqlConnection(connStr))
        {

            using (SqlCommand cmd = new SqlCommand())
            {
                conn.Open();
                cmd.CommandText = string.Format("insert into tb_Button (buttonContent) values ('{0}')",TextBox1.Text.Trim());
                cmd.Connection = conn;
                int i=cmd.ExecuteNonQuery();
                if (i > 0)
                {
                    TextBox1.Text = string.Empty;
                    Bind();
                    Label1.ForeColor = System.Drawing.Color.Green;
                    Label1.Text = "活动添加成功！";
                }
                else
                {
                    Label1.ForeColor = System.Drawing.Color.Red;
                    Label1.Text = "活动添加失败，未知错误！";
                }
            }
        }
    }

    protected void GridView1_RowUpdated(object sender, GridViewUpdatedEventArgs e)
    {
        if (buttonContentChangeEventHandler != null)
        {
            buttonContentChangeEventHandler();
        }
    }

    private void CheckWeekDay()
    {
        //获取config中的日期串，如果和今天是同一天，返回

        //如果不是同一天，继续执行更新操作
        TimeSpan during = new TimeSpan();
        
        week= System.Globalization.CultureInfo.CurrentCulture.DateTimeFormat.GetDayName(DateTime.Now.DayOfWeek);
        string path = Server.MapPath("config.xml");
        XmlDocument doc = new XmlDocument();
        doc.Load(path);
        XmlNode root = doc.SelectSingleNode("config");
        string date = root.ChildNodes[1].InnerText;
        during = DateTime.Now - Convert.ToDateTime(date);
        if ((DateTime.Now.ToString("yy/MM/dd").CompareTo(Convert.ToDateTime(date).ToString("yy/MM/dd")) == 0))//和上次配置的时间相同
        {
            Label2.Text = "Today!";
            return;
        }
        else if(during.Days<7)
        {
            //如果Now的值比上次配置的日期之差小于7，
            Label2.Text = "In This Week!";
        }
        else if(during.Days>7)
        {
            if (during.Days / 7 == 0)
            {
                root.ChildNodes[1].InnerText = (Convert.ToDateTime(date) + new TimeSpan(7, 0, 0, 0)).ToString("yy/MM/dd");
                doc.Save(path);
                if (buttonContentChangeEventHandler != null)
                {
                    buttonContentChangeEventHandler();
                }
            }
            else
            {
                int n = during.Days / 7;
                root.ChildNodes[1].InnerText = (Convert.ToDateTime(date) + new TimeSpan(7 * n, 0, 0, 0)).ToString("yy/MM/dd");
                doc.Save(path);
                if (buttonContentChangeEventHandler != null)
                {
                    buttonContentChangeEventHandler();
                }
            }
            //执行委托，更新可点击状态

            Label2.Text = "It's time to update!";
        }
    }
}