
import java.sql.*;

public class Result {
    private int resultId;
    private Student student;
    private Quiz quiz;
    private int obtainedMarks;
    private int studentId;

    public Result() {}

    public Result(int resultId, Student student, Quiz quiz, int obtainedMarks) {
        this.resultId = resultId;
        this.student = student;
        this.quiz = quiz;
        this.obtainedMarks = obtainedMarks;
    }

    public int getResultId() { return resultId; }
     public void setResultId(int resultId) { this.resultId = resultId; }

    public Student getStudent() { return student; }
    public void setQuiz(Quiz quiz) { this.quiz = quiz; }
    public Quiz getQuiz() { return quiz; }
    
    public void setObtainedMarks(int obtainedMarks) { 
        if(obtainedMarks >= 0) this.obtainedMarks = obtainedMarks;
        else System.out.println("Invalid marks!");
    }
    public int getObtainedMarks() { return obtainedMarks; }
    public void setStudentId(int studentId) {
    this.studentId = studentId;
}

    @Override
    public String toString() {
        return "Result ID: " + resultId + " | Student: " + (student != null ? student.getName() : "Unknown") +
               " | Quiz: " + (quiz != null ? quiz.getQuizName() : "Unknown") +
               " | Marks: " + obtainedMarks;
    }

public static LinkedList<Result> loadByStudent(int studentId) {
    LinkedList<Result> results = new LinkedList<>();

    String sql = "SELECT a.attempt_id, a.score, q.quiz_id, q.title, q.section_id, q.teacher_id, q.subject_id " +
                 "FROM attempt a " +
                 "JOIN quiz q ON a.quiz_id = q.quiz_id " +
                 "WHERE a.student_id = ?";

    try (Connection con = DbConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, studentId);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
        
            Quiz q = new Quiz();
            q.setQuizId(rs.getInt("quiz_id"));
            q.setQuizName(rs.getString("title"));       
            q.setSection(String.valueOf(rs.getInt("section_id"))); 
            q.setTeacherId(rs.getInt("teacher_id"));
            q.setSubjectId(rs.getInt("subject_id"));

            Result r = new Result();
            r.setResultId(rs.getInt("attempt_id"));
            r.setStudentId(studentId); 
            r.setQuiz(q);
            r.setObtainedMarks(rs.getInt("score"));

            results.add(r);
        }

    } catch (SQLException e) {
        System.out.println("Error loading student results: " + e.getMessage());
    }

    return results;
}



}




