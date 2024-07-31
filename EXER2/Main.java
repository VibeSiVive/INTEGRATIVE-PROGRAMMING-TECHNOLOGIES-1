package javaapplication1;

public class Main {
    public static void main(String[] args) {
        DBConnect dbConnect = new DBConnect();
        if ("insert".equals(args[0])) {
            dbConnect.insertData(args[1], args[2], args[3], args[4], args[5]);
        } else if ("update".equals(args[0])) {
            dbConnect.updateData(args[1], args[2], args[3], args[4], args[5], args[6]);
        } else if ("delete".equals(args[0])) {
            dbConnect.deleteData(args[1]);
        } else {
            dbConnect.getData(args[0]);
        }
    }
}
