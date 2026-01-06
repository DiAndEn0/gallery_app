package dianden0.backend_gallery_app.controllers;

import dianden0.backend_gallery_app.objects.AuthenticationResponse;
import dianden0.backend_gallery_app.objects.LoginRequest;
import dianden0.backend_gallery_app.entities.User;
import dianden0.backend_gallery_app.services.AuthenticationService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;


@RestController
@RequestMapping(path ="/auth", method = {RequestMethod.POST, RequestMethod.GET})
public class AuthenticationController {

    private final AuthenticationService authService;

    public AuthenticationController(AuthenticationService authService) {
        this.authService = authService;
    }

    @PostMapping("/register")
    public ResponseEntity<AuthenticationResponse> register(@RequestBody User request){
        try {
            return ResponseEntity.ok(authService.register(request));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(AuthenticationResponse.builder().error_message("User Already Exists").build());
        }
    }

    @PostMapping("/login")
    public ResponseEntity<AuthenticationResponse> login(@RequestBody LoginRequest request){
        try {
            return ResponseEntity.ok(authService.authenticate(request));
        } catch (Exception e) {
            return  ResponseEntity.badRequest().body(AuthenticationResponse.builder().error_message("User not found").build());
        }
    }
}
