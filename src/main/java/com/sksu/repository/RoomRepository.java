package com.sksu.repository;

import com.sksu.model.Room;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface RoomRepository extends JpaRepository<Room, String> {
    // JpaRepository provides: findAll(), save(), findById(), deleteById(), etc.
    // Custom query methods can be added here if needed
    Optional<Room> findByName(String name);
}
