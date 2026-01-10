package dianden0.backend_gallery_app.entities;


import jakarta.persistence.*;
import lombok.*;
import lombok.Getter;
import lombok.Setter;

import java.sql.Date;

@Entity
@Table(name = "media_types")
@DiscriminatorColumn(name = "dtype", discriminatorType = DiscriminatorType.STRING)
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@Data
public abstract class MediaItem {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;


    @Getter
    @Setter
    private String fileName;

    @Getter
    @Setter
    @Column(nullable = false)
    private Date date;

    @Getter
    @Setter
    @Column(nullable = false)
    private Long fileSize;

    @Getter
    @Setter
    private String storageKey;



    @Getter
    @Setter
    @ManyToOne()
    @JoinColumn(name = "user_id")
    private User user;

    public String getThumbnailIdentifier() {
        return null;
    }
}
