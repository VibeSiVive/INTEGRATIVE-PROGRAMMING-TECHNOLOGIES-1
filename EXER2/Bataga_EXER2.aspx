<%@ Page Language="C#" Debug="true" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.Diagnostics" %>
<%@ Import Namespace="System.IO" %>

<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f4f4f9;
        margin: 0;
        padding: 0;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
    }

    .container {
        background-color: #fff;
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }

    h2 {
        text-align: center;
        color: #333;
    }

    label {
        display: block;
        margin-top: 10px;
        color: #555;
    }

    input[type="text"] {
        width: 100%;
        padding: 8px;
        margin-top: 5px;
        border: 1px solid #ccc;
        border-radius: 4px;
    }

    input[type="submit"] {
        width: 100%;
        padding: 10px;
        margin-top: 15px;
        border: none;
        border-radius: 4px;
        background-color: #28a745;
        color: white;
        font-size: 16px;
        cursor: pointer;
    }

    input[type="submit"]:hover {
        background-color: #218838;
    }

    table {
        width: 100%;
        margin-top: 20px;
        border-collapse: collapse;
    }

    table, th, td {
        border: 1px solid #ccc;
    }

    th, td {
        padding: 10px;
        text-align: left;
    }

    th {
        background-color: #f4f4f9;
        color: #333;
    }
</style>

