package dianden0.backend_gallery_app.services;

import dianden0.backend_gallery_app.entities.MediaItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public interface StorageService {
    String uploadFiles(List<MultipartFile> fileList, String email);


}
