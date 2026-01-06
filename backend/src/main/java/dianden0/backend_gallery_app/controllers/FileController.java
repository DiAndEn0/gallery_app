package dianden0.backend_gallery_app.controllers;

import dianden0.backend_gallery_app.services.LocalFileService;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
@RequestMapping(path = "/local", method = {RequestMethod.GET, RequestMethod.POST})
public class FileController {
    private final LocalFileService localFileService;

    public FileController(LocalFileService localFileService) {
        this.localFileService = localFileService;
    }

    @PostMapping(value = "/upload", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public String uploadFiles(
            @RequestParam("files") List<MultipartFile> files,
            @RequestParam("email") String email
    )
    {
        try {
            return localFileService.uploadFiles(files, email);
        } catch (Exception e) {
            return e.toString();
        }
    }

    // Need to make /fetch and /delete methods
}
