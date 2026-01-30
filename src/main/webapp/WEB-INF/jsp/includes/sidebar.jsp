<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>

<%
  // Determine home URL based on user role
  String homeUrl = "/home";
  Boolean sidebarIsAdmin = (Boolean) request.getAttribute("isAdmin");
  if (sidebarIsAdmin != null && sidebarIsAdmin) {
    homeUrl = "/admin/dashboard";
  }
%>

<div class="sidebar">
  <!-- Sidebar Logo -->
  <div style="text-align: center; padding: 20px 0">
    <a href="<%= homeUrl %>">
      <img
        src="https://upload.wikimedia.org/wikipedia/ms/1/1c/Lencana_Sekolah_Kebangsaan_Saujana_Utama.jpg"
        alt="SKSU Logo"
        class="sidebar-logo-img"
      />
    </a>
  </div>


  <div class="sidebar-nav">
    <ul>
      <li>
        <a
          href="<%= homeUrl %>"
          class="${pageContext.request.requestURI.contains('/home') || pageContext.request.requestURI.contains('/admin/dashboard') ? 'active' : ''}"
          >🏠 Home Dashboard</a
        >
      </li>
      <li>
        <a
          href="/rooms"
          class="${pageContext.request.requestURI.endsWith('/rooms') ? 'active' : ''}"
          >📄 Room List Catalog</a
        >
      </li>
      <li>
        <a
          href="/booking/new"
          class="${pageContext.request.requestURI.contains('/booking/new') ? 'active' : ''}"
          >➕ New Booking</a
        >
      </li>
      <li>
        <a
          href="/calendar"
          class="${pageContext.request.requestURI.contains('/calendar') ? 'active' : ''}"
          >📅 View Calendar</a
        >
      </li>

      <%-- Display Admin-specific links ONLY if the user is an admin --%>
      <c:if test="${isAdmin}">
        <li>
          <a
            href="/admin/rooms"
            class="${pageContext.request.requestURI.contains('/admin/rooms') ? 'active' : ''}"
            >🏫 Manage Rooms</a
          >
        </li>
      </c:if>
    </ul>
  </div>

  <div class="sidebar-info" style="padding-bottom: 20px">
    <a
      href="/login"
      style="
        color: var(--color-sandstone);
        text-decoration: none;
        display: block;
        text-align: center;
        font-weight: bold;
        margin-top: 10px;
      "
    >
      ➡️ Logout
    </a>
  </div>
</div>
