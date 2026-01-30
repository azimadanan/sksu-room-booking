package com.sksu.model;

public class BookingRequest {
    public String room;
    public String purpose;
    public String classUsed;
    public int students;
    public String equipment;
    public String startTime;
    public String endTime;

    public String getRoom() { return room; }
    public void setRoom(String room) { this.room = room; }
    public String getPurpose() { return purpose; }
    public void setPurpose(String purpose) { this.purpose = purpose; }
    public String getClassUsed() { return classUsed; }
    public void setClassUsed(String classUsed) { this.classUsed = classUsed; }
    public int getStudents() { return students; }
    public void setStudents(int students) { this.students = students; }
    public String getEquipment() { return equipment; }
    public void setEquipment(String equipment) { this.equipment = equipment; }
    public String getStartTime() { return startTime; }
    public void setStartTime(String startTime) { this.startTime = startTime; }
    public String getEndTime() { return endTime; }
    public void setEndTime(String endTime) { this.endTime = endTime; }
}