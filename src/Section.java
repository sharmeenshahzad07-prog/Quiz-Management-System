
import java.sql.*;


public class Section {

    private int sectionId;
    private String sectionName;
    private String courseName;       
    private int strength;           
    private LinkedList<Student> students;

    public Section() {
        students = new LinkedList<>();
        strength = 30; 
    }

    public Section(int sectionId, String sectionName, String courseName, int strength) {
        this.sectionId = sectionId;
        this.sectionName = sectionName;
        this.courseName = courseName;
        this.strength = strength; 
        students = new LinkedList<>();
    }

    public Section(int secId, String secName) {
        this.sectionId = secId;
        this.sectionName = secName;
        students = new LinkedList<>();
    }

    public int getSectionId() { return sectionId; }
    public String getSectionName() { return sectionName; }
    public String getCourseName() { return courseName; }
    public int getStrength() { return strength; }
    public LinkedList<Student> getStudents() { return students; }

    public void setSectionId(int sectionId) { this.sectionId = sectionId; }
    public void setSectionName(String sectionName) { this.sectionName = sectionName; }
    public void setCourseName(String courseName) { this.courseName = courseName; }
    public void setStrength(int strength) { this.strength = strength; }

   
    public boolean addStudent(Student s) {
        if (s == null) return false;
        if (!students.contains(s) && students.size() < strength) {
            students.add(s);
            s.setAssignedSection(this);
            return true;
        }
        return false;
    }

    public void removeStudent(Student s) {
        if (students.contains(s)) {
            students.remove(s);
            s.setAssignedSection(null); 
        }
    }

    public int availableSeats() {
        return strength - students.size();
    }

    @Override
    public String toString() {
        return "Section [ID: " + sectionId + ", Name: " + sectionName + 
               ", Course: " + courseName + ", Seats: " + strength + 
               ", Enrolled: " + students.size() + "]";
    }


    public boolean saveToDB() {
        try (Connection con = DbConnection.getConnection()) {
            String sql = "INSERT INTO section (section_name, subject_name, strength) VALUES (?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, sectionName);
            ps.setString(2, courseName);
            ps.setInt(3, strength);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) sectionId = rs.getInt(1);
                return true;
            }
        } catch (SQLException e) {
            System.out.println("Error saving section: " + e.getMessage());
        }
        return false;
    }

    public static LinkedList<Section> loadAllSections() {
        LinkedList<Section> sections = new LinkedList<>();
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT * FROM section");
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                int id = rs.getInt("section_id");
                String name = rs.getString("section_name");
                String course = rs.getString("subject_name");
                int strength = rs.getInt("strength");

                sections.add(new Section(id, name, course, strength));
            }

        } catch (SQLException e) {
            System.out.println("Error loading sections: " + e.getMessage());
        }
        return sections;
    }
}
