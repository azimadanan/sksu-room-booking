package com.sksu.repository;

import com.sksu.model.Notification;
import com.sksu.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface NotificationRepository extends JpaRepository<Notification, Long> {
    
    // Find all notifications for a specific user, ordered by newest first
    List<Notification> findByRecipientOrderByTimestampDesc(User recipient);
    
    // Count unread notifications
    long countByRecipientAndIsReadFalse(User recipient);
}
