// Safe API URL accessor - prefer centralized `API_BASE_URL` on window to avoid duplicates
function getApiUrl() {
    if (typeof window !== 'undefined') {
        if (window.API_BASE_URL) return window.API_BASE_URL;
        if (window.API_URL) return window.API_URL;
    }
    return 'http://localhost:8080/api';
}

// Initialize when page loads
document.addEventListener('DOMContentLoaded', () => {
    // Check if user is logged in
    const userId = localStorage.getItem('userId');
    const role = localStorage.getItem('role');
    const name = localStorage.getItem('name');

    if (!userId || role !== 'TEACHER') {
        window.location.href = 'index.html';
        return;
    }

    // Display teacher name in sidebar
    document.getElementById('teacherName').textContent = `Welcome, ${name}`;

    // Load initial data
    loadTeacherProfile();
    loadSections();
    loadSubjects();
    loadMyQuizzes();
    loadAllResults();

    // Setup edit profile form listener
    const editForm = document.getElementById('editProfileForm');
    if (editForm) {
        editForm.addEventListener('submit', handleEditProfileSubmit);
    }

    // Close modal when clicking outside
    const modal = document.getElementById('editProfileModal');
    if (modal) {
        window.addEventListener('click', (e) => {
            if (e.target === modal) {
                closeEditProfile();
            }
        });
    }

    // Setup create quiz form listener
    const createQuizForm = document.getElementById('createQuizForm');
    if (createQuizForm) {
        createQuizForm.addEventListener('submit', handleCreateQuizSubmit);
    }
});

// ============= PROFILE SECTION =============
async function loadTeacherProfile() {
    const userId = localStorage.getItem('userId');
    
    console.log('Loading profile for userId:', userId);
    
    try {
        const url = `${getApiUrl()}/teacher/profile?teacherId=${userId}`;
        console.log('Fetching from:', url);
        
        const response = await fetch(url);
        console.log('Response status:', response.status);
        console.log('Response headers:', response.headers);
        
        const text = await response.text();
        console.log('Response text:', text);
        
        const profile = JSON.parse(text);
        console.log('Parsed profile:', profile);

        if (profile.id || profile.teacherId) {
            const profileHTML = `
                <p><strong>👤 Teacher ID:</strong> ${profile.id || profile.teacherId}</p>
                <p><strong>📝 Name:</strong> ${profile.name}</p>
                <p><strong>📧 Email:</strong> ${profile.email}</p>
            `;
            document.getElementById('profileInfo').innerHTML = profileHTML;
        } else if (profile.error) {
            document.getElementById('profileInfo').innerHTML = `<p style="color: red;">❌ Error: ${profile.error}</p>`;
        } else {
            document.getElementById('profileInfo').innerHTML = '<p style="color: red;">❌ Error: Invalid response format</p>';
        }
    } catch (error) {
        console.error('Error loading profile:', error);
        document.getElementById('profileInfo').innerHTML = `<p style="color: red;">❌ Error: ${error.message}</p>`;
    }
}

function showEditProfile() {
    const userId = localStorage.getItem('userId');
    
    // Load current profile data
    fetch(`${getApiUrl()}/teacher/profile?teacherId=${userId}`)
        .then(res => res.json())
        .then(data => {
            if (data.id) {
                document.getElementById('editName').value = data.name;
                document.getElementById('editEmail').value = data.email;
                const modal = document.getElementById('editProfileModal');
                modal.style.display = 'flex';
                modal.classList.remove('hidden');
            }
        })
        .catch(err => {
            console.error('Error loading profile for edit:', err);
            alert('Error loading profile data');
        });
}

function closeEditProfile() {
    const modal = document.getElementById('editProfileModal');
    modal.style.display = 'none';
    modal.classList.add('hidden');
}

function handleEditProfileSubmit(e) {
    e.preventDefault();
    
    const userId = localStorage.getItem('userId');
    const name = document.getElementById('editName').value.trim();
    const email = document.getElementById('editEmail').value.trim();

    if (!name || !email) {
        alert('Please fill in all fields');
        return;
    }

    if (!email.match(/^[^\s@]+@[^\s@]+\.[^\s@]+$/)) {
        alert('Please enter a valid email');
        return;
    }

    fetch(`${getApiUrl()}/teacher/update-profile`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            teacherId: parseInt(userId),
            name: name,
            email: email
        })
    })
    .then(res => res.json())
    .then(data => {
        if (data.success) {
            alert('✓ Profile updated successfully!');
            // Update sidebar name
            localStorage.setItem('name', name);
            document.getElementById('teacherName').textContent = `Welcome, ${name}`;
            // Reload profile
            loadTeacherProfile();
            closeEditProfile();
        } else {
            alert('Error updating profile: ' + data.message);
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('Network error: ' + error.message);
    });
}

