namespace b24chht017HienptProject1.Service
{
    using MySql.Data.MySqlClient;
    using MySqlX.XDevAPI.Relational;
    using System.Data;
    using System.Reflection.PortableExecutable;
    using Microsoft.Extensions.Configuration;
    using static Org.BouncyCastle.Math.EC.ECCurve;

    public class DBConnect
    {
        private MySqlConnection connection;
        private string server;
        private string database;
        private string uid;
        private string password;

        //Constructor
        public DBConnect()
        {
            Initialize();
        }

        //Initialize values
        private void Initialize()
        {
            server = "localhost";
            database = "b24chht017_hienpt_project1";
            uid = "root";
            password = "123456aA@!";
            string connectionString;
            var MyConfig = new ConfigurationBuilder().AddJsonFile("appsettings.json").Build();
            connectionString = MyConfig.GetValue<string>("AppSettings:connectionString");
           // connectionString = "SERVER=" + server + ";" + "DATABASE=" + database + ";" + "UID=" + uid + ";" + "PASSWORD=" + password + ";";

            connection = new MySqlConnection(connectionString);
        }

        private bool OpenConnection()
        {
            try
            {
                connection.Open();
                return true;
            }
            catch (MySqlException ex)
            {
                return false;
            }
        }

        //Close connection
        private bool CloseConnection()
        {
            try
            {
                connection.Close();
                return true;
            }
            catch (MySqlException ex)
            {
                return false;
            }
        }

        public void Insert()
        {
            string query = "INSERT INTO tableinfo (name, age) VALUES('John Smith', '33')";

            //open connection
            if (this.OpenConnection() == true)
            {
                //create command and assign the query and connection from the constructor
                MySqlCommand cmd = new MySqlCommand(query, connection);

                //Execute command
                cmd.ExecuteNonQuery();

                //close connection
                this.CloseConnection();
            }
        }

        public DataTable Select(string query)
        {
            DataTable table = new DataTable();
            //Open connection
            if (this.OpenConnection() == true)
            {
                //Create Command
                MySqlCommand cmd = new MySqlCommand(query, connection);
                //Create a data reader and Execute the command
                MySqlDataReader dataReader = cmd.ExecuteReader();


                table.Load(dataReader);

                //close Data Reader
                dataReader.Close();

                //close Connection
                this.CloseConnection();

                //return list to be displayed
                return table;
            }
            else
            {
                return table;
            }

        }
    }
}
