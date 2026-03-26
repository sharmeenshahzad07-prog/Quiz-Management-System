// ===== Constants =====
const API_BASE_URL = 'http://localhost:8080/api';
let adminName = localStorage.getItem('name') || 'Admin';

// ===== Initialization =====
document.addEventListener('DOMContentLoaded', function() {
    document.getElementById('adminName').textContent = adminName;
    loadDashboardStats();
    loadTeachersDropdown();
    loadSectionsDropdown();
    loadSubjectsDropdown();
    loadStudentsDropdown();
    loadAllTeachers();
    loadAllStudents();
    loadSectionsTable();
    loadSubjectsTable();
});

// ===== Navigation Functions =====
function showSection(sectionId, event) {
    if (event) event.preventDefault();
    
    // Hide all sections
    const sections = document.querySelectorAll('.content-section');
    sections.forEach(section => section.classList.remove('active'));
    
    // Remove active class from all nav links
    const navLinks = document.querySelectorAll('.nav-link');
    navLinks.forEach(link => link.classList.remove('active'));
    
    // Show selected section
    const selectedSection = document.getElementById(sectionId);
    if (selectedSection) {
        selectedSection.classList.add('active');
    }
    
    // Add active class to clicked link
    if (event && event.target) {
        event.target.classList.add('active');
    }
}

function toggleSubmenu(submenuId, event) {
    if (event) event.preventDefault();
    
    const submenu = document.getElementById(submenuId + '-submenu');
    if (submenu) {
        submenu.classList.toggle('active');
        
        // Toggle the arrow icon or styling
        const link = event.target;
        link.classList.toggle('active');
    }
}

// ===== Dashboard Stats =====
function loadDashboardStats() {
    // Fetch stats from server
    fetch(`${API_BASE_URL}/admin/stats`)
        .then(response => response.json())
        .then(data => {
            document.getElementById('teacherCount').textContent = data.teacherCount || 0;
            document.getElementById('studentCount').textContent = data.studentCount || 0;
            document.getElementById('sectionCount').textContent = data.sectionCount || 0;
            document.getElementById('subjectCount').textContent = data.subjectCount || 0;
        })
        .catch(error => {
            console.error('Error loading dashboard stats:', error);
            document.getElementById('teacherCount').textContent = 'N/A';
            document.getElementById('studentCount').textContent = 'N/A';
            document.getElementById('sectionCount').textContent = 'N/A';
            document.getElementById('subjectCount').textContent = 'N/A';
        });
}

// ===== TEACHER FUNCTIONS =====

// Load teachers for dropdowns
function loadTeachersDropdown() {
    fetch(`${API_BASE_URL}/teachers`)
        .then(response => response.json())
        .then(data => {
            const selectElements = [
                'assignTeacherId',
                'assignSubjectTeacherId'
            ];
            
            selectElements.forEach(elementId => {
                const select = document.getElementById(elementId);
                if (select) {
                    select.innerHTML = '<option value="">-- Select Teacher --</option>';
                    data.forEach(teacher => {
                        const option = document.createElement('option');
                        option.value = teacher.id;
                        option.textContent = `${teacher.name} (ID: ${teacher.id})`;
                        select.appendChild(option);
                    });
                }
            });
        })
        .catch(error => console.error('Error loading teachers:', error));
}

