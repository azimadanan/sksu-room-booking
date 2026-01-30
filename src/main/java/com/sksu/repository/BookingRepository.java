package com.sksu.repository;

import com.sksu.model.Booking; // Use the new Entity
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BookingRepository extends JpaRepository<Booking, Long> {
    // Custom query to find by the composite logic we had earlier (start + room)
    // Actually, identifiers are tricky now. Let's find by Room and Start time which
    // is the logical key.
    Booking findByRoomAndStart(String room, String start);

    // Find all bookings for a room with a specific status (for conflict checking)
    List<Booking> findByRoomAndStatus(String room, String status);

    // Find all bookings made by a specific user (for teacher's dashboard)
    List<Booking> findByUserEmail(String userEmail);
}
