package dianden0.backend_gallery_app.repos;

import dianden0.backend_gallery_app.entities.MediaItem;
import org.springframework.data.jpa.repository.JpaRepository;

public interface FileRepository extends JpaRepository<MediaItem, String> {

}
