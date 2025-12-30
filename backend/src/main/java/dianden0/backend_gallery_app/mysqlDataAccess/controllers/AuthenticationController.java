package dianden0.backend_gallery_app.mysqlDataAccess.controllers;

import dianden0.backend_gallery_app.mysqlDataAccess.objects.AuthenticationResponse;
import dianden0.backend_gallery_app.mysqlDataAccess.objects.User;
import dianden0.backend_gallery_app.mysqlDataAccess.services.AuthenticationService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;


@RestController
@RequestMapping(path ="/auth", method = {RequestMethod.GET, RequestMethod.POST})
public class AuthenticationController {

    private final AuthenticationService authService;

    public AuthenticationController(AuthenticationService authService) {
        this.authService = authService;
    }

    @PostMapping("/register")
    public ResponseEntity<AuthenticationResponse> register(@RequestBody User request){
        return ResponseEntity.ok(authService.register(request));
    }

    @PostMapping("/login")
    public ResponseEntity<AuthenticationResponse> login(@RequestBody User request){
        return ResponseEntity.ok(authService.authenticate(request));
    }
}
