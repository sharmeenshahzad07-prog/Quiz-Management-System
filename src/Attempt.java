import java.sql.*;


public class Attempt {
    private int attemptId;
    private int quizId;
    private int studentId;
    private int score;

    public Attempt() {}

    public Attempt(int attemptId, int quizId, int studentId, int score) {
        this.attemptId = attemptId;
        this.quizId = quizId;
        this.studentId = studentId;
        this.score = score;
    }

  
    public int getAttemptId() { return attemptId; }
    public void setAttemptId(int attemptId) { this.attemptId = attemptId; }

    public int getQuizId() { return quizId; }
    public void setQuizId(int quizId) { this.quizId = quizId; }

    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }

    public int getScore() { return score; }
    public void setScore(int score) { this.score = score; }

    @Override
    public String toString() {
        return "AttemptId: " + getAttemptId() + 
               "\nQuizId: " + getQuizId() + 
               "\nStudentId: " + getStudentId() + 
               "\nScore=" + getScore();
    }

    public static LinkedList<Attempt> fetchAllAttempts() {
        LinkedList<Attempt> list = new LinkedList<>();
        try (Connection con = DbConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery("SELECT * FROM attempt")) {

            while (rs.next()) {
                Attempt a = new Attempt(
                    rs.getInt("attempt_id"),
                    rs.getInt("quiz_id"),
                    rs.getInt("student_id"),
                    rs.getInt("score")
                );
                list.add(a);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void saveToDB() {
        try (Connection con = DbConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO attempt (attempt_id, quiz_id, student_id, score) VALUES (?,?,?,?)"
            );
            ps.setInt(1, attemptId);
            ps.setInt(2, quizId);
            ps.setInt(3, studentId);
            ps.setInt(4, score);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

  
    public void deleteFromDB() {
        try (Connection con = DbConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement(
                "DELETE FROM attempt WHERE attempt_id=?"
            );
            ps.setInt(1, attemptId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
