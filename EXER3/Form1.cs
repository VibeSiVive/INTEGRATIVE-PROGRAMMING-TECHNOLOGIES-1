using System;
using System.Windows.Forms;
using progexer3;

namespace WindowsFormsApplication1
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
            comboBox1.SelectedIndexChanged += comboBox1_SelectedIndexChanged;
            listView1.Click += listView1_Click;
            btn_Insert.Click += btn_Insert_Click;
            btn_Update.Click += btn_Update_Click;
            btn_Delete.Click += btn_Delete_Click;
            btn_Refresh.Click += btn_Refresh_Click;
            btn_NewCategory.Click += btn_NewCategory_Click;
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            LoadClasses();
            LoadAllProducts();
        }

        private void LoadClasses()
        {
            comboBox1.Items.Clear();
            ProgExer3 b = new ProgExer3("vive");
            string[] classes = b.getClasses(); // Get the array of classes
            foreach (string cls in classes)
            {
                comboBox1.Items.Add(cls);
            }
        }

        private void LoadAllProducts()
        {
            ProgExer3 b = new ProgExer3("vive");
            string[][] data = b.getData("products"); // Get all products
            DisplayDataInListView(data);
        }

        private void LoadProductsByClass(string className)
        {
            ProgExer3 b = new ProgExer3("vive");
            string[][] data = b.getDataByClass(className); // Get data filtered by class
            DisplayDataInListView(data);
        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            string selectedClass = comboBox1.SelectedItem.ToString();
            if (!string.IsNullOrEmpty(selectedClass))
            {
                LoadProductsByClass(selectedClass);
            }
        }

        private void btn_NewCategory_Click(object sender, EventArgs e)
        {
            string newClass = comboBox1.Text.Trim();
            if (!string.IsNullOrEmpty(newClass))
            {
                ProgExer3 b = new ProgExer3("vive");
                b.insertClass(newClass);
                LoadClasses(); // Refresh the combobox with the new class
                comboBox1.SelectedItem = newClass; // Select the newly added class
                MessageBox.Show("New class added successfully.");
                LoadProductsByClass(newClass); // Display data for the newly added class
            }
            else
            {
                MessageBox.Show("Please enter a valid class name.");
            }
        }

        private void DisplayDataInListView(string[][] data)
        {
            listView1.Items.Clear();
            listView1.Columns.Clear();
            listView1.View = View.Details;
            listView1.Columns.Add("ID");
            listView1.Columns.Add("Class");
            listView1.Columns.Add("Description");
            listView1.Columns.Add("Price");
            listView1.Columns.Add("Quantity");
            listView1.Columns.Add("Date");
            listView1.Columns.Add("Image");

            foreach (var row in data)
            {
                ListViewItem item = new ListViewItem(row);
                listView1.Items.Add(item);
            }
        }

        private void listView1_Click(object sender, EventArgs e)
        {
            if (listView1.SelectedItems.Count > 0)
            {
                ListViewItem item = listView1.SelectedItems[0];
                // Assuming the ListView columns are in the order: ID, Class, Description, Price, Quantity, Date, Image
                txt_ID.Text = item.SubItems[0].Text;
                comboBox1.Text = item.SubItems[1].Text;
                txt_Description.Text = item.SubItems[2].Text;
                txt_Price.Text = item.SubItems[3].Text;
                txt_Quantity.Text = item.SubItems[4].Text;
                txt_Date.Text = item.SubItems[5].Text;
            }
        }

        private void btn_Refresh_Click(object sender, EventArgs e)
        {
            string selectedClass = comboBox1.Text.Trim();
            if (!string.IsNullOrEmpty(selectedClass))
            {
                LoadProductsByClass(selectedClass);
            }
            else
            {
                LoadAllProducts();
            }
        }

        private void btn_Insert_Click(object sender, EventArgs e)
        {
            string id = txt_ID.Text.Trim();
            string className = comboBox1.Text.Trim();
            string description = txt_Description.Text.Trim();
            string price = txt_Price.Text.Trim();
            string quantity = txt_Quantity.Text.Trim();
            string date = txt_Date.Text.Trim();

            if (!string.IsNullOrEmpty(id) && !string.IsNullOrEmpty(description) && !string.IsNullOrEmpty(price) &&
                !string.IsNullOrEmpty(quantity) && !string.IsNullOrEmpty(date) && !string.IsNullOrEmpty(className))
            {
                ProgExer3 b = new ProgExer3("vive");
                b.insertProduct(id, className, description, price, quantity, date);
                MessageBox.Show("Product added successfully.");
                LoadProductsByClass(className); // Refresh the ListView to include the new product
            }
            else
            {
                MessageBox.Show("Please fill all fields.");
            }
        }

        private void btn_Update_Click(object sender, EventArgs e)
        {
            string id = txt_ID.Text.Trim();
            string className = comboBox1.Text.Trim();
            string description = txt_Description.Text.Trim();
            string price = txt_Price.Text.Trim();
            string quantity = txt_Quantity.Text.Trim();
            string date = txt_Date.Text.Trim();

            if (!string.IsNullOrEmpty(id) && !string.IsNullOrEmpty(className) && !string.IsNullOrEmpty(description) &&
                !string.IsNullOrEmpty(price) && !string.IsNullOrEmpty(quantity) && !string.IsNullOrEmpty(date))
            {
                ProgExer3 b = new ProgExer3("vive");
                b.updateProduct(id, className, description, price, quantity, date);
                MessageBox.Show("Product updated successfully.");
                LoadProductsByClass(className); // Refresh the ListView to reflect the updated product
            }
            else
            {
                MessageBox.Show("Please fill all fields.");
            }
        }

        private void btn_Delete_Click(object sender, EventArgs e)
        {
            string id = txt_ID.Text.Trim();
            string className = comboBox1.Text.Trim();
            if (!string.IsNullOrEmpty(id))
            {
                ProgExer3 b = new ProgExer3("vive");
                b.deleteProduct(id);
                MessageBox.Show("Product deleted successfully.");
                LoadProductsByClass(className); // Refresh the ListView to remove the deleted product
            }
            else
            {
                MessageBox.Show("Please enter a valid ID.");
            }
        }
    }
}
