<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>SKSU Room Booking - Booking Summary</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/theme.css">
    <style>
        .summary-box {
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            max-width: 500px;
            margin: 40px auto 0; 
        }
        .summary-item {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px dashed #eee;
        }
        .summary-item:last-child {
            border-bottom: none;
        }
        .summary-label {
            font-weight: bold;
            color: var(--color-dark-olive);
            flex-basis: 45%;
        }
        .summary-value {
            text-align: right;
            color: var(--color-text-dark);
            flex-basis: 55%;
        }
    </style>
</head>
<body class="page-layout">
    
    <%@ include file="includes/header.jsp" %>
    
    <div class="main-body-container">
        
        <%@ include file="includes/sidebar.jsp" %>

        <div class="content" style="padding: 20px;">
            <h1 style="text-align: center; width: 100%;">✅ Booking Confirmed!</h1>
            <p style="text-align: center; width: 100%;">Your request has been successfully submitted and is pending administrator approval.</p>

            <div class="summary-box">
                <h2 style="text-align: center; color: var(--color-dark-olive); margin-bottom: 25px;">Booking Summary</h2>

                <%-- Display Booking Details (Placeholder data) --%>
                <div class="summary-item">
                    <span class="summary-label">Room:</span>
                    <span class="summary-value">Makmal Komputer</span>
                </div>
                
                <div class="summary-item">
                    <span class="summary-label">Purpose:</span>
                    <span class="summary-value">PowerPoint 101</span>
                </div>

                <div class="summary-item">
                    <span class="summary-label">Time Slot:</span>
                    <span class="summary-value">2:00 pm - 4:00 pm (2025-12-20)</span>
                </div>
                
                <div class="summary-item">
                    <span class="summary-label">Status:</span>
                    <span class="summary-value status-pending">PENDING</span>
                </div>

                <p style="text-align: right; margin-top: 30px;">
                    <button type="button" class="btn-secondary" onclick="window.location.href='/home'" style="min-width: 100px;">
                        Close
                    </button>
                </p>
            </div>
        </div>
    </div>
    
    <%@ include file="includes/footer.jsp" %>
</body>
</html>