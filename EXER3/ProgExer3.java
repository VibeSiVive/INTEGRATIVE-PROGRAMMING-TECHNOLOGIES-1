package progexer3;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProgExer3 {
    private Connection con;
    private Statement st;
    private ResultSet rs;

    public ProgExer3() {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/vive?zeroDateTimeBehavior=convertToNull", "root", "root");
            st = con.createStatement();
        } catch (Exception ex) {
            System.out.println("Error: " + ex);
        }
    }

    public ProgExer3(String db) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/" + db + "?zeroDateTimeBehavior=convertToNull", "root", "root");
            st = con.createStatement();
        } catch (Exception ex) {
            System.out.println("Error: " + ex);
        }
    }

    public String[] getClasses() {
        List<String> classes = new ArrayList<>();
        try {
            String query = "SELECT DISTINCT Class FROM products";
            rs = st.executeQuery(query);
            while (rs.next()) {
                classes.add(rs.getString("Class"));
            }
        } catch (Exception ex) {
            System.out.println("Error: " + ex);
        }
        return classes.toArray(new String[0]);
    }

    public String[][] getData(String tableName) {
        List<String[]> products = new ArrayList<>();
        try {
            String query = "SELECT ID, Class, Description, Price, Quantity, Date, Image FROM " + tableName;
            rs = st.executeQuery(query);
            while (rs.next()) {
                String[] product = new String[7];
                product[0] = rs.getString("ID");
                product[1] = rs.getString("Class");
                product[2] = rs.getString("Description");
                product[3] = rs.getString("Price");
                product[4] = rs.getString("Quantity");
                product[5] = rs.getString("Date");
                product[6] = rs.getString("Image");
                products.add(product);
            }
        } catch (Exception ex) {
            System.out.println("Error: " + ex);
        }
        return products.toArray(new String[0][0]);
    }

    public String[][] getDataByClass(String className) {
        List<String[]> products = new ArrayList<>();
        try {
            String query = "SELECT ID, Class, Description, Price, Quantity, Date, Image FROM products WHERE Class = ?";
            PreparedStatement pstmt = con.prepareStatement(query);
            pstmt.setString(1, className);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                String[] product = new String[7];
                product[0] = rs.getString("ID");
                product[1] = rs.getString("Class");
                product[2] = rs.getString("Description");
                product[3] = rs.getString("Price");
                product[4] = rs.getString("Quantity");
                product[5] = rs.getString("Date");
                product[6] = rs.getString("Image");
                products.add(product);
            }
        } catch (Exception ex) {
            System.out.println("Error: " + ex);
        }
        return products.toArray(new String[0][0]);
    }

    public void insertClass(String newClass) {
        try {
            String query = "INSERT INTO products (Class) VALUES (?)";
            PreparedStatement pstmt = con.prepareStatement(query);
            pstmt.setString(1, newClass);
            pstmt.executeUpdate();
        } catch (Exception ex) {
            System.out.println("Error: " + ex);
        }
    }

    public void insertProduct(String id, String className, String description, String price, String quantity, String date) {
        try {
            String query = "INSERT INTO products (ID, Class, Description, Price, Quantity, Date) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement pstmt = con.prepareStatement(query);
            pstmt.setString(1, id);
            pstmt.setString(2, className);
            pstmt.setString(3, description);
            pstmt.setString(4, price);
            pstmt.setString(5, quantity);
            pstmt.setString(6, date);
            pstmt.executeUpdate();
        } catch (Exception ex) {
            System.out.println("Error: " + ex);
        }
    }

    public void updateProduct(String id, String className, String description, String price, String quantity, String date) {
        try {
            String query = "UPDATE products SET Class = ?, Description = ?, Price = ?, Quantity = ?, Date = ? WHERE ID = ?";
            PreparedStatement pstmt = con.prepareStatement(query);
            pstmt.setString(1, className);
            pstmt.setString(2, description);
            pstmt.setString(3, price);
            pstmt.setString(4, quantity);
            pstmt.setString(5, date);
            pstmt.setString(6, id);
            pstmt.executeUpdate();
        } catch (Exception ex) {
            System.out.println("Error: " + ex);
        }
    }
    public void deleteProduct(String id) {
        try {
            String query = "DELETE FROM products WHERE ID = ?";
            PreparedStatement pstmt = con.prepareStatement(query);
            pstmt.setString(1, id);
            pstmt.executeUpdate();
        } catch (Exception ex) {
            System.out.println("Error: " + ex);
        }
    }
}