// ============= CREATE QUIZ SECTION =============
async function loadSections() {
    try {
        const userId = localStorage.getItem('userId');
        if (!userId) {
            console.error('User ID not found in localStorage');
            return;
        }
        
        const apiUrl = `${getApiUrl()}/teacher/sections?teacherId=${userId}`;
        console.log('Loading teacher sections from:', apiUrl);

        const response = await fetch(apiUrl);
        
        if (!response.ok) {
            const errorText = await response.text();
            throw new Error(`HTTP ${response.status}: ${errorText}`);
        }
        
        const sections = await response.json();
        console.log('Teacher sections loaded:', sections);

        const select = document.getElementById('quizSection');
        if (!select) {
            console.error('quizSection select element not found');
            return;
        }
        
        // clear existing options except the placeholder
        select.querySelectorAll('option:not([value=""])').forEach(o => o.remove());
        
        if (Array.isArray(sections) && sections.length > 0) {
            sections.forEach(section => {
                const option = document.createElement('option');
                option.value = section.id;
                option.textContent = section.name;
                select.appendChild(option);
            });
            console.log(`Successfully loaded ${sections.length} sections`);
        } else {
            console.warn('No sections assigned to teacher');
        }
    } catch (error) {
        console.error('Error loading sections:', error);
    }
}

async function loadSubjects() {
    try {
        const userId = localStorage.getItem('userId');
        if (!userId) {
            console.error('User ID not found in localStorage');
            return;
        }
        
        const apiUrl = `${getApiUrl()}/teacher/subjects?teacherId=${userId}`;
        console.log('Loading teacher subjects from:', apiUrl);

        const response = await fetch(apiUrl);
        
        if (!response.ok) {
            const errorText = await response.text();
            throw new Error(`HTTP ${response.status}: ${errorText}`);
        }
        
        const subjects = await response.json();
        console.log('Teacher subjects loaded:', subjects);

        const select = document.getElementById('quizSubject');
        if (!select) {
            console.error('quizSubject select element not found');
            return;
        }
        
        select.querySelectorAll('option:not([value=""])').forEach(o => o.remove());
        
        if (Array.isArray(subjects) && subjects.length > 0) {
            subjects.forEach(subject => {
                const option = document.createElement('option');
                option.value = subject.id;
                option.textContent = subject.name;
                select.appendChild(option);
            });
            console.log(`Successfully loaded ${subjects.length} subjects`);
        } else {
            console.warn('No subjects assigned to teacher');
        }
    } catch (error) {
        console.error('Error loading subjects:', error);
    }
}

