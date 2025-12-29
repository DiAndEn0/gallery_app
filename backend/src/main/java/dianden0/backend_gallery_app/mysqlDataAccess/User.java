package dianden0.backend_gallery_app.mysqlDataAccess;

import jakarta.persistence.*;

@Entity

public class User {
    @Id
//    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private String email;
    private String name;
    private String password;



    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }


}