// View Teacher Profile
function viewTeacherProfile() {
    const teacherId = document.getElementById('viewTeacherId').value;
    
    if (!teacherId) {
        showMessage('Please enter a Teacher ID', 'error', 'profileInfo');
        return;
    }
    
    fetch(`${API_BASE_URL}/teachers/${teacherId}`)
        .then(response => response.json())
        .then(data => {
            const profileDiv = document.getElementById('teacherProfileInfo');
            let sectionsHtml = 'None';
            let subjectsHtml = 'None';
            
            if (data.sections && data.sections.length > 0) {
                sectionsHtml = data.sections.map(s => `<li>${s.name}</li>`).join('');
                sectionsHtml = `<ul>${sectionsHtml}</ul>`;
            }
            
            if (data.subjects && data.subjects.length > 0) {
                subjectsHtml = data.subjects.map(s => `<li>${s.name}</li>`).join('');
                subjectsHtml = `<ul>${subjectsHtml}</ul>`;
            }
            
            profileDiv.innerHTML = `
                <p><strong>Teacher ID:</strong> ${data.id}</p>
                <p><strong>Name:</strong> ${data.name}</p>
                <p><strong>Email:</strong> ${data.email}</p>
                <p><strong>Assigned Sections:</strong></p>
                ${sectionsHtml}
                <p><strong>Assigned Subjects:</strong></p>
                ${subjectsHtml}
            `;
            profileDiv.style.display = 'block';
        })
        .catch(error => {
            console.error('Error:', error);
            showMessage('Teacher not found', 'error', 'profileInfo');
        });
}

// Load Teacher for Edit
function loadTeacherForEdit() {
    const teacherId = document.getElementById('editTeacherId').value;
    
    if (!teacherId) {
        showMessage('Please enter a Teacher ID', 'error');
        return;
    }
    
    fetch(`${API_BASE_URL}/teachers/${teacherId}`)
        .then(response => response.json())
        .then(data => {
            document.getElementById('editTeacherName').value = data.name;
            document.getElementById('editTeacherEmail').value = data.email;
            document.getElementById('editTeacherForm').style.display = 'block';
        })
        .catch(error => {
            console.error('Error:', error);
            showMessage('Teacher not found', 'error');
        });
}

// Edit Teacher Form
document.addEventListener('DOMContentLoaded', function() {
    const editTeacherForm = document.getElementById('editTeacherForm');
    if (editTeacherForm) {
        editTeacherForm.addEventListener('submit', function(e) {
            e.preventDefault();
            const teacherId = document.getElementById('editTeacherId').value;
            const data = {
                name: document.getElementById('editTeacherName').value,
                email: document.getElementById('editTeacherEmail').value
            };
            
            fetch(`${API_BASE_URL}/teachers/${teacherId}`, {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(data)
            })
            .then(response => response.json())
            .then(data => {
                showMessage('Teacher updated successfully', 'success');
                loadTeachersDropdown();
                loadAllTeachers();
            })
            .catch(error => {
                console.error('Error:', error);
                showMessage('Error updating teacher', 'error');
            });
        });
    }
});

// Add Teacher Form
document.addEventListener('DOMContentLoaded', function() {
    const addTeacherForm = document.getElementById('addTeacherForm');
    if (addTeacherForm) {
        addTeacherForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            const newTeacherId = document.getElementById('newTeacherId').value.trim();
            const newTeacherName = document.getElementById('newTeacherName').value.trim();
            const newTeacherEmail = document.getElementById('newTeacherEmail').value.trim();
            const newTeacherPassword = document.getElementById('newTeacherPassword').value.trim();
            
            if (!newTeacherId || !newTeacherName || !newTeacherEmail || !newTeacherPassword) {
                showMessage('All fields are required', 'error', 'addTeacherMessage');
                return;
            }
            
            const data = {
                id: parseInt(newTeacherId),
                name: newTeacherName,
                email: newTeacherEmail,
                password: newTeacherPassword
            };
            
            showMessage('Adding teacher...', 'info', 'addTeacherMessage');
            
            fetch(`${API_BASE_URL}/teachers`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(data)
            })
            .then(response => {
                if (!response.ok) {
                    return response.text().then(text => {
                        throw new Error(`HTTP ${response.status}: ${text}`);
                    });
                }
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    showMessage('✓ Teacher added successfully!', 'success', 'addTeacherMessage');
                    addTeacherForm.reset();
                    setTimeout(() => {
                        loadTeachersDropdown();
                        loadAllTeachers();
                    }, 500);
                } else {
                    showMessage('Error: ' + (data.message || 'Failed to add teacher'), 'error', 'addTeacherMessage');
                }
            })
            .catch(error => {
                console.error('Error adding teacher:', error);
                showMessage('Error: ' + error.message, 'error', 'addTeacherMessage');
            });
        });
    }
});

