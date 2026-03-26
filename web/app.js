// ===== API Configuration =====
const API_BASE = 'http://localhost:8080/api';
let currentUser = null;
let currentRole = null;
let currentQuizId = null;

// ===== Login Handler =====
document.getElementById('loginForm').addEventListener('submit', async (e) => {
    e.preventDefault();
    
    const role = document.getElementById('role').value;
    const name = document.getElementById('name').value;
    const password = document.getElementById('password').value;
    const errorMsg = document.getElementById('errorMsg');
    
    errorMsg.textContent = '';

    try {
        const response = await fetch(`${API_BASE}/login`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: `role=${role}&name=${encodeURIComponent(name)}&password=${encodeURIComponent(password)}`
        });

        const data = await response.json();

        if (data.success) {
            currentUser = {
                id: data.userId,
                name: name,
                role: role
            };
            currentRole = role;

            // Persist minimal auth info for standalone teacher page
            try {
                localStorage.setItem('userId', String(data.userId));
                localStorage.setItem('role', role);
                localStorage.setItem('name', name);
            } catch (e) {
                console.warn('localStorage unavailable:', e);
            }

            // Route to appropriate dashboard
            if (role === 'TEACHER') {
                window.location.href = 'teacher.html';
            } else if (role === 'ADMIN') {
                window.location.href = 'admin.html';
            } else {
                showDashboard(role);
            }
        } else {
            errorMsg.textContent = data.message || 'Login failed. Please check your credentials.';
        }
    } catch (error) {
        errorMsg.textContent = 'Connection error. Make sure the server is running.';
        console.error('Login error:', error);
    }
});

// ===== Show Dashboard =====
function showDashboard(role) {
    document.querySelector('.login-container').style.display = 'none';
    
    switch(role) {
        case 'ADMIN':
            document.getElementById('adminDashboard').classList.remove('hidden');
            loadAdminData();
            break;
        case 'TEACHER':
            document.getElementById('teacherDashboard').classList.remove('hidden');
            loadTeacherData();
            break;
        case 'STUDENT':
            document.getElementById('studentDashboard').classList.remove('hidden');
            loadStudentData();
            break;
    }
}

// ===== Admin Functions =====
async function loadAdminData() {
    try {
        const [teachers, students, sections, subjects] = await Promise.all([
            fetch(`${API_BASE}/teachers`).then(r => r.json()),
            fetch(`${API_BASE}/students`).then(r => r.json()),
            fetch(`${API_BASE}/sections`).then(r => r.json()),
            fetch(`${API_BASE}/subjects`).then(r => r.json())
        ]);

        // Update stats
        document.getElementById('teacherCount').textContent = teachers.length;
        document.getElementById('studentCount').textContent = students.length;
        document.getElementById('sectionCount').textContent = sections.length;
        document.getElementById('subjectCount').textContent = subjects.length;

        // Load tables
        loadTeachersTable(teachers);
        loadStudentsTable(students);
        loadSectionsTable(sections);
        loadSubjectsTable(subjects);

        // populate section select in admin add-student form
        const sectionSelect = document.getElementById('addStudentSection');
        if (sectionSelect) {
            sectionSelect.innerHTML = '<option value="">Section (optional)</option>' +
                sections.map(s => `<option value="${s.id}">${s.name}</option>`).join('');
        }

        // wire admin form buttons
        const addTeacherBtn = document.getElementById('addTeacherBtn');
        if (addTeacherBtn) addTeacherBtn.onclick = adminAddTeacher;
        const removeTeacherBtn = document.getElementById('removeTeacherBtn');
        if (removeTeacherBtn) removeTeacherBtn.onclick = adminRemoveTeacher;
        const addStudentBtn = document.getElementById('addStudentBtn');
        if (addStudentBtn) addStudentBtn.onclick = adminAddStudent;
        const removeStudentBtn = document.getElementById('removeStudentBtn');
        if (removeStudentBtn) removeStudentBtn.onclick = adminRemoveStudent;
        // populate admin teacher/subject/section selects
        const teacherSelect = document.getElementById('adminTeacherSelect');
        const teacherSelect2 = document.getElementById('adminTeacherSelect2');
        const subjectSelect = document.getElementById('adminSubjectSelect');
        const sectionSelectAdmin = document.getElementById('adminSectionSelect');
        if (teacherSelect) teacherSelect.innerHTML = '<option value="">Select Teacher</option>' + teachers.map(t => `<option value="${t.id}">${t.name} (${t.id})</option>`).join('');
        if (teacherSelect2) teacherSelect2.innerHTML = teacherSelect ? teacherSelect.innerHTML : (teachers.map(t => `<option value="${t.id}">${t.name} (${t.id})</option>`).join(''));
        if (subjectSelect) subjectSelect.innerHTML = '<option value="">Select Subject</option>' + subjects.map(s => `<option value="${s.id}">${s.name}</option>`).join('');
        if (sectionSelectAdmin) sectionSelectAdmin.innerHTML = '<option value="">Select Section</option>' + sections.map(s => `<option value="${s.id}">${s.name} (${s.id})</option>`).join('');

        // wire assign/remove buttons
        const assignSubjectBtn = document.getElementById('assignSubjectBtn'); if (assignSubjectBtn) assignSubjectBtn.onclick = adminAssignSubject;
        const removeSubjectBtn = document.getElementById('removeSubjectBtn'); if (removeSubjectBtn) removeSubjectBtn.onclick = adminRemoveSubject;
        const assignSectionBtn = document.getElementById('assignSectionBtn'); if (assignSectionBtn) assignSectionBtn.onclick = adminAssignSection;
        const removeSectionBtn = document.getElementById('removeSectionBtn'); if (removeSectionBtn) removeSectionBtn.onclick = adminRemoveSection;
    } catch (error) {
        console.error('Error loading admin data:', error);
    }
}

