package com.sksu.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;

import com.sksu.model.User;
import com.sksu.repository.BookingRepository;
import com.sksu.repository.RoomRepository;
import com.sksu.repository.UserRepository;
import com.sksu.service.BookingService;
import com.sksu.service.LoginAttemptService;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

// @Controller: Tells Spring "This class handles web pages and URLs".
@Controller
@RequestMapping("/") // Base URL. All links start from here.
@SessionAttributes("userEmail") // Keeps "userEmail" in memory as long as the browser is open (Simulates being
                                // logged in).
public class HomeController {

    // Dependencies (Tools we need)
    private final BookingRepository bookingRepository;
    private final RoomRepository roomRepository;
    private final UserRepository userRepository;
    private final BookingService bookingService; // Our Logic Handler
    private final LoginAttemptService loginAttemptService; // Anti-Brute Force

    // Constructor Injection: Spring provides these tools automatically.
    public HomeController(BookingRepository bookingRepository,
            RoomRepository roomRepository,
            UserRepository userRepository,
            BookingService bookingService,
            LoginAttemptService loginAttemptService) {
        this.bookingRepository = bookingRepository;
        this.roomRepository = roomRepository;
        this.userRepository = userRepository;
        this.bookingService = bookingService;
        this.loginAttemptService = loginAttemptService;
    }

    // --- 1. LOGIN & LOGOUT ---

    @GetMapping("/")
    public String defaultRoot() {
        return "redirect:/login"; // Redirect root URL to login
    }

    @GetMapping("/login")
    public String loginPage(SessionStatus sessionStatus) {
        // Clear previous session data safely when visiting login page
        sessionStatus.setComplete();
        return "login"; // Show login.jsp
    }

    @PostMapping("/login/submit")
    public String processLogin(@RequestParam String email,
            @RequestParam String password,
            @RequestParam(defaultValue = "USER") String expectedRole,
            Model model) {

        // Basic Validation
        if (email == null || email.isEmpty() || password == null || password.isEmpty()) {
            model.addAttribute("error", "Please enter email and password.");
            return "login";
        }

        // ANTI-BRUTE FORCE: Check if account is locked
        if (loginAttemptService.isBlocked(email)) {
            long remainingMinutes = loginAttemptService.getRemainingLockTime(email);
            model.addAttribute("error",
                    "Account locked due to too many failed attempts. Try again in " + remainingMinutes + " minutes.");
            return "login";
        }

        // Database Lookup: Find user by email
        User user = userRepository.findByEmail(email);

        // Security Check: Does user exist? Does password match?
        if (user != null && user.getPassword().equals(password)) {

            // Authorization Check: Prevent User from logging in as Admin
            if (!user.getRole().equalsIgnoreCase(expectedRole)) {
                loginAttemptService.loginFailed(email); // Count as failed attempt
                model.addAttribute("error", "Access Denied: You are not authorized as " + expectedRole);
                return "login";
            }

            // Success! Clear failed attempts and save email to session
            loginAttemptService.loginSucceeded(email);
            model.addAttribute("userEmail", email);

            // Redirect based on Role
            if ("ADMIN".equalsIgnoreCase(user.getRole())) {
                return "redirect:/admin/dashboard";
            } else {
                return "redirect:/home";
            }
        } else {
            // Failed login - track attempt
            loginAttemptService.loginFailed(email);
            int remaining = loginAttemptService.getRemainingAttempts(email);

            if (remaining > 0) {
                model.addAttribute("error", "Invalid email or password. " + remaining + " attempts remaining.");
            } else {
                model.addAttribute("error", "Account locked due to too many failed attempts. Try again in 15 minutes.");
            }
            return "login";
        }
    }

    // --- FORGOT PASSWORD ---

    @GetMapping("/forgot-password")
    public String forgotPasswordPage() {
        return "forgot-password";
    }

