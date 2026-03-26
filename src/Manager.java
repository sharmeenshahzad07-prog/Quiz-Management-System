import java.sql.*;

import java.util.Scanner;

public class Manager {

    private LinkedList<Student> students = new LinkedList<>();
    private LinkedList<Teacher> teachers = new LinkedList<>();
    private LinkedList<Section> sections = new LinkedList<>();
    private LinkedList<Subject> subjects = new LinkedList<>();
    private Admin admin;
    private int teacherId;

    public Manager() {
    students = new LinkedList<>();
    teachers = new LinkedList<>();
    sections = new LinkedList<>();
    subjects = new LinkedList<>();
    
}

    public LinkedList<Teacher> getTeachers() { return teachers; }
    public LinkedList<Student> getStudents() { return students; }
    public LinkedList<Section> getSections() { return sections; }
    public LinkedList<Subject> getSubjects() { return subjects; }
    public Admin getAdmin() { return admin; }
    public void setTeacherId(int teacherId) {
    this.teacherId = teacherId;
}

    public void fetchAllDataFromDB() {
        fetchAdmin();
        
        fetchSubjects();
        fetchSections();
        fetchTeachers();
        fetchStudents();
       
    }

    private void fetchAdmin() {
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT * FROM user WHERE role='ADMIN' LIMIT 1");
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                admin = new Admin(
                        rs.getInt("user_id"), rs.getString("name"),rs.getString("email"),rs.getString("password")
                );
            }

        } catch (SQLException e) {
            System.out.println("Error while fetching");
        }
    }

    private void fetchTeachers() {
        teachers.clear();
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT * FROM teacher t JOIN user u ON t.teacher_id = u.user_id");
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Teacher t = new Teacher(
                        rs.getInt("teacher_id"), rs.getString("name"), rs.getString("email"),
                         rs.getString("password"));
                        teachers.add(t);
            }
            
            
            for (Teacher teacher : teachers) {
                loadTeacherSections(teacher, con);
                loadTeacherSubjects(teacher, con);
            }

        } catch (SQLException e) {
            System.out.println("Error while fetching teachers: " + e.getMessage());
        }
    }
    
    private void loadTeacherSections(Teacher teacher, Connection con) {
        String query = "SELECT s.section_id, s.section_name, s.strength FROM section s " +
                      "JOIN teachersection ts ON s.section_id = ts.section_id " +
                      "WHERE ts.teacher_id = ?";
        try (PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, teacher.getTeacherId());
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Section section = getSectionById(rs.getInt("section_id"));
                if (section != null) {
                    teacher.addSection(section);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error loading sections for teacher " + teacher.getTeacherId() + ": " + e.getMessage());
        }
    }
    
    private void loadTeacherSubjects(Teacher teacher, Connection con) {
        String query = "SELECT sub.subject_id, sub.subject_name FROM subject sub " +
                      "JOIN teacher_subject ts ON sub.subject_id = ts.subject_id " +
                      "WHERE ts.teacher_id = ?";
        try (PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, teacher.getTeacherId());
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Subject subject = getSubjectById(rs.getInt("subject_id"));
                if (subject != null) {
                    teacher.addSubject(subject);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error loading subjects for teacher " + teacher.getTeacherId() + ": " + e.getMessage());
        }
    }

    private void fetchStudents() {
        students.clear();
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT s.student_id, s.roll_no, s.section_id, u.name, u.email, u.password FROM student s JOIN user u ON s.student_id = u.user_id");
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                int sectionId = rs.getInt("section_id");
                Section sec = getSectionById(sectionId);
               Student st = new Student(
                rs.getInt("student_id"), 
                rs.getString("name"), 
                rs.getString("email"),
                rs.getString("password"),
                rs.getString("roll_no"),  
                sec);
                students.add(st);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private void fetchSubjects() {
        subjects.clear();
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT * FROM subject");
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                subjects.add(new Subject(
                        rs.getInt("subject_id"),
                        rs.getString("subject_name")
                ));
            }

        } catch (SQLException e) {
            System.out.println("Error while fetching");
        }
    }

   private void fetchSections() {
    sections.clear();
    try (Connection con = DbConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(
                 "SELECT sec.section_id, sec.section_name, sec.strength, sub.subject_name " +
                 "FROM section sec JOIN subject sub ON sec.subject_id = sub.subject_id");
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            int id = rs.getInt("section_id");
            String name = rs.getString("section_name");
            String course = rs.getString("subject_name");
            int strength = rs.getInt("strength");

            sections.add(new Section(id, name, course, strength));
        }

    } catch (SQLException e) {
        System.out.println("Error fetching sections: " + e.getMessage());
    }
}



   
    public Section getSectionById(int id) {
        for (Section s : sections) if (s.getSectionId() == id) return s;
        return null;
    }

    public Subject getSubjectById(int id) {
        for (Subject s : subjects) if (s.getSubjectId() == id) return s;
        return null;
    }

    public Teacher getTeacherById(int id) {
        for (Teacher t : teachers) if (t.getTeacherId() == id) return t;
        return null;
    }

    public Student getStudentById(int id) {
        for (Student s : students) if (s.getStudentId() == id) return s;
        return null;
    }

