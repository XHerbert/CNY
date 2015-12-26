<%@ Application Language="C#" %>

<script runat="server">

    void Application_Start(object sender, EventArgs e)
    {
        // 在应用程序启动时运行的代码
        System.Timers.Timer timer = new System.Timers.Timer();
        //timer.Interval = 24 * 60 * 60 * 1000;
        timer.Interval = 5*1000;
        timer.Enabled = true;
        timer.Elapsed += new System.Timers.ElapsedEventHandler(timer_Elapsed);
    }

    private void timer_Elapsed(object sender,EventArgs args)
    {
        string date = DateTime.Now.ToString("yyyy/MM/dd");
        //string orderTime = ConfigurationManager.AppSettings["time"];

        string path =System.AppDomain.CurrentDomain.BaseDirectory+"config.xml";
        System.Xml.XmlDocument doc = new System.Xml.XmlDocument();
        doc.Load(path);
        System.Xml.XmlNode root = doc.SelectSingleNode("config");
        string orderDate = root.ChildNodes[0].InnerText;
        if (!date.Equals(orderDate))//如果不相等，说明是第一次进入，把所有的flag设置成可选，同时更新XML中的日期
        {
            //System.Diagnostics.Process p = new System.Diagnostics.Process();
            //p.StartInfo.FileName = AppDomain.CurrentDomain.BaseDirectory+("server\\ss.txt");
            //p.Start();
            //执行更新数据库Flag
            int i=SQL.SetEffective();
            root.ChildNodes[0].InnerText = date;
            doc.Save(path);
        }
    }

    void Application_End(object sender, EventArgs e)
    {
        //  在应用程序关闭时运行的代码

    }

    void Application_Error(object sender, EventArgs e)
    {
        // 在出现未处理的错误时运行的代码

    }

    void Session_Start(object sender, EventArgs e)
    {
        // 在新会话启动时运行的代码

    }

    void Session_End(object sender, EventArgs e)
    {
        // 在会话结束时运行的代码。 
        // 注意: 只有在 Web.config 文件中的 sessionstate 模式设置为
        // InProc 时，才会引发 Session_End 事件。如果会话模式设置为 StateServer
        // 或 SQLServer，则不引发该事件。

    }

</script>
