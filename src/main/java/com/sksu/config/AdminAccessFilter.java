package com.sksu.config;

import com.sksu.model.User;
import com.sksu.repository.UserRepository;
import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import java.io.IOException;

/**
 * AdminAccessFilter - Security Filter for Admin Pages
 * 
 * This filter intercepts ALL requests to /admin/* URLs and checks:
 * 1. Is the user logged in? (session exists)
 * 2. Is the user an ADMIN?
 * 
 * If either check fails, the user is redirected to the login page.
 * This prevents unauthorized access even if someone types the URL directly.
 */
@Component
@Order(1) // Run this filter first
public class AdminAccessFilter implements Filter {

    @Autowired
    private UserRepository userRepository;

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String requestURI = httpRequest.getRequestURI();

        // Only filter /admin/* URLs
        if (requestURI.startsWith("/admin")) {

            HttpSession session = httpRequest.getSession(false);

            // Check 1: Is user logged in?
            if (session == null || session.getAttribute("userEmail") == null) {
                // Not logged in - redirect to login
                httpResponse.sendRedirect("/login");
                return;
            }

            // Check 2: Is user an ADMIN?
            String userEmail = (String) session.getAttribute("userEmail");
            User user = userRepository.findByEmail(userEmail);

            if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) {
                // Not an admin - redirect to home with error
                httpResponse.sendRedirect("/home?error=unauthorized");
                return;
            }

            // User is admin - allow access
        }

        // Continue to the next filter/controller
        chain.doFilter(request, response);
    }
}
