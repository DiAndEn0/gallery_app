package dianden0.backend_gallery_app.objects;

import jakarta.persistence.DiscriminatorValue;
import jakarta.persistence.Entity;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;

@EqualsAndHashCode(callSuper = true)
@Entity
@DiscriminatorValue("VIDEO")
@Data
public class Video extends MediaItem {

  @Getter
  @Setter
  private Integer durationSeconds;

  @Getter
  @Setter
  private String thumbnailS3Key;
}