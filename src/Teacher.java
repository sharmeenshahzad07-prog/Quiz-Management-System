import java.sql.*;

import java.util.Scanner;

public class Teacher extends User {
    private int teacherId;
    private LinkedList<Quiz> createdQuizzes = new LinkedList<>();
    private LinkedList<Section> sections = new LinkedList<>();  
    private LinkedList<Subject> subjects = new LinkedList<>();  

   
    public Teacher(int teacherId, String name, String email, String password) {
        super(teacherId, name, email, password);
        this.teacherId = teacherId;
    }

 
    public int getTeacherId() { return teacherId; }
    public LinkedList<Quiz> getCreatedQuizzes() { return createdQuizzes; }
    public LinkedList<Section> getSections() { return sections; }
    public LinkedList<Subject> getSubjects() { return subjects; }


    public void addQuiz(Quiz q) { createdQuizzes.add(q); }

    public void addSection(Section s) {
        if (!sections.contains(s)) sections.add(s);
    }

    public void addSubject(Subject s) {
        if (!subjects.contains(s)) subjects.add(s);
    }

    public void removeSubject(Subject sub) { subjects.remove(sub); }
    public void removeSection(Section sec) { sections.remove(sec); }


    public LinkedList<String> getCourses() {
        LinkedList<String> names = new LinkedList<>();
        for (Subject s : subjects) names.add(s.getSubjectName());
        return names;
    }

    public void viewProfile() {
        System.out.println("Teacher ID: " + teacherId + ", Name: " + getName());

        System.out.print("Sections: ");
        if (sections.isEmpty()) System.out.println("None");
        else {
            for (int i = 0; i < sections.size(); i++) {
                System.out.print(sections.get(i).getSectionName());
                if (i < sections.size() - 1) System.out.print(", ");
            }
            System.out.println();
        }

        System.out.print("Subjects: ");
        if (subjects.isEmpty()) System.out.println("None");
        else {
            for (int i = 0; i < subjects.size(); i++) {
                System.out.print(subjects.get(i).getSubjectName());
                if (i < subjects.size() - 1) System.out.print(", ");
            }
            System.out.println();
        }

        System.out.println("Quizzes created: " + createdQuizzes.size());
    }

  
    public static Teacher loadTeacherFromDB(int teacherId) {
        Teacher teacher = null;
        Connection con = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
      
            con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/examination_system", "root", "");

          
            pst = con.prepareStatement("SELECT * FROM teacher WHERE teacherId = ?");
            pst.setInt(1, teacherId);
            rs = pst.executeQuery();

            if (rs.next()) {
                teacher = new Teacher(
                    rs.getInt("teacherId"),
                    rs.getString("name"),
                    rs.getString("email"),
                    rs.getString("password")
                );
            } else {
                System.out.println(" Teacher not found!");
                return null;
            }

            rs.close();
            pst.close();

         
                    pst = con.prepareStatement(
            "SELECT s.section_id, s.section_name, s.strength " +
            "FROM section s " +
            "JOIN teachersection ts ON s.section_id = ts.section_id " +
            "WHERE ts.teacher_id = ?"
        );
        pst.setInt(1, teacherId);
        rs = pst.executeQuery();

        while (rs.next()) {
            Section sec = new Section();
            sec.setSectionId(rs.getInt("section_id"));
            sec.setSectionName(rs.getString("section_name"));
            sec.setStrength(rs.getInt("strength"));
            teacher.addSection(sec);
        }

            rs.close();
            pst.close();

     
            pst = con.prepareStatement(
                "SELECT s.* FROM subject s " +
                "JOIN teacher_subject ts ON s.subject_id = ts.subject_id " +
                "WHERE ts.teacher_id = ?");
            pst.setInt(1, teacherId);
            rs = pst.executeQuery();

            while (rs.next()) {
                Subject sub = new Subject();
                sub.setSubjectId(rs.getInt("subjectId"));
                sub.setSubjectName(rs.getString("subjectName"));
                teacher.addSubject(sub);
            }
            rs.close();
            pst.close();

            pst = con.prepareStatement(
                "SELECT * FROM quiz WHERE teacherId = ?");
            pst.setInt(1, teacherId);
            rs = pst.executeQuery();

            while (rs.next()) {
                Quiz q = new Quiz();
                q.setQuizId(rs.getInt("quiz_id"));
                q.setQuizName(rs.getString("title"));
                q.setSubjectId(rs.getInt("subject_id"));
                q.setSection(rs.getString("section_id"));
                q.setTeacherId(teacherId);
                teacher.addQuiz(q);
            }

        } catch (SQLException e) {
            System.out.println("Error while fetching");
        } 

