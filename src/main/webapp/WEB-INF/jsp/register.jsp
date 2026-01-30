<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>SKSU Room Booking - Register</title>
    
    <!-- Bootstrap 5 CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">
    
    <!-- Custom Theme CSS -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/theme.css">
    
    <!-- Glassmorphism Redesign Style -->
    <style>
        body.register-page {
            /* Final Design: Gradient + Image from User */
            background: linear-gradient(135deg, rgba(106, 27, 154, 0.5), rgba(74, 20, 108, 0.7)), 
                        url('https://i.imgur.com/rtaSNVG.jpeg');
            background-repeat: no-repeat;
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            font-family: 'Roboto', sans-serif;
            padding: 20px 0;
            box-sizing: border-box;
        }

        .register-container {
            background: linear-gradient(135deg, rgba(255,255,255,0.4) 0%, rgba(255,255,255,0.1) 100%);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 500px;
            text-align: center;
            border: 1px solid rgba(255, 255, 255, 0.6);
            animation: fadeIn 0.8s ease-out;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .system-title {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(to right, #6a1b9a 0%, #ba68c8 50%, #6a1b9a 100%);
            background-size: 200% auto;
            color: #000; /* Fallback */
            background-clip: text;
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            animation: shine 3s linear infinite;
            font-weight: 700;
            margin-bottom: 5px;
            font-size: 1.8rem; /* Kept font size appropriate for register page layout */
        }

        @keyframes shine {
            to {
                background-position: 200% center;
            }
        }
        
        .subtitle {
            color: #f0f0f0;
            font-size: 0.9em;
            margin-bottom: 30px;
            text-shadow: 0 1px 2px rgba(0,0,0,0.3);
        }

        /* --- Role Toggle --- */
        .role-selector {
            display: flex;
            background: rgba(255, 255, 255, 0.3);
            border-radius: 50px;
            padding: 5px;
            margin-bottom: 25px;
            position: relative;
            backdrop-filter: blur(5px);
        }

        .role-btn {
            flex: 1;
            padding: 10px;
            border: none;
            background: transparent;
            cursor: pointer;
            border-radius: 50px;
            font-weight: 600;
            color: #333;
            transition: all 0.3s ease;
            font-size: 1rem;
        }
        
        .role-btn:hover:not(.active) {
            background-color: rgba(255, 255, 255, 0.2);
            transform: translateY(-2px);
        }

        .role-btn.active {
            color: #000;
            background: #FFD700; /* Golden Yellow */
            box-shadow: 0 4px 10px rgba(255, 215, 0, 0.4);
            font-weight: 700;
            transform: scale(1.02);
        }

        /* --- Grid Layout --- */
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }

        .full-width {
            grid-column: span 2;
        }
        
        .half-width {
            grid-column: span 1;
        }

        /* --- Input Fields (Matched Login Style - NO ICONS) --- */
        input, 
        input[type="text"],
        input[type="email"],
        input[type="password"],
        input[type="tel"] {
            width: 100%;
            padding: 14px 15px; /* Standard Padding */
            border: 1px solid rgba(106, 27, 154, 0.4); /* Matched Login Border */
            border-radius: 12px;
            font-size: 1rem;
            transition: all 0.3s;
            background-color: rgba(255, 255, 255, 0.8); /* Matched Login Opacity */
            backdrop-filter: blur(5px);
            box-sizing: border-box; 
            color: #222; 
            font-weight: 500;
            outline: none;
            /* Ensure no inherited margins/heights differ */
            margin: 0; 
            height: auto;
        }
        
        ::placeholder {
            color: #555;
        }

        input:focus {
            background-color: rgba(255, 255, 255, 0.95);
            border-color: var(--color-primary);
            box-shadow: 0 0 10px rgba(106, 27, 154, 0.2);
        }

        /* --- Register Button (Matched Login) --- */
        .btn-register {
            grid-column: span 2;
            width: 100%;
            padding: 14px;
            font-size: 1.1rem;
            border-radius: 12px;
            border: none;
            color: white;
            background: linear-gradient(135deg, var(--color-primary), #8E24AA);
            box-shadow: 0 4px 15px rgba(106, 27, 154, 0.4); /* Primary Shadow */
            cursor: pointer;
            font-weight: bold;
            margin-top: 15px;
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .btn-register:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(106, 27, 154, 0.5);
        }

        /* Hidden Admin Input */
        #adminCodeContainer {
            display: none; /* Hidden by default */
            grid-column: span 2;
        }

        .footer-link {
            display: block;
            margin-top: 20px;
            color: #ffffff;
            text-decoration: none;
            font-weight: 600;
            font-size: 0.9rem;
            text-shadow: 0 1px 2px rgba(0,0,0,0.3);
        }
        
        .footer-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body class="register-page">

    <div class="register-container">
        <!-- Logo -->
        <!-- <img src="https://upload.wikimedia.org/wikipedia/ms/1/1c/Lencana_Sekolah_Kebangsaan_Saujana_Utama.jpg" alt="SKSU Logo" class="school-logo"> -->
        <!-- User didn't explicitly ask for logo in this prompt but it's standard. I'll keep the H2 prominent as requested by "Header" logic implied -->
        
        <h2 class="system-title">Create Account</h2>
        <p class="subtitle">Join the SKSU Booking System</p>

        <!-- Role Toggle -->
        <div class="role-selector">
            <button type="button" class="role-btn active" id="btnTeacher" onclick="selectRole('USER')">Teacher</button>
            <button type="button" class="role-btn" id="btnAdmin" onclick="selectRole('ADMIN')">Admin</button>
        </div>

        <form action="${pageContext.request.contextPath}/register/submit" method="POST" id="registerForm" class="form-grid">
            
            <!-- Hidden Role Input -->
            <input type="hidden" name="role" id="selectedRole" value="USER">

            <!-- Row 1: First Name | Last Name -->
            <input type="text" name="firstName" class="half-width form-control" placeholder="First Name" required>
            <input type="text" name="lastName" class="half-width form-control" placeholder="Last Name" required>

            <!-- Row 2: Staff ID | Mobile Number -->
            <input type="text" name="staffId" class="half-width form-control" placeholder="Staff ID" required>
            <input type="tel" name="contactNumber" class="half-width form-control" placeholder="Mobile Number" required>

            <!-- Row 3: Email (Full Width) -->
            <div class="full-width">
                <input type="email" name="email" class="form-control" placeholder="Official Email Address" required>
            </div>

            <!-- Row 4: Password (Full Width) -->
            <div class="full-width">
                <input type="password" name="password" class="form-control" placeholder="Password" required>
            </div>
            
            <!-- Added Confirm Password for safety, consistent with full width layout -->
             <div class="full-width">
                <input type="password" name="confirmPassword" id="confirmPassword" class="form-control" placeholder="Confirm Password" required>
            </div>

            <!-- Row 5: Admin Secret Code (Hidden) -->
            <div id="adminCodeContainer">
                <input type="password" id="adminCode" class="form-control" placeholder="Admin Secret Code">
            </div>

            <!-- Submit Button -->
            <button type="button" class="btn btn-register btn-lg w-100" onclick="validateAndSubmit()">Register Account</button>

        </form>

        <% if (request.getAttribute("error") != null) { %>
            <p style="color: #ff5252; margin-top: 15px; font-weight: bold; text-shadow: 0 1px 1px rgba(0,0,0,0.5);">
                <%= request.getAttribute("error") %>
            </p>
        <% } %>

        <a href="${pageContext.request.contextPath}/login" class="footer-link">Already have an account? Login here</a>
    </div>

    <!-- JavaScript Logic -->
    <script>
        const CORRECT_ADMIN_CODE = "1234"; // Developer Config

        function selectRole(role) {
            document.getElementById('selectedRole').value = role;
            
            if (role === 'USER') { // "Teacher"
                document.getElementById('btnTeacher').classList.add('active');
                document.getElementById('btnAdmin').classList.remove('active');
                document.getElementById('adminCodeContainer').style.display = 'none';
            } else { // "Admin"
                document.getElementById('btnAdmin').classList.add('active');
                document.getElementById('btnTeacher').classList.remove('active');
                document.getElementById('adminCodeContainer').style.display = 'block';
                setTimeout(() => document.getElementById('adminCode').focus(), 100);
            }
        }

        function validateAndSubmit() {
            const role = document.getElementById('selectedRole').value;
            const form = document.getElementById('registerForm');
            const password = document.querySelector('input[name="password"]').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (role === 'ADMIN') {
                const inputCode = document.getElementById('adminCode').value;
                if (inputCode !== CORRECT_ADMIN_CODE) {
                    alert("Security code not correct. Please contact the developer to get the code.");
                    return; 
                }
            }
            
            if (password !== confirmPassword) {
                alert("Passwords do not match!");
                return;
            }
            
            if (form.reportValidity()) {
                form.submit();
            }
        }
    </script>
</body>
</html>