// Remove Teacher
function removeTeacher() {
    const teacherId = document.getElementById('removeTeacherId').value;
    
    if (!teacherId) {
        showMessage('Please enter a Teacher ID', 'error', 'removeTeacherMessage');
        return;
    }
    
    if (!confirm('Are you sure you want to remove this teacher?')) return;
    
    fetch(`${API_BASE_URL}/teachers/${teacherId}`, {
        method: 'DELETE'
    })
    .then(response => response.json())
    .then(data => {
        showMessage('Teacher removed successfully', 'success', 'removeTeacherMessage');
        document.getElementById('removeTeacherId').value = '';
        loadTeachersDropdown();
        loadAllTeachers();
    })
    .catch(error => {
        console.error('Error:', error);
        showMessage('Error removing teacher', 'error', 'removeTeacherMessage');
    });
}

// Assign Section to Teacher
function assignSectionToTeacher() {
    const teacherId = document.getElementById('assignTeacherId').value;
    const sectionId = document.getElementById('assignSectionId').value;
    
    if (!teacherId || !sectionId) {
        showMessage('Please select both teacher and section', 'error', 'assignSectionMessage');
        return;
    }
    
    const data = {
        teacherId: parseInt(teacherId),
        sectionId: parseInt(sectionId)
    };
    
    fetch(`${API_BASE_URL}/admin/assign-section`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data)
    })
    .then(response => response.json())
    .then(data => {
        showMessage('Section assigned successfully', 'success', 'assignSectionMessage');
        document.getElementById('assignTeacherId').value = '';
        document.getElementById('assignSectionId').value = '';
    })
    .catch(error => {
        console.error('Error:', error);
        showMessage('Error assigning section', 'error', 'assignSectionMessage');
    });
}

// Remove Section from Teacher
function removeSectionFromTeacher() {
    const teacherId = document.getElementById('assignTeacherId').value;
    const sectionId = document.getElementById('assignSectionId').value;
    
    if (!teacherId || !sectionId) {
        showMessage('Please select both teacher and section', 'error', 'assignSectionMessage');
        return;
    }
    
    const data = {
        teacherId: parseInt(teacherId),
        sectionId: parseInt(sectionId)
    };
    
    fetch(`${API_BASE_URL}/admin/remove-section`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data)
    })
    .then(response => response.json())
    .then(data => {
        showMessage('Section removed successfully', 'success', 'assignSectionMessage');
        document.getElementById('assignTeacherId').value = '';
        document.getElementById('assignSectionId').value = '';
    })
    .catch(error => {
        console.error('Error:', error);
        showMessage('Error removing section', 'error', 'assignSectionMessage');
    });
}

// Assign Subject to Teacher
function assignSubjectToTeacher() {
    const teacherId = document.getElementById('assignSubjectTeacherId').value;
    const subjectId = document.getElementById('assignSubjectId').value;
    
    if (!teacherId || !subjectId) {
        showMessage('Please select both teacher and subject', 'error', 'assignSubjectMessage');
        return;
    }
    
    const data = {
        teacherId: parseInt(teacherId),
        subjectId: parseInt(subjectId)
    };
    
    fetch(`${API_BASE_URL}/admin/assign-subject`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data)
    })
    .then(response => response.json())
    .then(data => {
        showMessage('Subject assigned successfully', 'success', 'assignSubjectMessage');
        document.getElementById('assignSubjectTeacherId').value = '';
        document.getElementById('assignSubjectId').value = '';
    })
    .catch(error => {
        console.error('Error:', error);
        showMessage('Error assigning subject', 'error', 'assignSubjectMessage');
    });
}

