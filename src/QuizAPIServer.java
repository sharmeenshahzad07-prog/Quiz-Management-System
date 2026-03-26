import com.sun.net.httpserver.*;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.InetSocketAddress;
import java.sql.*;
import java.util.List;

public class QuizAPIServer {
    private static Manager manager;
    private static final int PORT = 8080;

    public static void main(String[] args) throws IOException {
        manager = new Manager();
        manager.fetchAllDataFromDB();

        HttpServer server = HttpServer.create(new InetSocketAddress(PORT), 0);

        
        server.createContext("/api/login", QuizAPIServer::handleLogin);
        server.createContext("/api/admin/stats", QuizAPIServer::handleAdminStats);
        server.createContext("/api/admin/details", QuizAPIServer::handleAdminDetails);
        server.createContext("/api/teachers", QuizAPIServer::handleTeachers);
        server.createContext("/api/admin/assign-subject", QuizAPIServer::handleAdminAssignSubject);
        server.createContext("/api/admin/remove-subject", QuizAPIServer::handleAdminRemoveSubject);
        server.createContext("/api/admin/assign-section", QuizAPIServer::handleAdminAssignSection);
        server.createContext("/api/admin/remove-section", QuizAPIServer::handleAdminRemoveSection);
        server.createContext("/api/students", QuizAPIServer::handleStudents);
        server.createContext("/api/sections", QuizAPIServer::handleSections);
        server.createContext("/api/subjects", QuizAPIServer::handleSubjects);
        server.createContext("/api/quizzes", QuizAPIServer::handleQuizzes);
        server.createContext("/api/questions", QuizAPIServer::handleQuestions);
        server.createContext("/api/submit-quiz", QuizAPIServer::handleSubmitQuiz);
        server.createContext("/api/student/profile", QuizAPIServer::handleStudentProfile);
        server.createContext("/api/student/scores", QuizAPIServer::handleStudentScores);
        server.createContext("/api/teacher/profile", QuizAPIServer::handleTeacherProfile);
        server.createContext("/api/teacher/update-profile", QuizAPIServer::handleTeacherUpdateProfile);
        server.createContext("/api/teacher/quizzes", QuizAPIServer::handleTeacherQuizzes);
        server.createContext("/api/teacher/sections", QuizAPIServer::handleTeacherSections);
        server.createContext("/api/teacher/subjects", QuizAPIServer::handleTeacherSubjects);
        server.createContext("/api/teacher/results", QuizAPIServer::handleTeacherResults);
        server.createContext("/api/teacher/create-quiz", QuizAPIServer::handleCreateQuiz);
        server.createContext("/api/teacher/update-quiz", QuizAPIServer::handleUpdateQuiz);
        server.createContext("/api/teacher/delete-quiz", QuizAPIServer::handleDeleteQuiz);

        
        server.createContext("/api/", QuizAPIServer::handleApiNotFound);
        
        
        server.createContext("/", QuizAPIServer::serveStaticFiles);

        server.setExecutor(null);
        
        
        initializeTestData();
        
        server.start();
        System.out.println("Quiz API Server running on http://localhost:" + PORT);
    }

    private static void initializeTestData() {
        try (Connection con = DbConnection.getConnection()) {
            // Check if subjects table is empty
            PreparedStatement checkSubjects = con.prepareStatement("SELECT COUNT(*) as count FROM subject");
            ResultSet rs = checkSubjects.executeQuery();
            rs.next();
            int subjectCount = rs.getInt("count");
            
            if (subjectCount == 0) {
                System.out.println("Inserting test subjects...");
                String[] subjects = {"Mathematics", "English", "Science", "History", "Computer Science"};
                for (String subject : subjects) {
                    PreparedStatement ps = con.prepareStatement("INSERT INTO subject (subject_name) VALUES (?)");
                    ps.setString(1, subject);
                    ps.executeUpdate();
                    ps.close();
                }
            }
            
            // Check if sections table is empty
            PreparedStatement checkSections = con.prepareStatement("SELECT COUNT(*) as count FROM section");
            rs = checkSections.executeQuery();
            rs.next();
            int sectionCount = rs.getInt("count");
            
            if (sectionCount == 0) {
                System.out.println("Inserting test sections...");
                String[] sectionNames = {"A", "B", "C", "D"};
                int[] strengths = {40, 35, 42, 38};
                
                for (int i = 0; i < sectionNames.length; i++) {
                    PreparedStatement ps = con.prepareStatement("INSERT INTO section (section_name, subject_id, strength) VALUES (?, ?, ?)");
                    ps.setString(1, sectionNames[i]);
                    ps.setInt(2, (i % 5) + 1); // Assign to subjects 1-5
                    ps.setInt(3, strengths[i]);
                    ps.executeUpdate();
                    ps.close();
                }
            }
            
            checkSubjects.close();
            checkSections.close();
        } catch (SQLException e) {
            System.out.println("Error initializing test data: " + e.getMessage());
        }
    }

    private static void handleLogin(HttpExchange exchange) throws IOException {
        // Handle CORS preflight
        if ("OPTIONS".equals(exchange.getRequestMethod())) {
            sendResponse(exchange, 200, "");
            return;
        }
        
        if ("POST".equals(exchange.getRequestMethod())) {
            String body = readRequestBody(exchange);
            String[] params = body.split("&");
            String role = "", name = "", password = "";

            for (String param : params) {
                String[] kv = param.split("=");
                if (kv.length == 2) {
                    if (kv[0].equals("role")) role = kv[1];
                    if (kv[0].equals("name")) name = java.net.URLDecoder.decode(kv[1], "UTF-8");
                    if (kv[0].equals("password")) password = java.net.URLDecoder.decode(kv[1], "UTF-8");
                }
            }

            boolean success = false;
            String userId = "";

            if ("ADMIN".equals(role)) {
                Admin admin = manager.getAdmin();
                if (admin != null && admin.getName().equals(name) && admin.getPassword().equals(password)) {
                    success = true;
                    userId = String.valueOf(admin.getUserId());
                }
            } else if ("TEACHER".equals(role)) {
                for (Teacher t : manager.getTeachers()) {
                    if (t.getName().equals(name) && t.getPassword().equals(password)) {
                        success = true;
                        userId = String.valueOf(t.getUserId());
                        manager.setTeacherId(t.getUserId());
                        break;
                    }
                }
            } else if ("STUDENT".equals(role)) {
                for (Student s : manager.getStudents()) {
                    if (s.getName().equals(name) && s.getPassword().equals(password)) {
                        success = true;
                        userId = String.valueOf(s.getUserId());
                        break;
                    }
                }
            }

            String response = success ? "{\"success\":true,\"userId\":\"" + userId + "\"}" 
                                       : "{\"success\":false,\"message\":\"Invalid credentials\"}";
            sendResponse(exchange, 200, response);
        }
    }

    private static void handleAdminDetails(HttpExchange exchange) throws IOException {
        Admin admin = manager.getAdmin();
        if (admin != null) {
            String response = "{\"id\":" + admin.getUserId() + ",\"name\":\"" + admin.getName() + 
                            "\",\"email\":\"" + admin.getEmail() + "\"}";
            sendResponse(exchange, 200, response);
        } else {
            sendResponse(exchange, 404, "{\"error\":\"Admin not found\"}");
        }
    }

    private static void handleAdminStats(HttpExchange exchange) throws IOException {
        if ("OPTIONS".equals(exchange.getRequestMethod())) {
            sendResponse(exchange, 200, "");
            return;
        }
        
        int teacherCount = manager.getTeachers().size();
        int studentCount = manager.getStudents().size();
        int sectionCount = manager.getSections().size();
        int subjectCount = manager.getSubjects().size();
        
        String response = "{\"teacherCount\":" + teacherCount + 
                        ",\"studentCount\":" + studentCount + 
                        ",\"sectionCount\":" + sectionCount + 
                        ",\"subjectCount\":" + subjectCount + "}";
        sendResponse(exchange, 200, response);
    }

