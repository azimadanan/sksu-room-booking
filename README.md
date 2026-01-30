# SKSU Room Booking System

## 👋 Welcome New Developer!

If you have received this project as a `.zip` file, follow this guide to get it running on your local machine. This document explains exactly what you need to install and what settings **you must change** to make the code work on your computer.

---

## 🛠️ Prerequisites

Before you begin, ensure you have these installed:

1.  **Java Development Kit (JDK) 17** or higher.
2.  **MySQL Server** (The database used by this system).
    - _Tip: Apps like XAMPP or MySQL Workbench make this easy._
3.  **A Code Editor** (VS Code, IntelliJ, or Eclipse).

---

## 🚀 Setup Instructions (Step-by-Step)

### Step 1: Database Setup

You need to create an empty database. The code will automatically build the tables for you.

1.  Open your MySQL Command Line or Workbench.
2.  Run this command:
    ```sql
    CREATE DATABASE sksu_db;
    ```

### Step 2: Update Configuration (CRITICAL STEP - DO NOT SKIP)

Your friend **MUST** change these settings in `src/main/resources/application.properties` or the app will not work.

#### A. Database Settings (MySQL)

Open `application.properties` and find these lines. Change them to match **THEIR** computer's MySQL setup:

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/sksu_db
spring.datasource.username=root      <-- CHANGE THIS to your MySQL username (usually 'root')
spring.datasource.password=1234      <-- CHANGE THIS to your MySQL password
```

#### B. Email Settings (Gmail App Password)

**IMPORTANT:** You cannot use your normal Gmail password. Google blocks it.

1.  Go to your Google Account -> Security -> 2-Step Verification (Turn On).
2.  Go to **App Passwords** (Search for it in settings).
3.  Create a new app name "SKSU Booking".
4.  Copy the **16-character code**.
5.  Paste it in `application.properties` here:

```properties
spring.mail.username=your-email@gmail.com   <-- CHANGE THIS to your Gmail address
spring.mail.password=kasr pmjs gkrt fghj    <-- CHANGE THIS to the 16-char App Password (no spaces needed)
```

---

## ▶️ How to Run the App

1.  Open your terminal / command prompt.
2.  Change directory (`cd`) into the project folder where you unzipped the files.
    ```cmd
    cd path/to/sksu-room-booking
    ```
3.  Run the application using the included Maven wrapper script:
    - **Windows:**
      ```cmd
      .\mvnw spring-boot:run
      ```
    - **Mac/Linux:**
      ```bash
      ./mvnw spring-boot:run
      ```
4.  Wait for the console to say `Started SksuApplication`.

## 🌐 Accessing the System

Open your browser and verify the app is running:

- URL: **[http://localhost:8082](http://localhost:8082)**

---

## 🔑 Important User & Role Info

This system uses a dynamic role assignment logic:

1.  **The FIRST user to register** becomes the **ADMIN**.
    - _Action:_ When you first run the app, go to `/register` and create an account. This account will be the Admin.
2.  **All subsequent users** will be **Standard Users**.

### Default Password Policy

There is no complex password complexity enforced (e.g., special chars not required) for ease of testing, but you should use secure passwords.

---

## 📂 Project Structure & Code Dictionary

This section explains **every single file** in the project so you know exactly where to look.

### 1. Backend Code (`src/main/java/com/sksu`)

This is the code that runs on the server (Hidden from users).

#### a. Main App

- **`SksuApplication.java`**: The "Start Button".
  - **What it does:** Contains the `public static void main` method. It starts the Spring Boot server.

#### b. `controller` (The "Front Desk" / Traffic Control)

- **`HomeController.java`**: The main public interface.
  - **What it does:** It listens for URLs like `/login`, `/register`, or `/home`.
  - **Key Logic:** It checks if a user is an `ADMIN` before showing the dashboard. If they are just a `USER`, it blocks them.
- **`BookingController.java`**: Handles booking submissions.
  - **What it does:** Takes the form data (Date, Room) and saves it as a "Pending" booking.
- **`RoomController.java`**: Handles Room Management.
  - **What it does:** Allows Admins to add new rooms (e.g., "Library") or delete old ones.

#### c. `service` (The "Manager" / Business Logic)

- **`BookingService.java`**: **CRITICAL FILE.** The brain of the booking system.
  - **Transactons:** Uses `@Transactional` to ensure data is saved safely.
  - **Logic:** When Admin clicks "Approve", this service:
    1. Updates the `booking` status in MySQL.
    2. Creates a `Notification` for the dashboard.
    3. Calls `EmailService` to send a Gmail alert.
- **`EmailService.java`**: The Postman.
  - **What it does:** Uses `JavaMailSender` to log in to your Gmail (using the App Password) and send emails to users.

#### d. `repository` (The "Librarians" / Database Access)

- **`UserRepository.java`**: Finds Users.
  - **Example:** `findByEmail("ali@gmail.com")` — gets the user without writing raw SQL.
- **`BookingRepository.java`**: Saves/Loads Bookings.
- **`RoomRepository.java`**: Saves/Loads Rooms.
- **`NotificationRepository.java`**: Saves/Loads usage notifications.

#### e. `model` (The "Blueprints" / Data Structure)

- **`User.java`**: Represents a Person in the `users` table.
  - **Fields:** `email`, `password`, `role` (ADMIN/USER), `contactNumber`.
- **`Booking.java`**: Represents a Row in the `bookings` table.
  - **Fields:** `startTime`, `roomName`, `status` (PENDING/APPROVED).
- **`Room.java`**: Represents a Room.
- **`Notification.java`**: Represents a dashboard message.
- **`BookingRequest.java`**: A temporary "Form Object" to hold data when a user fills out the booking form.
- **`BookingDetails.java`**: A helper class for the Calendar display logic.

---

### 2. Frontend Views (`src/main/webapp/WEB-INF/jsp`)

These are the HTML pages (with Java code `<% %>` inside).

#### a. Public Pages

- **`login.jsp`**: The purple Login screen.
- **`register.jsp`**: The Sign Up screen.
- **`server-error.jsp`**: The "Oops" page if something crashes.

#### b. Teacher Pages

- **`home-dashboard.jsp`**: The Teacher's Homepage. Shows "My Bookings" and Notifications.
- **`booking-form.jsp`**: The form to "Request a Room".
- **`booking-summary.jsp`**: A confirmation page after booking.
- **`calendar.jsp`**: The visual monthly view.
- **`rooms.jsp`**: A gallery showing all rooms and photos.

#### c. Admin Pages

- **`admin-dashboard.jsp`**: The Principal's Control Panel (Approve/Reject).
- **`manage-rooms.jsp`**: The page where Admins can Add or Remove rooms.

#### d. Fragments (`includes/`)

- **`header.jsp`**: The top bar (Logo + Navigation).
- **`footer.jsp`**: The bottom bar (Copyright).
- **`sidebar.jsp`**: (Optional) Side navigation if used.

---

### 3. Configuration (`src/main/resources`)

- **`application.properties`**: **CRITICAL SETTINGS.** Database URL, Password, and Gmail keys.
- **`static/css/theme.css`**: The visuals (Colors, Gradients, Glassmorphism).

---

### 💡 Glossary for Beginners

- **Controller**: Handles clicks and URLs.
- **Service**: Handles the "Business Logic" (Rules).
- **Repository**: Talks to the Database.
- **Entity/Model**: The data object itself.
- **JSP**: "Java Server Page" (HTML + Java).
