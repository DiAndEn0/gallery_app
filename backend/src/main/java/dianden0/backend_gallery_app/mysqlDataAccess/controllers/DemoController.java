package dianden0.backend_gallery_app.mysqlDataAccess.controllers;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class DemoController {
    @GetMapping("/demo")
    public ResponseEntity<String> demo(){
        return ResponseEntity.ok("Hello from secured URL");
    }

    @GetMapping("/admin_only")
    public ResponseEntity<String> admin_only(){
        return ResponseEntity.ok("Hello admin");
    }
}