async function adminAssignSubject() {
    const teacherId = document.getElementById('adminTeacherSelect').value;
    const subjectId = document.getElementById('adminSubjectSelect').value;
    if (!teacherId || !subjectId) { alert('Select teacher and subject'); return; }
    try {
        const res = await fetch(`${API_BASE}/admin/assign-subject`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: `teacherId=${teacherId}&subjectId=${subjectId}`
        });
        const data = await res.json(); if (data.success) { alert('Subject assigned'); loadAdminData(); } else alert('Failed');
    } catch (e) { console.error(e); alert('Network error'); }
}

async function adminRemoveSubject() {
    const teacherId = document.getElementById('adminTeacherSelect').value;
    const subjectId = document.getElementById('adminSubjectSelect').value;
    if (!teacherId || !subjectId) { alert('Select teacher and subject'); return; }
    try {
        const res = await fetch(`${API_BASE}/admin/remove-subject`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: `teacherId=${teacherId}&subjectId=${subjectId}`
        });
        const data = await res.json(); if (data.success) { alert('Subject removed'); loadAdminData(); } else alert('Failed');
    } catch (e) { console.error(e); alert('Network error'); }
}

async function adminAssignSection() {
    const teacherId = document.getElementById('adminTeacherSelect2').value;
    const sectionId = document.getElementById('adminSectionSelect').value;
    if (!teacherId || !sectionId) { alert('Select teacher and section'); return; }
    try {
        const res = await fetch(`${API_BASE}/admin/assign-section`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: `teacherId=${teacherId}&sectionId=${sectionId}`
        });
        const data = await res.json(); if (data.success) { alert('Section assigned'); loadAdminData(); } else alert('Failed');
    } catch (e) { console.error(e); alert('Network error'); }
}

async function adminRemoveSection() {
    const teacherId = document.getElementById('adminTeacherSelect2').value;
    const sectionId = document.getElementById('adminSectionSelect').value;
    if (!teacherId || !sectionId) { alert('Select teacher and section'); return; }
    try {
        const res = await fetch(`${API_BASE}/admin/remove-section`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: `teacherId=${teacherId}&sectionId=${sectionId}`
        });
        const data = await res.json(); if (data.success) { alert('Section removed'); loadAdminData(); } else alert('Failed');
    } catch (e) { console.error(e); alert('Network error'); }
}

// ===== Admin actions =====
async function adminAddTeacher() {
    const id = document.getElementById('addTeacherId').value.trim();
    const name = document.getElementById('addTeacherName').value.trim();
    const email = document.getElementById('addTeacherEmail').value.trim();
    const password = document.getElementById('addTeacherPassword').value;
    if (!id || !name || !email || !password) { alert('Please fill all teacher fields'); return; }
    try {
        const res = await fetch(`${API_BASE}/teachers`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: `id=${encodeURIComponent(id)}&name=${encodeURIComponent(name)}&email=${encodeURIComponent(email)}&password=${encodeURIComponent(password)}`
        });
        const data = await res.json();
        if (data.success) { alert('Teacher added'); loadAdminData(); } else alert('Error adding teacher');
    } catch (e) { console.error(e); alert('Network error'); }
}

async function adminRemoveTeacher() {
    const id = document.getElementById('removeTeacherId').value.trim();
    if (!id) { alert('Enter teacher ID'); return; }
    if (!confirm('Remove teacher ID '+id+'?')) return;
    try {
        const res = await fetch(`${API_BASE}/teachers?id=${encodeURIComponent(id)}`, { method: 'DELETE' });
        const data = await res.json();
        if (data.success) { alert('Teacher removed'); loadAdminData(); } else alert('Error removing teacher');
    } catch (e) { console.error(e); alert('Network error'); }
}

