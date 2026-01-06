package dianden0.backend_gallery_app.services;

import dianden0.backend_gallery_app.entities.Image;
import dianden0.backend_gallery_app.entities.MediaItem;
import dianden0.backend_gallery_app.entities.User;
import dianden0.backend_gallery_app.entities.Video;
import dianden0.backend_gallery_app.repos.FileRepository;
import dianden0.backend_gallery_app.repos.UserRepository;
import org.mp4parser.IsoFile;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Date;
import java.time.LocalDate;
import java.util.*;

@Service
public class LocalFileService implements StorageService {
    private final UserRepository repository;
    private final FileRepository fileRepository;

    public LocalFileService(UserRepository repository, FileRepository fileRepository) {
        this.repository = repository;
        this.fileRepository = fileRepository;
    }

    @Transactional
    public String uploadFiles(List<MultipartFile> files, String email)
    {
        Optional<User> user = repository.findByEmail(email);

        List<String> fileUploadStatus = new ArrayList<>();

        String filePath = System.getProperty("user.dir") + "/LocalStorage"+ File.separator+ email;
        Path uploadPath = Paths.get(filePath);

        if (!Files.exists(uploadPath)) {
            try {
                Files.createDirectories(uploadPath);
            } catch (IOException e) {
                return "Could not create upload directory: " + e.getMessage();
            }
        }

        for (MultipartFile file : files )
        {

            filePath = System.getProperty("user.dir") + "/LocalStorage"+ File.separator+ email + File.separator + file.getOriginalFilename();
            if (Files.exists(Paths.get(filePath)))
            {
                continue;
            } else {
                try {
                    FileOutputStream fout = new FileOutputStream(filePath);
                    fout.write(file.getBytes());

                    MediaItem newUploadedFile;
                    if (Objects.requireNonNull(file.getContentType()).startsWith("image")) {
                        Image image = new Image();

                        image.setFile_name(file.getOriginalFilename());
                        image.setFile_size(file.getSize());
                        image.setDate(Date.valueOf(LocalDate.now()));
                        image.setUser(user.orElseThrow());

                        newUploadedFile = image;
                    } else {
                        Video video = new Video();

                        video.setFile_name(file.getOriginalFilename());
                        video.setFile_size(file.getSize());
                        video.setDate(Date.valueOf(LocalDate.now()));
                        video.setUser(user.orElseThrow());
                        double durationInSeconds = getVideoDuration(new File(filePath));
                        video.setDurationSeconds(durationInSeconds);

                        newUploadedFile = video;
                    }
                    user.get().addMediaItem(newUploadedFile);
                    fileRepository.save(newUploadedFile);
                    fout.close();
                } catch (Exception e) {
                    e.printStackTrace();
                    fileUploadStatus.add("Error in uploading file: " + file.getOriginalFilename() + " " + e);
                }
            }
        }
        return fileUploadStatus.isEmpty() ? "Files uploaded successfully" : fileUploadStatus.toString();
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
