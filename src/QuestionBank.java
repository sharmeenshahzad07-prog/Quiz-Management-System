

public class QuestionBank {
    private LinkedList<Question> questions = new LinkedList<>();

    public QuestionBank() {
        fetchQuestionsFromDB();
    }

    public void addQuestion(Question q) {
        questions.add(q);
        q.saveToDB(); 
    }

    public LinkedList<Question> getAllQuestions() {
        return questions;
    }

    public LinkedList<Question> getQuestionsBySubject(int subjectId) {
        LinkedList<Question> list = new LinkedList<>();
        for (Question q : questions) {
            if (q.getSubjectId() == subjectId) list.add(q);
        }
        return list;
    }

    private void fetchQuestionsFromDB() {
        questions = Question.fetchAllQuestions();
    }

    public void removeQuestion(Question q) {
        questions.remove(q);
        q.deleteFromDB(); 
    }
}
