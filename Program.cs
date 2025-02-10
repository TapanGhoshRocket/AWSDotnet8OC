// See https://aka.ms/new-console-template for more information
using IBM.Data.Db2;
string uid = Environment.GetEnvironmentVariable("uid");
string pwd = Environment.GetEnvironmentVariable("pwd");
string server = Environment.GetEnvironmentVariable("server");
string db = Environment.GetEnvironmentVariable("db");
string security = Environment.GetEnvironmentVariable("security");
Console.WriteLine("Using DB2 .NET8 provider");

//using DB2Connection objConnection = new DB2Connection("Database=bludb;UID=ztf38289;PWD=0Uq0qmLFnKv4m8mo;Server=b70af05b-76e4-4bca-a1f5-23dbb4c6a74e.c1ogj3sd0tgtu0lqde00.databases.appdomain.cloud:32716;Security=ssl");

//Connection String
string connString = "uid=" + uid + ";pwd=" + pwd + ";server=" + server + ";database=" + db + ";Security=" + security;
DB2Connection con = new DB2Connection(connString);
con.Open();
Console.WriteLine("Connection Opened successfully");
con.Close();
Console.WriteLine("Connection Closed");