package dianden0.backend_gallery_app;

import org.springframework.boot.SpringApplication;

public class TestBackendGalleryAppApplication {

    public static void main(String[] args) {
        SpringApplication.from(BackendGalleryAppApplication::main).with(TestcontainersConfiguration.class).run(args);
    }

}
