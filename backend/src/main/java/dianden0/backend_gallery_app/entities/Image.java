package dianden0.backend_gallery_app.entities;

import jakarta.persistence.DiscriminatorValue;
import jakarta.persistence.Entity;
import lombok.Data;
import lombok.EqualsAndHashCode;

@EqualsAndHashCode(callSuper = true)
@Entity
@DiscriminatorValue("IMAGE")
@Data
public class Image extends MediaItem {
    @Override
    public String getThumbnailIdentifier() {
        return getStorageKey();
    }

}
