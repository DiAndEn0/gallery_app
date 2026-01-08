package dianden0.backend_gallery_app.services;

import dianden0.backend_gallery_app.entities.MediaItem;
import org.apache.coyote.Response;
import org.springframework.core.io.Resource;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public interface StorageService {
    String uploadFiles(List<MultipartFile> fileList, String email);

    ResponseEntity<Resource> loadOneFile(String email, String filename);

    String deleteFiles(List<String> files, String email);
}