// Handle create quiz form submission
async function handleCreateQuizSubmit(e) {
    e.preventDefault();

    const userId = localStorage.getItem('userId');
    const sectionId = document.getElementById('quizSection').value;
    const subjectId = document.getElementById('quizSubject').value;
    const messageDiv = document.getElementById('createQuizMessage');

    console.log('Creating quiz with:', { userId, sectionId, subjectId });

    if (!userId) {
        messageDiv.className = 'message error';
        messageDiv.textContent = '❌ User ID not found. Please login again.';
        return;
    }

    if (!sectionId || !subjectId) {
        messageDiv.className = 'message error';
        messageDiv.textContent = '❌ Please select both Section and Subject';
        return;
    }

    const titleInput = document.getElementById('quizTitle');
    const numQuestionsInput = document.getElementById('numQuestions');
    const title = titleInput ? titleInput.value.trim() : '';
    const numQuestions = numQuestionsInput ? parseInt(numQuestionsInput.value, 10) : 0;

    if (!title) {
        messageDiv.className = 'message error';
        messageDiv.textContent = '❌ Please enter a quiz title';
        return;
    }

    if (!numQuestions || numQuestions < 1 || numQuestions > 99) {
        messageDiv.className = 'message error';
        messageDiv.textContent = '❌ Please enter a valid number of questions (1-99)';
        return;
    }

    try {
        const apiUrl = `${getApiUrl()}/teacher/create-quiz`;
        console.log('API URL:', apiUrl);
        
        const payload = {
            teacherId: parseInt(userId),
            title: title,
            sectionId: parseInt(sectionId),
            subjectId: parseInt(subjectId),
            numQuestions: numQuestions
        };
        
        console.log('Payload:', payload);
        
        const response = await fetch(apiUrl, {
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
            messageDiv.className = 'message success';
            messageDiv.textContent = `✅ Quiz created successfully! Quiz ID: ${data.quizId}`;
            document.getElementById('createQuizForm').reset();
            setTimeout(() => loadMyQuizzes(), 1000);
        } else {
            messageDiv.className = 'message error';
            messageDiv.textContent = '❌ ' + (data.message || 'Failed to create quiz');
        }
    } catch (error) {
        console.error('Error creating quiz:', error);
        messageDiv.className = 'message error';
        messageDiv.textContent = '❌ Network error: ' + error.message;
    }
}

// ============= VIEW QUIZZES SECTION =============
async function loadMyQuizzes() {
    const userId = localStorage.getItem('userId');

    try {
        const response = await fetch(`${getApiUrl()}/teacher/quizzes?teacherId=${userId}`);
        const quizzes = await response.json();

        const container = document.getElementById('quizzesContainer');

        if (quizzes.length === 0) {
            container.innerHTML = '<p>No quizzes created yet. Create your first quiz!</p>';
            return;
        }

        let html = '';
        quizzes.forEach(quiz => {
            html += `
                <div class="quiz-card">
                    <h3>${quiz.title}</h3>
                    <p><strong>Quiz ID:</strong> ${quiz.quizId}</p>
                    <p><strong>Section:</strong> ${quiz.section}</p>
                    <p><strong>Subject:</strong> ${quiz.subject}</p>
                    <div class="quiz-actions">
                        <button class="btn btn-primary" onclick="editQuiz(${quiz.quizId}, '${quiz.title}')">✏️ Edit</button>
                        <button class="btn btn-danger" onclick="deleteQuiz(${quiz.quizId})">🗑️ Delete</button>
                    </div>
                </div>
            `;
        });

        container.innerHTML = html;
    } catch (error) {
        console.error('Error loading quizzes:', error);
        document.getElementById('quizzesContainer').innerHTML = '<p>Error loading quizzes</p>';
    }
}

function editQuiz(quizId, currentTitle) {
    const newTitle = prompt(`Edit Quiz Title:\n\nCurrent: ${currentTitle}`, currentTitle);

    if (newTitle && newTitle !== currentTitle) {
        fetch(`${getApiUrl()}/teacher/update-quiz`, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                quizId: quizId,
                title: newTitle
            })
        })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                alert('Quiz updated successfully!');
                loadMyQuizzes();
            } else {
                alert('Error updating quiz');
            }
        })
        .catch(error => console.error('Error:', error));
    }
}

function deleteQuiz(quizId) {
    if (confirm('Are you sure you want to delete this quiz? This action cannot be undone.')) {
        fetch(`${getApiUrl()}/teacher/delete-quiz?quizId=${quizId}`, {
            method: 'DELETE'
        })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                alert('Quiz deleted successfully!');
                loadMyQuizzes();
            } else {
                alert('Error deleting quiz');
            }
        })
        .catch(error => console.error('Error:', error));
    }
}

// ============= SEARCH AND SORT RESULTS =============
async function searchResultsByName() {
    const userId = localStorage.getItem('userId');
    const searchValue = document.getElementById('searchNameInput').value.trim();

    if (!searchValue) {
        alert('Please enter a student name');
        return;
    }

    try {
        const response = await fetch(`${getApiUrl()}/teacher/results?teacherId=${userId}&searchType=name&searchValue=${encodeURIComponent(searchValue)}`);
        const results = await response.json();

        displayResults(results, 'searchNameResults');
    } catch (error) {
        console.error('Error:', error);
        document.getElementById('searchNameResults').innerHTML = '<p>Error searching results</p>';
    }
}