async function adminAddStudent() {
    const id = document.getElementById('addStudentId').value.trim();
    const name = document.getElementById('addStudentName').value.trim();
    const rollNo = document.getElementById('addStudentRoll').value.trim();
    const email = document.getElementById('addStudentEmail').value.trim();
    const password = document.getElementById('addStudentPassword').value;
    const sectionId = document.getElementById('addStudentSection').value;
    if (!id || !name || !email || !password) { alert('Please fill required student fields'); return; }
    try {
        const body = `id=${encodeURIComponent(id)}&name=${encodeURIComponent(name)}&rollNo=${encodeURIComponent(rollNo)}&email=${encodeURIComponent(email)}&password=${encodeURIComponent(password)}&sectionId=${encodeURIComponent(sectionId)}`;
        const res = await fetch(`${API_BASE}/students`, { method: 'POST', headers: { 'Content-Type': 'application/x-www-form-urlencoded' }, body });
        const data = await res.json();
        if (data.success) { alert('Student added'); loadAdminData(); } else alert('Error adding student');
    } catch (e) { console.error(e); alert('Network error'); }
}

async function adminRemoveStudent() {
    const id = document.getElementById('removeStudentId').value.trim();
    if (!id) { alert('Enter student ID'); return; }
    if (!confirm('Remove student ID '+id+'?')) return;
    try {
        const res = await fetch(`${API_BASE}/students?id=${encodeURIComponent(id)}`, { method: 'DELETE' });
        const data = await res.json();
        if (data.success) { alert('Student removed'); loadAdminData(); } else alert('Error removing student');
    } catch (e) { console.error(e); alert('Network error'); }
}

function loadTeachersTable(teachers) {
    const tbody = document.getElementById('teacherTable');
    if (teachers.length === 0) {
        tbody.innerHTML = '<tr><td colspan="3">No teachers found</td></tr>';
        return;
    }

    tbody.innerHTML = teachers.map(t => `
        <tr>
            <td>${t.id}</td>
            <td>${t.name}</td>
            <td>${t.email}</td>
        </tr>
    `).join('');
}

function loadStudentsTable(students) {
    const tbody = document.getElementById('studentTable');
    if (students.length === 0) {
        tbody.innerHTML = '<tr><td colspan="4">No students found</td></tr>';
        return;
    }

    tbody.innerHTML = students.map(s => `
        <tr>
            <td>${s.id}</td>
            <td>${s.name}</td>
            <td>${s.rollNo}</td>
            <td>${s.email}</td>
        </tr>
    `).join('');
}

function loadSectionsTable(sections) {
    const tbody = document.getElementById('sectionTable');
    if (sections.length === 0) {
        tbody.innerHTML = '<tr><td colspan="4">No sections found</td></tr>';
        return;
    }

    tbody.innerHTML = sections.map(sec => `
        <tr>
            <td>${sec.id}</td>
            <td>${sec.name}</td>
            <td>${sec.course}</td>
            <td>${sec.strength}</td>
        </tr>
    `).join('');
}

function loadSubjectsTable(subjects) {
    const tbody = document.getElementById('subjectTable');
    if (subjects.length === 0) {
        tbody.innerHTML = '<tr><td colspan="2">No subjects found</td></tr>';
        return;
    }

    tbody.innerHTML = subjects.map(s => `
        <tr>
            <td>${s.id}</td>
            <td>${s.name}</td>
        </tr>
    `).join('');
}

function showAdminSection(section) {
    document.querySelectorAll('#adminDashboard .section').forEach(s => s.classList.remove('active'));
    document.getElementById(section).classList.add('active');
    
    document.querySelectorAll('#adminDashboard .menu-btn').forEach(btn => btn.classList.remove('active'));
    event.target.classList.add('active');
}

// ===== Teacher Functions =====
async function loadTeacherData() {
    try {
        const quizzes = await fetch(`${API_BASE}/quizzes`).then(r => r.json());
        const sections = await fetch(`${API_BASE}/sections`).then(r => r.json());
        
        loadTeacherQuizzesTable(quizzes);
        loadTeacherSectionsTable(sections);
    } catch (error) {
        console.error('Error loading teacher data:', error);
    }
}

function loadTeacherQuizzesTable(quizzes) {
    const tbody = document.getElementById('quizTable');
    if (quizzes.length === 0) {
        tbody.innerHTML = '<tr><td colspan="4">No quizzes found</td></tr>';
        return;
    }

    tbody.innerHTML = quizzes.map(q => `
        <tr>
            <td>${q.id}</td>
            <td>${q.title}</td>
            <td>${q.subjectId}</td>
            <td><button class="btn-view" onclick="viewQuizDetails(${q.id})">View</button></td>
        </tr>
    `).join('');
}

