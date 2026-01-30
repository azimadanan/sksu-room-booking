<%@ page import="com.sksu.model.Booking" %>
<%@ page import="com.sksu.controller.HomeController" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
  <head>
    <title>SKSU Room Booking - Admin Dashboard</title>
    
    <!-- Bootstrap 5 CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">
    
    <!-- Custom Theme CSS -->
    <link
      rel="stylesheet"
      type="text/css"
      href="${pageContext.request.contextPath}/static/css/theme.css"
    />
  </head>
  <body class="page-layout">
    <%@ include file="includes/header.jsp" %>

    <div class="main-body-container">
      <%@ include file="includes/sidebar.jsp" %>

      <div class="content">
        <h1>Administrator Dashboard</h1>
        <p>
          School administrators can efficiently review, approve, or reject
          requests through this dashboard. Total Bookings:
          ${pendingRequests.size()}
        </p>

        <div class="card shadow-sm">
          <div class="card-header bg-primary text-white">
            <h2 class="mb-0">All Bookings Review</h2>
          </div>
          <div class="card-body p-0">
            <div class="table-responsive">
              <table class="table table-striped table-hover mb-0">
            <thead class="table-dark">
              <tr>
                <th scope="col" style="width: 5%">ID</th>
                <th scope="col" style="width: 12%">Teacher</th>
                <th scope="col" style="width: 10%">Room</th>
                <th scope="col" style="width: 12%">Purpose</th>
                <th scope="col" style="width: 13%">Start Time</th>
                <th scope="col" style="width: 13%">End Time</th>
                <th scope="col" style="width: 8%">Status</th>
                <th scope="col" style="width: 12%">Reason</th>
                <th scope="col" style="width: 15%">Actions</th>
              </tr>
            </thead>
            <tbody>
              <%
                  List<?> requestList = (List<?>) request.getAttribute("pendingRequests");
                  DateTimeFormatter inputFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
                  DateTimeFormatter outputFormatter = DateTimeFormatter.ofPattern("dd MMM yyyy, hh:mm a");
                  
                  if (requestList == null || requestList.isEmpty()) {
              %>
              <tr>
                <td colspan="9">No bookings found.</td>
              </tr>
              <%
                  } else {
                      for (Object obj : requestList) {
                          if (obj instanceof Booking) {
                              Booking booking = (Booking) obj;
                              
                              String roomName = booking.getRoom();
                              if ("102".equals(roomName)) {
                                  roomName = "Surau";
                              } else if ("101".equals(roomName)) roomName = "Makmal Komputer";
                              else if ("103".equals(roomName)) roomName = "Surau";
                              else if ("104".equals(roomName)) roomName = "Makmal Sains 1";
                              else if ("105".equals(roomName)) roomName = "Makmal Sains 2";
                              else if ("106".equals(roomName)) roomName = "Bilik Mesyuarat";

                              String purpose = booking.getPurpose();
                              String status = booking.getStatus();
                              Long id = booking.getId();
                              String teacherEmail = booking.getUserEmail();
                              if (teacherEmail == null) teacherEmail = "Unknown";
                              String reason = booking.getRejectionReason();
                              if (reason == null) reason = "-";

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
              <tr id="row-<%= id %>">
                <td><%= id %></td>
                <td><%= teacherEmail %></td>
                <td><%= roomName %></td>
                <td><%= purpose %></td>
                <td><%= start %></td>
                <td><%= end %></td>
                <td class="status-<%= status != null ? status.toLowerCase() : "pending" %>">
                  <%= status %>
                </td>
                <td><%= reason %></td>
                <td>
                  <% if (status != null && status.equalsIgnoreCase("Pending")) { %>
                  <form
                    method="POST"
                    action="${pageContext.request.contextPath}/admin/update"
                    style="display: inline-block; margin-right: 5px;"
                  >
                    <input type="hidden" name="bookingId" value="<%= id %>" />
                    <button type="submit" name="action" value="approve" class="btn btn-success btn-sm">
                      Approve
                    </button>
                  </form>
                  <form
                    method="POST"
                    action="${pageContext.request.contextPath}/admin/update"
                    style="display: inline-block"
                    onsubmit="return promptRejectReason(this)"
                  >
                    <input type="hidden" name="bookingId" value="<%= id %>" />
                    <input type="hidden" name="rejectionReason" value="" />
                    <button type="submit" name="action" value="reject" class="btn btn-danger btn-sm">
                      Reject
                    </button>
                  </form>
                  <% } else { %>
                      <%-- Empty for approved/rejected items to avoid clutter/artifacts --%>
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

        <div class="card shadow-sm mt-4">
          <div class="card-header bg-secondary text-white">
            <h2 class="mb-0">Booking History Search</h2>
          </div>
          <div class="card-body">
            <form method="GET" action="${pageContext.request.contextPath}/admin/search" class="row g-3">
              <div class="col-md-3">
                <label class="form-label">Teacher Email</label>
                <input type="text" name="email" class="form-control" placeholder="e.g. ali@gmail.com">
              </div>
              <div class="col-md-3">
                <label class="form-label">Room</label>
                <select name="room" class="form-select">
                  <option value="">All Rooms</option>
                  <option value="Makmal Komputer">Makmal Komputer</option>
                  <option value="Bilik Seni">Bilik Seni</option>
                  <option value="Surau">Surau</option>
                  <option value="Makmal Sains 1">Makmal Sains 1</option>
                  <option value="Makmal Sains 2">Makmal Sains 2</option>
                  <option value="Bilik Mesyuarat">Bilik Mesyuarat</option>
                </select>
              </div>
              <div class="col-md-2">
                <label class="form-label">Date</label>
                <input type="date" name="date" class="form-control">
              </div>
              <div class="col-md-2">
                <label class="form-label">Status</label>
                <select name="status" class="form-select">
                  <option value="">All Status</option>
                  <option value="Pending">Pending</option>
                  <option value="Approved">Approved</option>
                  <option value="Rejected">Rejected</option>
                </select>
              </div>
              <div class="col-md-2 d-flex align-items-end">
                <button type="submit" class="btn btn-primary w-100">Search</button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>

    <%@ include file="includes/footer.jsp" %>
    <script>
        function promptRejectReason(form) {
            var reason = prompt("Please enter the reason for rejection:");
            if (reason === null) {
                return false; // User cancelled
            }
            if (reason.trim() === "") {
                 reason = "No reason provided";
            }
            form.rejectionReason.value = reason;
            return true;
        }
    </script>
  </body>
</html>