// Remove Subject from Teacher
function removeSubjectFromTeacher() {
    const teacherId = document.getElementById('assignSubjectTeacherId').value;
    const subjectId = document.getElementById('assignSubjectId').value;
    
    if (!teacherId || !subjectId) {
        showMessage('Please select both teacher and subject', 'error', 'assignSubjectMessage');
        return;
    }
    
    const data = {
        teacherId: parseInt(teacherId),
        subjectId: parseInt(subjectId)
    };
    
    fetch(`${API_BASE_URL}/admin/remove-subject`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data)
    })
    .then(response => response.json())
    .then(data => {
        showMessage('Subject removed successfully', 'success', 'assignSubjectMessage');
        document.getElementById('assignSubjectTeacherId').value = '';
        document.getElementById('assignSubjectId').value = '';
    })
    .catch(error => {
        console.error('Error:', error);
        showMessage('Error removing subject', 'error', 'assignSubjectMessage');
    });
}

// Load All Teachers
function loadAllTeachers() {
    fetch(`${API_BASE_URL}/teachers`)
        .then(response => response.json())
        .then(data => {
            const tbody = document.getElementById('allTeacherTable');
            tbody.innerHTML = '';
            
            if (data.length === 0) {
                tbody.innerHTML = '<tr><td colspan="3">No teachers found</td></tr>';
                return;
            }
            
            data.forEach(teacher => {
                const tr = document.createElement('tr');
                tr.innerHTML = `
                    <td>${teacher.id}</td>
                    <td>${teacher.name}</td>
                    <td>${teacher.email}</td>
                `;
                tbody.appendChild(tr);
            });
        })
        .catch(error => {
            console.error('Error:', error);
            document.getElementById('allTeacherTable').innerHTML = '<tr><td colspan="3">Error loading teachers</td></tr>';
        });
}

// View Individual Teacher Details
function viewIndividualTeacherDetails() {
    const teacherId = document.getElementById('searchTeacherId').value;
    
    if (!teacherId) {
        showMessage('Please enter a Teacher ID', 'error');
        return;
    }
    
    fetch(`${API_BASE_URL}/teachers/${teacherId}`)
        .then(response => response.json())
        .then(data => {
            const detailsDiv = document.getElementById('individualTeacherDetails');
            let sectionsHtml = 'None';
            let subjectsHtml = 'None';
            
            if (data.sections && data.sections.length > 0) {
                sectionsHtml = data.sections.map(s => `<li>${s.name}</li>`).join('');
                sectionsHtml = `<ul>${sectionsHtml}</ul>`;
            }
            
            if (data.subjects && data.subjects.length > 0) {
                subjectsHtml = data.subjects.map(s => `<li>${s.name}</li>`).join('');
                subjectsHtml = `<ul>${subjectsHtml}</ul>`;
            }
            
            detailsDiv.innerHTML = `
                <p><strong>Teacher ID:</strong> ${data.id}</p>
                <p><strong>Name:</strong> ${data.name}</p>
                <p><strong>Email:</strong> ${data.email}</p>
                <p><strong>Assigned Sections:</strong></p>
                ${sectionsHtml}
                <p><strong>Assigned Subjects:</strong></p>
                ${subjectsHtml}
            `;
            detailsDiv.style.display = 'block';
        })
        .catch(error => {
            console.error('Error:', error);
            showMessage('Teacher not found', 'error');
        });
}

// ===== STUDENT FUNCTIONS =====

// Load students for dropdowns
function loadStudentsDropdown() {
    fetch(`${API_BASE_URL}/students`)
        .then(response => response.json())
        .then(data => {
            // Currently not used, but available for future features
        })
        .catch(error => console.error('Error loading students:', error));
}

