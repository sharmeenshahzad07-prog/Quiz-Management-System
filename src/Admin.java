

import java.sql.*;
import java.util.List;
import java.util.Scanner;

public class Admin extends User {

    public Admin(int userId, String name, String email, String password) {
        super(userId, name, email, password);
    }

    public void displayAdminMenu() {
        System.out.println("\n--- Admin Dashboard ---");
        System.out.println("1. View / Edit Admin Profile");
        System.out.println("2. Teacher Management");
        System.out.println("3. Student Management");
        System.out.println("4. Logout");
        System.out.print("Choice: ");
    }

    
    public void viewAdminDetails(Scanner sc) {
        while (true) {
            System.out.println("\n--- Admin Profile ---");
            System.out.println("1. View Profile");
            System.out.println("2. Edit Name");
            System.out.println("3. Edit Email");
            System.out.println("4. Edit Password");
            System.out.println("5. Back");
            System.out.print("Choice: ");

            int choice = Integer.parseInt(sc.nextLine());

            if (choice == 5) break;

            try (Connection con = DbConnection.getConnection()) {
                if (choice == 1) {
                    System.out.println(this);
                } else if (choice == 2) {
                    System.out.print("New Name: ");
                    String name = sc.nextLine();
                    PreparedStatement ps = con.prepareStatement("UPDATE user SET name=? WHERE user_id=?");
                    ps.setString(1, name);
                    ps.setInt(2, getUserId());
                    ps.executeUpdate();
                    setName(name);
                    System.out.println("Name updated!");
                } else if (choice == 3) {
                    System.out.print("New Email: ");
                    String email = sc.nextLine();
                    PreparedStatement ps = con.prepareStatement("UPDATE user SET email=? WHERE user_id=?");
                    ps.setString(1, email);
                    ps.setInt(2, getUserId());
                    ps.executeUpdate();
                    setEmail(email);
                    System.out.println("Email updated!");
                } else if (choice == 4) {
                    System.out.print("New Password: ");
                    String pass = sc.nextLine();
                    PreparedStatement ps = con.prepareStatement("UPDATE user SET password=? WHERE user_id=?");
                    ps.setString(1, pass);
                    ps.setInt(2, getUserId());
                    ps.executeUpdate();
                    setPassword(pass);
                    System.out.println("Password updated!");
                } else {
                    System.out.println("Invalid choice!");
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public void manageTeachers(Manager manager, Scanner sc) {

        while (true) {
            System.out.println("\n--- Teacher Management ---");
            System.out.println("1. Add Teacher");
            System.out.println("2. Remove Teacher");
            System.out.println("3. View All Teachers");
            System.out.println("4. Assign / Add Courses");
            System.out.println("5. Assign / Add Sections");
            System.out.println("6. Remove Courses");
            System.out.println("7. Remove Sections");
            System.out.println("8. View Individual Teacher Details");
            System.out.println("9. Back to Admin Menu");
            System.out.print("Choice: ");
            int choice = Integer.parseInt(sc.nextLine());

            Teacher t = null;
            if (choice >= 4 && choice <= 8) {
                System.out.print("Enter Teacher ID: ");
                int id = Integer.parseInt(sc.nextLine());
                for (Teacher tea : manager.getTeachers()) {
                    if (tea.getTeacherId() == id) {
                        t = tea;
                        break;
                    }
                }
                if (t == null) {
                    System.out.println(" Teacher not found!");
                    return;
                }

                TeachermanageDb.loadSectionsFromDB(t, manager.getSections());
                TeachermanageDb.loadSubjectsFromDB(t, manager.getSubjects());
                
            }

            try (Connection con = DbConnection.getConnection()) {

                
                if (choice == 1) {
                    System.out.print("Enter Teacher ID: ");
                    int id = Integer.parseInt(sc.nextLine());
                    if (manager.getTeachers().stream().anyMatch(te -> te.getTeacherId() == id)) {
                        System.out.println(" Teacher ID already exists!");
                        continue;
                    }
                    System.out.print("Enter Name: ");
                    String name = sc.nextLine();
                    System.out.print("Enter Email: ");
                    String email = sc.nextLine();
                    System.out.print("Enter Password: ");
                    String pass = sc.nextLine();

                    
                    PreparedStatement ps1 = con.prepareStatement(
                            "INSERT INTO user(user_id, name, email, password, role) VALUES (?, ?, ?, ?, 'TEACHER')");
                    ps1.setInt(1, id);
                    ps1.setString(2, name);
                    ps1.setString(3, email);
                    ps1.setString(4, pass);
                    ps1.executeUpdate();

                    PreparedStatement ps2 = con.prepareStatement("INSERT INTO teacher(teacher_id) VALUES (?)");
                    ps2.setInt(1, id);
                    ps2.executeUpdate();

                    Teacher teacher = new Teacher(id, name, email, pass);
                    manager.getTeachers().add(teacher);
                    System.out.println("Teacher added successfully in DB and Manager!");

                } else if (choice == 2) {
                    System.out.print("Enter Teacher ID to remove: ");
                    int id = Integer.parseInt(sc.nextLine());
                    PreparedStatement ps1 = con.prepareStatement("DELETE FROM teacher WHERE teacher_id=?");
                    ps1.setInt(1, id);
                    ps1.executeUpdate();

                    PreparedStatement ps2 = con.prepareStatement("DELETE FROM user WHERE user_id=? AND role='TEACHER'");
                    ps2.setInt(1, id);
                    int rows = ps2.executeUpdate();

                    boolean removed = manager.getTeachers().removeIf(tch -> tch.getTeacherId() == id);
                    System.out.println(rows > 0 ? "Teacher removed from DB and Manager." : "Teacher not found!");

                } else if (choice == 3) {
                    Statement st = con.createStatement();
                    ResultSet rs = st.executeQuery(
                            "SELECT u.user_id, u.name, u.email FROM user u WHERE u.role='TEACHER'");
                    System.out.println("\n--- Teachers ---");

                    while (rs.next()) {
                        int tid = rs.getInt("user_id");
                        String name = rs.getString("name");
                        String email = rs.getString("email");

                        Teacher tMem = manager.getTeachers().stream()
                                .filter(te -> te.getTeacherId() == tid)
                                .findFirst().orElse(null);

                       if (tMem != null) {
                        TeachermanageDb.loadSubjectsFromDB(tMem, manager.getSubjects());
                        TeachermanageDb.loadSectionsFromDB(tMem, manager.getSections()); 
                    }


                        String sections = tMem != null && !tMem.getSections().isEmpty() ?
                                getSectionNames(tMem.getSections()) : "None";
                        String subjects = tMem != null && !tMem.getSubjects().isEmpty() ?
                                getNames(tMem.getSubjects()) : "None";

                        System.out.println("ID: " + tid + " | Name: " + name + " | Email: " + email +
                                " | Sections: " + sections + " | Subjects: " + subjects);
                    }

                } else if (choice == 4) {
                    System.out.println("\nAvailable Subjects:");
                    for (Subject sub : manager.getSubjects())
                        System.out.println(sub.getSubjectId() + ". " + sub.getSubjectName());

                    System.out.println("\nCurrent subjects: " + (t.getSubjects().isEmpty() ? "None" : getNames(t.getSubjects())));
                    System.out.print("Enter Subject IDs to assign (comma-separated): ");
                    String[] ids = sc.nextLine().split(",");
                    for (String sIdStr : ids) {
                        int sId = Integer.parseInt(sIdStr.trim());
                        Subject sub = manager.getSubjectById(sId);
                        if (sub != null)
                            TeachermanageDb.assignSubjectToTeacherDB(t, sub);
                    }

                } else if (choice == 5) {
                    System.out.println("Current sections: " + (t.getSections().isEmpty() ? "None" : getSectionNames(t.getSections())));
                    System.out.println("\nAvailable Sections:");
                    for (Section sec : manager.getSections())
                        System.out.println(sec.getSectionId() + ". " + sec.getSectionName());

                    System.out.print("Enter Section IDs to assign (comma-separated): ");
                    String[] ids = sc.nextLine().split(",");
                    for (String sIdStr : ids) {
                    int secId = Integer.parseInt(sIdStr.trim());
                    Section sec = manager.getSectionById(secId);
                    if (sec != null) {
                        
                        TeachermanageDb.assignSectionToTeacherDB(t, sec);
                    }
                }

                    System.out.println("Section(s) assigned successfully!");

                } else if (choice == 6) {
                    if (t.getSubjects().isEmpty()) {
                        System.out.println("No subjects assigned to this teacher.");
                        continue;
                    }

                    System.out.println("\nAssigned Subjects:");
                    for (Subject s : t.getSubjects())
                        System.out.println("ID: " + s.getSubjectId() + " | " + s.getSubjectName());

                    System.out.print("Enter Subject IDs to remove (comma-separated): ");
                    String[] ids = sc.nextLine().split(",");
                    for (String sIdStr : ids) {
                        try {
                            int subId = Integer.parseInt(sIdStr.trim());
                            Subject subToRemove = t.getSubjects().stream()
                                    .filter(sub -> sub.getSubjectId() == subId)
                                    .findFirst().orElse(null);
                            if (subToRemove != null)
                                TeachermanageDb.removeSubjectFromTeacherDB(t, subToRemove);
                            else System.out.println("Subject ID " + subId + " not assigned.");
                        } catch (NumberFormatException e) {
                            System.out.println("Invalid Subject ID: " + sIdStr.trim());
                        }
                    }

                } else if (choice == 7) {
               
                if (t.getSections().isEmpty()) {
                    System.out.println("No sections assigned to this teacher.");
                    continue;
                }

                System.out.println("\nAssigned Sections:");
                for (Section sec : t.getSections()) {
                    System.out.println("ID: " + sec.getSectionId() + " | " + sec.getSectionName());
                }

                System.out.print("Enter Section IDs to remove (comma-separated): ");
                String input = sc.nextLine();
                String[] idStrings = input.split(",");

                for (String idStr : idStrings) {
                    int secId;
                    try {
                        secId = Integer.parseInt(idStr.trim());
                    } catch (NumberFormatException e) {
                        System.out.println("Invalid Section ID: " + idStr.trim());
                        continue;
                    }

                    Section secToRemove = null;
                    for (Section sec : t.getSections()) {
                        if (sec.getSectionId() == secId) {
                            secToRemove = sec;
                            break;
                        }
                    }

                    if (secToRemove != null) {
                        TeachermanageDb.removeSectionFromTeacherDB(t, secToRemove);
                    } else {
                        System.out.println("Section ID " + secId + " not assigned to this teacher.");
                    }
                }


                } else if (choice == 8) {
                    System.out.println("\n--- Teacher Details ---");
                    System.out.println("ID: " + t.getTeacherId());
                    System.out.println("Name: " + t.getName());
                    System.out.println("Email: " + t.getEmail());
                    System.out.println("Sections: " + (t.getSections().isEmpty() ? "None" : getSectionNames(t.getSections())));
                    System.out.println("Subjects: " + (t.getSubjects().isEmpty() ? "None" : getNames(t.getSubjects())));
                    

                } else if (choice == 9) {
                    break;

                } else {
                    System.out.println(" Invalid choice! Try again.");
                }

            } catch (SQLException e) {
                e.printStackTrace();
                System.out.println("Database operation failed!");
            }
        }
    }

    private String getNames(List<Subject> subjects) {
        return subjects.isEmpty() ? "None" : String.join(", ", subjects.stream().map(Subject::getSubjectName).toList());
    }

    private String getSectionNames(List<Section> sections) {
        return sections.isEmpty() ? "None" : String.join(", ", sections.stream().map(Section::getSectionName).toList());
    }

    public void manageStudents(Scanner sc, Manager manager) {
        while (true) {
            System.out.println("\n--- Student Management ---");
            System.out.println("1. Add Student");
            System.out.println("2. Edit Student");
            System.out.println("3. Remove Student");
            System.out.println("4. View All Students");
            System.out.println("5. Register Student into Section");
            System.out.println("6. Remove Student from Section");
            System.out.println("7. View All Students by Section");
            System.out.println("8. View Individual Student Details");
            System.out.println("9. Back");
            System.out.print("Choice: ");

            int choice;
            try {
                choice = Integer.parseInt(sc.nextLine());
            } catch (NumberFormatException e) {
                System.out.println("Invalid choice! Enter a number.");
                continue;
            }

            try (Connection con = DbConnection.getConnection()) {
                if (choice == 1) addStudentDB(sc, con);
                else if (choice == 2) editStudentDB(sc, con);
                else if (choice == 3) removeStudentManager(sc, manager, con);
                else if (choice == 4) viewAllStudentsDB(con, manager);
                else if (choice == 5) registerStudentDB(sc, con);
                else if (choice == 6) removeStudentFromSectionDB(sc, con);
                else if (choice == 7) viewAllStudentsBySectionDB(sc, con, manager);
                else if (choice == 8) viewIndividualStudentDB(sc, con, manager);
                else if (choice == 9) break;
                else System.out.println("Invalid choice!");
            } catch (SQLException e) {
                System.out.println("Database error: " + e.getMessage());
            }
        }
    }

    @Override
    public String toString() {
        return "Admin ID: " + getUserId() +
               "\nName   : " + getName() +
               "\nEmail  : " + getEmail();
    }

    private void viewAllStudentsDB(Connection con, Manager manager) throws SQLException {
        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery("SELECT u.user_id, u.name, u.email, s.section_id FROM user u JOIN student s ON u.user_id = s.student_id WHERE role='STUDENT'");
        System.out.println("\n--- All Students ---");
        while (rs.next()) {
            int secId = rs.getInt("section_id");
            Section sec = manager.getSectionById(secId);

            String sectionName;
            if (sec != null) sectionName = sec.getSectionName();
            else sectionName = "Not Assigned";

            System.out.println(rs.getInt("user_id") + " | " + rs.getString("name") + " | " + rs.getString("email") +
                               " | Section: " + sectionName);
        }
    }

private void addStudentDB(Scanner sc, Connection con) throws SQLException {
    String name;
    while (true) {
        System.out.print("Enter Name: ");
        name = sc.nextLine().trim();
        if (name.matches("[a-zA-Z ]+")) break;
        System.out.println("Invalid name! Only letters allowed.");
    }

    String email;
    while (true) {
        System.out.print("Enter Email: ");
        email = sc.nextLine().trim();
        if (email.contains("@") && email.contains(".")) break;
        System.out.println("Invalid email! Must contain '@' and '.'");
    }

    String pass;
    while (true) {
        System.out.print("Enter Password: ");
        pass = sc.nextLine().trim();
        if (!pass.isEmpty()) break;
        System.out.println("Password cannot be empty!");
    }

    String roll;
    while (true) {
        System.out.print("Enter Roll No: ");
        roll = sc.nextLine().trim();
        if (!roll.isEmpty()) break;
        System.out.println("Roll No cannot be empty!");
    }

    PreparedStatement ps1 = con.prepareStatement(
        "INSERT INTO user(name,email,password,role) VALUES (?,?,?,'STUDENT')",
        Statement.RETURN_GENERATED_KEYS
    );
    ps1.setString(1, name);
    ps1.setString(2, email);
    ps1.setString(3, pass);
    ps1.executeUpdate();

    ResultSet rs = ps1.getGeneratedKeys();
    rs.next();
    int studentId = rs.getInt(1);

    PreparedStatement ps2 = con.prepareStatement(
        "INSERT INTO student(student_id, roll_no, section_id) VALUES (?,?,1)"
    );
    ps2.setInt(1, studentId);
    ps2.setString(2, roll);
    ps2.executeUpdate();

    System.out.println("Student added successfully!");
}

private void editStudentDB(Scanner sc, Connection con) throws SQLException {
    System.out.print("Enter Student ID to edit: ");
    int id = Integer.parseInt(sc.nextLine());

    String name;
    while (true) {
        System.out.print("New Name: ");
        name = sc.nextLine().trim();
        if (name.matches("[a-zA-Z ]+")) break;
        System.out.println("Invalid name! Only letters allowed.");
    }

    String email;
    while (true) {
        System.out.print("New Email: ");
        email = sc.nextLine().trim();
        if (email.contains("@") && email.contains(".")) break;
        System.out.println("Invalid email! Must contain '@' and '.'");
    }

    String pass;
    while (true) {
        System.out.print("New Password: ");
        pass = sc.nextLine().trim();
        if (!pass.isEmpty()) break;
        System.out.println("Password cannot be empty!");
    }

    PreparedStatement ps = con.prepareStatement(
        "UPDATE user SET name=?, email=?, password=? WHERE user_id=? AND role='STUDENT'"
    );
    ps.setString(1, name);
    ps.setString(2, email);
    ps.setString(3, pass);
    ps.setInt(4, id);

    int rows = ps.executeUpdate();
    if (rows > 0) {
        System.out.println("Student updated successfully!");
    } else {
        System.out.println("Student not found!");
    }
}

private void registerStudentDB(Scanner sc, Connection con) throws SQLException {
    System.out.print("Enter Roll No of Student: ");
    String roll = sc.nextLine().trim();

    System.out.print("Enter Section ID to assign: ");
    int secId;
    try {
        secId = Integer.parseInt(sc.nextLine());
    } catch (NumberFormatException e) {
        System.out.println("Invalid Section ID! Must be a number.");
        return;
    }

    PreparedStatement ps = con.prepareStatement(
        "UPDATE student SET section_id=? WHERE roll_no=?"
    );
    ps.setInt(1, secId);
    ps.setString(2, roll);

    int rows = ps.executeUpdate();
    if (rows > 0) {
        System.out.println("Student registered into section!");
    } else {
        System.out.println("Student not found!");
    }
}

private void removeStudentFromSectionDB(Scanner sc, Connection con) throws SQLException {
    System.out.print("Enter Roll No: ");
    String roll = sc.nextLine().trim();

    PreparedStatement ps = con.prepareStatement(
        "UPDATE student SET section_id=NULL WHERE roll_no=?"
    );
    ps.setString(1, roll);

    int rows = ps.executeUpdate();
    if (rows > 0) {
        System.out.println("Student removed from section successfully!");
    } else {
        System.out.println("Student not found!");
    }
}

private void viewAllStudentsBySectionDB(Scanner sc, Connection con, Manager manager) throws SQLException {
    System.out.print("Enter Section ID: ");
    int secId;
    try {
        secId = Integer.parseInt(sc.nextLine());
    } catch (NumberFormatException e) {
        System.out.println("Invalid Section ID!");
        return;
    }

    PreparedStatement ps = con.prepareStatement(
        "SELECT u.name, u.email, s.roll_no FROM student s JOIN user u ON s.student_id = u.user_id WHERE s.section_id=?"
    );
    ps.setInt(1, secId);
    ResultSet rs = ps.executeQuery();

    System.out.println("\n--- Students in Section ---");
    boolean found = false;
    while (rs.next()) {
        found = true;
        System.out.println(
            "Roll No: " + rs.getString("roll_no") +
            " | Name: " + rs.getString("name") +
            " | Email: " + rs.getString("email")
        );
    }
    if (!found) {
        System.out.println("No students in this section.");
    }
}

private void viewIndividualStudentDB(Scanner sc, Connection con, Manager manager) throws SQLException {
    System.out.print("Enter Roll No of Student: ");
    String roll = sc.nextLine().trim();

    PreparedStatement ps = con.prepareStatement(
        "SELECT u.name, u.email, s.roll_no, s.section_id FROM student s JOIN user u ON s.student_id = u.user_id WHERE s.roll_no=?"
    );
    ps.setString(1, roll);
    ResultSet rs = ps.executeQuery();

    if (rs.next()) {
        String name = rs.getString("name");
        String email = rs.getString("email");
        String rollNo = rs.getString("roll_no");
        int secId = rs.getInt("section_id");
        Section sec = manager.getSectionById(secId);

        String sectionName = "Not Assigned";
        if (sec != null) sectionName = sec.getSectionName();

        System.out.println("\n--- Student Details ---");
        System.out.println("Name: " + name);
        System.out.println("Email: " + email);
        System.out.println("Roll No: " + rollNo);
        System.out.println("Section: " + sectionName);
    } else {
        System.out.println("Student not found!");
    }
}

private void removeStudentManager(Scanner sc, Manager manager, Connection con) throws SQLException {
    System.out.print("Enter Student Roll No to remove: ");
    String roll = sc.nextLine().trim();

    PreparedStatement ps1 = con.prepareStatement("DELETE FROM student WHERE roll_no=?");
    ps1.setString(1, roll);
    int rows1 = ps1.executeUpdate();

    PreparedStatement ps2 = con.prepareStatement(
        "DELETE FROM user WHERE user_id=(SELECT student_id FROM student WHERE roll_no=?) AND role='STUDENT'"
    );
    ps2.setString(1, roll);
    int rows2 = ps2.executeUpdate();

    if (rows1 > 0 || rows2 > 0) {
        System.out.println("Student removed successfully!");
    } else {
        System.out.println("Student not found!");
    }

   
}




}