    private static void handleTeachers(HttpExchange exchange) throws IOException {
        String path = exchange.getRequestURI().getPath(); 
        String method = exchange.getRequestMethod();
        String idPart = null;
        
        
        if (path.matches("^/api/teachers/\\d+$")) {
            idPart = path.substring("/api/teachers/".length());
        }
        
        try {
            // GET /api/teachers - list all
            if ("GET".equals(method) && idPart == null) {
                StringBuilder json = new StringBuilder("[");
                var teachers = manager.getTeachers();
                for (int i = 0; i < teachers.size(); i++) {
                    Teacher t = teachers.get(i);
                    if (i > 0) json.append(",");
                    json.append("{\"id\":").append(t.getUserId()).append(",\"name\":\"")
                        .append(t.getName()).append("\",\"email\":\"").append(t.getEmail()).append("\"}");
                }
                json.append("]");
                sendResponse(exchange, 200, json.toString());
                return;
            }
            // GET /api/teachers/{id} - get specific teacher
            else if ("GET".equals(method) && idPart != null) {
                int id = Integer.parseInt(idPart);
                Teacher t = manager.getTeacherById(id);
                if (t != null) {
                    // Get assigned sections
                    StringBuilder sections = new StringBuilder("[");
                    List<Section> sectionList = t.getSections();
                    for (int i = 0; i < sectionList.size(); i++) {
                        if (i > 0) sections.append(",");
                        Section sec = sectionList.get(i);
                        sections.append("{\"id\":").append(sec.getSectionId()).append(",\"name\":\"")
                                .append(sec.getSectionName()).append("\"}");
                    }
                    sections.append("]");
                    
                    // Get assigned subjects
                    StringBuilder subjects = new StringBuilder("[");
                    List<Subject> subjectList = t.getSubjects();
                    for (int i = 0; i < subjectList.size(); i++) {
                        if (i > 0) subjects.append(",");
                        Subject subj = subjectList.get(i);
                        subjects.append("{\"id\":").append(subj.getSubjectId()).append(",\"name\":\"")
                                .append(subj.getSubjectName()).append("\"}");
                    }
                    subjects.append("]");
                    
                    String response = "{\"id\":" + t.getUserId() + ",\"name\":\"" + t.getName() 
                                    + "\",\"email\":\"" + t.getEmail() + "\",\"sections\":" + sections.toString()
                                    + ",\"subjects\":" + subjects.toString() + "}";
                    sendResponse(exchange, 200, response);
                } else {
                    sendResponse(exchange, 404, "{\"error\":\"Teacher not found\"}");
                }
                return;
            }
            // POST /api/teachers - create
            else if ("POST".equals(method) && idPart == null) {
                String body = readRequestBody(exchange);
                // Parse JSON or form-urlencoded
                int id = 0; String name = "", email = "", password = "";
                
                // Try JSON first
                if (body.contains("{")) {
                    id = extractIntFromJson(body, "id");
                    name = extractStringFromJson(body, "name");
                    email = extractStringFromJson(body, "email");
                    password = extractStringFromJson(body, "password");
                } else {
                    // Fall back to form-urlencoded
                    String[] params = body.split("&");
                    for (String p : params) {
                        String[] kv = p.split("="); if (kv.length!=2) continue;
                        String k = kv[0]; String v = java.net.URLDecoder.decode(kv[1], "UTF-8");
                        if (k.equals("id")) try { id = Integer.parseInt(v);} catch(Exception e){}
                        if (k.equals("name")) name = v;
                        if (k.equals("email")) email = v;
                        if (k.equals("password")) password = v;
                    }
                }
                
                if (id==0 || name.isEmpty() || email.isEmpty() || password.isEmpty()) {
                    sendResponse(exchange, 400, "{\"success\":false,\"message\":\"Missing fields\"}");
                    return;
                }
                try (Connection con = DbConnection.getConnection()) {
                    PreparedStatement ps1 = con.prepareStatement(
                        "INSERT INTO user(user_id, name, email, password, role) VALUES (?, ?, ?, ?, 'TEACHER')");
                    ps1.setInt(1, id); ps1.setString(2, name); ps1.setString(3, email); ps1.setString(4, password);
                    ps1.executeUpdate();

                    PreparedStatement ps2 = con.prepareStatement("INSERT INTO teacher(teacher_id) VALUES (?)");
                    ps2.setInt(1, id); ps2.executeUpdate();

                    Teacher t = new Teacher(id, name, email, password);
                    manager.getTeachers().add(t);
                    sendResponse(exchange, 200, "{\"success\":true}");
                } catch (SQLException e) {
                    sendResponse(exchange, 500, "{\"success\":false,\"message\":\"DB error\"}");
                }
                return;
            }
            // PUT /api/teachers/{id} - update
            else if ("PUT".equals(method) && idPart != null) {
                int id = Integer.parseInt(idPart);
                String body = readRequestBody(exchange);
                // Parse JSON body
                String name = extractStringFromJson(body, "name");
                String email = extractStringFromJson(body, "email");
                
                if (name.isEmpty() && email.isEmpty()) {
                    sendResponse(exchange, 400, "{\"success\":false,\"message\":\"No fields to update\"}");
                    return;
                }
                
                Teacher t = manager.getTeacherById(id);
                if (t == null) {
                    sendResponse(exchange, 404, "{\"error\":\"Teacher not found\"}");
                    return;
                }
                
                try (Connection con = DbConnection.getConnection()) {
                    if (!name.isEmpty()) {
                        PreparedStatement ps = con.prepareStatement("UPDATE user SET name=? WHERE user_id=? AND role='TEACHER'");
                        ps.setString(1, name);
                        ps.setInt(2, id);
                        ps.executeUpdate();
                        t.setName(name);
                    }
                    if (!email.isEmpty()) {
                        PreparedStatement ps = con.prepareStatement("UPDATE user SET email=? WHERE user_id=? AND role='TEACHER'");
                        ps.setString(1, email);
                        ps.setInt(2, id);
                        ps.executeUpdate();
                        t.setEmail(email);
                    }
                    sendResponse(exchange, 200, "{\"success\":true}");
                } catch (SQLException e) {
                    sendResponse(exchange, 500, "{\"success\":false,\"message\":\"DB error\"}");
                }
                return;
            }
            // DELETE /api/teachers/{id} - delete
            else if ("DELETE".equals(method) && idPart != null) {
                int id = Integer.parseInt(idPart);
                try (Connection con = DbConnection.getConnection()) {
                    PreparedStatement ps1 = con.prepareStatement("DELETE FROM teacher WHERE teacher_id=?");
                    ps1.setInt(1, id); ps1.executeUpdate();
                    PreparedStatement ps2 = con.prepareStatement("DELETE FROM user WHERE user_id=? AND role='TEACHER'");
                    ps2.setInt(1, id); int rows = ps2.executeUpdate();
                    final int targetId = id;
                    manager.getTeachers().removeIf(t -> t.getTeacherId() == targetId);
                    sendResponse(exchange, 200, "{\"success\":true,\"rows\":"+rows+"}");
                } catch (SQLException e) {
                    sendResponse(exchange, 500, "{\"success\":false,\"message\":\"DB error\"}");
                }
                return;
            } else if ("OPTIONS".equals(method)) {
                sendResponse(exchange, 200, "");
                return;
            }
        } catch (Exception e) {
            sendResponse(exchange, 500, "{\"success\":false,\"message\":\"Server error\"}");
        }
    }

