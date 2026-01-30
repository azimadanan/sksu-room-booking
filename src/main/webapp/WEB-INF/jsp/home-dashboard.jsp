<%@ page import="com.sksu.model.Booking" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>SKSU Room Booking - Dashboard</title>
    
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
            <h1>Welcome To SKSU ROOM BOOKING</h1>
            <p>Find the next available slot and book instantly.</p>

            <%-- Display success/error messages --%>
            <% if (request.getAttribute("success") != null) { %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <strong>✅ Success!</strong> <%= request.getAttribute("success") %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <strong>❌ Error!</strong> <%= request.getAttribute("error") %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>

            <%-- --- 1. QUICK ACCESS (Centered) --- --%>
            <%-- --- 1. DASHBOARD INFO PANELS --- --%>
            <div class="dashboard-info-grid">
                <!-- Panel 1: Room List -->
                <a href="/rooms" class="info-panel">
                    <h3>Room List Catalog</h3>
                    <p>Browse available rooms, check their details, features, and individual calendars.</p>
                </a>

                <!-- Panel 2: New Booking -->
                <a href="/booking/new" class="info-panel">
                    <h3>New Room Booking Request</h3>
                    <p>Submit new room booking requests online instantly for approval by the administration.</p>
                </a>

                <!-- Panel 3: Availability Calendar -->
                <a href="/calendar" class="info-panel">
                    <h3>Room Availability Calendar</h3>
                    <p>View the monthly schedule for all approved room usage to plan your events.</p>
                </a>
            </div>
            
            <%-- --- 2. MY RECENT BOOKINGS --- --%>
            <div class="card shadow-sm">
                <div class="card-header bg-info text-white">
                    <h2 class="mb-0">My Recent Bookings</h2>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-striped table-hover mb-0">
                        <thead class="table-dark">
                            <tr>
                                <th scope="col" style="width: 18%">Purpose</th>
                                <th scope="col" style="width: 13%">Room</th>
                                <th scope="col" style="width: 18%">Start Time</th>
                                <th scope="col" style="width: 18%">End Time</th>
                                <th scope="col" style="width: 10%">Status</th>
                                <th scope="col" style="width: 13%">Reason</th>
                                <th scope="col" style="width: 10%">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                List<?> rawBookings = (List<?>) request.getAttribute("bookings");
                                DateTimeFormatter inputFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
                                DateTimeFormatter outputFormatter = DateTimeFormatter.ofPattern("dd MMM yyyy, hh:mm a");

                                if (rawBookings == null || rawBookings.isEmpty()) {
                            %>
                                    <tr><td colspan="7">No recent bookings found.</td></tr>
                            <%      
                                } else {
                                    for (Object obj : rawBookings) {
                                        if (obj instanceof Booking) {
                                            Booking booking = (Booking) obj;
                                            
                                            // Map Room IDs to Names
                                            String roomName = booking.getRoom();
                                            if ("102".equals(roomName)) roomName = "Surau";
                                            else if ("101".equals(roomName)) roomName = "Makmal Komputer";
                                            else if ("103".equals(roomName)) roomName = "Surau"; // Duplicate mapping as per previous request? Or maybe 103 was something else. Let's stick to safe defaults.
                                            else if ("104".equals(roomName)) roomName = "Makmal Sains 1";
                                            else if ("105".equals(roomName)) roomName = "Makmal Sains 2";
                                            else if ("106".equals(roomName)) roomName = "Bilik Mesyuarat";
                                            
                                            // Format Start Date
                                            String formattedStart = booking.getStart();
                                            try {
                                                LocalDateTime date = LocalDateTime.parse(booking.getStart(), inputFormatter);
                                                formattedStart = date.format(outputFormatter);
                                            } catch (Exception e) { /* Keep original if parsing fails */ }

                                            // Format End Date
                                            String formattedEnd = booking.getEnd();
                                            try {
                                                LocalDateTime date = LocalDateTime.parse(booking.getEnd(), inputFormatter);
                                                formattedEnd = date.format(outputFormatter);
                                            } catch (Exception e) { /* Keep original if parsing fails */ }
                                            
                                            // Status and Reason
                                            String status = booking.getStatus();
                                            String reason = booking.getRejectionReason();
                                            if (reason == null) reason = "-";
                            %>
                                            <tr>
                                                <td><%= booking.getPurpose() %></td>
                                                <td><%= roomName %></td>
                                                <td><%= formattedStart %></td>
                                                <td><%= formattedEnd %></td>
                                                <td class="status-<%= status.toLowerCase() %>"><%= status %></td>
                                                <td><%= reason %></td>
                                                <td>
                                                    <% if ("Pending".equals(status) || "Approved".equals(status)) { %>
                                                        <form action="${pageContext.request.contextPath}/booking/cancel" method="POST" style="display: inline;"
                                                              onsubmit="return confirm('Are you sure you want to cancel this booking for <%= booking.getPurpose() %> in <%= roomName %>?');">
                                                            <input type="hidden" name="bookingId" value="<%= booking.getId() %>">
                                                            <button type="submit" class="btn btn-sm btn-danger" title="Cancel this booking">
                                                                Cancel
                                                            </button>
                                                        </form>
                                                    <% } else { %>
                                                        <span style="color: #999;">-</span>
                                                    <% } %>
                                                </td>
                                            </tr>
                            <%
                                        }
                                    }
                                }
                            %>
                        </tbody>
                    </table>
                    </div><!-- .table-responsive -->
                </div><!-- .card-body -->
            </div><!-- .card -->
        </div>
    </div>
    
    <%@ include file="includes/footer.jsp" %>
</body>
</html>