<script runat="server">
    private string exePath = @"C:\Users\vboxuser\Desktop\ikvm-8.1.5717.0\bin\JavaApplication1.exe";

    protected void Page_Load(object sender, EventArgs e) {
        if (!IsPostBack) {
            RunDos(sender, e);
        }
    }

    private void RunDos(object sender, EventArgs e) {
        try {
            if (!File.Exists(exePath)) {
                Response.Write("Error in RunDos: File not found at " + exePath + "<br/>");
                return;
            }
            ProcessStartInfo info = new ProcessStartInfo();
            info.FileName = exePath;
            info.Arguments = "inserted_data";
            info.WindowStyle = ProcessWindowStyle.Normal;
            info.UseShellExecute = false;
            info.RedirectStandardOutput = true;
            info.RedirectStandardError = true;
            info.WorkingDirectory = Path.GetDirectoryName(exePath); // Set working directory if needed
            Process pro = Process.Start(info);
            pro.WaitForExit();
        } catch (Exception ex) {
            Response.Write("Error in RunDos: " + ex.Message + "<br/>");
        }
    }

    private void insert(object sender, EventArgs e) {
        try {
            string className = classInput.Value;
            string description = descriptionInput.Value;
            string price = priceInput.Value;
            string quantity = quantityInput.Value;
            string date = dateInput.Value;

            Response.Write("Class: " + className + ", Description: " + description + ", Price: " + price + ", Quantity: " + quantity + ", Date: " + date + "<br/>");

            if (!File.Exists(exePath)) {
                Response.Write("Error in insert: File not found at " + exePath + "<br/>");
                return;
            }

            ProcessStartInfo info = new ProcessStartInfo();
            info.FileName = exePath;
            info.Arguments = "insert " + className + " " + description + " " + price + " " + quantity + " " + date;
            info.WindowStyle = ProcessWindowStyle.Normal;
            info.UseShellExecute = false;
            info.RedirectStandardOutput = true;
            info.RedirectStandardError = true;
            info.WorkingDirectory = Path.GetDirectoryName(exePath); // Set working directory if needed
            Process pro = Process.Start(info);
            pro.WaitForExit();
            RunDos(sender, e);
        } catch (Exception ex) {
            Response.Write("Error in insert: " + ex.Message + "<br/>");
        }
    }

    private void update(object sender, EventArgs e) {
        try {
            string id = idInput.Value;
            string className = classInput.Value;
            string description = descriptionInput.Value;
            string price = priceInput.Value;
            string quantity = quantityInput.Value;
            string date = dateInput.Value;

            Response.Write("ID: " + id + ", Class: " + className + ", Description: " + description + ", Price: " + price + ", Quantity: " + quantity + ", Date: " + date + "<br/>");

            if (!File.Exists(exePath)) {
                Response.Write("Error in update: File not found at " + exePath + "<br/>");
                return;
            }

            ProcessStartInfo info = new ProcessStartInfo();
            info.FileName = exePath;
            info.Arguments = "update " + id + " " + className + " " + description + " " + price + " " + quantity + " " + date;
            info.WindowStyle = ProcessWindowStyle.Normal;
            info.UseShellExecute = false;
            info.RedirectStandardOutput = true;
            info.RedirectStandardError = true;
            info.WorkingDirectory = Path.GetDirectoryName(exePath); // Set working directory if needed
            Process pro = Process.Start(info);
            pro.WaitForExit();
            RunDos(sender, e);
        } catch (Exception ex) {
            Response.Write("Error in update: " + ex.Message + "<br/>");
        }
    }

    private void delete(object sender, EventArgs e) {
        try {
            string id = idInput.Value;

            Response.Write("ID: " + id + "<br/>");

            if (!File.Exists(exePath)) {
                Response.Write("Error in delete: File not found at " + exePath + "<br/>");
                return;
            }

            ProcessStartInfo info = new ProcessStartInfo();
            info.FileName = exePath;
            info.Arguments = "delete " + id;
            info.WindowStyle = ProcessWindowStyle.Normal;
            info.UseShellExecute = false;
            info.RedirectStandardOutput = true;
            info.RedirectStandardError = true;
            info.WorkingDirectory = Path.GetDirectoryName(exePath); // Set working directory if needed
            Process pro = Process.Start(info);
            pro.WaitForExit();
            RunDos(sender, e);
        } catch (Exception ex) {
            Response.Write("Error in delete: " + ex.Message + "<br/>");
        }
    }

    private void show(object sender, EventArgs e) {
        try {
            XmlDocument document = new XmlDocument();
            document.Load(@"C:\Users\vboxuser\Desktop\EXER2\inserted_data.xml");
            XmlNodeList nodes = document.SelectNodes("/products/product");

            string html = "<table><tr><th>ID</th><th>Class</th><th>Description</th><th>Price</th><th>Quantity</th><th>Date</th></tr>";
            foreach (XmlNode items in nodes) {
                string printid = items.Attributes["ID"].Value.ToString();
                string printClass = items.Attributes["Class"].Value.ToString();
                string printDescription = items.Attributes["Description"].Value.ToString();
                string printPrice = items.Attributes["Price"].Value.ToString();
                string printQuantity = items.Attributes["Quantity"].Value.ToString();
                string printDate = items.Attributes["Date"].Value.ToString();

                html += "<tr><td>" + printid + "</td><td>" + printClass + "</td><td>" + printDescription + "</td><td>" + printPrice + "</td><td>" + printQuantity + "</td><td>" + printDate + "</td></tr>";
            }
            html += "</table>";
            ResultDiv.InnerHtml = html;
        } catch (Exception ex) {
            Response.Write("Error in show: " + ex.Message + "<br/>");
        }
    }
</script>

<html>
<head>
    <title>Product Management</title>
</head>
<body>
    <div class="container">
        <h2>Product Management</h2>
        <form runat="server">
            <div>
                <label><strong>Enter ID:</strong></label>
                <input type="text" id="idInput" name="idInput" runat="server" />

                <label>Enter Class:</label>
                <input type="text" id="classInput" name="classInput" runat="server" />

                <label>Enter Description:</label>
                <input type="text" id="descriptionInput" name="descriptionInput" runat="server" />

                <label>Enter Price:</label>
                <input type="text" id="priceInput" name="priceInput" runat="server" />

                <label>Enter Quantity:</label>
                <input type="text" id="quantityInput" name="quantityInput" runat="server" />

                <label>Enter Date:</label>
                <input type="text" id="dateInput" name="dateInput" runat="server" />

                <input id="button1" type="submit" value="Show" onServerClick="show" runat="server" />
                <input id="button2" type="submit" value="Insert data" onServerClick="insert" runat="server" />
                <input id="button3" type="submit" value="Update data" onServerClick="update" runat="server" />
                <input id="button4" type="submit" value="Delete data" onServerClick="delete" runat="server" />
            </div>
            <div id="ResultDiv" runat="server"></div>
        </form>
    </div>
</body>
</html>