    private static void handleStudents(HttpExchange exchange) throws IOException {
        String path = exchange.getRequestURI().getPath(); // /api/students or /api/students/123
        String method = exchange.getRequestMethod();
        String idPart = null;
        
        // Extract ID from path like /api/students/123
        if (path.matches("^/api/students/\\d+$")) {
            idPart = path.substring("/api/students/".length());
        }
        
        try {
            // GET /api/students - list all
            if ("GET".equals(method) && idPart == null) {
                StringBuilder json = new StringBuilder("[");
                var students = manager.getStudents();
                for (int i = 0; i < students.size(); i++) {
                    Student s = students.get(i);
                    String sectionName = s.getAssignedSection() != null ? s.getAssignedSection().getSectionName() : "Not Assigned";
                    if (i > 0) json.append(",");
                    json.append("{\"id\":").append(s.getUserId()).append(",\"name\":\"")
                        .append(s.getName()).append("\",\"rollNo\":\"").append(s.getRollNumber())
                        .append("\",\"email\":\"").append(s.getEmail()).append("\",\"section\":\"")
                        .append(sectionName).append("\"}");
                }
                json.append("]");
                sendResponse(exchange, 200, json.toString());
                return;
            }
            // GET /api/students/{id} - get specific student
            else if ("GET".equals(method) && idPart != null) {
                int id = Integer.parseInt(idPart);
                Student s = manager.getStudentById(id);
                if (s != null) {
                    String sectionName = s.getAssignedSection() != null ? s.getAssignedSection().getSectionName() : "Not Assigned";
                    String response = "{\"id\":" + s.getUserId() + ",\"name\":\"" + s.getName() 
                                    + "\",\"email\":\"" + s.getEmail() + "\",\"rollNo\":\"" + s.getRollNumber()
                                    + "\",\"section\":\"" + sectionName + "\"}";
                    sendResponse(exchange, 200, response);
                } else {
                    sendResponse(exchange, 404, "{\"error\":\"Student not found\"}");
                }
                return;
            }
            // POST /api/students - create
            else if ("POST".equals(method) && idPart == null) {
                String body = readRequestBody(exchange);
                int id = 0; String name = "", email = "", password = "", rollNo = ""; int sectionId = 0;
                
                // Try JSON first
                if (body.contains("{")) {
                    id = extractIntFromJson(body, "id");
                    name = extractStringFromJson(body, "name");
                    email = extractStringFromJson(body, "email");
                    password = extractStringFromJson(body, "password");
                    rollNo = extractStringFromJson(body, "rollNo");
                    sectionId = extractIntFromJson(body, "section");
                } else {
                    // Fall back to form-urlencoded
                    String[] params = body.split("&");
                    for (String p : params) {
                        String[] kv = p.split("="); if (kv.length!=2) continue;
                        String k = kv[0]; String v = java.net.URLDecoder.decode(kv[1], "UTF-8");
                        if (k.equals("id")) try { id = Integer.parseInt(v);} catch(Exception e){}
                        if (k.equals("name")) name = v;
                        if (k.equals("email")) email = v;
                        if (k.equals("password")) password = v;
                        if (k.equals("rollNo")) rollNo = v;
                        if (k.equals("section")) try { sectionId = Integer.parseInt(v);} catch(Exception e){}
                    }
                }
                
                if (id==0 || name.isEmpty() || email.isEmpty() || password.isEmpty()) {
                    sendResponse(exchange, 400, "{\"success\":false,\"message\":\"Missing fields\"}");
                    return;
                }
                try (Connection con = DbConnection.getConnection()) {
                    PreparedStatement ps1 = con.prepareStatement(
                        "INSERT INTO user(user_id, name, email, password, role) VALUES (?, ?, ?, ?, 'STUDENT')");
                    ps1.setInt(1, id); ps1.setString(2, name); ps1.setString(3, email); ps1.setString(4, password);
                    ps1.executeUpdate();
                    PreparedStatement ps2 = con.prepareStatement("INSERT INTO student(student_id, roll_no, section_id) VALUES (?, ?, ?)");
                    ps2.setInt(1, id); ps2.setString(2, rollNo); if (sectionId>0) ps2.setInt(3, sectionId); else ps2.setNull(3, java.sql.Types.INTEGER);
                    ps2.executeUpdate();
                    Section sec = manager.getSectionById(sectionId);
                    Student s = new Student(id, name, email, password, rollNo, sec);
                    manager.getStudents().add(s);
                    sendResponse(exchange, 200, "{\"success\":true}");
                } catch (SQLException e) {
                    sendResponse(exchange, 500, "{\"success\":false,\"message\":\"DB error\"}");
                }
                return;
            }
            // PUT /api/students/{id} - update
            else if ("PUT".equals(method) && idPart != null) {
                int id = Integer.parseInt(idPart);
                String body = readRequestBody(exchange);
                // Parse JSON body
                String name = extractStringFromJson(body, "name");
                String email = extractStringFromJson(body, "email");
                String rollNo = extractStringFromJson(body, "rollNo");
                
                if (name.isEmpty() && email.isEmpty() && rollNo.isEmpty()) {
                    sendResponse(exchange, 400, "{\"success\":false,\"message\":\"No fields to update\"}");
                    return;
                }
                
                Student s = manager.getStudentById(id);
                if (s == null) {
                    sendResponse(exchange, 404, "{\"error\":\"Student not found\"}");
                    return;
                }
                
                try (Connection con = DbConnection.getConnection()) {
                    if (!name.isEmpty()) {
                        PreparedStatement ps = con.prepareStatement("UPDATE user SET name=? WHERE user_id=? AND role='STUDENT'");
                        ps.setString(1, name);
                        ps.setInt(2, id);
                        ps.executeUpdate();
                        s.setName(name);
                    }
                    if (!email.isEmpty()) {
                        PreparedStatement ps = con.prepareStatement("UPDATE user SET email=? WHERE user_id=? AND role='STUDENT'");
                        ps.setString(1, email);
                        ps.setInt(2, id);
                        ps.executeUpdate();
                        s.setEmail(email);
                    }
                    if (!rollNo.isEmpty()) {
                        PreparedStatement ps = con.prepareStatement("UPDATE student SET roll_no=? WHERE student_id=?");
                        ps.setString(1, rollNo);
                        ps.setInt(2, id);
                        ps.executeUpdate();
                        s.setRollNumber(rollNo);
                    }
                    sendResponse(exchange, 200, "{\"success\":true}");
                } catch (SQLException e) {
                    sendResponse(exchange, 500, "{\"success\":false,\"message\":\"DB error\"}");
                }
                return;
            }
            // DELETE /api/students/{id} - delete
            else if ("DELETE".equals(method) && idPart != null) {
                int id = Integer.parseInt(idPart);
                try (Connection con = DbConnection.getConnection()) {
                    PreparedStatement ps1 = con.prepareStatement("DELETE FROM student WHERE student_id=?");
                    ps1.setInt(1, id); ps1.executeUpdate();
                    PreparedStatement ps2 = con.prepareStatement("DELETE FROM user WHERE user_id=? AND role='STUDENT'");
                    ps2.setInt(1, id); int rows = ps2.executeUpdate();
                    final int targetId = id;
                    manager.getStudents().removeIf(st -> st.getStudentId() == targetId);
                    sendResponse(exchange, 200, "{\"success\":true,\"rows\":"+rows+"}");
                } catch (SQLException e) {
                    sendResponse(exchange, 500, "{\"success\":false,\"message\":\"DB error\"}");
                }
                return;
            } else if ("OPTIONS".equals(method)) {
                sendResponse(exchange, 200, "");
                return;
            }
        } catch (Exception e) {
            sendResponse(exchange, 500, "{\"success\":false,\"message\":\"Server error\"}");
        }
    }

