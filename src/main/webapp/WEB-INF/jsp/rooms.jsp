<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>SKSU Room Booking - Room List</title>
    
    <!-- Bootstrap 5 CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">
    
    <!-- Custom Theme CSS -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/theme.css">
</head>
<body class="page-layout">
    
    <%@ include file="includes/header.jsp" %>
    
    <div class="main-body-container">
        
        <%@ include file="includes/sidebar.jsp" %>

        <div class="content">
            <h1>Room List Catalog</h1>
            <p>Browse available rooms and check their details or calendars.</p>

            <div class="card">
                <h2>All Special Rooms</h2>
                
                <div class="room-list-grid">
                    
                    <% 
                        List<?> roomList = (List<?>) request.getAttribute("rooms");
                        if (roomList == null) { roomList = java.util.Collections.emptyList(); }
                    %>


                    <% for (Object roomObj : roomList) { 
                        if (roomObj instanceof com.sksu.model.Room) {
                            com.sksu.model.Room room = (com.sksu.model.Room) roomObj;
                            String name = room.getName();
                            String id = room.getId(); // ID is a String in the model
                            int capacity = room.getCapacity();
                    %>
                        <div class="room-item-card">
                            
                            <div>
                                <h3><%= name %></h3>
                                <p style="margin-top: 0; font-size: 0.9em;">Room Id: <%= id %> | Capacity: <%= capacity %></p>
                            </div>
                            
                            <div class="button-group">
                                <a href="/booking/new?roomId=<%= id %>" class="btn btn-primary">Book Room</a>
                                <a href="/calendar?roomId=<%= id %>" class="btn btn-secondary">Check Availability</a>
                            </div>
                        </div>
                    <% 
                        }
                    } %>
                    
                </div>
            </div>
            
        </div>
    </div>
    
    <%@ include file="includes/footer.jsp" %>
</body>
</html>