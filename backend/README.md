# Gallery App - Backend

## 🛠 Tech Stack
* **IDE:** IntelliJ IDEA 2025.3.1 Ultimate
* **Framework:** Spring Boot 4.0.1
* **Language:** Java 17+
* **Database:** MySQL
* **ORM:** Hibernate / Spring Data JPA
* **Security:** Spring Security + JWT (Stateless)
* **Storage:** Local Filesystem
* **Build Tool:** Maven

---

## Getting Started

### Prerequisites

1. **Java 17** or newer installed.
2. **MySQL Server** running locally or via Docker.
3. **Postman** (optional but recommended) for API testing.

### Configuration (`application.properties`)

Before running, ensure your database and storage paths are configured.

```properties
spring.application.name=backend
# File Storage Configuration
spring.docker.compose.file=backend/compose.yaml
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.format_sql=true
spring.jpa.database=mysql

# Upload Limits (Crucial for large video files)
spring.servlet.multipart.enabled=true
spring.servlet.multipart.max-file-size=100MB
spring.servlet.multipart.max-request-size=200MB
spring.servlet.multipart.resolve-lazily=true
server.max-http-request-header-size=65536

```

### Configuration (`compose.yaml`)


```properties
services:
mysql:
container_name: 'mysql'
image: 'mysql:latest'
# Ensure your environment is properly configured
environment:
- 'MYSQL_DATABASE=<yourDatabase>'
- 'MYSQL_PASSWORD=<yourPassword>'
- 'MYSQL_ROOT_PASSWORD=<YourRootPassword>'
- 'MYSQL_USER=<yourUser>'
ports:
- '3306:3306'
```

### Running the App

1. **Open** your  IntelliJ, look at pom.xml folder.
2. Check your dependencies, reload if needed.
3. Use either ``` ./mvnw spring-boot:run``` or IntelliJ's **Run** command of the BackendGalleryApplication
---

##  Authentication Flow

The API is **stateless**. The server does not maintain sessions.

1. **Register:** User creates an account.
2. **Login:** User sends credentials and receives a **JWT (JSON Web Token)**.
3. **Access:** The Client (Flutter/Postman) must attach this token to the `Authorization` header of **every** subsequent request.

**Header Format:**

```text
Authorization: Bearer <YOUR_JWT_TOKEN_HERE>

```

---

##  API Usage & Flow

### 1. Authentication

| Method | Endpoint | Description | Body (JSON)                                                          |
| --- | --- | --- |----------------------------------------------------------------------|
| `POST` | `/auth/register` | Create account | `{ "email": "...", "password": "...", "name": "...", "Role": "..."}` |
| `POST` | `/auth/login` | Login | `{ "email": "...", "password": "...", "Role": ...}`                  |

**Response:** Returns an `AuthenticationResponse` containing the `token`.

### 2. Media Management (`/local`)

*All endpoints below require the Bearer Token.*

#### A. Uploading Files

**Flow:** Client selects multiple files -> Sends Multipart Request -> Server saves to disk -> Server saves metadata to DB.

* **Endpoint:** `POST /local/upload`
* **Content-Type:** `multipart/form-data`
* **Key:** `files` (Must be a list of files).
* **Note:** The server is configured with high limits (200MB+) to handle video uploads.

#### B. Fetching Metadata

**Flow:** Client asks "What files do I own?" -> Server queries DB -> Returns JSON list (IDs, filenames, dates).

* **Endpoint:** `GET /local/fetch`
* **Response:** JSON List of `FileResponse` objects.

#### C. Streaming/Viewing Files

**Flow:** Client requests a file by its Key -> Server reads bytes from disk -> Streams back to Client.

* **Endpoint:** `GET /local/view/{fileKey}`
* **Example:** `/local/view/12345-image.jpg`
* **Optional Param:** `?type=thumbnail` (If implemented for preview images).
* **Note:** The `{fileKey}` must include the extension.

#### D. Deleting Files

**Flow:** Client sends list of Keys -> Server deletes from DB -> Server deletes from Disk.

* **Endpoint:** `DELETE /local/delete`
* **Body:** JSON List of strings.
```json
["file_key_1.jpg", "file_key_2.mp4"]

```


* *Warning:* Some network proxies strip bodies from DELETE requests.

---

##  Project Structure

* **`config/`**: Security configuration (CSRF disable, Filter chains).
* **`controllers/`**: REST Endpoints (`FileController`, `AuthenticationController`).
* **`entities/`**: Database models (`User`, `MediaItem`, `Video`, `Image`).
* *Note:* Uses Single Table Inheritance for MediaItems.


* **`filters/`**: `JwtAuthenticationFilter` intercepts requests to validate tokens.
* **`repos/`**: JPA Repositories for DB access.
* **`services/`**: Business logic.
* `LocalFileService`: Handles disk I/O.
* `AuthenticationService`: Handles Login/Register logic.



---

##  Developer Notes & Suggestions

### 1. Handling Large Uploads

The project uses custom **Tomcat Configuration** to bypass standard size limits. If you encounter `Connection Reset` or `401` errors during large uploads, ensure the **Tomcat Config Bean** is active to allow:

* Unlimited `maxSwallowSize`.
* Increased `maxPostSize`.

### 2. Security Warning

The `DELETE` endpoint currently accepts a request body. While valid in HTTP specs, standard practice in some gateways (like AWS API Gateway) is to reject bodies in DELETE methods.

* **Suggestion:** Consider changing this to a `POST` request (e.g., `/local/delete-batch`) OR passing IDs as query parameters if the list is small.

### 3. File Extension Handling

The endpoint `/view/{fileKey:.+}` uses a regex to ensure Spring does not truncate file extensions (e.g., stopping at `.jpg`). Do not remove this regex.

