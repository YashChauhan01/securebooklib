# Secure Book Library

A full-stack secure application allowing users to maintain a private list of books. It features a **Spring Boot** backend with JWT authentication and a **Flutter** frontend for mobile access.

## Features
* **User Authentication:** Secure Registration and Login using JWT (JSON Web Tokens).
* **Data Isolation:** Users can *only* see and edit their own books.
* **Secure Storage:** JWT tokens are encrypted and stored safely on the mobile device.
* **State Management:** Real-time UI updates when adding books.

---

## Tech Stack

### **Backend (Spring Boot)**
* **Language:** Java 17+
* **Framework:** Spring Boot 3.x
* **Security:** Spring Security & JWT (JIO)
* **Database:** PostgreSQL
* **Build Tool:** Maven

### **Frontend (Flutter)**
* **Language:** Dart
* **Framework:** Flutter 3.x
* **HTTP Client:** `http` package
* **Storage:** `flutter_secure_storage` (Keystore/Keychain)

---

## Backend Setup (Spring Boot)

### 1. Prerequisites
* Java JDK 17 or higher
* PostgreSQL installed and running
* Maven

### 2. Database Configuration
Create a database named `library_db` in PostgreSQL:
```sql
CREATE DATABASE library_db;
```

**Note for Mac Users:** If you encounter "Permission Denied" errors, ensure your `pg_hba.conf` file allows local connections.

* Path: `/Library/PostgreSQL/18/data/pg_hba.conf` (or similar)
* Change `scram-sha-256` to `trust` for `127.0.0.1/32` temporarily to reset password if locked out.

### 3. Application Properties

Update `src/main/resources/application.properties`:

```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/library_db
spring.datasource.username=postgres
spring.datasource.password=root  # <-- Replace with your password
spring.jpa.hibernate.ddl-auto=update

# JWT Secret (Must be 32+ chars hex string)
jwt.secret=404E635266556A586E3272357538782F413F4428472B4B6250645367566B5970
jwt.expiration=86400000
```

### 4. Run the Server

```bash
./mvnw spring-boot:run
```

The server will start at `http://localhost:8080`.

---

## Frontend Setup (Flutter)

### 1. Prerequisites

* Flutter SDK Installed
* Android Emulator or Physical Device

### 2. Install Dependencies

Navigate to the `frontend` folder:

```bash
cd frontend
flutter pub get
```

### 3. Configure API URL (`api_service.dart`)

Choose the correct `baseUrl` based on your device:

* **Android Emulator:**
```dart
static const String baseUrl = "http://10.0.2.2:8080/api";
```

* **iOS Simulator / Web:**
```dart
static const String baseUrl = "http://localhost:8080/api";
```

* **Physical Device (USB):**
```dart
// Use your computer's local IP (Run ipconfig/ifconfig to find it)
static const String baseUrl = "http://192.168.1.15:8080/api";
```

### 4. Android Configuration (Important!)

To allow HTTP traffic to a local server, update `android/app/src/main/AndroidManifest.xml`:

```xml
<application
    ...
    android:usesCleartextTraffic="true">
```

### 5. Run the App
```bash
flutter run
```

---

## API Endpoints

| Method | Endpoint | Description | Auth Required |
| --- | --- | --- | --- |
| `POST` | `/api/auth/register` | Register a new user | No |
| `POST` | `/api/auth/login` | Login and get JWT | No |
| `GET` | `/api/books` | Get list of user's books | Yes (Bearer Token) |
| `POST` | `/api/books` | Add a new book | Yes (Bearer Token) |

---

## Troubleshooting

**1. "Connection Refused" on Android Emulator**

* **Fix:** Ensure you are using `10.0.2.2` instead of `localhost` in `api_service.dart`.

**2. "Cleartext HTTP traffic not permitted"**

* **Fix:** Add `android:usesCleartextTraffic="true"` to your `AndroidManifest.xml` and restart the app completely.

**3. "PostgreSQL Password Authentication Failed"**

* **Fix:** Verify your `application.properties` password matches your Postgres user password. You may need to edit `pg_hba.conf` to `trust` mode temporarily to reset it.

---

## Project Structure

```
secure-book-library/
├── backend/                  # Spring Boot backend
│   ├── src/main/java/
│   ├── src/main/resources/
│   │   └── application.properties
│   └── pom.xml
│
└── frontend/                 # Flutter frontend
    ├── lib/
    │   ├── models/
    │   ├── services/
    │   └── screens/
    ├── android/
    │   └── app/src/main/AndroidManifest.xml
    └── pubspec.yaml
```

---

## Security Notes

* JWT tokens are stored securely using platform-specific secure storage (Keychain on iOS, Keystore on Android)
* Tokens expire after 24 hours (configurable in `application.properties`)
* Users can only access their own data - enforced at the backend level
* Passwords are hashed using BCrypt before storage

---

## License

This project is open source and available under the [MIT License](LICENSE).

---

## Author

Created as a demonstration of secure full-stack development with Spring Boot and Flutter.

---

## Acknowledgments

* Spring Security for robust authentication framework
* Flutter Secure Storage for encrypted token storage
* PostgreSQL for reliable data persistence