package dianden0.backend_gallery_app.mysqlDataAccess;

import org.springframework.data.repository.CrudRepository;

public interface UserRepository extends CrudRepository<User, Integer> {

    User findUserByEmail(String email);

    boolean existsByEmail(String email);
}
