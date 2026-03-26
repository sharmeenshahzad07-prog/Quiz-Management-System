
import java.sql.*;
import java.util.Scanner;

public class Student extends User {
    private String rollNumber;
    private Section assignedSection;
    private LinkedList<String> courses = new LinkedList<>();

    public Student() {}

    public Student(int userId, String name, String email, String password, String rollNumber, Section section) {
        super(userId, name, email, password);
        this.rollNumber = rollNumber;
        this.assignedSection = section;
    }

    public int getStudentId() { return getUserId(); }
    public String getRollNumber() { return rollNumber; }
    public void setRollNumber(String rollNumber) { this.rollNumber = rollNumber; }
    public Section getAssignedSection() { return assignedSection; }
    public void setAssignedSection(Section section) { this.assignedSection = section; }

    public void addCourse(String course) { courses.add(course); }
    public LinkedList<String> getCourses() { return courses; }

 
    public static Student loadById(int studentId) {
        Student s = null;
        try (Connection con = DbConnection.getConnection()) {
            String sql = "SELECT s.student_id, s.roll_no, s.section_id, u.name, u.email, u.password, sec.section_name " +
                         "FROM student s " +
                         "JOIN user u ON s.student_id = u.user_id " +
                         "LEFT JOIN section sec ON s.section_id = sec.section_id " +
                         "WHERE s.student_id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Section sec = null;
                int secId = rs.getInt("section_id");
                String secName = rs.getString("section_name");
                if (secId > 0) sec = new Section(secId, secName);

                s = new Student(
                    rs.getInt("student_id"),
                    rs.getString("name"),
                    rs.getString("email"),
                    rs.getString("password"),
                    rs.getString("roll_no"),
                    sec
                );
            }
        } catch (SQLException e) {
            System.out.println("Error loading student: " + e.getMessage());
        }
        return s;
    }

    public LinkedList<Quiz> getAvailableQuizzes() {
        LinkedList<Quiz> quizzes = new LinkedList<>();
        if (assignedSection == null) return quizzes;

        try (Connection con = DbConnection.getConnection()) {
            String sql = "SELECT * FROM quiz WHERE section_id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, assignedSection.getSectionId());
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Quiz q = new Quiz(rs.getInt("quiz_id")); 
                quizzes.add(q);
            }
        } catch (SQLException e) {
            System.out.println("Error loading quizzes: " + e.getMessage());
        }

        return quizzes;
    }

    public void attemptQuiz(Scanner sc) {
        if (assignedSection == null) {
            System.out.println("You are not assigned to any section!");
            return;
        }

        LinkedList<Quiz> quizzes = getAvailableQuizzes();
        if (quizzes.isEmpty()) {
            System.out.println("No quizzes available for your section!");
            return;
        }

        System.out.println("\nAvailable Quizzes:");
        for (int i = 0; i < quizzes.size(); i++) {
            Quiz q = quizzes.get(i);
            System.out.println(q.getQuizId() + ". " + q.getQuizName());
        }

        System.out.print("Enter Quiz ID to attempt: ");
        int quizId = Integer.parseInt(sc.nextLine().trim());

        Quiz selectedQuiz = null;
        for (int i = 0; i < quizzes.size(); i++) {
            Quiz q = quizzes.get(i);
            if (q.getQuizId() == quizId) {
                selectedQuiz = q;
                break;
            }
        }

        if (selectedQuiz == null) {
            System.out.println("Invalid Quiz ID!");
            return;
        }

        int score = selectedQuiz.attemptQuiz(sc);

        try (Connection con = DbConnection.getConnection()) {
            String sql = "INSERT INTO attempt (student_id, quiz_id, score, attempt_date) VALUES (?, ?, ?, NOW())";
           PreparedStatement ps = con.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);

            ps.setInt(1, getUserId());
            ps.setInt(2, quizId);
            ps.setInt(3, score);
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            int attemptId = 0;
            if (rs.next()) {
                attemptId = rs.getInt(1);
            }

            int total = selectedQuiz.getTotalQuestions();
            int percentage = (score * 100) / total;

            String status;
            if (percentage >= 50) {
                status = "PASS";
            } else {
                status = "FAIL";
            }

            String sqlResult = "INSERT INTO result (attempt_id, status) VALUES (?, ?)";
            PreparedStatement psResult = con.prepareStatement(sqlResult);
            psResult.setInt(1, attemptId);
             psResult.setString(2, status);
            psResult.executeUpdate();


            System.out.println("Quiz submitted! Score: " + score + "/" + selectedQuiz.getTotalQuestions() +
                           " | Status: " + status);
        } catch (SQLException e) {
            System.out.println("Error saving quiz attempt: " + e.getMessage());
        }
    }

    public void viewMyScores() {
        if (assignedSection == null) {
            System.out.println("You are not assigned to any section!");
            return;
        }

        try (Connection con = DbConnection.getConnection()) {
            String sql = "SELECT a.score, q.title, s.section_name " +
                         "FROM attempt a " +
                         "JOIN quiz q ON a.quiz_id = q.quiz_id " +
                         "LEFT JOIN section s ON q.section_id = s.section_id " +
                         "WHERE a.student_id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, getUserId());
            ResultSet rs = ps.executeQuery();

            boolean hasScores = false;
            System.out.println("\nMy Quiz Scores:");
            while (rs.next()) {
                hasScores = true;
                System.out.println("Quiz: " + rs.getString("title") +
                                   " | Section: " + rs.getString("section_name") +
                                   " | Score: " + rs.getInt("score"));
            }

            if (!hasScores) System.out.println("You have not attempted any quizzes yet!");
        } catch (SQLException e) {
            System.out.println("Error fetching scores: " + e.getMessage());
        }
    }


public void viewAvailableQuizzes() {
    LinkedList<Quiz> quizzes = getAvailableQuizzes(); 

    if (quizzes.isEmpty()) {
        System.out.println("No quizzes available for your section!");
        return;
    }

    System.out.println("\nAvailable Quizzes:");
    for (Quiz q : quizzes) {
        System.out.println(q.getQuizId() + ". " + q.getQuizName());
    }
}


    @Override
    public String toString() {
        return "Student [Roll: " + rollNumber + ", Name: " + getName() +
               ", Section: " + (assignedSection != null ? assignedSection.getSectionName() : "Not Assigned") + "]";
    }

    
}












