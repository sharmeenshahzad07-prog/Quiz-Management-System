import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class App {
    public static void main(String[] args) {
      
        String url = "jdbc:mysql://localhost:3306/examination_system";
        String username = "root"; 
        String password = ""; 

        try {
          
            Class.forName("com.mysql.cj.jdbc.Driver");

      
            Connection con = DriverManager.getConnection(url, username, password);
            System.out.println("Connected to MySQL database!");

           
            Statement stmt = con.createStatement();

          
            String query = "SELECT * FROM student"; 
            ResultSet rs = stmt.executeQuery(query);

         
            while (rs.next()) {
                System.out.println("ID: " + rs.getInt("user_id") + ", Name: " + rs.getString("name"));
            }


            rs.close();
            stmt.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