// View Student Profile
function viewStudentProfile() {
    const studentId = document.getElementById('viewStudentId').value;
    
    if (!studentId) {
        showMessage('Please enter a Student ID', 'error');
        return;
    }
    
    fetch(`${API_BASE_URL}/students/${studentId}`)
        .then(response => response.json())
        .then(data => {
            const profileDiv = document.getElementById('studentProfileInfo');
            profileDiv.innerHTML = `
                <p><strong>Student ID:</strong> ${data.id}</p>
                <p><strong>Name:</strong> ${data.name}</p>
                <p><strong>Email:</strong> ${data.email}</p>
                <p><strong>Roll No:</strong> ${data.rollNo || 'N/A'}</p>
                <p><strong>Section:</strong> ${data.section || 'N/A'}</p>
            `;
            profileDiv.style.display = 'block';
        })
        .catch(error => {
            console.error('Error:', error);
            showMessage('Student not found', 'error');
        });
}

// Load Student for Edit
function loadStudentForEdit() {
    const studentId = document.getElementById('editStudentId').value;
    
    if (!studentId) {
        showMessage('Please enter a Student ID', 'error');
        return;
    }
    
    fetch(`${API_BASE_URL}/students/${studentId}`)
        .then(response => response.json())
        .then(data => {
            document.getElementById('editStudentName').value = data.name;
            document.getElementById('editStudentEmail').value = data.email;
            document.getElementById('editStudentRoll').value = data.rollNo || '';
            document.getElementById('editStudentForm').style.display = 'block';
        })
        .catch(error => {
            console.error('Error:', error);
            showMessage('Student not found', 'error');
        });
}

// Edit Student Form
document.addEventListener('DOMContentLoaded', function() {
    const editStudentForm = document.getElementById('editStudentForm');
    if (editStudentForm) {
        editStudentForm.addEventListener('submit', function(e) {
            e.preventDefault();
            const studentId = document.getElementById('editStudentId').value;
            const data = {
                name: document.getElementById('editStudentName').value,
                email: document.getElementById('editStudentEmail').value,
                rollNo: document.getElementById('editStudentRoll').value
            };
            
            fetch(`${API_BASE_URL}/students/${studentId}`, {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(data)
            })
            .then(response => response.json())
            .then(data => {
                showMessage('Student updated successfully', 'success');
                loadAllStudents();
            })
            .catch(error => {
                console.error('Error:', error);
                showMessage('Error updating student', 'error');
            });
        });
    }
});

// Add Student Form
document.addEventListener('DOMContentLoaded', function() {
    const addStudentForm = document.getElementById('addStudentForm');
    if (addStudentForm) {
        addStudentForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            const newStudentId = document.getElementById('newStudentId').value.trim();
            const newStudentName = document.getElementById('newStudentName').value.trim();
            const newStudentRoll = document.getElementById('newStudentRoll').value.trim();
            const newStudentEmail = document.getElementById('newStudentEmail').value.trim();
            const newStudentPassword = document.getElementById('newStudentPassword').value.trim();
            const newStudentSection = document.getElementById('newStudentSection').value.trim();
            
            if (!newStudentId || !newStudentName || !newStudentRoll || !newStudentEmail || !newStudentPassword) {
                showMessage('All required fields must be filled', 'error', 'addStudentMessage');
                return;
            }
            
            const data = {
                id: parseInt(newStudentId),
                name: newStudentName,
                rollNo: newStudentRoll,
                email: newStudentEmail,
                password: newStudentPassword,
                section: newStudentSection ? parseInt(newStudentSection) : 0
            };
            
            showMessage('Adding student...', 'info', 'addStudentMessage');
            
            fetch(`${API_BASE_URL}/students`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(data)
            })
            .then(response => {
                if (!response.ok) {
                    return response.text().then(text => {
                        throw new Error(`HTTP ${response.status}: ${text}`);
                    });
                }
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    showMessage('✓ Student added successfully!', 'success', 'addStudentMessage');
                    addStudentForm.reset();
                    setTimeout(() => {
                        loadAllStudents();
                        loadSectionsDropdown();
                    }, 500);
                } else {
                    showMessage('Error: ' + (data.message || 'Failed to add student'), 'error', 'addStudentMessage');
                }
            })
            .catch(error => {
                console.error('Error adding student:', error);
                showMessage('Error: ' + error.message, 'error', 'addStudentMessage');
            });
        });
    }
});

