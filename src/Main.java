import java.sql.Connection;
import java.sql.SQLException;
import java.util.Scanner;

public class Main {

    public static void main(String[] args) {

        Scanner sc = new Scanner(System.in);
        Manager manager = new Manager();
      

        manager.fetchAllDataFromDB();
        System.out.println("Connected to MySQL database!");

        boolean running = true;

        while (running) {
            System.out.println("\n=== Examination System ===");
            System.out.println("1. Admin Login");
            System.out.println("2. Teacher Login");
            System.out.println("3. Student Login");
            System.out.println("4. Exit");
            System.out.print("Enter choice: ");
            int choice = Integer.parseInt(sc.nextLine());

            switch (choice) {

                case 1: 
                    System.out.print("Enter Admin Name: ");
                    String adminName = sc.nextLine();
                    System.out.print("Enter Password: ");
                    String adminPass = sc.nextLine();
 
                    Admin admin = manager.getAdmin();
                    if (admin != null && admin.getName().equals(adminName) && admin.getPassword().equals(adminPass)) {
                        System.out.println("Login successful!");
                        boolean adminMenu = true;
                        while (adminMenu) {
                            admin.displayAdminMenu();
                            int aChoice = Integer.parseInt(sc.nextLine());

                            if (aChoice == 1) admin.viewAdminDetails(sc);
                            else if (aChoice == 2) admin.manageTeachers(manager, sc);
                            else if (aChoice == 3) admin.manageStudents(sc, manager);
                            else if (aChoice == 4) adminMenu = false;
                            else System.out.println(" Invalid choice!");
                        }
                    } else {
                        System.out.println(" Invalid Admin credentials!");
                    }
                    break;

                case 2:
                    System.out.print("Enter Teacher Name: ");
                    String tName = sc.nextLine();
                    System.out.print("Enter Password: ");
                    String tPass = sc.nextLine();

                    Teacher loggedTeacher = null;
                    for (Teacher t : manager.getTeachers()) {
                        if (t.getName().equals(tName) && t.getPassword().equals(tPass)) {
                            loggedTeacher = t;
                            break;
                        }
                    }

                    if (loggedTeacher != null) {
                        System.out.println("Login successful!");
                        TeachermanageDb.loadSectionsFromDB(loggedTeacher, manager.getSections());
                        TeachermanageDb.loadSubjectsFromDB(loggedTeacher, manager.getSubjects());

                        boolean tMenu = true;
                        while (tMenu) {
                            System.out.println("\n--- Teacher Dashboard ---");
                            System.out.println("1. View Profile");
                            System.out.println("2. Edit Profile");
                            System.out.println("3. Create Quiz");
                            System.out.println("4. View My Quizzes");
                            System.out.println("5. Search Results by Student Name");
                            System.out.println("6. Search Results by Student ID");
                            System.out.println("7. Update Quiz");
                            System.out.println("8. Delete Quiz");
                            System.out.println("9. Sort Results by ID");
                            System.out.println("10. Sort Results by Name");
                            System.out.println("11. Logout");
                            
                            System.out.print("Choice: ");

                            int tChoice = Integer.parseInt(sc.nextLine());

                            if (tChoice == 1) System.out.println(loggedTeacher);
                            else if (tChoice == 2) loggedTeacher.editTeacherProfile(sc);
                            else if (tChoice == 3) loggedTeacher.createQuizFromBank(sc);
                            else if (tChoice == 4) loggedTeacher.viewQuizzes(manager);
                            else if (tChoice == 5) manager.searchResultsByName( loggedTeacher.getTeacherId(),sc);
                            else if (tChoice == 6) manager.searchResultsById(loggedTeacher.getTeacherId(),sc);
                            else if (tChoice == 7) loggedTeacher.updateQuiz(sc, manager);
                            else if (tChoice == 8) loggedTeacher.deleteQuiz(sc, manager);
                            else if (tChoice == 9) manager.sortResultsById(loggedTeacher.getTeacherId());
                            else if (tChoice == 10) manager.sortResultsByName(loggedTeacher.getTeacherId());
                            else if (tChoice == 11) tMenu = false;
                            
                            else System.out.println(" Invalid choice!");
                        }
                    } else {
                        System.out.println(" Invalid Teacher credentials!");
                    }
                    break;

                case 3: 
                    System.out.print("Enter Student Name: ");
                    String sName = sc.nextLine();
                    System.out.print("Enter Password: ");
                    String sPass = sc.nextLine();

                    Student loggedStudent = null;
                    for (Student s : manager.getStudents()) {
                        if (s.getName().equals(sName) && s.getPassword().equals(sPass)) {
                            loggedStudent = s;
                            break;
                        }
                    }

                   if (loggedStudent != null) {
                    System.out.println(" Login successful!");
                    boolean sMenu = true;
                    while (sMenu) {
                        System.out.println("\n--- Student Dashboard ---");
                        System.out.println("1. View Profile");
                        System.out.println("2. View Available Quizzes");
                        System.out.println("3. Attempt Quiz");
                        System.out.println("4. View My Scores");
                        System.out.println("5. Logout");
                        System.out.print("Choice: ");

                        int sChoice = 0;
                        try {
                            sChoice = Integer.parseInt(sc.nextLine().trim());
                        } catch (NumberFormatException e) {
                            System.out.println("Invalid input! Enter a number.");
                            continue;
                        }

                        if (sChoice == 1) {
                            System.out.println(loggedStudent); 

                        } else if (sChoice == 2) {
                            loggedStudent.viewAvailableQuizzes(); 

                        } else if (sChoice == 3) {
                            loggedStudent.attemptQuiz(sc); 

                        } else if (sChoice == 4) {
                            loggedStudent.viewMyScores(); 

                        } else if (sChoice == 5) {
                            System.out.println("Logging out...");
                            sMenu = false;

                        } else {
                            System.out.println("Invalid choice!");
                        }

                    }
                } else {
                    System.out.println("Invalid Student credentials!");
                }
                break;


                                case 4:
                                    running = false;
                                    System.out.println("Exiting system...");
                                    break;

                                default:
                                    System.out.println("Invalid choice!");
                            }
        }

        sc.close();
    }
}