public void sortResultsById(int teacherId) {
    String query = "SELECT r.result_id, s.student_id, u.name AS student_name, q.title AS quiz_title, r.status " +
                   "FROM result r " +
                   "JOIN attempt a ON r.attempt_id = a.attempt_id " +
                   "JOIN student s ON a.student_id = s.student_id " +
                   "JOIN user u ON s.student_id = u.user_id " +
                   "JOIN quiz q ON a.quiz_id = q.quiz_id " +
                   "WHERE q.teacher_id=? " +
                   "ORDER BY s.student_id ASC";

    try (Connection con = DbConnection.getConnection();
         PreparedStatement pst = con.prepareStatement(query)) {

        pst.setInt(1, teacherId);
        ResultSet rs = pst.executeQuery();

        System.out.println("\n--- Results Sorted by Student ID ---");
        boolean found = false;
        while (rs.next()) {
            found = true;
            System.out.println("Result ID: " + rs.getInt("result_id") +
                               " | Student ID: " + rs.getInt("student_id") +
                               " | Name: " + rs.getString("student_name") +
                               " | Quiz: " + rs.getString("quiz_title") +
                               " | Status: " + rs.getString("status"));
        }
        if (!found) System.out.println("No results found.");
    } catch (SQLException e) {
        System.out.println("Error sorting results by ID: " + e.getMessage());
    }
}

public void sortResultsByName(int teacherId) {
    String query = "SELECT r.result_id, s.student_id, u.name AS student_name, q.title AS quiz_title, r.status " +
                   "FROM result r " +
                   "JOIN attempt a ON r.attempt_id = a.attempt_id " +
                   "JOIN student s ON a.student_id = s.student_id " +
                   "JOIN user u ON s.student_id = u.user_id " +
                   "JOIN quiz q ON a.quiz_id = q.quiz_id " +
                   "WHERE q.teacher_id=? " +
                   "ORDER BY u.name ASC";

    try (Connection con = DbConnection.getConnection();
         PreparedStatement pst = con.prepareStatement(query)) {

        pst.setInt(1, teacherId);
        ResultSet rs = pst.executeQuery();

        System.out.println("\n--- Results Sorted by Student Name ---");
        boolean found = false;
        while (rs.next()) {
            found = true;
            System.out.println("Result ID: " + rs.getInt("result_id") +
                               " | Student ID: " + rs.getInt("student_id") +
                               " | Name: " + rs.getString("student_name") +
                               " | Quiz: " + rs.getString("quiz_title") +
                               " | Status: " + rs.getString("status"));
        }
        if (!found) System.out.println("No results found.");
    } catch (SQLException e) {
        System.out.println("Error sorting results by Name: " + e.getMessage());
    }
}

public void searchResultsById(int teacherId, Scanner sc) {
    System.out.print("Enter Student ID to search: ");
    int stuId = Integer.parseInt(sc.nextLine().trim());

    String query = "SELECT r.result_id, s.student_id, u.name AS student_name, q.title AS quiz_title, r.status " +
                   "FROM result r " +
                   "JOIN attempt a ON r.attempt_id = a.attempt_id " +
                   "JOIN student s ON a.student_id = s.student_id " +
                   "JOIN user u ON s.student_id = u.user_id " +
                   "JOIN quiz q ON a.quiz_id = q.quiz_id " +
                   "WHERE s.student_id=? AND q.teacher_id=?";

    try (Connection con = DbConnection.getConnection();
         PreparedStatement pst = con.prepareStatement(query)) {

        pst.setInt(1, stuId);
        pst.setInt(2, teacherId);

        ResultSet rs = pst.executeQuery();

        System.out.println("\n--- Results for Student ID " + stuId + " ---");
        boolean found = false;
        while (rs.next()) {
            found = true;
            System.out.println("Result ID: " + rs.getInt("result_id") +
                               " | Name: " + rs.getString("student_name") +
                               " | Quiz: " + rs.getString("quiz_title") +
                               " | Status: " + rs.getString("status"));
        }
        if (!found) System.out.println("No results found for this student.");
    } catch (SQLException e) {
        System.out.println("Error searching results by student ID: " + e.getMessage());
    }
}



public void searchResultsByName(int teacherId, Scanner sc) {
    System.out.print("Enter student name to search: ");
    String name = sc.nextLine();

    String query = "SELECT r.result_id, s.student_id, u.name AS student_name, q.title AS quiz_title, r.status " +
                   "FROM result r " +
                   "JOIN attempt a ON r.attempt_id = a.attempt_id " +
                   "JOIN student s ON a.student_id = s.student_id " +
                   "JOIN user u ON s.student_id = u.user_id " +
                   "JOIN quiz q ON a.quiz_id = q.quiz_id " +
                   "WHERE u.name LIKE ? AND q.teacher_id=?";

    try (Connection con = DbConnection.getConnection();
         PreparedStatement pst = con.prepareStatement(query)) {

        pst.setString(1, "%" + name + "%");
        pst.setInt(2, teacherId);

        ResultSet rs = pst.executeQuery();

        System.out.println("\n--- Search Results ---");
        boolean found = false;
        while (rs.next()) {
            found = true;
            System.out.println("Result ID: " + rs.getInt("result_id") +
                               " | Student ID: " + rs.getInt("student_id") +
                               " | Name: " + rs.getString("student_name") +
                               " | Quiz: " + rs.getString("quiz_title") +
                               " | Status: " + rs.getString("status"));
        }
        if (!found) System.out.println("No results found.");
    } catch (SQLException e) {
        System.out.println("Error searching results by student name: " + e.getMessage());
    }
}




    public Quiz[] getQuizzes() {
       
        throw new UnsupportedOperationException("Unimplemented method 'getQuizzes'");
    }

   
}
