<%@ page import="com.sksu.model.Booking" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
  <head>
    <title>SKSU - Booking Search Results</title>
    
    <!-- Bootstrap 5 CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">
    
    <!-- Custom Theme CSS -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/theme.css"/>
  </head>
  <body class="page-layout">
    <%@ include file="includes/header.jsp" %>

    <div class="main-body-container">
      <%@ include file="includes/sidebar.jsp" %>

      <div class="content">
        <h1>Booking Search Results</h1>
        <p>
          <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-secondary">Back to Dashboard</a>
        </p>
        
        <!-- Search Filters Applied -->
        <div class="alert alert-info">
          <strong>Search Filters:</strong>
          <% 
            String emailFilter = (String) request.getAttribute("emailFilter");
            String roomFilter = (String) request.getAttribute("roomFilter");
            String dateFilter = (String) request.getAttribute("dateFilter");
            String statusFilter = (String) request.getAttribute("statusFilter");
          %>
          <% if (emailFilter != null && !emailFilter.isEmpty()) { %>
            Teacher: <strong><%= emailFilter %></strong> |
          <% } %>
          <% if (roomFilter != null && !roomFilter.isEmpty()) { %>
            Room: <strong><%= roomFilter %></strong> |
          <% } %>
          <% if (dateFilter != null && !dateFilter.isEmpty()) { %>
            Date: <strong><%= dateFilter %></strong> |
          <% } %>
          <% if (statusFilter != null && !statusFilter.isEmpty()) { %>
            Status: <strong><%= statusFilter %></strong>
          <% } %>
          <% if ((emailFilter == null || emailFilter.isEmpty()) && 
                 (roomFilter == null || roomFilter.isEmpty()) && 
                 (dateFilter == null || dateFilter.isEmpty()) && 
                 (statusFilter == null || statusFilter.isEmpty())) { %>
            <em>No filters applied - showing all bookings</em>
          <% } %>
        </div>

        <div class="card shadow-sm">
          <div class="card-header bg-primary text-white">
            <h2 class="mb-0">Search Results (<%= request.getAttribute("resultCount") %> found)</h2>
          </div>
          <div class="card-body p-0">
            <div class="table-responsive">
              <table class="table table-striped table-hover mb-0">
                <thead class="table-dark">
                  <tr>
                    <th>ID</th>
                    <th>Teacher</th>
                    <th>Room</th>
                    <th>Purpose</th>
                    <th>Start Time</th>
                    <th>End Time</th>
                    <th>Status</th>
                  </tr>
                </thead>
                <tbody>
                  <%
                      List<?> searchResults = (List<?>) request.getAttribute("searchResults");
                      DateTimeFormatter inputFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
                      DateTimeFormatter outputFormatter = DateTimeFormatter.ofPattern("dd MMM yyyy, hh:mm a");
                      
                      if (searchResults == null || searchResults.isEmpty()) {
                  %>
                  <tr>
                    <td colspan="7" class="text-center text-muted py-4">No bookings found matching your search criteria.</td>
                  </tr>
                  <%
                      } else {
                          for (Object obj : searchResults) {
                              if (obj instanceof Booking) {
                                  Booking booking = (Booking) obj;
                                  
                                  String roomName = booking.getRoom();
                                  if ("101".equals(roomName)) roomName = "Makmal Komputer";
                                  else if ("102".equals(roomName)) roomName = "Bilik Seni";
                                  else if ("103".equals(roomName)) roomName = "Surau";
                                  else if ("104".equals(roomName)) roomName = "Makmal Sains 1";
                                  else if ("105".equals(roomName)) roomName = "Makmal Sains 2";
                                  else if ("106".equals(roomName)) roomName = "Bilik Mesyuarat";

                                  String teacher = booking.getUserEmail();
                                  if (teacher == null) teacher = "Unknown";
                                  
                                  String purpose = booking.getPurpose();
                                  String status = booking.getStatus();
                                  Long id = booking.getId();

                                  String start = booking.getStart();
                                  try {
                                      LocalDateTime d = LocalDateTime.parse(start, inputFormatter);
                                      start = d.format(outputFormatter);
                                  } catch(Exception e) {}

                                  String end = booking.getEnd();
                                  try {
                                      LocalDateTime d = LocalDateTime.parse(end, inputFormatter);
                                      end = d.format(outputFormatter);
                                  } catch(Exception e) {}
                  %>
                  <tr>
                    <td><%= id %></td>
                    <td><%= teacher %></td>
                    <td><%= roomName %></td>
                    <td><%= purpose %></td>
                    <td><%= start %></td>
                    <td><%= end %></td>
                    <td class="status-<%= status != null ? status.toLowerCase() : "pending" %>">
                      <%= status %>
                    </td>
                  </tr>
                  <%
                              }
                          }
                      }
                  %>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>

    <%@ include file="includes/footer.jsp" %>
  </body>
</html>