function loadTeacherSectionsTable(sections) {
    const tbody = document.getElementById('teacherSectionTable');
    if (sections.length === 0) {
        tbody.innerHTML = '<tr><td colspan="4">No sections found</td></tr>';
        return;
    }

    tbody.innerHTML = sections.map(sec => `
        <tr>
            <td>${sec.id}</td>
            <td>${sec.name}</td>
            <td>${sec.course}</td>
            <td>${sec.strength}</td>
        </tr>
    `).join('');
}

function showTeacherSection(section) {
    const sectionMap = {
        'overview': 'teacher-overview',
        'create-quiz': 'teacher-create-quiz',
        'quizzes': 'teacher-quizzes',
        'sections': 'teacher-sections',
        'search-name': 'teacher-search-name',
        'search-id': 'teacher-search-id',
        'all-results': 'teacher-all-results'
    };
    
    document.querySelectorAll('#teacherDashboard .section').forEach(s => s.classList.remove('active'));
    const targetSection = document.getElementById(sectionMap[section]);
    if (targetSection) {
        targetSection.classList.add('active');
        
        // Load data when opening sections
        if (section === 'all-results') {
            teacherLoadAllResults();
        } else if (section === 'create-quiz') {
            loadTeacherQuizFormData();
        }
    }
    
    document.querySelectorAll('#teacherDashboard .menu-btn').forEach(btn => btn.classList.remove('active'));
    if (event && event.target) {
        event.target.classList.add('active');
    }
}

async function loadTeacherQuizFormData() {
    try {
        const [sections, subjects] = await Promise.all([
            fetch(`${API_BASE}/sections`).then(r => r.json()),
            fetch(`${API_BASE}/subjects`).then(r => r.json())
        ]);

        const sectionSelect = document.getElementById('teacherQuizSection');
        const subjectSelect = document.getElementById('teacherQuizSubject');

        sectionSelect.innerHTML = '<option value="">Select Section</option>' + 
            sections.map(s => `<option value="${s.id}">${s.name}</option>`).join('');

        subjectSelect.innerHTML = '<option value="">Select Subject</option>' + 
            subjects.map(s => `<option value="${s.id}">${s.name}</option>`).join('');
    } catch (error) {
        console.error('Error loading quiz form data:', error);
    }
}

async function teacherSearchResultsByName() {
    const name = document.getElementById('searchNameInput').value.trim();
    if (!name) {
        alert('Please enter a student name');
        return;
    }

    try {
        const response = await fetch(`${API_BASE}/student/search?name=${encodeURIComponent(name)}`);
        const results = await response.json();
        displayTeacherSearchResults(results, 'searchNameResults');
    } catch (error) {
        console.error('Error searching by name:', error);
        alert('Error searching results');
    }
}

async function teacherSearchResultsById() {
    const id = document.getElementById('searchIdInput').value.trim();
    if (!id) {
        alert('Please enter a student ID or roll number');
        return;
    }

    try {
        const response = await fetch(`${API_BASE}/student/search?id=${encodeURIComponent(id)}`);
        const results = await response.json();
        displayTeacherSearchResults(results, 'searchIdResults');
    } catch (error) {
        console.error('Error searching by ID:', error);
        alert('Error searching results');
    }
}

async function teacherLoadAllResults() {
    try {
        const response = await fetch(`${API_BASE}/results`);
        const results = await response.json();
        teacherDisplayAllResults(results);
    } catch (error) {
        console.error('Error loading all results:', error);
        document.getElementById('allResultsContainer').innerHTML = '<p>Error loading results</p>';
    }
}

function teacherSortResults(sortBy) {
    const container = document.getElementById('allResultsContainer');
    const rows = Array.from(container.querySelectorAll('tbody tr'));
    
    rows.sort((a, b) => {
        const cellIndex = sortBy === 'id' ? 0 : 1;
        const aText = a.cells[cellIndex].textContent.trim();
        const bText = b.cells[cellIndex].textContent.trim();
        return aText.localeCompare(bText);
    });
    
    const tbody = container.querySelector('tbody');
    rows.forEach(row => tbody.appendChild(row));
}

function displayTeacherSearchResults(results, containerId) {
    const container = document.getElementById(containerId);
    
    if (!results || results.length === 0) {
        container.innerHTML = '<p>No results found</p>';
        return;
    }

    let html = `
        <table class="data-table">
            <thead>
                <tr>
                    <th>Student ID</th>
                    <th>Name</th>
                    <th>Quiz Title</th>
                    <th>Score</th>
                    <th>Total Marks</th>
                    <th>Percentage</th>
                    <th>Status</th>
                    <th>Date</th>
                </tr>
            </thead>
            <tbody>
    `;

    results.forEach(result => {
        const percentage = result.totalMarks > 0 ? ((result.score / result.totalMarks) * 100).toFixed(2) : 0;
        const status = percentage >= 50 ? 'PASS' : 'FAIL';
        html += `
            <tr>
                <td>${result.studentId || '-'}</td>
                <td>${result.studentName || '-'}</td>
                <td>${result.quizTitle || '-'}</td>
                <td>${result.score || 0}</td>
                <td>${result.totalMarks || 0}</td>
                <td>${percentage}%</td>
                <td><span class="badge ${status.toLowerCase()}">${status}</span></td>
                <td>${result.attemptDate || '-'}</td>
            </tr>
        `;
    });

    html += '</tbody></table>';
    container.innerHTML = html;
}

