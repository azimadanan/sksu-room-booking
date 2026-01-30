<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<header class="main-header">
  <div class="logo-container">
    <%
      com.sksu.model.User currentUser = (com.sksu.model.User) request.getAttribute("user");
      String headerTitle = "SKSU ROOM BOOKING SYSTEM";
      String headerLink = "/home";
      
      if (currentUser != null && currentUser.getFirstName() != null) {
          String fullName = currentUser.getFirstName();
          if (currentUser.getLastName() != null) {
              fullName += " " + currentUser.getLastName();
          }
          headerTitle = "Welcome " + fullName + " to SKSU Room Booking";
      }
      
      // Check if admin to set proper home link
      Boolean headerIsAdmin = (Boolean) request.getAttribute("isAdmin");
      if (headerIsAdmin != null && headerIsAdmin) {
          headerLink = "/admin/dashboard";
      }
    %>
    <a href="<%= headerLink %>" style="text-decoration: none; color: inherit;">
      <h1 class="system-title"><%= headerTitle %></h1>
    </a>
  </div>
</header>
