package com.sksu.controller;

import com.sksu.model.Room;
import com.sksu.model.User;
import com.sksu.repository.RoomRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/admin/rooms")
public class RoomController {

    @Autowired
    private RoomRepository roomRepository;

    @Autowired
    private com.sksu.repository.UserRepository userRepository; // Inject UserRepository

    // List all rooms (Management Page)
    @GetMapping
    public String listRooms(HttpSession session, Model model) {
        String userEmail = (String) session.getAttribute("userEmail");
        if (userEmail == null) {
            return "redirect:/login";
        }

        User user = userRepository.findByEmail(userEmail);
        if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) {
            return "redirect:/home"; // or /login
        }

        List<Room> rooms = roomRepository.findAll();
        // Sort rooms by name for better UX
        rooms.sort((r1, r2) -> r1.getName().compareToIgnoreCase(r2.getName()));

        model.addAttribute("rooms", rooms);
        model.addAttribute("isAdmin", true); // Pass isAdmin flag for sidebar
        return "manage-rooms";
    }

    // Handle adding a new room
    @PostMapping("/add")
    public String addRoom(@RequestParam String name,
            @RequestParam int capacity,
            @RequestParam String description,
            HttpSession session) {
        String userEmail = (String) session.getAttribute("userEmail");
        if (userEmail == null) {
            return "redirect:/login";
        }

        User user = userRepository.findByEmail(userEmail);
        if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) {
            return "redirect:/home";
        }

        // Generate a unique ID for the new room
        String newId = String.valueOf(100 + roomRepository.count() + 1);
        Room newRoom = new Room(newId, name, capacity, description);
        roomRepository.save(newRoom);
        return "redirect:/admin/rooms";
    }

    // Handle updating an existing room (CRUD: UPDATE)
    @PostMapping("/update")
    public String updateRoom(@RequestParam String id,
            @RequestParam String name,
            @RequestParam int capacity,
            @RequestParam String description,
            HttpSession session) {
        String userEmail = (String) session.getAttribute("userEmail");
        if (userEmail == null) {
            return "redirect:/login";
        }

        User user = userRepository.findByEmail(userEmail);
        if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) {
            return "redirect:/home";
        }

        // Find existing room and update its properties
        Room existingRoom = roomRepository.findById(id).orElse(null);
        if (existingRoom != null) {
            existingRoom.setName(name);
            existingRoom.setCapacity(capacity);
            existingRoom.setDescription(description);
            roomRepository.save(existingRoom);
        }

        return "redirect:/admin/rooms";
    }

    // Handle deleting a room
    @PostMapping("/delete")
    public String deleteRoom(@RequestParam String id, HttpSession session) {
        String userEmail = (String) session.getAttribute("userEmail");
        if (userEmail == null) {
            return "redirect:/login";
        }

        User user = userRepository.findByEmail(userEmail);
        if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) {
            return "redirect:/home";
        }

        roomRepository.deleteById(id);
        return "redirect:/admin/rooms";
    }
}
