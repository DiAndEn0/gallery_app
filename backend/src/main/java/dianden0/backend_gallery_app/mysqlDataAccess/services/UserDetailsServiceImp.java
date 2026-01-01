package dianden0.backend_gallery_app.mysqlDataAccess.services;

import dianden0.backend_gallery_app.mysqlDataAccess.repos.UserRepository;
import org.jspecify.annotations.NullMarked;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
public class UserDetailsServiceImp implements UserDetailsService {
    private final UserRepository repository;

    public UserDetailsServiceImp(UserRepository repository) {
        this.repository = repository;
    }

    @Override
    @NullMarked
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        return repository.findUserByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));
    }


    @NullMarked
    public UserDetails loadUserByEmail(String email) throws UsernameNotFoundException {
        return repository.findUserByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));
    }

}
