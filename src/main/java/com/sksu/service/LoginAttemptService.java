package com.sksu.service;

import org.springframework.stereotype.Service;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.TimeUnit;

/**
 * LoginAttemptService - Anti-Brute Force Protection
 * 
 * Tracks failed login attempts per email address.
 * After MAX_ATTEMPTS (5) failed tries, the account is locked for LOCK_TIME (15
 * minutes).
 * This prevents hackers from guessing passwords.
 */
@Service
public class LoginAttemptService {

    // Configuration
    private static final int MAX_ATTEMPTS = 5; // Max failed attempts before lock
    private static final long LOCK_TIME_MINUTES = 15; // Lock duration in minutes

    // Storage: email -> [failedAttempts, lockTime]
    private final ConcurrentHashMap<String, int[]> attemptsCache = new ConcurrentHashMap<>();

    /**
     * Record a failed login attempt
     */
    public void loginFailed(String email) {
        email = email.toLowerCase();
        int[] data = attemptsCache.getOrDefault(email, new int[] { 0, 0 });
        data[0]++; // Increment failed attempts

        if (data[0] >= MAX_ATTEMPTS) {
            // Lock the account
            data[1] = (int) (System.currentTimeMillis() / 1000); // Store lock timestamp
        }

        attemptsCache.put(email, data);
    }

    /**
     * Record a successful login - reset attempts
     */
    public void loginSucceeded(String email) {
        attemptsCache.remove(email.toLowerCase());
    }

    /**
     * Check if account is currently locked
     */
    public boolean isBlocked(String email) {
        email = email.toLowerCase();
        int[] data = attemptsCache.get(email);

        if (data == null) {
            return false;
        }

        if (data[0] >= MAX_ATTEMPTS) {
            // Check if lock time has expired
            long lockTimestamp = data[1];
            long currentTime = System.currentTimeMillis() / 1000;
            long lockDuration = TimeUnit.MINUTES.toSeconds(LOCK_TIME_MINUTES);

            if (currentTime - lockTimestamp > lockDuration) {
                // Lock expired - reset
                attemptsCache.remove(email);
                return false;
            }
            return true; // Still locked
        }

        return false;
    }

    /**
     * Get remaining attempts before lock
     */
    public int getRemainingAttempts(String email) {
        email = email.toLowerCase();
        int[] data = attemptsCache.get(email);
        if (data == null) {
            return MAX_ATTEMPTS;
        }
        return Math.max(0, MAX_ATTEMPTS - data[0]);
    }

    /**
     * Get remaining lock time in minutes
     */
    public long getRemainingLockTime(String email) {
        email = email.toLowerCase();
        int[] data = attemptsCache.get(email);
        if (data == null || data[0] < MAX_ATTEMPTS) {
            return 0;
        }

        long lockTimestamp = data[1];
        long currentTime = System.currentTimeMillis() / 1000;
        long lockDuration = TimeUnit.MINUTES.toSeconds(LOCK_TIME_MINUTES);
        long remaining = lockDuration - (currentTime - lockTimestamp);

        return Math.max(0, remaining / 60); // Return minutes
    }
}