        return teacher;
    }

            public void editTeacherProfile(Scanner sc){

            System.out.println("\n--- Edit Profile ---");
            System.out.println("1. Edit Name");
            System.out.println("2. Edit Email");
            System.out.println("3. Edit Password");
            System.out.println("4. Back");
            System.out.print("Enter choice: ");

            int choice = sc.nextInt();
            sc.nextLine();

            try (Connection con = DbConnection.getConnection()) {

                PreparedStatement pst = null;

                if (choice == 1) {
                    System.out.print("Enter new name: ");
            String newName = sc.nextLine();

            if (newName.isEmpty()) {
                System.out.println(" Name cannot be empty");
                return;
            }

            if (newName.matches(".*\\d.*")) {
                System.out.println(" Name cannot contain numbers");
                return;
            }

            pst = con.prepareStatement(
                "UPDATE user SET name=? WHERE user_id=? AND role='TEACHER'");
            pst.setString(1, newName);
            pst.setInt(2, getUserId());
            pst.executeUpdate();
            setName(newName);

            System.out.println(" Name updated successfully");

                } else if (choice == 2) {
                    System.out.print("Enter new email: ");
            String newEmail = sc.nextLine().trim();

         
            if (newEmail.isEmpty()) {
                System.out.println(" Email cannot be empty");
                return;
            }

            if (!newEmail.matches("^[\\w.-]+@[\\w.-]+\\.\\w+$")) {
                System.out.println("Invalid email format");
                return;
            }

            pst = con.prepareStatement(
                "UPDATE user SET email=? WHERE user_id=? AND role='TEACHER'");
            pst.setString(1, newEmail);
            pst.setInt(2, getUserId());
            pst.executeUpdate();
            setEmail(newEmail);

            System.out.println(" Email updated successfully");
                }else if (choice == 3) {

            System.out.print("Enter new password: ");
            String newPass = sc.nextLine();

            if (newPass.isEmpty()) {
                System.out.println(" Password cannot be empty");
                return;
            }

            if (newPass.length() < 2) {
                System.out.println(" Password must be at least 5 characters");
                return;
            }

            if (newPass.matches("\\d+")) {
                System.out.println("Password cannot be only numbers");
                return;
            }

            pst = con.prepareStatement(
                "UPDATE user SET password=? WHERE user_id=? AND role='TEACHER'");
            pst.setString(1, newPass);
            pst.setInt(2, getUserId());
            pst.executeUpdate();
            setPassword(newPass); 

            System.out.println(" Password updated successfully");
        }
        else {
                    System.out.println(" Back");
                }

            } catch (Exception e) {
                e.printStackTrace();
            }
        }

    public void createQuizFromBank(Scanner sc) {
    Connection con = null;
    PreparedStatement pst = null;
    ResultSet rs = null;

    try {
        con = DbConnection.getConnection();

        if (sections.isEmpty()) {
            System.out.println(" You have no assigned sections. Contact admin.");
            return;
        }

        System.out.println("\n--- Your Sections ---");
        for (Section s : sections) {
            System.out.println(s.getSectionId() + ". " + s.getSectionName());
        }

        System.out.print("Enter section ID for this quiz: ");
        int sectionId = sc.nextInt();
        sc.nextLine();

        Section selectedSection = null;
        for (Section s : sections) {
            if (s.getSectionId() == sectionId) {
                selectedSection = s;
                break;
            }
        }
        if (selectedSection == null) {
            System.out.println(" You are not assigned this section!");
            return;
        }

        if (subjects.isEmpty()) {
            System.out.println(" You have no assigned subjects. Contact admin.");
            return;
        }

        System.out.println("\n--- Your Subjects ---");
        for (Subject s : subjects) {
            System.out.println(s.getSubjectId() + ". " + s.getSubjectName());
        }

        System.out.print("Enter subject ID for this quiz: ");
        int subjectId = sc.nextInt();
        sc.nextLine();

        Subject selectedSubject = null;
        for (Subject s : subjects) {
            if (s.getSubjectId() == subjectId) {
                selectedSubject = s;
                break;
            }
        }
        if (selectedSubject == null) {
            System.out.println(" You are not assigned this subject!");
            return;
        }

   
        System.out.print("Enter number of questions for this quiz (1-99): ");
        int numQuestions = sc.nextInt();
        sc.nextLine();
        if (numQuestions < 1 || numQuestions > 99) {
            System.out.println(" Invalid number of questions. Must be 1-99.");
            return;
        }

       
        pst = con.prepareStatement(
            "SELECT * FROM questionbank WHERE subject_id=? ORDER BY RAND() LIMIT ?"
        );
        pst.setInt(1, subjectId);
        pst.setInt(2, numQuestions);
        rs = pst.executeQuery();

        LinkedList<Integer> selectedQuestionIds = new LinkedList<>();
        System.out.println("\n--- Questions Selected for Quiz ---");
        while (rs.next()) {
            int qId = rs.getInt("question_id");
            selectedQuestionIds.add(qId);
            System.out.println(qId + ": " + rs.getString("question_text")); 
        }
        if (selectedQuestionIds.isEmpty()) {
            System.out.println(" No questions available for this subject.");
            return;
        }


        System.out.print("Enter quiz title: ");
        String quizTitle = sc.nextLine();
        if (quizTitle.isEmpty()) {
            System.out.println(" Quiz title cannot be empty.");
            return;
        }

  
        pst = con.prepareStatement(
            "INSERT INTO quiz (title, subject_id, section_id, teacher_id) VALUES (?, ?, ?, ?)",
            Statement.RETURN_GENERATED_KEYS
        );
        pst.setString(1, quizTitle);
        pst.setInt(2, subjectId);
        pst.setInt(3, sectionId);
        pst.setInt(4, teacherId);
        pst.executeUpdate();

        rs = pst.getGeneratedKeys();
        int quizId = rs.next() ? rs.getInt(1) : -1;
        if (quizId == -1) {
            System.out.println(" Error creating quiz.");
            return;
        }

        pst = con.prepareStatement(
            "INSERT INTO quizquestion (quiz_id, question_id) VALUES (?, ?)"
        );
        for (int qId : selectedQuestionIds) {
            pst.setInt(1, quizId);
            pst.setInt(2, qId);
            pst.executeUpdate();
        }

        System.out.println(" Quiz '" + quizTitle + "' created successfully with " 
                            + selectedQuestionIds.size() + " questions.");

    } catch (SQLException e) {
        System.out.println(" Error while creating quiz.");
        
    } 
}

    public void viewQuizzes(Manager manager) {
    try (Connection con = DbConnection.getConnection();
         PreparedStatement pst = con.prepareStatement(
             "SELECT q.quiz_id, q.title, s.section_name, sub.subject_name " + "FROM quiz q " + "JOIN section s ON q.section_id = s.section_id " +
             "JOIN subject sub ON q.subject_id = sub.subject_id " + "WHERE q.teacher_id=?")) {

                pst.setInt(1, teacherId);
                ResultSet rs = pst.executeQuery();

                System.out.println("\n--- My Quizzes ---");
                boolean hasQuiz = false;
                while (rs.next()) {
                    hasQuiz = true;
                    System.out.println(
                        "ID: " + rs.getInt("quiz_id") + " | Title: " + rs.getString("title") + " | Section: " + rs.getString("section_name") +
                        " | Subject: " + rs.getString("subject_name")  );
        }
        if (!hasQuiz) System.out.println(" No quizzes created yet.");

    } catch (SQLException e) {
        System.out.println(" Error while fetching quizzes.");
        
    }
}


   public void deleteQuiz(Scanner sc, Manager manager) {
    viewQuizzes(manager);

    System.out.print("\nEnter Quiz ID to delete: ");
    int quizId = sc.nextInt();
    sc.nextLine();

    try (Connection con = DbConnection.getConnection()) {

        PreparedStatement pst = con.prepareStatement(
            "SELECT * FROM quiz WHERE quiz_id=? AND teacher_id=?" );
        pst.setInt(1, quizId);
        pst.setInt(2, teacherId);
        ResultSet rs = pst.executeQuery();

        if (!rs.next()) {
            System.out.println(" Quiz not found or not yours.");
            return;
        }

     
        pst = con.prepareStatement("DELETE FROM quizquestion WHERE quiz_id=?");
        pst.setInt(1, quizId);
        pst.executeUpdate();

 
        pst = con.prepareStatement("DELETE FROM quiz WHERE quiz_id=?");
        pst.setInt(1, quizId);
        pst.executeUpdate();

        System.out.println("Quiz deleted successfully.");

    } catch (SQLException e) {
        System.out.println(" Error while deleting quiz.");
        
    }
}


    public void updateQuiz(Scanner sc, Manager manager) {
    viewQuizzes(manager); 

    System.out.print("\nEnter Quiz ID to update: ");
    int quizId = sc.nextInt();
    sc.nextLine(); 

    try (Connection con = DbConnection.getConnection()) {
    
        PreparedStatement pst = con.prepareStatement(
            "SELECT * FROM quiz WHERE quiz_id=? AND teacher_id=?"
        );
        pst.setInt(1, quizId);
        pst.setInt(2, teacherId);
        ResultSet rs = pst.executeQuery();

        if (!rs.next()) {
            System.out.println(" Quiz not found or not yours.");
            return;
        }

    
        System.out.print("Enter new quiz title: ");
        String newTitle = sc.nextLine();

        if (newTitle.isEmpty()) {
            System.out.println(" Title cannot be empty.");
            return;
        }

        pst = con.prepareStatement("UPDATE quiz SET title=? WHERE quiz_id=?");
        pst.setString(1, newTitle);
        pst.setInt(2, quizId);
        pst.executeUpdate();

        System.out.println(" Quiz title updated successfully.");

    } catch (SQLException e) {
        System.out.println(" Error while updating quiz.");
        
    }
}

    

   
}
