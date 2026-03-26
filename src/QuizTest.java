import java.io.*;
import java.net.*;

public class QuizTest {
    public static void main(String[] args) throws Exception {
        Thread.sleep(3000);
        
        
        String payload = "{\"quizId\":1,\"studentId\":8,\"answers\":{\"question_1\":\"A\",\"question_2\":\"B\"}}";
        
        URL url = new URL("http://localhost:8080/api/submit-quiz");
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setDoOutput(true);
        
        try (OutputStream os = conn.getOutputStream()) {
            byte[] payload_bytes = payload.getBytes("utf-8");
            os.write(payload_bytes, 0, payload_bytes.length);
        }
        
        System.out.println("Response Code: " + conn.getResponseCode());
        
        BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        String line;
        StringBuilder response = new StringBuilder();
        while ((line = br.readLine()) != null) {
            response.append(line);
        }
        br.close();
        
        System.out.println("Response: " + response.toString());
    }
}