    @PostMapping("/forgot-password/submit")
    public String processForgotPassword(@RequestParam String email, Model model) {
        // Find user by email
        User user = userRepository.findByEmail(email);

        if (user == null) {
            model.addAttribute("error", "No account found with this email address.");
            return "forgot-password";
        }

        // Send password via email
        try {
            bookingService.sendPasswordRecoveryEmail(user.getEmail(), user.getPassword());
            model.addAttribute("success", "Your password has been sent to " + email + ". Please check your inbox.");
        } catch (Exception e) {
            model.addAttribute("success", "Your password is: " + user.getPassword() + " (Email service unavailable)");
        }

        return "forgot-password";
    }

    // --- 2. USER DASHBOARD (TEACHERS) ---

    @GetMapping("/home")
    public String homeDashboardPage(Model model,
            @SessionAttribute(name = "userEmail", required = false) String userEmail) {
        if (userEmail == null)
            return "redirect:/login"; // Not logged in? Go to login.

        // Get notifications for this user (inbox)
        User user = userRepository.findByEmail(userEmail);
        model.addAttribute("user", user);

        // Fetch user's own bookings to display "My Recent Bookings"
        // Only show bookings made by this specific teacher
        model.addAttribute("bookings", bookingRepository.findByUserEmail(userEmail));

        return "home-dashboard";
    }

    @GetMapping("/rooms")
    public String roomListPage(Model model, @SessionAttribute(name = "userEmail", required = false) String userEmail) {
        if (userEmail == null)
            return "redirect:/login";

        // Fetch user for header
        User user = userRepository.findByEmail(userEmail);
        model.addAttribute("user", user);

        // Check if admin to show admin links in sidebar
        if (user != null && "ADMIN".equalsIgnoreCase(user.getRole())) {
            model.addAttribute("isAdmin", true);
        }

        model.addAttribute("rooms", roomRepository.findAll());
        return "rooms";
    }

    @GetMapping("/calendar")
    public String calendarPage(Model model, @SessionAttribute(name = "userEmail", required = false) String userEmail) {
        if (userEmail == null)
            return "redirect:/login";

        // Fetch user for header display
        User user = userRepository.findByEmail(userEmail);
        model.addAttribute("user", user);

        // Check if admin to show admin links in sidebar
        if (user != null && "ADMIN".equalsIgnoreCase(user.getRole())) {
            model.addAttribute("isAdmin", true);
        }

        // Send data to the calendar view
        model.addAttribute("bookings", bookingRepository.findAll());
        model.addAttribute("rooms", roomRepository.findAll());
        return "calendar";
    }

    // --- 3. ADMIN DASHBOARD ---

    @GetMapping("/admin/dashboard")
    public String adminDashboard(Model model,
            @SessionAttribute(name = "userEmail", required = false) String userEmail) {
        if (userEmail == null)
            return "redirect:/login";

        // Double Security Check: Is this person REALY an admin?
        User user = userRepository.findByEmail(userEmail);
        if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) {
            return "redirect:/home"; // Stop hackers
        }
        model.addAttribute("user", user);

