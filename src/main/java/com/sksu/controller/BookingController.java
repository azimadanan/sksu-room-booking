package com.sksu.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.sksu.model.Booking; // Entity
import com.sksu.model.BookingDetails;
import com.sksu.model.BookingRequest;
import com.sksu.repository.BookingRepository;

@Controller
@RequestMapping("/booking")
@SessionAttributes("userEmail")
public class BookingController {

    private final BookingRepository bookingRepository;
    private final com.sksu.repository.RoomRepository roomRepository; // Inject RoomRepository
    private final com.sksu.repository.UserRepository userRepository; // Add UserRepository
    private final com.sksu.repository.NotificationRepository notificationRepository; // Add NotificationRepository

    public BookingController(BookingRepository bookingRepository,
            com.sksu.repository.RoomRepository roomRepository,
            com.sksu.repository.UserRepository userRepository,
            com.sksu.repository.NotificationRepository notificationRepository) {
        this.bookingRepository = bookingRepository;
        this.roomRepository = roomRepository;
        this.userRepository = userRepository;
        this.notificationRepository = notificationRepository;
    }

    @GetMapping("/new")
    public String showBookingForm(Model model,
            @RequestParam(required = false) String roomId,
            @SessionAttribute(name = "userEmail", required = false) String userEmail) {
        if (userEmail == null) {
            return "redirect:/login";
        }

        // Fetch user for header and admin check
        com.sksu.model.User user = userRepository.findByEmail(userEmail);
        model.addAttribute("user", user);

        // Check if admin to show admin links in sidebar
        if (user != null && "ADMIN".equalsIgnoreCase(user.getRole())) {
            model.addAttribute("isAdmin", true);
        }

        model.addAttribute("selectedRoomId", roomId);
        model.addAttribute("bookingRequest", new BookingRequest());
        model.addAttribute("rooms", roomRepository.findAll()); // Add rooms to model
        return "booking-form";
    }

