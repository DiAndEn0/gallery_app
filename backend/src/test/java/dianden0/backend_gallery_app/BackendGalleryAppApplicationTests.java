package dianden0.backend_gallery_app;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.annotation.Import;

@Import(TestcontainersConfiguration.class)
@SpringBootTest(properties = "security.jwt.secret-key=dGVzdC1vbmx5LWtleS1mb3ItY29udGV4dC1sb2Fkcy10ZXN0cw==")
class BackendGalleryAppApplicationTests {

    @Test
    void contextLoads() {
    }

}
