package javaapplication1;

import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class DBConnect {
    private Connection con;
    private Statement st;
    private ResultSet rs;

    public DBConnect() {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/vive?useSSL=false&zeroDateTimeBehavior=convertToNull", "root", "root");
            st = con.createStatement();
        } catch (Exception ex) {
            System.out.println("Error: " + ex);
        }
    }

    public void insertData(String className, String description, String price, String quantity, String date) {
        try {
            String query = "INSERT INTO products (Class, Description, Price, Quantity, Date) VALUES ('" + className + "', '" + description + "', '" + price + "', " + quantity + ", '" + date + "')";
            st.executeUpdate(query);
            System.out.println("Data inserted into the database");
            getData("inserted_data");
        } catch (Exception ex) {
            System.out.println(ex);
        }
    }

    public void updateData(String id, String className, String description, String price, String quantity, String date) {
        try {
            String query = "UPDATE products SET Class='" + className + "', Description='" + description + "', Price='" + price + "', Quantity=" + quantity + ", Date='" + date + "' WHERE ID=" + id;
            st.executeUpdate(query);
            System.out.println("Data updated in the database");
            getData("updated_data");
        } catch (Exception ex) {
            System.out.println(ex);
        }
    }

    public void deleteData(String id) {
        try {
            String query = "DELETE FROM products WHERE ID=" + id;
            st.executeUpdate(query);
            System.out.println("Data deleted from the database");
            getData("updated_data");
        } catch (Exception ex) {
            System.out.println(ex);
        }
    }

    public void getData(String a) {
        PrintWriter writer;
        try {
            String query2 = "select * from products";
            rs = st.executeQuery(query2);
            System.out.println("Records from Database");

            writer = new PrintWriter("C:\\Users\\vboxuser\\Desktop\\EXER2\\" + a + ".xml", "UTF-8");
            writer.println("<?xml version='1.0'?>");
            writer.println("<products>");

            while (rs.next()) {
                String id = String.valueOf(rs.getInt("ID"));
                String className = rs.getString("Class");
                String description = rs.getString("Description");
                String price = rs.getString("Price");
                String quantity = String.valueOf(rs.getInt("Quantity"));
                String date = rs.getString("Date");

                writer.println("<product ID='" + id + "' Class='" + className + "' Description='" + description + "' Price='" + price + "' Quantity='" + quantity + "' Date='" + date + "'></product>");
                System.out.println("\nID: " + id + "\nClass: " + className + "\nDescription: " + description + "\nPrice: " + price + "\nQuantity: " + quantity + "\nDate: " + date);
            }

            writer.println("</products>");
            writer.close();
            System.out.println("XML file created successfully.");
        } catch (Exception ex) {
            System.out.println(ex);
        }
    }
}
