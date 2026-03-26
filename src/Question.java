import java.sql.*;

import java.util.Scanner;

public class Question {
    private int questionId;
    private int subjectId;
    private String text;
    private String optionA, optionB, optionC, optionD;
    private char correctOption;

    public Question() {
        
    }

    public Question(int questionId, int subjectId, String text,
                    String optionA, String optionB, String optionC, String optionD,
                    char correctOption) {
        this.questionId = questionId;
        this.subjectId = subjectId;
        this.text = text;
        this.optionA = optionA;
        this.optionB = optionB;
        this.optionC = optionC;
        this.optionD = optionD;
        this.correctOption = Character.toUpperCase(correctOption);
    }

    public void validateCorrectOption(Scanner sc) {
        while ("ABCD".indexOf(Character.toUpperCase(correctOption)) == -1) {
            System.out.print("Invalid correct option! Enter A, B, C, or D: ");
            String input = sc.nextLine();
            if (input != null && input.length() > 0) {
                correctOption = Character.toUpperCase(input.charAt(0));
            }
        }
    }

    public int getQuestionId() { return questionId; }
    public void setQuestionId(int questionId) { this.questionId = questionId; }

    public int getSubjectId() { return subjectId; }
    public void setSubjectId(int subjectId) { this.subjectId = subjectId; }

    public String getText() { return text; }
    public void setText(String text) { this.text = text; }

    public String getOptionA() { return optionA; }
    public void setOptionA(String optionA) { this.optionA = optionA; }

    public String getOptionB() { return optionB; }
    public void setOptionB(String optionB) { this.optionB = optionB; }

    public String getOptionC() { return optionC; }
    public void setOptionC(String optionC) { this.optionC = optionC; }

    public String getOptionD() { return optionD; }
    public void setOptionD(String optionD) { this.optionD = optionD; }

    public char getCorrectOption() { return correctOption; }
    public void setCorrectOption(char correctOption) { this.correctOption = Character.toUpperCase(correctOption); }

    @Override
    public String toString() {
        return "Q" + questionId + ": " + text + 
               " [A:" + optionA + ", B:" + optionB + ", C:" + optionC + ", D:" + optionD + "]" +
               " Correct: " + correctOption;
    }

    public static LinkedList<Question> fetchAllQuestions() {
        LinkedList<Question> list = new LinkedList<>();
        try (Connection con = DbConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery("SELECT * FROM questionbank")) {

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
                list.add(q);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void saveToDB() {
        try (Connection con = DbConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO questionbank (question_id, subject_id, text, option_a, option_b, option_c, option_d, correct_option) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)"
            );
            ps.setInt(1, questionId);
            ps.setInt(2, subjectId);
            ps.setString(3, text);
            ps.setString(4, optionA);
            ps.setString(5, optionB);
            ps.setString(6, optionC);
            ps.setString(7, optionD);
            ps.setString(8, String.valueOf(correctOption));
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deleteFromDB() {
        try (Connection con = DbConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement(
                "DELETE FROM questionbank WHERE question_id=?"
            );
            ps.setInt(1, questionId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