    @PostMapping("/submit")
    public String submitBooking(@ModelAttribute BookingRequest request,
            @SessionAttribute("userEmail") String userEmail,
            RedirectAttributes redirectAttributes) {

        // Validate capacity - request.getRoom() now contains the room ID
        com.sksu.model.Room room = roomRepository.findById(request.getRoom()).orElse(null);

        if (room == null) {
            redirectAttributes.addFlashAttribute("error", "Selected room not found. Please try again.");
            return "redirect:/booking/new";
        }

        if (request.getStudents() > room.getCapacity()) {
            redirectAttributes.addFlashAttribute("error", "Number of students (" + request.getStudents()
                    + ") exceeds room capacity (" + room.getCapacity() + "). Maximum allowed: " + room.getCapacity());
            redirectAttributes.addFlashAttribute("bookingRequest", request); // Keep their input
            return "redirect:/booking/new?roomId=" + request.getRoom();
        }

        // Check for time conflicts with approved bookings
        java.util.List<Booking> approvedBookings = bookingRepository.findByRoomAndStatus(room.getName(), "Approved");
        for (Booking existing : approvedBookings) {
            // Time overlap check: (new.start < existing.end) AND (new.end > existing.start)
            if (request.getStartTime().compareTo(existing.getEnd()) < 0 &&
                    request.getEndTime().compareTo(existing.getStart()) > 0) {

                // Get the teacher's name who made the booking
                com.sksu.model.User bookedByUser = userRepository.findByEmail(existing.getUserEmail());
                String teacherName = existing.getUserEmail(); // Default to email
                if (bookedByUser != null && bookedByUser.getFirstName() != null) {
                    teacherName = bookedByUser.getFirstName();
                    if (bookedByUser.getLastName() != null) {
                        teacherName += " " + bookedByUser.getLastName();
                    }
                }

                // Format times for better readability
                String startTime = existing.getStart();
                String endTime = existing.getEnd();
                try {
                    java.time.LocalDateTime startDt = java.time.LocalDateTime.parse(startTime,
                            java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"));
                    java.time.LocalDateTime endDt = java.time.LocalDateTime.parse(endTime,
                            java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"));

                    java.time.format.DateTimeFormatter displayFormat = java.time.format.DateTimeFormatter
                            .ofPattern("dd MMM yyyy, hh:mm a");
                    startTime = startDt.format(displayFormat);
                    endTime = endDt.format(displayFormat);
                } catch (Exception e) {
                    // Keep original format if parsing fails
                }

                String conflictMsg = "❌ ROOM ALREADY BOOKED!\n\n" +
                        "Room: " + room.getName() + "\n" +
                        "Booked by: " + teacherName + "\n" +
                        "Time: " + startTime + " - " + endTime + "\n\n" +
                        "Please choose a different room or time slot.";

                redirectAttributes.addFlashAttribute("error", conflictMsg);
                redirectAttributes.addFlashAttribute("bookingRequest", request);
                return "redirect:/booking/new?roomId=" + request.getRoom();
            }
        }

        // Store room NAME (not ID) for display in booking lists
        Booking newBooking = new Booking(
                request.getPurpose(),
                room.getName(), // Use room name for display
                request.getStartTime(),
                request.getEndTime(),
                request.getStudents(),
                "Pending",
                userEmail);

        bookingRepository.save(newBooking);

        redirectAttributes.addFlashAttribute("submittedBooking", request);
        return "redirect:/booking/summary";
    }

    @GetMapping("/summary")
    public String showBookingSummary(Model model, @RequestParam(required = false) Long bookingId) {
        // If we want to show the saved booking, we could fetch it by ID?
        // But the original logic used a new BookingDetails() or expected flash
        // attributes?
        // The original code: model.addAttribute("booking", new BookingDetails());
        // I'll keep it as is to minimize regression, assuming summary.jsp uses the
        // flash attribute or this object.
        model.addAttribute("booking", new BookingDetails());
        return "booking-summary";
    }

    @PostMapping("/cancel")
    public String cancelBooking(@RequestParam Long bookingId,
            @SessionAttribute("userEmail") String userEmail,
            RedirectAttributes redirectAttributes) {

        // Find the booking
        Booking booking = bookingRepository.findById(bookingId).orElse(null);

        if (booking == null) {
            redirectAttributes.addFlashAttribute("error", "Booking not found.");
            return "redirect:/home";
        }

        // Verify ownership - only the teacher who made the booking can cancel it
        if (!booking.getUserEmail().equals(userEmail)) {
            redirectAttributes.addFlashAttribute("error", "You can only cancel your own bookings.");
            return "redirect:/home";
        }

        // Check status - only Pending or Approved bookings can be cancelled
        if (!"Pending".equals(booking.getStatus()) && !"Approved".equals(booking.getStatus())) {
            redirectAttributes.addFlashAttribute("error",
                    "This booking cannot be cancelled (status: " + booking.getStatus() + ").");
            return "redirect:/home";
        }

        // Store booking details for notification before deleting
        String purpose = booking.getPurpose();
        String room = booking.getRoom();
        String startTime = booking.getStart();
        String endTime = booking.getEnd();

        // Delete the booking (frees up the time slot)
        bookingRepository.deleteById(bookingId);

        // Notify admin about cancellation
        com.sksu.model.User teacher = userRepository.findByEmail(userEmail);
        String teacherName = userEmail;
        if (teacher != null && teacher.getFirstName() != null) {
            teacherName = teacher.getFirstName();
            if (teacher.getLastName() != null) {
                teacherName += " " + teacher.getLastName();
            }
        }

        // Create notification for admin
        String notificationMsg = "Booking cancelled by " + teacherName + ": " + purpose +
                " (" + room + ") from " + startTime + " to " + endTime;

        // Find all admins and notify them
        java.util.List<com.sksu.model.User> admins = userRepository.findAll().stream()
                .filter(u -> "ADMIN".equalsIgnoreCase(u.getRole()))
                .collect(java.util.stream.Collectors.toList());

        for (com.sksu.model.User admin : admins) {
            com.sksu.model.Notification notification = new com.sksu.model.Notification(notificationMsg, admin);
            notificationRepository.save(notification);
        }

        redirectAttributes.addFlashAttribute("success",
                "Booking cancelled successfully! The time slot is now available.");
        return "redirect:/home";
    }

    // Handle deleting/canceling a booking (CRUD: DELETE)
    @PostMapping("/delete")
    public String deleteBooking(@RequestParam Long bookingId,
            @SessionAttribute("userEmail") String userEmail,
            RedirectAttributes redirectAttributes) {

        // Find the booking
        Booking booking = bookingRepository.findById(bookingId).orElse(null);

        // Security check: only allow users to delete their own bookings
        if (booking != null && booking.getUserEmail().equals(userEmail)) {
            bookingRepository.deleteById(bookingId);
            redirectAttributes.addFlashAttribute("message",
                    "Booking cancelled successfully");
        } else {
            redirectAttributes.addFlashAttribute("error",
                    "You are not authorized to delete this booking");
        }

        return "redirect:/home";
    }
}