// Remove Student
function removeStudent() {
    const studentId = document.getElementById('removeStudentId').value;
    
    if (!studentId) {
        showMessage('Please enter a Student ID', 'error', 'removeStudentMessage');
        return;
    }
    
    if (!confirm('Are you sure you want to remove this student?')) return;
    
    fetch(`${API_BASE_URL}/students/${studentId}`, {
        method: 'DELETE'
    })
    .then(response => response.json())
    .then(data => {
        showMessage('Student removed successfully', 'success', 'removeStudentMessage');
        document.getElementById('removeStudentId').value = '';
        loadAllStudents();
    })
    .catch(error => {
        console.error('Error:', error);
        showMessage('Error removing student', 'error', 'removeStudentMessage');
    });
}

// Load All Students
function loadAllStudents() {
    fetch(`${API_BASE_URL}/students`)
        .then(response => response.json())
        .then(data => {
            const tbody = document.getElementById('allStudentTable');
            tbody.innerHTML = '';
            
            if (data.length === 0) {
                tbody.innerHTML = '<tr><td colspan="5">No students found</td></tr>';
                return;
            }
            
            data.forEach(student => {
                const tr = document.createElement('tr');
                tr.innerHTML = `
                    <td>${student.id}</td>
                    <td>${student.name}</td>
                    <td>${student.rollNo || 'N/A'}</td>
                    <td>${student.email}</td>
                    <td>${student.section || 'N/A'}</td>
                `;
                tbody.appendChild(tr);
            });
        })
        .catch(error => {
            console.error('Error:', error);
            document.getElementById('allStudentTable').innerHTML = '<tr><td colspan="5">Error loading students</td></tr>';
        });
}

// View Individual Student Details
function viewIndividualStudentDetails() {
    const studentId = document.getElementById('searchStudentId').value;
    
    if (!studentId) {
        showMessage('Please enter a Student ID', 'error');
        return;
    }
    
    fetch(`${API_BASE_URL}/students/${studentId}`)
        .then(response => response.json())
        .then(data => {
            const detailsDiv = document.getElementById('individualStudentDetails');
            detailsDiv.innerHTML = `
                <p><strong>Student ID:</strong> ${data.id}</p>
                <p><strong>Name:</strong> ${data.name}</p>
                <p><strong>Email:</strong> ${data.email}</p>
                <p><strong>Roll No:</strong> ${data.rollNo || 'N/A'}</p>
                <p><strong>Section:</strong> ${data.section || 'N/A'}</p>
                <p><strong>Date Enrolled:</strong> ${data.dateEnrolled || 'N/A'}</p>
            `;
            detailsDiv.style.display = 'block';
        })
        .catch(error => {
            console.error('Error:', error);
            showMessage('Student not found', 'error');
        });
}

// ===== SECTIONS & SUBJECTS =====

// Load Sections Dropdown
function loadSectionsDropdown() {
    fetch(`${API_BASE_URL}/sections`)
        .then(response => response.json())
        .then(data => {
            const selectElements = [
                'assignSectionId',
                'newStudentSection'
            ];
            
            selectElements.forEach(elementId => {
                const select = document.getElementById(elementId);
                if (select) {
                    const currentValue = select.value;
                    select.innerHTML = '<option value="">-- Select Section --</option>';
                    data.forEach(section => {
                        const option = document.createElement('option');
                        option.value = section.id;
                        option.textContent = section.name;
                        select.appendChild(option);
                    });
                    select.value = currentValue;
                }
            });
        })
        .catch(error => console.error('Error loading sections:', error));
}

