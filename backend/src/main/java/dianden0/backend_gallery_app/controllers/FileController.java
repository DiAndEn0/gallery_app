package dianden0.backend_gallery_app.controllers;

import dianden0.backend_gallery_app.objects.FileResponse;
import dianden0.backend_gallery_app.services.LocalFileService;
import org.springframework.core.io.Resource;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;

import java.security.Principal;
import java.util.List;

@RestController
@RequestMapping(path = "/local", method = {RequestMethod.GET, RequestMethod.POST, RequestMethod.DELETE})
public class FileController {
    private final LocalFileService localFileService;

    public FileController(LocalFileService localFileService) {
        this.localFileService = localFileService;
    }

    @PostMapping(value = "/upload", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public String uploadFiles(
            @RequestParam List<MultipartFile> files,
            Principal principal
    )
    {
        try {
            return localFileService.uploadFiles(files, principal.getName());
        } catch (Exception e) {
            return e.toString();
        }
    }

    @GetMapping("/fetch")
    public ResponseEntity<List<FileResponse>> fetchFiles (Principal principal) {
        try {
            return localFileService.fetchFiles(principal.getName());
        } catch (Exception e) {
            return  ResponseEntity.internalServerError().build();
        }
    }

    @GetMapping("/view/{fileKey:.+}")
    public ResponseEntity<Resource> serveFile(@PathVariable String fileKey, @RequestParam(defaultValue = "original") String type, Principal  principal) {
       return localFileService.loadOneFile(principal.getName(), fileKey, type);
    }


    @DeleteMapping("/delete")
    public ResponseEntity<String> deleteFiles(@RequestBody List<String> fileKeys, Principal principal ) {
        try {
            return ResponseEntity.ok(localFileService.deleteFiles(fileKeys, principal.getName()));
        } catch (Exception e) {
            return ResponseEntity.ok(e.toString());
        }
    }
}
