import java.sql.*;


public class Subject {

    private int subjectId;
    private String subjectName;

    public Subject() {}

    public Subject(int subjectId, String subjectName) {
        this.subjectId = subjectId;
        setSubjectName(subjectName);
    }

    public int getSubjectId() {
        return subjectId;
    }

    public void setSubjectId(int subjectId) {
        if (subjectId > 0) {
            this.subjectId = subjectId;
        } else {
            System.out.println(" Invalid Subject ID!");
        }
    }

    public String getSubjectName() {
        return subjectName;
    }

    public void setSubjectName(String subjectName) {
        if (subjectName != null && !subjectName.trim().isEmpty()) {
            this.subjectName = subjectName.trim();
        } else {
            System.out.println(" Invalid Subject Name!");
        }
    }

   


    public boolean saveToDB() {
        try (Connection con = DbConnection.getConnection()) {
            String sql = "INSERT INTO subject (subjectName) VALUES (?)";
            PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, subjectName);

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    subjectId = rs.getInt(1);
                }
                return true;
            }
        } catch (SQLException e) {
            System.out.println(" Error saving subject: " + e.getMessage());
        }
        return false;
    }

   
    public static LinkedList<Subject> loadAllSubjects() {
        LinkedList<Subject> subjects = new LinkedList<>();
        try (Connection con = DbConnection.getConnection()) {
            String sql = "SELECT * FROM subject";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                int id = rs.getInt("subject_id");
                String name = rs.getString("subject_name");
                subjects.add(new Subject(id, name));
            }
        } catch (SQLException e) {
            System.out.println(" Error loading subjects: " + e.getMessage());
        }
        return subjects;
    }

    @Override
    public String toString() {
        return "Subject ID: " + subjectId + " | Name: " + subjectName;
    }
}
