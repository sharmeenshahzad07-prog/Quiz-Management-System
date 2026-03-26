import java.sql.*;
import java.util.List;

public class TeachermanageDb {

    public static boolean assignSectionToTeacherDB(Teacher teacher, Section section) {

    for (Section s : teacher.getSections()) {
        if (s.getSectionId() == section.getSectionId()) {
            System.out.println("Section already assigned.");
            return false;
        }
    }

    String sql = "INSERT INTO teachersection (teacher_id, section_id) VALUES (?, ?)";
    try (Connection con = DbConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, teacher.getTeacherId());
        ps.setInt(2, section.getSectionId());
        ps.executeUpdate();

        teacher.addSection(section); 
        System.out.println(" Section " + section.getSectionName() + " assigned to DB!");
        return true;

    } catch (SQLException e) {
        System.out.println("Error assigning section in DB: " + e.getMessage());
        return false;
    }
}


   
    public static boolean assignSubjectToTeacherDB(Teacher teacher, Subject subject) {
      
        if (teacher.getSubjects().stream().anyMatch(s -> s.getSubjectId() == subject.getSubjectId())) {
            System.out.println("Subject already assigned.");
            return false;
        }

        String sql = "INSERT INTO teacher_subject (teacher_id, subject_id) VALUES (?, ?)";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, teacher.getTeacherId());
            ps.setInt(2, subject.getSubjectId());
            ps.executeUpdate();

            teacher.addSubject(subject);
            System.out.println(" Subject " + subject.getSubjectName() + " assigned.");
            return true;

        } catch (SQLException e) {
            System.out.println("Subject already exists in DB or DB error.");
            return false;
        }
    }

   
    public static void loadSubjectsFromDB(Teacher teacher, List<Subject> allSubjects) {
        String sql = "SELECT subject_id FROM teacher_subject WHERE teacher_id = ?";

        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, teacher.getTeacherId());
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                int subId = rs.getInt("subject_id");

                allSubjects.stream()
                        .filter(sub -> sub.getSubjectId() == subId)
                        .filter(sub -> !teacher.getSubjects().contains(sub))
                        .findFirst()
                        .ifPresent(teacher::addSubject);
            }

        } catch (SQLException e) {
            System.out.println(" Error loading subjects: " + e.getMessage());
        }
    }

    public static boolean removeSubjectFromTeacherDB(Teacher teacher, Subject subject) {
        String sql = "DELETE FROM teacher_subject WHERE teacher_id=? AND subject_id=?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, teacher.getTeacherId());
            ps.setInt(2, subject.getSubjectId());
            int rows = ps.executeUpdate();

            if (rows > 0) {
                teacher.removeSubject(subject);
                System.out.println(" Subject " + subject.getSubjectName() + " removed.");
                return true;
            } else {
                System.out.println(" Subject not found in DB.");
                return false;
            }

        } catch (SQLException e) {
            System.out.println("⚠ Error removing subject: " + e.getMessage());
            return false;
        }
    }

public static boolean removeSectionFromTeacherDB(Teacher teacher, Section section) {
    String sql = "DELETE FROM teachersection WHERE teacher_id=? AND section_id=?";
    try (Connection con = DbConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, teacher.getTeacherId());
        ps.setInt(2, section.getSectionId());
        int rows = ps.executeUpdate();

        if (rows > 0) {
            teacher.removeSection(section); 
            System.out.println("Section " + section.getSectionName() + " removed successfully from DB!");
            return true;
        } else {
            System.out.println("Section not assigned to this teacher in DB!");
            return false;
        }

    } catch (SQLException e) {
        System.out.println("Error removing section from DB: " + e.getMessage());
        return false;
    }
}


public static void loadSectionsFromDB(Teacher teacher, List<Section> allSections) {
    String sql = "SELECT section_id FROM teachersection WHERE teacher_id=?";

    try (Connection con = DbConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, teacher.getTeacherId());
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            int secId = rs.getInt("section_id");

            for (Section sec : allSections) {
                if (sec.getSectionId() == secId &&
                    !teacher.getSections().contains(sec)) {
                    teacher.addSection(sec);
                }
            }
        }

    } catch (SQLException e) {
        System.out.println("Error loading sections for teacher.");
    }
}

}
