
# Secure Media Gallery (Monorepo)

A full-stack, secure media management solution allowing users to browse local device storage, upload large media batches (Images/Videos) to a private server, and stream content securely.

**This monorepo contains:**

* **`backend/`**: A Spring Boot REST API optimized for high-volume multipart uploads and media streaming.
* **`frontend/`**: A Flutter mobile application featuring custom asset picking and VLC-based playback.

---

##  System Architecture

This project demonstrates a stateless, decoupled architecture designed for resilience and large file handling.

### Key Technical Decisions

* **Stateless Authentication:** Uses **JWT (JSON Web Tokens)** for secure, session-less communication. Tokens are encrypted at rest on the mobile device using Android Secure Storage.
* **Resilient Upload Engine:**
* **Frontend:** Implements parallel processing for asset compression and MIME-type detection. Solves the *Android Emulator Chunked-Transfer bug* by manually calculating content headers.
* **Backend:** Custom **Tomcat Configuration** bypasses standard upload limits to handle batch uploads (10+ files) and large video files (200MB+), preventing "Connection Reset" errors common in default Spring setups.


* **Polymorphic Media Storage:** Uses **Single Table Inheritance** in MySQL/Hibernate to efficiently manage metadata for different media types (Images vs. Videos) while maintaining a unified query interface.
* **Media Streaming:** Integrates **VLC Player** in Flutter to handle RTSP and complex video codecs that the native Android player struggles with.

---

## Tech Stack

| Component | Technology                   | Highlights |
| --- |------------------------------| --- |
| **Backend** | Java 17, Spring Boot 4.0.1   | Lazy Multipart Resolution (for security filters), Stream-based File Serving. |
| **Frontend** | Flutter 3.38.1 (Dart 3.10.1) | Parallel Asset Processing (Future.wait), Custom Multipart Chunking (fixes Emulator bugs), VLC Integration for RTSP/MKV support. |
| **Database** | MySQL                        | Relational Data Modeling, STI |
| **Security** | JWT, BCrypt                  | Stateless Auth, Encrypted Local Storage |
| **DevOps** | Maven, Android SDK           | Monorepo structure |

---

## Quick Start Guide

### Prerequisites

* **Java 17+** (for Backend)
* **Flutter SDK** (for Mobile App)
* **MySQL Server** (running locally or via Docker)
*  **Docker Desktop** (Recommended for docker-compose.yaml)
* **Android Emulator** (or physical device)


*Configure your credentials in `backend/compose.yaml`.*

### 2. Launch Backend

Navigate to the backend directory and run the Spring Boot server:

Set the JWT signing key first (a Base64 string of at least 32 bytes):

```bash
export JWT_SECRET_KEY=$(openssl rand -base64 32)
```

*In IntelliJ, add `JWT_SECRET_KEY` under Run Configuration → Environment variables.*


Use the IntelliJ **Run** command or `./mvnw spring-boot:run`

*Server will start at `http://localhost:8080`.*

### 3. Launch Mobile App

Navigate to the frontend directory:

```bash
cd frontend
flutter pub get
```

**Important:** If running on an **Android Emulator**, ensure `lib/AppConfig.dart` points to the loopback IP:

```dart
class AppConfig {
  // Enable this if your device is an emulator ran in an IDE or such
  static const bool isEmulator = false;


  static const String emulatorBasedUrl = 'http://10.0.2.2:8080';
  // If you use a physical device like an Android Phone,
  // you should configure this setting for your appropriate IPV4 address on your host machine
  static const String deviceBasedUrl = 'http://YOUR_IPV4ADDRESS:8080';

  static String getBaseUrl (){
    return isEmulator ? emulatorBasedUrl : deviceBasedUrl;
  }
}
```

Run the app:

```bash
flutter run
```

---

## Features Showcase

### 1. Secure Batch Uploads

Users can select unlimited photos/videos from their native gallery. The app handles the concurrency, ensuring the server (tuned for high throughput) receives the payload without timing out.

### 2. Protected Media Streaming

Files are stored outside the web root. Access is only granted via a dedicated streaming controller (`/local/view/{key}`) that validates the JWT before serving the byte stream.

### 3. Native & Remote Gallery Views

* **Local View:** High-performance grid rendering using `photo_manager` (loads 5,000+ assets instantly via pagination).
* **Remote View:** authenticated network images and streamed video content.

---

##  Future Roadmap

* **Video Transcoding:** Implement `FFmpeg` on the backend to generate multiple resolution qualities for slower networks.
* **S3 Integration:** Refactor `LocalFileService` to support cloud storage buckets for scalability.
* **Https and Encoding** Rewrite `http` to use a more secure `https` protocol, as well as encoding to ensure the password arrives safely and undecoded to the backend.
* **Frontend Features** Expand on the accessibility of the app and add more features.
---
