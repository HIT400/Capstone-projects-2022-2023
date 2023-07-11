package com.example.capstone.controller;

import com.example.capstone.model.UserDetails;
import com.example.capstone.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequiredArgsConstructor
@RequestMapping("user")
@CrossOrigin(origins = "*")
public class UserController {
    private final UserService userService;

    //save users
    @PostMapping("save")
    public ResponseEntity<UserDetails> saveUser(@RequestBody UserDetails user){
        return new ResponseEntity<>(userService.saveUser(user), HttpStatus.CREATED);
    }

    //LOGIN
    @PostMapping("/authenticate")
    @ResponseStatus(HttpStatus.OK)
    public String authenticate(@RequestParam String email, @RequestParam String password) {
        return userService.authenticate(email, password);
    }

    @GetMapping("/login/{email}/{password}")
    public Optional<UserDetails> login(@PathVariable String email, String password) throws Exception {
        UserDetails email1 = userService.login(email,password);
        System.out.println(email1);
        return Optional.ofNullable(email1);
    }

    //get user by id
    @GetMapping("get-by-id/{id}")
    public ResponseEntity<Optional<UserDetails>> findbyId(@PathVariable("id") String userId){
        return new ResponseEntity<>(userService.findById(userId),HttpStatus.FOUND);
    }

    //get all users
    @GetMapping("all-users")
    public ResponseEntity<List<UserDetails>> allUsers(){
        return new ResponseEntity<>(userService.listAllUsers(),HttpStatus.OK);
    }

    //delete
    @DeleteMapping("delete-by-id")
    public ResponseEntity<String> deleteById(@PathVariable String id){
        return new ResponseEntity<>(userService.deleteById(id),HttpStatus.OK);
    }
}

