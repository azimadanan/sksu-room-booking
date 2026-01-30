package com.sksu.config;

import com.sksu.model.Room;
import com.sksu.repository.RoomRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

/**
 * DataInitializer runs on application startup.
 * It seeds the database with initial room data if the rooms table is empty.
 */
@Component
public class DataInitializer implements CommandLineRunner {

    private final RoomRepository roomRepository;
    private final com.sksu.repository.UserRepository userRepository;

    public DataInitializer(RoomRepository roomRepository, com.sksu.repository.UserRepository userRepository) {
        this.roomRepository = roomRepository;
        this.userRepository = userRepository;
    }

    @Override
    public void run(String... args) throws Exception {
        // Only add rooms if the table is empty (first run)
        if (roomRepository.count() == 0) {
            roomRepository.save(new Room("101", "Makmal Komputer", 30, "Main computer lab with 30 PCs"));
            roomRepository.save(new Room("102", "Bilik Seni", 25, "Art room with sinks and easement"));
            roomRepository.save(new Room("103", "Surau", 50, "Prayer room"));
            roomRepository.save(new Room("104", "Makmal Sains 1", 35, "Physics and Biology Lab"));
            roomRepository.save(new Room("105", "Makmal Sains 2", 35, "Chemistry Lab"));
            roomRepository.save(new Room("106", "Bilik Mesyuarat", 15, "Meeting room with projector"));

            System.out.println("✅ DataInitializer: 6 rooms added to database.");
        } else {
            System.out.println("ℹ️ DataInitializer: Rooms already exist in database.");
        }

        // Initialize Users if none exist
        if (userRepository.count() == 0) {
            // Admin User (Azim Adnan)
            com.sksu.model.User admin = new com.sksu.model.User(
                    "admin@sksu.com",
                    "admin123",
                    "ADMIN",
                    "Azim",
                    "Adnan",
                    "012-3456789",
                    "Male",
                    "ADM001");
            userRepository.save(admin);

            // Regular Teacher (Ali Abu)
            com.sksu.model.User teacher = new com.sksu.model.User(
                    "ali@gmail.com",
                    "password",
                    "USER",
                    "Ali",
                    "Abu",
                    "019-8765432",
                    "Male",
                    "TCH001");
            userRepository.save(teacher);

            System.out.println("✅ DataInitializer: Default users created (admin@sksu.com, ali@gmail.com).");
        }
    }
}
