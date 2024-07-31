use Tk;
use Tk::BrowseEntry;
use Time::Piece;

use Inline Java => <<'END', CLASSPATH => 'C:\Users\vboxuser\Documents\Perl\mysql-connector-java-5.1.47.jar', AUTOSTUDY => 1;
import java.sql.*;
public class Products {
    int id; 
    String className; 
    String description; 
    double price; 
    int quantity; 
    String date; 
    String image; 
    Connection con; 
    Statement st; 
    ResultSet rs;

    public Products() {
        initializeDB();
    }

    public Products(int id, String className, String description, double price, int quantity, String date, String image) {
        this.id = id;
        this.className = className;
        this.description = description;
        this.price = price;
        this.quantity = quantity;
        this.date = date;
        this.image = image;
        initializeDB();
    }

    private void initializeDB() {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/vive?zeroDateTimeBehavior=convertToNull&useSSL=false", "root", "root");
            st = con.createStatement();
        } catch (Exception ex) {
            System.out.println("Error: " + ex);
        }
    }

    public String insertData() {
        try {
            String query = "insert into products (ID, Class, Description, Price, Quantity, Date, Image) values(" 
                            + this.id + ",'" + this.className + "','" + this.description + "','" 
                            + this.price + "','" + this.quantity + "','" + this.date + "','" + this.image + "')";
            st.executeUpdate(query);
        } catch(Exception ex) {
            System.out.println(ex);
            return "Insert Failed: " + ex.getMessage();
        }
        return "Inserted";
    }

    public String deleteData(int id) {
        try {
            String query = "delete from products where ID=" + id;
            st.executeUpdate(query);
        } catch(Exception ex) {
            System.out.println(ex);
            return "Delete Failed: " + ex.getMessage();
        }
        return "Deleted";
    }

    public String updateData(int id, String className, String description, double price, int quantity, String date, String image) {
        try {
            String query = "update products set Class='" + className + "', Description='" + description + "', Price=" + price + ", Quantity=" + quantity + ", Date='" + date + "', Image='" + image + "' where ID=" + id;
            st.executeUpdate(query);
        } catch(Exception ex) {
            System.out.println(ex);
            return "Update Failed: " + ex.getMessage();
        }
        return "Updated";
    }

    public String[][] selectAllProducts() {
        return selectProductsByClass("");
    }

    public String[][] selectProductsByClass(String className) {
        String[][] resultArray = new String[0][0]; // Initialize empty 2D array
        try {
            String query = "SELECT ID, Class, Description, Price, Quantity, Date, Image FROM products";
            if (!className.isEmpty()) {
                query += " WHERE Class='" + className + "'";
            }
            rs = st.executeQuery(query);
            rs.last();
            int rowCount = rs.getRow();
            rs.beforeFirst();
            resultArray = new String[rowCount][7];
            int rowIndex = 0;
            while (rs.next()) {
                resultArray[rowIndex][0] = Integer.toString(rs.getInt("ID"));
                resultArray[rowIndex][1] = rs.getString("Class");
                resultArray[rowIndex][2] = rs.getString("Description");
                resultArray[rowIndex][3] = Double.toString(rs.getDouble("Price"));
                resultArray[rowIndex][4] = Integer.toString(rs.getInt("Quantity"));
                resultArray[rowIndex][5] = rs.getString("Date");
                resultArray[rowIndex][6] = rs.getString("Image");
                rowIndex++;
            }
        } catch (SQLException ex) {
            System.out.println("Error executing query: " + ex);
        }
        return resultArray;
    }

    public String[] selectCategories() {
        String[] categories = new String[0];
        try {
            String query = "SELECT DISTINCT Class FROM products";
            rs = st.executeQuery(query);
            rs.last();
            int rowCount = rs.getRow();
            rs.beforeFirst();
            categories = new String[rowCount];
            int rowIndex = 0;
            while (rs.next()) {
                categories[rowIndex] = rs.getString("Class");
                rowIndex++;
            }
        } catch (SQLException ex) {
            System.out.println("Error executing query: " + ex);
        }
        return categories;
    }

    public String insertCategory(String className) {
        try {
            String query = "insert into products (Class) select * from (select '" + className + "') as tmp where not exists (select Class from products where Class = '" + className + "') limit 1";
            st.executeUpdate(query);
        } catch(Exception ex) {
            System.out.println(ex);
            return "Insert Category Failed: " + ex.getMessage();
        }
        return "Category Inserted";
    }
}
END

# Perl Part

# Create the main window
my $mw = MainWindow->new;
$mw->geometry("600x450");
$mw->title("Perl MySQL and Java Integration");

# Create input fields
my $id_label = $mw->Label(-text => "ID")->grid(-row => 0, -column => 0);
my $id_entry = $mw->Entry()->grid(-row => 0, -column => 1);

my $class_label = $mw->Label(-text => "Class")->grid(-row => 1, -column => 0);
my $class_entry = $mw->BrowseEntry()->grid(-row => 1, -column => 1);
$class_entry->configure(-browsecmd => \&refresh_list_by_class);

my $desc_label = $mw->Label(-text => "Description")->grid(-row => 2, -column => 0);
my $desc_entry = $mw->Entry()->grid(-row => 2, -column => 1);

my $price_label = $mw->Label(-text => "Price")->grid(-row => 3, -column => 0);
my $price_entry = $mw->Entry()->grid(-row => 3, -column => 1);

