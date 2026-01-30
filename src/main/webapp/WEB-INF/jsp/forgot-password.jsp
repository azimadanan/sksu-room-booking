<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>SKSU - Forgot Password</title>
    
    <!-- Bootstrap 5 CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">
    
    <!-- Custom Theme CSS -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/theme.css">
    
    <style>
        body.forgot-page {
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
        }

        .forgot-container {
            background: linear-gradient(135deg, rgba(255,255,255,0.4) 0%, rgba(255,255,255,0.1) 100%);
            backdrop-filter: blur(12px);
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 450px;
            text-align: center;
            border: 1px solid rgba(255, 255, 255, 0.6);
        }

        .forgot-container h2 {
            color: #6a1b9a;
            margin-bottom: 10px;
        }

        .forgot-container p {
            color: #f0f0f0;
            margin-bottom: 25px;
            text-shadow: 0 1px 2px rgba(0,0,0,0.3);
        }

        input[type="email"] {
            width: 100%;
            padding: 14px 15px;
            margin-bottom: 20px;
            border: 1px solid rgba(106, 27, 154, 0.4);
            border-radius: 12px;
            font-size: 1rem;
            background-color: rgba(255, 255, 255, 0.8);
            box-sizing: border-box;
        }

        .btn-primary {
            width: 100%;
            padding: 14px;
            border-radius: 12px;
            border: none;
            color: white;
            background: linear-gradient(135deg, #6a1b9a, #8E24AA);
            cursor: pointer;
        }

        .back-link {
            display: block;
            margin-top: 20px;
            color: #ffffff;
            text-decoration: none;
            text-shadow: 0 1px 2px rgba(0,0,0,0.3);
        }

        .success-msg {
            background: rgba(76, 175, 80, 0.9);
            color: white;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
        }

        .error-msg {
            background: rgba(244, 67, 54, 0.9);
            color: white;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body class="forgot-page">
    <div class="forgot-container">
        <h2>Forgot Password</h2>
        <p>Enter your email address and we'll send you your password.</p>

        <% if (request.getAttribute("success") != null) { %>
            <div class="success-msg">
                <%= request.getAttribute("success") %>
            </div>
        <% } %>

        <% if (request.getAttribute("error") != null) { %>
            <div class="error-msg">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/forgot-password/submit" method="POST">
            <input type="email" name="email" placeholder="Enter your email address" required>
            <button type="submit" class="btn btn-primary">Send Password</button>
        </form>

        <a href="${pageContext.request.contextPath}/login" class="back-link">Back to Login</a>
    </div>
</body>
</html>
