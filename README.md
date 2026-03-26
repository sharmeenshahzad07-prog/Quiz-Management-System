Quiz Learning Management System! 🎓
To simulate a real-world academic environment, I engineered this platform with strict Role-Based Access Control and data isolation. Every user sees exactly what they need—and nothing more.
Here’s how the ecosystem works:

🛠️ 1. Admin (System & Course Management) The core of the system operations. Admins completely manage the ecosystem by registering students, teachers, and subjects. Crucially, they mimic real-world registration by explicitly assigning specific Teachers to specific Sections and Subjects.

👩‍🏫 2. Teachers (Targeted Assignment & Automated Quiz Generation) :

Data privacy and workflow optimization at its finest. Teachers can only create quizzes for the exact sections they are assigned to, and only view the quiz results of the students within those classrooms. 
⚡ Highlight Feature:  When a teacher generates a quiz, the system automatically pulls questions randomly from a centralized Question Bank in the database (which stores over 300+ MCQs per subject!). This prevents cheating and creates unique assessment experiences.

👨‍🎓 3. Students (Focused Learning):  A distraction-free portal. Students only see and attempt quizzes provided by their assigned teachers for their enrolled sections. To ensure academic integrity, quizzes can only be attempted once, with real-time score calculation scaling instantly upon submission.
The Tech Stack : I wanted to challenge my core engineering fundamentals, so I intentionally avoided heavy frameworks:
🔹 Backend: Written entirely in Core Java. Instead of Spring Boot, I built a custom RESTful API server from scratch using HttpServer. I even implemented custom Data Structures (Linked Lists, Stacks, Queues) to handle memory and logic under the hood. 
 Database: MySQL handles the complex relational mapping of students, teachers, sections, and randomized question banks via JDBC. 🔹Frontend: The responsive UI is built with purely HTML, CSS, and Vanilla JavaScript. 
🔹 Connectivity: The frontend communicates asynchronously with the custom Java API server using the native JS Fetch API, resulting in a lightning-fast, seamless experience.