    private static void handleSections(HttpExchange exchange) throws IOException {
        StringBuilder json = new StringBuilder("[");
        var sections = manager.getSections();
        for (int i = 0; i < sections.size(); i++) {
            Section sec = sections.get(i);
            if (i > 0) json.append(",");
            json.append("{\"id\":").append(sec.getSectionId()).append(",\"name\":\"")
                .append(sec.getSectionName()).append("\",\"course\":\"").append(sec.getCourseName())
                .append("\",\"strength\":").append(sec.getStrength()).append("}");
        }
        json.append("]");
        sendResponse(exchange, 200, json.toString());
    }

    private static void handleSubjects(HttpExchange exchange) throws IOException {
        // Support GET (list) only for subjects
        try {
            if ("GET".equals(exchange.getRequestMethod())) {
                StringBuilder json = new StringBuilder("[");
                var subjects = manager.getSubjects();
                for (int i = 0; i < subjects.size(); i++) {
                    Subject subj = subjects.get(i);
                    if (i > 0) json.append(",");
                    json.append("{\"id\":").append(subj.getSubjectId()).append(",\"name\":\"")
                        .append(subj.getSubjectName()).append("\"}");
                }
                json.append("]");
                sendResponse(exchange, 200, json.toString());
                return;
            } else if ("OPTIONS".equals(exchange.getRequestMethod())) {
                sendResponse(exchange, 200, "");
                return;
            }
        } catch (Exception e) {
            sendResponse(exchange, 500, "{\"success\":false,\"message\":\"Server error\"}");
        }
    }