async function searchResultsById() {
    const userId = localStorage.getItem('userId');
    const searchValue = document.getElementById('searchIdInput').value.trim();

    if (!searchValue) {
        alert('Please enter a student ID');
        return;
    }

    try {
        const response = await fetch(`${getApiUrl()}/teacher/results?teacherId=${userId}&searchType=id&searchValue=${encodeURIComponent(searchValue)}`);
        const results = await response.json();

        displayResults(results, 'searchIdResults');
    } catch (error) {
        console.error('Error:', error);
        document.getElementById('searchIdResults').innerHTML = '<p>Error searching results</p>';
    }
}

let currentSortBy = 'id';

async function sortResults(sortBy) {
    const userId = localStorage.getItem('userId');
    currentSortBy = sortBy;

    try {
        const response = await fetch(`${getApiUrl()}/teacher/results?teacherId=${userId}&sortBy=${sortBy}`);
        const results = await response.json();

        displayResults(results, 'allResultsContainer');
    } catch (error) {
        console.error('Error:', error);
        document.getElementById('allResultsContainer').innerHTML = '<p>Error loading results</p>';
    }
}

async function loadAllResults() {
    const userId = localStorage.getItem('userId');

    try {
        const response = await fetch(`${getApiUrl()}/teacher/results?teacherId=${userId}`);
        const results = await response.json();

        displayResults(results, 'allResultsContainer');
    } catch (error) {
        console.error('Error:', error);
        document.getElementById('allResultsContainer').innerHTML = '<p>Error loading results</p>';
    }
}

function displayResults(results, containerId) {
    const container = document.getElementById(containerId);

    if (!results || results.length === 0) {
        container.innerHTML = '<p>No results found</p>';
        return;
    }

    let html = `
        <table class="results-table">
            <thead>
                <tr>
                    <th>Student Name</th>
                    <th>Roll No</th>
                    <th>Quiz Title</th>
                    <th>Score</th>
                    <th>Total</th>
                    <th>Percentage</th>
                    <th>Status</th>
                    <th>Date</th>
                </tr>
            </thead>
            <tbody>
    `;

    results.forEach(result => {
        const percentage = result.totalMarks > 0 ? ((result.score / result.totalMarks) * 100).toFixed(2) : 0;
        const statusClass = result.status === 'PASS' ? 'pass' : result.status === 'FAIL' ? 'fail' : 'pending';
        
        html += `
            <tr>
                <td>${result.studentName}</td>
                <td>${result.rollNo}</td>
                <td>${result.quizTitle}</td>
                <td>${result.score}</td>
                <td>${result.totalMarks}</td>
                <td>${percentage}%</td>
                <td><span class="status ${statusClass}">${result.status || 'N/A'}</span></td>
                <td>${new Date(result.attemptDate).toLocaleDateString()}</td>
            </tr>
        `;
    });

    html += `
            </tbody>
        </table>
    `;

    container.innerHTML = html;
}

// ============= NAVIGATION =============
function showSection(sectionId, event) {
    if (event) {
        event.preventDefault();
    }

    // Hide all sections
    document.querySelectorAll('.content-section').forEach(section => {
        section.classList.remove('active');
    });

    // Remove active class from all nav links
    document.querySelectorAll('.nav-link').forEach(link => {
        link.classList.remove('active');
    });

    // Show selected section
    const section = document.getElementById(sectionId);
    if (section) {
        section.classList.add('active');
    }

    // Add active class to clicked nav link
    if (event && event.target) {
        event.target.classList.add('active');
    }

    // Reload data for specific sections
    if (sectionId === 'my-quizzes') {
        loadMyQuizzes();
    } else if (sectionId === 'all-results') {
        loadAllResults();
    }
}

// ============= LOGOUT =============
function logout(event) {
    if (event) {
        event.preventDefault();
    }

    if (confirm('Are you sure you want to logout?')) {
        localStorage.removeItem('userId');
        localStorage.removeItem('role');
        localStorage.removeItem('name');
        window.location.href = 'index.html';
    }
}

// CSS for status badges
const styleSheet = document.createElement('style');
styleSheet.textContent = `
    .status {
        padding: 5px 10px;
        border-radius: 4px;
        font-weight: 600;
        font-size: 12px;
    }

    .status.pass {
        background-color: #d4edda;
        color: #155724;
    }

    .status.fail {
        background-color: #f8d7da;
        color: #721c24;
    }

    .status.pending {
        background-color: #fff3cd;
        color: #856404;
    }
`;
document.head.appendChild(styleSheet);
