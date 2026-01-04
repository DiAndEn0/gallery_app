package dianden0.backend_gallery_app.mysqlDataAccess.services;

import dianden0.backend_gallery_app.mysqlDataAccess.objects.AuthenticationResponse;
import dianden0.backend_gallery_app.mysqlDataAccess.objects.LoginRequest;
import dianden0.backend_gallery_app.mysqlDataAccess.objects.User;
import dianden0.backend_gallery_app.mysqlDataAccess.repos.UserRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import javax.management.openmbean.KeyAlreadyExistsException;
import java.util.Optional;



@Slf4j
@Service
public class AuthenticationService {
    private final UserRepository repository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final AuthenticationManager authenticationManager;

    public AuthenticationService(UserRepository repository, PasswordEncoder passwordEncoder, JwtService jwtService, AuthenticationManager authenticationManager) {
        this.repository = repository;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
        this.authenticationManager = authenticationManager;
    }

    public AuthenticationResponse register(User request){
        if (repository.findByEmail(request.getEmail()).isPresent()){
            throw new KeyAlreadyExistsException();
        }
        User user = new User();
        user.setEmail(request.getEmail());
        user.setName(request.getName());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setRole(request.getRole());

        user = repository.save(user);

        String token = jwtService.generateToken(user);

        return AuthenticationResponse.builder().token(token)
                .user_name(user.getName())
                .email(user.getEmail())
                .role(user.getRole().name()).build();
    }

    public AuthenticationResponse authenticate(LoginRequest request){
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        request.getEmail(),
                        request.getPassword()
                )
        );

        User user = repository.findByEmail(request.getEmail()).orElseThrow();
        String token = jwtService.generateToken(user);



        return AuthenticationResponse.builder()
                .token(token)
                .user_name(user.getName())
                .email(user.getEmail())
                .role(user.getRole().name())
                .build();
    }
}
