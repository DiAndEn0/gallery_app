package dianden0.backend_gallery_app.mysqlDataAccess.repos;

import dianden0.backend_gallery_app.mysqlDataAccess.objects.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UserRepository extends JpaRepository<User, String> {
    
    boolean existsByEmail(String email);

    Optional<User> findByEmail(String email);
}
