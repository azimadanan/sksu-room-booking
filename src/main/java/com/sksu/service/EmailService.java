package com.sksu.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class EmailService {

    @Autowired
    private JavaMailSender mailSender;

    public void sendBookingStatusEmail(String to, String status, String reason, String bookingDetails) {
        if (to == null || to.isEmpty()) {
            System.out.println("No email provided for notification.");
            return;
        }

        SimpleMailMessage message = new SimpleMailMessage();
        message.setFrom("your-email@gmail.com"); // Will be overridden by properties usually, but good to set
        message.setTo(to);

        String subject = "SKSU Room Booking Status: " + status;
        message.setSubject(subject);

        StringBuilder text = new StringBuilder();
        text.append("====================================================\n");
        text.append("      SKSU ROOM BOOKING NOTIFICATION SYSTEM      \n");
        text.append("====================================================\n\n");

        text.append("Status Update > ").append(status.toUpperCase()).append("\n\n");

        text.append("Dear User,\n\n");
        text.append("This is an automated message regarding your facility request.\n");
        text.append("----------------------------------------------------\n");

        text.append(bookingDetails).append("\n");

        if (reason != null && !reason.isEmpty()) {
            text.append("Admin Comment: ").append(reason).append("\n");
        }
        text.append("----------------------------------------------------\n\n");

        if ("Approved".equalsIgnoreCase(status)) {
            text.append("IMPORTANT:\n");
            text.append("1. Please collect keys from the Administration Office.\n");
            text.append("2. Ensure the room is clean before leaving.\n\n");
        }

        text.append("System Generated Email. Please do not reply.");

        message.setText(text.toString());

        try {
            mailSender.send(message);
            System.out.println("Email sent successfully to " + to);
        } catch (Exception e) {
            System.err.println("Error sending email: " + e.getMessage());
        }
    }

    // Generic email method for password recovery and other purposes
    public void sendGenericEmail(String to, String subject, String body) {
        if (to == null || to.isEmpty()) {
            System.out.println("No email provided for notification.");
            return;
        }

        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(to);
        message.setSubject(subject);
        message.setText(body);

        try {
            mailSender.send(message);
            System.out.println("Email sent successfully to " + to);
        } catch (Exception e) {
            System.err.println("Error sending email: " + e.getMessage());
            throw new RuntimeException("Failed to send email", e);
        }
    }
}
