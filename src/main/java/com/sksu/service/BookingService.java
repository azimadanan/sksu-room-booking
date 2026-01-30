package com.sksu.service;

import com.sksu.model.Booking;
import com.sksu.model.Notification;
import com.sksu.model.User;
import com.sksu.repository.BookingRepository;
import com.sksu.repository.NotificationRepository;
import com.sksu.repository.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service // Marks this class as a Service (Business Logic Layer)
public class BookingService {

    private final BookingRepository bookingRepository;
    private final NotificationRepository notificationRepository;
    private final UserRepository userRepository;
    private final EmailService emailService;

    // Constructor Injection: Spring Boot automatically gives us these tools to use.
    public BookingService(BookingRepository bookingRepository,
            NotificationRepository notificationRepository,
            UserRepository userRepository,
            EmailService emailService) {
        this.bookingRepository = bookingRepository;
        this.notificationRepository = notificationRepository;
        this.userRepository = userRepository;
        this.emailService = emailService;
    }

    // @Transactional means: "Do everything in this method together. If one thing
    // fails, undo everything."
    // This prevents half-saved data errors.
    @Transactional
    public void processBookingDecision(Long bookingId, String action, String adminComment) {
        // 1. Fetch the Booking from Database
        // .orElseThrow() is a safety check: If the ID doesn't exist, stop immediately
        // with an error.
        Booking booking = bookingRepository.findById(bookingId)
                .orElseThrow(() -> new IllegalArgumentException("Booking ID not found: " + bookingId));

        // 2. Decide Status based on Admin's action ("approve" or "reject")
        String newStatus = action.equalsIgnoreCase("approve") ? "Approved" : "Rejected";
        booking.setStatus(newStatus);

        // 3. Save the Admin's Comment (if they wrote one)
        if (adminComment != null && !adminComment.trim().isEmpty()) {
            booking.setRejectionReason(adminComment);
        }

        // 4. Save the updated Booking back to the Database
        bookingRepository.save(booking);

        // 5. Create an In-App Notification (So they see it on the dashboard)
        createSystemNotification(booking, newStatus, adminComment);

        // 6. Send an Email (So they know even if they are offline)
        sendEmailNotification(booking, newStatus, adminComment);
    }

    // Helper method to save a notification to the database
    private void createSystemNotification(Booking booking, String newStatus, String comment) {
        // Find who made the booking
        User recipient = userRepository.findByEmail(booking.getUserEmail());
        if (recipient == null)
            return; // Safety check: If user was deleted, don't crash.

        String message = "Your booking for " + booking.getRoom() + " on " + booking.getStart() + " has been "
                + newStatus + ".";
        if (comment != null && !comment.isEmpty()) {
            message += " Admin Note: " + comment;
        }

        // Save the notification
        Notification notification = new Notification(message, recipient);
        notificationRepository.save(notification);
    }

    // Helper method to send the actual email via Gmail
    private void sendEmailNotification(Booking booking, String status, String comment) {
        String details = "Room: " + booking.getRoom() + "\n" +
                "Date: " + booking.getStart() + "\n" +
                "Purpose: " + booking.getPurpose();

        // Delegate to EmailService to handle the technical mailing part
        emailService.sendBookingStatusEmail(booking.getUserEmail(), status, comment, details);
    }

    // Send password recovery email
    public void sendPasswordRecoveryEmail(String email, String password) {
        String subject = "SKSU Room Booking - Password Recovery";
        String body = "Hello,\n\n" +
                "You requested your password for SKSU Room Booking System.\n\n" +
                "Your password is: " + password + "\n\n" +
                "Please keep this safe and consider changing it after login.\n\n" +
                "Best regards,\n" +
                "SKSU Room Booking System";

        emailService.sendGenericEmail(email, subject, body);
    }
}
