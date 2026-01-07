package dianden0.backend_gallery_app.repos;

import dianden0.backend_gallery_app.entities.MediaItem;
import dianden0.backend_gallery_app.entities.User;
import org.springframework.core.io.Resource;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface FileRepository extends JpaRepository<MediaItem, String> {

    Page<MediaItem> findByUserEmail(String email, Pageable pageable);

    List<MediaItem> getAllByUser(User user);

    MediaItem getMediaItemByUserAndFileName(User user, String filename);
}
