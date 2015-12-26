using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Data.OleDb;

public partial class server_ZoneAndMarketManager : System.Web.UI.Page
{
    string connStr = ConfigurationManager.ConnectionStrings["db_CountConnectionString"].ToString();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            //using (SqlConnection conn = new SqlConnection(connStr))
            //{
            //    using (SqlCommand cmd = new SqlCommand())
            //    {
            //        string sql = @" select U.userName as 员工号,Z.zone as 区域,M.market as 超市,S.date as 日期 from dbo.tb_SendName as S inner join dbo.tb_Market as M
            //                     on S.mid=M.id
            //                     inner join dbo.tb_Zone as Z
            //                     on S.zid=Z.id
            //                     inner join dbo.tb_User as U 
            //                     on S.uid=U.id";
            //        cmd.CommandText = sql;
            //        cmd.Connection = conn;
            //        dt = new DataTable();
            //        SqlDataAdapter sda = new SqlDataAdapter(sql, conn);
            //        sda.Fill(dt);
            //        detail.DataSource = dt.DefaultView;
            //        detail.DataBind();
            //    }
            //}


            DataView source = new DataView(Zone());
            zone_d.DataTextField = "zone";  //此列名为DropDownList1显示的值
            zone_d.DataValueField = "id";
            zone_d.DataSource = source;
            zone_d.DataBind();
            //zone_d(sender, e);
        }
    }
    private DataTable Zone()
    {
        SqlParameter p = new SqlParameter("@type", SqlDbType.Int);
        p.Value = -1;
        return SQL.ExcuteProcedureQuery("sp_GetList", p);
    }


    private void InputExcel(string pPath, string sheet)
    {
        string conn = "Provider = Microsoft.Ace.OleDb.12.0 ; Data Source =" + pPath + ";Extended Properties='Excel 12.0;HDR=False;IMEX=1'";
        OleDbConnection oleCon = new OleDbConnection(conn);
        oleCon.Open();
        string Sql = string.Format("select * from [{0}]", sheet);
        OleDbDataAdapter mycommand = new OleDbDataAdapter(Sql, oleCon);
        DataSet ds = new DataSet();
        mycommand.Fill(ds, sheet);
        oleCon.Close();
        int count = ds.Tables[sheet].Rows.Count;
        for (int i = 0; i < count; i++)
        {
            string tUserName, tUserPass;

            tUserName = ds.Tables[sheet].Rows[i]["员工编号"].ToString().Trim();
            tUserPass = ds.Tables[sheet].Rows[i]["身份证号"].ToString().Trim();
            tUserPass = tUserPass.Substring(tUserPass.Length - 6);

            using (SqlConnection connS = new SqlConnection(connStr))
            {
                connS.Open();
                using (SqlCommand sqlcmd = new SqlCommand())
                {
                    string excelsql = string.Format("insert into dbo.tb_User ( userName,pass) values ('{0}','{1}')", tUserName, tUserPass);
                    sqlcmd.CommandText = excelsql;
                    sqlcmd.Connection = connS;
                    sqlcmd.ExecuteNonQuery();
                }
            }
        }
    }



    private void InputMarketExcel(string pPath, string sheet)
    {
        string conn = "Provider = Microsoft.Ace.OleDb.12.0 ; Data Source =" + pPath + ";Extended Properties='Excel 12.0;HDR=False;IMEX=1'";
        OleDbConnection oleCon = new OleDbConnection(conn);
        oleCon.Open();
        string Sql = string.Format("select * from [{0}] as A", sheet);
        OleDbDataAdapter mycommand = new OleDbDataAdapter(Sql, oleCon);
        DataSet ds = new DataSet();
        mycommand.Fill(ds, sheet);
        oleCon.Close();
        int count = ds.Tables[sheet].Rows.Count;
        for (int i = 0; i < count; i++)
        {
            int zoneId = 0;
            int clickTiems = 0;
            string zoneName,marketName ,address,no;
            zoneName= ds.Tables[sheet].Rows[i]["区域"].ToString().Trim();
            switch (zoneName)
            {
                case "杭湖区":
                    zoneId = 1;
                    break;
                case "杭州区":
                    zoneId = 2;
                    break;
                case "金华区":
                    zoneId = 3;
                    break;
                case "丽衡区":
                    zoneId = 4;
                    break;
                case "宁波区":
                    zoneId = 5;
                    break;
                case "绍兴区":
                    zoneId = 6;
                    break;
                case "台宁区":
                    zoneId = 7;
                    break;
                case "温州区":
                    zoneId = 8;
                    break;
                default:
                    break;
            }

            marketName = ds.Tables[sheet].Rows[i]["详细客户"].ToString().Trim();
            address = ds.Tables[sheet].Rows[i]["地址"].ToString().Trim();
            no = ds.Tables[sheet].Rows[i]["客户编号"].ToString().Trim(); 
            clickTiems = Convert.ToInt32(ds.Tables[sheet].Rows[i]["每店每天冲击人员数"].ToString().Trim());

            using (SqlConnection connS = new SqlConnection(connStr))
            {
                connS.Open();
                using (SqlCommand sqlcmd = new SqlCommand())
                {
                    string excelsql = string.Format("insert into dbo.tb_Market ( zoneId,market,clickTimes,address,no) values ({0},'{1}','{2}','{3}','{4}')", zoneId, marketName,clickTiems,address,no);
                    sqlcmd.CommandText = excelsql;
                    sqlcmd.Connection = connS;
                    int rows=sqlcmd.ExecuteNonQuery();
                }
            }
        }
    }

    protected void import_Click(object sender, EventArgs e)
    {
        string savePath = Server.MapPath("~/upload/");//指定上传文件在服务器上的保存路径                                           
        if (!System.IO.Directory.Exists(savePath))//检查服务器上是否存在这个物理路径，如果不存在则创建
        {
            System.IO.Directory.CreateDirectory(savePath);
        }
        savePath = savePath + "\\" + file.FileName;
        string filePath = savePath;
        file.SaveAs(savePath);
        if (filePath != "")
        {
            if (filePath.Contains("xls") || filePath.Contains("xlsx"))//判断文件是否存在
            {
                InputExcel(filePath, "测试人员$");
            }
            else
            {
                Response.Write("请检查您选择的文件是否为Excel文件！谢谢！");
            }
        }
        else
        {
            Response.Write("请先选择导入文件后，再执行导入！谢谢！");
        }
    }

    protected void z_add_Click(object sender, EventArgs e)
    {
        SqlParameter para = new SqlParameter("@zone", SqlDbType.NVarChar);
        if (string.IsNullOrEmpty(z.Value))
        {
            return;
        }
        para.Value = z.Value;
        int i = SQL.ExcuteProcedureNonquery("sp_AddZone", "@result", para);
        if (i > 0)
        {
            zone_d.DataSource = null;
            DataView source = new DataView(Zone());
            zone_d.DataTextField = "zone";  //此列名为DropDownList1显示的值
            zone_d.DataValueField = "id";
            zone_d.DataSource = source;
            zone_d.DataBind();
        }
        else
        {
            return;
        }
    }

    protected void m_add_Click(object sender, EventArgs e)
    {
        SqlParameter[] paraz = {
            new SqlParameter("@zid", SqlDbType.Int),
            new SqlParameter("@market", SqlDbType.NVarChar)
        };

        if (string.IsNullOrEmpty(zone_d.SelectedItem.Value) || string.IsNullOrEmpty(m.Value)) return;
        paraz[0].Value = zone_d.SelectedItem.Value;
        paraz[1].Value = m.Value;
        int i = SQL.ExcuteProcedureNonquery("sp_AddMarket", "@result", paraz);
        if (i > 0)
        {
            //直接加载数据
        }
        else
        {
            return;
        }
    }

    protected void btnMarket_Click(object sender, EventArgs e)
    {
        string savePath = Server.MapPath("~/upload/");//指定上传文件在服务器上的保存路径                                           
        if (!System.IO.Directory.Exists(savePath))//检查服务器上是否存在这个物理路径，如果不存在则创建
        {
            System.IO.Directory.CreateDirectory(savePath);
        }
        savePath = savePath + "\\" + file2.FileName;
        string filePath = savePath;
        file2.SaveAs(savePath);
        if (filePath != "")
        {
            if (filePath.Contains("xls") || filePath.Contains("xlsx"))//判断文件是否存在
            {
                InputMarketExcel(filePath, "MIT冲击的超市$");
            }
            else
            {
                Response.Write("请检查您选择的文件是否为Excel文件！谢谢！");
            }
        }
        else
        {
            Response.Write("请先选择导入文件后，再执行导入！谢谢！");
        }
        //string savePath = Server.MapPath("~/upload/");//指定上传文件在服务器上的保存路径                                           
        //if (!System.IO.Directory.Exists(savePath))//检查服务器上是否存在这个物理路径，如果不存在则创建
        //{
        //    System.IO.Directory.CreateDirectory(savePath);
        //}
        //savePath = savePath + "\\" + file2.FileName;
        //string filePath = savePath;
        //file.SaveAs(savePath);
        //if (filePath != "")
        //{
        //    if (filePath.Contains("xls") || filePath.Contains("xlsx"))//判断文件是否存在   
        //    {
        //        InputMarketExcel(filePath, "");
        //    }
        //    else
        //    {
        //        Response.Write("请检查您选择的文件是否为Excel文件！谢谢！");
        //    }
        //}
        //else
        //{
        //    Response.Write("请先选择导入文件后，再执行导入！谢谢！");
        //}
    }
}