<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>SKSU Room Booking - Login</title>
    
    <!-- Bootstrap 5 CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">
    
    <!-- Custom Theme CSS -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/theme.css">
    
    <!-- Background Image Style -->
    <style>
        body.login-page {
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
            height: 100vh;
            margin: 0;
            font-family: 'Roboto', sans-serif;
        }

        .login-container {
            background: linear-gradient(135deg, rgba(255,255,255,0.4) 0%, rgba(255,255,255,0.1) 100%);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1); /* Subtle deep shadow */
            width: 100%;
            max-width: 400px;
            text-align: center;
            border: 1px solid rgba(255, 255, 255, 0.6); /* Shiny glass edge */
            animation: fadeIn 0.8s ease-out;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .login-container .school-logo {
            width: 130px;
            height: 130px;
            margin-bottom: 20px;
            margin-top: 80px; /* Moved down slightly */
            border-radius: 50%; /* Perfect Circle */
            object-fit: cover; /* Ensures image doesn't distort */
            border: 4px solid rgba(255, 255, 255, 0.9); /* Premium white border */
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2); /* Deep shadow */
            background-color: white;
        }

        .system-title {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(to right, #6a1b9a 0%, #ba68c8 50%, #6a1b9a 100%);
            background-size: 200% auto;
            color: #000; /* Fallback */
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            animation: shine 3s linear infinite;
            font-weight: 700;
            margin-bottom: 5px;
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

        /* --- Toggle Switch Styling (Enhanced Glassmorphism) --- */
        .role-selector {
            display: flex;
            background: rgba(255, 255, 255, 0.3); /* Slightly more opaque */
            border: 1px solid rgba(255, 255, 255, 0.4);
            border-radius: 50px;
            padding: 4px;
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
            font-weight: 600; /* Bolder text */
            color: #333; /* Darker text for readability */
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275); /* Smooth bouncy effect */
            z-index: 2;
        }

        .role-btn:hover:not(.active) {
            background-color: rgba(255, 255, 255, 0.2);
            transform: translateY(-2px);
        }

        .role-btn:active {
            transform: scale(0.95) !important; /* "Press" effect overrides others */
        }

        .role-btn.active {
            color: #000;
            font-weight: 700;
            background: rgba(255, 215, 0, 0.85); /* Stronger gold */
            box-shadow: 0 4px 15px rgba(255, 215, 0, 0.4);
            border: 1px solid rgba(255, 215, 0, 0.6);
            backdrop-filter: blur(4px);
            transform: scale(1.05); /* The "Pop" */
        }

        /* --- Input Fields (Glass Style with Icons) --- */
        input[type="email"], input[type="password"] {
            width: 100%;
            padding: 14px 15px 14px 45px; /* Added left padding for icon */
            margin-bottom: 15px;
            border: 1px solid rgba(106, 27, 154, 0.4); /* Stronger border */
            border-radius: 12px;
            font-size: 1rem;
            transition: all 0.3s;
            background-color: rgba(255, 255, 255, 0.8); /* More Opaque Input Background */
            backdrop-filter: blur(5px);
            box-sizing: border-box; 
            color: #222; /* High opacity text */
            font-weight: 500;
            background-repeat: no-repeat;
            background-position: 15px center;
            background-size: 20px;
        }

        /* Envelope Icon for Email */
        input[type="email"] {
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='%236A1B9A'%3E%3Cpath d='M20 4H4c-1.1 0-1.99.9-1.99 2L2 18c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 4l-8 5-8-5V6l8 5 8-5v2z'/%3E%3C/svg%3E");
        }

        /* Lock Icon for Password */
        input[type="password"] {
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='%236A1B9A'%3E%3Cpath d='M18 8h-1V6c0-2.76-2.24-5-5-5S7 3.24 7 6v2H6c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V10c0-1.1-.9-2-2-2zm-6 9c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2zm3.1-9H8.9V6c0-1.71 1.39-3.1 3.1-3.1 1.71 0 3.1 1.39 3.1 3.1v2z'/%3E%3C/svg%3E");
        }

        input[type="email"]:focus, input[type="password"]:focus {
            border-color: var(--color-primary);
            background-color: rgba(255, 255, 255, 0.95);
            outline: none;
            box-shadow: 0 0 10px rgba(106, 27, 154, 0.2);
        }

        /* --- Primary Button --- */
        .btn-primary {
            width: 100%;
            padding: 14px;
            font-size: 1rem;
            border-radius: 12px;
            border: none;
            color: white;
            background: linear-gradient(135deg, var(--color-primary), #8E24AA);
            box-shadow: 0 4px 15px rgba(106, 27, 154, 0.4);
            cursor: pointer;
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(106, 27, 154, 0.5);
        }

        /* --- Footer Links --- */
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
<body class="login-page">
    <div class="login-container">
        
        <img src="https://upload.wikimedia.org/wikipedia/ms/1/1c/Lencana_Sekolah_Kebangsaan_Saujana_Utama.jpg" 
             alt="SKSU Logo" 
             class="school-logo">
        
        <h2 class="system-title">Welcome to SKSU</h2>
        <p class="subtitle">Sign in to book your facilities</p>

        <div class="role-selector">
            <button type="button" class="role-btn active" id="btnUser" onclick="setRole('USER')">Teacher</button>
            <button type="button" class="role-btn" id="btnAdmin" onclick="setRole('ADMIN')">Admin</button>
        </div>

        <form action="${pageContext.request.contextPath}/login/submit" method="POST">
            <input type="hidden" name="expectedRole" id="expectedRole" value="USER">

            <div class="mb-3">
                <input type="email" name="email" id="emailInput" class="form-control form-control-lg" placeholder="Gmail Address (@gmail.com)" required style="padding: 14px 15px 14px 45px; background-image: url(&quot;data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='%236A1B9A'%3E%3Cpath d='M20 4H4c-1.1 0-1.99.9-1.99 2L2 18c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 4l-8 5-8-5V6l8 5 8-5v2z'/%3E%3C/svg%3E&quot;);">
            </div>
            <div class="mb-3">
                <input type="password" name="password" class="form-control form-control-lg" placeholder="Password" required style="padding: 14px 15px 14px 45px; background-image: url(&quot;data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='%236A1B9A'%3E%3Cpath d='M18 8h-1V6c0-2.76-2.24-5-5-5S7 3.24 7 6v2H6c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V10c0-1.1-.9-2-2-2zm-6 9c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2zm3.1-9H8.9V6c0-1.71 1.39-3.1 3.1-3.1 1.71 0 3.1 1.39 3.1 3.1v2z'/%3E%3C/svg%3E&quot;);">
            </div>
            
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; font-size: 0.85rem; color: #f0f0f0; text-shadow: 0 1px 2px rgba(0,0,0,0.3);">
                <label>
                    <input type="checkbox" name="rememberMe" id="rememberMe" style="margin-right: 5px;"> Remember me
                </label>
                <a href="${pageContext.request.contextPath}/forgot-password" style="color: #ffffff; text-decoration: none; text-shadow: 0 1px 2px rgba(0,0,0,0.3);">Forgot password?</a>
            </div>
            
            <button type="submit" class="btn btn-primary btn-lg w-100">Log In</button>
        </form>

        <script>
            // Role selector
            function setRole(role) {
                document.getElementById('expectedRole').value = role;
                const btnUser = document.getElementById('btnUser');
                const btnAdmin = document.getElementById('btnAdmin');
                
                if (role === 'USER') {
                    btnUser.classList.add('active');
                    btnAdmin.classList.remove('active');
                } else {
                    btnAdmin.classList.add('active');
                    btnUser.classList.remove('active');
                }
            }

            // Remember Me functionality
            document.addEventListener('DOMContentLoaded', function() {
                const emailInput = document.getElementById('emailInput');
                const rememberMe = document.getElementById('rememberMe');
                
                // Load saved email if Remember Me was checked
                const savedEmail = localStorage.getItem('sksu_remembered_email');
                if (savedEmail) {
                    emailInput.value = savedEmail;
                    rememberMe.checked = true;
                }
                
                // Save email when form is submitted with Remember Me checked
                document.querySelector('form').addEventListener('submit', function() {
                    if (rememberMe.checked) {
                        localStorage.setItem('sksu_remembered_email', emailInput.value);
                    } else {
                        localStorage.removeItem('sksu_remembered_email');
                    }
                });
            });
        </script>

        <% if (request.getAttribute("error") != null) { %>
            <p style="color: var(--color-danger); margin-top: 15px; font-weight: 500;"><%= request.getAttribute("error") %></p>
        <% } %>

        <a href="${pageContext.request.contextPath}/register" class="footer-link">Don't have an account? Register here</a>
        
        <p style="margin-top: 30px; font-size: 0.75em; color: #e0e0e0; text-shadow: 0 1px 2px rgba(0,0,0,0.3);">
            &copy; <%= java.time.Year.now() %> SK Saujana Utama Ijok
        </p>
    </div>
</body>
</html>