function teacherDisplayAllResults(results) {
    const container = document.getElementById('allResultsContainer');
    
    if (!results || results.length === 0) {
        container.innerHTML = '<p>No results available</p>';
        return;
    }

    let html = `
        <table class="data-table">
            <thead>
                <tr>
                    <th>Student ID</th>
                    <th>Student Name</th>
                    <th>Quiz Title</th>
                    <th>Score</th>
                    <th>Total Marks</th>
                    <th>Percentage</th>
                    <th>Status</th>
                    <th>Attempt Date</th>
                </tr>
            </thead>
            <tbody>
    `;

    results.forEach(result => {
        const percentage = result.totalMarks > 0 ? ((result.score / result.totalMarks) * 100).toFixed(2) : 0;
        const status = percentage >= 50 ? 'PASS' : 'FAIL';
        html += `
            <tr>
                <td>${result.studentId || '-'}</td>
                <td>${result.studentName || '-'}</td>
                <td>${result.quizTitle || '-'}</td>
                <td>${result.score || 0}</td>
                <td>${result.totalMarks || 0}</td>
                <td>${percentage}%</td>
                <td><span class="badge ${status.toLowerCase()}">${status}</span></td>
                <td>${result.attemptDate || '-'}</td>
            </tr>
        `;
    });

    html += '</tbody></table>';
    container.innerHTML = html;
}

// ===== Student Functions =====
let studentQuizzes = [];
let quizQuestions = [];
let currentQuestionIndex = 0;
let studentAnswers = {};

async function loadStudentData() {
    console.log('Loading student data for user:', currentUser.id);
    
    try {
        // Load student profile
        console.log('Fetching profile from:', `${API_BASE}/student/profile?studentId=${currentUser.id}`);
        const profileResponse = await fetch(`${API_BASE}/student/profile?studentId=${currentUser.id}`);
        console.log('Profile response status:', profileResponse.status);
        const profile = await profileResponse.json();
        console.log('Profile data received:', profile);
        displayStudentProfile(profile);
        
        // Load quizzes
        console.log('Fetching quizzes from:', `${API_BASE}/quizzes?studentId=${currentUser.id}`);
        const quizzesResponse = await fetch(`${API_BASE}/quizzes?studentId=${currentUser.id}`);
        console.log('Quizzes response status:', quizzesResponse.status);
        const quizzes = await quizzesResponse.json();
        console.log('Quizzes data received:', quizzes);
        studentQuizzes = quizzes;
        loadStudentQuizzes(quizzes);
        loadQuizSelectOptions(quizzes);
        
        // Load scores
        console.log('Fetching scores from:', `${API_BASE}/student/scores?studentId=${currentUser.id}`);
        const scoresResponse = await fetch(`${API_BASE}/student/scores?studentId=${currentUser.id}`);
        console.log('Scores response status:', scoresResponse.status);
        const scores = await scoresResponse.json();
        console.log('Scores data received:', scores);
        loadStudentScores(scores);
        
        // Show profile section by default
        showStudentSection('profile');
    } catch (error) {
        console.error('Error loading student data:', error);
        alert('Error loading student data. Check console for details.');
    }
}

function displayStudentProfile(profile) {
    if (profile.error) {
        console.log('Profile error:', profile.error);
        document.getElementById('profileStudentId').textContent = 'Error: ' + profile.error;
        return;
    }
    
    console.log('Displaying profile:', profile);
    document.getElementById('profileStudentId').textContent = profile.id || '-';
    document.getElementById('profileName').textContent = profile.name || '-';
    document.getElementById('profileEmail').textContent = profile.email || '-';
    document.getElementById('profileRollNo').textContent = profile.rollNo || '-';
    document.getElementById('profileSection').textContent = profile.section || '-';
}

async function loadStudentQuizzes(quizzes) {
    const quizList = document.getElementById('quizList');
    if (quizzes.length === 0) {
        quizList.innerHTML = '<p>No quizzes available for your section</p>';
        return;
    }

    quizList.innerHTML = quizzes.map(q => `
        <div class="quiz-card">
            <h3>${q.title}</h3>
            <p>Subject: ${q.subjectId}</p>
            <p class="quiz-info">Go to <strong>"Attempt Quiz"</strong> option to start this quiz.</p>
        </div>
    `).join('');
}