        // Show all bookings
        model.addAttribute("pendingRequests", bookingRepository.findAll());
        model.addAttribute("isAdmin", true); // Enable admin links in sidebar
        return "admin-dashboard";
    }

    // Admin Booking Search
    @GetMapping("/admin/search")
    public String adminSearch(
            @RequestParam(required = false) String email,
            @RequestParam(required = false) String room,
            @RequestParam(required = false) String date,
            @RequestParam(required = false) String status,
            Model model,
            @SessionAttribute(name = "userEmail", required = false) String userEmail) {

        if (userEmail == null)
            return "redirect:/login";

        User user = userRepository.findByEmail(userEmail);
        if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) {
            return "redirect:/home";
        }
        model.addAttribute("user", user);

        // Get all bookings and filter
        java.util.List<com.sksu.model.Booking> allBookings = bookingRepository.findAll();
        java.util.List<com.sksu.model.Booking> filteredBookings = new java.util.ArrayList<>();

        for (com.sksu.model.Booking booking : allBookings) {
            boolean matches = true;

            // Filter by email
            if (email != null && !email.isEmpty()) {
                if (booking.getUserEmail() == null ||
                        !booking.getUserEmail().toLowerCase().contains(email.toLowerCase())) {
                    matches = false;
                }
            }

            // Filter by room (convert room ID to name for matching)
            if (room != null && !room.isEmpty() && matches) {
                String bookingRoom = booking.getRoom();
                // Convert ID to name
                if ("101".equals(bookingRoom))
                    bookingRoom = "Makmal Komputer";
                else if ("102".equals(bookingRoom))
                    bookingRoom = "Bilik Seni";
                else if ("103".equals(bookingRoom))
                    bookingRoom = "Surau";
                else if ("104".equals(bookingRoom))
                    bookingRoom = "Makmal Sains 1";
                else if ("105".equals(bookingRoom))
                    bookingRoom = "Makmal Sains 2";
                else if ("106".equals(bookingRoom))
                    bookingRoom = "Bilik Mesyuarat";

                if (!bookingRoom.equalsIgnoreCase(room)) {
                    matches = false;
                }
            }

            // Filter by date
            if (date != null && !date.isEmpty() && matches) {
                String startDate = booking.getStart();
                if (startDate == null || !startDate.startsWith(date)) {
                    matches = false;
                }
            }

            // Filter by status
            if (status != null && !status.isEmpty() && matches) {
                if (!status.equalsIgnoreCase(booking.getStatus())) {
                    matches = false;
                }
            }

            if (matches) {
                filteredBookings.add(booking);
            }
        }

        model.addAttribute("searchResults", filteredBookings);
        model.addAttribute("resultCount", filteredBookings.size());
        model.addAttribute("emailFilter", email);
        model.addAttribute("roomFilter", room);
        model.addAttribute("dateFilter", date);
        model.addAttribute("statusFilter", status);
        model.addAttribute("isAdmin", true);

        return "admin-search";
    }

    // When Admin clicks "Approve" or "Reject"
    @PostMapping("/admin/update")
    public String updateBookingStatus(@RequestParam Long bookingId,
            @RequestParam String action,
            @RequestParam(required = false) String rejectionReason) {

        // DELEGATE TO SERVICE: The Controller doesn't do logic. It asks the Service to
        // do it.
        // This keeps the Controller clean.
        bookingService.processBookingDecision(bookingId, action, rejectionReason);

        return "redirect:/admin/dashboard";
    }

    // --- 4. REGISTRATION ---

    @GetMapping("/register")
    public String registerPage() {
        return "register";
    }

    @PostMapping("/register/submit")
    public String processRegister(@RequestParam String email,
            @RequestParam String password,
            @RequestParam String firstName,
            @RequestParam String lastName,
            @RequestParam String contactNumber,
            @RequestParam(required = false) String gender,
            @RequestParam(required = false) String staffId,
            @RequestParam(defaultValue = "USER") String role,
            Model model) {

        // Validation Checks
        if (!email.toLowerCase().endsWith("@gmail.com")) {
            model.addAttribute("error", "Registration restricted to Gmail only.");
            return "register";
        }

        if (userRepository.findByEmail(email) != null) {
            model.addAttribute("error", "Email already registered.");
            return "register";
        }

        // First User Rule: The first person to ever register becomes Admin.
        if (userRepository.count() == 0) {
            role = "ADMIN";
        }

        // Save new user
        User newUser = new User(email, password, role, firstName, lastName, contactNumber, gender, staffId);
        userRepository.save(newUser);

        return "redirect:/login";
    }

    // --- CALENDAR API SIMULATION HELPER ---
    public static String getBookingDate(String datetimeString) {
        try {
            // Parses YYYY-MM-DDTHH:MM and returns YYYY-MM-DD
            LocalDateTime dateTime = LocalDateTime.parse(datetimeString, DateTimeFormatter.ISO_LOCAL_DATE_TIME);
            return dateTime.format(DateTimeFormatter.ISO_LOCAL_DATE);
        } catch (Exception e) {
            // Fallback
            return datetimeString.split("T")[0];
        }
    }
}