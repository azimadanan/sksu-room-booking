package com.sksu.controller;

import com.sksu.model.User;
import com.sksu.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;

/**
 * Controller for User Management CRUD operations.
 * Handles UPDATE and DELETE operations to complete full CRUD functionality.
 */
@Controller
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserRepository userRepository;

    // Handle updating user profile (CRUD: UPDATE)
    @PostMapping("/update")
    public String updateUser(@RequestParam String email,
            @RequestParam String firstName,
            @RequestParam String lastName,
            @RequestParam String contactNumber,
            @RequestParam(required = false) String staffId,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        String sessionEmail = (String) session.getAttribute("userEmail");

        // Security check: users can only update their own profile
        if (sessionEmail == null || !sessionEmail.equals(email)) {
            redirectAttributes.addFlashAttribute("error",
                    "You are not authorized to update this profile");
            return "redirect:/home";
        }

        User user = userRepository.findByEmail(email);
        if (user != null) {
            user.setFirstName(firstName);
            user.setLastName(lastName);
            user.setContactNumber(contactNumber);
            if (staffId != null && !staffId.isEmpty()) {
                user.setStaffId(staffId);
            }

            userRepository.save(user);
            redirectAttributes.addFlashAttribute("message",
                    "Profile updated successfully");
        } else {
            redirectAttributes.addFlashAttribute("error",
                    "User not found");
        }

        return "redirect:/home";
    }

    // Handle deleting user account (CRUD: DELETE)
    @PostMapping("/delete")
    public String deleteUser(@RequestParam String email,
            @RequestParam String confirmPassword,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        String sessionEmail = (String) session.getAttribute("userEmail");

        // Security check: users can only delete their own account
        if (sessionEmail == null || !sessionEmail.equals(email)) {
            redirectAttributes.addFlashAttribute("error",
                    "You are not authorized to delete this account");
            return "redirect:/home";
        }

        User user = userRepository.findByEmail(email);
        if (user != null && user.getPassword().equals(confirmPassword)) {
            // Delete the user account
            userRepository.deleteById(user.getId());

            // Clear session
            session.invalidate();

            redirectAttributes.addFlashAttribute("message",
                    "Account deleted successfully");
            return "redirect:/login";
        } else {
            redirectAttributes.addFlashAttribute("error",
                    "Invalid password or user not found");
            return "redirect:/home";
        }
    }

    // Admin-only: Delete any user account
    @PostMapping("/admin/delete")
    public String adminDeleteUser(@RequestParam Long userId,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        String sessionEmail = (String) session.getAttribute("userEmail");
        if (sessionEmail == null) {
            return "redirect:/login";
        }

        User admin = userRepository.findByEmail(sessionEmail);
        if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getRole())) {
            redirectAttributes.addFlashAttribute("error",
                    "You are not authorized to perform this action");
            return "redirect:/home";
        }

        // Prevent admin from deleting themselves
        if (admin.getId().equals(userId)) {
            redirectAttributes.addFlashAttribute("error",
                    "You cannot delete your own account");
            return "redirect:/admin/users";
        }

        userRepository.deleteById(userId);
        redirectAttributes.addFlashAttribute("message",
                "User deleted successfully");

        return "redirect:/admin/users";
    }
}
