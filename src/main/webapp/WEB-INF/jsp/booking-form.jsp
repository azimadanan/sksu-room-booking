<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>SKSU Room Booking - New Booking</title>
    
    <!-- Bootstrap 5 CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">
    
    <!-- Custom Theme CSS -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/theme.css">
    <style>
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        .form-full {
            grid-column: 1 / -1;
        }
        .form-actions {
            grid-column: 1 / -1;
            text-align: right;
            padding-top: 10px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: var(--color-dark-olive);
            font-size: 0.95em;
        }
    </style>
</head>
<body class="page-layout">
    
    <%@ include file="includes/header.jsp" %>
    
    <div class="main-body-container">
        
        <%@ include file="includes/sidebar.jsp" %>

        <div class="content">
            <h1>New Room Booking Request</h1>
            <p>Submit booking requests online.</p>

            <c:if test="${not empty error}">
                <div class="alert alert-danger" role="alert">
                    ${error}
                </div>
            </c:if>

            <div class="card">
                <form action="${pageContext.request.contextPath}/booking/submit" method="POST">
                    
                    <div class="form-grid">
                        
                        <div>
                            <label for="room" class="form-label">Room:</label>
                            <select id="room" name="room" class="form-select" required>
                                <option value="" style="background-color: white;">--- Choose Room ---</option>
                                <c:forEach items="${rooms}" var="room">
                                    <option value="${room.id}" ${selectedRoomId == room.id ? 'selected' : ''} style="background-color: white;">${room.name} (Capacity: ${room.capacity})</option>
                                </c:forEach>
                            </select>
                            <c:if test="${empty rooms}">
                                <small class="text-danger">No rooms available. Please contact Admin.</small>
                            </c:if>
                        </div>
                        
                        <div>
                            <label for="purpose" class="form-label">Purpose:</label>
                            <input type="text" id="purpose" name="purpose" class="form-control" placeholder="e.g., PowerPoint 101" required>
                        </div>

                        <div>
                            <label for="classUsed" class="form-label">Class:</label>
                            <input type="text" id="classUsed" name="classUsed" class="form-control" placeholder="e.g., 2B">
                        </div>
                        
                        <div>
                            <label for="students" class="form-label">Number of Students:</label>
                            <input type="number" id="students" name="students" class="form-control" min="1" required>
                        </div>
                        
                        <div>
                            <label for="startTime" class="form-label">Start Date & Time:</label>
                            <input type="datetime-local" id="startTime" name="startTime" class="form-control" required>
                        </div>
                        
                        <div>
                            <label for="endTime" class="form-label">End Date & Time:</label>
                            <input type="datetime-local" id="endTime" name="endTime" class="form-control" required>
                        </div>

                        <div class="form-full">
                            <label for="equipment" class="form-label">Equipment Needed:</label>
                            <input type="text" id="equipment" name="equipment" class="form-control" placeholder="e.g., Projector, Whiteboard Marker">
                        </div>

                        <div class="form-actions">
                            <button type="button" class="btn btn-secondary" onclick="window.history.back()">Cancel</button>
                            <button type="submit" class="btn btn-primary">Submit Request</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <%@ include file="includes/footer.jsp" %>
</body>
</html>