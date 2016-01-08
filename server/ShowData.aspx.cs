using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.SessionState;
using System.Configuration;

public partial class server_ShowData : System.Web.UI.Page
{
    DataTable dt = null;
    DateTime fromD, toD;
    //string connStr = @"server = 4RBLIOWUDMHUMSF; database = db_CNY; uid = sa; pwd = 123456";
    string connStr = ConfigurationManager.ConnectionStrings["db_CountConnectionString"].ToString();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    string sql = @" select S.id as ID,U.userName as 员工号,Z.zone as 区域,M.market as 超市,S.date as 日期 from dbo.tb_SendName as S inner join dbo.tb_Market as M
	                                on S.mid=M.id
	                                inner join dbo.tb_Zone as Z
	                                on S.zid=Z.id
	                                inner join dbo.tb_User as U 
	                                on S.uid=U.id";
                    cmd.CommandText = sql;
                    cmd.Connection = conn;
                    dt = new DataTable();
                    SqlDataAdapter sda = new SqlDataAdapter(sql, conn);
                    sda.Fill(dt);
                    detail.DataSource = dt.DefaultView;
                    detail.DataBind();
                }
                //using (SqlCommand cmd = new SqlCommand())
                //{
                //    string sql = @" select userName as 员工号,pass as 密码 from tb_User";
                //    cmd.CommandText = sql;
                //    cmd.Connection = conn;
                //    dt = new DataTable();
                //    SqlDataAdapter sda = new SqlDataAdapter(sql, conn);
                //    sda.Fill(dt);
                //    user.DataSource = dt.DefaultView;
                //    user.DataBind();
                //}
            }


            DataView source = new DataView(Zone());
            DropDownList1.DataTextField = "zone";  //此列名为DropDownList1显示的值
            DropDownList1.DataValueField = "id";
            DropDownList1.DataSource = source;
            DropDownList1.DataBind();
            DropDownList1_SelectedIndexChanged(sender, e);
        }
    }

    private DataTable Zone()
    {
        SqlParameter p = new SqlParameter("@type", SqlDbType.Int);
        p.Value = -1;
        return SQL.ExcuteProcedureQuery("sp_GetList", p);
    }

    public void CreateExcel(DataTable dt, string FileName)
    {
        HttpResponse resp;
        resp = Page.Response;
        resp.ContentEncoding = System.Text.Encoding.GetEncoding("GB2312");
        resp.AppendHeader("Content-Disposition", "attachment;filename=" + FileName);
        string colHeaders = "", ls_item = "";

        //定义表对象与行对象，同时用DataSet对其值进行初始化 
        //DataTable dt = ds.Tables[0];
        DataRow[] myRow = dt.Select();//可以类似dt.Select("id>10")之形式达到数据筛选目的
        int i = 0;
        int cl = dt.Columns.Count;

        //取得数据表各列标题，各标题之间以t分割，最后一个列标题后加回车符 
        for (i = 0; i < cl; i++)
        {

            if (i == (cl - 1))//最后一列，加n
            {
                colHeaders += dt.Columns[i].Caption.ToString() + "\n";
            }
            else
            {
                colHeaders += dt.Columns[i].Caption.ToString() + "\t";
            }

        }
        resp.Write(colHeaders);
        //向HTTP输出流中写入取得的数据信息 

        //逐行处理数据   
        foreach (DataRow row in myRow)
        {
            //当前行数据写入HTTP输出流，并且置空ls_item以便下行数据     
            for (i = 0; i < cl; i++)
            {
                if (i == (cl - 1))//最后一列，加n
                {
                    ls_item += row[i].ToString() + "\n";
                }
                else
                {
                    ls_item += row[i].ToString() + "\t";
                }

            }
            resp.Write(ls_item);
            ls_item = "";

        }
        resp.End();
    }

    protected void export_Click(object sender, EventArgs e)
    {
        queryAll_Click(sender, e);
        CreateExcel(dt, "data.xls");
    }

    protected void dateExport_Click(object sender, EventArgs e)
    {
        query_Click(sender, e);
        CreateExcel(dt, "DataByDate.xls");
    }

    protected void query_Click(object sender, EventArgs e)
    {
        if (string.IsNullOrEmpty(inputfromDate.Value) || string.IsNullOrEmpty(inputtoDate.Value))
        {
            return;
        }
        //using (SqlConnection conn = new SqlConnection(connStr))
        //{
        //    using (SqlCommand cmd = new SqlCommand())
        //    {
        //        string sql = string.Format("select cid as 编号,userNum as 被提交的用户编码,btnContent as 被提交的按钮内容,clickDate as 当前提交数据点击日期 from tb_Record where clickDate between '{0}' and '{1}'", Convert.ToDateTime(inputfromDate.Value).ToLocalTime(), Convert.ToDateTime(inputtoDate.Value).ToLocalTime());
        //        //string sql = string.Format("select cid as 编号,userNum as 被提交的用户编码,btnContent as 被提交的按钮内容,clickDate as 当前提交数据点击日期 from tb_Record where clickDate between CONVERT(varchar,'{0}',120) and CONVERT(varchar,'{1}',120)", Convert.ToDateTime(from.Value).ToLocalTime(), Convert.ToDateTime(to.Value).ToLocalTime());
        //        cmd.CommandText = sql;
        //        cmd.Connection = conn;
        //        dt = new DataTable();
        //        SqlDataAdapter sda = new SqlDataAdapter(sql, conn);
        //        sda.Fill(dt);
        //        detail.DataSource = dt.DefaultView;
        //        detail.DataBind();
        //    }
        //}
        SqlParameter[] pars = {
            new SqlParameter("@zid",SqlDbType.Int),
            new SqlParameter("@mid",SqlDbType.Int),
            new SqlParameter("@fromDate",SqlDbType.Date),
            new SqlParameter("@toDate",SqlDbType.Date),
            new SqlParameter("@isAll",SqlDbType.Int)
        };

        pars[0].Value = DropDownList1.SelectedItem.Value;
        pars[1].Value = DropDownList2.SelectedItem.Value;
        pars[2].Value = inputfromDate.Value;
        pars[3].Value = inputtoDate.Value;
        pars[4].Value = 0;
        dt = new DataTable();
        dt = SQL.ExcuteProcedureQuery("sp_QueryByCondition", pars);
        detail.DataSource = dt.DefaultView;
        detail.DataBind();
    }

    protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
    {
        string id = DropDownList1.SelectedItem.Value;
        SqlParameter p = new SqlParameter("@type", SqlDbType.Int);
        p.Value = id;
        DataTable t = SQL.ExcuteProcedureQuery("sp_GetList", p);
        DropDownList2.DataTextField = "market";
        DropDownList2.DataValueField = "id";
        DropDownList2.DataSource = new DataView(t);
        DropDownList2.DataBind();
    }

    protected void queryAll_Click(object sender, EventArgs e)
    {
        SqlParameter[] ps = {
            new SqlParameter("@zid",SqlDbType.Int),
            new SqlParameter("@mid",SqlDbType.Int),
            new SqlParameter("@fromDate",SqlDbType.Date),
            new SqlParameter("@toDate",SqlDbType.Date),
            new SqlParameter("@isAll",SqlDbType.Int)
        };
        ps[0].Value = DBNull.Value;
        ps[1].Value = DBNull.Value;
        ps[2].Value = DBNull.Value;
        ps[3].Value = DBNull.Value;
        ps[4].Value = 1;
        dt = new DataTable();
        dt = SQL.ExcuteProcedureQuery("sp_QueryByCondition", ps);
        detail.DataSource = dt.DefaultView;
        detail.DataBind();
    }

    protected void detail_SelectedIndexChanged(object sender, EventArgs e)
    {
        Response.Write("<script>alert('sss')</script>");
    }


    protected void detail_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        try
        {
            // string TID = user.DataKeys[e.RowIndex].Value.ToString();
            string TID = detail.Rows[e.RowIndex].Cells[1].Text.ToString();
            string delSQL = "delete from tb_SendName where id=" + TID;
            int flag = SQL.DeleteSendName(delSQL);
            //if (!Page.IsPostBack)
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        string sql = @" select S.id as ID,U.userName as 员工号,Z.zone as 区域,M.market as 超市,S.date as 日期 from dbo.tb_SendName as S inner join dbo.tb_Market as M
	                                on S.mid=M.id
	                                inner join dbo.tb_Zone as Z
	                                on S.zid=Z.id
	                                inner join dbo.tb_User as U 
	                                on S.uid=U.id";
                        cmd.CommandText = sql;
                        cmd.Connection = conn;
                        dt = new DataTable();
                        SqlDataAdapter sda = new SqlDataAdapter(sql, conn);
                        sda.Fill(dt);
                        detail.DataSource = dt.DefaultView;
                        detail.DataBind();
                    }
                   
                }
            }
        }
        catch (Exception ex)
        {

        }
    }

    protected void TextBox1_TextChanged(object sender, EventArgs e)
    {

    }

    protected void Add_Click(object sender, EventArgs e)
    {
        string z = DropDownList1.SelectedValue;
        string m = DropDownList2.SelectedValue;
        string u = TextBox1.Text;
        string d = DropDownList3.SelectedValue;
        SqlParameter[] pars = {
            new SqlParameter("@uid",System.Data.SqlDbType.Int),
            new SqlParameter("@zid",System.Data.SqlDbType.Int),
            new SqlParameter("@mid",System.Data.SqlDbType.Int),
            new SqlParameter("@date",System.Data.SqlDbType.Date)
            };
        int i = 0;
        pars[0].Value = SQL.GetIDs(u);
        pars[1].Value = z;
        pars[2].Value = m;
        pars[3].Value = d;

        i = SQL.ExcuteProcedureNonquery("sp_AddSendNameRecord", "@state", pars);
        using (SqlConnection conn = new SqlConnection())
            if (i == -1)
            {
                this.msg.Text = "报名次数达到上限了哦";//"报名次数达到上限了哦"
            }
            else if (i == -2)
            {
                this.msg.Text = "该地区该超市已经报名了哦";//"该地区该超市已经报名了哦"
            }
            else if (i == -3)
            {
                this.msg.Text ="今天已经报名了哦";//"今天已经报名了哦"
            }
            else if (i == -5)
            {
                this.msg.Text ="该地区该超市已经报名了哦";//"该地区该超市已经报名了哦"
            }
            else
            {
                //SqlParameter p = new SqlParameter("@userId", SqlDbType.Int);
                //p.Value = Convert.ToInt32(context.Session["user"].ToString());
                //DataTable dt = SQL.ExcuteProcedureQuery("sp_SendNameTable", p);

                //if (dt.Rows.Count > 0)
                //{
                //    msg = BuildRecoedTable(dt);
                //}
            }




        if (i > 0)
        {
            Response.Write("<script type='javascript'> alert('修改成功')</script>");
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    string sql = @" select S.id as ID,U.userName as 员工号,Z.zone as 区域,M.market as 超市,S.date as 日期 from dbo.tb_SendName as S inner join dbo.tb_Market as M
	                                on S.mid=M.id
	                                inner join dbo.tb_Zone as Z
	                                on S.zid=Z.id
	                                inner join dbo.tb_User as U 
	                                on S.uid=U.id";
                    cmd.CommandText = sql;
                    cmd.Connection = conn;
                    dt = new DataTable();
                    SqlDataAdapter sda = new SqlDataAdapter(sql, conn);
                    sda.Fill(dt);
                    detail.DataSource = dt.DefaultView;
                    detail.DataBind();
                }

            }
        }
    }
}