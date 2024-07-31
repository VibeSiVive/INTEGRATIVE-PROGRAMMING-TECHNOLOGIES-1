<%@ Page Language="C#" Debug="true" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Diagnostics" %>
<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="MySql.Data.MySqlClient" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tennis Product Catalog</title>
    
</head>
<body>
    <div class="container">
        <h1>Tennis Product</h1>
        <form id="form1" runat="server">
            <button type="submit" id="button1" runat="server" onserverclick="Button1_Click">View Tennis Apparels</button>
        </form>
        <div id="ResultDiv" runat="server"></div>
    </div>
</body>
<script runat="server">
    protected void Button1_Click(object sender, EventArgs e)
    {
        ExecuteMySQLQuery();
    }

    protected void ExecuteMySQLQuery()
    {
        string connStr = "server=localhost; user=root; database=vive; port=3306; password=root";
        MySqlConnection conn = new MySqlConnection(connStr);

        MySqlCommand cmd = new MySqlCommand(@"
            SELECT 
                CONCAT(
                    GROUP_CONCAT(
                        CONCAT(
                            '<tr>',
                            '<td>', ID, '</td>',
                            '<td>', Class, '</td>',
                            '<td>', Description, '</td>',
                            '<td>', Price, '</td>',                
                            '<td>', Quantity, '</td>',                                
                            '<td>', Date, '</td>',                                                
                            '<td><img src=""tennis/', Image, '"" alt=""Product Image"" width=""100"" height=""100""/></td>',                                                                
                            '</tr>'
                        )
                    )
                ) AS html_output
            FROM 
                products;", conn);
        conn.Open();
        MySqlDataReader reader = cmd.ExecuteReader();

        string html = "<table border='1'><tr><th>ID</th><th>Class</th><th>Description</th><th>Price</th><th>Quantity</th><th>Date</th><th>Image</th></tr>";
        while (reader.Read())
        {
            html += reader["html_output"].ToString();
        }
        html += "</table>";

        reader.Close();
        conn.Close();

        ResultDiv.InnerHtml = html;
    }
</script>
<style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f2f2f2;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        h1 {
            text-align: center;
            margin-bottom: 20px;
            color: #333;
        }
        button {
            display: block;
            margin: 0 auto;
            padding: 10px 20px;
            font-size: 16px;
            background-color: #007bff;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        button:hover {
            background-color: #0056b3;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
        img {
            width: 100px;
            height: 100px;
            display: block;
            margin: 0 auto;
        }
    </style>
</html>