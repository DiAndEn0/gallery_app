package dianden0.backend_gallery_app.services;

import dianden0.backend_gallery_app.entities.Image;
import dianden0.backend_gallery_app.entities.MediaItem;
import dianden0.backend_gallery_app.entities.User;
import dianden0.backend_gallery_app.entities.Video;
import dianden0.backend_gallery_app.objects.FileResponse;
import dianden0.backend_gallery_app.repos.FileRepository;
import dianden0.backend_gallery_app.repos.UserRepository;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.mp4parser.IsoFile;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.MediaTypeFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.io.File;
import java.io.IOException;
import java.net.MalformedURLException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Date;
import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class LocalFileService implements StorageService {
    private static final Log log = LogFactory.getLog(LocalFileService.class);
    private final UserRepository repository;
    private final FileRepository fileRepository;

    public LocalFileService(UserRepository repository, FileRepository fileRepository) {
        this.repository = repository;
        this.fileRepository = fileRepository;
    }

    public ResponseEntity<List<FileResponse>> fetchFiles(String email) throws IOException {
        Optional<User> user = repository.findByEmail(email);
        List<MediaItem> mediaItems = fileRepository.getAllByUser(user.get());

        List<FileResponse> responseFiles = mediaItems.stream().map(resource -> {

            MediaType mediaType = MediaTypeFactory.getMediaType(resource.getFileName())
                    .orElse(MediaType.APPLICATION_OCTET_STREAM);
            String fileUrl = ServletUriComponentsBuilder.fromCurrentContextPath()
                    .path("/local/view/")
                    .path(resource.getStorageKey())
                    .toUriString();

            return FileResponse.builder()
                    .fileName(resource.getFileName())
                    .fileType(mediaType.toString())
                    .size(resource.getFileSize())
                    .downloadUrl(fileUrl)
                    .storageKey(resource.getStorageKey()).build();
        }).collect(Collectors.toList());

        return ResponseEntity.ok(responseFiles);
    }

    @Transactional
    public String uploadFiles(List<MultipartFile> files, String email)
    {
        Optional<User> user = repository.findByEmail(email);

        List<String> fileUploadStatus = new ArrayList<>();

        String rootPath = System.getProperty("user.dir") + "/LocalStorage"+ File.separator+ email;
        Path uploadPath = Paths.get(rootPath);

        if (!Files.exists(uploadPath)) {
            try {
                Files.createDirectories(uploadPath);
            } catch (IOException e) {
                return "Could not create upload directory: " + e.getMessage();
            }
        }


        for (MultipartFile file : files )
        {
            String originalName = file.getOriginalFilename();
            assert originalName != null;
            String extension = originalName.substring(originalName.lastIndexOf("."));
            String uniqueFileName = UUID.randomUUID().toString() + extension;

            Path filePath = uploadPath.resolve(uniqueFileName);

            if (Files.exists(filePath))
            {
                continue;
            } else {
                try {
                    file.transferTo(filePath);

                    MediaItem newUploadedFile;
                    if (Objects.requireNonNull(file.getContentType()).startsWith("image")) {
                        Image image = new Image();

                        image.setFileName(originalName);
                        image.setFileSize(file.getSize());
                        image.setDate(Date.valueOf(LocalDate.now()));
                        image.setStorageKey(uniqueFileName);
                        image.setUser(user.orElseThrow());

                        newUploadedFile = image;
                    } else {
                        Video video = new Video();

                        video.setFileName(originalName);
                        video.setFileSize(file.getSize());
                        video.setDate(Date.valueOf(LocalDate.now()));
                        video.setStorageKey(uniqueFileName);
                        video.setUser(user.orElseThrow());
                        double durationInSeconds = getVideoDuration(filePath.toFile());
                        video.setDurationSeconds(durationInSeconds);

                        newUploadedFile = video;
                    }
                    user.get().addMediaItem(newUploadedFile);
                    fileRepository.save(newUploadedFile);
                } catch (Exception e) {
                    fileUploadStatus.add("Error in uploading file: " + file.getOriginalFilename() + " " + e);
                }
            }
        }
        return fileUploadStatus.isEmpty() ? "Files uploaded successfully" : fileUploadStatus.toString();
    }

    @Override
    public ResponseEntity<Resource> loadOneFile(String email, String fileKey) {
        try {
            Path rootPath = Paths.get(System.getProperty("user.dir"));
            Path filePath = rootPath.resolve("LocalStorage")
                    .resolve(email)
                    .resolve(fileKey);

            Resource resource = new UrlResource(filePath.toUri());

            if (resource.exists() && resource.isReadable()) {
                MediaType mediaType = MediaTypeFactory.getMediaType(resource.getFilename())
                        .orElse(MediaType.APPLICATION_OCTET_STREAM);
                return ResponseEntity.ok()
                        .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"" + resource.getFilename() + "\"")
                        .contentType(mediaType)
                        .body(resource);
            } else {
                throw new RuntimeException("File not found on disk: " + fileKey);
            }
        } catch (MalformedURLException e) {
            throw new RuntimeException("Invalid file path", e);
        }
    }

    @Override
    @Transactional
    public String deleteFiles(List<String> fileKeys, String email) {
        Optional<User> user = repository.findByEmail(email);

        try {
            Path rootPath = Paths.get(System.getProperty("user.dir"));
            Path userPath = rootPath.resolve("LocalStorage")
                    .resolve(email);
            List<MediaItem> itemsToDelete = fileRepository.findAllByUserAndStorageKeyIn(user.get(), fileKeys);
            for (MediaItem item : itemsToDelete){
                Path filePath = userPath.resolve(item.getStorageKey());
                Files.deleteIfExists(filePath);

                fileRepository.deleteMediaItemByStorageKey(item.getStorageKey());
                user.get().deleteMediaItem(item);
            }
        } catch (Exception e) {
            return e.toString();
        }

        return "Files deleted successfully";
    }


    public double getVideoDuration(File videoFile) throws IOException {
        try (IsoFile isoFile = new IsoFile(videoFile.getAbsolutePath())) {
            long duration = isoFile.getMovieBox().getMovieHeaderBox().getDuration();
            long timescale = isoFile.getMovieBox().getMovieHeaderBox().getTimescale();

            // Duration is in "ticks", so divide by timescale to get seconds
            return (double) duration / timescale;
        }
    }

}
