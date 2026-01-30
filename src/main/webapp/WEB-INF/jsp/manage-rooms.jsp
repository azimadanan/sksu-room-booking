<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>SKSU - Manage Rooms</title>
    
    <!-- Bootstrap 5 CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">
    
    <!-- Custom Theme CSS -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/theme.css">
    <style>
        .manage-grid {
            display: grid;
            grid-template-columns: 1fr 2fr;
            gap: 30px;
        }
        
        /* Form Card */
        .add-room-card {
            background: rgba(255, 255, 255, 0.9);
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            height: fit-content;
        }

        /* Room List */
        .room-list-container {
            background: rgba(255, 255, 255, 0.9);
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        .room-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px;
            border-bottom: 1px solid #eee;
        }
        .room-item:last-child { border-bottom: none; }
        
        .room-details h4 { margin: 0 0 5px 0; color: #6a1b9a; }
        .room-details p { margin: 0; color: #666; font-size: 0.9em; }
        
        .delete-btn {
            background: #ff5252;
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 5px;
            cursor: pointer;
        }
        
        input, textarea {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
        }
    </style>
</head>
<body class="page-layout">
    
    <%@ include file="includes/header.jsp" %>
    
    <div class="main-body-container">
        <%@ include file="includes/sidebar.jsp" %>

        <div class="content">
            <h1>Manage School Rooms</h1>
            <p>Add existing classrooms, labs, or halls to the booking system.</p>

            <div class="manage-grid">
                <!-- Add Room Form -->
                <div class="add-room-card">
                    <h3 style="color: #6a1b9a; margin-top: 0;">Add New Room</h3>
                    <form action="${pageContext.request.contextPath}/admin/rooms/add" method="POST">
                        <label class="form-label">Room Name</label>
                        <input type="text" name="name" class="form-control" placeholder="e.g. Makmal Kimia" required>
                        
                        <label class="form-label">Capacity (Students)</label>
                        <input type="number" name="capacity" class="form-control" placeholder="e.g. 35" required>
                        
                        <label class="form-label">Description</label>
                        <textarea name="description" rows="3" class="form-control" placeholder="Description of equipment..."></textarea>
                        
                        <button type="submit" class="btn btn-primary w-100">Add Room</button>
                    </form>
                </div>

                <!-- Room List -->
                <div class="room-list-container">
                    <h3 style="color: #6a1b9a; margin-top: 0;">Existing Rooms</h3>
                    
                    <c:forEach items="${rooms}" var="room">
                        <div class="room-item">
                            <div class="room-details">
                                <h4>${room.name}</h4>
                                <p>Capacity: ${room.capacity} | ${room.description}</p>
                            </div>
                            <div class="room-actions" style="display: flex; gap: 5px;">
                                <button type="button" class="btn btn-warning btn-sm" onclick="showEditForm('${room.id}', '${room.name}', ${room.capacity}, '${room.description}')">Edit</button>
                                <form action="${pageContext.request.contextPath}/admin/rooms/delete" method="POST" style="margin:0;">
                                    <input type="hidden" name="id" value="${room.id}">
                                    <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Delete this room?')">Delete</button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                    
                    <c:if test="${empty rooms}">
                        <p style="text-align: center; color: #999;">No rooms found. Add one on the left!</p>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
    
    <%@ include file="includes/footer.jsp" %>
    
    <!-- Edit Room Modal -->
    <div id="editModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:1000;">
        <div style="background:white; max-width:400px; margin:100px auto; padding:25px; border-radius:12px;">
            <h3 style="color:#6a1b9a; margin-top:0;">Edit Room</h3>
            <form action="${pageContext.request.contextPath}/admin/rooms/update" method="POST">
                <input type="hidden" name="id" id="editId">
                
                <label class="form-label">Room Name</label>
                <input type="text" name="name" id="editName" class="form-control" required>
                
                <label class="form-label">Capacity</label>
                <input type="number" name="capacity" id="editCapacity" class="form-control" required>
                
                <label class="form-label">Description</label>
                <textarea name="description" id="editDescription" rows="3" class="form-control"></textarea>
                
                <div style="display:flex; gap:10px; margin-top:15px;">
                    <button type="submit" class="btn btn-primary">Save Changes</button>
                    <button type="button" class="btn btn-secondary" onclick="hideEditForm()">Cancel</button>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        function showEditForm(id, name, capacity, description) {
            document.getElementById('editId').value = id;
            document.getElementById('editName').value = name;
            document.getElementById('editCapacity').value = capacity;
            document.getElementById('editDescription').value = description || '';
            document.getElementById('editModal').style.display = 'block';
        }
        
        function hideEditForm() {
            document.getElementById('editModal').style.display = 'none';
        }
    </script>
</body>
</html>
