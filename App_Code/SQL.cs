using System;
using System.Collections.Generic;
using System.Configuration;
using System.Web;
using System.Data.SqlClient;
using System.Data;

/// <summary>
/// SQL 的摘要说明
/// </summary>
public class SQL
{
    static string connStr = ConfigurationManager.ConnectionStrings["db_CountConnectionString"].ToString();
    public SQL()
    {
        
    }

    public static int ExcuteProcedureScalar(string procedureName,params SqlParameter[] para)
    {
        if (string.IsNullOrEmpty(procedureName)) return -1;
        int result = 0;
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();
            using (SqlCommand cmd=new SqlCommand(procedureName))
            {
                cmd.Connection = conn;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                if (para != null)
                {
                    foreach (SqlParameter  item in para)
                    {
                        cmd.Parameters.Add(item);
                    }
                }
                result=(int)cmd.ExecuteScalar();
                cmd.Parameters.Clear();
            }
        }
        return result;
    }


    public static int ExcuteProcedureNonquery(string procedureName, string output, params SqlParameter[] para)
    {
        if (string.IsNullOrEmpty(procedureName)) return -1;
        int result = 0;
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();
            using (SqlCommand cmd = new SqlCommand(procedureName))
            {
                cmd.Connection = conn;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                if (para != null)
                {
                    foreach (SqlParameter item in para)
                    {
                        cmd.Parameters.Add(item);
                    }
                }
                if (!string.IsNullOrEmpty(output))
                {
                    SqlParameter outputPara= new SqlParameter(output, System.Data.SqlDbType.Int);
                    outputPara.Direction = System.Data.ParameterDirection.Output;
                    outputPara.Value = 0;
                    cmd.Parameters.Add(outputPara);
                    
                }
                result = (int)cmd.ExecuteNonQuery();
                if (!string.IsNullOrEmpty(output))
                {
                    result = (int)cmd.Parameters[output].Value;
                }
                cmd.Parameters.Clear();
            }
        }
        return result;
    }

    public static DataTable ExcuteProcedureQueryWithOutput(string procedureName, string output,out int result, params SqlParameter[] para)
    {
        result = 0;
        if (string.IsNullOrEmpty(procedureName))
        {
            result = -1;
            return null;
        }
        //int result = 0;
        DataTable dt;
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();
            using (SqlCommand cmd = new SqlCommand(procedureName))
            {
                cmd.Connection = conn;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                if (para != null)
                {
                    foreach (SqlParameter item in para)
                    {
                        cmd.Parameters.Add(item);
                    }
                }
                SqlParameter outputPara = new SqlParameter(output, System.Data.SqlDbType.Int);
                outputPara.Direction = System.Data.ParameterDirection.Output;
                outputPara.Value = 0;
                cmd.Parameters.Add(outputPara);
                //                cmd.ExecuteNonQuery();
                SqlDataAdapter sda = new SqlDataAdapter();
                sda.SelectCommand = cmd;
                dt = new DataTable();
                sda.Fill(dt);
                result = (int)cmd.Parameters[output].Value;
                cmd.Parameters.Clear();
            }
        }
        return dt;
    }



    public static DataTable ExcuteProcedureQuery(string procedureName,  params SqlParameter[] para)
    { 
        if (string.IsNullOrEmpty(procedureName))
        {
            return null;
        }
        //int result = 0;
        DataTable dt;
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();
            using (SqlCommand cmd = new SqlCommand(procedureName))
            {
                cmd.Connection = conn;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                if (para != null)
                {
                    foreach (SqlParameter item in para)
                    {
                        cmd.Parameters.Add(item);
                    }
                }               
                SqlDataAdapter sda = new SqlDataAdapter();
                sda.SelectCommand = cmd;
                dt = new DataTable();
                //SqlConnection.ClearAllPools();
                sda.Fill(dt);
                cmd.Parameters.Clear();
            }
        }
        return dt;
    }


    public static int DeleteSendName(string sql)
    {
        int i = -1;
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();
            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.Connection = conn;
                cmd.CommandText = sql;
                i = cmd.ExecuteNonQuery();
            }
        }
        return i;
    }

    public static int SetEffective()
    {
        int i = -1;
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();
            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.Connection = conn;
                cmd.CommandText = "update tb_SendName set flag=0";
                i=cmd.ExecuteNonQuery();
            }
        }
        return i;
    }


    public static int QueryChances(out int times,int id,string date)
    {
        int curOcupied = -1;
        string column = string.Empty;
        switch (date)
        {
            case "2016-3-29":
            case "2016-03-29":
                column = "c1";
                break;
            case "2016-3-30":
            case "2016-03-30":
                column = "c2";
                break;
            case "2016-3-31":
            case "2016-03-31":
                column = "c3";
                break;
            case "2016-4-1":
            case "2016-04-01":
                column = "c4";
                break;
            case "2016-4-2":
            case "2016-04-02":
                column = "c5";
                break;
            case "2016-4-3":
            case "2016-04-03":
                column = "c6";
                break;
            case "2016-4-4":
            case "2016-04-04":
                column = "c7";
                break;
            case "2016-4-5":
            case "2016-04-05":
                column = "c8";
                break;
            case "2016-4-6":
            case "2016-04-06":
                column = "c9";
                break;
            default:
                column= "c1";
                break;
        }


        using(SqlConnection conn=new SqlConnection(connStr))
        {
            conn.Open();
            using (SqlCommand cmd=new SqlCommand())
            {
                string sqlcmd = string.Format("select {0} from tb_Market where id={1}",column,id);
                cmd.Connection = conn;
                cmd.CommandText = sqlcmd;
                times = (int)cmd.ExecuteScalar();
                cmd.CommandText = string.Empty;

                sqlcmd = string.Format("select count(*) from dbo.tb_SendName where mid={0} and date='{1}'",id,date);
                cmd.CommandText = sqlcmd;
                curOcupied = (int)cmd.ExecuteScalar();
            }
        }
        return curOcupied;
    }


    public static int GetIDs(string name)
    {
        int o = -1;
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();
            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.Connection = conn;
                cmd.CommandText = "select id from tb_User where userName='" + name + "'";
                o = (int)cmd.ExecuteScalar();
            }
        }
        return o;
    }

    public static int Login(string uname, string pass)
    {
        int result = -1;
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();
            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.Connection = conn;
                cmd.CommandText = string.Format("select count(id) from dbo.tb_User where userName= '{0}' and pass='{1}'",uname,pass);
                result = (int)cmd.ExecuteScalar();
            }
        }
        return result;
    }
}