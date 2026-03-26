
import java.util.Scanner;
import java.sql.*;

public class Quiz {
    private int quizId;
    private int subjectId;
    private int sectionId;
    private LinkedList<Question> questions = new LinkedList<>();
    private String quizName;
    private String section;
    private int teacherId;
    private String course;

    public Quiz() {}
    public Quiz(int quizId) {
        this.quizId = quizId;
        loadFromDB();
    }

    public int getQuizId() { return quizId; }
    public void setQuizId(int quizId) { this.quizId = quizId; }

    public int getTeacherId() { return teacherId; }
    public void setTeacherId(int teacherId) { this.teacherId = teacherId; }

    public int getSubjectId() { return subjectId; }
    public void setSubjectId(int subjectId) { this.subjectId = subjectId; }

    public int getSectionId() { return sectionId; }
    public void setSectionId(int sectionId) { this.sectionId = sectionId; }

    public String getSection() { return section; }
    public void setSection(String section) { this.section = section; }

    public String getCourse() { return course; }
    public void setCourse(String course) { this.course = course; }

    public LinkedList<Question> getQuestions() { return questions; }
    public void setQuestions(LinkedList<Question> questions) { this.questions = questions; }

    public int getTotalQuestions() { return questions.size(); }

    public void addQuestion(Question q) { questions.add(q); }

    public String getQuizName() { return quizName; }
    public void setQuizName(String quizName) { this.quizName = quizName; }

    private void loadFromDB() {
        try (Connection con = DbConnection.getConnection()) {
    
            String sql = "SELECT * FROM quiz WHERE quiz_id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, quizId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                quizName = rs.getString("title");
                sectionId = rs.getInt("section_id");
                 teacherId = rs.getInt("teacher_id");
                subjectId = rs.getInt("subject_id");
                
               
               
            }

            sql = "SELECT q.* FROM questionbank q " +
                  "JOIN quizquestion qq ON q.question_id = qq.question_id " +
                  "WHERE qq.quiz_id = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, quizId);
            rs = ps.executeQuery();

            while (rs.next()) {
                Question q = new Question(
                    rs.getInt("question_id"),
                    rs.getInt("subject_id"),
                    rs.getString("question_text"),
                    rs.getString("option_a"),
                    rs.getString("option_b"),
                    rs.getString("option_c"),
                    rs.getString("option_d"),
                    rs.getString("correct_option").charAt(0)
                );
                questions.add(q);
            }

        } catch (SQLException e) {
            System.out.println("Error loading quiz from DB: " + e.getMessage());
        }
    }


    public int attemptQuiz(Scanner sc) {
        if (questions.isEmpty()) return 0;

        StackDS<Integer> history = new StackDS<>();
        char[] answers = new char[questions.size()];
        int currentIndex = 0;

        while (true) {
            Question q = questions.get(currentIndex);
            System.out.println("\n--- Question " + (currentIndex + 1) + " of " + questions.size() + " ---");
            System.out.println("Q: " + q.getText());
            System.out.println("A: " + q.getOptionA());
            System.out.println("B: " + q.getOptionB());
            System.out.println("C: " + q.getOptionC());
            System.out.println("D: " + q.getOptionD());

            if (answers[currentIndex] != '\0') {
                System.out.println("Your previous answer: " + answers[currentIndex]);
            }

            System.out.println("\nOptions:");
            System.out.println("1. Answer A");
            System.out.println("2. Answer B");
            System.out.println("3. Answer C");
            System.out.println("4. Answer D");
            if (currentIndex < questions.size() - 1) System.out.println("5. Next Question");
            if (!history.isEmpty()) System.out.println("6. Previous Question");
            System.out.println("7. Submit Quiz");

            System.out.print("Choose: ");
            int choice = sc.nextInt();
            sc.nextLine();

            if (choice >= 1 && choice <= 4) {
                answers[currentIndex] = (char) ('A' + (choice - 1));
                System.out.println("Answer recorded: " + answers[currentIndex]);
            } else if (choice == 5 && currentIndex < questions.size() - 1) {
                history.push(currentIndex);
                currentIndex++;
            } else if (choice == 6 && !history.isEmpty()) {
                Integer prev = history.pop();
                if (prev != null) currentIndex = prev;
            } else if (choice == 7) {
                break;
            } else {
                System.out.println("Invalid choice!");
            }
        }

        
        int score = 0;
        for (int i = 0; i < questions.size(); i++) {
            if (answers[i] == questions.get(i).getCorrectOption()) score++;
        }
        return score;
    }

    @Override
    public String toString() {
        return "QuizId: " + quizId + "\nName: " + quizName + 
               "\nSubjectId: " + subjectId + "\nSectionId: " + sectionId + 
               "\nTotalQuestions: " + getTotalQuestions();
    }

   
}