my $quantity_label = $mw->Label(-text => "Quantity")->grid(-row => 4, -column => 0);
my $quantity_entry = $mw->Entry()->grid(-row => 4, -column => 1);

my $date_label = $mw->Label(-text => "Date")->grid(-row => 5, -column => 0);
my $date_entry = $mw->Entry()->grid(-row => 5, -column => 1);

my $image_label = $mw->Label(-text => "Image")->grid(-row => 6, -column => 0);
my $image_entry = $mw->Entry()->grid(-row => 6, -column => 1);

# Create Listbox
my $listbox = $mw->Listbox(-width => 80, -height => 10)->grid(-row => 7, -column => 0, -columnspan => 4);
$listbox->bind('<<ListboxSelect>>', \&on_select_product);

# Create buttons
my $insert_button = $mw->Button(-text => "Insert", -command => \&insert_product)->grid(-row => 8, -column => 0);
my $update_button = $mw->Button(-text => "Update", -command => \&update_product)->grid(-row => 8, -column => 1);
my $delete_button = $mw->Button(-text => "Delete", -command => \&delete_product)->grid(-row => 8, -column => 2);
my $refresh_button = $mw->Button(-text => "Refresh", -command => \&refresh_list)->grid(-row => 8, -column => 3);

my $new_class_label = $mw->Label(-text => "New Category")->grid(-row => 9, -column => 0);
my $new_class_entry = $mw->Entry()->grid(-row => 9, -column => 1);
my $new_class_button = $mw->Button(-text => "Add Category", -command => \&insert_category)->grid(-row => 9, -column => 2);

MainLoop;

sub insert_product {
    my $id = $id_entry->get();
    my $className = $class_entry->Subwidget('entry')->get();
    my $description = $desc_entry->get();
    my $price = $price_entry->get();
    my $quantity = $quantity_entry->get();
    my $date = $date_entry->get();
    my $image = $image_entry->get();

    # Validate the date format
    eval {
        Time::Piece->strptime($date, '%Y-%m-%d');
    };
    if ($@) {
        print "Invalid date format. Please use YYYY-MM-DD.\n";
        return;
    }

    my $obj = Products->new($id, $className, $description, $price, $quantity, $date, $image);
    print $obj->insertData() . "\n";
    refresh_list_by_class();
}

sub update_product {
    my $id = $id_entry->get();
    my $className = $class_entry->Subwidget('entry')->get();
    my $description = $desc_entry->get();
    my $price = $price_entry->get();
    my $quantity = $quantity_entry->get();
    my $date = $date_entry->get();
    my $image = $image_entry->get();

    # Validate the date format
    eval {
        Time::Piece->strptime($date, '%Y-%m-%d');
    };
    if ($@) {
        print "Invalid date format. Please use YYYY-MM-DD.\n";
        return;
    }

    my $obj = Products->new();
    print $obj->updateData($id, $className, $description, $price, $quantity, $date, $image) . "\n";
    refresh_list_by_class();
}

sub delete_product {
    my @selected_indices = $listbox->curselection();
    if (@selected_indices) {
        my $selected_index = $selected_indices[0];
        my $product = $listbox->get($selected_index);
        my ($id, $className, $description, $price, $quantity, $date, $image) = split /: |, /, $product;
        my $obj = Products->new();
        print $obj->deleteData($id) . "\n";
        refresh_list_by_class();
    }
}

sub insert_category {
    my $new_class = $new_class_entry->get();
    if ($new_class ne "") {
        my $obj = Products->new();
        print $obj->insertCategory($new_class) . "\n";
        refresh_categories();
    }
}

sub refresh_list {
    $listbox->delete(0, 'end');
    my $obj = Products->new();
    my $resultArray = $obj->selectAllProducts();
    foreach my $row (@$resultArray) {
        my ($id, $className, $description, $price, $quantity, $date, $image) = @$row;
        $listbox->insert('end', "$id: $className, $description, $price, $quantity, $date, $image");
    }
    refresh_categories();
}

sub refresh_list_by_class {
    my $selected_class = $class_entry->Subwidget('entry')->get();
    $listbox->delete(0, 'end');
    my $obj = Products->new();
    my $resultArray = $obj->selectProductsByClass($selected_class);
    foreach my $row (@$resultArray) {
        my ($id, $className, $description, $price, $quantity, $date, $image) = @$row;
        $listbox->insert('end', "$id: $className, $description, $price, $quantity, $date, $image");
    }
}

sub refresh_categories {
    my $obj = Products->new();
    my $categories_ref = $obj->selectCategories();
    $class_entry->delete(0, 'end');
    foreach my $category (@$categories_ref) {
        $class_entry->insert('end', $category);
    }
}

sub on_select_product {
    my @selected_indices = $listbox->curselection();
    if (@selected_indices) {
        my $selected_index = $selected_indices[0];
        my $product = $listbox->get($selected_index);
        my ($id, $className, $description, $price, $quantity, $date, $image) = split /: |, /, $product;
        $id_entry->delete(0, 'end');
        $id_entry->insert(0, $id);
        $desc_entry->delete(0, 'end');
        $desc_entry->insert(0, $description);
        $price_entry->delete(0, 'end');
        $price_entry->insert(0, $price);
        $quantity_entry->delete(0, 'end');
        $quantity_entry->insert(0, $quantity);
        $date_entry->delete(0, 'end');
        $date_entry->insert(0, $date);
        $image_entry->delete(0, 'end');
        $image_entry->insert(0, $image);
    }
}

# Initial refresh to populate the categories 
refresh_categories();