function loadQuizSelectOptions(quizzes) {
    const select = document.getElementById('quizSelect');
    if (!quizzes || quizzes.length === 0) {
        select.innerHTML = '<option value="">No quizzes available</option>';
        return;
    }
    select.innerHTML = '<option value="">-- Select a quiz --</option>' + 
        quizzes.map(q => `<option value="${q.id}">${q.title}</option>`).join('');
    console.log('Quiz options loaded:', quizzes.length);
}

function onQuizSelected() {
    console.log('Quiz selected, current quizzes:', studentQuizzes);
    const quizId = document.getElementById('quizSelect').value;
    const infoBox = document.getElementById('attemptQuizInfo');
    const startBtn = document.getElementById('startQuizBtn');

    console.log('Selected quiz ID:', quizId);

    if (!quizId) {
        infoBox.style.display = 'none';
        startBtn.disabled = true;
        startBtn.style.backgroundColor = '#ccc';
        startBtn.style.color = '#666';
        startBtn.style.borderColor = '#999';
        startBtn.style.cursor = 'not-allowed';
        return;
    }

    const quiz = studentQuizzes.find(q => q.id == quizId);
    console.log('Found quiz:', quiz);

    if (quiz) {
        document.getElementById('attemptQuizTitle').textContent = quiz.title;
        document.getElementById('attemptQuizInfo').textContent = `Click "Start Quiz" to begin your attempt.`;

        // Show container and enable button
        infoBox.style.display = 'block';
        infoBox.style.visibility = 'visible';
        startBtn.disabled = false;
        startBtn.style.backgroundColor = '#27ae60';
        startBtn.style.color = 'white';
        startBtn.style.borderColor = '#1e8449';
        startBtn.style.cursor = 'pointer';

        console.log('✅ Quiz info displayed with START QUIZ button enabled');
    } else {
        console.error('Quiz not found in studentQuizzes array');
        infoBox.style.display = 'none';
        startBtn.disabled = true;
        startBtn.style.backgroundColor = '#ccc';
        startBtn.style.color = '#666';
        startBtn.style.borderColor = '#999';
        startBtn.style.cursor = 'not-allowed';
    }
}

function startAttemptQuiz() {
    const quizId = document.getElementById('quizSelect').value;
    if (!quizId) {
        alert('Please select a quiz first');
        return;
    }
    const quiz = studentQuizzes.find(q => q.id == quizId);
    if (quiz) {
        attemptQuizDirect(quizId, quiz.title);
    }
}

async function attemptQuizDirect(quizId, quizTitle) {
    console.log('=== Attempting Quiz ===');
    console.log('Quiz ID:', quizId);
    console.log('Quiz Title:', quizTitle);
    
    currentQuizId = quizId;
    currentQuestionIndex = 0;
    quizQuestions = [];
    studentAnswers = {};
    
    const modal = document.getElementById('quizModal');
    const title = document.getElementById('quizTitle');
    
    title.textContent = quizTitle;
    
    try {
        console.log('Fetching questions from:', `${API_BASE}/questions?quizId=${quizId}`);
        const questionsResponse = await fetch(`${API_BASE}/questions?quizId=${quizId}`);
        console.log('Questions response status:', questionsResponse.status);
        
        const questions = await questionsResponse.json();
        console.log('Loaded questions:', questions);
        console.log('Number of questions:', questions.length);
        
        if (!questions || questions.length === 0) {
            alert('No questions found for this quiz');
            return;
        }
        
        quizQuestions = questions;
        
        // Display the first question
        displayCurrentQuestion();
        updateQuestionCounter();
        updateNavigationButtons();
        
        modal.classList.remove('hidden');
        console.log('Modal displayed');
    } catch (error) {
        console.error('Error loading quiz questions:', error);
        alert('Error loading quiz questions: ' + error.message);
    }
}

function displayCurrentQuestion() {
    if (currentQuestionIndex >= quizQuestions.length) {
        console.error('Question index out of bounds');
        return;
    }
    
    const q = quizQuestions[currentQuestionIndex];
    console.log('Displaying question:', q);
    
    // Update question text
    document.getElementById('questionText').textContent = `Q${currentQuestionIndex + 1}: ${q.text}`;
    
    // Generate options
    const optionsContainer = document.getElementById('optionsContainer');
    const options = [
        { key: 'A', text: q.optionA },
        { key: 'B', text: q.optionB },
        { key: 'C', text: q.optionC },
        { key: 'D', text: q.optionD }
    ];
    
    optionsContainer.innerHTML = options.map(opt => {
        const answerId = `question_${q.id}_${opt.key}`;
        const isSelected = studentAnswers[`question_${q.id}`] === opt.key;
        
        return `
            <label class="option-label">
                <input type="radio" 
                       name="question_${q.id}" 
                       value="${opt.key}" 
                       ${isSelected ? 'checked' : ''}
                       onchange="recordAnswer('question_${q.id}', '${opt.key}')">
                <span class="option-text">${opt.key}) ${opt.text}</span>
            </label>
        `;
    }).join('');
}

