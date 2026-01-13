# Frontend Gallery App

This is a **Flutter** android application that serves as the client for the Backend Gallery API. It is designed as a hybrid gallery manager that allows users to view local device media, upload it to a secure backend, and stream media back from the server.

## Tech Stack

* **IDE:** IntelliJ IDEA 2025.3.1 Ultimate
* **Framework:** Flutter 3.38.1 (Dart 3.10.1)
* **State Management:** `setState` / `FutureBuilder` (Simple & Reactive)
* **Networking:** `http` package with Multipart support
* **Local Media:** `photo_manager` (High-performance asset picking)
* **Video Playback:** `flutter_vlc_player` (For robust codec support like RTSP/MKV)
* **Storage:** `flutter_secure_storage` (For JWT persistence)
* **Permissions:** Android Runtime Permissions handler

---

## Getting Started

### Prerequisites

1. **Flutter SDK** installed and configured.
2. **Android Studio** or **IntelliJ** (for Emulator) or a physical Android device.
3. **Backend Server** running locally (see Backend README).

### Configuration (`lib/AppConfig.dart`)

You must point the app to your local backend. The IP address differs depending on whether you use an Emulator or a Physical Device. You're able to change which one you're using with the `isEmulator` variable.

**`lib/AppConfig.dart`:**

```dart
class AppConfig {
  // Enable this if your device is an emulator ran in an IDE or such
  static const bool isEmulator = false;

  static const String emulatorBasedUrl = 'http://10.0.2.2:8080';
  // If you use a physical device like an Android Phone,
  // you should configure this setting for your appropriate IPV4 address on your host machine
  static const String deviceBasedUrl = 'http://10.0.0.10:8080';

  static String getBaseUrl (){
    return isEmulator ? emulatorBasedUrl : deviceBasedUrl;
  }
}

```

### Installation

```bash
# 1. Install dependencies
flutter pub get

# 2. Run the app
flutter run

```

---

## Authentication Flow

The app is **stateless** and relies on JWTs stored in the device's secure Keystore/Keychain.

1. **Login Screen:** User enters credentials.
2. **Request:** `AuthService.createHttpSignupRequest()` sends a POST to `/auto/register` to create a new user.
2. **Request:** `AuthService.createHttpLoginRequest` sends a POST to `/auth/login`.
3. **Storage:** On success, the JWT is encrypted and saved using `FlutterSecureStorage`.
4. **Session Check:** On app launch (`SplashScreen`), the app checks if a token exists and is valid. If yes, it skips to `HomePageView`; otherwise, it logs out the user.

---

## Key Features & Logic

### 1. Phone Gallery (Local Media)

**File:** `screens/PhoneGalleryView.dart`

* **Library:** Uses `PhotoManager` to query the device's standard gallery (Camera Roll).
* **Pagination:** Implements lazy loading.
* **Selectable GridView:** Users can select multiple images and videos and upload them with a click of a button.

### 2. Remote Gallery (Server Media)

**File:** `screens/RemoteGalleryView.dart`

* **Fetching:** Calls `GET /local/fetch` to retrieve a list of `MediaItem` objects (JSON metadata).
* **Rendering:**
* **Images:** Rendered using standard `Image.network` with authentication headers.
* **Videos:** Uses `FlutterVlcPlayer`. This was chosen over the standard video player to support a wider range of formats and streaming protocols.



### 3. The Upload Engine

**File:** `services/MediaService.dart`


* **Parallel Processing:** Iterates through selected `AssetEntity` items.
* **MIME Detection:** Explicitly determines content type (e.g., `video/mp4`, `image/png`) before sending.
* **Chunked Fix:** Manually calculates `Content-Length` headers to prevent Android Emulator network crashes.

---

## Project Structure

A quick guide for developers navigating the codebase:

* **`assets/`**: Custom widgets like `AssetThumbnail` (for grid views) and `VideoView`.
* **`config/`**: Environment variables (`AppConfig.dart`).
* **`objects/`**: Data models that map to Backend Entities.
* `MediaItem.dart` maps to the backend's `MediaItem`.
* `LoginRequest.dart` maps to the Auth DTOs.


* **`screens/`**:
* `Main.dart`: Entry point.
* `HomePageView.dart`: Tab controller (switches between Local and Remote galleries).


* **`services/`**:
* `AuthService.dart`: HTTP calls for Login/Register.
* `MediaService.dart`: HTTP calls for Upload/Delete/Fetch.



---

## Developer Notes & Pitfalls

### 1. Android Permissions

The app uses `PhotoManager` which requires specific permissions in `AndroidManifest.xml`. If images don't load, ensure these are present:

```xml
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
<uses-permission android:name="android.permission.READ_MEDIA_VIDEO"/>

<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.INTERNET"/>

```

### 2. The VLC Player quirk

`FlutterVlcPlayer` is used for streaming. Note that the emulator might struggle with hardware acceleration for high-res video decoding. If the video is black but audio plays, try testing on a physical device.

### 3. Secure Storage & Cleartext

* **Development:** To allow HTTP (non-HTTPS) traffic to your local server, the `network_security_config.xml` is configured to allow cleartext traffic. **Do not use this in production.**
* **Storage:** If you uninstall the app, `FlutterSecureStorage` data might persist on Android (due to Auto-Backup). If login behaves weirdly after a reinstalling, clear the app storage manually in Android Settings or simply logout the user via the Drawer.

### 4. Modularity

* The frontend was made to be as modular as possible,  however there are features like the selectable `GridView` which is implemented differently in `PhoneGalleryView` and `RemoteGalleryView`. Keep in mind for further modifications.

### 5. File Loading from Backend

* `RemoteGalleryView` uses `AssetThumbnail` to load videos and images inside the `GridView.builder`. Currently, each initialized item loads assets individually, which leads to delays between the initialized item and the asset appearing on the screen after a successful fetch request.