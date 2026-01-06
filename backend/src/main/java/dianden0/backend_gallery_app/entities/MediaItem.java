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
    private String file_name;

    @Getter
    @Setter
    @Column(nullable = false)
    private Date date;

    @Getter
    @Setter
    @Column(nullable = false)
    private Long file_size;


    @Getter
    @Setter
    @ManyToOne()
    @JoinColumn(name = "user_id")
    private User user;
}