function recordAnswer(questionId, answer) {
    studentAnswers[questionId] = answer;
    console.log('Answer recorded:', questionId, '=', answer);
}

function updateQuestionCounter() {
    const total = quizQuestions.length;
    const current = currentQuestionIndex + 1;
    document.getElementById('questionCounter').textContent = `Question ${current} of ${total}`;
    
    // Update progress bar
    const percentage = (current / total) * 100;
    document.getElementById('progressFill').style.width = percentage + '%';
}

function updateNavigationButtons() {
    const total = quizQuestions.length;
    const isFirst = currentQuestionIndex === 0;
    const isLast = currentQuestionIndex === total - 1;

    const submitBtn = document.getElementById('submitBtn');

    document.getElementById('prevBtn').style.display = isFirst ? 'none' : 'block';
    document.getElementById('nextBtn').style.display = isLast ? 'none' : 'block';

    // Always show submit button - students can submit at any time
    submitBtn.style.display = 'block';
    submitBtn.style.visibility = 'visible';
    submitBtn.style.opacity = '1';
    submitBtn.disabled = false;
    console.log('✅ SUBMIT BUTTON ALWAYS VISIBLE - Can submit at any time');
}

function previousQuestion() {
    if (currentQuestionIndex > 0) {
        currentQuestionIndex--;
        displayCurrentQuestion();
        updateQuestionCounter();
        updateNavigationButtons();
        console.log('Moved to previous question:', currentQuestionIndex + 1);
    }
}

function nextQuestion() {
    if (currentQuestionIndex < quizQuestions.length - 1) {
        currentQuestionIndex++;
        displayCurrentQuestion();
        updateQuestionCounter();
        updateNavigationButtons();
        console.log('Moved to next question:', currentQuestionIndex + 1);
    }
}

function closeQuizModal() {
    document.getElementById('quizModal').classList.add('hidden');
    document.getElementById('quizForm').reset();
}

document.getElementById('quizForm').addEventListener('submit', async (e) => {
    e.preventDefault();
    await submitQuiz();
});

async function submitQuiz() {
    console.log('🔴🔴🔴 === QUIZ SUBMIT FUNCTION CALLED ===');
    console.log('Current Quiz ID:', currentQuizId);
    console.log('Current User ID:', currentUser.id);
    console.log('Total Answers:', Object.keys(studentAnswers).length);
    console.log('studentAnswers:', studentAnswers);

    // Validate that answers were collected
    if (Object.keys(studentAnswers).length === 0) {
        alert('Please answer at least one question before submitting!');
        return;
    }

    try {
        const payload = {
            quizId: parseInt(currentQuizId),
            studentId: parseInt(currentUser.id),
            answers: studentAnswers
        };

        console.log('Sending payload:', JSON.stringify(payload));

        const response = await fetch(`${API_BASE}/submit-quiz`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(payload)
        });

        console.log('Response status:', response.status);

        const data = await response.json();
        console.log('Response data:', data);

        if (data.success) {
            // Show score results modal
            const percentage = ((data.score / data.totalMarks) * 100).toFixed(2);
            const status = percentage >= 50 ? 'PASSED ✓' : 'FAILED ✗';
            const statusColor = percentage >= 50 ? 'pass' : 'fail';

            document.getElementById('scorePercentage').textContent = percentage + '%';
            document.getElementById('scoreValue').textContent = data.score;
            document.getElementById('totalMarksValue').textContent = data.totalMarks;
            document.getElementById('percentageValue').textContent = percentage;
            document.getElementById('statusMessage').textContent = 'You ' + status;
            document.getElementById('statusMessage').className = 'status-msg ' + statusColor;

            // Show score modal, hide quiz modal
            closeQuizModal();
            document.getElementById('scoreModal').classList.remove('hidden');

            console.log('Score displayed successfully');
        } else {
            console.error('API returned error:', data);
            alert('Error: ' + (data.message || data.error || 'Unknown error'));
        }
    } catch (error) {
        console.error('Network/Parse error:', error);
        alert('Error submitting quiz: ' + error.message);
    }
}

function closeScoreModal() {
    document.getElementById('scoreModal').classList.add('hidden');
    loadStudentData();
    showStudentSection('scores');
}

