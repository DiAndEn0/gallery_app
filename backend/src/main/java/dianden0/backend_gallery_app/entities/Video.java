package dianden0.backend_gallery_app.entities;

import jakarta.persistence.DiscriminatorValue;
import jakarta.persistence.Entity;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import org.mp4parser.IsoFile;

import java.io.File;
import java.io.IOException;

@EqualsAndHashCode(callSuper = true)
@Entity
@DiscriminatorValue("VIDEO")
@Data
public class Video extends MediaItem {

  @Getter
  @Setter
  private double durationSeconds;

  @Getter
  @Setter
  private String thumbnailKey;
@Override
  public String getThumbnailIdentifier(){
    return thumbnailKey;
  }
}