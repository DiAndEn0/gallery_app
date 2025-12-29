package dianden0.backend_gallery_app.mysqlDataAccess;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCrypt;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;


@Controller
@RequestMapping(path ="/auth", method = {RequestMethod.GET, RequestMethod.POST})
public class MainController {
    @Autowired
    private UserRepository userRepository;
    private final PasswordEncoder passwordEncoder = new BCryptPasswordEncoder(16);

    @PostMapping(path="/register")
    public @ResponseBody String addNewUser (@RequestParam String name
    , @RequestParam String email, @RequestParam String password)
    {
        String encodedPassword = passwordEncoder.encode(password);
        User newUser = new User();
        newUser.setName(name);
        newUser.setEmail(email);
        newUser.setPassword(encodedPassword);
        userRepository.save(newUser);
        return "Saved";
    }


    @PostMapping(path="/login")
    public @ResponseBody String loginUser(@RequestParam String email, @RequestParam String password)
    {
        if (userRepository.existsByEmail(email)){
            User user = userRepository.findUserByEmail(email);
            return passwordEncoder.matches(password, user.getPassword())  ? "Login Successful" : "Login Unsuccessful";
        } else return "No such email";
    }

    @GetMapping(path="/all")
    public @ResponseBody Iterable<User> getAllUsers(){
        return userRepository.findAll();
    }


}