function loadStudentScores(scores) {
    const tbody = document.getElementById('resultTable');
    
    if (!scores || scores.length === 0) {
        tbody.innerHTML = '<tr><td colspan="6">No quiz attempts yet.</td></tr>';
        return;
    }
    
    tbody.innerHTML = scores.map(score => {
        const percentage = score.totalMarks > 0 ? ((score.score / score.totalMarks) * 100).toFixed(2) : 0;
        const status = score.status || (percentage >= 50 ? 'PASS' : 'FAIL');
        return `
            <tr>
                <td>${score.quizTitle || 'Unknown Quiz'}</td>
                <td>${score.score}</td>
                <td>${score.totalMarks}</td>
                <td>${percentage}%</td>
                <td><span class="badge ${status.toLowerCase()}">${status}</span></td>
                <td>${score.attemptDate || '-'}</td>
            </tr>
        `;
    }).join('');
}

function showStudentSection(section) {
    console.log('Showing student section:', section);
    
    const sectionMap = {
        'profile': 'student-profile',
        'quizzes': 'student-quizzes',
        'attempt': 'student-attempt',
        'scores': 'student-scores'
    };
    
    // Hide all sections
    document.querySelectorAll('#studentDashboard .section').forEach(s => {
        s.classList.remove('active');
        console.log('Hidden section:', s.id);
    });
    
    // Show selected section
    const sectionElement = document.getElementById(sectionMap[section]);
    if (sectionElement) {
        sectionElement.classList.add('active');
        console.log('Showed section:', sectionElement.id);
        
        // Refresh quiz dropdown when attempt section is shown
        if (section === 'attempt' && studentQuizzes.length > 0) {
            loadQuizSelectOptions(studentQuizzes);
        }
    } else {
        console.error('Section not found:', sectionMap[section]);
    }
    
    // Update button styles
    document.querySelectorAll('#studentDashboard .menu-btn').forEach(btn => {
        btn.classList.remove('active');
    });
    
    // Find and activate the clicked button
    const buttons = document.querySelectorAll('#studentDashboard .menu-btn');
    buttons.forEach((btn, index) => {
        const sectionNames = ['profile', 'quizzes', 'attempt', 'scores', 'logout'];
        if (sectionNames[index] === section) {
            btn.classList.add('active');
            console.log('Activated button:', index);
        }
    });
}

// ===== Logout Handler =====
function logout() {
    currentUser = null;
    currentRole = null;
    
    document.querySelectorAll('.dashboard').forEach(d => d.classList.add('hidden'));
    document.querySelector('.login-container').style.display = 'flex';
    
    document.getElementById('loginForm').reset();
    document.getElementById('errorMsg').textContent = '';
}

// Ensure localStorage auth keys are removed when logging out (so standalone pages won't allow access).
function clearLocalAuth() {
    try {
        localStorage.removeItem('userId');
        localStorage.removeItem('role');
        localStorage.removeItem('name');
    } catch (e) {
        console.warn('localStorage clear failed:', e);
    }
}

// Hook into existing logout UI: also clear localStorage
const originalLogout = logout;
logout = function() {
    clearLocalAuth();
    originalLogout();
};

// ===== Create Quiz Handler =====
document.addEventListener('DOMContentLoaded', function() {
    const createQuizForm = document.getElementById('createQuizForm');
    if (createQuizForm) {
        createQuizForm.addEventListener('submit', async (e) => {
            e.preventDefault();
            
            const section = document.getElementById('teacherQuizSection').value;
            const subject = document.getElementById('teacherQuizSubject').value;
            const title = document.getElementById('teacherQuizTitle').value;
            const numQuestions = document.getElementById('teacherNumQuestions').value;

            if (!section || !subject || !title) {
                alert('Please fill in all fields');
                return;
            }

            try {
                const response = await fetch(`${API_BASE}/quiz/create`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        title: title,
                        sectionId: section,
                        subjectId: subject,
                        teacherId: currentUser.id,
                        numQuestions: numQuestions
                    })
                });

                const data = await response.json();

                const messageDiv = document.getElementById('createQuizMessage');
                if (data.success) {
                    messageDiv.textContent = 'Quiz created successfully!';
                    messageDiv.style.color = '#27ae60';
                    createQuizForm.reset();
                    setTimeout(() => {
                        showTeacherSection('quizzes');
                        loadTeacherData();
                    }, 1500);
                } else {
                    messageDiv.textContent = 'Error: ' + (data.message || 'Failed to create quiz');
                    messageDiv.style.color = '#e74c3c';
                }
            } catch (error) {
                console.error('Error creating quiz:', error);
                document.getElementById('createQuizMessage').textContent = 'Error: ' + error.message;
                document.getElementById('createQuizMessage').style.color = '#e74c3c';
            }
        });
    }
});

// ===== Helper Functions =====
function viewQuizDetails(quizId) {
    alert('Quiz Details: ID ' + quizId);
}