// Load Subjects Dropdown
function loadSubjectsDropdown() {
    fetch(`${API_BASE_URL}/subjects`)
        .then(response => response.json())
        .then(data => {
            const select = document.getElementById('assignSubjectId');
            if (select) {
                select.innerHTML = '<option value="">-- Select Subject --</option>';
                data.forEach(subject => {
                    const option = document.createElement('option');
                    option.value = subject.id;
                    option.textContent = subject.name;
                    select.appendChild(option);
                });
            }
        })
        .catch(error => console.error('Error loading subjects:', error));
}

// Load Sections Table
function loadSectionsTable() {
    fetch(`${API_BASE_URL}/sections`)
        .then(response => response.json())
        .then(data => {
            const tbody = document.getElementById('sectionTable');
            tbody.innerHTML = '';
            
            if (data.length === 0) {
                tbody.innerHTML = '<tr><td colspan="4">No sections found</td></tr>';
                return;
            }
            
            data.forEach(section => {
                const tr = document.createElement('tr');
                tr.innerHTML = `
                    <td>${section.id}</td>
                    <td>${section.name}</td>
                    <td>${section.course || 'N/A'}</td>
                    <td>${section.strength || 0}</td>
                `;
                tbody.appendChild(tr);
            });
        })
        .catch(error => {
            console.error('Error:', error);
            document.getElementById('sectionTable').innerHTML = '<tr><td colspan="4">Error loading sections</td></tr>';
        });
}

// Load Subjects Table
function loadSubjectsTable() {
    fetch(`${API_BASE_URL}/subjects`)
        .then(response => response.json())
        .then(data => {
            const tbody = document.getElementById('subjectTable');
            tbody.innerHTML = '';
            
            if (data.length === 0) {
                tbody.innerHTML = '<tr><td colspan="2">No subjects found</td></tr>';
                return;
            }
            
            data.forEach(subject => {
                const tr = document.createElement('tr');
                tr.innerHTML = `
                    <td>${subject.id}</td>
                    <td>${subject.name}</td>
                `;
                tbody.appendChild(tr);
            });
        })
        .catch(error => {
            console.error('Error:', error);
            document.getElementById('subjectTable').innerHTML = '<tr><td colspan="2">Error loading subjects</td></tr>';
        });
}

// ===== Utility Functions =====

function showMessage(message, type, elementId = 'message') {
    const messageElement = document.getElementById(elementId) || createMessageElement(elementId);
    messageElement.textContent = message;
    messageElement.className = `message ${type}`;
    messageElement.style.display = 'block';
    
    console.log(`[${type.toUpperCase()}] ${message}`);
    
    const timeout = type === 'info' ? 2000 : (type === 'error' ? 6000 : 4000);
    setTimeout(() => {
        messageElement.style.display = 'none';
    }, timeout);
}

function createMessageElement(elementId) {
    const div = document.createElement('div');
    div.id = elementId;
    div.className = 'message';
    document.querySelector('.form-container').appendChild(div);
    return div;
}

function logout(event) {
    if (event) event.preventDefault();
    
    localStorage.removeItem('role');
    localStorage.removeItem('name');
    window.location.href = 'index.html';
}

// Reload data every 30 seconds
setInterval(() => {
    const activeSection = document.querySelector('.content-section.active');
    if (activeSection) {
        const sectionId = activeSection.id;
        
        if (sectionId === 'teacher-view-all') loadAllTeachers();
        else if (sectionId === 'student-view-all') loadAllStudents();
        else if (sectionId === 'sections') loadSectionsTable();
        else if (sectionId === 'subjects') loadSubjectsTable();
        else if (sectionId === 'dashboard') loadDashboardStats();
    }
}, 30000);
