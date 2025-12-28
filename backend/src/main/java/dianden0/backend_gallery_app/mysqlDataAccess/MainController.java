package dianden0.backend_gallery_app.mysqlDataAccess;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping(path ="/demo")
public class MainController {
    @Autowired
    private UserRepository userRepository;

    @PostMapping(path="/add")
    public @ResponseBody String addNewUser (@RequestParam String name
    , @RequestParam String email)
    {
        User newUser = new User();
        newUser.setName(name);
        newUser.setEmail(email);
        userRepository.save(newUser);
        return "Saved";
    }

    @GetMapping(path="/all")
    public @ResponseBody Iterable<User> getAllUsers(){
        return userRepository.findAll();
    }

}
