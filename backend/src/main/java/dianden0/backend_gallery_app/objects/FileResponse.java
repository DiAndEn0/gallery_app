package dianden0.backend_gallery_app.objects;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.*;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.NON_NULL)
public class FileResponse {
    @Getter
    @Setter
    private String fileName;
    @Getter
    @Setter
    private String downloadUrl;
    @Getter
    @Setter
    private String fileType;
    @Getter
    @Setter
    private long size;
    @Getter
    @Setter
    private double duration;
    @Getter
    @Setter
    private String storageKey;
    @Getter
    @Setter
    private String thumbnailUrl;

}