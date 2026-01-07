package dianden0.backend_gallery_app.controllers;

import dianden0.backend_gallery_app.objects.FileResponse;
import dianden0.backend_gallery_app.services.LocalFileService;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.MediaTypeFactory;
import org.springframework.http.ResponseEntity;
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
    @GetMapping("/fetch/{email}")
    public ResponseEntity<List<FileResponse>> fetchFiles(@PathVariable String email) {
        try {
            return localFileService.fetchFiles(email);
        } catch (Exception e) {
            return  ResponseEntity.internalServerError().build();
        }
    }

    @GetMapping("/view/{email}/{filename:.+}")
    public ResponseEntity<Resource> serveFile(@PathVariable String email, @PathVariable String filename) {
        Resource file = localFileService.loadOneFile(email, filename);
        MediaType mediaType = MediaTypeFactory.getMediaType(filename)
                .orElse(MediaType.APPLICATION_OCTET_STREAM);
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"" + file.getFilename() + "\"")
                .contentType(mediaType)
                .body(file);
    }


//    @DeleteMapping("/deleteFiles")
//    public ResponseEntity<String> deleteFiles(@RequestParam List<String>)
}
