package com.sksu.model;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "bookings")
public class Booking {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String purpose;
    private String room;
    private String start; // Assuming ISO-8601 string for simplicity matching current logic
                          // "YYYY-MM-DDTHH:MM"
    private String end;
    private String status;
    private int students;
    private String userEmail;
    private String rejectionReason;

    public Booking() {
    }

    public Booking(String purpose, String room, String start, String end, int students, String status,
            String userEmail) {
        this.purpose = purpose;
        this.room = room;
        this.start = start;
        this.end = end;
        this.students = students;
        this.status = status;
        this.userEmail = userEmail;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getPurpose() {
        return purpose;
    }

    public void setPurpose(String purpose) {
        this.purpose = purpose;
    }

    public String getRoom() {
        return room;
    }

    public void setRoom(String room) {
        this.room = room;
    }

    public String getStart() {
        return start;
    }

    public void setStart(String start) {
        this.start = start;
    }

    public String getEnd() {
        return end;
    }

    public void setEnd(String end) {
        this.end = end;
    }

    public int getStudents() {
        return students;
    }

    public void setStudents(int students) {
        this.students = students;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getUserEmail() {
        return userEmail;
    }

    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }

    public String getRejectionReason() {
        return rejectionReason;
    }

    public void setRejectionReason(String rejectionReason) {
        this.rejectionReason = rejectionReason;
    }

    // Convenience methods to match record style accessors if needed by JSP (but
    // JSPs usually use getters, record accessors were .room())
    // We will need to update JSP to use .room instead of .room() or EL will handle
    // it if it is a property.
    // JSP EL ${booking.room} calls getRoom(), so this is fine.
    // However, existing JAVA code calls booking.room(). We might need to refactor
    // that or add these methods.

    public String purpose() {
        return purpose;
    }

    public String room() {
        return room;
    }

    public String start() {
        return start;
    }

    public String end() {
        return end;
    }

    public String status() {
        return status;
    }

    public String userEmail() {
        return userEmail;
    }
}