    private static void handleQuizzes(HttpExchange exchange) throws IOException {
        // Get query parameter for student ID
        String query = exchange.getRequestURI().getQuery();
        int studentId = 0;
        if (query != null && query.contains("studentId=")) {
            try {
                studentId = Integer.parseInt(query.split("studentId=")[1].split("&")[0]);
            } catch (NumberFormatException e) {
                // Invalid studentId parameter
            }
        }
        
        // Get quizzes from database
        StringBuilder json = new StringBuilder("[");
        try (Connection con = DbConnection.getConnection()) {
            String sql;
            PreparedStatement ps;
            
            if (studentId > 0) {
                // Get student's section and filter quizzes for that section
                sql = "SELECT q.quiz_id, q.title, q.subject_id FROM quiz q " +
                      "WHERE q.section_id = (SELECT section_id FROM student WHERE student_id = ?)";
                ps = con.prepareStatement(sql);
                ps.setInt(1, studentId);
            } else {
                // Fallback to all quizzes if no studentId provided
                sql = "SELECT quiz_id, title, subject_id FROM quiz";
                ps = con.prepareStatement(sql);
            }
            
            ResultSet rs = ps.executeQuery();
            boolean first = true;
            while (rs.next()) {
                if (!first) json.append(",");
                json.append("{\"id\":").append(rs.getInt("quiz_id")).append(",\"title\":\"")
                    .append(rs.getString("title")).append("\",\"subjectId\":").append(rs.getInt("subject_id")).append("}");
                first = false;
            }
            ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        json.append("]");
        sendResponse(exchange, 200, json.toString());
    }

    private static void handleQuestions(HttpExchange exchange) throws IOException {
        String query = exchange.getRequestURI().getQuery();
        int quizId = 0;
        if (query != null && query.contains("quizId=")) {
            quizId = Integer.parseInt(query.split("quizId=")[1]);
        }

        StringBuilder json = new StringBuilder("[");
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                "SELECT qb.question_id, qb.question_text, qb.option_a, qb.option_b, qb.option_c, qb.option_d, qb.marks " +
                "FROM quizquestion qq JOIN questionbank qb ON qq.question_id = qb.question_id WHERE qq.quiz_id = ?")) {
            ps.setInt(1, quizId);
            ResultSet rs = ps.executeQuery();
            
            boolean first = true;
            while (rs.next()) {
                if (!first) json.append(",");
                json.append("{\"id\":").append(rs.getInt("question_id")).append(",\"text\":\"")
                    .append(rs.getString("question_text").replace("\"", "\\\"")).append("\",")
                    .append("\"optionA\":\"").append(rs.getString("option_a")).append("\",")
                    .append("\"optionB\":\"").append(rs.getString("option_b")).append("\",")
                    .append("\"optionC\":\"").append(rs.getString("option_c")).append("\",")
                    .append("\"optionD\":\"").append(rs.getString("option_d")).append("\",")
                    .append("\"marks\":").append(rs.getInt("marks")).append("}");
                first = false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        json.append("]");
        sendResponse(exchange, 200, json.toString());
    }

    // ---- Admin assign/remove handlers ----
    private static void handleAdminAssignSubject(HttpExchange exchange) throws IOException {
        if ("POST".equals(exchange.getRequestMethod())) {
            try {
                String body = readRequestBody(exchange);
                int teacherId = extractIntFromJson(body, "teacherId");
                int subjectId = extractIntFromJson(body, "subjectId");
                
                if (teacherId==0 || subjectId==0) { sendResponse(exchange,400,"{\"success\":false,\"message\":\"Missing ids\"}"); return; }
                Teacher t = manager.getTeacherById(teacherId);
                Subject s = manager.getSubjectById(subjectId);
                if (t==null || s==null) { sendResponse(exchange,404,"{\"success\":false,\"message\":\"Not found\"}"); return; }
                boolean ok = TeachermanageDb.assignSubjectToTeacherDB(t, s);
                sendResponse(exchange, ok?200:500, ok?"{\"success\":true}":"{\"success\":false}");
            } catch (Exception e) { e.printStackTrace(); sendResponse(exchange,500,"{\"success\":false}"); }
        } else if ("OPTIONS".equals(exchange.getRequestMethod())) sendResponse(exchange,200,"");
    }

    private static void handleAdminRemoveSubject(HttpExchange exchange) throws IOException {
        if ("POST".equals(exchange.getRequestMethod())) {
            try {
                String body = readRequestBody(exchange);
                int teacherId = extractIntFromJson(body, "teacherId");
                int subjectId = extractIntFromJson(body, "subjectId");
                
                if (teacherId==0 || subjectId==0) { sendResponse(exchange,400,"{\"success\":false,\"message\":\"Missing ids\"}"); return; }
                Teacher t = manager.getTeacherById(teacherId);
                Subject s = manager.getSubjectById(subjectId);
                if (t==null || s==null) { sendResponse(exchange,404,"{\"success\":false,\"message\":\"Not found\"}"); return; }
                boolean ok = TeachermanageDb.removeSubjectFromTeacherDB(t, s);
                sendResponse(exchange, ok?200:500, ok?"{\"success\":true}":"{\"success\":false}");
            } catch (Exception e) { e.printStackTrace(); sendResponse(exchange,500,"{\"success\":false}"); }
        } else if ("OPTIONS".equals(exchange.getRequestMethod())) sendResponse(exchange,200,"");
    }

    private static void handleAdminAssignSection(HttpExchange exchange) throws IOException {
        if ("POST".equals(exchange.getRequestMethod())) {
            try {
                String body = readRequestBody(exchange);
                int teacherId = extractIntFromJson(body, "teacherId");
                int sectionId = extractIntFromJson(body, "sectionId");
                
                if (teacherId==0 || sectionId==0) { sendResponse(exchange,400,"{\"success\":false,\"message\":\"Missing ids\"}"); return; }
                Teacher t = manager.getTeacherById(teacherId);
                Section sec = manager.getSectionById(sectionId);
                if (t==null || sec==null) { sendResponse(exchange,404,"{\"success\":false,\"message\":\"Not found\"}"); return; }
                boolean ok = TeachermanageDb.assignSectionToTeacherDB(t, sec);
                sendResponse(exchange, ok?200:500, ok?"{\"success\":true}":"{\"success\":false}");
            } catch (Exception e) { e.printStackTrace(); sendResponse(exchange,500,"{\"success\":false}"); }
        } else if ("OPTIONS".equals(exchange.getRequestMethod())) sendResponse(exchange,200,"");
    }

    private static void handleAdminRemoveSection(HttpExchange exchange) throws IOException {
        if ("POST".equals(exchange.getRequestMethod())) {
            try {
                String body = readRequestBody(exchange);
                int teacherId = extractIntFromJson(body, "teacherId");
                int sectionId = extractIntFromJson(body, "sectionId");
                
                if (teacherId==0 || sectionId==0) { sendResponse(exchange,400,"{\"success\":false,\"message\":\"Missing ids\"}"); return; }
                Teacher t = manager.getTeacherById(teacherId);
                Section sec = manager.getSectionById(sectionId);
                if (t==null || sec==null) { sendResponse(exchange,404,"{\"success\":false,\"message\":\"Not found\"}"); return; }
                boolean ok = TeachermanageDb.removeSectionFromTeacherDB(t, sec);
                sendResponse(exchange, ok?200:500, ok?"{\"success\":true}":"{\"success\":false}");
            } catch (Exception e) { e.printStackTrace(); sendResponse(exchange,500,"{\"success\":false}"); }
        } else if ("OPTIONS".equals(exchange.getRequestMethod())) sendResponse(exchange,200,"");
    }

    private static void handleSubmitQuiz(HttpExchange exchange) throws IOException {
        // Handle CORS preflight
        if ("OPTIONS".equals(exchange.getRequestMethod())) {
            sendResponse(exchange, 200, "");
            return;
        }
        
        if ("POST".equals(exchange.getRequestMethod())) {
            try {
                String body = readRequestBody(exchange);
                System.out.println("Submit Quiz Request Body: " + body);
                
                // Parse JSON properly
                int quizId = extractIntFromJson(body, "quizId");
                int studentId = extractIntFromJson(body, "studentId");
                
                System.out.println("Parsed - Quiz ID: " + quizId + ", Student ID: " + studentId);
                
                // Calculate score
                try (Connection con = DbConnection.getConnection()) {
                    // Get all questions and correct answers
                    String questionQuery = "SELECT qq.question_id, qb.correct_option, qb.marks " +
                                         "FROM quizquestion qq " +
                                         "JOIN questionbank qb ON qq.question_id = qb.question_id " +
                                         "WHERE qq.quiz_id = ?";
                    PreparedStatement stmt = con.prepareStatement(questionQuery);
                    stmt.setInt(1, quizId);
                    ResultSet rs = stmt.executeQuery();
                    
                    int score = 0;
                    int totalMarks = 0;
                    
                    while (rs.next()) {
                        int questionId = rs.getInt("question_id");
                        String correctAnswer = rs.getString("correct_option");
                        int marks = rs.getInt("marks");
                        totalMarks += marks;
                        
                        // Find student's answer in JSON answers object
                        String studentAnswer = extractAnswerFromJson(body, questionId);
                        System.out.println("Question " + questionId + ": Student=" + studentAnswer + ", Correct=" + correctAnswer);
                        
                        if (studentAnswer != null && studentAnswer.equals(correctAnswer)) {
                            score += marks;
                        }
                    }
                    
                    System.out.println("Final Score: " + score + " / " + totalMarks);
                    
                    // Save attempt to database
                    String insertAttempt = "INSERT INTO attempt (student_id, quiz_id, score, attempt_date) VALUES (?, ?, ?, NOW())";
                    PreparedStatement insertStmt = con.prepareStatement(insertAttempt, Statement.RETURN_GENERATED_KEYS);
                    insertStmt.setInt(1, studentId);
                    insertStmt.setInt(2, quizId);
                    insertStmt.setInt(3, score);
                    int rowsInserted = insertStmt.executeUpdate();
                    System.out.println("Inserted into attempt: " + rowsInserted + " rows");
                    
                    ResultSet generatedKeys = insertStmt.getGeneratedKeys();
                    int attemptId = -1;
                    if (generatedKeys.next()) {
                        attemptId = generatedKeys.getInt(1);
                        System.out.println("Generated Attempt ID: " + attemptId);
                    }
                    
                    if (attemptId > 0) {
                        // Save result to database
                        String status = (score >= (totalMarks / 2)) ? "PASS" : "FAIL";
                        String insertResult = "INSERT INTO result (attempt_id, status) VALUES (?, ?)";
                        PreparedStatement resultStmt = con.prepareStatement(insertResult);
                        resultStmt.setInt(1, attemptId);
                        resultStmt.setString(2, status);
                        int resultRows = resultStmt.executeUpdate();
                        System.out.println("Inserted into result: " + resultRows + " rows, Status: " + status);
                    }
                    
                    String response = "{\"success\":true,\"message\":\"Quiz submitted successfully\",\"score\":" 
                                    + score + ",\"totalMarks\":" + totalMarks + "}";
                    sendResponse(exchange, 200, response);
                } catch (SQLException e) {
                    System.out.println("SQLException in handleSubmitQuiz: " + e.getMessage());
                    e.printStackTrace();
                    sendResponse(exchange, 500, "{\"success\":false,\"message\":\"Database error: " + e.getMessage().replace("\"", "") + "\"}");
                }
            } catch (Exception e) {
                System.out.println("Exception in handleSubmitQuiz: " + e.getMessage());
                e.printStackTrace();
                sendResponse(exchange, 400, "{\"success\":false,\"message\":\"Invalid request: " + e.getMessage().replace("\"", "") + "\"}");
            }
        }
    }
    
    private static int extractIntFromJson(String json, String key) {
        String pattern = "\"" + key + "\":";
        int start = json.indexOf(pattern);
        if (start == -1) return 0;
        start += pattern.length();
        int end = start;
        while (end < json.length() && Character.isDigit(json.charAt(end))) {
            end++;
        }
        if (end > start) {
            return Integer.parseInt(json.substring(start, end));
        }
        return 0;
    }
    
    private static String extractAnswerFromJson(String json, int questionId) {
        String pattern = "\"question_" + questionId + "\":";
        int start = json.indexOf(pattern);
        if (start == -1) return null;
        start += pattern.length();
        // Skip whitespace and quote
        while (start < json.length() && (json.charAt(start) == ' ' || json.charAt(start) == '"')) {
            start++;
        }
        int end = start;
        while (end < json.length() && json.charAt(end) != '"' && json.charAt(end) != ',') {
            end++;
        }
        if (end > start) {
            return json.substring(start, end).trim();
        }
        return null;
    }

    private static void handleStudentProfile(HttpExchange exchange) throws IOException {
        String query = exchange.getRequestURI().getQuery();
        int studentId = 0;
        if (query != null && query.contains("studentId=")) {
            studentId = Integer.parseInt(query.split("studentId=")[1]);
        }
        
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                "SELECT s.student_id, u.name, u.email, s.roll_no, sec.section_name " +
                "FROM student s " +
                "JOIN user u ON s.student_id = u.user_id " +
                "LEFT JOIN section sec ON s.section_id = sec.section_id " +
                "WHERE s.student_id = ?")) {
            
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                String response = "{\"id\":" + rs.getInt("student_id") + 
                                ",\"name\":\"" + rs.getString("name") + 
                                "\",\"email\":\"" + rs.getString("email") + 
                                "\",\"rollNo\":\"" + rs.getString("roll_no") + 
                                "\",\"section\":\"" + (rs.getString("section_name") != null ? rs.getString("section_name") : "Not Assigned") + "\"}";
                sendResponse(exchange, 200, response);
            } else {
                sendResponse(exchange, 404, "{\"error\":\"Student not found\"}");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            sendResponse(exchange, 500, "{\"error\":\"Database error\"}");
        }
    }

    private static void handleStudentScores(HttpExchange exchange) throws IOException {
        String query = exchange.getRequestURI().getQuery();
        int studentId = 0;
        if (query != null && query.contains("studentId=")) {
            studentId = Integer.parseInt(query.split("studentId=")[1]);
        }
        
        StringBuilder json = new StringBuilder("[");
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                "SELECT q.quiz_id, q.title, a.score, " +
                "(SELECT SUM(marks) FROM quizquestion qq JOIN questionbank qb ON qq.question_id = qb.question_id WHERE qq.quiz_id = q.quiz_id) as totalMarks, " +
                "r.status, a.attempt_date " +
                "FROM attempt a " +
                "JOIN quiz q ON a.quiz_id = q.quiz_id " +
                "LEFT JOIN result r ON a.attempt_id = r.attempt_id " +
                "WHERE a.student_id = ? " +
                "ORDER BY a.attempt_date DESC")) {
            
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            
            boolean first = true;
            while (rs.next()) {
                if (!first) json.append(",");
                int totalMarks = rs.getInt("totalMarks");
                int score = rs.getInt("score");
                json.append("{\"quizId\":").append(rs.getInt("quiz_id"))
                    .append(",\"quizTitle\":\"").append(rs.getString("title"))
                    .append("\",\"score\":").append(score)
                    .append(",\"totalMarks\":").append(totalMarks)
                    .append(",\"status\":\"").append(rs.getString("status") != null ? rs.getString("status") : "PENDING")
                    .append("\",\"attemptDate\":\"").append(rs.getString("attempt_date"))
                    .append("\"}");
                first = false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        json.append("]");
        sendResponse(exchange, 200, json.toString());
    }

    private static void handleTeacherProfile(HttpExchange exchange) throws IOException {
        if ("OPTIONS".equals(exchange.getRequestMethod())) {
            sendResponse(exchange, 200, "");
            return;
        }
        
        String query = exchange.getRequestURI().getQuery();
        int teacherId = 0;
        if (query != null && query.contains("teacherId=")) {
            teacherId = Integer.parseInt(query.split("teacherId=")[1]);
        }
        
        System.out.println("Teacher Profile Request - TeacherId: " + teacherId);
        
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                "SELECT user_id, name, email FROM user WHERE user_id = ? AND role='TEACHER'")) {
            
            ps.setInt(1, teacherId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                String response = "{\"id\":" + rs.getInt("user_id") + 
                                ",\"name\":\"" + rs.getString("name") + 
                                "\",\"email\":\"" + rs.getString("email") + "\"}";
                System.out.println("Teacher Profile Response: " + response);
                sendResponse(exchange, 200, response);
            } else {
                System.out.println("Teacher not found for ID: " + teacherId);
                sendResponse(exchange, 404, "{\"error\":\"Teacher not found\",\"id\":" + teacherId + "}");
            }
        } catch (SQLException e) {
            System.out.println("SQLException in handleTeacherProfile: " + e.getMessage());
            e.printStackTrace();
            sendResponse(exchange, 500, "{\"error\":\"Database error: " + e.getMessage().replace("\"", "") + "\"}");
        }
    }

    private static void handleTeacherUpdateProfile(HttpExchange exchange) throws IOException {
        if ("OPTIONS".equals(exchange.getRequestMethod())) {
            sendResponse(exchange, 200, "");
            return;
        }
        
        if ("POST".equals(exchange.getRequestMethod())) {
            try {
                String body = readRequestBody(exchange);
                int teacherId = extractIntFromJson(body, "teacherId");
                String name = extractStringFromJson(body, "name");
                String email = extractStringFromJson(body, "email");
                
                try (Connection con = DbConnection.getConnection()) {
                    // Update name
                    if (!name.isEmpty()) {
                        PreparedStatement ps = con.prepareStatement(
                            "UPDATE user SET name = ? WHERE user_id = ? AND role = 'TEACHER'");
                        ps.setString(1, name);
                        ps.setInt(2, teacherId);
                        ps.executeUpdate();
                    }
                    
                    // Update email
                    if (!email.isEmpty()) {
                        PreparedStatement ps = con.prepareStatement(
                            "UPDATE user SET email = ? WHERE user_id = ? AND role = 'TEACHER'");
                        ps.setString(1, email);
                        ps.setInt(2, teacherId);
                        ps.executeUpdate();
                    }
                    
                    sendResponse(exchange, 200, "{\"success\":true,\"message\":\"Profile updated successfully\"}");
                }
            } catch (Exception e) {
                e.printStackTrace();
                sendResponse(exchange, 400, "{\"success\":false,\"message\":\"" + e.getMessage() + "\"}");
            }
        }
    }

    private static void handleTeacherQuizzes(HttpExchange exchange) throws IOException {
        String query = exchange.getRequestURI().getQuery();
        int teacherId = 0;
        if (query != null && query.contains("teacherId=")) {
            teacherId = Integer.parseInt(query.split("teacherId=")[1]);
        }
        
        StringBuilder json = new StringBuilder("[");
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                "SELECT q.quiz_id, q.title, s.section_name, sub.subject_name FROM quiz q " +
                "JOIN section s ON q.section_id = s.section_id " +
                "JOIN subject sub ON q.subject_id = sub.subject_id " +
                "WHERE q.teacher_id = ? ORDER BY q.quiz_id DESC")) {
            
            ps.setInt(1, teacherId);
            ResultSet rs = ps.executeQuery();
            
            boolean first = true;
            while (rs.next()) {
                if (!first) json.append(",");
                json.append("{\"quizId\":").append(rs.getInt("quiz_id"))
                    .append(",\"title\":\"").append(rs.getString("title"))
                    .append("\",\"section\":\"").append(rs.getString("section_name"))
                    .append("\",\"subject\":\"").append(rs.getString("subject_name"))
                    .append("\"}");
                first = false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        json.append("]");
        sendResponse(exchange, 200, json.toString());
    }

    private static void handleTeacherSections(HttpExchange exchange) throws IOException {
        String query = exchange.getRequestURI().getQuery();
        int teacherId = 0;
        if (query != null && query.contains("teacherId=")) {
            teacherId = Integer.parseInt(query.split("teacherId=")[1].split("&")[0]);
        }

        StringBuilder json = new StringBuilder("[");
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                "SELECT s.section_id, s.section_name, s.strength FROM section s JOIN teachersection ts ON s.section_id = ts.section_id WHERE ts.teacher_id = ?")) {

            ps.setInt(1, teacherId);
            ResultSet rs = ps.executeQuery();
            boolean first = true;
            while (rs.next()) {
                if (!first) json.append(",");
                json.append("{\"id\":").append(rs.getInt("section_id"))
                    .append(",\"name\":\"").append(rs.getString("section_name").replace("\"","\\\"")).append("\"")
                    .append(",\"strength\":").append(rs.getInt("strength")).append("}");
                first = false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        json.append("]");
        sendResponse(exchange, 200, json.toString());
    }

    private static void handleTeacherSubjects(HttpExchange exchange) throws IOException {
        String query = exchange.getRequestURI().getQuery();
        int teacherId = 0;
        if (query != null && query.contains("teacherId=")) {
            teacherId = Integer.parseInt(query.split("teacherId=")[1].split("&")[0]);
        }

        StringBuilder json = new StringBuilder("[");
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                "SELECT sub.subject_id, sub.subject_name FROM subject sub JOIN teacher_subject ts ON sub.subject_id = ts.subject_id WHERE ts.teacher_id = ?")) {

            ps.setInt(1, teacherId);
            ResultSet rs = ps.executeQuery();
            boolean first = true;
            while (rs.next()) {
                if (!first) json.append(",");
                json.append("{\"id\":").append(rs.getInt("subject_id"))
                    .append(",\"name\":\"").append(rs.getString("subject_name").replace("\"","\\\"")).append("\"}");
                first = false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        json.append("]");
        sendResponse(exchange, 200, json.toString());
    }

    private static void handleTeacherResults(HttpExchange exchange) throws IOException {
        String query = exchange.getRequestURI().getQuery();
        int teacherId = 0;
        String searchType = "";
        String searchValue = "";
        String sortBy = "id";
        
        if (query != null) {
            if (query.contains("teacherId=")) {
                teacherId = Integer.parseInt(query.split("teacherId=")[1].split("&")[0]);
            }
            if (query.contains("searchType=")) {
                searchType = query.split("searchType=")[1].split("&")[0];
            }
            if (query.contains("searchValue=")) {
                searchValue = java.net.URLDecoder.decode(query.split("searchValue=")[1].split("&")[0], "UTF-8");
            }
            if (query.contains("sortBy=")) {
                sortBy = query.split("sortBy=")[1].split("&")[0];
            }
        }
        
        StringBuilder json = new StringBuilder("[");
        try (Connection con = DbConnection.getConnection()) {
            String sql = "SELECT u.user_id, u.name, s.roll_no, q.quiz_id, q.title, a.score, " +
                        "(SELECT SUM(marks) FROM quizquestion qq JOIN questionbank qb ON qq.question_id = qb.question_id WHERE qq.quiz_id = q.quiz_id) as totalMarks, " +
                        "r.status, a.attempt_date " +
                        "FROM attempt a " +
                        "JOIN quiz q ON a.quiz_id = q.quiz_id " +
                        "JOIN student s ON a.student_id = s.student_id " +
                        "JOIN user u ON s.student_id = u.user_id " +
                        "LEFT JOIN result r ON a.attempt_id = r.attempt_id " +
                        "WHERE q.teacher_id = ?";
            
            if ("name".equals(searchType) && !searchValue.isEmpty()) {
                sql += " AND u.name LIKE '%" + searchValue + "%'";
            } else if ("id".equals(searchType) && !searchValue.isEmpty()) {
                sql += " AND s.roll_no = '" + searchValue + "'";
            }
            
            if ("name".equals(sortBy)) {
                sql += " ORDER BY u.name";
            } else {
                sql += " ORDER BY s.roll_no";
            }
            
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, teacherId);
            ResultSet rs = ps.executeQuery();
            
            boolean first = true;
            while (rs.next()) {
                if (!first) json.append(",");
                int totalMarks = rs.getInt("totalMarks");
                if (totalMarks == 0) totalMarks = 100;
                json.append("{\"studentId\":").append(rs.getInt("user_id"))
                    .append(",\"studentName\":\"").append(rs.getString("name"))
                    .append("\",\"rollNo\":\"").append(rs.getString("roll_no"))
                    .append("\",\"quizTitle\":\"").append(rs.getString("title"))
                    .append("\",\"score\":").append(rs.getInt("score"))
                    .append(",\"totalMarks\":").append(totalMarks)
                    .append(",\"status\":\"").append(rs.getString("status") != null ? rs.getString("status") : "PENDING")
                    .append("\",\"attemptDate\":\"").append(rs.getString("attempt_date"))
                    .append("\"}");
                first = false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        json.append("]");
        sendResponse(exchange, 200, json.toString());
    }

    private static void handleCreateQuiz(HttpExchange exchange) throws IOException {
        if ("OPTIONS".equals(exchange.getRequestMethod())) {
            sendResponse(exchange, 200, "");
            return;
        }
        
        if ("POST".equals(exchange.getRequestMethod())) {
            try {
                String body = readRequestBody(exchange);
                int teacherId = extractIntFromJson(body, "teacherId");
                int sectionId = extractIntFromJson(body, "sectionId");
                int subjectId = extractIntFromJson(body, "subjectId");
                String title = extractStringFromJson(body, "title");
                int numQuestions = extractIntFromJson(body, "numQuestions");
                if (numQuestions <= 0) numQuestions = 0;
                
                try (Connection con = DbConnection.getConnection();
                     PreparedStatement ps = con.prepareStatement(
                        "INSERT INTO quiz (title, subject_id, section_id, teacher_id) VALUES (?, ?, ?, ?)",
                        Statement.RETURN_GENERATED_KEYS)) {

                    // Validate teacher is assigned to the subject and section
                    try (PreparedStatement checkSub = con.prepareStatement("SELECT 1 FROM teacher_subject WHERE teacher_id=? AND subject_id=?")) {
                        checkSub.setInt(1, teacherId);
                        checkSub.setInt(2, subjectId);
                        ResultSet rsCheck = checkSub.executeQuery();
                        if (!rsCheck.next()) {
                            sendResponse(exchange, 400, "{\"success\":false,\"message\":\"Teacher not assigned to this subject\"}");
                            return;
                        }
                    }

                    try (PreparedStatement checkSec = con.prepareStatement("SELECT 1 FROM teachersection WHERE teacher_id=? AND section_id=?")) {
                        checkSec.setInt(1, teacherId);
                        checkSec.setInt(2, sectionId);
                        ResultSet rsCheck2 = checkSec.executeQuery();
                        if (!rsCheck2.next()) {
                            sendResponse(exchange, 400, "{\"success\":false,\"message\":\"Teacher not assigned to this section\"}");
                            return;
                        }
                    }

                    ps.setString(1, title);
                    ps.setInt(2, subjectId);
                    ps.setInt(3, sectionId);
                    ps.setInt(4, teacherId);
                    ps.executeUpdate();

                    ResultSet rs = ps.getGeneratedKeys();
                    int quizId = rs.next() ? rs.getInt(1) : -1;

                    if (quizId <= 0) {
                        sendResponse(exchange, 400, "{\"success\":false,\"message\":\"Failed to create quiz\"}");
                        return;
                    }

                    // If numQuestions provided, select random questions from questionbank for the subject
                    if (numQuestions > 0) {
                        try (PreparedStatement qsel = con.prepareStatement(
                                "SELECT question_id FROM questionbank WHERE subject_id=? ORDER BY RAND() LIMIT ?")) {
                            qsel.setInt(1, subjectId);
                            qsel.setInt(2, numQuestions);
                            ResultSet qrs = qsel.executeQuery();
                            boolean hasAny = false;
                            try (PreparedStatement insertMap = con.prepareStatement("INSERT INTO quizquestion (quiz_id, question_id) VALUES (?, ?)") ) {
                                while (qrs.next()) {
                                    hasAny = true;
                                    int qid = qrs.getInt("question_id");
                                    insertMap.setInt(1, quizId);
                                    insertMap.setInt(2, qid);
                                    insertMap.executeUpdate();
                                }
                            }
                            if (!hasAny) {
                                // no questions available; delete created quiz and return error
                                try (PreparedStatement del = con.prepareStatement("DELETE FROM quiz WHERE quiz_id=?")) {
                                    del.setInt(1, quizId);
                                    del.executeUpdate();
                                }
                                sendResponse(exchange, 400, "{\"success\":false,\"message\":\"No questions available for this subject\"}");
                                return;
                            }
                        }
                    }

                    sendResponse(exchange, 200, "{\"success\":true,\"quizId\":" + quizId + "}");
                }
            } catch (Exception e) {
                e.printStackTrace();
                sendResponse(exchange, 400, "{\"success\":false,\"message\":\"" + e.getMessage() + "\"}");
            }
        }
    }

    private static void handleUpdateQuiz(HttpExchange exchange) throws IOException {
        if ("OPTIONS".equals(exchange.getRequestMethod())) {
            sendResponse(exchange, 200, "");
            return;
        }
        
        if ("PUT".equals(exchange.getRequestMethod())) {
            try {
                String body = readRequestBody(exchange);
                int quizId = extractIntFromJson(body, "quizId");
                String title = extractStringFromJson(body, "title");
                
                try (Connection con = DbConnection.getConnection();
                     PreparedStatement ps = con.prepareStatement(
                        "UPDATE quiz SET title = ? WHERE quiz_id = ?")) {
                    
                    ps.setString(1, title);
                    ps.setInt(2, quizId);
                    int rows = ps.executeUpdate();
                    
                    if (rows > 0) {
                        sendResponse(exchange, 200, "{\"success\":true,\"message\":\"Quiz updated\"}");
                    } else {
                        sendResponse(exchange, 400, "{\"success\":false,\"message\":\"Quiz not found\"}");
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                sendResponse(exchange, 400, "{\"success\":false,\"message\":\"" + e.getMessage() + "\"}");
            }
        }
    }

    private static void handleDeleteQuiz(HttpExchange exchange) throws IOException {
        if ("OPTIONS".equals(exchange.getRequestMethod())) {
            sendResponse(exchange, 200, "");
            return;
        }

        if ("DELETE".equals(exchange.getRequestMethod())) {
            try {
                String query = exchange.getRequestURI().getQuery();
                int quizId = 0;
                if (query != null) {
                    String[] params = query.split("&");
                    for (String param : params) {
                        if (param.startsWith("quizId=")) {
                            quizId = Integer.parseInt(param.substring(7)); // "quizId=".length() = 7
                            break;
                        }
                    }
                }

                try (Connection con = DbConnection.getConnection()) {
                    con.setAutoCommit(false);

                    try {
                        // Disable foreign key checks to allow deletion
                        PreparedStatement disableFK = con.prepareStatement("SET FOREIGN_KEY_CHECKS = 0");
                        disableFK.execute();

                        // Delete from result first (cascade from attempt)
                        PreparedStatement ps0 = con.prepareStatement("DELETE FROM result WHERE attempt_id IN (SELECT attempt_id FROM attempt WHERE quiz_id = ?)");
                        ps0.setInt(1, quizId);
                        ps0.executeUpdate();

                        // Delete from attempt
                        PreparedStatement ps1 = con.prepareStatement("DELETE FROM attempt WHERE quiz_id = ?");
                        ps1.setInt(1, quizId);
                        ps1.executeUpdate();

                        // Delete from quizquestion
                        PreparedStatement ps2 = con.prepareStatement("DELETE FROM quizquestion WHERE quiz_id = ?");
                        ps2.setInt(1, quizId);
                        ps2.executeUpdate();

                        // Delete from quiz
                        PreparedStatement ps3 = con.prepareStatement("DELETE FROM quiz WHERE quiz_id = ?");
                        ps3.setInt(1, quizId);
                        int rows = ps3.executeUpdate();

                        // Re-enable foreign key checks
                        PreparedStatement enableFK = con.prepareStatement("SET FOREIGN_KEY_CHECKS = 1");
                        enableFK.execute();

                        con.commit();

                        if (rows > 0) {
                            sendResponse(exchange, 200, "{\"success\":true,\"message\":\"Quiz deleted\"}");
                        } else {
                            sendResponse(exchange, 400, "{\"success\":false,\"message\":\"Quiz not found\"}");
                        }
                    } catch (SQLException e) {
                        con.rollback();
                        throw e;
                    } finally {
                        con.setAutoCommit(true);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                sendResponse(exchange, 400, "{\"success\":false,\"message\":\"" + e.getMessage() + "\"}");
            }
        }
    }

    private static void handleApiNotFound(HttpExchange exchange) throws IOException {
        // Allow CORS preflight
        if ("OPTIONS".equals(exchange.getRequestMethod())) {
            sendResponse(exchange, 200, "{\"error\":\"none\"}");
            return;
        }
        sendResponse(exchange, 404, "{\"error\":\"API endpoint not found\"}");
    }

    private static String extractStringFromJson(String json, String key) {
        String pattern = "\"" + key + "\":\"";
        int start = json.indexOf(pattern);
        if (start == -1) return "";
        start += pattern.length();
        int end = json.indexOf("\"", start);
        if (end > start) {
            return json.substring(start, end);
        }
        return "";
    }

    private static void serveStaticFiles(HttpExchange exchange) throws IOException {
        String path = exchange.getRequestURI().getPath();
        
        // Don't serve files for API requests - let them be handled by other handlers
        if (path.startsWith("/api/")) {
            sendResponse(exchange, 404, "{\"error\":\"API endpoint not found\"}");
            return;
        }
        
        if (path.equals("/")) path = "/index.html";
        
        String filePath = "web/" + path.substring(1);
        File file = new File(filePath);

        if (file.exists() && file.isFile()) {
            String contentType = getContentType(filePath);
            exchange.getResponseHeaders().set("Content-Type", contentType);
            exchange.getResponseHeaders().set("Access-Control-Allow-Origin", "*");
            
            byte[] response = readFile(file);
            exchange.sendResponseHeaders(200, response.length);
            exchange.getResponseBody().write(response);
        } else {
            exchange.getResponseHeaders().set("Content-Type", "text/html");
            exchange.getResponseHeaders().set("Access-Control-Allow-Origin", "*");
            sendResponse(exchange, 404, "<h1>404 - File Not Found</h1>");
        }
        exchange.close();
    }

    private static void sendResponse(HttpExchange exchange, int statusCode, String response) throws IOException {
        exchange.getResponseHeaders().set("Content-Type", "application/json");
        exchange.getResponseHeaders().set("Access-Control-Allow-Origin", "*");
        exchange.getResponseHeaders().set("Access-Control-Allow-Methods", "GET, POST, OPTIONS, PUT, DELETE");
        exchange.getResponseHeaders().set("Access-Control-Allow-Headers", "Content-Type, Authorization");
        byte[] bytes = response.getBytes();
        exchange.sendResponseHeaders(statusCode, bytes.length);
        exchange.getResponseBody().write(bytes);
        exchange.close();
    }

    private static String readRequestBody(HttpExchange exchange) throws IOException {
        InputStream is = exchange.getRequestBody();
        ByteArrayOutputStream result = new ByteArrayOutputStream();
        byte[] buffer = new byte[1024];
        int length;
        while ((length = is.read(buffer)) != -1) {
            result.write(buffer, 0, length);
        }
        return result.toString("UTF-8");
    }

    private static byte[] readFile(File file) throws IOException {
        ByteArrayOutputStream result = new ByteArrayOutputStream();
        try (FileInputStream fis = new FileInputStream(file)) {
            byte[] buffer = new byte[1024];
            int length;
            while ((length = fis.read(buffer)) != -1) {
                result.write(buffer, 0, length);
            }
        }
        return result.toByteArray();
    }

    private static String getContentType(String filePath) {
        if (filePath.endsWith(".html")) return "text/html";
        if (filePath.endsWith(".css")) return "text/css";
        if (filePath.endsWith(".js")) return "application/javascript";
        if (filePath.endsWith(".json")) return "application/json";
        return "text/plain";
    }
}
