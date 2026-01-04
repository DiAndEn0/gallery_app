package dianden0.backend_gallery_app.mysqlDataAccess.objects;

import com.fasterxml.jackson.annotation.JsonProperty;
import jdk.jfr.DataAmount;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import tools.jackson.databind.annotation.JsonPOJOBuilder;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class AuthenticationResponse {
    @JsonProperty("token")
    private String token;

    @JsonProperty("name")
    private String user_name;

    @JsonProperty("email")
    private String email;

    @JsonProperty("role")
    private String role;
}
